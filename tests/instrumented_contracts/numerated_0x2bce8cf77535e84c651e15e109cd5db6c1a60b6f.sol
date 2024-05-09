1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
68 
69 
70 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev These functions deal with verification of Merkle Tree proofs.
76  *
77  * The proofs can be generated using the JavaScript library
78  * https://github.com/miguelmota/merkletreejs[merkletreejs].
79  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
80  *
81  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
82  *
83  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
84  * hashing, or use a hash function other than keccak256 for hashing leaves.
85  * This is because the concatenation of a sorted pair of internal nodes in
86  * the merkle tree could be reinterpreted as a leaf value.
87  */
88 library MerkleProof {
89     /**
90      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
91      * defined by `root`. For this, a `proof` must be provided, containing
92      * sibling hashes on the branch from the leaf to the root of the tree. Each
93      * pair of leaves and each pair of pre-images are assumed to be sorted.
94      */
95     function verify(
96         bytes32[] memory proof,
97         bytes32 root,
98         bytes32 leaf
99     ) internal pure returns (bool) {
100         return processProof(proof, leaf) == root;
101     }
102 
103     /**
104      * @dev Calldata version of {verify}
105      *
106      * _Available since v4.7._
107      */
108     function verifyCalldata(
109         bytes32[] calldata proof,
110         bytes32 root,
111         bytes32 leaf
112     ) internal pure returns (bool) {
113         return processProofCalldata(proof, leaf) == root;
114     }
115 
116     /**
117      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
118      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
119      * hash matches the root of the tree. When processing the proof, the pairs
120      * of leafs & pre-images are assumed to be sorted.
121      *
122      * _Available since v4.4._
123      */
124     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
125         bytes32 computedHash = leaf;
126         for (uint256 i = 0; i < proof.length; i++) {
127             computedHash = _hashPair(computedHash, proof[i]);
128         }
129         return computedHash;
130     }
131 
132     /**
133      * @dev Calldata version of {processProof}
134      *
135      * _Available since v4.7._
136      */
137     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
138         bytes32 computedHash = leaf;
139         for (uint256 i = 0; i < proof.length; i++) {
140             computedHash = _hashPair(computedHash, proof[i]);
141         }
142         return computedHash;
143     }
144 
145     /**
146      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
147      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
148      *
149      * _Available since v4.7._
150      */
151     function multiProofVerify(
152         bytes32[] memory proof,
153         bool[] memory proofFlags,
154         bytes32 root,
155         bytes32[] memory leaves
156     ) internal pure returns (bool) {
157         return processMultiProof(proof, proofFlags, leaves) == root;
158     }
159 
160     /**
161      * @dev Calldata version of {multiProofVerify}
162      *
163      * _Available since v4.7._
164      */
165     function multiProofVerifyCalldata(
166         bytes32[] calldata proof,
167         bool[] calldata proofFlags,
168         bytes32 root,
169         bytes32[] memory leaves
170     ) internal pure returns (bool) {
171         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
172     }
173 
174     /**
175      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
176      * consuming from one or the other at each step according to the instructions given by
177      * `proofFlags`.
178      *
179      * _Available since v4.7._
180      */
181     function processMultiProof(
182         bytes32[] memory proof,
183         bool[] memory proofFlags,
184         bytes32[] memory leaves
185     ) internal pure returns (bytes32 merkleRoot) {
186         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
187         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
188         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
189         // the merkle tree.
190         uint256 leavesLen = leaves.length;
191         uint256 totalHashes = proofFlags.length;
192 
193         // Check proof validity.
194         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
195 
196         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
197         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
198         bytes32[] memory hashes = new bytes32[](totalHashes);
199         uint256 leafPos = 0;
200         uint256 hashPos = 0;
201         uint256 proofPos = 0;
202         // At each step, we compute the next hash using two values:
203         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
204         //   get the next hash.
205         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
206         //   `proof` array.
207         for (uint256 i = 0; i < totalHashes; i++) {
208             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
209             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
210             hashes[i] = _hashPair(a, b);
211         }
212 
213         if (totalHashes > 0) {
214             return hashes[totalHashes - 1];
215         } else if (leavesLen > 0) {
216             return leaves[0];
217         } else {
218             return proof[0];
219         }
220     }
221 
222     /**
223      * @dev Calldata version of {processMultiProof}
224      *
225      * _Available since v4.7._
226      */
227     function processMultiProofCalldata(
228         bytes32[] calldata proof,
229         bool[] calldata proofFlags,
230         bytes32[] memory leaves
231     ) internal pure returns (bytes32 merkleRoot) {
232         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
233         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
234         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
235         // the merkle tree.
236         uint256 leavesLen = leaves.length;
237         uint256 totalHashes = proofFlags.length;
238 
239         // Check proof validity.
240         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
241 
242         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
243         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
244         bytes32[] memory hashes = new bytes32[](totalHashes);
245         uint256 leafPos = 0;
246         uint256 hashPos = 0;
247         uint256 proofPos = 0;
248         // At each step, we compute the next hash using two values:
249         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
250         //   get the next hash.
251         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
252         //   `proof` array.
253         for (uint256 i = 0; i < totalHashes; i++) {
254             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
255             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
256             hashes[i] = _hashPair(a, b);
257         }
258 
259         if (totalHashes > 0) {
260             return hashes[totalHashes - 1];
261         } else if (leavesLen > 0) {
262             return leaves[0];
263         } else {
264             return proof[0];
265         }
266     }
267 
268     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
269         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
270     }
271 
272     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
273         /// @solidity memory-safe-assembly
274         assembly {
275             mstore(0x00, a)
276             mstore(0x20, b)
277             value := keccak256(0x00, 0x40)
278         }
279     }
280 }
281 
282 // File: @openzeppelin/contracts/utils/Strings.sol
283 
284 
285 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
286 
287 pragma solidity ^0.8.0;
288 
289 /**
290  * @dev String operations.
291  */
292 library Strings {
293     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
294     uint8 private constant _ADDRESS_LENGTH = 20;
295 
296     /**
297      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
298      */
299     function toString(uint256 value) internal pure returns (string memory) {
300         // Inspired by OraclizeAPI's implementation - MIT licence
301         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
302 
303         if (value == 0) {
304             return "0";
305         }
306         uint256 temp = value;
307         uint256 digits;
308         while (temp != 0) {
309             digits++;
310             temp /= 10;
311         }
312         bytes memory buffer = new bytes(digits);
313         while (value != 0) {
314             digits -= 1;
315             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
316             value /= 10;
317         }
318         return string(buffer);
319     }
320 
321     /**
322      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
323      */
324     function toHexString(uint256 value) internal pure returns (string memory) {
325         if (value == 0) {
326             return "0x00";
327         }
328         uint256 temp = value;
329         uint256 length = 0;
330         while (temp != 0) {
331             length++;
332             temp >>= 8;
333         }
334         return toHexString(value, length);
335     }
336 
337     /**
338      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
339      */
340     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
341         bytes memory buffer = new bytes(2 * length + 2);
342         buffer[0] = "0";
343         buffer[1] = "x";
344         for (uint256 i = 2 * length + 1; i > 1; --i) {
345             buffer[i] = _HEX_SYMBOLS[value & 0xf];
346             value >>= 4;
347         }
348         require(value == 0, "Strings: hex length insufficient");
349         return string(buffer);
350     }
351 
352     /**
353      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
354      */
355     function toHexString(address addr) internal pure returns (string memory) {
356         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
357     }
358 }
359 
360 // File: @openzeppelin/contracts/utils/Context.sol
361 
362 
363 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
364 
365 pragma solidity ^0.8.0;
366 
367 /**
368  * @dev Provides information about the current execution context, including the
369  * sender of the transaction and its data. While these are generally available
370  * via msg.sender and msg.data, they should not be accessed in such a direct
371  * manner, since when dealing with meta-transactions the account sending and
372  * paying for execution may not be the actual sender (as far as an application
373  * is concerned).
374  *
375  * This contract is only required for intermediate, library-like contracts.
376  */
377 abstract contract Context {
378     function _msgSender() internal view virtual returns (address) {
379         return msg.sender;
380     }
381 
382     function _msgData() internal view virtual returns (bytes calldata) {
383         return msg.data;
384     }
385 }
386 
387 // File: @openzeppelin/contracts/access/Ownable.sol
388 
389 
390 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
391 
392 pragma solidity ^0.8.0;
393 
394 
395 /**
396  * @dev Contract module which provides a basic access control mechanism, where
397  * there is an account (an owner) that can be granted exclusive access to
398  * specific functions.
399  *
400  * By default, the owner account will be the one that deploys the contract. This
401  * can later be changed with {transferOwnership}.
402  *
403  * This module is used through inheritance. It will make available the modifier
404  * `onlyOwner`, which can be applied to your functions to restrict their use to
405  * the owner.
406  */
407 abstract contract Ownable is Context {
408     address private _owner;
409 
410     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
411 
412     /**
413      * @dev Initializes the contract setting the deployer as the initial owner.
414      */
415     constructor() {
416         _transferOwnership(_msgSender());
417     }
418 
419     /**
420      * @dev Throws if called by any account other than the owner.
421      */
422     modifier onlyOwner() {
423         _checkOwner();
424         _;
425     }
426 
427     /**
428      * @dev Returns the address of the current owner.
429      */
430     function owner() public view virtual returns (address) {
431         return _owner;
432     }
433 
434     /**
435      * @dev Throws if the sender is not the owner.
436      */
437     function _checkOwner() internal view virtual {
438         require(owner() == _msgSender(), "Ownable: caller is not the owner");
439     }
440 
441     /**
442      * @dev Leaves the contract without owner. It will not be possible to call
443      * `onlyOwner` functions anymore. Can only be called by the current owner.
444      *
445      * NOTE: Renouncing ownership will leave the contract without an owner,
446      * thereby removing any functionality that is only available to the owner.
447      */
448     function renounceOwnership() public virtual onlyOwner {
449         _transferOwnership(address(0));
450     }
451 
452     /**
453      * @dev Transfers ownership of the contract to a new account (`newOwner`).
454      * Can only be called by the current owner.
455      */
456     function transferOwnership(address newOwner) public virtual onlyOwner {
457         require(newOwner != address(0), "Ownable: new owner is the zero address");
458         _transferOwnership(newOwner);
459     }
460 
461     /**
462      * @dev Transfers ownership of the contract to a new account (`newOwner`).
463      * Internal function without access restriction.
464      */
465     function _transferOwnership(address newOwner) internal virtual {
466         address oldOwner = _owner;
467         _owner = newOwner;
468         emit OwnershipTransferred(oldOwner, newOwner);
469     }
470 }
471 
472 // File: @openzeppelin/contracts/utils/Address.sol
473 
474 
475 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
476 
477 pragma solidity ^0.8.1;
478 
479 /**
480  * @dev Collection of functions related to the address type
481  */
482 library Address {
483     /**
484      * @dev Returns true if `account` is a contract.
485      *
486      * [IMPORTANT]
487      * ====
488      * It is unsafe to assume that an address for which this function returns
489      * false is an externally-owned account (EOA) and not a contract.
490      *
491      * Among others, `isContract` will return false for the following
492      * types of addresses:
493      *
494      *  - an externally-owned account
495      *  - a contract in construction
496      *  - an address where a contract will be created
497      *  - an address where a contract lived, but was destroyed
498      * ====
499      *
500      * [IMPORTANT]
501      * ====
502      * You shouldn't rely on `isContract` to protect against flash loan attacks!
503      *
504      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
505      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
506      * constructor.
507      * ====
508      */
509     function isContract(address account) internal view returns (bool) {
510         // This method relies on extcodesize/address.code.length, which returns 0
511         // for contracts in construction, since the code is only stored at the end
512         // of the constructor execution.
513 
514         return account.code.length > 0;
515     }
516 
517     /**
518      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
519      * `recipient`, forwarding all available gas and reverting on errors.
520      *
521      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
522      * of certain opcodes, possibly making contracts go over the 2300 gas limit
523      * imposed by `transfer`, making them unable to receive funds via
524      * `transfer`. {sendValue} removes this limitation.
525      *
526      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
527      *
528      * IMPORTANT: because control is transferred to `recipient`, care must be
529      * taken to not create reentrancy vulnerabilities. Consider using
530      * {ReentrancyGuard} or the
531      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
532      */
533     function sendValue(address payable recipient, uint256 amount) internal {
534         require(address(this).balance >= amount, "Address: insufficient balance");
535 
536         (bool success, ) = recipient.call{value: amount}("");
537         require(success, "Address: unable to send value, recipient may have reverted");
538     }
539 
540     /**
541      * @dev Performs a Solidity function call using a low level `call`. A
542      * plain `call` is an unsafe replacement for a function call: use this
543      * function instead.
544      *
545      * If `target` reverts with a revert reason, it is bubbled up by this
546      * function (like regular Solidity function calls).
547      *
548      * Returns the raw returned data. To convert to the expected return value,
549      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
550      *
551      * Requirements:
552      *
553      * - `target` must be a contract.
554      * - calling `target` with `data` must not revert.
555      *
556      * _Available since v3.1._
557      */
558     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
559         return functionCall(target, data, "Address: low-level call failed");
560     }
561 
562     /**
563      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
564      * `errorMessage` as a fallback revert reason when `target` reverts.
565      *
566      * _Available since v3.1._
567      */
568     function functionCall(
569         address target,
570         bytes memory data,
571         string memory errorMessage
572     ) internal returns (bytes memory) {
573         return functionCallWithValue(target, data, 0, errorMessage);
574     }
575 
576     /**
577      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
578      * but also transferring `value` wei to `target`.
579      *
580      * Requirements:
581      *
582      * - the calling contract must have an ETH balance of at least `value`.
583      * - the called Solidity function must be `payable`.
584      *
585      * _Available since v3.1._
586      */
587     function functionCallWithValue(
588         address target,
589         bytes memory data,
590         uint256 value
591     ) internal returns (bytes memory) {
592         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
593     }
594 
595     /**
596      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
597      * with `errorMessage` as a fallback revert reason when `target` reverts.
598      *
599      * _Available since v3.1._
600      */
601     function functionCallWithValue(
602         address target,
603         bytes memory data,
604         uint256 value,
605         string memory errorMessage
606     ) internal returns (bytes memory) {
607         require(address(this).balance >= value, "Address: insufficient balance for call");
608         require(isContract(target), "Address: call to non-contract");
609 
610         (bool success, bytes memory returndata) = target.call{value: value}(data);
611         return verifyCallResult(success, returndata, errorMessage);
612     }
613 
614     /**
615      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
616      * but performing a static call.
617      *
618      * _Available since v3.3._
619      */
620     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
621         return functionStaticCall(target, data, "Address: low-level static call failed");
622     }
623 
624     /**
625      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
626      * but performing a static call.
627      *
628      * _Available since v3.3._
629      */
630     function functionStaticCall(
631         address target,
632         bytes memory data,
633         string memory errorMessage
634     ) internal view returns (bytes memory) {
635         require(isContract(target), "Address: static call to non-contract");
636 
637         (bool success, bytes memory returndata) = target.staticcall(data);
638         return verifyCallResult(success, returndata, errorMessage);
639     }
640 
641     /**
642      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
643      * but performing a delegate call.
644      *
645      * _Available since v3.4._
646      */
647     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
648         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
649     }
650 
651     /**
652      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
653      * but performing a delegate call.
654      *
655      * _Available since v3.4._
656      */
657     function functionDelegateCall(
658         address target,
659         bytes memory data,
660         string memory errorMessage
661     ) internal returns (bytes memory) {
662         require(isContract(target), "Address: delegate call to non-contract");
663 
664         (bool success, bytes memory returndata) = target.delegatecall(data);
665         return verifyCallResult(success, returndata, errorMessage);
666     }
667 
668     /**
669      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
670      * revert reason using the provided one.
671      *
672      * _Available since v4.3._
673      */
674     function verifyCallResult(
675         bool success,
676         bytes memory returndata,
677         string memory errorMessage
678     ) internal pure returns (bytes memory) {
679         if (success) {
680             return returndata;
681         } else {
682             // Look for revert reason and bubble it up if present
683             if (returndata.length > 0) {
684                 // The easiest way to bubble the revert reason is using memory via assembly
685                 /// @solidity memory-safe-assembly
686                 assembly {
687                     let returndata_size := mload(returndata)
688                     revert(add(32, returndata), returndata_size)
689                 }
690             } else {
691                 revert(errorMessage);
692             }
693         }
694     }
695 }
696 
697 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
698 
699 
700 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
701 
702 pragma solidity ^0.8.0;
703 
704 /**
705  * @title ERC721 token receiver interface
706  * @dev Interface for any contract that wants to support safeTransfers
707  * from ERC721 asset contracts.
708  */
709 interface IERC721Receiver {
710     /**
711      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
712      * by `operator` from `from`, this function is called.
713      *
714      * It must return its Solidity selector to confirm the token transfer.
715      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
716      *
717      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
718      */
719     function onERC721Received(
720         address operator,
721         address from,
722         uint256 tokenId,
723         bytes calldata data
724     ) external returns (bytes4);
725 }
726 
727 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
728 
729 
730 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
731 
732 pragma solidity ^0.8.0;
733 
734 /**
735  * @dev Interface of the ERC165 standard, as defined in the
736  * https://eips.ethereum.org/EIPS/eip-165[EIP].
737  *
738  * Implementers can declare support of contract interfaces, which can then be
739  * queried by others ({ERC165Checker}).
740  *
741  * For an implementation, see {ERC165}.
742  */
743 interface IERC165 {
744     /**
745      * @dev Returns true if this contract implements the interface defined by
746      * `interfaceId`. See the corresponding
747      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
748      * to learn more about how these ids are created.
749      *
750      * This function call must use less than 30 000 gas.
751      */
752     function supportsInterface(bytes4 interfaceId) external view returns (bool);
753 }
754 
755 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
756 
757 
758 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
759 
760 pragma solidity ^0.8.0;
761 
762 
763 /**
764  * @dev Implementation of the {IERC165} interface.
765  *
766  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
767  * for the additional interface id that will be supported. For example:
768  *
769  * ```solidity
770  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
771  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
772  * }
773  * ```
774  *
775  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
776  */
777 abstract contract ERC165 is IERC165 {
778     /**
779      * @dev See {IERC165-supportsInterface}.
780      */
781     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
782         return interfaceId == type(IERC165).interfaceId;
783     }
784 }
785 
786 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
787 
788 
789 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
790 
791 pragma solidity ^0.8.0;
792 
793 
794 /**
795  * @dev Required interface of an ERC721 compliant contract.
796  */
797 interface IERC721 is IERC165 {
798     /**
799      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
800      */
801     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
802 
803     /**
804      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
805      */
806     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
807 
808     /**
809      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
810      */
811     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
812 
813     /**
814      * @dev Returns the number of tokens in ``owner``'s account.
815      */
816     function balanceOf(address owner) external view returns (uint256 balance);
817 
818     /**
819      * @dev Returns the owner of the `tokenId` token.
820      *
821      * Requirements:
822      *
823      * - `tokenId` must exist.
824      */
825     function ownerOf(uint256 tokenId) external view returns (address owner);
826 
827     /**
828      * @dev Safely transfers `tokenId` token from `from` to `to`.
829      *
830      * Requirements:
831      *
832      * - `from` cannot be the zero address.
833      * - `to` cannot be the zero address.
834      * - `tokenId` token must exist and be owned by `from`.
835      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
836      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
837      *
838      * Emits a {Transfer} event.
839      */
840     function safeTransferFrom(
841         address from,
842         address to,
843         uint256 tokenId,
844         bytes calldata data
845     ) external;
846 
847     /**
848      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
849      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
850      *
851      * Requirements:
852      *
853      * - `from` cannot be the zero address.
854      * - `to` cannot be the zero address.
855      * - `tokenId` token must exist and be owned by `from`.
856      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
857      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
858      *
859      * Emits a {Transfer} event.
860      */
861     function safeTransferFrom(
862         address from,
863         address to,
864         uint256 tokenId
865     ) external;
866 
867     /**
868      * @dev Transfers `tokenId` token from `from` to `to`.
869      *
870      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
871      *
872      * Requirements:
873      *
874      * - `from` cannot be the zero address.
875      * - `to` cannot be the zero address.
876      * - `tokenId` token must be owned by `from`.
877      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
878      *
879      * Emits a {Transfer} event.
880      */
881     function transferFrom(
882         address from,
883         address to,
884         uint256 tokenId
885     ) external;
886 
887     /**
888      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
889      * The approval is cleared when the token is transferred.
890      *
891      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
892      *
893      * Requirements:
894      *
895      * - The caller must own the token or be an approved operator.
896      * - `tokenId` must exist.
897      *
898      * Emits an {Approval} event.
899      */
900     function approve(address to, uint256 tokenId) external;
901 
902     /**
903      * @dev Approve or remove `operator` as an operator for the caller.
904      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
905      *
906      * Requirements:
907      *
908      * - The `operator` cannot be the caller.
909      *
910      * Emits an {ApprovalForAll} event.
911      */
912     function setApprovalForAll(address operator, bool _approved) external;
913 
914     /**
915      * @dev Returns the account approved for `tokenId` token.
916      *
917      * Requirements:
918      *
919      * - `tokenId` must exist.
920      */
921     function getApproved(uint256 tokenId) external view returns (address operator);
922 
923     /**
924      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
925      *
926      * See {setApprovalForAll}
927      */
928     function isApprovedForAll(address owner, address operator) external view returns (bool);
929 }
930 
931 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
932 
933 
934 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
935 
936 pragma solidity ^0.8.0;
937 
938 
939 /**
940  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
941  * @dev See https://eips.ethereum.org/EIPS/eip-721
942  */
943 interface IERC721Enumerable is IERC721 {
944     /**
945      * @dev Returns the total amount of tokens stored by the contract.
946      */
947     function totalSupply() external view returns (uint256);
948 
949     /**
950      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
951      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
952      */
953     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
954 
955     /**
956      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
957      * Use along with {totalSupply} to enumerate all tokens.
958      */
959     function tokenByIndex(uint256 index) external view returns (uint256);
960 }
961 
962 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
963 
964 
965 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
966 
967 pragma solidity ^0.8.0;
968 
969 
970 /**
971  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
972  * @dev See https://eips.ethereum.org/EIPS/eip-721
973  */
974 interface IERC721Metadata is IERC721 {
975     /**
976      * @dev Returns the token collection name.
977      */
978     function name() external view returns (string memory);
979 
980     /**
981      * @dev Returns the token collection symbol.
982      */
983     function symbol() external view returns (string memory);
984 
985     /**
986      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
987      */
988     function tokenURI(uint256 tokenId) external view returns (string memory);
989 }
990 
991 // File: erc721a/contracts/ERC721A.sol
992 
993 
994 // Creator: Chiru Labs
995 
996 pragma solidity ^0.8.4;
997 
998 
999 
1000 
1001 
1002 
1003 
1004 
1005 
1006 error ApprovalCallerNotOwnerNorApproved();
1007 error ApprovalQueryForNonexistentToken();
1008 error ApproveToCaller();
1009 error ApprovalToCurrentOwner();
1010 error BalanceQueryForZeroAddress();
1011 error MintedQueryForZeroAddress();
1012 error BurnedQueryForZeroAddress();
1013 error AuxQueryForZeroAddress();
1014 error MintToZeroAddress();
1015 error MintZeroQuantity();
1016 error OwnerIndexOutOfBounds();
1017 error OwnerQueryForNonexistentToken();
1018 error TokenIndexOutOfBounds();
1019 error TransferCallerNotOwnerNorApproved();
1020 error TransferFromIncorrectOwner();
1021 error TransferToNonERC721ReceiverImplementer();
1022 error TransferToZeroAddress();
1023 error URIQueryForNonexistentToken();
1024 
1025 /**
1026  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1027  * the Metadata extension. Built to optimize for lower gas during batch mints.
1028  *
1029  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1030  *
1031  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1032  *
1033  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1034  */
1035 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1036     using Address for address;
1037     using Strings for uint256;
1038 
1039     // Compiler will pack this into a single 256bit word.
1040     struct TokenOwnership {
1041         // The address of the owner.
1042         address addr;
1043         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1044         uint64 startTimestamp;
1045         // Whether the token has been burned.
1046         bool burned;
1047     }
1048 
1049     // Compiler will pack this into a single 256bit word.
1050     struct AddressData {
1051         // Realistically, 2**64-1 is more than enough.
1052         uint64 balance;
1053         // Keeps track of mint count with minimal overhead for tokenomics.
1054         uint64 numberMinted;
1055         // Keeps track of burn count with minimal overhead for tokenomics.
1056         uint64 numberBurned;
1057         // For miscellaneous variable(s) pertaining to the address
1058         // (e.g. number of whitelist mint slots used).
1059         // If there are multiple variables, please pack them into a uint64.
1060         uint64 aux;
1061     }
1062 
1063     // The tokenId of the next token to be minted.
1064     uint256 internal _currentIndex;
1065 
1066     // The number of tokens burned.
1067     uint256 internal _burnCounter;
1068 
1069     // Token name
1070     string private _name;
1071 
1072     // Token symbol
1073     string private _symbol;
1074 
1075     // Mapping from token ID to ownership details
1076     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1077     mapping(uint256 => TokenOwnership) internal _ownerships;
1078 
1079     // Mapping owner address to address data
1080     mapping(address => AddressData) private _addressData;
1081 
1082     // Mapping from token ID to approved address
1083     mapping(uint256 => address) private _tokenApprovals;
1084 
1085     // Mapping from owner to operator approvals
1086     mapping(address => mapping(address => bool)) private _operatorApprovals;
1087 
1088     constructor(string memory name_, string memory symbol_) {
1089         _name = name_;
1090         _symbol = symbol_;
1091         _currentIndex = _startTokenId();
1092     }
1093 
1094     /**
1095      * To change the starting tokenId, please override this function.
1096      */
1097     function _startTokenId() internal view virtual returns (uint256) {
1098         return 0;
1099     }
1100 
1101     /**
1102      * @dev See {IERC721Enumerable-totalSupply}.
1103      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1104      */
1105     function totalSupply() public view returns (uint256) {
1106         // Counter underflow is impossible as _burnCounter cannot be incremented
1107         // more than _currentIndex - _startTokenId() times
1108         unchecked {
1109             return _currentIndex - _burnCounter - _startTokenId();
1110         }
1111     }
1112 
1113     /**
1114      * Returns the total amount of tokens minted in the contract.
1115      */
1116     function _totalMinted() internal view returns (uint256) {
1117         // Counter underflow is impossible as _currentIndex does not decrement,
1118         // and it is initialized to _startTokenId()
1119         unchecked {
1120             return _currentIndex - _startTokenId();
1121         }
1122     }
1123 
1124     /**
1125      * @dev See {IERC165-supportsInterface}.
1126      */
1127     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1128         return
1129             interfaceId == type(IERC721).interfaceId ||
1130             interfaceId == type(IERC721Metadata).interfaceId ||
1131             super.supportsInterface(interfaceId);
1132     }
1133 
1134     /**
1135      * @dev See {IERC721-balanceOf}.
1136      */
1137     function balanceOf(address owner) public view override returns (uint256) {
1138         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1139         return uint256(_addressData[owner].balance);
1140     }
1141 
1142     /**
1143      * Returns the number of tokens minted by `owner`.
1144      */
1145     function _numberMinted(address owner) internal view returns (uint256) {
1146         if (owner == address(0)) revert MintedQueryForZeroAddress();
1147         return uint256(_addressData[owner].numberMinted);
1148     }
1149 
1150     /**
1151      * Returns the number of tokens burned by or on behalf of `owner`.
1152      */
1153     function _numberBurned(address owner) internal view returns (uint256) {
1154         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1155         return uint256(_addressData[owner].numberBurned);
1156     }
1157 
1158     /**
1159      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1160      */
1161     function _getAux(address owner) internal view returns (uint64) {
1162         if (owner == address(0)) revert AuxQueryForZeroAddress();
1163         return _addressData[owner].aux;
1164     }
1165 
1166     /**
1167      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1168      * If there are multiple variables, please pack them into a uint64.
1169      */
1170     function _setAux(address owner, uint64 aux) internal {
1171         if (owner == address(0)) revert AuxQueryForZeroAddress();
1172         _addressData[owner].aux = aux;
1173     }
1174 
1175     /**
1176      * Gas spent here starts off proportional to the maximum mint batch size.
1177      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1178      */
1179     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1180         uint256 curr = tokenId;
1181 
1182         unchecked {
1183             if (_startTokenId() <= curr && curr < _currentIndex) {
1184                 TokenOwnership memory ownership = _ownerships[curr];
1185                 if (!ownership.burned) {
1186                     if (ownership.addr != address(0)) {
1187                         return ownership;
1188                     }
1189                     // Invariant:
1190                     // There will always be an ownership that has an address and is not burned
1191                     // before an ownership that does not have an address and is not burned.
1192                     // Hence, curr will not underflow.
1193                     while (true) {
1194                         curr--;
1195                         ownership = _ownerships[curr];
1196                         if (ownership.addr != address(0)) {
1197                             return ownership;
1198                         }
1199                     }
1200                 }
1201             }
1202         }
1203         revert OwnerQueryForNonexistentToken();
1204     }
1205 
1206     /**
1207      * @dev See {IERC721-ownerOf}.
1208      */
1209     function ownerOf(uint256 tokenId) public view override returns (address) {
1210         return ownershipOf(tokenId).addr;
1211     }
1212 
1213     /**
1214      * @dev See {IERC721Metadata-name}.
1215      */
1216     function name() public view virtual override returns (string memory) {
1217         return _name;
1218     }
1219 
1220     /**
1221      * @dev See {IERC721Metadata-symbol}.
1222      */
1223     function symbol() public view virtual override returns (string memory) {
1224         return _symbol;
1225     }
1226 
1227     /**
1228      * @dev See {IERC721Metadata-tokenURI}.
1229      */
1230     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1231         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1232 
1233         string memory baseURI = _baseURI();
1234         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1235     }
1236 
1237     /**
1238      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1239      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1240      * by default, can be overriden in child contracts.
1241      */
1242     function _baseURI() internal view virtual returns (string memory) {
1243         return '';
1244     }
1245 
1246     /**
1247      * @dev See {IERC721-approve}.
1248      */
1249     function approve(address to, uint256 tokenId) public override {
1250         address owner = ERC721A.ownerOf(tokenId);
1251         if (to == owner) revert ApprovalToCurrentOwner();
1252 
1253         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1254             revert ApprovalCallerNotOwnerNorApproved();
1255         }
1256 
1257         _approve(to, tokenId, owner);
1258     }
1259 
1260     /**
1261      * @dev See {IERC721-getApproved}.
1262      */
1263     function getApproved(uint256 tokenId) public view override returns (address) {
1264         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1265 
1266         return _tokenApprovals[tokenId];
1267     }
1268 
1269     /**
1270      * @dev See {IERC721-setApprovalForAll}.
1271      */
1272     function setApprovalForAll(address operator, bool approved) public override {
1273         if (operator == _msgSender()) revert ApproveToCaller();
1274 
1275         _operatorApprovals[_msgSender()][operator] = approved;
1276         emit ApprovalForAll(_msgSender(), operator, approved);
1277     }
1278 
1279     /**
1280      * @dev See {IERC721-isApprovedForAll}.
1281      */
1282     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1283         return _operatorApprovals[owner][operator];
1284     }
1285 
1286     /**
1287      * @dev See {IERC721-transferFrom}.
1288      */
1289     function transferFrom(
1290         address from,
1291         address to,
1292         uint256 tokenId
1293     ) public virtual override {
1294         _transfer(from, to, tokenId);
1295     }
1296 
1297     /**
1298      * @dev See {IERC721-safeTransferFrom}.
1299      */
1300     function safeTransferFrom(
1301         address from,
1302         address to,
1303         uint256 tokenId
1304     ) public virtual override {
1305         safeTransferFrom(from, to, tokenId, '');
1306     }
1307 
1308     /**
1309      * @dev See {IERC721-safeTransferFrom}.
1310      */
1311     function safeTransferFrom(
1312         address from,
1313         address to,
1314         uint256 tokenId,
1315         bytes memory _data
1316     ) public virtual override {
1317         _transfer(from, to, tokenId);
1318         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1319             revert TransferToNonERC721ReceiverImplementer();
1320         }
1321     }
1322 
1323     /**
1324      * @dev Returns whether `tokenId` exists.
1325      *
1326      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1327      *
1328      * Tokens start existing when they are minted (`_mint`),
1329      */
1330     function _exists(uint256 tokenId) internal view returns (bool) {
1331         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1332             !_ownerships[tokenId].burned;
1333     }
1334 
1335     function _safeMint(address to, uint256 quantity) internal {
1336         _safeMint(to, quantity, '');
1337     }
1338 
1339     /**
1340      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1341      *
1342      * Requirements:
1343      *
1344      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1345      * - `quantity` must be greater than 0.
1346      *
1347      * Emits a {Transfer} event.
1348      */
1349     function _safeMint(
1350         address to,
1351         uint256 quantity,
1352         bytes memory _data
1353     ) internal {
1354         _mint(to, quantity, _data, true);
1355     }
1356 
1357     /**
1358      * @dev Mints `quantity` tokens and transfers them to `to`.
1359      *
1360      * Requirements:
1361      *
1362      * - `to` cannot be the zero address.
1363      * - `quantity` must be greater than 0.
1364      *
1365      * Emits a {Transfer} event.
1366      */
1367     function _mint(
1368         address to,
1369         uint256 quantity,
1370         bytes memory _data,
1371         bool safe
1372     ) internal {
1373         uint256 startTokenId = _currentIndex;
1374         if (to == address(0)) revert MintToZeroAddress();
1375         if (quantity == 0) revert MintZeroQuantity();
1376 
1377         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1378 
1379         // Overflows are incredibly unrealistic.
1380         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1381         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1382         unchecked {
1383             _addressData[to].balance += uint64(quantity);
1384             _addressData[to].numberMinted += uint64(quantity);
1385 
1386             _ownerships[startTokenId].addr = to;
1387             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1388 
1389             uint256 updatedIndex = startTokenId;
1390             uint256 end = updatedIndex + quantity;
1391 
1392             if (safe && to.isContract()) {
1393                 do {
1394                     emit Transfer(address(0), to, updatedIndex);
1395                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1396                         revert TransferToNonERC721ReceiverImplementer();
1397                     }
1398                 } while (updatedIndex != end);
1399                 // Reentrancy protection
1400                 if (_currentIndex != startTokenId) revert();
1401             } else {
1402                 do {
1403                     emit Transfer(address(0), to, updatedIndex++);
1404                 } while (updatedIndex != end);
1405             }
1406             _currentIndex = updatedIndex;
1407         }
1408         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1409     }
1410 
1411     /**
1412      * @dev Transfers `tokenId` from `from` to `to`.
1413      *
1414      * Requirements:
1415      *
1416      * - `to` cannot be the zero address.
1417      * - `tokenId` token must be owned by `from`.
1418      *
1419      * Emits a {Transfer} event.
1420      */
1421     function _transfer(
1422         address from,
1423         address to,
1424         uint256 tokenId
1425     ) private {
1426         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1427 
1428         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1429             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1430             getApproved(tokenId) == _msgSender());
1431 
1432         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1433         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1434         if (to == address(0)) revert TransferToZeroAddress();
1435 
1436         _beforeTokenTransfers(from, to, tokenId, 1);
1437 
1438         // Clear approvals from the previous owner
1439         _approve(address(0), tokenId, prevOwnership.addr);
1440 
1441         // Underflow of the sender's balance is impossible because we check for
1442         // ownership above and the recipient's balance can't realistically overflow.
1443         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1444         unchecked {
1445             _addressData[from].balance -= 1;
1446             _addressData[to].balance += 1;
1447 
1448             _ownerships[tokenId].addr = to;
1449             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1450 
1451             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1452             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1453             uint256 nextTokenId = tokenId + 1;
1454             if (_ownerships[nextTokenId].addr == address(0)) {
1455                 // This will suffice for checking _exists(nextTokenId),
1456                 // as a burned slot cannot contain the zero address.
1457                 if (nextTokenId < _currentIndex) {
1458                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1459                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1460                 }
1461             }
1462         }
1463 
1464         emit Transfer(from, to, tokenId);
1465         _afterTokenTransfers(from, to, tokenId, 1);
1466     }
1467 
1468     /**
1469      * @dev Destroys `tokenId`.
1470      * The approval is cleared when the token is burned.
1471      *
1472      * Requirements:
1473      *
1474      * - `tokenId` must exist.
1475      *
1476      * Emits a {Transfer} event.
1477      */
1478     function _burn(uint256 tokenId) internal virtual {
1479         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1480 
1481         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1482 
1483         // Clear approvals from the previous owner
1484         _approve(address(0), tokenId, prevOwnership.addr);
1485 
1486         // Underflow of the sender's balance is impossible because we check for
1487         // ownership above and the recipient's balance can't realistically overflow.
1488         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1489         unchecked {
1490             _addressData[prevOwnership.addr].balance -= 1;
1491             _addressData[prevOwnership.addr].numberBurned += 1;
1492 
1493             // Keep track of who burned the token, and the timestamp of burning.
1494             _ownerships[tokenId].addr = prevOwnership.addr;
1495             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1496             _ownerships[tokenId].burned = true;
1497 
1498             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1499             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1500             uint256 nextTokenId = tokenId + 1;
1501             if (_ownerships[nextTokenId].addr == address(0)) {
1502                 // This will suffice for checking _exists(nextTokenId),
1503                 // as a burned slot cannot contain the zero address.
1504                 if (nextTokenId < _currentIndex) {
1505                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1506                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1507                 }
1508             }
1509         }
1510 
1511         emit Transfer(prevOwnership.addr, address(0), tokenId);
1512         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1513 
1514         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1515         unchecked {
1516             _burnCounter++;
1517         }
1518     }
1519 
1520     /**
1521      * @dev Approve `to` to operate on `tokenId`
1522      *
1523      * Emits a {Approval} event.
1524      */
1525     function _approve(
1526         address to,
1527         uint256 tokenId,
1528         address owner
1529     ) private {
1530         _tokenApprovals[tokenId] = to;
1531         emit Approval(owner, to, tokenId);
1532     }
1533 
1534     /**
1535      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1536      *
1537      * @param from address representing the previous owner of the given token ID
1538      * @param to target address that will receive the tokens
1539      * @param tokenId uint256 ID of the token to be transferred
1540      * @param _data bytes optional data to send along with the call
1541      * @return bool whether the call correctly returned the expected magic value
1542      */
1543     function _checkContractOnERC721Received(
1544         address from,
1545         address to,
1546         uint256 tokenId,
1547         bytes memory _data
1548     ) private returns (bool) {
1549         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1550             return retval == IERC721Receiver(to).onERC721Received.selector;
1551         } catch (bytes memory reason) {
1552             if (reason.length == 0) {
1553                 revert TransferToNonERC721ReceiverImplementer();
1554             } else {
1555                 assembly {
1556                     revert(add(32, reason), mload(reason))
1557                 }
1558             }
1559         }
1560     }
1561 
1562     /**
1563      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1564      * And also called before burning one token.
1565      *
1566      * startTokenId - the first token id to be transferred
1567      * quantity - the amount to be transferred
1568      *
1569      * Calling conditions:
1570      *
1571      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1572      * transferred to `to`.
1573      * - When `from` is zero, `tokenId` will be minted for `to`.
1574      * - When `to` is zero, `tokenId` will be burned by `from`.
1575      * - `from` and `to` are never both zero.
1576      */
1577     function _beforeTokenTransfers(
1578         address from,
1579         address to,
1580         uint256 startTokenId,
1581         uint256 quantity
1582     ) internal virtual {}
1583 
1584     /**
1585      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1586      * minting.
1587      * And also called after one token has been burned.
1588      *
1589      * startTokenId - the first token id to be transferred
1590      * quantity - the amount to be transferred
1591      *
1592      * Calling conditions:
1593      *
1594      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1595      * transferred to `to`.
1596      * - When `from` is zero, `tokenId` has been minted for `to`.
1597      * - When `to` is zero, `tokenId` has been burned by `from`.
1598      * - `from` and `to` are never both zero.
1599      */
1600     function _afterTokenTransfers(
1601         address from,
1602         address to,
1603         uint256 startTokenId,
1604         uint256 quantity
1605     ) internal virtual {}
1606 }
1607 
1608 // File: contracts/AryanDemons.sol
1609 
1610 
1611 
1612 pragma solidity >=0.8.9 <0.9.0;
1613 
1614 
1615 
1616 
1617 
1618 contract AryanverseDemons is ERC721A, Ownable, ReentrancyGuard {
1619 
1620   using Strings for uint256;
1621 
1622   bytes32 public merkleRoot;
1623   mapping(address => bool) public whitelistClaimed;
1624 
1625   string public uriPrefix = '';
1626   string public uriSuffix = '.json';
1627   string public hiddenMetadataUri;
1628   
1629   uint256 public cost = 0.01 ether;
1630   uint256 public maxSupply = 7777;
1631   uint256 public maxMintAmountPerTx = 20;
1632 
1633   bool public paused = true;
1634   bool public whitelistMintEnabled = false;
1635   bool public revealed = false;
1636 
1637   constructor(
1638     string memory _tokenName,
1639     string memory _tokenSymbol,
1640     uint256 _cost,
1641     uint256 _maxSupply,
1642     uint256 _maxMintAmountPerTx,
1643     string memory _hiddenMetadataUri
1644   ) ERC721A(_tokenName, _tokenSymbol) {
1645     setCost(_cost);
1646     maxSupply = _maxSupply;
1647     setMaxMintAmountPerTx(_maxMintAmountPerTx);
1648     setHiddenMetadataUri(_hiddenMetadataUri);
1649   }
1650 
1651   modifier mintCompliance(uint256 _mintAmount) {
1652     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
1653     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1654     _;
1655   }
1656 
1657   modifier mintPriceCompliance(uint256 _mintAmount) {
1658     require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1659     _;
1660   }
1661 
1662   function whitelistMint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1663     // Verify whitelist requirements
1664     require(whitelistMintEnabled, 'The whitelist sale is not enabled!');
1665     require(!whitelistClaimed[_msgSender()], 'Address already claimed!');
1666     bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
1667     require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), 'Invalid proof!');
1668 
1669     whitelistClaimed[_msgSender()] = true;
1670     _safeMint(_msgSender(), _mintAmount);
1671   }
1672 
1673   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1674     require(!paused, 'The contract is paused!');
1675 
1676     _safeMint(_msgSender(), _mintAmount);
1677   }
1678   
1679   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1680     _safeMint(_receiver, _mintAmount);
1681   }
1682 
1683   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1684     uint256 ownerTokenCount = balanceOf(_owner);
1685     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1686     uint256 currentTokenId = _startTokenId();
1687     uint256 ownedTokenIndex = 0;
1688     address latestOwnerAddress;
1689 
1690     while (ownedTokenIndex < ownerTokenCount && currentTokenId < _currentIndex) {
1691       TokenOwnership memory ownership = _ownerships[currentTokenId];
1692 
1693       if (!ownership.burned) {
1694         if (ownership.addr != address(0)) {
1695           latestOwnerAddress = ownership.addr;
1696         }
1697 
1698         if (latestOwnerAddress == _owner) {
1699           ownedTokenIds[ownedTokenIndex] = currentTokenId;
1700 
1701           ownedTokenIndex++;
1702         }
1703       }
1704 
1705       currentTokenId++;
1706     }
1707 
1708     return ownedTokenIds;
1709   }
1710 
1711   function _startTokenId() internal view virtual override returns (uint256) {
1712     return 1;
1713   }
1714 
1715   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1716     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1717 
1718     if (revealed == false) {
1719       return hiddenMetadataUri;
1720     }
1721 
1722     string memory currentBaseURI = _baseURI();
1723     return bytes(currentBaseURI).length > 0
1724         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1725         : '';
1726   }
1727 
1728   function setRevealed(bool _state) public onlyOwner {
1729     revealed = _state;
1730   }
1731 
1732   function setCost(uint256 _cost) public onlyOwner {
1733     cost = _cost;
1734   }
1735 
1736   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1737     maxMintAmountPerTx = _maxMintAmountPerTx;
1738   }
1739 
1740   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1741     hiddenMetadataUri = _hiddenMetadataUri;
1742   }
1743 
1744   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1745     uriPrefix = _uriPrefix;
1746   }
1747 
1748   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1749     uriSuffix = _uriSuffix;
1750   }
1751 
1752   function setPaused(bool _state) public onlyOwner {
1753     paused = _state;
1754   }
1755 
1756   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1757     merkleRoot = _merkleRoot;
1758   }
1759 
1760   function setWhitelistMintEnabled(bool _state) public onlyOwner {
1761     whitelistMintEnabled = _state;
1762   }
1763 
1764   function withdraw() public onlyOwner nonReentrant {
1765     // This will transfer the remaining contract balance to the owner.
1766     // Do not remove this otherwise you will not be able to withdraw the funds.
1767     // =============================================================================
1768     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1769     require(os);
1770     // =============================================================================
1771   }
1772 
1773   function _baseURI() internal view virtual override returns (string memory) {
1774     return uriPrefix;
1775   }
1776 }