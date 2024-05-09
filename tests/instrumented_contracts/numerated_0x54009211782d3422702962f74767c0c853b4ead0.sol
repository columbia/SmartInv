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
217 // File: @openzeppelin/contracts/utils/Counters.sol
218 
219 
220 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
221 
222 pragma solidity ^0.8.0;
223 
224 /**
225  * @title Counters
226  * @author Matt Condon (@shrugs)
227  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
228  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
229  *
230  * Include with `using Counters for Counters.Counter;`
231  */
232 library Counters {
233     struct Counter {
234         // This variable should never be directly accessed by users of the library: interactions must be restricted to
235         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
236         // this feature: see https://github.com/ethereum/solidity/issues/4637
237         uint256 _value; // default: 0
238     }
239 
240     function current(Counter storage counter) internal view returns (uint256) {
241         return counter._value;
242     }
243 
244     function increment(Counter storage counter) internal {
245         unchecked {
246             counter._value += 1;
247         }
248     }
249 
250     function decrement(Counter storage counter) internal {
251         uint256 value = counter._value;
252         require(value > 0, "Counter: decrement overflow");
253         unchecked {
254             counter._value = value - 1;
255         }
256     }
257 
258     function reset(Counter storage counter) internal {
259         counter._value = 0;
260     }
261 }
262 
263 // File: @openzeppelin/contracts/utils/Strings.sol
264 
265 
266 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
267 
268 pragma solidity ^0.8.0;
269 
270 /**
271  * @dev String operations.
272  */
273 library Strings {
274     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
275     uint8 private constant _ADDRESS_LENGTH = 20;
276 
277     /**
278      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
279      */
280     function toString(uint256 value) internal pure returns (string memory) {
281         // Inspired by OraclizeAPI's implementation - MIT licence
282         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
283 
284         if (value == 0) {
285             return "0";
286         }
287         uint256 temp = value;
288         uint256 digits;
289         while (temp != 0) {
290             digits++;
291             temp /= 10;
292         }
293         bytes memory buffer = new bytes(digits);
294         while (value != 0) {
295             digits -= 1;
296             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
297             value /= 10;
298         }
299         return string(buffer);
300     }
301 
302     /**
303      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
304      */
305     function toHexString(uint256 value) internal pure returns (string memory) {
306         if (value == 0) {
307             return "0x00";
308         }
309         uint256 temp = value;
310         uint256 length = 0;
311         while (temp != 0) {
312             length++;
313             temp >>= 8;
314         }
315         return toHexString(value, length);
316     }
317 
318     /**
319      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
320      */
321     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
322         bytes memory buffer = new bytes(2 * length + 2);
323         buffer[0] = "0";
324         buffer[1] = "x";
325         for (uint256 i = 2 * length + 1; i > 1; --i) {
326             buffer[i] = _HEX_SYMBOLS[value & 0xf];
327             value >>= 4;
328         }
329         require(value == 0, "Strings: hex length insufficient");
330         return string(buffer);
331     }
332 
333     /**
334      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
335      */
336     function toHexString(address addr) internal pure returns (string memory) {
337         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
338     }
339 }
340 
341 // File: @openzeppelin/contracts/utils/Context.sol
342 
343 
344 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
345 
346 pragma solidity ^0.8.0;
347 
348 /**
349  * @dev Provides information about the current execution context, including the
350  * sender of the transaction and its data. While these are generally available
351  * via msg.sender and msg.data, they should not be accessed in such a direct
352  * manner, since when dealing with meta-transactions the account sending and
353  * paying for execution may not be the actual sender (as far as an application
354  * is concerned).
355  *
356  * This contract is only required for intermediate, library-like contracts.
357  */
358 abstract contract Context {
359     function _msgSender() internal view virtual returns (address) {
360         return msg.sender;
361     }
362 
363     function _msgData() internal view virtual returns (bytes calldata) {
364         return msg.data;
365     }
366 }
367 
368 // File: @openzeppelin/contracts/access/Ownable.sol
369 
370 
371 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
372 
373 pragma solidity ^0.8.0;
374 
375 
376 /**
377  * @dev Contract module which provides a basic access control mechanism, where
378  * there is an account (an owner) that can be granted exclusive access to
379  * specific functions.
380  *
381  * By default, the owner account will be the one that deploys the contract. This
382  * can later be changed with {transferOwnership}.
383  *
384  * This module is used through inheritance. It will make available the modifier
385  * `onlyOwner`, which can be applied to your functions to restrict their use to
386  * the owner.
387  */
388 abstract contract Ownable is Context {
389     address private _owner;
390 
391     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
392 
393     /**
394      * @dev Initializes the contract setting the deployer as the initial owner.
395      */
396     constructor() {
397         _transferOwnership(_msgSender());
398     }
399 
400     /**
401      * @dev Throws if called by any account other than the owner.
402      */
403     modifier onlyOwner() {
404         _checkOwner();
405         _;
406     }
407 
408     /**
409      * @dev Returns the address of the current owner.
410      */
411     function owner() public view virtual returns (address) {
412         return _owner;
413     }
414 
415     /**
416      * @dev Throws if the sender is not the owner.
417      */
418     function _checkOwner() internal view virtual {
419         require(owner() == _msgSender(), "Ownable: caller is not the owner");
420     }
421 
422     /**
423      * @dev Leaves the contract without owner. It will not be possible to call
424      * `onlyOwner` functions anymore. Can only be called by the current owner.
425      *
426      * NOTE: Renouncing ownership will leave the contract without an owner,
427      * thereby removing any functionality that is only available to the owner.
428      */
429     function renounceOwnership() public virtual onlyOwner {
430         _transferOwnership(address(0));
431     }
432 
433     /**
434      * @dev Transfers ownership of the contract to a new account (`newOwner`).
435      * Can only be called by the current owner.
436      */
437     function transferOwnership(address newOwner) public virtual onlyOwner {
438         require(newOwner != address(0), "Ownable: new owner is the zero address");
439         _transferOwnership(newOwner);
440     }
441 
442     /**
443      * @dev Transfers ownership of the contract to a new account (`newOwner`).
444      * Internal function without access restriction.
445      */
446     function _transferOwnership(address newOwner) internal virtual {
447         address oldOwner = _owner;
448         _owner = newOwner;
449         emit OwnershipTransferred(oldOwner, newOwner);
450     }
451 }
452 
453 // File: @openzeppelin/contracts/utils/Address.sol
454 
455 
456 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
457 
458 pragma solidity ^0.8.1;
459 
460 /**
461  * @dev Collection of functions related to the address type
462  */
463 library Address {
464     /**
465      * @dev Returns true if `account` is a contract.
466      *
467      * [IMPORTANT]
468      * ====
469      * It is unsafe to assume that an address for which this function returns
470      * false is an externally-owned account (EOA) and not a contract.
471      *
472      * Among others, `isContract` will return false for the following
473      * types of addresses:
474      *
475      *  - an externally-owned account
476      *  - a contract in construction
477      *  - an address where a contract will be created
478      *  - an address where a contract lived, but was destroyed
479      * ====
480      *
481      * [IMPORTANT]
482      * ====
483      * You shouldn't rely on `isContract` to protect against flash loan attacks!
484      *
485      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
486      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
487      * constructor.
488      * ====
489      */
490     function isContract(address account) internal view returns (bool) {
491         // This method relies on extcodesize/address.code.length, which returns 0
492         // for contracts in construction, since the code is only stored at the end
493         // of the constructor execution.
494 
495         return account.code.length > 0;
496     }
497 
498     /**
499      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
500      * `recipient`, forwarding all available gas and reverting on errors.
501      *
502      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
503      * of certain opcodes, possibly making contracts go over the 2300 gas limit
504      * imposed by `transfer`, making them unable to receive funds via
505      * `transfer`. {sendValue} removes this limitation.
506      *
507      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
508      *
509      * IMPORTANT: because control is transferred to `recipient`, care must be
510      * taken to not create reentrancy vulnerabilities. Consider using
511      * {ReentrancyGuard} or the
512      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
513      */
514     function sendValue(address payable recipient, uint256 amount) internal {
515         require(address(this).balance >= amount, "Address: insufficient balance");
516 
517         (bool success, ) = recipient.call{value: amount}("");
518         require(success, "Address: unable to send value, recipient may have reverted");
519     }
520 
521     /**
522      * @dev Performs a Solidity function call using a low level `call`. A
523      * plain `call` is an unsafe replacement for a function call: use this
524      * function instead.
525      *
526      * If `target` reverts with a revert reason, it is bubbled up by this
527      * function (like regular Solidity function calls).
528      *
529      * Returns the raw returned data. To convert to the expected return value,
530      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
531      *
532      * Requirements:
533      *
534      * - `target` must be a contract.
535      * - calling `target` with `data` must not revert.
536      *
537      * _Available since v3.1._
538      */
539     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
540         return functionCall(target, data, "Address: low-level call failed");
541     }
542 
543     /**
544      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
545      * `errorMessage` as a fallback revert reason when `target` reverts.
546      *
547      * _Available since v3.1._
548      */
549     function functionCall(
550         address target,
551         bytes memory data,
552         string memory errorMessage
553     ) internal returns (bytes memory) {
554         return functionCallWithValue(target, data, 0, errorMessage);
555     }
556 
557     /**
558      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
559      * but also transferring `value` wei to `target`.
560      *
561      * Requirements:
562      *
563      * - the calling contract must have an ETH balance of at least `value`.
564      * - the called Solidity function must be `payable`.
565      *
566      * _Available since v3.1._
567      */
568     function functionCallWithValue(
569         address target,
570         bytes memory data,
571         uint256 value
572     ) internal returns (bytes memory) {
573         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
574     }
575 
576     /**
577      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
578      * with `errorMessage` as a fallback revert reason when `target` reverts.
579      *
580      * _Available since v3.1._
581      */
582     function functionCallWithValue(
583         address target,
584         bytes memory data,
585         uint256 value,
586         string memory errorMessage
587     ) internal returns (bytes memory) {
588         require(address(this).balance >= value, "Address: insufficient balance for call");
589         require(isContract(target), "Address: call to non-contract");
590 
591         (bool success, bytes memory returndata) = target.call{value: value}(data);
592         return verifyCallResult(success, returndata, errorMessage);
593     }
594 
595     /**
596      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
597      * but performing a static call.
598      *
599      * _Available since v3.3._
600      */
601     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
602         return functionStaticCall(target, data, "Address: low-level static call failed");
603     }
604 
605     /**
606      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
607      * but performing a static call.
608      *
609      * _Available since v3.3._
610      */
611     function functionStaticCall(
612         address target,
613         bytes memory data,
614         string memory errorMessage
615     ) internal view returns (bytes memory) {
616         require(isContract(target), "Address: static call to non-contract");
617 
618         (bool success, bytes memory returndata) = target.staticcall(data);
619         return verifyCallResult(success, returndata, errorMessage);
620     }
621 
622     /**
623      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
624      * but performing a delegate call.
625      *
626      * _Available since v3.4._
627      */
628     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
629         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
630     }
631 
632     /**
633      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
634      * but performing a delegate call.
635      *
636      * _Available since v3.4._
637      */
638     function functionDelegateCall(
639         address target,
640         bytes memory data,
641         string memory errorMessage
642     ) internal returns (bytes memory) {
643         require(isContract(target), "Address: delegate call to non-contract");
644 
645         (bool success, bytes memory returndata) = target.delegatecall(data);
646         return verifyCallResult(success, returndata, errorMessage);
647     }
648 
649     /**
650      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
651      * revert reason using the provided one.
652      *
653      * _Available since v4.3._
654      */
655     function verifyCallResult(
656         bool success,
657         bytes memory returndata,
658         string memory errorMessage
659     ) internal pure returns (bytes memory) {
660         if (success) {
661             return returndata;
662         } else {
663             // Look for revert reason and bubble it up if present
664             if (returndata.length > 0) {
665                 // The easiest way to bubble the revert reason is using memory via assembly
666                 /// @solidity memory-safe-assembly
667                 assembly {
668                     let returndata_size := mload(returndata)
669                     revert(add(32, returndata), returndata_size)
670                 }
671             } else {
672                 revert(errorMessage);
673             }
674         }
675     }
676 }
677 
678 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
679 
680 
681 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
682 
683 pragma solidity ^0.8.0;
684 
685 /**
686  * @title ERC721 token receiver interface
687  * @dev Interface for any contract that wants to support safeTransfers
688  * from ERC721 asset contracts.
689  */
690 interface IERC721Receiver {
691     /**
692      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
693      * by `operator` from `from`, this function is called.
694      *
695      * It must return its Solidity selector to confirm the token transfer.
696      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
697      *
698      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
699      */
700     function onERC721Received(
701         address operator,
702         address from,
703         uint256 tokenId,
704         bytes calldata data
705     ) external returns (bytes4);
706 }
707 
708 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
709 
710 
711 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
712 
713 pragma solidity ^0.8.0;
714 
715 /**
716  * @dev Interface of the ERC165 standard, as defined in the
717  * https://eips.ethereum.org/EIPS/eip-165[EIP].
718  *
719  * Implementers can declare support of contract interfaces, which can then be
720  * queried by others ({ERC165Checker}).
721  *
722  * For an implementation, see {ERC165}.
723  */
724 interface IERC165 {
725     /**
726      * @dev Returns true if this contract implements the interface defined by
727      * `interfaceId`. See the corresponding
728      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
729      * to learn more about how these ids are created.
730      *
731      * This function call must use less than 30 000 gas.
732      */
733     function supportsInterface(bytes4 interfaceId) external view returns (bool);
734 }
735 
736 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
737 
738 
739 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
740 
741 pragma solidity ^0.8.0;
742 
743 
744 /**
745  * @dev Interface for the NFT Royalty Standard.
746  *
747  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
748  * support for royalty payments across all NFT marketplaces and ecosystem participants.
749  *
750  * _Available since v4.5._
751  */
752 interface IERC2981 is IERC165 {
753     /**
754      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
755      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
756      */
757     function royaltyInfo(uint256 tokenId, uint256 salePrice)
758         external
759         view
760         returns (address receiver, uint256 royaltyAmount);
761 }
762 
763 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
764 
765 
766 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
767 
768 pragma solidity ^0.8.0;
769 
770 
771 /**
772  * @dev Implementation of the {IERC165} interface.
773  *
774  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
775  * for the additional interface id that will be supported. For example:
776  *
777  * ```solidity
778  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
779  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
780  * }
781  * ```
782  *
783  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
784  */
785 abstract contract ERC165 is IERC165 {
786     /**
787      * @dev See {IERC165-supportsInterface}.
788      */
789     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
790         return interfaceId == type(IERC165).interfaceId;
791     }
792 }
793 
794 // File: @openzeppelin/contracts/token/common/ERC2981.sol
795 
796 
797 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
798 
799 pragma solidity ^0.8.0;
800 
801 
802 
803 /**
804  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
805  *
806  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
807  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
808  *
809  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
810  * fee is specified in basis points by default.
811  *
812  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
813  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
814  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
815  *
816  * _Available since v4.5._
817  */
818 abstract contract ERC2981 is IERC2981, ERC165 {
819     struct RoyaltyInfo {
820         address receiver;
821         uint96 royaltyFraction;
822     }
823 
824     RoyaltyInfo private _defaultRoyaltyInfo;
825     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
826 
827     /**
828      * @dev See {IERC165-supportsInterface}.
829      */
830     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
831         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
832     }
833 
834     /**
835      * @inheritdoc IERC2981
836      */
837     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
838         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
839 
840         if (royalty.receiver == address(0)) {
841             royalty = _defaultRoyaltyInfo;
842         }
843 
844         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
845 
846         return (royalty.receiver, royaltyAmount);
847     }
848 
849     /**
850      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
851      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
852      * override.
853      */
854     function _feeDenominator() internal pure virtual returns (uint96) {
855         return 10000;
856     }
857 
858     /**
859      * @dev Sets the royalty information that all ids in this contract will default to.
860      *
861      * Requirements:
862      *
863      * - `receiver` cannot be the zero address.
864      * - `feeNumerator` cannot be greater than the fee denominator.
865      */
866     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
867         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
868         require(receiver != address(0), "ERC2981: invalid receiver");
869 
870         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
871     }
872 
873     /**
874      * @dev Removes default royalty information.
875      */
876     function _deleteDefaultRoyalty() internal virtual {
877         delete _defaultRoyaltyInfo;
878     }
879 
880     /**
881      * @dev Sets the royalty information for a specific token id, overriding the global default.
882      *
883      * Requirements:
884      *
885      * - `receiver` cannot be the zero address.
886      * - `feeNumerator` cannot be greater than the fee denominator.
887      */
888     function _setTokenRoyalty(
889         uint256 tokenId,
890         address receiver,
891         uint96 feeNumerator
892     ) internal virtual {
893         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
894         require(receiver != address(0), "ERC2981: Invalid parameters");
895 
896         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
897     }
898 
899     /**
900      * @dev Resets royalty information for the token id back to the global default.
901      */
902     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
903         delete _tokenRoyaltyInfo[tokenId];
904     }
905 }
906 
907 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
908 
909 
910 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
911 
912 pragma solidity ^0.8.0;
913 
914 
915 /**
916  * @dev Required interface of an ERC721 compliant contract.
917  */
918 interface IERC721 is IERC165 {
919     /**
920      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
921      */
922     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
923 
924     /**
925      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
926      */
927     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
928 
929     /**
930      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
931      */
932     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
933 
934     /**
935      * @dev Returns the number of tokens in ``owner``'s account.
936      */
937     function balanceOf(address owner) external view returns (uint256 balance);
938 
939     /**
940      * @dev Returns the owner of the `tokenId` token.
941      *
942      * Requirements:
943      *
944      * - `tokenId` must exist.
945      */
946     function ownerOf(uint256 tokenId) external view returns (address owner);
947 
948     /**
949      * @dev Safely transfers `tokenId` token from `from` to `to`.
950      *
951      * Requirements:
952      *
953      * - `from` cannot be the zero address.
954      * - `to` cannot be the zero address.
955      * - `tokenId` token must exist and be owned by `from`.
956      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
957      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
958      *
959      * Emits a {Transfer} event.
960      */
961     function safeTransferFrom(
962         address from,
963         address to,
964         uint256 tokenId,
965         bytes calldata data
966     ) external;
967 
968     /**
969      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
970      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
971      *
972      * Requirements:
973      *
974      * - `from` cannot be the zero address.
975      * - `to` cannot be the zero address.
976      * - `tokenId` token must exist and be owned by `from`.
977      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
978      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
979      *
980      * Emits a {Transfer} event.
981      */
982     function safeTransferFrom(
983         address from,
984         address to,
985         uint256 tokenId
986     ) external;
987 
988     /**
989      * @dev Transfers `tokenId` token from `from` to `to`.
990      *
991      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
992      *
993      * Requirements:
994      *
995      * - `from` cannot be the zero address.
996      * - `to` cannot be the zero address.
997      * - `tokenId` token must be owned by `from`.
998      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
999      *
1000      * Emits a {Transfer} event.
1001      */
1002     function transferFrom(
1003         address from,
1004         address to,
1005         uint256 tokenId
1006     ) external;
1007 
1008     /**
1009      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1010      * The approval is cleared when the token is transferred.
1011      *
1012      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1013      *
1014      * Requirements:
1015      *
1016      * - The caller must own the token or be an approved operator.
1017      * - `tokenId` must exist.
1018      *
1019      * Emits an {Approval} event.
1020      */
1021     function approve(address to, uint256 tokenId) external;
1022 
1023     /**
1024      * @dev Approve or remove `operator` as an operator for the caller.
1025      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1026      *
1027      * Requirements:
1028      *
1029      * - The `operator` cannot be the caller.
1030      *
1031      * Emits an {ApprovalForAll} event.
1032      */
1033     function setApprovalForAll(address operator, bool _approved) external;
1034 
1035     /**
1036      * @dev Returns the account approved for `tokenId` token.
1037      *
1038      * Requirements:
1039      *
1040      * - `tokenId` must exist.
1041      */
1042     function getApproved(uint256 tokenId) external view returns (address operator);
1043 
1044     /**
1045      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1046      *
1047      * See {setApprovalForAll}
1048      */
1049     function isApprovedForAll(address owner, address operator) external view returns (bool);
1050 }
1051 
1052 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1053 
1054 
1055 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1056 
1057 pragma solidity ^0.8.0;
1058 
1059 
1060 /**
1061  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1062  * @dev See https://eips.ethereum.org/EIPS/eip-721
1063  */
1064 interface IERC721Metadata is IERC721 {
1065     /**
1066      * @dev Returns the token collection name.
1067      */
1068     function name() external view returns (string memory);
1069 
1070     /**
1071      * @dev Returns the token collection symbol.
1072      */
1073     function symbol() external view returns (string memory);
1074 
1075     /**
1076      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1077      */
1078     function tokenURI(uint256 tokenId) external view returns (string memory);
1079 }
1080 
1081 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1082 
1083 
1084 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
1085 
1086 pragma solidity ^0.8.0;
1087 
1088 
1089 
1090 
1091 
1092 
1093 
1094 
1095 /**
1096  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1097  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1098  * {ERC721Enumerable}.
1099  */
1100 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1101     using Address for address;
1102     using Strings for uint256;
1103 
1104     // Token name
1105     string private _name;
1106 
1107     // Token symbol
1108     string private _symbol;
1109 
1110     // Mapping from token ID to owner address
1111     mapping(uint256 => address) private _owners;
1112 
1113     // Mapping owner address to token count
1114     mapping(address => uint256) private _balances;
1115 
1116     // Mapping from token ID to approved address
1117     mapping(uint256 => address) private _tokenApprovals;
1118 
1119     // Mapping from owner to operator approvals
1120     mapping(address => mapping(address => bool)) private _operatorApprovals;
1121 
1122     /**
1123      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1124      */
1125     constructor(string memory name_, string memory symbol_) {
1126         _name = name_;
1127         _symbol = symbol_;
1128     }
1129 
1130     /**
1131      * @dev See {IERC165-supportsInterface}.
1132      */
1133     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1134         return
1135             interfaceId == type(IERC721).interfaceId ||
1136             interfaceId == type(IERC721Metadata).interfaceId ||
1137             super.supportsInterface(interfaceId);
1138     }
1139 
1140     /**
1141      * @dev See {IERC721-balanceOf}.
1142      */
1143     function balanceOf(address owner) public view virtual override returns (uint256) {
1144         require(owner != address(0), "ERC721: address zero is not a valid owner");
1145         return _balances[owner];
1146     }
1147 
1148     /**
1149      * @dev See {IERC721-ownerOf}.
1150      */
1151     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1152         address owner = _owners[tokenId];
1153         require(owner != address(0), "ERC721: invalid token ID");
1154         return owner;
1155     }
1156 
1157     /**
1158      * @dev See {IERC721Metadata-name}.
1159      */
1160     function name() public view virtual override returns (string memory) {
1161         return _name;
1162     }
1163 
1164     /**
1165      * @dev See {IERC721Metadata-symbol}.
1166      */
1167     function symbol() public view virtual override returns (string memory) {
1168         return _symbol;
1169     }
1170 
1171     /**
1172      * @dev See {IERC721Metadata-tokenURI}.
1173      */
1174     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1175         _requireMinted(tokenId);
1176 
1177         string memory baseURI = _baseURI();
1178         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1179     }
1180 
1181     /**
1182      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1183      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1184      * by default, can be overridden in child contracts.
1185      */
1186     function _baseURI() internal view virtual returns (string memory) {
1187         return "";
1188     }
1189 
1190     /**
1191      * @dev See {IERC721-approve}.
1192      */
1193     function approve(address to, uint256 tokenId) public virtual override {
1194         address owner = ERC721.ownerOf(tokenId);
1195         require(to != owner, "ERC721: approval to current owner");
1196 
1197         require(
1198             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1199             "ERC721: approve caller is not token owner nor approved for all"
1200         );
1201 
1202         _approve(to, tokenId);
1203     }
1204 
1205     /**
1206      * @dev See {IERC721-getApproved}.
1207      */
1208     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1209         _requireMinted(tokenId);
1210 
1211         return _tokenApprovals[tokenId];
1212     }
1213 
1214     /**
1215      * @dev See {IERC721-setApprovalForAll}.
1216      */
1217     function setApprovalForAll(address operator, bool approved) public virtual override {
1218         _setApprovalForAll(_msgSender(), operator, approved);
1219     }
1220 
1221     /**
1222      * @dev See {IERC721-isApprovedForAll}.
1223      */
1224     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1225         return _operatorApprovals[owner][operator];
1226     }
1227 
1228     /**
1229      * @dev See {IERC721-transferFrom}.
1230      */
1231     function transferFrom(
1232         address from,
1233         address to,
1234         uint256 tokenId
1235     ) public virtual override {
1236         //solhint-disable-next-line max-line-length
1237         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1238 
1239         _transfer(from, to, tokenId);
1240     }
1241 
1242     /**
1243      * @dev See {IERC721-safeTransferFrom}.
1244      */
1245     function safeTransferFrom(
1246         address from,
1247         address to,
1248         uint256 tokenId
1249     ) public virtual override {
1250         safeTransferFrom(from, to, tokenId, "");
1251     }
1252 
1253     /**
1254      * @dev See {IERC721-safeTransferFrom}.
1255      */
1256     function safeTransferFrom(
1257         address from,
1258         address to,
1259         uint256 tokenId,
1260         bytes memory data
1261     ) public virtual override {
1262         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1263         _safeTransfer(from, to, tokenId, data);
1264     }
1265 
1266     /**
1267      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1268      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1269      *
1270      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1271      *
1272      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1273      * implement alternative mechanisms to perform token transfer, such as signature-based.
1274      *
1275      * Requirements:
1276      *
1277      * - `from` cannot be the zero address.
1278      * - `to` cannot be the zero address.
1279      * - `tokenId` token must exist and be owned by `from`.
1280      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1281      *
1282      * Emits a {Transfer} event.
1283      */
1284     function _safeTransfer(
1285         address from,
1286         address to,
1287         uint256 tokenId,
1288         bytes memory data
1289     ) internal virtual {
1290         _transfer(from, to, tokenId);
1291         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1292     }
1293 
1294     /**
1295      * @dev Returns whether `tokenId` exists.
1296      *
1297      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1298      *
1299      * Tokens start existing when they are minted (`_mint`),
1300      * and stop existing when they are burned (`_burn`).
1301      */
1302     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1303         return _owners[tokenId] != address(0);
1304     }
1305 
1306     /**
1307      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1308      *
1309      * Requirements:
1310      *
1311      * - `tokenId` must exist.
1312      */
1313     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1314         address owner = ERC721.ownerOf(tokenId);
1315         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1316     }
1317 
1318     /**
1319      * @dev Safely mints `tokenId` and transfers it to `to`.
1320      *
1321      * Requirements:
1322      *
1323      * - `tokenId` must not exist.
1324      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1325      *
1326      * Emits a {Transfer} event.
1327      */
1328     function _safeMint(address to, uint256 tokenId) internal virtual {
1329         _safeMint(to, tokenId, "");
1330     }
1331 
1332     /**
1333      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1334      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1335      */
1336     function _safeMint(
1337         address to,
1338         uint256 tokenId,
1339         bytes memory data
1340     ) internal virtual {
1341         _mint(to, tokenId);
1342         require(
1343             _checkOnERC721Received(address(0), to, tokenId, data),
1344             "ERC721: transfer to non ERC721Receiver implementer"
1345         );
1346     }
1347 
1348     /**
1349      * @dev Mints `tokenId` and transfers it to `to`.
1350      *
1351      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1352      *
1353      * Requirements:
1354      *
1355      * - `tokenId` must not exist.
1356      * - `to` cannot be the zero address.
1357      *
1358      * Emits a {Transfer} event.
1359      */
1360     function _mint(address to, uint256 tokenId) internal virtual {
1361         require(to != address(0), "ERC721: mint to the zero address");
1362         require(!_exists(tokenId), "ERC721: token already minted");
1363 
1364         _beforeTokenTransfer(address(0), to, tokenId);
1365 
1366         _balances[to] += 1;
1367         _owners[tokenId] = to;
1368 
1369         emit Transfer(address(0), to, tokenId);
1370 
1371         _afterTokenTransfer(address(0), to, tokenId);
1372     }
1373 
1374     /**
1375      * @dev Destroys `tokenId`.
1376      * The approval is cleared when the token is burned.
1377      *
1378      * Requirements:
1379      *
1380      * - `tokenId` must exist.
1381      *
1382      * Emits a {Transfer} event.
1383      */
1384     function _burn(uint256 tokenId) internal virtual {
1385         address owner = ERC721.ownerOf(tokenId);
1386 
1387         _beforeTokenTransfer(owner, address(0), tokenId);
1388 
1389         // Clear approvals
1390         _approve(address(0), tokenId);
1391 
1392         _balances[owner] -= 1;
1393         delete _owners[tokenId];
1394 
1395         emit Transfer(owner, address(0), tokenId);
1396 
1397         _afterTokenTransfer(owner, address(0), tokenId);
1398     }
1399 
1400     /**
1401      * @dev Transfers `tokenId` from `from` to `to`.
1402      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1403      *
1404      * Requirements:
1405      *
1406      * - `to` cannot be the zero address.
1407      * - `tokenId` token must be owned by `from`.
1408      *
1409      * Emits a {Transfer} event.
1410      */
1411     function _transfer(
1412         address from,
1413         address to,
1414         uint256 tokenId
1415     ) internal virtual {
1416         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1417         require(to != address(0), "ERC721: transfer to the zero address");
1418 
1419         _beforeTokenTransfer(from, to, tokenId);
1420 
1421         // Clear approvals from the previous owner
1422         _approve(address(0), tokenId);
1423 
1424         _balances[from] -= 1;
1425         _balances[to] += 1;
1426         _owners[tokenId] = to;
1427 
1428         emit Transfer(from, to, tokenId);
1429 
1430         _afterTokenTransfer(from, to, tokenId);
1431     }
1432 
1433     /**
1434      * @dev Approve `to` to operate on `tokenId`
1435      *
1436      * Emits an {Approval} event.
1437      */
1438     function _approve(address to, uint256 tokenId) internal virtual {
1439         _tokenApprovals[tokenId] = to;
1440         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1441     }
1442 
1443     /**
1444      * @dev Approve `operator` to operate on all of `owner` tokens
1445      *
1446      * Emits an {ApprovalForAll} event.
1447      */
1448     function _setApprovalForAll(
1449         address owner,
1450         address operator,
1451         bool approved
1452     ) internal virtual {
1453         require(owner != operator, "ERC721: approve to caller");
1454         _operatorApprovals[owner][operator] = approved;
1455         emit ApprovalForAll(owner, operator, approved);
1456     }
1457 
1458     /**
1459      * @dev Reverts if the `tokenId` has not been minted yet.
1460      */
1461     function _requireMinted(uint256 tokenId) internal view virtual {
1462         require(_exists(tokenId), "ERC721: invalid token ID");
1463     }
1464 
1465     /**
1466      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1467      * The call is not executed if the target address is not a contract.
1468      *
1469      * @param from address representing the previous owner of the given token ID
1470      * @param to target address that will receive the tokens
1471      * @param tokenId uint256 ID of the token to be transferred
1472      * @param data bytes optional data to send along with the call
1473      * @return bool whether the call correctly returned the expected magic value
1474      */
1475     function _checkOnERC721Received(
1476         address from,
1477         address to,
1478         uint256 tokenId,
1479         bytes memory data
1480     ) private returns (bool) {
1481         if (to.isContract()) {
1482             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1483                 return retval == IERC721Receiver.onERC721Received.selector;
1484             } catch (bytes memory reason) {
1485                 if (reason.length == 0) {
1486                     revert("ERC721: transfer to non ERC721Receiver implementer");
1487                 } else {
1488                     /// @solidity memory-safe-assembly
1489                     assembly {
1490                         revert(add(32, reason), mload(reason))
1491                     }
1492                 }
1493             }
1494         } else {
1495             return true;
1496         }
1497     }
1498 
1499     /**
1500      * @dev Hook that is called before any token transfer. This includes minting
1501      * and burning.
1502      *
1503      * Calling conditions:
1504      *
1505      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1506      * transferred to `to`.
1507      * - When `from` is zero, `tokenId` will be minted for `to`.
1508      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1509      * - `from` and `to` are never both zero.
1510      *
1511      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1512      */
1513     function _beforeTokenTransfer(
1514         address from,
1515         address to,
1516         uint256 tokenId
1517     ) internal virtual {}
1518 
1519     /**
1520      * @dev Hook that is called after any transfer of tokens. This includes
1521      * minting and burning.
1522      *
1523      * Calling conditions:
1524      *
1525      * - when `from` and `to` are both non-zero.
1526      * - `from` and `to` are never both zero.
1527      *
1528      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1529      */
1530     function _afterTokenTransfer(
1531         address from,
1532         address to,
1533         uint256 tokenId
1534     ) internal virtual {}
1535 }
1536 
1537 // File: contracts/goblin V2.sol
1538 
1539 
1540 /*
1541             .-'''-.                                                                          
1542            '   _    \            .---.               .---.                     _______       
1543          /   /` '.   \ /|        |   |.--.   _..._   |   |             _..._   \  ___ `'.    
1544   .--./).   |     \  ' ||        |   ||__| .'     '. |   |           .'     '.  ' |--.\  \   
1545  /.''\\ |   '      |  '||        |   |.--..   .-.   .|   |          .   .-.   . | |    \  '  
1546 | |  | |\    \     / / ||  __    |   ||  ||  '   '  ||   |    __    |  '   '  | | |     |  ' 
1547  \`-' /  `.   ` ..' /  ||/'__ '. |   ||  ||  |   |  ||   | .:--.'.  |  |   |  | | |     |  | 
1548  /("'`      '-...-'`   |:/`  '. '|   ||  ||  |   |  ||   |/ |   \ | |  |   |  | | |     ' .' 
1549  \ '---.               ||     | ||   ||  ||  |   |  ||   |`" __ | | |  |   |  | | |___.' /'  
1550   /'""'.\              ||\    / '|   ||__||  |   |  ||   | .'.''| | |  |   |  |/_______.'/   
1551  ||     ||             |/\'..' / '---'    |  |   |  |'---'/ /   | |_|  |   |  |\_______|/    
1552  \'. __//              '  `'-'`           |  |   |  |     \ \._,\ '/|  |   |  |              
1553   `'---'                                  '--'   '--'      `--'  `" '--'   '--'//By Elfoly
1554 **/
1555 
1556 pragma solidity >=0.7.0 <0.9.0;
1557 
1558 
1559 
1560 
1561 
1562 
1563 contract NFT_Utility is ERC721, ERC2981, Ownable {
1564   using Strings for uint256;
1565   using Counters for Counters.Counter;
1566 
1567   Counters.Counter private supply;
1568 
1569   string public uriPrefix = "ipfs://bafybeigj3s5h55bfinlzhhi2nlljmamdxllsj3mdydysheo5o4p7g5rxn4/";
1570   string public uriSuffix = ".json";
1571   string public contractURI;
1572   uint256 public maxSupply = 5000;
1573   uint256 public maxMintAmountPerWallet = 1;
1574   uint256 public cost = 0.01 ether;
1575   bytes32 public root;
1576   
1577 
1578 
1579   mapping(address => uint256) public mintedWallets;
1580 
1581   bool public isWhitelistMintPaused = true;
1582   bool public isPublicMintpaused = true;
1583 
1584 
1585  constructor(uint96 _royaltyFeesInBips, string memory _contractURI, bytes32 _root) ERC721("NFT_Utility", "NU") {
1586    setRoyaltyInfo(msg.sender, _royaltyFeesInBips);
1587    contractURI = _contractURI;
1588    root = _root ;
1589   }
1590   
1591 
1592   function totalSupply() public view returns (uint256) {
1593     return supply.current();
1594   }
1595 
1596 //mint functions
1597   function WhitelistMint(bytes32[] memory proof) public {
1598     uint256 _mintAmount = 1;
1599     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1600     require(!isWhitelistMintPaused, " whitelist mint is not open yet!");
1601     require(isValid(proof, keccak256(abi.encodePacked(msg.sender))), "Not whitlisted");
1602     require(mintedWallets[msg.sender] < 1, "Only one per wallet !");
1603     mintedWallets[msg.sender]++;
1604 
1605     _mintLoop(msg.sender, _mintAmount);
1606   }
1607 
1608   function isValid(bytes32[] memory proof, bytes32 leaf) public view returns (bool) {
1609     return MerkleProof.verify(proof, root, leaf);
1610   }
1611 
1612 
1613   function PublicMint(uint256 _mintAmount) public payable {
1614     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1615     require(!isPublicMintpaused, " mint is not open !");
1616     require(msg.value >= cost * _mintAmount , "Insufficient funds!");
1617 
1618     _mintLoop(msg.sender, _mintAmount);
1619   }
1620 
1621   function mintForOwner(uint256 _mintAmount, address _receiver) public onlyOwner {
1622     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1623 
1624     _mintLoop(_receiver, _mintAmount);
1625   }
1626 //
1627   function walletOfOwner(address _owner)
1628     public
1629     view
1630     returns (uint256[] memory)
1631   {
1632     uint256 ownerTokenCount = balanceOf(_owner);
1633     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1634     uint256 currentTokenId = 1;
1635     uint256 ownedTokenIndex = 0;
1636 
1637     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1638       address currentTokenOwner = ownerOf(currentTokenId);
1639 
1640       if (currentTokenOwner == _owner) {
1641         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1642 
1643         ownedTokenIndex++;
1644       }
1645 
1646       currentTokenId++;
1647     }
1648 
1649     return ownedTokenIds;
1650   }
1651 
1652   function tokenURI(uint256 _tokenId)
1653     public
1654     view
1655     virtual
1656     override
1657     returns (string memory)
1658   {
1659     require(
1660       _exists(_tokenId),
1661       "ERC721Metadata: URI query for nonexistent token"
1662     );
1663 
1664   
1665 
1666     string memory currentBaseURI = _baseURI();
1667     return bytes(currentBaseURI).length > 0
1668         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1669         : "";
1670   }
1671 
1672   
1673 
1674   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1675     uriPrefix = _uriPrefix;
1676   }
1677 
1678 
1679 
1680   function setisWhitelistMintPaused(bool _state) public onlyOwner {
1681     isWhitelistMintPaused = _state;
1682   }
1683   
1684   function setisPublicMintpaused(bool _state) public onlyOwner {
1685     isPublicMintpaused = _state;
1686   }
1687 
1688 
1689 
1690   function withdraw() public onlyOwner {
1691     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1692     require(os);
1693   }
1694 
1695   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1696     for (uint256 i = 0; i < _mintAmount; i++) {
1697       supply.increment();
1698       _safeMint(_receiver, supply.current());
1699     }
1700   }
1701 
1702   function _baseURI() internal view virtual override returns (string memory) {
1703     return uriPrefix;
1704   }
1705 
1706   function supportsInterface(bytes4 interfaceId) 
1707   public
1708   view
1709   override(ERC721, ERC2981)
1710   returns (bool)
1711   {
1712     return super.supportsInterface(interfaceId);
1713   }
1714 
1715     function setRoyaltyInfo(address _receiver, uint96 _royaltyFeesInBips) public onlyOwner {
1716       _setDefaultRoyalty(_receiver, _royaltyFeesInBips);
1717     }
1718 
1719     function setContractURI(string calldata _contractURI) public onlyOwner {
1720       contractURI = _contractURI;
1721     }
1722 
1723     
1724 }