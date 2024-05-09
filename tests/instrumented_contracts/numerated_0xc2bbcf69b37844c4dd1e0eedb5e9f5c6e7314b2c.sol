1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
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
216 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
217 
218 
219 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
220 
221 pragma solidity ^0.8.0;
222 
223 /**
224  * @dev Contract module that helps prevent reentrant calls to a function.
225  *
226  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
227  * available, which can be applied to functions to make sure there are no nested
228  * (reentrant) calls to them.
229  *
230  * Note that because there is a single `nonReentrant` guard, functions marked as
231  * `nonReentrant` may not call one another. This can be worked around by making
232  * those functions `private`, and then adding `external` `nonReentrant` entry
233  * points to them.
234  *
235  * TIP: If you would like to learn more about reentrancy and alternative ways
236  * to protect against it, check out our blog post
237  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
238  */
239 abstract contract ReentrancyGuard {
240     // Booleans are more expensive than uint256 or any type that takes up a full
241     // word because each write operation emits an extra SLOAD to first read the
242     // slot's contents, replace the bits taken up by the boolean, and then write
243     // back. This is the compiler's defense against contract upgrades and
244     // pointer aliasing, and it cannot be disabled.
245 
246     // The values being non-zero value makes deployment a bit more expensive,
247     // but in exchange the refund on every call to nonReentrant will be lower in
248     // amount. Since refunds are capped to a percentage of the total
249     // transaction's gas, it is best to keep them low in cases like this one, to
250     // increase the likelihood of the full refund coming into effect.
251     uint256 private constant _NOT_ENTERED = 1;
252     uint256 private constant _ENTERED = 2;
253 
254     uint256 private _status;
255 
256     constructor() {
257         _status = _NOT_ENTERED;
258     }
259 
260     /**
261      * @dev Prevents a contract from calling itself, directly or indirectly.
262      * Calling a `nonReentrant` function from another `nonReentrant`
263      * function is not supported. It is possible to prevent this from happening
264      * by making the `nonReentrant` function external, and making it call a
265      * `private` function that does the actual work.
266      */
267     modifier nonReentrant() {
268         // On the first call to nonReentrant, _notEntered will be true
269         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
270 
271         // Any calls to nonReentrant after this point will fail
272         _status = _ENTERED;
273 
274         _;
275 
276         // By storing the original value once again, a refund is triggered (see
277         // https://eips.ethereum.org/EIPS/eip-2200)
278         _status = _NOT_ENTERED;
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
387 // File: @openzeppelin/contracts/security/Pausable.sol
388 
389 
390 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
391 
392 pragma solidity ^0.8.0;
393 
394 
395 /**
396  * @dev Contract module which allows children to implement an emergency stop
397  * mechanism that can be triggered by an authorized account.
398  *
399  * This module is used through inheritance. It will make available the
400  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
401  * the functions of your contract. Note that they will not be pausable by
402  * simply including this module, only once the modifiers are put in place.
403  */
404 abstract contract Pausable is Context {
405     /**
406      * @dev Emitted when the pause is triggered by `account`.
407      */
408     event Paused(address account);
409 
410     /**
411      * @dev Emitted when the pause is lifted by `account`.
412      */
413     event Unpaused(address account);
414 
415     bool private _paused;
416 
417     /**
418      * @dev Initializes the contract in unpaused state.
419      */
420     constructor() {
421         _paused = false;
422     }
423 
424     /**
425      * @dev Modifier to make a function callable only when the contract is not paused.
426      *
427      * Requirements:
428      *
429      * - The contract must not be paused.
430      */
431     modifier whenNotPaused() {
432         _requireNotPaused();
433         _;
434     }
435 
436     /**
437      * @dev Modifier to make a function callable only when the contract is paused.
438      *
439      * Requirements:
440      *
441      * - The contract must be paused.
442      */
443     modifier whenPaused() {
444         _requirePaused();
445         _;
446     }
447 
448     /**
449      * @dev Returns true if the contract is paused, and false otherwise.
450      */
451     function paused() public view virtual returns (bool) {
452         return _paused;
453     }
454 
455     /**
456      * @dev Throws if the contract is paused.
457      */
458     function _requireNotPaused() internal view virtual {
459         require(!paused(), "Pausable: paused");
460     }
461 
462     /**
463      * @dev Throws if the contract is not paused.
464      */
465     function _requirePaused() internal view virtual {
466         require(paused(), "Pausable: not paused");
467     }
468 
469     /**
470      * @dev Triggers stopped state.
471      *
472      * Requirements:
473      *
474      * - The contract must not be paused.
475      */
476     function _pause() internal virtual whenNotPaused {
477         _paused = true;
478         emit Paused(_msgSender());
479     }
480 
481     /**
482      * @dev Returns to normal state.
483      *
484      * Requirements:
485      *
486      * - The contract must be paused.
487      */
488     function _unpause() internal virtual whenPaused {
489         _paused = false;
490         emit Unpaused(_msgSender());
491     }
492 }
493 
494 // File: @openzeppelin/contracts/access/Ownable.sol
495 
496 
497 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
498 
499 pragma solidity ^0.8.0;
500 
501 
502 /**
503  * @dev Contract module which provides a basic access control mechanism, where
504  * there is an account (an owner) that can be granted exclusive access to
505  * specific functions.
506  *
507  * By default, the owner account will be the one that deploys the contract. This
508  * can later be changed with {transferOwnership}.
509  *
510  * This module is used through inheritance. It will make available the modifier
511  * `onlyOwner`, which can be applied to your functions to restrict their use to
512  * the owner.
513  */
514 abstract contract Ownable is Context {
515     address private _owner;
516 
517     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
518 
519     /**
520      * @dev Initializes the contract setting the deployer as the initial owner.
521      */
522     constructor() {
523         _transferOwnership(_msgSender());
524     }
525 
526     /**
527      * @dev Throws if called by any account other than the owner.
528      */
529     modifier onlyOwner() {
530         _checkOwner();
531         _;
532     }
533 
534     /**
535      * @dev Returns the address of the current owner.
536      */
537     function owner() public view virtual returns (address) {
538         return _owner;
539     }
540 
541     /**
542      * @dev Throws if the sender is not the owner.
543      */
544     function _checkOwner() internal view virtual {
545         require(owner() == _msgSender(), "Ownable: caller is not the owner");
546     }
547 
548     /**
549      * @dev Leaves the contract without owner. It will not be possible to call
550      * `onlyOwner` functions anymore. Can only be called by the current owner.
551      *
552      * NOTE: Renouncing ownership will leave the contract without an owner,
553      * thereby removing any functionality that is only available to the owner.
554      */
555     function renounceOwnership() public virtual onlyOwner {
556         _transferOwnership(address(0));
557     }
558 
559     /**
560      * @dev Transfers ownership of the contract to a new account (`newOwner`).
561      * Can only be called by the current owner.
562      */
563     function transferOwnership(address newOwner) public virtual onlyOwner {
564         require(newOwner != address(0), "Ownable: new owner is the zero address");
565         _transferOwnership(newOwner);
566     }
567 
568     /**
569      * @dev Transfers ownership of the contract to a new account (`newOwner`).
570      * Internal function without access restriction.
571      */
572     function _transferOwnership(address newOwner) internal virtual {
573         address oldOwner = _owner;
574         _owner = newOwner;
575         emit OwnershipTransferred(oldOwner, newOwner);
576     }
577 }
578 
579 // File: @openzeppelin/contracts/utils/Address.sol
580 
581 
582 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
583 
584 pragma solidity ^0.8.1;
585 
586 /**
587  * @dev Collection of functions related to the address type
588  */
589 library Address {
590     /**
591      * @dev Returns true if `account` is a contract.
592      *
593      * [IMPORTANT]
594      * ====
595      * It is unsafe to assume that an address for which this function returns
596      * false is an externally-owned account (EOA) and not a contract.
597      *
598      * Among others, `isContract` will return false for the following
599      * types of addresses:
600      *
601      *  - an externally-owned account
602      *  - a contract in construction
603      *  - an address where a contract will be created
604      *  - an address where a contract lived, but was destroyed
605      * ====
606      *
607      * [IMPORTANT]
608      * ====
609      * You shouldn't rely on `isContract` to protect against flash loan attacks!
610      *
611      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
612      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
613      * constructor.
614      * ====
615      */
616     function isContract(address account) internal view returns (bool) {
617         // This method relies on extcodesize/address.code.length, which returns 0
618         // for contracts in construction, since the code is only stored at the end
619         // of the constructor execution.
620 
621         return account.code.length > 0;
622     }
623 
624     /**
625      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
626      * `recipient`, forwarding all available gas and reverting on errors.
627      *
628      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
629      * of certain opcodes, possibly making contracts go over the 2300 gas limit
630      * imposed by `transfer`, making them unable to receive funds via
631      * `transfer`. {sendValue} removes this limitation.
632      *
633      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
634      *
635      * IMPORTANT: because control is transferred to `recipient`, care must be
636      * taken to not create reentrancy vulnerabilities. Consider using
637      * {ReentrancyGuard} or the
638      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
639      */
640     function sendValue(address payable recipient, uint256 amount) internal {
641         require(address(this).balance >= amount, "Address: insufficient balance");
642 
643         (bool success, ) = recipient.call{value: amount}("");
644         require(success, "Address: unable to send value, recipient may have reverted");
645     }
646 
647     /**
648      * @dev Performs a Solidity function call using a low level `call`. A
649      * plain `call` is an unsafe replacement for a function call: use this
650      * function instead.
651      *
652      * If `target` reverts with a revert reason, it is bubbled up by this
653      * function (like regular Solidity function calls).
654      *
655      * Returns the raw returned data. To convert to the expected return value,
656      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
657      *
658      * Requirements:
659      *
660      * - `target` must be a contract.
661      * - calling `target` with `data` must not revert.
662      *
663      * _Available since v3.1._
664      */
665     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
666         return functionCall(target, data, "Address: low-level call failed");
667     }
668 
669     /**
670      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
671      * `errorMessage` as a fallback revert reason when `target` reverts.
672      *
673      * _Available since v3.1._
674      */
675     function functionCall(
676         address target,
677         bytes memory data,
678         string memory errorMessage
679     ) internal returns (bytes memory) {
680         return functionCallWithValue(target, data, 0, errorMessage);
681     }
682 
683     /**
684      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
685      * but also transferring `value` wei to `target`.
686      *
687      * Requirements:
688      *
689      * - the calling contract must have an ETH balance of at least `value`.
690      * - the called Solidity function must be `payable`.
691      *
692      * _Available since v3.1._
693      */
694     function functionCallWithValue(
695         address target,
696         bytes memory data,
697         uint256 value
698     ) internal returns (bytes memory) {
699         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
700     }
701 
702     /**
703      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
704      * with `errorMessage` as a fallback revert reason when `target` reverts.
705      *
706      * _Available since v3.1._
707      */
708     function functionCallWithValue(
709         address target,
710         bytes memory data,
711         uint256 value,
712         string memory errorMessage
713     ) internal returns (bytes memory) {
714         require(address(this).balance >= value, "Address: insufficient balance for call");
715         require(isContract(target), "Address: call to non-contract");
716 
717         (bool success, bytes memory returndata) = target.call{value: value}(data);
718         return verifyCallResult(success, returndata, errorMessage);
719     }
720 
721     /**
722      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
723      * but performing a static call.
724      *
725      * _Available since v3.3._
726      */
727     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
728         return functionStaticCall(target, data, "Address: low-level static call failed");
729     }
730 
731     /**
732      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
733      * but performing a static call.
734      *
735      * _Available since v3.3._
736      */
737     function functionStaticCall(
738         address target,
739         bytes memory data,
740         string memory errorMessage
741     ) internal view returns (bytes memory) {
742         require(isContract(target), "Address: static call to non-contract");
743 
744         (bool success, bytes memory returndata) = target.staticcall(data);
745         return verifyCallResult(success, returndata, errorMessage);
746     }
747 
748     /**
749      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
750      * but performing a delegate call.
751      *
752      * _Available since v3.4._
753      */
754     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
755         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
756     }
757 
758     /**
759      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
760      * but performing a delegate call.
761      *
762      * _Available since v3.4._
763      */
764     function functionDelegateCall(
765         address target,
766         bytes memory data,
767         string memory errorMessage
768     ) internal returns (bytes memory) {
769         require(isContract(target), "Address: delegate call to non-contract");
770 
771         (bool success, bytes memory returndata) = target.delegatecall(data);
772         return verifyCallResult(success, returndata, errorMessage);
773     }
774 
775     /**
776      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
777      * revert reason using the provided one.
778      *
779      * _Available since v4.3._
780      */
781     function verifyCallResult(
782         bool success,
783         bytes memory returndata,
784         string memory errorMessage
785     ) internal pure returns (bytes memory) {
786         if (success) {
787             return returndata;
788         } else {
789             // Look for revert reason and bubble it up if present
790             if (returndata.length > 0) {
791                 // The easiest way to bubble the revert reason is using memory via assembly
792                 /// @solidity memory-safe-assembly
793                 assembly {
794                     let returndata_size := mload(returndata)
795                     revert(add(32, returndata), returndata_size)
796                 }
797             } else {
798                 revert(errorMessage);
799             }
800         }
801     }
802 }
803 
804 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
805 
806 
807 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
808 
809 pragma solidity ^0.8.0;
810 
811 /**
812  * @title ERC721 token receiver interface
813  * @dev Interface for any contract that wants to support safeTransfers
814  * from ERC721 asset contracts.
815  */
816 interface IERC721Receiver {
817     /**
818      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
819      * by `operator` from `from`, this function is called.
820      *
821      * It must return its Solidity selector to confirm the token transfer.
822      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
823      *
824      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
825      */
826     function onERC721Received(
827         address operator,
828         address from,
829         uint256 tokenId,
830         bytes calldata data
831     ) external returns (bytes4);
832 }
833 
834 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
835 
836 
837 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
838 
839 pragma solidity ^0.8.0;
840 
841 /**
842  * @dev Interface of the ERC165 standard, as defined in the
843  * https://eips.ethereum.org/EIPS/eip-165[EIP].
844  *
845  * Implementers can declare support of contract interfaces, which can then be
846  * queried by others ({ERC165Checker}).
847  *
848  * For an implementation, see {ERC165}.
849  */
850 interface IERC165 {
851     /**
852      * @dev Returns true if this contract implements the interface defined by
853      * `interfaceId`. See the corresponding
854      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
855      * to learn more about how these ids are created.
856      *
857      * This function call must use less than 30 000 gas.
858      */
859     function supportsInterface(bytes4 interfaceId) external view returns (bool);
860 }
861 
862 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
863 
864 
865 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
866 
867 pragma solidity ^0.8.0;
868 
869 
870 /**
871  * @dev Interface for the NFT Royalty Standard.
872  *
873  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
874  * support for royalty payments across all NFT marketplaces and ecosystem participants.
875  *
876  * _Available since v4.5._
877  */
878 interface IERC2981 is IERC165 {
879     /**
880      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
881      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
882      */
883     function royaltyInfo(uint256 tokenId, uint256 salePrice)
884         external
885         view
886         returns (address receiver, uint256 royaltyAmount);
887 }
888 
889 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
890 
891 
892 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
893 
894 pragma solidity ^0.8.0;
895 
896 
897 /**
898  * @dev Implementation of the {IERC165} interface.
899  *
900  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
901  * for the additional interface id that will be supported. For example:
902  *
903  * ```solidity
904  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
905  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
906  * }
907  * ```
908  *
909  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
910  */
911 abstract contract ERC165 is IERC165 {
912     /**
913      * @dev See {IERC165-supportsInterface}.
914      */
915     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
916         return interfaceId == type(IERC165).interfaceId;
917     }
918 }
919 
920 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
921 
922 
923 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
924 
925 pragma solidity ^0.8.0;
926 
927 
928 /**
929  * @dev Required interface of an ERC721 compliant contract.
930  */
931 interface IERC721 is IERC165 {
932     /**
933      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
934      */
935     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
936 
937     /**
938      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
939      */
940     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
941 
942     /**
943      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
944      */
945     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
946 
947     /**
948      * @dev Returns the number of tokens in ``owner``'s account.
949      */
950     function balanceOf(address owner) external view returns (uint256 balance);
951 
952     /**
953      * @dev Returns the owner of the `tokenId` token.
954      *
955      * Requirements:
956      *
957      * - `tokenId` must exist.
958      */
959     function ownerOf(uint256 tokenId) external view returns (address owner);
960 
961     /**
962      * @dev Safely transfers `tokenId` token from `from` to `to`.
963      *
964      * Requirements:
965      *
966      * - `from` cannot be the zero address.
967      * - `to` cannot be the zero address.
968      * - `tokenId` token must exist and be owned by `from`.
969      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
970      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
971      *
972      * Emits a {Transfer} event.
973      */
974     function safeTransferFrom(
975         address from,
976         address to,
977         uint256 tokenId,
978         bytes calldata data
979     ) external;
980 
981     /**
982      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
983      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
984      *
985      * Requirements:
986      *
987      * - `from` cannot be the zero address.
988      * - `to` cannot be the zero address.
989      * - `tokenId` token must exist and be owned by `from`.
990      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
991      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
992      *
993      * Emits a {Transfer} event.
994      */
995     function safeTransferFrom(
996         address from,
997         address to,
998         uint256 tokenId
999     ) external;
1000 
1001     /**
1002      * @dev Transfers `tokenId` token from `from` to `to`.
1003      *
1004      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1005      *
1006      * Requirements:
1007      *
1008      * - `from` cannot be the zero address.
1009      * - `to` cannot be the zero address.
1010      * - `tokenId` token must be owned by `from`.
1011      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1012      *
1013      * Emits a {Transfer} event.
1014      */
1015     function transferFrom(
1016         address from,
1017         address to,
1018         uint256 tokenId
1019     ) external;
1020 
1021     /**
1022      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1023      * The approval is cleared when the token is transferred.
1024      *
1025      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1026      *
1027      * Requirements:
1028      *
1029      * - The caller must own the token or be an approved operator.
1030      * - `tokenId` must exist.
1031      *
1032      * Emits an {Approval} event.
1033      */
1034     function approve(address to, uint256 tokenId) external;
1035 
1036     /**
1037      * @dev Approve or remove `operator` as an operator for the caller.
1038      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1039      *
1040      * Requirements:
1041      *
1042      * - The `operator` cannot be the caller.
1043      *
1044      * Emits an {ApprovalForAll} event.
1045      */
1046     function setApprovalForAll(address operator, bool _approved) external;
1047 
1048     /**
1049      * @dev Returns the account approved for `tokenId` token.
1050      *
1051      * Requirements:
1052      *
1053      * - `tokenId` must exist.
1054      */
1055     function getApproved(uint256 tokenId) external view returns (address operator);
1056 
1057     /**
1058      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1059      *
1060      * See {setApprovalForAll}
1061      */
1062     function isApprovedForAll(address owner, address operator) external view returns (bool);
1063 }
1064 
1065 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1066 
1067 
1068 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1069 
1070 pragma solidity ^0.8.0;
1071 
1072 
1073 /**
1074  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1075  * @dev See https://eips.ethereum.org/EIPS/eip-721
1076  */
1077 interface IERC721Enumerable is IERC721 {
1078     /**
1079      * @dev Returns the total amount of tokens stored by the contract.
1080      */
1081     function totalSupply() external view returns (uint256);
1082 
1083     /**
1084      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1085      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1086      */
1087     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1088 
1089     /**
1090      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1091      * Use along with {totalSupply} to enumerate all tokens.
1092      */
1093     function tokenByIndex(uint256 index) external view returns (uint256);
1094 }
1095 
1096 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1097 
1098 
1099 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1100 
1101 pragma solidity ^0.8.0;
1102 
1103 
1104 /**
1105  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1106  * @dev See https://eips.ethereum.org/EIPS/eip-721
1107  */
1108 interface IERC721Metadata is IERC721 {
1109     /**
1110      * @dev Returns the token collection name.
1111      */
1112     function name() external view returns (string memory);
1113 
1114     /**
1115      * @dev Returns the token collection symbol.
1116      */
1117     function symbol() external view returns (string memory);
1118 
1119     /**
1120      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1121      */
1122     function tokenURI(uint256 tokenId) external view returns (string memory);
1123 }
1124 
1125 // File: ERC721A.sol
1126 
1127 
1128 // Creator: Chiru Labs
1129 
1130 pragma solidity ^0.8.4;
1131 
1132 
1133 
1134 
1135 
1136 
1137 
1138 
1139 
1140 error ApprovalCallerNotOwnerNorApproved();
1141 error ApprovalQueryForNonexistentToken();
1142 error ApproveToCaller();
1143 error ApprovalToCurrentOwner();
1144 error BalanceQueryForZeroAddress();
1145 error MintedQueryForZeroAddress();
1146 error BurnedQueryForZeroAddress();
1147 error AuxQueryForZeroAddress();
1148 error MintToZeroAddress();
1149 error MintZeroQuantity();
1150 error OwnerQueryForNonexistentToken();
1151 error TransferCallerNotOwnerNorApproved();
1152 error TransferFromIncorrectOwner();
1153 error TransferToNonERC721ReceiverImplementer();
1154 error TransferToZeroAddress();
1155 error URIQueryForNonexistentToken();
1156 
1157 /**
1158  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1159  * the Metadata extension. Built to optimize for lower gas during batch mints.
1160  *
1161  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1162  *
1163  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1164  *
1165  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1166  */
1167 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1168     using Address for address;
1169     using Strings for uint256;
1170 
1171     // Compiler will pack this into a single 256bit word.
1172     struct TokenOwnership {
1173         // The address of the owner.
1174         address addr;
1175         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1176         uint64 startTimestamp;
1177         // Whether the token has been burned.
1178         bool burned;
1179     }
1180 
1181     // Compiler will pack this into a single 256bit word.
1182     struct AddressData {
1183         // Realistically, 2**64-1 is more than enough.
1184         uint64 balance;
1185         // Keeps track of mint count with minimal overhead for tokenomics.
1186         uint64 numberMinted;
1187         // Keeps track of burn count with minimal overhead for tokenomics.
1188         uint64 numberBurned;
1189         // For miscellaneous variable(s) pertaining to the address
1190         // (e.g. number of whitelist mint slots used).
1191         // If there are multiple variables, please pack them into a uint64.
1192         uint64 aux;
1193     }
1194 
1195     // The tokenId of the next token to be minted.
1196     uint256 internal _currentIndex;
1197 
1198     // The number of tokens burned.
1199     uint256 internal _burnCounter;
1200 
1201     // Token name
1202     string private _name;
1203 
1204     // Token symbol
1205     string private _symbol;
1206 
1207     // Mapping from token ID to ownership details
1208     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1209     mapping(uint256 => TokenOwnership) internal _ownerships;
1210 
1211     // Mapping owner address to address data
1212     mapping(address => AddressData) private _addressData;
1213 
1214     // Mapping from token ID to approved address
1215     mapping(uint256 => address) private _tokenApprovals;
1216 
1217     // Mapping from owner to operator approvals
1218     mapping(address => mapping(address => bool)) private _operatorApprovals;
1219 
1220     constructor(string memory name_, string memory symbol_) {
1221         _name = name_;
1222         _symbol = symbol_;
1223         _currentIndex = _startTokenId();
1224     }
1225 
1226     /**
1227      * To change the starting tokenId, please override this function.
1228      */
1229     function _startTokenId() internal view virtual returns (uint256) {
1230         return 0;
1231     }
1232 
1233     /**
1234      * @dev See {IERC721Enumerable-totalSupply}.
1235      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1236      */
1237     function totalSupply() public view returns (uint256) {
1238         // Counter underflow is impossible as _burnCounter cannot be incremented
1239         // more than _currentIndex - _startTokenId() times
1240         unchecked {
1241             return _currentIndex - _burnCounter - _startTokenId();
1242         }
1243     }
1244 
1245     /**
1246      * Returns the total amount of tokens minted in the contract.
1247      */
1248     function _totalMinted() internal view returns (uint256) {
1249         // Counter underflow is impossible as _currentIndex does not decrement,
1250         // and it is initialized to _startTokenId()
1251         unchecked {
1252             return _currentIndex - _startTokenId();
1253         }
1254     }
1255 
1256     /**
1257      * @dev See {IERC165-supportsInterface}.
1258      */
1259     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1260         return
1261             interfaceId == type(IERC721).interfaceId ||
1262             interfaceId == type(IERC721Metadata).interfaceId ||
1263             super.supportsInterface(interfaceId);
1264     }
1265 
1266     /**
1267      * @dev See {IERC721-balanceOf}.
1268      */
1269     function balanceOf(address owner) public view override returns (uint256) {
1270         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1271         return uint256(_addressData[owner].balance);
1272     }
1273 
1274     /**
1275      * Returns the number of tokens minted by `owner`.
1276      */
1277     function _numberMinted(address owner) internal view returns (uint256) {
1278         if (owner == address(0)) revert MintedQueryForZeroAddress();
1279         return uint256(_addressData[owner].numberMinted);
1280     }
1281 
1282     /**
1283      * Returns the number of tokens burned by or on behalf of `owner`.
1284      */
1285     function _numberBurned(address owner) internal view returns (uint256) {
1286         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1287         return uint256(_addressData[owner].numberBurned);
1288     }
1289 
1290     /**
1291      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1292      */
1293     function _getAux(address owner) internal view returns (uint64) {
1294         if (owner == address(0)) revert AuxQueryForZeroAddress();
1295         return _addressData[owner].aux;
1296     }
1297 
1298     /**
1299      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1300      * If there are multiple variables, please pack them into a uint64.
1301      */
1302     function _setAux(address owner, uint64 aux) internal {
1303         if (owner == address(0)) revert AuxQueryForZeroAddress();
1304         _addressData[owner].aux = aux;
1305     }
1306 
1307     /**
1308      * Gas spent here starts off proportional to the maximum mint batch size.
1309      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1310      */
1311     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1312         uint256 curr = tokenId;
1313 
1314         unchecked {
1315             if (_startTokenId() <= curr && curr < _currentIndex) {
1316                 TokenOwnership memory ownership = _ownerships[curr];
1317                 if (!ownership.burned) {
1318                     if (ownership.addr != address(0)) {
1319                         return ownership;
1320                     }
1321                     // Invariant:
1322                     // There will always be an ownership that has an address and is not burned
1323                     // before an ownership that does not have an address and is not burned.
1324                     // Hence, curr will not underflow.
1325                     while (true) {
1326                         curr--;
1327                         ownership = _ownerships[curr];
1328                         if (ownership.addr != address(0)) {
1329                             return ownership;
1330                         }
1331                     }
1332                 }
1333             }
1334         }
1335         revert OwnerQueryForNonexistentToken();
1336     }
1337 
1338     /**
1339      * @dev See {IERC721-ownerOf}.
1340      */
1341     function ownerOf(uint256 tokenId) public view override returns (address) {
1342         return _ownershipOf(tokenId).addr;
1343     }
1344 
1345     /**
1346      * @dev See {IERC721Metadata-name}.
1347      */
1348     function name() public view virtual override returns (string memory) {
1349         return _name;
1350     }
1351 
1352     /**
1353      * @dev See {IERC721Metadata-symbol}.
1354      */
1355     function symbol() public view virtual override returns (string memory) {
1356         return _symbol;
1357     }
1358 
1359     /**
1360      * @dev See {IERC721Metadata-tokenURI}.
1361      */
1362     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1363         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1364 
1365         string memory baseURI = _baseURI();
1366         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1367     }
1368 
1369     /**
1370      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1371      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1372      * by default, can be overriden in child contracts.
1373      */
1374     function _baseURI() internal view virtual returns (string memory) {
1375         return '';
1376     }
1377 
1378     /**
1379      * @dev See {IERC721-approve}.
1380      */
1381     function approve(address to, uint256 tokenId) public override {
1382         address owner = ERC721A.ownerOf(tokenId);
1383         if (to == owner) revert ApprovalToCurrentOwner();
1384 
1385         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1386             revert ApprovalCallerNotOwnerNorApproved();
1387         }
1388 
1389         _approve(to, tokenId, owner);
1390     }
1391 
1392     /**
1393      * @dev See {IERC721-getApproved}.
1394      */
1395     function getApproved(uint256 tokenId) public view override returns (address) {
1396         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1397 
1398         return _tokenApprovals[tokenId];
1399     }
1400 
1401     /**
1402      * @dev See {IERC721-setApprovalForAll}.
1403      */
1404     function setApprovalForAll(address operator, bool approved) public virtual override {
1405         if (operator == _msgSender()) revert ApproveToCaller();
1406 
1407         _operatorApprovals[_msgSender()][operator] = approved;
1408         emit ApprovalForAll(_msgSender(), operator, approved);
1409     }
1410 
1411     /**
1412      * @dev See {IERC721-isApprovedForAll}.
1413      */
1414     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1415         return _operatorApprovals[owner][operator];
1416     }
1417 
1418     /**
1419      * @dev See {IERC721-transferFrom}.
1420      */
1421     function transferFrom(
1422         address from,
1423         address to,
1424         uint256 tokenId
1425     ) public virtual override {
1426         _transfer(from, to, tokenId);
1427     }
1428 
1429     /**
1430      * @dev See {IERC721-safeTransferFrom}.
1431      */
1432     function safeTransferFrom(
1433         address from,
1434         address to,
1435         uint256 tokenId
1436     ) public virtual override {
1437         safeTransferFrom(from, to, tokenId, '');
1438     }
1439 
1440     /**
1441      * @dev See {IERC721-safeTransferFrom}.
1442      */
1443     function safeTransferFrom(
1444         address from,
1445         address to,
1446         uint256 tokenId,
1447         bytes memory _data
1448     ) public virtual override {
1449         _transfer(from, to, tokenId);
1450         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1451             revert TransferToNonERC721ReceiverImplementer();
1452         }
1453     }
1454 
1455     /**
1456      * @dev Returns whether `tokenId` exists.
1457      *
1458      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1459      *
1460      * Tokens start existing when they are minted (`_mint`),
1461      */
1462     function _exists(uint256 tokenId) internal view returns (bool) {
1463         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1464             !_ownerships[tokenId].burned;
1465     }
1466 
1467     function _safeMint(address to, uint256 quantity) internal {
1468         _safeMint(to, quantity, '');
1469     }
1470 
1471     /**
1472      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1473      *
1474      * Requirements:
1475      *
1476      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1477      * - `quantity` must be greater than 0.
1478      *
1479      * Emits a {Transfer} event.
1480      */
1481     function _safeMint(
1482         address to,
1483         uint256 quantity,
1484         bytes memory _data
1485     ) internal {
1486         _mint(to, quantity, _data, true);
1487     }
1488 
1489     /**
1490      * @dev Mints `quantity` tokens and transfers them to `to`.
1491      *
1492      * Requirements:
1493      *
1494      * - `to` cannot be the zero address.
1495      * - `quantity` must be greater than 0.
1496      *
1497      * Emits a {Transfer} event.
1498      */
1499     function _mint(
1500         address to,
1501         uint256 quantity,
1502         bytes memory _data,
1503         bool safe
1504     ) internal {
1505         uint256 startTokenId = _currentIndex;
1506         if (to == address(0)) revert MintToZeroAddress();
1507         if (quantity == 0) revert MintZeroQuantity();
1508 
1509         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1510 
1511         // Overflows are incredibly unrealistic.
1512         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1513         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1514         unchecked {
1515             _addressData[to].balance += uint64(quantity);
1516             _addressData[to].numberMinted += uint64(quantity);
1517 
1518             _ownerships[startTokenId].addr = to;
1519             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1520 
1521             uint256 updatedIndex = startTokenId;
1522             uint256 end = updatedIndex + quantity;
1523 
1524             if (safe && to.isContract()) {
1525                 do {
1526                     emit Transfer(address(0), to, updatedIndex);
1527                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1528                         revert TransferToNonERC721ReceiverImplementer();
1529                     }
1530                 } while (updatedIndex != end);
1531                 // Reentrancy protection
1532                 if (_currentIndex != startTokenId) revert();
1533             } else {
1534                 do {
1535                     emit Transfer(address(0), to, updatedIndex++);
1536                 } while (updatedIndex != end);
1537             }
1538             _currentIndex = updatedIndex;
1539         }
1540         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1541     }
1542 
1543     /**
1544      * @dev Transfers `tokenId` from `from` to `to`.
1545      *
1546      * Requirements:
1547      *
1548      * - `to` cannot be the zero address.
1549      * - `tokenId` token must be owned by `from`.
1550      *
1551      * Emits a {Transfer} event.
1552      */
1553     function _transfer(
1554         address from,
1555         address to,
1556         uint256 tokenId
1557     ) private {
1558         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1559 
1560         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1561             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1562             getApproved(tokenId) == _msgSender());
1563 
1564         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1565         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1566         if (to == address(0)) revert TransferToZeroAddress();
1567 
1568         _beforeTokenTransfers(from, to, tokenId, 1);
1569 
1570         // Clear approvals from the previous owner
1571         _approve(address(0), tokenId, prevOwnership.addr);
1572 
1573         // Underflow of the sender's balance is impossible because we check for
1574         // ownership above and the recipient's balance can't realistically overflow.
1575         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1576         unchecked {
1577             _addressData[from].balance -= 1;
1578             _addressData[to].balance += 1;
1579 
1580             _ownerships[tokenId].addr = to;
1581             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1582 
1583             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1584             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1585             uint256 nextTokenId = tokenId + 1;
1586             if (_ownerships[nextTokenId].addr == address(0)) {
1587                 // This will suffice for checking _exists(nextTokenId),
1588                 // as a burned slot cannot contain the zero address.
1589                 if (nextTokenId < _currentIndex) {
1590                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1591                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1592                 }
1593             }
1594         }
1595 
1596         emit Transfer(from, to, tokenId);
1597         _afterTokenTransfers(from, to, tokenId, 1);
1598     }
1599 
1600     /**
1601      * @dev Destroys `tokenId`.
1602      * The approval is cleared when the token is burned.
1603      *
1604      * Requirements:
1605      *
1606      * - `tokenId` must exist.
1607      *
1608      * Emits a {Transfer} event.
1609      */
1610     function _burn(uint256 tokenId) internal virtual {
1611         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1612 
1613         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1614 
1615         // Clear approvals from the previous owner
1616         _approve(address(0), tokenId, prevOwnership.addr);
1617 
1618         // Underflow of the sender's balance is impossible because we check for
1619         // ownership above and the recipient's balance can't realistically overflow.
1620         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1621         unchecked {
1622             _addressData[prevOwnership.addr].balance -= 1;
1623             _addressData[prevOwnership.addr].numberBurned += 1;
1624 
1625             // Keep track of who burned the token, and the timestamp of burning.
1626             _ownerships[tokenId].addr = prevOwnership.addr;
1627             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1628             _ownerships[tokenId].burned = true;
1629 
1630             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1631             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1632             uint256 nextTokenId = tokenId + 1;
1633             if (_ownerships[nextTokenId].addr == address(0)) {
1634                 // This will suffice for checking _exists(nextTokenId),
1635                 // as a burned slot cannot contain the zero address.
1636                 if (nextTokenId < _currentIndex) {
1637                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1638                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1639                 }
1640             }
1641         }
1642 
1643         emit Transfer(prevOwnership.addr, address(0), tokenId);
1644         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1645 
1646         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1647         unchecked {
1648             _burnCounter++;
1649         }
1650     }
1651 
1652     /**
1653      * @dev Approve `to` to operate on `tokenId`
1654      *
1655      * Emits a {Approval} event.
1656      */
1657     function _approve(
1658         address to,
1659         uint256 tokenId,
1660         address owner
1661     ) private {
1662         _tokenApprovals[tokenId] = to;
1663         emit Approval(owner, to, tokenId);
1664     }
1665 
1666     /**
1667      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1668      *
1669      * @param from address representing the previous owner of the given token ID
1670      * @param to target address that will receive the tokens
1671      * @param tokenId uint256 ID of the token to be transferred
1672      * @param _data bytes optional data to send along with the call
1673      * @return bool whether the call correctly returned the expected magic value
1674      */
1675     function _checkContractOnERC721Received(
1676         address from,
1677         address to,
1678         uint256 tokenId,
1679         bytes memory _data
1680     ) private returns (bool) {
1681         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1682             return retval == IERC721Receiver(to).onERC721Received.selector;
1683         } catch (bytes memory reason) {
1684             if (reason.length == 0) {
1685                 revert TransferToNonERC721ReceiverImplementer();
1686             } else {
1687                 assembly {
1688                     revert(add(32, reason), mload(reason))
1689                 }
1690             }
1691         }
1692     }
1693 
1694     /**
1695      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1696      * And also called before burning one token.
1697      *
1698      * startTokenId - the first token id to be transferred
1699      * quantity - the amount to be transferred
1700      *
1701      * Calling conditions:
1702      *
1703      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1704      * transferred to `to`.
1705      * - When `from` is zero, `tokenId` will be minted for `to`.
1706      * - When `to` is zero, `tokenId` will be burned by `from`.
1707      * - `from` and `to` are never both zero.
1708      */
1709     function _beforeTokenTransfers(
1710         address from,
1711         address to,
1712         uint256 startTokenId,
1713         uint256 quantity
1714     ) internal virtual {}
1715 
1716     /**
1717      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1718      * minting.
1719      * And also called after one token has been burned.
1720      *
1721      * startTokenId - the first token id to be transferred
1722      * quantity - the amount to be transferred
1723      *
1724      * Calling conditions:
1725      *
1726      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1727      * transferred to `to`.
1728      * - When `from` is zero, `tokenId` has been minted for `to`.
1729      * - When `to` is zero, `tokenId` has been burned by `from`.
1730      * - `from` and `to` are never both zero.
1731      */
1732     function _afterTokenTransfers(
1733         address from,
1734         address to,
1735         uint256 startTokenId,
1736         uint256 quantity
1737     ) internal virtual {}
1738 }
1739 // File: magusnft (2).sol
1740 
1741 
1742 
1743 pragma solidity ^0.8.12;
1744 
1745 
1746 
1747 
1748 
1749 
1750 
1751 
1752 contract TheMagus is
1753     ERC721A,
1754     IERC2981,
1755     Ownable,
1756     Pausable,
1757     ReentrancyGuard
1758 {
1759     using Strings for uint256;
1760 
1761     string public contractURIstr = "ipfs://QmTyHfKzG1Xyopag7DZVnckT3ed6hKFrSkUu8e6iDf5DAN/";
1762     string public baseExtension = ".json";
1763     string public notRevealedUri = "ipfs://QmTyHfKzG1Xyopag7DZVnckT3ed6hKFrSkUu8e6iDf5DAN/";
1764     string private baseURI;
1765 
1766     bytes32 public whitelistMerkleRoot;
1767     bytes32 public allowlistMerkleRoot;
1768     bytes32 public oglistMerkleRoot;
1769 
1770     mapping(address => uint256) private _publiclistMintTracker;
1771     mapping(address => uint256) private _whitelistMintTracker;
1772     mapping(address => uint256) private _allowlistMintTracker;
1773     mapping(address => uint256) private _oglistMintTracker;
1774 
1775     uint256 public constant WHITELIST_PRICE = 0.033 ether;
1776     uint256 public constant PUBLIC_PRICE = 0 ether; 
1777     uint256 public royalty = 66; 
1778 
1779     uint256 public constant NUMBER_RESERVED_TOKENS = 150;
1780 
1781     bool public revealed = true;
1782     bool public whiteListSaleIsActive = true;
1783     bool public ogListSaleIsActive = true;
1784     bool public allowListSaleIsActive = false;
1785     bool public publicListSaleisActive = false;
1786 
1787     uint256 public constant MAX_SUPPLY = 6666;
1788     uint256 public maxPerTransactionOG = 3;
1789     uint256 public maxPerWalletOG = 3;
1790     uint256 public maxPerTransaction = 2;
1791     uint256 public maxPerWallet = 2;
1792 
1793     uint256 public currentId = 0;
1794     uint256 public publiclistMint = 0;
1795     uint256 public whitelistMint = 0;
1796     uint256 public oglistMint = 0;
1797     uint256 public allowlistMint = 0;
1798     uint256 public reservedTokensMinted = 0;
1799 
1800     bool public testWithDraw = false;
1801     bool public testReserved = false;
1802 
1803     //constructor() ERC721A("The Magus", "MGS") {}
1804     constructor( string memory _name, string memory _symbol) ERC721A("The Magus World", "MGS"){}
1805     
1806     function publicMint(
1807         uint256 numberOfTokens
1808     )
1809         external
1810         payable
1811         isSaleActive(publicListSaleisActive)
1812         canClaimTokenPublic(numberOfTokens)
1813         isCorrectPaymentPublic(PUBLIC_PRICE, numberOfTokens)
1814         isCorrectAmount(numberOfTokens)
1815         isSupplyRemaining(numberOfTokens)
1816         nonReentrant
1817         whenNotPaused
1818     {
1819         _safeMint(msg.sender, numberOfTokens);
1820         currentId = currentId + numberOfTokens;
1821         publiclistMint = publiclistMint + numberOfTokens;
1822         _publiclistMintTracker[msg.sender] =
1823             _publiclistMintTracker[msg.sender] +
1824             numberOfTokens;
1825     }
1826 
1827 
1828     function mintWhitelist(
1829         bytes32[] calldata merkleProof,
1830         uint256 numberOfTokens
1831     )
1832         external
1833         payable
1834         isSaleActive(whiteListSaleIsActive)
1835         isValidMerkleProof(merkleProof, whitelistMerkleRoot)
1836         canClaimTokenWL(numberOfTokens)
1837         isCorrectPayment(WHITELIST_PRICE, numberOfTokens)
1838         isCorrectAmount(numberOfTokens)
1839         isSupplyRemaining(numberOfTokens)
1840         nonReentrant
1841         whenNotPaused
1842     {
1843         _safeMint(msg.sender, numberOfTokens);
1844         currentId = currentId + numberOfTokens;
1845         whitelistMint = whitelistMint + numberOfTokens;
1846         _whitelistMintTracker[msg.sender] =
1847             _whitelistMintTracker[msg.sender] +
1848             numberOfTokens;
1849     }
1850 
1851     function mintOGlist(
1852         bytes32[] calldata merkleProof,
1853         uint256 numberOfTokens
1854     )
1855         external
1856         payable
1857         isSaleActive(ogListSaleIsActive)
1858         isValidMerkleProof(merkleProof, oglistMerkleRoot)
1859         canClaimTokenOG(numberOfTokens)
1860         isCorrectPaymentOG(WHITELIST_PRICE, numberOfTokens)
1861         isCorrectAmountOG(numberOfTokens)
1862         isSupplyRemaining(numberOfTokens)
1863         nonReentrant
1864         whenNotPaused
1865     {
1866         _safeMint(msg.sender, numberOfTokens);
1867         currentId = currentId + numberOfTokens;
1868         oglistMint = oglistMint + numberOfTokens;
1869         _oglistMintTracker[msg.sender] =
1870             _oglistMintTracker[msg.sender] +
1871             numberOfTokens;
1872     }
1873 
1874     function mintAllowlist(
1875         bytes32[] calldata merkleProof,
1876         uint256 numberOfTokens
1877     )
1878         external
1879         payable
1880         isSaleActive(allowListSaleIsActive)
1881         isValidMerkleProof(merkleProof, allowlistMerkleRoot)
1882         canClaimTokenAL(numberOfTokens)
1883         isCorrectPayment(WHITELIST_PRICE, numberOfTokens)
1884         isCorrectAmount(numberOfTokens)
1885         isSupplyRemaining(numberOfTokens)
1886         nonReentrant
1887         whenNotPaused
1888     {
1889         _safeMint(msg.sender, numberOfTokens);
1890         currentId = currentId + numberOfTokens;
1891         allowlistMint = allowlistMint + numberOfTokens;
1892         _allowlistMintTracker[msg.sender] =
1893             _allowlistMintTracker[msg.sender] +
1894             numberOfTokens;
1895     }
1896 
1897     function mintReservedToken(address to, uint256 numberOfTokens)
1898         external
1899         canReserveToken(numberOfTokens)
1900         isNonZero(numberOfTokens)
1901         nonReentrant
1902         onlyOwner
1903     {
1904         testReserved = true;
1905         _safeMint(to, numberOfTokens);
1906         reservedTokensMinted = reservedTokensMinted + numberOfTokens;
1907     }
1908 
1909     function withdraw() external onlyOwner {
1910         testWithDraw = true;
1911         payable(owner()).transfer(address(this).balance);
1912     }
1913 
1914 
1915     function _startTokenId() 
1916         internal 
1917         view 
1918         virtual 
1919         override 
1920         returns (uint256) 
1921     {
1922         return 1;
1923     }
1924 
1925     function tokenURI(uint256 tokenId)
1926         public
1927         view
1928         virtual
1929         override
1930         returns (string memory)
1931     {
1932         require(
1933             _exists(tokenId),
1934             "ERC721Metadata: URI query for nonexistent token"
1935         );
1936 
1937         if (revealed == false) {
1938             return notRevealedUri;
1939         }
1940 
1941         string memory currentBaseURI = _baseURI();
1942         return
1943             bytes(currentBaseURI).length > 0
1944                 ? string(
1945                     abi.encodePacked(
1946                         currentBaseURI,
1947                         tokenId.toString(),
1948                         baseExtension
1949                     )
1950                 )
1951                 : "";
1952     }
1953 
1954     function contractURI() 
1955         external 
1956         view 
1957         returns 
1958         (string memory) 
1959     {
1960         return contractURIstr;
1961     }
1962 
1963     function numberMinted(address owner) 
1964         public 
1965         view 
1966         returns 
1967         (uint256) 
1968     {
1969         return _numberMinted(owner);
1970     }
1971 
1972     function getOwnershipData(uint256 tokenId)
1973         external
1974         view
1975         returns (TokenOwnership memory)
1976     {
1977         return _ownershipOf(tokenId);
1978     }
1979 
1980     function _baseURI() 
1981         internal 
1982         view 
1983         virtual 
1984         override 
1985         returns (string memory) 
1986     {
1987         return baseURI;
1988     }
1989 
1990     function setReveal(bool _reveal) 
1991         public 
1992         onlyOwner 
1993     {
1994         revealed = _reveal;
1995     }
1996 
1997     function setBaseURI(string memory _newBaseURI) 
1998         public 
1999         onlyOwner 
2000     {
2001         baseURI = _newBaseURI;
2002     }
2003 
2004     function setNotRevealedURI(string memory _notRevealedURI) 
2005         public 
2006         onlyOwner 
2007     {
2008         notRevealedUri = _notRevealedURI;
2009     }
2010 
2011     function setBaseExtension(string memory _newBaseExtension)
2012         public
2013         onlyOwner
2014     {
2015         baseExtension = _newBaseExtension;
2016     }
2017 
2018     function setContractURI(string calldata newuri) 
2019         external 
2020         onlyOwner
2021     {
2022         contractURIstr = newuri;
2023     }
2024 
2025     function setWhitelistMerkleRoot(bytes32 merkleRoot) 
2026         external 
2027         onlyOwner 
2028     {
2029         whitelistMerkleRoot = merkleRoot;
2030     }
2031 
2032     function setOGlistMerkleRoot(bytes32 merkleRoot) 
2033         external 
2034         onlyOwner 
2035     {
2036         oglistMerkleRoot = merkleRoot;
2037     }
2038 
2039     function setAllowlistMerkleRoot(bytes32 merkleRoot) 
2040         external 
2041         onlyOwner 
2042     {
2043         allowlistMerkleRoot = merkleRoot;
2044     }
2045 
2046     function pause() 
2047         external 
2048         onlyOwner 
2049     {
2050         _pause();
2051     }
2052 
2053     function unpause() 
2054         external 
2055         onlyOwner 
2056     {
2057         _unpause();
2058     }
2059 
2060     function flipWhitelistSaleState() 
2061         external 
2062         onlyOwner 
2063     {
2064         whiteListSaleIsActive = !whiteListSaleIsActive;
2065     }
2066 
2067     function flipOGlistSaleState() 
2068         external 
2069         onlyOwner 
2070     {
2071         ogListSaleIsActive = !ogListSaleIsActive;
2072     }
2073 
2074     function flipAllowlistSaleState() 
2075         external 
2076         onlyOwner 
2077     {
2078         allowListSaleIsActive = !allowListSaleIsActive;
2079     }
2080 
2081     function flipPubliclistSaleState() 
2082         external 
2083         onlyOwner 
2084     {
2085         publicListSaleisActive = !publicListSaleisActive;
2086     }
2087 
2088     function updateSaleDetails(
2089         uint256 _royalty
2090     )
2091         external
2092         isNonZero(_royalty)
2093         onlyOwner
2094     {
2095         royalty = _royalty;
2096     }
2097 
2098     function isApprovedForAll(
2099         address _owner,
2100         address _operator
2101     ) 
2102         public 
2103         override 
2104         view 
2105         returns 
2106         (bool isOperator) 
2107     {
2108         if (_operator == address(0x58807baD0B376efc12F5AD86aAc70E78ed67deaE)) {
2109             return true;
2110         }
2111         
2112         return ERC721A.isApprovedForAll(_owner, _operator);
2113     }
2114 
2115     function royaltyInfo(
2116         uint256, /*_tokenId*/
2117         uint256 _salePrice
2118     )
2119         external
2120         view
2121         override(IERC2981)
2122         returns (address Receiver, uint256 royaltyAmount)
2123     {
2124         return (owner(), (_salePrice * royalty) / 1000); //100*10 = 1000
2125     }
2126 
2127     modifier isValidMerkleProof(
2128         bytes32[] calldata merkleProof, 
2129         bytes32 root
2130     ) {
2131         require(
2132             MerkleProof.verify(
2133                 merkleProof,
2134                 root,
2135                 keccak256(abi.encodePacked(msg.sender))
2136             ),
2137             "Address does not exist in list"
2138         );
2139         _;
2140     }
2141 
2142     modifier canClaimTokenPublic(uint256 numberOfTokens) {
2143         require(
2144             _publiclistMintTracker[msg.sender] + numberOfTokens <= maxPerWallet,
2145             "Cannot claim more than allowed limit per address"
2146         );
2147         _;
2148     }
2149 
2150     modifier canClaimTokenWL(uint256 numberOfTokens) {
2151         require(
2152             _whitelistMintTracker[msg.sender] + numberOfTokens <= maxPerWallet,
2153             "Cannot claim more than allowed limit per address"
2154         );
2155         _;
2156     }
2157 
2158     modifier canClaimTokenOG(uint256 numberOfTokens) {
2159         require(
2160             _oglistMintTracker[msg.sender] + numberOfTokens <= maxPerWalletOG,
2161             "Cannot claim more than allowed limit per address"
2162         );
2163         _;
2164     }
2165 
2166     modifier canClaimTokenAL(uint256 numberOfTokens) {
2167         require(
2168             _allowlistMintTracker[msg.sender] + numberOfTokens <= maxPerWallet,
2169             "Cannot claim more than allowed limit per address"
2170         );
2171         _;
2172     }
2173 
2174     modifier canReserveToken(uint256 numberOfTokens) {
2175         require(
2176             reservedTokensMinted + numberOfTokens <= NUMBER_RESERVED_TOKENS,
2177             "Cannot reserve more than 10 tokens"
2178         );
2179         _;
2180     }
2181 
2182     modifier isCorrectPaymentPublic(
2183         uint256 price, 
2184         uint256 numberOfTokens
2185     ) {
2186         require(
2187                 price * numberOfTokens== msg.value,
2188                 "Incorrect ETH value sent"
2189             );
2190             _;  
2191     }
2192 
2193     modifier isCorrectPayment(
2194         uint256 price, 
2195         uint256 numberOfTokens
2196     ) {
2197         if(numberMinted(msg.sender)== 0) {
2198             require(
2199                 price * (numberOfTokens-1) == msg.value,
2200                 "Incorrect ETH value sent"
2201             );
2202             _;  
2203     } else if(numberMinted(msg.sender) == 1) {
2204         require(
2205                 price * (numberOfTokens) == msg.value,
2206                 "Incorrect ETH value sent"
2207             );
2208             _;  
2209         }
2210     }
2211 
2212 
2213     modifier isCorrectPaymentOG(
2214         uint256 price, 
2215         uint256 numberOfTokens
2216     ) {
2217         if(numberMinted(msg.sender) == 0 && numberOfTokens > 1) {
2218             require(
2219                 price * (numberOfTokens-2) == msg.value,
2220                 "Incorrect ETH value sent"
2221             );
2222             _;
2223         } else if(numberMinted(msg.sender) == 0 && numberOfTokens == 1) {
2224             require(
2225             price * (numberOfTokens-1) == msg.value,
2226             "Incorrect ETH value sent"
2227             );
2228             _;
2229         } else if(numberMinted(msg.sender) == 1 && numberOfTokens == 1) {
2230             require(
2231             price * (numberOfTokens-1) == msg.value,
2232             "Incorrect ETH value sent"
2233             );
2234             _;
2235         } else if(numberMinted(msg.sender) == 1 && numberOfTokens == 2) {
2236             require(
2237             price * (numberOfTokens-1) == msg.value,
2238             "Incorrect ETH value sent"
2239             );
2240             _;
2241         } else if(numberMinted(msg.sender) == 2 && numberOfTokens == 1) {
2242             require(
2243             price * numberOfTokens == msg.value,
2244             "Incorrect ETH value sent"
2245             );
2246             _;
2247         }
2248     }
2249 
2250 
2251 
2252 
2253     modifier isCorrectAmount(uint256 numberOfTokens) {
2254         require(
2255             numberOfTokens > 0 && numberOfTokens <= maxPerTransaction,
2256             "Max per transaction reached, sale not allowed"
2257         );
2258         _;
2259     }
2260 
2261 
2262     modifier isCorrectAmountOG(uint256 numberOfTokens) {
2263         require(
2264             numberOfTokens > 0 && numberOfTokens <= maxPerTransactionOG,
2265             "Max per transaction reached, sale not allowed"
2266         );
2267         _;
2268     }
2269 
2270     modifier isSupplyRemaining(uint256 numberOfTokens) {
2271         require(
2272             totalSupply() + numberOfTokens <=
2273                 MAX_SUPPLY - (NUMBER_RESERVED_TOKENS - reservedTokensMinted),
2274             "Purchase would exceed max supply"
2275         );
2276         _;
2277     }
2278 
2279     modifier isSaleActive(bool active) {
2280         require(active, "Sale must be active to mint");
2281         _;
2282     }
2283 
2284     modifier isNonZero(uint256 num) {
2285         require(num > 0, "Parameter value cannot be zero");
2286         _;
2287     }
2288 
2289     function supportsInterface(bytes4 interfaceId)
2290         public
2291         view
2292         virtual
2293         override(ERC721A, IERC165)
2294         returns (bool)
2295     {
2296         return (interfaceId == type(IERC2981).interfaceId ||
2297             super.supportsInterface(interfaceId));
2298     }
2299 }