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
282 // File: @openzeppelin/contracts/utils/Counters.sol
283 
284 
285 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
286 
287 pragma solidity ^0.8.0;
288 
289 /**
290  * @title Counters
291  * @author Matt Condon (@shrugs)
292  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
293  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
294  *
295  * Include with `using Counters for Counters.Counter;`
296  */
297 library Counters {
298     struct Counter {
299         // This variable should never be directly accessed by users of the library: interactions must be restricted to
300         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
301         // this feature: see https://github.com/ethereum/solidity/issues/4637
302         uint256 _value; // default: 0
303     }
304 
305     function current(Counter storage counter) internal view returns (uint256) {
306         return counter._value;
307     }
308 
309     function increment(Counter storage counter) internal {
310         unchecked {
311             counter._value += 1;
312         }
313     }
314 
315     function decrement(Counter storage counter) internal {
316         uint256 value = counter._value;
317         require(value > 0, "Counter: decrement overflow");
318         unchecked {
319             counter._value = value - 1;
320         }
321     }
322 
323     function reset(Counter storage counter) internal {
324         counter._value = 0;
325     }
326 }
327 
328 // File: @openzeppelin/contracts/utils/Strings.sol
329 
330 
331 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
332 
333 pragma solidity ^0.8.0;
334 
335 /**
336  * @dev String operations.
337  */
338 library Strings {
339     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
340     uint8 private constant _ADDRESS_LENGTH = 20;
341 
342     /**
343      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
344      */
345     function toString(uint256 value) internal pure returns (string memory) {
346         // Inspired by OraclizeAPI's implementation - MIT licence
347         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
348 
349         if (value == 0) {
350             return "0";
351         }
352         uint256 temp = value;
353         uint256 digits;
354         while (temp != 0) {
355             digits++;
356             temp /= 10;
357         }
358         bytes memory buffer = new bytes(digits);
359         while (value != 0) {
360             digits -= 1;
361             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
362             value /= 10;
363         }
364         return string(buffer);
365     }
366 
367     /**
368      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
369      */
370     function toHexString(uint256 value) internal pure returns (string memory) {
371         if (value == 0) {
372             return "0x00";
373         }
374         uint256 temp = value;
375         uint256 length = 0;
376         while (temp != 0) {
377             length++;
378             temp >>= 8;
379         }
380         return toHexString(value, length);
381     }
382 
383     /**
384      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
385      */
386     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
387         bytes memory buffer = new bytes(2 * length + 2);
388         buffer[0] = "0";
389         buffer[1] = "x";
390         for (uint256 i = 2 * length + 1; i > 1; --i) {
391             buffer[i] = _HEX_SYMBOLS[value & 0xf];
392             value >>= 4;
393         }
394         require(value == 0, "Strings: hex length insufficient");
395         return string(buffer);
396     }
397 
398     /**
399      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
400      */
401     function toHexString(address addr) internal pure returns (string memory) {
402         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
403     }
404 }
405 
406 // File: @openzeppelin/contracts/utils/Context.sol
407 
408 
409 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
410 
411 pragma solidity ^0.8.0;
412 
413 /**
414  * @dev Provides information about the current execution context, including the
415  * sender of the transaction and its data. While these are generally available
416  * via msg.sender and msg.data, they should not be accessed in such a direct
417  * manner, since when dealing with meta-transactions the account sending and
418  * paying for execution may not be the actual sender (as far as an application
419  * is concerned).
420  *
421  * This contract is only required for intermediate, library-like contracts.
422  */
423 abstract contract Context {
424     function _msgSender() internal view virtual returns (address) {
425         return msg.sender;
426     }
427 
428     function _msgData() internal view virtual returns (bytes calldata) {
429         return msg.data;
430     }
431 }
432 
433 // File: @openzeppelin/contracts/access/Ownable.sol
434 
435 
436 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
437 
438 pragma solidity ^0.8.0;
439 
440 
441 /**
442  * @dev Contract module which provides a basic access control mechanism, where
443  * there is an account (an owner) that can be granted exclusive access to
444  * specific functions.
445  *
446  * By default, the owner account will be the one that deploys the contract. This
447  * can later be changed with {transferOwnership}.
448  *
449  * This module is used through inheritance. It will make available the modifier
450  * `onlyOwner`, which can be applied to your functions to restrict their use to
451  * the owner.
452  */
453 abstract contract Ownable is Context {
454     address private _owner;
455 
456     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
457 
458     /**
459      * @dev Initializes the contract setting the deployer as the initial owner.
460      */
461     constructor() {
462         _transferOwnership(_msgSender());
463     }
464 
465     /**
466      * @dev Throws if called by any account other than the owner.
467      */
468     modifier onlyOwner() {
469         _checkOwner();
470         _;
471     }
472 
473     /**
474      * @dev Returns the address of the current owner.
475      */
476     function owner() public view virtual returns (address) {
477         return _owner;
478     }
479 
480     /**
481      * @dev Throws if the sender is not the owner.
482      */
483     function _checkOwner() internal view virtual {
484         require(owner() == _msgSender(), "Ownable: caller is not the owner");
485     }
486 
487     /**
488      * @dev Leaves the contract without owner. It will not be possible to call
489      * `onlyOwner` functions anymore. Can only be called by the current owner.
490      *
491      * NOTE: Renouncing ownership will leave the contract without an owner,
492      * thereby removing any functionality that is only available to the owner.
493      */
494     function renounceOwnership() public virtual onlyOwner {
495         _transferOwnership(address(0));
496     }
497 
498     /**
499      * @dev Transfers ownership of the contract to a new account (`newOwner`).
500      * Can only be called by the current owner.
501      */
502     function transferOwnership(address newOwner) public virtual onlyOwner {
503         require(newOwner != address(0), "Ownable: new owner is the zero address");
504         _transferOwnership(newOwner);
505     }
506 
507     /**
508      * @dev Transfers ownership of the contract to a new account (`newOwner`).
509      * Internal function without access restriction.
510      */
511     function _transferOwnership(address newOwner) internal virtual {
512         address oldOwner = _owner;
513         _owner = newOwner;
514         emit OwnershipTransferred(oldOwner, newOwner);
515     }
516 }
517 
518 // File: @openzeppelin/contracts/utils/Address.sol
519 
520 
521 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
522 
523 pragma solidity ^0.8.1;
524 
525 /**
526  * @dev Collection of functions related to the address type
527  */
528 library Address {
529     /**
530      * @dev Returns true if `account` is a contract.
531      *
532      * [IMPORTANT]
533      * ====
534      * It is unsafe to assume that an address for which this function returns
535      * false is an externally-owned account (EOA) and not a contract.
536      *
537      * Among others, `isContract` will return false for the following
538      * types of addresses:
539      *
540      *  - an externally-owned account
541      *  - a contract in construction
542      *  - an address where a contract will be created
543      *  - an address where a contract lived, but was destroyed
544      * ====
545      *
546      * [IMPORTANT]
547      * ====
548      * You shouldn't rely on `isContract` to protect against flash loan attacks!
549      *
550      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
551      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
552      * constructor.
553      * ====
554      */
555     function isContract(address account) internal view returns (bool) {
556         // This method relies on extcodesize/address.code.length, which returns 0
557         // for contracts in construction, since the code is only stored at the end
558         // of the constructor execution.
559 
560         return account.code.length > 0;
561     }
562 
563     /**
564      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
565      * `recipient`, forwarding all available gas and reverting on errors.
566      *
567      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
568      * of certain opcodes, possibly making contracts go over the 2300 gas limit
569      * imposed by `transfer`, making them unable to receive funds via
570      * `transfer`. {sendValue} removes this limitation.
571      *
572      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
573      *
574      * IMPORTANT: because control is transferred to `recipient`, care must be
575      * taken to not create reentrancy vulnerabilities. Consider using
576      * {ReentrancyGuard} or the
577      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
578      */
579     function sendValue(address payable recipient, uint256 amount) internal {
580         require(address(this).balance >= amount, "Address: insufficient balance");
581 
582         (bool success, ) = recipient.call{value: amount}("");
583         require(success, "Address: unable to send value, recipient may have reverted");
584     }
585 
586     /**
587      * @dev Performs a Solidity function call using a low level `call`. A
588      * plain `call` is an unsafe replacement for a function call: use this
589      * function instead.
590      *
591      * If `target` reverts with a revert reason, it is bubbled up by this
592      * function (like regular Solidity function calls).
593      *
594      * Returns the raw returned data. To convert to the expected return value,
595      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
596      *
597      * Requirements:
598      *
599      * - `target` must be a contract.
600      * - calling `target` with `data` must not revert.
601      *
602      * _Available since v3.1._
603      */
604     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
605         return functionCall(target, data, "Address: low-level call failed");
606     }
607 
608     /**
609      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
610      * `errorMessage` as a fallback revert reason when `target` reverts.
611      *
612      * _Available since v3.1._
613      */
614     function functionCall(
615         address target,
616         bytes memory data,
617         string memory errorMessage
618     ) internal returns (bytes memory) {
619         return functionCallWithValue(target, data, 0, errorMessage);
620     }
621 
622     /**
623      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
624      * but also transferring `value` wei to `target`.
625      *
626      * Requirements:
627      *
628      * - the calling contract must have an ETH balance of at least `value`.
629      * - the called Solidity function must be `payable`.
630      *
631      * _Available since v3.1._
632      */
633     function functionCallWithValue(
634         address target,
635         bytes memory data,
636         uint256 value
637     ) internal returns (bytes memory) {
638         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
639     }
640 
641     /**
642      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
643      * with `errorMessage` as a fallback revert reason when `target` reverts.
644      *
645      * _Available since v3.1._
646      */
647     function functionCallWithValue(
648         address target,
649         bytes memory data,
650         uint256 value,
651         string memory errorMessage
652     ) internal returns (bytes memory) {
653         require(address(this).balance >= value, "Address: insufficient balance for call");
654         require(isContract(target), "Address: call to non-contract");
655 
656         (bool success, bytes memory returndata) = target.call{value: value}(data);
657         return verifyCallResult(success, returndata, errorMessage);
658     }
659 
660     /**
661      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
662      * but performing a static call.
663      *
664      * _Available since v3.3._
665      */
666     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
667         return functionStaticCall(target, data, "Address: low-level static call failed");
668     }
669 
670     /**
671      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
672      * but performing a static call.
673      *
674      * _Available since v3.3._
675      */
676     function functionStaticCall(
677         address target,
678         bytes memory data,
679         string memory errorMessage
680     ) internal view returns (bytes memory) {
681         require(isContract(target), "Address: static call to non-contract");
682 
683         (bool success, bytes memory returndata) = target.staticcall(data);
684         return verifyCallResult(success, returndata, errorMessage);
685     }
686 
687     /**
688      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
689      * but performing a delegate call.
690      *
691      * _Available since v3.4._
692      */
693     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
694         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
695     }
696 
697     /**
698      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
699      * but performing a delegate call.
700      *
701      * _Available since v3.4._
702      */
703     function functionDelegateCall(
704         address target,
705         bytes memory data,
706         string memory errorMessage
707     ) internal returns (bytes memory) {
708         require(isContract(target), "Address: delegate call to non-contract");
709 
710         (bool success, bytes memory returndata) = target.delegatecall(data);
711         return verifyCallResult(success, returndata, errorMessage);
712     }
713 
714     /**
715      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
716      * revert reason using the provided one.
717      *
718      * _Available since v4.3._
719      */
720     function verifyCallResult(
721         bool success,
722         bytes memory returndata,
723         string memory errorMessage
724     ) internal pure returns (bytes memory) {
725         if (success) {
726             return returndata;
727         } else {
728             // Look for revert reason and bubble it up if present
729             if (returndata.length > 0) {
730                 // The easiest way to bubble the revert reason is using memory via assembly
731                 /// @solidity memory-safe-assembly
732                 assembly {
733                     let returndata_size := mload(returndata)
734                     revert(add(32, returndata), returndata_size)
735                 }
736             } else {
737                 revert(errorMessage);
738             }
739         }
740     }
741 }
742 
743 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
744 
745 
746 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
747 
748 pragma solidity ^0.8.0;
749 
750 /**
751  * @title ERC721 token receiver interface
752  * @dev Interface for any contract that wants to support safeTransfers
753  * from ERC721 asset contracts.
754  */
755 interface IERC721Receiver {
756     /**
757      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
758      * by `operator` from `from`, this function is called.
759      *
760      * It must return its Solidity selector to confirm the token transfer.
761      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
762      *
763      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
764      */
765     function onERC721Received(
766         address operator,
767         address from,
768         uint256 tokenId,
769         bytes calldata data
770     ) external returns (bytes4);
771 }
772 
773 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
774 
775 
776 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
777 
778 pragma solidity ^0.8.0;
779 
780 /**
781  * @dev Interface of the ERC165 standard, as defined in the
782  * https://eips.ethereum.org/EIPS/eip-165[EIP].
783  *
784  * Implementers can declare support of contract interfaces, which can then be
785  * queried by others ({ERC165Checker}).
786  *
787  * For an implementation, see {ERC165}.
788  */
789 interface IERC165 {
790     /**
791      * @dev Returns true if this contract implements the interface defined by
792      * `interfaceId`. See the corresponding
793      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
794      * to learn more about how these ids are created.
795      *
796      * This function call must use less than 30 000 gas.
797      */
798     function supportsInterface(bytes4 interfaceId) external view returns (bool);
799 }
800 
801 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
802 
803 
804 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
805 
806 pragma solidity ^0.8.0;
807 
808 
809 /**
810  * @dev Implementation of the {IERC165} interface.
811  *
812  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
813  * for the additional interface id that will be supported. For example:
814  *
815  * ```solidity
816  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
817  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
818  * }
819  * ```
820  *
821  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
822  */
823 abstract contract ERC165 is IERC165 {
824     /**
825      * @dev See {IERC165-supportsInterface}.
826      */
827     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
828         return interfaceId == type(IERC165).interfaceId;
829     }
830 }
831 
832 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
833 
834 
835 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
836 
837 pragma solidity ^0.8.0;
838 
839 
840 /**
841  * @dev Required interface of an ERC721 compliant contract.
842  */
843 interface IERC721 is IERC165 {
844     /**
845      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
846      */
847     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
848 
849     /**
850      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
851      */
852     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
853 
854     /**
855      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
856      */
857     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
858 
859     /**
860      * @dev Returns the number of tokens in ``owner``'s account.
861      */
862     function balanceOf(address owner) external view returns (uint256 balance);
863 
864     /**
865      * @dev Returns the owner of the `tokenId` token.
866      *
867      * Requirements:
868      *
869      * - `tokenId` must exist.
870      */
871     function ownerOf(uint256 tokenId) external view returns (address owner);
872 
873     /**
874      * @dev Safely transfers `tokenId` token from `from` to `to`.
875      *
876      * Requirements:
877      *
878      * - `from` cannot be the zero address.
879      * - `to` cannot be the zero address.
880      * - `tokenId` token must exist and be owned by `from`.
881      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
882      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
883      *
884      * Emits a {Transfer} event.
885      */
886     function safeTransferFrom(
887         address from,
888         address to,
889         uint256 tokenId,
890         bytes calldata data
891     ) external;
892 
893     /**
894      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
895      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
896      *
897      * Requirements:
898      *
899      * - `from` cannot be the zero address.
900      * - `to` cannot be the zero address.
901      * - `tokenId` token must exist and be owned by `from`.
902      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
903      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
904      *
905      * Emits a {Transfer} event.
906      */
907     function safeTransferFrom(
908         address from,
909         address to,
910         uint256 tokenId
911     ) external;
912 
913     /**
914      * @dev Transfers `tokenId` token from `from` to `to`.
915      *
916      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
917      *
918      * Requirements:
919      *
920      * - `from` cannot be the zero address.
921      * - `to` cannot be the zero address.
922      * - `tokenId` token must be owned by `from`.
923      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
924      *
925      * Emits a {Transfer} event.
926      */
927     function transferFrom(
928         address from,
929         address to,
930         uint256 tokenId
931     ) external;
932 
933     /**
934      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
935      * The approval is cleared when the token is transferred.
936      *
937      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
938      *
939      * Requirements:
940      *
941      * - The caller must own the token or be an approved operator.
942      * - `tokenId` must exist.
943      *
944      * Emits an {Approval} event.
945      */
946     function approve(address to, uint256 tokenId) external;
947 
948     /**
949      * @dev Approve or remove `operator` as an operator for the caller.
950      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
951      *
952      * Requirements:
953      *
954      * - The `operator` cannot be the caller.
955      *
956      * Emits an {ApprovalForAll} event.
957      */
958     function setApprovalForAll(address operator, bool _approved) external;
959 
960     /**
961      * @dev Returns the account approved for `tokenId` token.
962      *
963      * Requirements:
964      *
965      * - `tokenId` must exist.
966      */
967     function getApproved(uint256 tokenId) external view returns (address operator);
968 
969     /**
970      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
971      *
972      * See {setApprovalForAll}
973      */
974     function isApprovedForAll(address owner, address operator) external view returns (bool);
975 }
976 
977 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
978 
979 
980 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
981 
982 pragma solidity ^0.8.0;
983 
984 
985 /**
986  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
987  * @dev See https://eips.ethereum.org/EIPS/eip-721
988  */
989 interface IERC721Enumerable is IERC721 {
990     /**
991      * @dev Returns the total amount of tokens stored by the contract.
992      */
993     function totalSupply() external view returns (uint256);
994 
995     /**
996      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
997      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
998      */
999     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1000 
1001     /**
1002      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1003      * Use along with {totalSupply} to enumerate all tokens.
1004      */
1005     function tokenByIndex(uint256 index) external view returns (uint256);
1006 }
1007 
1008 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1009 
1010 
1011 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1012 
1013 pragma solidity ^0.8.0;
1014 
1015 
1016 /**
1017  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1018  * @dev See https://eips.ethereum.org/EIPS/eip-721
1019  */
1020 interface IERC721Metadata is IERC721 {
1021     /**
1022      * @dev Returns the token collection name.
1023      */
1024     function name() external view returns (string memory);
1025 
1026     /**
1027      * @dev Returns the token collection symbol.
1028      */
1029     function symbol() external view returns (string memory);
1030 
1031     /**
1032      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1033      */
1034     function tokenURI(uint256 tokenId) external view returns (string memory);
1035 }
1036 
1037 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1038 
1039 
1040 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
1041 
1042 pragma solidity ^0.8.0;
1043 
1044 
1045 
1046 
1047 
1048 
1049 
1050 
1051 /**
1052  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1053  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1054  * {ERC721Enumerable}.
1055  */
1056 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1057     using Address for address;
1058     using Strings for uint256;
1059 
1060     // Token name
1061     string private _name;
1062 
1063     // Token symbol
1064     string private _symbol;
1065 
1066     // Mapping from token ID to owner address
1067     mapping(uint256 => address) private _owners;
1068 
1069     // Mapping owner address to token count
1070     mapping(address => uint256) private _balances;
1071 
1072     // Mapping from token ID to approved address
1073     mapping(uint256 => address) private _tokenApprovals;
1074 
1075     // Mapping from owner to operator approvals
1076     mapping(address => mapping(address => bool)) private _operatorApprovals;
1077 
1078     /**
1079      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1080      */
1081     constructor(string memory name_, string memory symbol_) {
1082         _name = name_;
1083         _symbol = symbol_;
1084     }
1085 
1086     /**
1087      * @dev See {IERC165-supportsInterface}.
1088      */
1089     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1090         return
1091             interfaceId == type(IERC721).interfaceId ||
1092             interfaceId == type(IERC721Metadata).interfaceId ||
1093             super.supportsInterface(interfaceId);
1094     }
1095 
1096     /**
1097      * @dev See {IERC721-balanceOf}.
1098      */
1099     function balanceOf(address owner) public view virtual override returns (uint256) {
1100         require(owner != address(0), "ERC721: address zero is not a valid owner");
1101         return _balances[owner];
1102     }
1103 
1104     /**
1105      * @dev See {IERC721-ownerOf}.
1106      */
1107     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1108         address owner = _owners[tokenId];
1109         require(owner != address(0), "ERC721: invalid token ID");
1110         return owner;
1111     }
1112 
1113     /**
1114      * @dev See {IERC721Metadata-name}.
1115      */
1116     function name() public view virtual override returns (string memory) {
1117         return _name;
1118     }
1119 
1120     /**
1121      * @dev See {IERC721Metadata-symbol}.
1122      */
1123     function symbol() public view virtual override returns (string memory) {
1124         return _symbol;
1125     }
1126 
1127     /**
1128      * @dev See {IERC721Metadata-tokenURI}.
1129      */
1130     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1131         _requireMinted(tokenId);
1132 
1133         string memory baseURI = _baseURI();
1134         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1135     }
1136 
1137     /**
1138      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1139      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1140      * by default, can be overridden in child contracts.
1141      */
1142     function _baseURI() internal view virtual returns (string memory) {
1143         return "";
1144     }
1145 
1146     /**
1147      * @dev See {IERC721-approve}.
1148      */
1149     function approve(address to, uint256 tokenId) public virtual override {
1150         address owner = ERC721.ownerOf(tokenId);
1151         require(to != owner, "ERC721: approval to current owner");
1152 
1153         require(
1154             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1155             "ERC721: approve caller is not token owner nor approved for all"
1156         );
1157 
1158         _approve(to, tokenId);
1159     }
1160 
1161     /**
1162      * @dev See {IERC721-getApproved}.
1163      */
1164     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1165         _requireMinted(tokenId);
1166 
1167         return _tokenApprovals[tokenId];
1168     }
1169 
1170     /**
1171      * @dev See {IERC721-setApprovalForAll}.
1172      */
1173     function setApprovalForAll(address operator, bool approved) public virtual override {
1174         _setApprovalForAll(_msgSender(), operator, approved);
1175     }
1176 
1177     /**
1178      * @dev See {IERC721-isApprovedForAll}.
1179      */
1180     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1181         return _operatorApprovals[owner][operator];
1182     }
1183 
1184     /**
1185      * @dev See {IERC721-transferFrom}.
1186      */
1187     function transferFrom(
1188         address from,
1189         address to,
1190         uint256 tokenId
1191     ) public virtual override {
1192         //solhint-disable-next-line max-line-length
1193         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1194 
1195         _transfer(from, to, tokenId);
1196     }
1197 
1198     /**
1199      * @dev See {IERC721-safeTransferFrom}.
1200      */
1201     function safeTransferFrom(
1202         address from,
1203         address to,
1204         uint256 tokenId
1205     ) public virtual override {
1206         safeTransferFrom(from, to, tokenId, "");
1207     }
1208 
1209     /**
1210      * @dev See {IERC721-safeTransferFrom}.
1211      */
1212     function safeTransferFrom(
1213         address from,
1214         address to,
1215         uint256 tokenId,
1216         bytes memory data
1217     ) public virtual override {
1218         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1219         _safeTransfer(from, to, tokenId, data);
1220     }
1221 
1222     /**
1223      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1224      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1225      *
1226      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1227      *
1228      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1229      * implement alternative mechanisms to perform token transfer, such as signature-based.
1230      *
1231      * Requirements:
1232      *
1233      * - `from` cannot be the zero address.
1234      * - `to` cannot be the zero address.
1235      * - `tokenId` token must exist and be owned by `from`.
1236      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1237      *
1238      * Emits a {Transfer} event.
1239      */
1240     function _safeTransfer(
1241         address from,
1242         address to,
1243         uint256 tokenId,
1244         bytes memory data
1245     ) internal virtual {
1246         _transfer(from, to, tokenId);
1247         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1248     }
1249 
1250     /**
1251      * @dev Returns whether `tokenId` exists.
1252      *
1253      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1254      *
1255      * Tokens start existing when they are minted (`_mint`),
1256      * and stop existing when they are burned (`_burn`).
1257      */
1258     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1259         return _owners[tokenId] != address(0);
1260     }
1261 
1262     /**
1263      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1264      *
1265      * Requirements:
1266      *
1267      * - `tokenId` must exist.
1268      */
1269     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1270         address owner = ERC721.ownerOf(tokenId);
1271         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1272     }
1273 
1274     /**
1275      * @dev Safely mints `tokenId` and transfers it to `to`.
1276      *
1277      * Requirements:
1278      *
1279      * - `tokenId` must not exist.
1280      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1281      *
1282      * Emits a {Transfer} event.
1283      */
1284     function _safeMint(address to, uint256 tokenId) internal virtual {
1285         _safeMint(to, tokenId, "");
1286     }
1287 
1288     /**
1289      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1290      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1291      */
1292     function _safeMint(
1293         address to,
1294         uint256 tokenId,
1295         bytes memory data
1296     ) internal virtual {
1297         _mint(to, tokenId);
1298         require(
1299             _checkOnERC721Received(address(0), to, tokenId, data),
1300             "ERC721: transfer to non ERC721Receiver implementer"
1301         );
1302     }
1303 
1304     /**
1305      * @dev Mints `tokenId` and transfers it to `to`.
1306      *
1307      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1308      *
1309      * Requirements:
1310      *
1311      * - `tokenId` must not exist.
1312      * - `to` cannot be the zero address.
1313      *
1314      * Emits a {Transfer} event.
1315      */
1316     function _mint(address to, uint256 tokenId) internal virtual {
1317         require(to != address(0), "ERC721: mint to the zero address");
1318         require(!_exists(tokenId), "ERC721: token already minted");
1319 
1320         _beforeTokenTransfer(address(0), to, tokenId);
1321 
1322         _balances[to] += 1;
1323         _owners[tokenId] = to;
1324 
1325         emit Transfer(address(0), to, tokenId);
1326 
1327         _afterTokenTransfer(address(0), to, tokenId);
1328     }
1329 
1330     /**
1331      * @dev Destroys `tokenId`.
1332      * The approval is cleared when the token is burned.
1333      *
1334      * Requirements:
1335      *
1336      * - `tokenId` must exist.
1337      *
1338      * Emits a {Transfer} event.
1339      */
1340     function _burn(uint256 tokenId) internal virtual {
1341         address owner = ERC721.ownerOf(tokenId);
1342 
1343         _beforeTokenTransfer(owner, address(0), tokenId);
1344 
1345         // Clear approvals
1346         _approve(address(0), tokenId);
1347 
1348         _balances[owner] -= 1;
1349         delete _owners[tokenId];
1350 
1351         emit Transfer(owner, address(0), tokenId);
1352 
1353         _afterTokenTransfer(owner, address(0), tokenId);
1354     }
1355 
1356     /**
1357      * @dev Transfers `tokenId` from `from` to `to`.
1358      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1359      *
1360      * Requirements:
1361      *
1362      * - `to` cannot be the zero address.
1363      * - `tokenId` token must be owned by `from`.
1364      *
1365      * Emits a {Transfer} event.
1366      */
1367     function _transfer(
1368         address from,
1369         address to,
1370         uint256 tokenId
1371     ) internal virtual {
1372         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1373         require(to != address(0), "ERC721: transfer to the zero address");
1374 
1375         _beforeTokenTransfer(from, to, tokenId);
1376 
1377         // Clear approvals from the previous owner
1378         _approve(address(0), tokenId);
1379 
1380         _balances[from] -= 1;
1381         _balances[to] += 1;
1382         _owners[tokenId] = to;
1383 
1384         emit Transfer(from, to, tokenId);
1385 
1386         _afterTokenTransfer(from, to, tokenId);
1387     }
1388 
1389     /**
1390      * @dev Approve `to` to operate on `tokenId`
1391      *
1392      * Emits an {Approval} event.
1393      */
1394     function _approve(address to, uint256 tokenId) internal virtual {
1395         _tokenApprovals[tokenId] = to;
1396         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1397     }
1398 
1399     /**
1400      * @dev Approve `operator` to operate on all of `owner` tokens
1401      *
1402      * Emits an {ApprovalForAll} event.
1403      */
1404     function _setApprovalForAll(
1405         address owner,
1406         address operator,
1407         bool approved
1408     ) internal virtual {
1409         require(owner != operator, "ERC721: approve to caller");
1410         _operatorApprovals[owner][operator] = approved;
1411         emit ApprovalForAll(owner, operator, approved);
1412     }
1413 
1414     /**
1415      * @dev Reverts if the `tokenId` has not been minted yet.
1416      */
1417     function _requireMinted(uint256 tokenId) internal view virtual {
1418         require(_exists(tokenId), "ERC721: invalid token ID");
1419     }
1420 
1421     /**
1422      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1423      * The call is not executed if the target address is not a contract.
1424      *
1425      * @param from address representing the previous owner of the given token ID
1426      * @param to target address that will receive the tokens
1427      * @param tokenId uint256 ID of the token to be transferred
1428      * @param data bytes optional data to send along with the call
1429      * @return bool whether the call correctly returned the expected magic value
1430      */
1431     function _checkOnERC721Received(
1432         address from,
1433         address to,
1434         uint256 tokenId,
1435         bytes memory data
1436     ) private returns (bool) {
1437         if (to.isContract()) {
1438             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1439                 return retval == IERC721Receiver.onERC721Received.selector;
1440             } catch (bytes memory reason) {
1441                 if (reason.length == 0) {
1442                     revert("ERC721: transfer to non ERC721Receiver implementer");
1443                 } else {
1444                     /// @solidity memory-safe-assembly
1445                     assembly {
1446                         revert(add(32, reason), mload(reason))
1447                     }
1448                 }
1449             }
1450         } else {
1451             return true;
1452         }
1453     }
1454 
1455     /**
1456      * @dev Hook that is called before any token transfer. This includes minting
1457      * and burning.
1458      *
1459      * Calling conditions:
1460      *
1461      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1462      * transferred to `to`.
1463      * - When `from` is zero, `tokenId` will be minted for `to`.
1464      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1465      * - `from` and `to` are never both zero.
1466      *
1467      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1468      */
1469     function _beforeTokenTransfer(
1470         address from,
1471         address to,
1472         uint256 tokenId
1473     ) internal virtual {}
1474 
1475     /**
1476      * @dev Hook that is called after any transfer of tokens. This includes
1477      * minting and burning.
1478      *
1479      * Calling conditions:
1480      *
1481      * - when `from` and `to` are both non-zero.
1482      * - `from` and `to` are never both zero.
1483      *
1484      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1485      */
1486     function _afterTokenTransfer(
1487         address from,
1488         address to,
1489         uint256 tokenId
1490     ) internal virtual {}
1491 }
1492 
1493 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1494 
1495 
1496 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721Burnable.sol)
1497 
1498 pragma solidity ^0.8.0;
1499 
1500 
1501 
1502 /**
1503  * @title ERC721 Burnable Token
1504  * @dev ERC721 Token that can be burned (destroyed).
1505  */
1506 abstract contract ERC721Burnable is Context, ERC721 {
1507     /**
1508      * @dev Burns `tokenId`. See {ERC721-_burn}.
1509      *
1510      * Requirements:
1511      *
1512      * - The caller must own `tokenId` or be an approved operator.
1513      */
1514     function burn(uint256 tokenId) public virtual {
1515         //solhint-disable-next-line max-line-length
1516         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1517         _burn(tokenId);
1518     }
1519 }
1520 
1521 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1522 
1523 
1524 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1525 
1526 pragma solidity ^0.8.0;
1527 
1528 
1529 
1530 /**
1531  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1532  * enumerability of all the token ids in the contract as well as all token ids owned by each
1533  * account.
1534  */
1535 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1536     // Mapping from owner to list of owned token IDs
1537     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1538 
1539     // Mapping from token ID to index of the owner tokens list
1540     mapping(uint256 => uint256) private _ownedTokensIndex;
1541 
1542     // Array with all token ids, used for enumeration
1543     uint256[] private _allTokens;
1544 
1545     // Mapping from token id to position in the allTokens array
1546     mapping(uint256 => uint256) private _allTokensIndex;
1547 
1548     /**
1549      * @dev See {IERC165-supportsInterface}.
1550      */
1551     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1552         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1553     }
1554 
1555     /**
1556      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1557      */
1558     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1559         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1560         return _ownedTokens[owner][index];
1561     }
1562 
1563     /**
1564      * @dev See {IERC721Enumerable-totalSupply}.
1565      */
1566     function totalSupply() public view virtual override returns (uint256) {
1567         return _allTokens.length;
1568     }
1569 
1570     /**
1571      * @dev See {IERC721Enumerable-tokenByIndex}.
1572      */
1573     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1574         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1575         return _allTokens[index];
1576     }
1577 
1578     /**
1579      * @dev Hook that is called before any token transfer. This includes minting
1580      * and burning.
1581      *
1582      * Calling conditions:
1583      *
1584      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1585      * transferred to `to`.
1586      * - When `from` is zero, `tokenId` will be minted for `to`.
1587      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1588      * - `from` cannot be the zero address.
1589      * - `to` cannot be the zero address.
1590      *
1591      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1592      */
1593     function _beforeTokenTransfer(
1594         address from,
1595         address to,
1596         uint256 tokenId
1597     ) internal virtual override {
1598         super._beforeTokenTransfer(from, to, tokenId);
1599 
1600         if (from == address(0)) {
1601             _addTokenToAllTokensEnumeration(tokenId);
1602         } else if (from != to) {
1603             _removeTokenFromOwnerEnumeration(from, tokenId);
1604         }
1605         if (to == address(0)) {
1606             _removeTokenFromAllTokensEnumeration(tokenId);
1607         } else if (to != from) {
1608             _addTokenToOwnerEnumeration(to, tokenId);
1609         }
1610     }
1611 
1612     /**
1613      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1614      * @param to address representing the new owner of the given token ID
1615      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1616      */
1617     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1618         uint256 length = ERC721.balanceOf(to);
1619         _ownedTokens[to][length] = tokenId;
1620         _ownedTokensIndex[tokenId] = length;
1621     }
1622 
1623     /**
1624      * @dev Private function to add a token to this extension's token tracking data structures.
1625      * @param tokenId uint256 ID of the token to be added to the tokens list
1626      */
1627     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1628         _allTokensIndex[tokenId] = _allTokens.length;
1629         _allTokens.push(tokenId);
1630     }
1631 
1632     /**
1633      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1634      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1635      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1636      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1637      * @param from address representing the previous owner of the given token ID
1638      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1639      */
1640     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1641         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1642         // then delete the last slot (swap and pop).
1643 
1644         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1645         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1646 
1647         // When the token to delete is the last token, the swap operation is unnecessary
1648         if (tokenIndex != lastTokenIndex) {
1649             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1650 
1651             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1652             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1653         }
1654 
1655         // This also deletes the contents at the last position of the array
1656         delete _ownedTokensIndex[tokenId];
1657         delete _ownedTokens[from][lastTokenIndex];
1658     }
1659 
1660     /**
1661      * @dev Private function to remove a token from this extension's token tracking data structures.
1662      * This has O(1) time complexity, but alters the order of the _allTokens array.
1663      * @param tokenId uint256 ID of the token to be removed from the tokens list
1664      */
1665     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1666         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1667         // then delete the last slot (swap and pop).
1668 
1669         uint256 lastTokenIndex = _allTokens.length - 1;
1670         uint256 tokenIndex = _allTokensIndex[tokenId];
1671 
1672         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1673         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1674         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1675         uint256 lastTokenId = _allTokens[lastTokenIndex];
1676 
1677         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1678         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1679 
1680         // This also deletes the contents at the last position of the array
1681         delete _allTokensIndex[tokenId];
1682         _allTokens.pop();
1683     }
1684 }
1685 
1686 // File: contracts/kumaBoss1.sol
1687 
1688 
1689 pragma solidity ^0.8.14;
1690 
1691 
1692 
1693 
1694 
1695 
1696 
1697 
1698 
1699 
1700 
1701 contract AwakenedKuma is ERC721, ERC721Enumerable, ERC721Burnable, Ownable, ReentrancyGuard {
1702     uint256 public maxWLMint = 10;
1703     uint256 public maxPublicMint = 10;
1704     uint256 totalMaxSupply = 5569;
1705 
1706     using Counters for Counters.Counter;
1707     string private _baseTokenURI;
1708     string public ext = ".json";
1709     bytes32 public whitelistMerkleRoot;
1710     bytes32 public secCheck = 0xa29ca91f3abb3cc4828f55a8f47a2a5fd7610f868f6bc5f9f91e59d768663f2b;
1711     bool public publicSwitch = false;
1712     bool public whitelistSwitch = false;
1713     bool public holderSwitch = false;
1714     Counters.Counter private _tokenIdCounter;
1715 
1716     constructor() ERC721("AwakenedKuma", "AK") {
1717     }
1718 
1719     function holderMint(bytes32[] calldata _merkleProof,bytes calldata checkID) external payable nonReentrant {
1720         // _tokenIdCounter.increment();
1721         require(holderSwitch == true,"Holder mint is paused");
1722         uint[] memory kumaID;
1723         kumaID = decodeID(checkID);
1724         require(totalSupply() + kumaID.length <= totalMaxSupply,"Max Kuma exceeded");
1725         require(whitelistValidity(_merkleProof), "Invalid proof");
1726         for(uint i; i < kumaID.length; i++ ){
1727             require(!_exists(kumaID[i]),"Kuma had Awakened");
1728             _safeMint(msg.sender, kumaID[i]);
1729         }
1730     }
1731 
1732     function wlMint(bytes32[] calldata _merkleProof, uint256 awakenNum) external payable nonReentrant{
1733         require(whitelistSwitch == true,"WL mint is paused");
1734         require(awakenNum > 0, "Mint qty should be over 0");
1735         require(awakenNum <= maxWLMint, "Max mint per transaction exceeded");
1736         require(totalSupply() + awakenNum <= totalMaxSupply,"Max Kuma exceeded");
1737         require(whitelistValidity(_merkleProof), "Invalid proof");
1738         uint256[] memory kumaID = new uint256[](awakenNum);
1739         uint256 tokenID = _tokenIdCounter.current();
1740         for(uint i; i< awakenNum; i++){
1741           while(tokenID < totalMaxSupply){
1742              if(!_exists(tokenID)){
1743                 kumaID[i] = tokenID;
1744                 _tokenIdCounter.increment();
1745                 break;
1746              }
1747              _tokenIdCounter.increment();
1748             }
1749         }
1750         for(uint i; i < kumaID.length; i++ ){
1751             require(!_exists(kumaID[i]),"Kuma had Awakened");
1752             _safeMint(msg.sender, kumaID[i]);
1753         }
1754 
1755     }
1756 
1757     function publicMint(uint256 awakenNum) external payable nonReentrant{
1758         require(publicSwitch == true,"Public mint is paused");
1759         require(awakenNum <= maxPublicMint, "Max mint per transaction exceeded");
1760         require(totalSupply() + awakenNum <= totalMaxSupply,"Max Kuma exceeded");
1761         uint256[] memory kumaID = new uint256[](awakenNum);
1762         uint256 tokenID = _tokenIdCounter.current();
1763         for(uint i; i< awakenNum; i++){
1764           while(tokenID < totalMaxSupply){
1765              if(!_exists(tokenID)){
1766                 kumaID[i] = tokenID;
1767                 _tokenIdCounter.increment();
1768                 break;
1769              }
1770              _tokenIdCounter.increment();
1771             }
1772         }
1773         for(uint i; i < kumaID.length; i++ ){
1774             require(!_exists(kumaID[i]),"Kuma had Awakened");
1775             _safeMint(msg.sender, kumaID[i]);
1776         }
1777 
1778     }
1779 
1780     function ownerMint(address to, uint256 awakenMint) external onlyOwner{
1781         require(totalSupply() + awakenMint <= totalMaxSupply, "Max mint per transaction exceeded");
1782         uint256[] memory kumaID = new uint256[](awakenMint);
1783         uint256 tokenID = _tokenIdCounter.current();
1784         for(uint i; i< awakenMint; i++){
1785           while(tokenID < totalMaxSupply){
1786              if(!_exists(tokenID)){
1787                 kumaID[i] = tokenID;
1788                 _tokenIdCounter.increment();
1789                 break;
1790              }
1791              _tokenIdCounter.increment();
1792             }
1793         }
1794         for(uint i; i < kumaID.length; i++ ){
1795             require(!_exists(kumaID[i]),"Kuma had Awakened");
1796             _safeMint(to, kumaID[i]);
1797         }
1798     }
1799     
1800     function setTotalSupply(uint256 _totalMaxSupply) external onlyOwner {
1801       totalMaxSupply = _totalMaxSupply; 
1802     }
1803     
1804     function setSecCheck(bytes32 _secCheck) external onlyOwner{
1805       secCheck = _secCheck;
1806     }
1807 
1808     function pausePublicMint() external onlyOwner {
1809       publicSwitch = !publicSwitch; 
1810     }
1811 
1812     function pauseWhitelistMint() external onlyOwner {
1813       whitelistSwitch = !whitelistSwitch; 
1814     }
1815 
1816     function pauseHolderMint() external onlyOwner {
1817       holderSwitch = !holderSwitch; 
1818     }
1819 
1820     function decodeID(bytes calldata data) internal view returns(uint[] memory arr){
1821         bytes32 hash;
1822         uint sec;
1823         uint[] memory check;
1824         (sec, check) = abi.decode(data, (uint, uint[]));
1825         hash = keccak256(abi.encodePacked(sec));
1826         require(hash == secCheck, "The Hash is incorrect");
1827         arr = check;
1828     } 
1829 
1830     function setWhitelistMerkleRoot(bytes32 _whitelistMerkleRoot) external onlyOwner {
1831         whitelistMerkleRoot = _whitelistMerkleRoot;
1832     }
1833 
1834     function whitelistValidity(bytes32[] calldata _merkleProof) public view returns (bool){
1835         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1836         require(MerkleProof.verify(_merkleProof, whitelistMerkleRoot, leaf), "Incorrect proof");
1837         return true; 
1838     }
1839 
1840     function burnKuma(uint256 tokenId) public onlyOwner {
1841         require(_exists(tokenId),"Kuma doesn't exist");
1842         _burn(tokenId);
1843     }
1844 
1845     function _baseURI() internal view virtual override returns (string memory) {
1846       return _baseTokenURI;
1847     }
1848     
1849     function setBaseURI(string calldata baseURI) public onlyOwner {
1850       _baseTokenURI = baseURI;
1851     }
1852 
1853  /**
1854   * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1855   */
1856   function tokenURI(uint tokenId) public view virtual override returns (string memory) {
1857      require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
1858       string memory currentBaseURI = _baseURI();
1859       return bytes(currentBaseURI).length > 0
1860           ? string(abi.encodePacked(currentBaseURI, Strings.toString(tokenId), ext))
1861           : "";
1862   }
1863 
1864     // The following functions are overrides required by Solidity.
1865 
1866     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1867         internal
1868         override(ERC721, ERC721Enumerable)
1869     {
1870         super._beforeTokenTransfer(from, to, tokenId);
1871     }
1872 
1873     function supportsInterface(bytes4 interfaceId)
1874         public
1875         view
1876         override(ERC721, ERC721Enumerable)
1877         returns (bool)
1878     {
1879         return super.supportsInterface(interfaceId);
1880     }
1881 }