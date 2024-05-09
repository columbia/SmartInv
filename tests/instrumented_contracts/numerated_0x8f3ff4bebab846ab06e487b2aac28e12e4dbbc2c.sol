1 // SPDX-License-Identifier: MIT
2 
3 // Author: Red
4 
5 // Genesis
6 
7 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
8 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
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
62     function processProof(bytes32[] memory proof, bytes32 leaf)
63         internal
64         pure
65         returns (bytes32)
66     {
67         bytes32 computedHash = leaf;
68         for (uint256 i = 0; i < proof.length; i++) {
69             computedHash = _hashPair(computedHash, proof[i]);
70         }
71         return computedHash;
72     }
73 
74     /**
75      * @dev Calldata version of {processProof}
76      *
77      * _Available since v4.7._
78      */
79     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf)
80         internal
81         pure
82         returns (bytes32)
83     {
84         bytes32 computedHash = leaf;
85         for (uint256 i = 0; i < proof.length; i++) {
86             computedHash = _hashPair(computedHash, proof[i]);
87         }
88         return computedHash;
89     }
90 
91     /**
92      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
93      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
94      *
95      * _Available since v4.7._
96      */
97     function multiProofVerify(
98         bytes32[] memory proof,
99         bool[] memory proofFlags,
100         bytes32 root,
101         bytes32[] memory leaves
102     ) internal pure returns (bool) {
103         return processMultiProof(proof, proofFlags, leaves) == root;
104     }
105 
106     /**
107      * @dev Calldata version of {multiProofVerify}
108      *
109      * _Available since v4.7._
110      */
111     function multiProofVerifyCalldata(
112         bytes32[] calldata proof,
113         bool[] calldata proofFlags,
114         bytes32 root,
115         bytes32[] memory leaves
116     ) internal pure returns (bool) {
117         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
118     }
119 
120     /**
121      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
122      * consuming from one or the other at each step according to the instructions given by
123      * `proofFlags`.
124      *
125      * _Available since v4.7._
126      */
127     function processMultiProof(
128         bytes32[] memory proof,
129         bool[] memory proofFlags,
130         bytes32[] memory leaves
131     ) internal pure returns (bytes32 merkleRoot) {
132         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
133         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
134         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
135         // the merkle tree.
136         uint256 leavesLen = leaves.length;
137         uint256 totalHashes = proofFlags.length;
138 
139         // Check proof validity.
140         require(
141             leavesLen + proof.length - 1 == totalHashes,
142             "MerkleProof: invalid multiproof"
143         );
144 
145         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
146         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
147         bytes32[] memory hashes = new bytes32[](totalHashes);
148         uint256 leafPos = 0;
149         uint256 hashPos = 0;
150         uint256 proofPos = 0;
151         // At each step, we compute the next hash using two values:
152         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
153         //   get the next hash.
154         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
155         //   `proof` array.
156         for (uint256 i = 0; i < totalHashes; i++) {
157             bytes32 a = leafPos < leavesLen
158                 ? leaves[leafPos++]
159                 : hashes[hashPos++];
160             bytes32 b = proofFlags[i]
161                 ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++]
162                 : proof[proofPos++];
163             hashes[i] = _hashPair(a, b);
164         }
165 
166         if (totalHashes > 0) {
167             return hashes[totalHashes - 1];
168         } else if (leavesLen > 0) {
169             return leaves[0];
170         } else {
171             return proof[0];
172         }
173     }
174 
175     /**
176      * @dev Calldata version of {processMultiProof}
177      *
178      * _Available since v4.7._
179      */
180     function processMultiProofCalldata(
181         bytes32[] calldata proof,
182         bool[] calldata proofFlags,
183         bytes32[] memory leaves
184     ) internal pure returns (bytes32 merkleRoot) {
185         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
186         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
187         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
188         // the merkle tree.
189         uint256 leavesLen = leaves.length;
190         uint256 totalHashes = proofFlags.length;
191 
192         // Check proof validity.
193         require(
194             leavesLen + proof.length - 1 == totalHashes,
195             "MerkleProof: invalid multiproof"
196         );
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
210             bytes32 a = leafPos < leavesLen
211                 ? leaves[leafPos++]
212                 : hashes[hashPos++];
213             bytes32 b = proofFlags[i]
214                 ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++]
215                 : proof[proofPos++];
216             hashes[i] = _hashPair(a, b);
217         }
218 
219         if (totalHashes > 0) {
220             return hashes[totalHashes - 1];
221         } else if (leavesLen > 0) {
222             return leaves[0];
223         } else {
224             return proof[0];
225         }
226     }
227 
228     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
229         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
230     }
231 
232     function _efficientHash(bytes32 a, bytes32 b)
233         private
234         pure
235         returns (bytes32 value)
236     {
237         /// @solidity memory-safe-assembly
238         assembly {
239             mstore(0x00, a)
240             mstore(0x20, b)
241             value := keccak256(0x00, 0x40)
242         }
243     }
244 }
245 
246 // File: @openzeppelin/contracts/utils/Counters.sol
247 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
248 
249 pragma solidity ^0.8.0;
250 
251 /**
252  * @title Counters
253  * @author Matt Condon (@shrugs)
254  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
255  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
256  *
257  * Include with `using Counters for Counters.Counter;`
258  */
259 library Counters {
260     struct Counter {
261         // This variable should never be directly accessed by users of the library: interactions must be restricted to
262         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
263         // this feature: see https://github.com/ethereum/solidity/issues/4637
264         uint256 _value; // default: 0
265     }
266 
267     function current(Counter storage counter) internal view returns (uint256) {
268         return counter._value;
269     }
270 
271     function increment(Counter storage counter) internal {
272         unchecked {
273             counter._value += 1;
274         }
275     }
276 
277     function decrement(Counter storage counter) internal {
278         uint256 value = counter._value;
279         require(value > 0, "Counter: decrement overflow");
280         unchecked {
281             counter._value = value - 1;
282         }
283     }
284 
285     function reset(Counter storage counter) internal {
286         counter._value = 0;
287     }
288 }
289 
290 // File: @openzeppelin/contracts/utils/Strings.sol
291 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
292 
293 pragma solidity ^0.8.0;
294 
295 /**
296  * @dev String operations.
297  */
298 library Strings {
299     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
300 
301     /**
302      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
303      */
304     function toString(uint256 value) internal pure returns (string memory) {
305         // Inspired by OraclizeAPI's implementation - MIT licence
306         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
307 
308         if (value == 0) {
309             return "0";
310         }
311         uint256 temp = value;
312         uint256 digits;
313         while (temp != 0) {
314             digits++;
315             temp /= 10;
316         }
317         bytes memory buffer = new bytes(digits);
318         while (value != 0) {
319             digits -= 1;
320             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
321             value /= 10;
322         }
323         return string(buffer);
324     }
325 
326     /**
327      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
328      */
329     function toHexString(uint256 value) internal pure returns (string memory) {
330         if (value == 0) {
331             return "0x00";
332         }
333         uint256 temp = value;
334         uint256 length = 0;
335         while (temp != 0) {
336             length++;
337             temp >>= 8;
338         }
339         return toHexString(value, length);
340     }
341 
342     /**
343      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
344      */
345     function toHexString(uint256 value, uint256 length)
346         internal
347         pure
348         returns (string memory)
349     {
350         bytes memory buffer = new bytes(2 * length + 2);
351         buffer[0] = "0";
352         buffer[1] = "x";
353         for (uint256 i = 2 * length + 1; i > 1; --i) {
354             buffer[i] = _HEX_SYMBOLS[value & 0xf];
355             value >>= 4;
356         }
357         require(value == 0, "Strings: hex length insufficient");
358         return string(buffer);
359     }
360 }
361 
362 // File: @openzeppelin/contracts/utils/Context.sol
363 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
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
388 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
389 
390 pragma solidity ^0.8.0;
391 
392 /**
393  * @dev Contract module which provides a basic access control mechanism, where
394  * there is an account (an owner) that can be granted exclusive access to
395  * specific functions.
396  *
397  * By default, the owner account will be the one that deploys the contract. This
398  * can later be changed with {transferOwnership}.
399  *
400  * This module is used through inheritance. It will make available the modifier
401  * `onlyOwner`, which can be applied to your functions to restrict their use to
402  * the owner.
403  */
404 abstract contract Ownable is Context {
405     address private _owner;
406 
407     event OwnershipTransferred(
408         address indexed previousOwner,
409         address indexed newOwner
410     );
411 
412     /**
413      * @dev Initializes the contract setting the deployer as the initial owner.
414      */
415     constructor() {
416         _transferOwnership(_msgSender());
417     }
418 
419     /**
420      * @dev Returns the address of the current owner.
421      */
422     function owner() public view virtual returns (address) {
423         return _owner;
424     }
425 
426     /**
427      * @dev Throws if called by any account other than the owner.
428      */
429     modifier onlyOwner() {
430         require(owner() == _msgSender(), "Ownable: caller is not the owner");
431         _;
432     }
433 
434     /**
435      * @dev Leaves the contract without owner. It will not be possible to call
436      * `onlyOwner` functions anymore. Can only be called by the current owner.
437      *
438      * NOTE: Renouncing ownership will leave the contract without an owner,
439      * thereby removing any functionality that is only available to the owner.
440      */
441     function renounceOwnership() public virtual onlyOwner {
442         _transferOwnership(address(0));
443     }
444 
445     /**
446      * @dev Transfers ownership of the contract to a new account (`newOwner`).
447      * Can only be called by the current owner.
448      */
449     function transferOwnership(address newOwner) public virtual onlyOwner {
450         require(
451             newOwner != address(0),
452             "Ownable: new owner is the zero address"
453         );
454         _transferOwnership(newOwner);
455     }
456 
457     /**
458      * @dev Transfers ownership of the contract to a new account (`newOwner`).
459      * Internal function without access restriction.
460      */
461     function _transferOwnership(address newOwner) internal virtual {
462         address oldOwner = _owner;
463         _owner = newOwner;
464         emit OwnershipTransferred(oldOwner, newOwner);
465     }
466 }
467 
468 // File: @openzeppelin/contracts/utils/Address.sol
469 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
470 
471 pragma solidity ^0.8.0;
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
493      */
494     function isContract(address account) internal view returns (bool) {
495         // This method relies on extcodesize, which returns 0 for contracts in
496         // construction, since the code is only stored at the end of the
497         // constructor execution.
498 
499         uint256 size;
500         assembly {
501             size := extcodesize(account)
502         }
503         return size > 0;
504     }
505 
506     /**
507      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
508      * `recipient`, forwarding all available gas and reverting on errors.
509      *
510      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
511      * of certain opcodes, possibly making contracts go over the 2300 gas limit
512      * imposed by `transfer`, making them unable to receive funds via
513      * `transfer`. {sendValue} removes this limitation.
514      *
515      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
516      *
517      * IMPORTANT: because control is transferred to `recipient`, care must be
518      * taken to not create reentrancy vulnerabilities. Consider using
519      * {ReentrancyGuard} or the
520      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
521      */
522     function sendValue(address payable recipient, uint256 amount) internal {
523         require(
524             address(this).balance >= amount,
525             "Address: insufficient balance"
526         );
527 
528         (bool success, ) = recipient.call{value: amount}("");
529         require(
530             success,
531             "Address: unable to send value, recipient may have reverted"
532         );
533     }
534 
535     /**
536      * @dev Performs a Solidity function call using a low level `call`. A
537      * plain `call` is an unsafe replacement for a function call: use this
538      * function instead.
539      *
540      * If `target` reverts with a revert reason, it is bubbled up by this
541      * function (like regular Solidity function calls).
542      *
543      * Returns the raw returned data. To convert to the expected return value,
544      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
545      *
546      * Requirements:
547      *
548      * - `target` must be a contract.
549      * - calling `target` with `data` must not revert.
550      *
551      * _Available since v3.1._
552      */
553     function functionCall(address target, bytes memory data)
554         internal
555         returns (bytes memory)
556     {
557         return functionCall(target, data, "Address: low-level call failed");
558     }
559 
560     /**
561      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
562      * `errorMessage` as a fallback revert reason when `target` reverts.
563      *
564      * _Available since v3.1._
565      */
566     function functionCall(
567         address target,
568         bytes memory data,
569         string memory errorMessage
570     ) internal returns (bytes memory) {
571         return functionCallWithValue(target, data, 0, errorMessage);
572     }
573 
574     /**
575      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
576      * but also transferring `value` wei to `target`.
577      *
578      * Requirements:
579      *
580      * - the calling contract must have an ETH balance of at least `value`.
581      * - the called Solidity function must be `payable`.
582      *
583      * _Available since v3.1._
584      */
585     function functionCallWithValue(
586         address target,
587         bytes memory data,
588         uint256 value
589     ) internal returns (bytes memory) {
590         return
591             functionCallWithValue(
592                 target,
593                 data,
594                 value,
595                 "Address: low-level call with value failed"
596             );
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
611         require(
612             address(this).balance >= value,
613             "Address: insufficient balance for call"
614         );
615         require(isContract(target), "Address: call to non-contract");
616 
617         (bool success, bytes memory returndata) = target.call{value: value}(
618             data
619         );
620         return verifyCallResult(success, returndata, errorMessage);
621     }
622 
623     /**
624      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
625      * but performing a static call.
626      *
627      * _Available since v3.3._
628      */
629     function functionStaticCall(address target, bytes memory data)
630         internal
631         view
632         returns (bytes memory)
633     {
634         return
635             functionStaticCall(
636                 target,
637                 data,
638                 "Address: low-level static call failed"
639             );
640     }
641 
642     /**
643      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
644      * but performing a static call.
645      *
646      * _Available since v3.3._
647      */
648     function functionStaticCall(
649         address target,
650         bytes memory data,
651         string memory errorMessage
652     ) internal view returns (bytes memory) {
653         require(isContract(target), "Address: static call to non-contract");
654 
655         (bool success, bytes memory returndata) = target.staticcall(data);
656         return verifyCallResult(success, returndata, errorMessage);
657     }
658 
659     /**
660      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
661      * but performing a delegate call.
662      *
663      * _Available since v3.4._
664      */
665     function functionDelegateCall(address target, bytes memory data)
666         internal
667         returns (bytes memory)
668     {
669         return
670             functionDelegateCall(
671                 target,
672                 data,
673                 "Address: low-level delegate call failed"
674             );
675     }
676 
677     /**
678      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
679      * but performing a delegate call.
680      *
681      * _Available since v3.4._
682      */
683     function functionDelegateCall(
684         address target,
685         bytes memory data,
686         string memory errorMessage
687     ) internal returns (bytes memory) {
688         require(isContract(target), "Address: delegate call to non-contract");
689 
690         (bool success, bytes memory returndata) = target.delegatecall(data);
691         return verifyCallResult(success, returndata, errorMessage);
692     }
693 
694     /**
695      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
696      * revert reason using the provided one.
697      *
698      * _Available since v4.3._
699      */
700     function verifyCallResult(
701         bool success,
702         bytes memory returndata,
703         string memory errorMessage
704     ) internal pure returns (bytes memory) {
705         if (success) {
706             return returndata;
707         } else {
708             // Look for revert reason and bubble it up if present
709             if (returndata.length > 0) {
710                 // The easiest way to bubble the revert reason is using memory via assembly
711 
712                 assembly {
713                     let returndata_size := mload(returndata)
714                     revert(add(32, returndata), returndata_size)
715                 }
716             } else {
717                 revert(errorMessage);
718             }
719         }
720     }
721 }
722 
723 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
724 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
725 
726 pragma solidity ^0.8.0;
727 
728 /**
729  * @title ERC721 token receiver interface
730  * @dev Interface for any contract that wants to support safeTransfers
731  * from ERC721 asset contracts.
732  */
733 interface IERC721Receiver {
734     /**
735      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
736      * by `operator` from `from`, this function is called.
737      *
738      * It must return its Solidity selector to confirm the token transfer.
739      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
740      *
741      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
742      */
743     function onERC721Received(
744         address operator,
745         address from,
746         uint256 tokenId,
747         bytes calldata data
748     ) external returns (bytes4);
749 }
750 
751 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
752 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
753 
754 pragma solidity ^0.8.0;
755 
756 /**
757  * @dev Interface of the ERC165 standard, as defined in the
758  * https://eips.ethereum.org/EIPS/eip-165[EIP].
759  *
760  * Implementers can declare support of contract interfaces, which can then be
761  * queried by others ({ERC165Checker}).
762  *
763  * For an implementation, see {ERC165}.
764  */
765 interface IERC165 {
766     /**
767      * @dev Returns true if this contract implements the interface defined by
768      * `interfaceId`. See the corresponding
769      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
770      * to learn more about how these ids are created.
771      *
772      * This function call must use less than 30 000 gas.
773      */
774     function supportsInterface(bytes4 interfaceId) external view returns (bool);
775 }
776 
777 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
778 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
779 
780 pragma solidity ^0.8.0;
781 
782 /**
783  * @dev Implementation of the {IERC165} interface.
784  *
785  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
786  * for the additional interface id that will be supported. For example:
787  *
788  * ```solidity
789  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
790  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
791  * }
792  * ```
793  *
794  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
795  */
796 abstract contract ERC165 is IERC165 {
797     /**
798      * @dev See {IERC165-supportsInterface}.
799      */
800     function supportsInterface(bytes4 interfaceId)
801         public
802         view
803         virtual
804         override
805         returns (bool)
806     {
807         return interfaceId == type(IERC165).interfaceId;
808     }
809 }
810 
811 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
812 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
813 
814 pragma solidity ^0.8.0;
815 
816 /**
817  * @dev Required interface of an ERC721 compliant contract.
818  */
819 interface IERC721 is IERC165 {
820     /**
821      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
822      */
823     event Transfer(
824         address indexed from,
825         address indexed to,
826         uint256 indexed tokenId
827     );
828 
829     /**
830      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
831      */
832     event Approval(
833         address indexed owner,
834         address indexed approved,
835         uint256 indexed tokenId
836     );
837 
838     /**
839      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
840      */
841     event ApprovalForAll(
842         address indexed owner,
843         address indexed operator,
844         bool approved
845     );
846 
847     /**
848      * @dev Returns the number of tokens in ``owner``'s account.
849      */
850     function balanceOf(address owner) external view returns (uint256 balance);
851 
852     /**
853      * @dev Returns the owner of the `tokenId` token.
854      *
855      * Requirements:
856      *
857      * - `tokenId` must exist.
858      */
859     function ownerOf(uint256 tokenId) external view returns (address owner);
860 
861     /**
862      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
863      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
864      *
865      * Requirements:
866      *
867      * - `from` cannot be the zero address.
868      * - `to` cannot be the zero address.
869      * - `tokenId` token must exist and be owned by `from`.
870      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
871      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
872      *
873      * Emits a {Transfer} event.
874      */
875     function safeTransferFrom(
876         address from,
877         address to,
878         uint256 tokenId
879     ) external;
880 
881     /**
882      * @dev Transfers `tokenId` token from `from` to `to`.
883      *
884      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
885      *
886      * Requirements:
887      *
888      * - `from` cannot be the zero address.
889      * - `to` cannot be the zero address.
890      * - `tokenId` token must be owned by `from`.
891      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
892      *
893      * Emits a {Transfer} event.
894      */
895     function transferFrom(
896         address from,
897         address to,
898         uint256 tokenId
899     ) external;
900 
901     /**
902      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
903      * The approval is cleared when the token is transferred.
904      *
905      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
906      *
907      * Requirements:
908      *
909      * - The caller must own the token or be an approved operator.
910      * - `tokenId` must exist.
911      *
912      * Emits an {Approval} event.
913      */
914     function approve(address to, uint256 tokenId) external;
915 
916     /**
917      * @dev Returns the account approved for `tokenId` token.
918      *
919      * Requirements:
920      *
921      * - `tokenId` must exist.
922      */
923     function getApproved(uint256 tokenId)
924         external
925         view
926         returns (address operator);
927 
928     /**
929      * @dev Approve or remove `operator` as an operator for the caller.
930      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
931      *
932      * Requirements:
933      *
934      * - The `operator` cannot be the caller.
935      *
936      * Emits an {ApprovalForAll} event.
937      */
938     function setApprovalForAll(address operator, bool _approved) external;
939 
940     /**
941      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
942      *
943      * See {setApprovalForAll}
944      */
945     function isApprovedForAll(address owner, address operator)
946         external
947         view
948         returns (bool);
949 
950     /**
951      * @dev Safely transfers `tokenId` token from `from` to `to`.
952      *
953      * Requirements:
954      *
955      * - `from` cannot be the zero address.
956      * - `to` cannot be the zero address.
957      * - `tokenId` token must exist and be owned by `from`.
958      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
959      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
960      *
961      * Emits a {Transfer} event.
962      */
963     function safeTransferFrom(
964         address from,
965         address to,
966         uint256 tokenId,
967         bytes calldata data
968     ) external;
969 }
970 
971 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
972 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
973 
974 pragma solidity ^0.8.0;
975 
976 /**
977  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
978  * @dev See https://eips.ethereum.org/EIPS/eip-721
979  */
980 interface IERC721Metadata is IERC721 {
981     /**
982      * @dev Returns the token collection name.
983      */
984     function name() external view returns (string memory);
985 
986     /**
987      * @dev Returns the token collection symbol.
988      */
989     function symbol() external view returns (string memory);
990 
991     /**
992      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
993      */
994     function tokenURI(uint256 tokenId) external view returns (string memory);
995 }
996 
997 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
998 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
999 
1000 pragma solidity ^0.8.0;
1001 
1002 /**
1003  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1004  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1005  * {ERC721Enumerable}.
1006  */
1007 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1008     using Address for address;
1009     using Strings for uint256;
1010 
1011     // Token name
1012     string private _name;
1013 
1014     // Token symbol
1015     string private _symbol;
1016 
1017     // Mapping from token ID to owner address
1018     mapping(uint256 => address) private _owners;
1019 
1020     // Mapping owner address to token count
1021     mapping(address => uint256) private _balances;
1022 
1023     // Mapping from token ID to approved address
1024     mapping(uint256 => address) private _tokenApprovals;
1025 
1026     // Mapping from owner to operator approvals
1027     mapping(address => mapping(address => bool)) private _operatorApprovals;
1028 
1029     /**
1030      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1031      */
1032     constructor(string memory name_, string memory symbol_) {
1033         _name = name_;
1034         _symbol = symbol_;
1035     }
1036 
1037     /**
1038      * @dev See {IERC165-supportsInterface}.
1039      */
1040     function supportsInterface(bytes4 interfaceId)
1041         public
1042         view
1043         virtual
1044         override(ERC165, IERC165)
1045         returns (bool)
1046     {
1047         return
1048             interfaceId == type(IERC721).interfaceId ||
1049             interfaceId == type(IERC721Metadata).interfaceId ||
1050             super.supportsInterface(interfaceId);
1051     }
1052 
1053     /**
1054      * @dev See {IERC721-balanceOf}.
1055      */
1056     function balanceOf(address owner)
1057         public
1058         view
1059         virtual
1060         override
1061         returns (uint256)
1062     {
1063         require(
1064             owner != address(0),
1065             "ERC721: balance query for the zero address"
1066         );
1067         return _balances[owner];
1068     }
1069 
1070     /**
1071      * @dev See {IERC721-ownerOf}.
1072      */
1073     function ownerOf(uint256 tokenId)
1074         public
1075         view
1076         virtual
1077         override
1078         returns (address)
1079     {
1080         address owner = _owners[tokenId];
1081         require(
1082             owner != address(0),
1083             "ERC721: owner query for nonexistent token"
1084         );
1085         return owner;
1086     }
1087 
1088     /**
1089      * @dev See {IERC721Metadata-name}.
1090      */
1091     function name() public view virtual override returns (string memory) {
1092         return _name;
1093     }
1094 
1095     /**
1096      * @dev See {IERC721Metadata-symbol}.
1097      */
1098     function symbol() public view virtual override returns (string memory) {
1099         return _symbol;
1100     }
1101 
1102     /**
1103      * @dev See {IERC721Metadata-tokenURI}.
1104      */
1105     function tokenURI(uint256 tokenId)
1106         public
1107         view
1108         virtual
1109         override
1110         returns (string memory)
1111     {
1112         require(
1113             _exists(tokenId),
1114             "ERC721Metadata: URI query for nonexistent token"
1115         );
1116 
1117         string memory baseURI = _baseURI();
1118         return
1119             bytes(baseURI).length > 0
1120                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1121                 : "";
1122     }
1123 
1124     /**
1125      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1126      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1127      * by default, can be overriden in child contracts.
1128      */
1129     function _baseURI() internal view virtual returns (string memory) {
1130         return "";
1131     }
1132 
1133     /**
1134      * @dev See {IERC721-approve}.
1135      */
1136     function approve(address to, uint256 tokenId) public virtual override {
1137         address owner = ERC721.ownerOf(tokenId);
1138         require(to != owner, "ERC721: approval to current owner");
1139 
1140         require(
1141             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1142             "ERC721: approve caller is not owner nor approved for all"
1143         );
1144 
1145         _approve(to, tokenId);
1146     }
1147 
1148     /**
1149      * @dev See {IERC721-getApproved}.
1150      */
1151     function getApproved(uint256 tokenId)
1152         public
1153         view
1154         virtual
1155         override
1156         returns (address)
1157     {
1158         require(
1159             _exists(tokenId),
1160             "ERC721: approved query for nonexistent token"
1161         );
1162 
1163         return _tokenApprovals[tokenId];
1164     }
1165 
1166     /**
1167      * @dev See {IERC721-setApprovalForAll}.
1168      */
1169     function setApprovalForAll(address operator, bool approved)
1170         public
1171         virtual
1172         override
1173     {
1174         _setApprovalForAll(_msgSender(), operator, approved);
1175     }
1176 
1177     /**
1178      * @dev See {IERC721-isApprovedForAll}.
1179      */
1180     function isApprovedForAll(address owner, address operator)
1181         public
1182         view
1183         virtual
1184         override
1185         returns (bool)
1186     {
1187         return _operatorApprovals[owner][operator];
1188     }
1189 
1190     /**
1191      * @dev See {IERC721-transferFrom}.
1192      */
1193     function transferFrom(
1194         address from,
1195         address to,
1196         uint256 tokenId
1197     ) public virtual override {
1198         //solhint-disable-next-line max-line-length
1199         require(
1200             _isApprovedOrOwner(_msgSender(), tokenId),
1201             "ERC721: transfer caller is not owner nor approved"
1202         );
1203 
1204         _transfer(from, to, tokenId);
1205     }
1206 
1207     /**
1208      * @dev See {IERC721-safeTransferFrom}.
1209      */
1210     function safeTransferFrom(
1211         address from,
1212         address to,
1213         uint256 tokenId
1214     ) public virtual override {
1215         safeTransferFrom(from, to, tokenId, "");
1216     }
1217 
1218     /**
1219      * @dev See {IERC721-safeTransferFrom}.
1220      */
1221     function safeTransferFrom(
1222         address from,
1223         address to,
1224         uint256 tokenId,
1225         bytes memory _data
1226     ) public virtual override {
1227         require(
1228             _isApprovedOrOwner(_msgSender(), tokenId),
1229             "ERC721: transfer caller is not owner nor approved"
1230         );
1231         _safeTransfer(from, to, tokenId, _data);
1232     }
1233 
1234     /**
1235      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1236      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1237      *
1238      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1239      *
1240      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1241      * implement alternative mechanisms to perform token transfer, such as signature-based.
1242      *
1243      * Requirements:
1244      *
1245      * - `from` cannot be the zero address.
1246      * - `to` cannot be the zero address.
1247      * - `tokenId` token must exist and be owned by `from`.
1248      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1249      *
1250      * Emits a {Transfer} event.
1251      */
1252     function _safeTransfer(
1253         address from,
1254         address to,
1255         uint256 tokenId,
1256         bytes memory _data
1257     ) internal virtual {
1258         _transfer(from, to, tokenId);
1259         require(
1260             _checkOnERC721Received(from, to, tokenId, _data),
1261             "ERC721: transfer to non ERC721Receiver implementer"
1262         );
1263     }
1264 
1265     /**
1266      * @dev Returns whether `tokenId` exists.
1267      *
1268      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1269      *
1270      * Tokens start existing when they are minted (`_mint`),
1271      * and stop existing when they are burned (`_burn`).
1272      */
1273     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1274         return _owners[tokenId] != address(0);
1275     }
1276 
1277     /**
1278      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1279      *
1280      * Requirements:
1281      *
1282      * - `tokenId` must exist.
1283      */
1284     function _isApprovedOrOwner(address spender, uint256 tokenId)
1285         internal
1286         view
1287         virtual
1288         returns (bool)
1289     {
1290         require(
1291             _exists(tokenId),
1292             "ERC721: operator query for nonexistent token"
1293         );
1294         address owner = ERC721.ownerOf(tokenId);
1295         return (spender == owner ||
1296             getApproved(tokenId) == spender ||
1297             isApprovedForAll(owner, spender));
1298     }
1299 
1300     /**
1301      * @dev Safely mints `tokenId` and transfers it to `to`.
1302      *
1303      * Requirements:
1304      *
1305      * - `tokenId` must not exist.
1306      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1307      *
1308      * Emits a {Transfer} event.
1309      */
1310     function _safeMint(address to, uint256 tokenId) internal virtual {
1311         _safeMint(to, tokenId, "");
1312     }
1313 
1314     /**
1315      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1316      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1317      */
1318     function _safeMint(
1319         address to,
1320         uint256 tokenId,
1321         bytes memory _data
1322     ) internal virtual {
1323         _mint(to, tokenId);
1324         require(
1325             _checkOnERC721Received(address(0), to, tokenId, _data),
1326             "ERC721: transfer to non ERC721Receiver implementer"
1327         );
1328     }
1329 
1330     /**
1331      * @dev Mints `tokenId` and transfers it to `to`.
1332      *
1333      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1334      *
1335      * Requirements:
1336      *
1337      * - `tokenId` must not exist.
1338      * - `to` cannot be the zero address.
1339      *
1340      * Emits a {Transfer} event.
1341      */
1342     function _mint(address to, uint256 tokenId) internal virtual {
1343         require(to != address(0), "ERC721: mint to the zero address");
1344         require(!_exists(tokenId), "ERC721: token already minted");
1345 
1346         _beforeTokenTransfer(address(0), to, tokenId);
1347 
1348         _balances[to] += 1;
1349         _owners[tokenId] = to;
1350 
1351         emit Transfer(address(0), to, tokenId);
1352     }
1353 
1354     /**
1355      * @dev Destroys `tokenId`.
1356      * The approval is cleared when the token is burned.
1357      *
1358      * Requirements:
1359      *
1360      * - `tokenId` must exist.
1361      *
1362      * Emits a {Transfer} event.
1363      */
1364     function _burn(uint256 tokenId) internal virtual {
1365         address owner = ERC721.ownerOf(tokenId);
1366 
1367         _beforeTokenTransfer(owner, address(0), tokenId);
1368 
1369         // Clear approvals
1370         _approve(address(0), tokenId);
1371 
1372         _balances[owner] -= 1;
1373         delete _owners[tokenId];
1374 
1375         emit Transfer(owner, address(0), tokenId);
1376     }
1377 
1378     /**
1379      * @dev Transfers `tokenId` from `from` to `to`.
1380      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1381      *
1382      * Requirements:
1383      *
1384      * - `to` cannot be the zero address.
1385      * - `tokenId` token must be owned by `from`.
1386      *
1387      * Emits a {Transfer} event.
1388      */
1389     function _transfer(
1390         address from,
1391         address to,
1392         uint256 tokenId
1393     ) internal virtual {
1394         require(
1395             ERC721.ownerOf(tokenId) == from,
1396             "ERC721: transfer of token that is not own"
1397         );
1398         require(to != address(0), "ERC721: transfer to the zero address");
1399 
1400         _beforeTokenTransfer(from, to, tokenId);
1401 
1402         // Clear approvals from the previous owner
1403         _approve(address(0), tokenId);
1404 
1405         _balances[from] -= 1;
1406         _balances[to] += 1;
1407         _owners[tokenId] = to;
1408 
1409         emit Transfer(from, to, tokenId);
1410     }
1411 
1412     /**
1413      * @dev Approve `to` to operate on `tokenId`
1414      *
1415      * Emits a {Approval} event.
1416      */
1417     function _approve(address to, uint256 tokenId) internal virtual {
1418         _tokenApprovals[tokenId] = to;
1419         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1420     }
1421 
1422     /**
1423      * @dev Approve `operator` to operate on all of `owner` tokens
1424      *
1425      * Emits a {ApprovalForAll} event.
1426      */
1427     function _setApprovalForAll(
1428         address owner,
1429         address operator,
1430         bool approved
1431     ) internal virtual {
1432         require(owner != operator, "ERC721: approve to caller");
1433         _operatorApprovals[owner][operator] = approved;
1434         emit ApprovalForAll(owner, operator, approved);
1435     }
1436 
1437     /**
1438      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1439      * The call is not executed if the target address is not a contract.
1440      *
1441      * @param from address representing the previous owner of the given token ID
1442      * @param to target address that will receive the tokens
1443      * @param tokenId uint256 ID of the token to be transferred
1444      * @param _data bytes optional data to send along with the call
1445      * @return bool whether the call correctly returned the expected magic value
1446      */
1447     function _checkOnERC721Received(
1448         address from,
1449         address to,
1450         uint256 tokenId,
1451         bytes memory _data
1452     ) private returns (bool) {
1453         if (to.isContract()) {
1454             try
1455                 IERC721Receiver(to).onERC721Received(
1456                     _msgSender(),
1457                     from,
1458                     tokenId,
1459                     _data
1460                 )
1461             returns (bytes4 retval) {
1462                 return retval == IERC721Receiver.onERC721Received.selector;
1463             } catch (bytes memory reason) {
1464                 if (reason.length == 0) {
1465                     revert(
1466                         "ERC721: transfer to non ERC721Receiver implementer"
1467                     );
1468                 } else {
1469                     assembly {
1470                         revert(add(32, reason), mload(reason))
1471                     }
1472                 }
1473             }
1474         } else {
1475             return true;
1476         }
1477     }
1478 
1479     /**
1480      * @dev Hook that is called before any token transfer. This includes minting
1481      * and burning.
1482      *
1483      * Calling conditions:
1484      *
1485      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1486      * transferred to `to`.
1487      * - When `from` is zero, `tokenId` will be minted for `to`.
1488      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1489      * - `from` and `to` are never both zero.
1490      *
1491      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1492      */
1493     function _beforeTokenTransfer(
1494         address from,
1495         address to,
1496         uint256 tokenId
1497     ) internal virtual {}
1498 }
1499 
1500 // File: contracts/NFT.sol
1501 
1502 pragma solidity ^0.8.0;
1503 
1504 contract NFT_ERC721 is ERC721, Ownable {
1505     using Counters for Counters.Counter;
1506     Counters.Counter private _tokenSupply;
1507 
1508     using Strings for uint256;
1509 
1510     string baseURI = "ipfs://QmPWckBjpmQSTGXMzMsez91ayKGbGjonJ2cTe2ms3iTzig/";
1511     string public baseExtension = ".json";
1512     uint256 public maxSupply = 1000;
1513     bool public revealed = false;
1514     string public notRevealedUri =
1515         "ipfs://QmPWckBjpmQSTGXMzMsez91ayKGbGjonJ2cTe2ms3iTzig/hidden.json";
1516     address payable public payments;
1517     bytes32 public merkleRootOG =
1518         0x3b0da7204ced669c3d8054621fa567e585f035b8583353fdc65d4d7a3aa7ffe4;
1519     bytes32 public merkleRootCollab =
1520         0x1515793cdc55dc782b4e6dd8c5bd013d8eb53973bcf7752abf2b167194b85b67;
1521     // Phase 1 (OG & Partners): October 23, 8:30AM UTC / 4:30AM EST
1522     // Phase 2 (Collabs): October 23, 4PM UTC / 12PM EST
1523     // Phase 3 (Public): October 23, 7PM UTC / 3PM EST
1524     uint256 public OGStartTime = 1666513800;
1525     uint256 public collabStartTime = 1666540800;
1526     uint256 public publicStartTime = 1666551600;
1527 
1528     mapping(address => bool) public mintClaimed;
1529 
1530     constructor() ERC721("Mandala Regens", "Regens") {
1531         uint256 supply = _tokenSupply.current();
1532         for (uint256 i = 0; i < 25; i++) {
1533             _tokenSupply.increment();
1534             _safeMint(0x809bFD2E376BF2E4C53F352B8bF07c812662f588, supply + i);
1535         }
1536     }
1537 
1538     // internal
1539     function _baseURI() internal view virtual override returns (string memory) {
1540         return baseURI;
1541     }
1542 
1543     // public
1544     function OGMint(bytes32[] calldata _merkleProof) public payable {
1545         require(block.timestamp > OGStartTime, "OG minting not started");
1546         uint256 supply = _tokenSupply.current();
1547         require(supply + 1 <= maxSupply, "Max supply has been reached");
1548         require(!mintClaimed[msg.sender], "Address already claimed");
1549         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1550         require(
1551             MerkleProof.verify(_merkleProof, merkleRootOG, leaf),
1552             "Invalid Merkle proof for OG"
1553         );
1554 
1555         mintClaimed[msg.sender] = true;
1556         _tokenSupply.increment();
1557         _safeMint(msg.sender, supply);
1558     }
1559 
1560     function collabMint(bytes32[] calldata _merkleProof) public payable {
1561         require(
1562             block.timestamp > collabStartTime,
1563             "Collab minting not started"
1564         );
1565         uint256 supply = _tokenSupply.current();
1566         require(supply + 1 <= maxSupply, "Max supply has been reached");
1567         require(!mintClaimed[msg.sender], "Address already claimed");
1568         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1569         require(
1570             MerkleProof.verify(_merkleProof, merkleRootOG, leaf),
1571             "Invalid Merkle proof for Collab"
1572         );
1573 
1574         mintClaimed[msg.sender] = true;
1575         _tokenSupply.increment();
1576         _safeMint(msg.sender, supply);
1577     }
1578 
1579     function publicMint() public payable {
1580         require(
1581             block.timestamp > publicStartTime,
1582             "Public minting not started"
1583         );
1584         uint256 supply = _tokenSupply.current();
1585         require(supply + 1 <= maxSupply, "Max supply has been reached");
1586         require(!mintClaimed[msg.sender], "Address already claimed");
1587 
1588         mintClaimed[msg.sender] = true;
1589         _tokenSupply.increment();
1590         _safeMint(msg.sender, supply);
1591     }
1592 
1593     function tokenURI(uint256 tokenId)
1594         public
1595         view
1596         virtual
1597         override
1598         returns (string memory)
1599     {
1600         require(
1601             _exists(tokenId),
1602             "ERC721Metadata: URI query for nonexistent token"
1603         );
1604 
1605         if (revealed == false) {
1606             return notRevealedUri;
1607         }
1608 
1609         string memory currentBaseURI = _baseURI();
1610         return
1611             bytes(currentBaseURI).length > 0
1612                 ? string(
1613                     abi.encodePacked(
1614                         currentBaseURI,
1615                         tokenId.toString(),
1616                         baseExtension
1617                     )
1618                 )
1619                 : "";
1620     }
1621 
1622     // only owner
1623     function reveal() public onlyOwner {
1624         revealed = true;
1625     }
1626 
1627     function setMerkleRootOG(bytes32 _merkleRoot) external onlyOwner {
1628         merkleRootOG = _merkleRoot;
1629     }
1630 
1631     function setMerkleRootCollab(bytes32 _merkleRoot) external onlyOwner {
1632         merkleRootCollab = _merkleRoot;
1633     }
1634 
1635     function setOGStartTime(uint256 _OGStartTime) external onlyOwner {
1636         OGStartTime = _OGStartTime;
1637     }
1638 
1639     function setCollabStartTime(uint256 _collabStartTime) external onlyOwner {
1640         collabStartTime = _collabStartTime;
1641     }
1642 
1643     function setPublicStartTime(uint256 _publicStartTime) external onlyOwner {
1644         publicStartTime = _publicStartTime;
1645     }
1646 
1647     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1648         baseURI = _newBaseURI;
1649     }
1650 
1651     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1652         notRevealedUri = _notRevealedURI;
1653     }
1654 
1655     function setBaseExtension(string memory _newBaseExtension)
1656         public
1657         onlyOwner
1658     {
1659         baseExtension = _newBaseExtension;
1660     }
1661 
1662     function withdraw() public payable onlyOwner {
1663         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1664         require(os);
1665     }
1666 
1667     function totalSupply() public view returns (uint256) {
1668         return _tokenSupply.current();
1669     }
1670 }