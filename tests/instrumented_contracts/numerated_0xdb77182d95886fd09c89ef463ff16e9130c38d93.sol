1 // SPDX-License-Identifier: MIT
2 // Author @Akileus7 twitter.com/akileus7 Akileus.eth
3 // Co-Author @atsu_eth twitter.com/atsu_eth
4 // Owner: GobzNFT
5 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
6 
7 
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
220 // File: @openzeppelin/contracts/utils/Counters.sol
221 
222 
223 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
224 
225 pragma solidity ^0.8.0;
226 
227 /**
228  * @title Counters
229  * @author Matt Condon (@shrugs)
230  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
231  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
232  *
233  * Include with `using Counters for Counters.Counter;`
234  */
235 library Counters {
236     struct Counter {
237         // This variable should never be directly accessed by users of the library: interactions must be restricted to
238         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
239         // this feature: see https://github.com/ethereum/solidity/issues/4637
240         uint256 _value; // default: 0
241     }
242 
243     function current(Counter storage counter) internal view returns (uint256) {
244         return counter._value;
245     }
246 
247     function increment(Counter storage counter) internal {
248         unchecked {
249             counter._value += 1;
250         }
251     }
252 
253     function decrement(Counter storage counter) internal {
254         uint256 value = counter._value;
255         require(value > 0, "Counter: decrement overflow");
256         unchecked {
257             counter._value = value - 1;
258         }
259     }
260 
261     function reset(Counter storage counter) internal {
262         counter._value = 0;
263     }
264 }
265 
266 // File: @openzeppelin/contracts/utils/Strings.sol
267 
268 
269 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
270 
271 pragma solidity ^0.8.0;
272 
273 /**
274  * @dev String operations.
275  */
276 library Strings {
277     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
278     uint8 private constant _ADDRESS_LENGTH = 20;
279 
280     /**
281      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
282      */
283     function toString(uint256 value) internal pure returns (string memory) {
284         // Inspired by OraclizeAPI's implementation - MIT licence
285         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
286 
287         if (value == 0) {
288             return "0";
289         }
290         uint256 temp = value;
291         uint256 digits;
292         while (temp != 0) {
293             digits++;
294             temp /= 10;
295         }
296         bytes memory buffer = new bytes(digits);
297         while (value != 0) {
298             digits -= 1;
299             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
300             value /= 10;
301         }
302         return string(buffer);
303     }
304 
305     /**
306      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
307      */
308     function toHexString(uint256 value) internal pure returns (string memory) {
309         if (value == 0) {
310             return "0x00";
311         }
312         uint256 temp = value;
313         uint256 length = 0;
314         while (temp != 0) {
315             length++;
316             temp >>= 8;
317         }
318         return toHexString(value, length);
319     }
320 
321     /**
322      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
323      */
324     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
325         bytes memory buffer = new bytes(2 * length + 2);
326         buffer[0] = "0";
327         buffer[1] = "x";
328         for (uint256 i = 2 * length + 1; i > 1; --i) {
329             buffer[i] = _HEX_SYMBOLS[value & 0xf];
330             value >>= 4;
331         }
332         require(value == 0, "Strings: hex length insufficient");
333         return string(buffer);
334     }
335 
336     /**
337      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
338      */
339     function toHexString(address addr) internal pure returns (string memory) {
340         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
341     }
342 }
343 
344 // File: @openzeppelin/contracts/utils/Context.sol
345 
346 
347 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
348 
349 pragma solidity ^0.8.0;
350 
351 /**
352  * @dev Provides information about the current execution context, including the
353  * sender of the transaction and its data. While these are generally available
354  * via msg.sender and msg.data, they should not be accessed in such a direct
355  * manner, since when dealing with meta-transactions the account sending and
356  * paying for execution may not be the actual sender (as far as an application
357  * is concerned).
358  *
359  * This contract is only required for intermediate, library-like contracts.
360  */
361 abstract contract Context {
362     function _msgSender() internal view virtual returns (address) {
363         return msg.sender;
364     }
365 
366     function _msgData() internal view virtual returns (bytes calldata) {
367         return msg.data;
368     }
369 }
370 
371 // File: @openzeppelin/contracts/access/Ownable.sol
372 
373 
374 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
375 
376 pragma solidity ^0.8.0;
377 
378 
379 /**
380  * @dev Contract module which provides a basic access control mechanism, where
381  * there is an account (an owner) that can be granted exclusive access to
382  * specific functions.
383  *
384  * By default, the owner account will be the one that deploys the contract. This
385  * can later be changed with {transferOwnership}.
386  *
387  * This module is used through inheritance. It will make available the modifier
388  * `onlyOwner`, which can be applied to your functions to restrict their use to
389  * the owner.
390  */
391 abstract contract Ownable is Context {
392     address private _owner;
393 
394     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
395 
396     /**
397      * @dev Initializes the contract setting the deployer as the initial owner.
398      */
399     constructor() {
400         _transferOwnership(_msgSender());
401     }
402 
403     /**
404      * @dev Throws if called by any account other than the owner.
405      */
406     modifier onlyOwner() {
407         _checkOwner();
408         _;
409     }
410 
411     /**
412      * @dev Returns the address of the current owner.
413      */
414     function owner() public view virtual returns (address) {
415         return _owner;
416     }
417 
418     /**
419      * @dev Throws if the sender is not the owner.
420      */
421     function _checkOwner() internal view virtual {
422         require(owner() == _msgSender(), "Ownable: caller is not the owner");
423     }
424 
425     /**
426      * @dev Leaves the contract without owner. It will not be possible to call
427      * `onlyOwner` functions anymore. Can only be called by the current owner.
428      *
429      * NOTE: Renouncing ownership will leave the contract without an owner,
430      * thereby removing any functionality that is only available to the owner.
431      */
432     function renounceOwnership() public virtual onlyOwner {
433         _transferOwnership(address(0));
434     }
435 
436     /**
437      * @dev Transfers ownership of the contract to a new account (`newOwner`).
438      * Can only be called by the current owner.
439      */
440     function transferOwnership(address newOwner) public virtual onlyOwner {
441         require(newOwner != address(0), "Ownable: new owner is the zero address");
442         _transferOwnership(newOwner);
443     }
444 
445     /**
446      * @dev Transfers ownership of the contract to a new account (`newOwner`).
447      * Internal function without access restriction.
448      */
449     function _transferOwnership(address newOwner) internal virtual {
450         address oldOwner = _owner;
451         _owner = newOwner;
452         emit OwnershipTransferred(oldOwner, newOwner);
453     }
454 }
455 
456 // File: @openzeppelin/contracts/utils/Address.sol
457 
458 
459 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
460 
461 pragma solidity ^0.8.1;
462 
463 /**
464  * @dev Collection of functions related to the address type
465  */
466 library Address {
467     /**
468      * @dev Returns true if `account` is a contract.
469      *
470      * [IMPORTANT]
471      * ====
472      * It is unsafe to assume that an address for which this function returns
473      * false is an externally-owned account (EOA) and not a contract.
474      *
475      * Among others, `isContract` will return false for the following
476      * types of addresses:
477      *
478      *  - an externally-owned account
479      *  - a contract in construction
480      *  - an address where a contract will be created
481      *  - an address where a contract lived, but was destroyed
482      * ====
483      *
484      * [IMPORTANT]
485      * ====
486      * You shouldn't rely on `isContract` to protect against flash loan attacks!
487      *
488      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
489      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
490      * constructor.
491      * ====
492      */
493     function isContract(address account) internal view returns (bool) {
494         // This method relies on extcodesize/address.code.length, which returns 0
495         // for contracts in construction, since the code is only stored at the end
496         // of the constructor execution.
497 
498         return account.code.length > 0;
499     }
500 
501     /**
502      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
503      * `recipient`, forwarding all available gas and reverting on errors.
504      *
505      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
506      * of certain opcodes, possibly making contracts go over the 2300 gas limit
507      * imposed by `transfer`, making them unable to receive funds via
508      * `transfer`. {sendValue} removes this limitation.
509      *
510      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
511      *
512      * IMPORTANT: because control is transferred to `recipient`, care must be
513      * taken to not create reentrancy vulnerabilities. Consider using
514      * {ReentrancyGuard} or the
515      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
516      */
517     function sendValue(address payable recipient, uint256 amount) internal {
518         require(address(this).balance >= amount, "Address: insufficient balance");
519 
520         (bool success, ) = recipient.call{value: amount}("");
521         require(success, "Address: unable to send value, recipient may have reverted");
522     }
523 
524     /**
525      * @dev Performs a Solidity function call using a low level `call`. A
526      * plain `call` is an unsafe replacement for a function call: use this
527      * function instead.
528      *
529      * If `target` reverts with a revert reason, it is bubbled up by this
530      * function (like regular Solidity function calls).
531      *
532      * Returns the raw returned data. To convert to the expected return value,
533      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
534      *
535      * Requirements:
536      *
537      * - `target` must be a contract.
538      * - calling `target` with `data` must not revert.
539      *
540      * _Available since v3.1._
541      */
542     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
543         return functionCall(target, data, "Address: low-level call failed");
544     }
545 
546     /**
547      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
548      * `errorMessage` as a fallback revert reason when `target` reverts.
549      *
550      * _Available since v3.1._
551      */
552     function functionCall(
553         address target,
554         bytes memory data,
555         string memory errorMessage
556     ) internal returns (bytes memory) {
557         return functionCallWithValue(target, data, 0, errorMessage);
558     }
559 
560     /**
561      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
562      * but also transferring `value` wei to `target`.
563      *
564      * Requirements:
565      *
566      * - the calling contract must have an ETH balance of at least `value`.
567      * - the called Solidity function must be `payable`.
568      *
569      * _Available since v3.1._
570      */
571     function functionCallWithValue(
572         address target,
573         bytes memory data,
574         uint256 value
575     ) internal returns (bytes memory) {
576         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
577     }
578 
579     /**
580      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
581      * with `errorMessage` as a fallback revert reason when `target` reverts.
582      *
583      * _Available since v3.1._
584      */
585     function functionCallWithValue(
586         address target,
587         bytes memory data,
588         uint256 value,
589         string memory errorMessage
590     ) internal returns (bytes memory) {
591         require(address(this).balance >= value, "Address: insufficient balance for call");
592         require(isContract(target), "Address: call to non-contract");
593 
594         (bool success, bytes memory returndata) = target.call{value: value}(data);
595         return verifyCallResult(success, returndata, errorMessage);
596     }
597 
598     /**
599      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
600      * but performing a static call.
601      *
602      * _Available since v3.3._
603      */
604     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
605         return functionStaticCall(target, data, "Address: low-level static call failed");
606     }
607 
608     /**
609      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
610      * but performing a static call.
611      *
612      * _Available since v3.3._
613      */
614     function functionStaticCall(
615         address target,
616         bytes memory data,
617         string memory errorMessage
618     ) internal view returns (bytes memory) {
619         require(isContract(target), "Address: static call to non-contract");
620 
621         (bool success, bytes memory returndata) = target.staticcall(data);
622         return verifyCallResult(success, returndata, errorMessage);
623     }
624 
625     /**
626      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
627      * but performing a delegate call.
628      *
629      * _Available since v3.4._
630      */
631     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
632         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
633     }
634 
635     /**
636      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
637      * but performing a delegate call.
638      *
639      * _Available since v3.4._
640      */
641     function functionDelegateCall(
642         address target,
643         bytes memory data,
644         string memory errorMessage
645     ) internal returns (bytes memory) {
646         require(isContract(target), "Address: delegate call to non-contract");
647 
648         (bool success, bytes memory returndata) = target.delegatecall(data);
649         return verifyCallResult(success, returndata, errorMessage);
650     }
651 
652     /**
653      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
654      * revert reason using the provided one.
655      *
656      * _Available since v4.3._
657      */
658     function verifyCallResult(
659         bool success,
660         bytes memory returndata,
661         string memory errorMessage
662     ) internal pure returns (bytes memory) {
663         if (success) {
664             return returndata;
665         } else {
666             // Look for revert reason and bubble it up if present
667             if (returndata.length > 0) {
668                 // The easiest way to bubble the revert reason is using memory via assembly
669                 /// @solidity memory-safe-assembly
670                 assembly {
671                     let returndata_size := mload(returndata)
672                     revert(add(32, returndata), returndata_size)
673                 }
674             } else {
675                 revert(errorMessage);
676             }
677         }
678     }
679 }
680 
681 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
682 
683 
684 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
685 
686 pragma solidity ^0.8.0;
687 
688 /**
689  * @title ERC721 token receiver interface
690  * @dev Interface for any contract that wants to support safeTransfers
691  * from ERC721 asset contracts.
692  */
693 interface IERC721Receiver {
694     /**
695      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
696      * by `operator` from `from`, this function is called.
697      *
698      * It must return its Solidity selector to confirm the token transfer.
699      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
700      *
701      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
702      */
703     function onERC721Received(
704         address operator,
705         address from,
706         uint256 tokenId,
707         bytes calldata data
708     ) external returns (bytes4);
709 }
710 
711 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
712 
713 
714 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
715 
716 pragma solidity ^0.8.0;
717 
718 /**
719  * @dev Interface of the ERC165 standard, as defined in the
720  * https://eips.ethereum.org/EIPS/eip-165[EIP].
721  *
722  * Implementers can declare support of contract interfaces, which can then be
723  * queried by others ({ERC165Checker}).
724  *
725  * For an implementation, see {ERC165}.
726  */
727 interface IERC165 {
728     /**
729      * @dev Returns true if this contract implements the interface defined by
730      * `interfaceId`. See the corresponding
731      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
732      * to learn more about how these ids are created.
733      *
734      * This function call must use less than 30 000 gas.
735      */
736     function supportsInterface(bytes4 interfaceId) external view returns (bool);
737 }
738 
739 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
740 
741 
742 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
743 
744 pragma solidity ^0.8.0;
745 
746 
747 /**
748  * @dev Implementation of the {IERC165} interface.
749  *
750  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
751  * for the additional interface id that will be supported. For example:
752  *
753  * ```solidity
754  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
755  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
756  * }
757  * ```
758  *
759  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
760  */
761 abstract contract ERC165 is IERC165 {
762     /**
763      * @dev See {IERC165-supportsInterface}.
764      */
765     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
766         return interfaceId == type(IERC165).interfaceId;
767     }
768 }
769 
770 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
771 
772 
773 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
774 
775 pragma solidity ^0.8.0;
776 
777 
778 /**
779  * @dev Required interface of an ERC721 compliant contract.
780  */
781 interface IERC721 is IERC165 {
782     /**
783      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
784      */
785     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
786 
787     /**
788      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
789      */
790     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
791 
792     /**
793      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
794      */
795     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
796 
797     /**
798      * @dev Returns the number of tokens in ``owner``'s account.
799      */
800     function balanceOf(address owner) external view returns (uint256 balance);
801 
802     /**
803      * @dev Returns the owner of the `tokenId` token.
804      *
805      * Requirements:
806      *
807      * - `tokenId` must exist.
808      */
809     function ownerOf(uint256 tokenId) external view returns (address owner);
810 
811     /**
812      * @dev Safely transfers `tokenId` token from `from` to `to`.
813      *
814      * Requirements:
815      *
816      * - `from` cannot be the zero address.
817      * - `to` cannot be the zero address.
818      * - `tokenId` token must exist and be owned by `from`.
819      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
820      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
821      *
822      * Emits a {Transfer} event.
823      */
824     function safeTransferFrom(
825         address from,
826         address to,
827         uint256 tokenId,
828         bytes calldata data
829     ) external;
830 
831     /**
832      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
833      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
834      *
835      * Requirements:
836      *
837      * - `from` cannot be the zero address.
838      * - `to` cannot be the zero address.
839      * - `tokenId` token must exist and be owned by `from`.
840      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
841      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
842      *
843      * Emits a {Transfer} event.
844      */
845     function safeTransferFrom(
846         address from,
847         address to,
848         uint256 tokenId
849     ) external;
850 
851     /**
852      * @dev Transfers `tokenId` token from `from` to `to`.
853      *
854      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
855      *
856      * Requirements:
857      *
858      * - `from` cannot be the zero address.
859      * - `to` cannot be the zero address.
860      * - `tokenId` token must be owned by `from`.
861      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
862      *
863      * Emits a {Transfer} event.
864      */
865     function transferFrom(
866         address from,
867         address to,
868         uint256 tokenId
869     ) external;
870 
871     /**
872      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
873      * The approval is cleared when the token is transferred.
874      *
875      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
876      *
877      * Requirements:
878      *
879      * - The caller must own the token or be an approved operator.
880      * - `tokenId` must exist.
881      *
882      * Emits an {Approval} event.
883      */
884     function approve(address to, uint256 tokenId) external;
885 
886     /**
887      * @dev Approve or remove `operator` as an operator for the caller.
888      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
889      *
890      * Requirements:
891      *
892      * - The `operator` cannot be the caller.
893      *
894      * Emits an {ApprovalForAll} event.
895      */
896     function setApprovalForAll(address operator, bool _approved) external;
897 
898     /**
899      * @dev Returns the account approved for `tokenId` token.
900      *
901      * Requirements:
902      *
903      * - `tokenId` must exist.
904      */
905     function getApproved(uint256 tokenId) external view returns (address operator);
906 
907     /**
908      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
909      *
910      * See {setApprovalForAll}
911      */
912     function isApprovedForAll(address owner, address operator) external view returns (bool);
913 }
914 
915 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
916 
917 
918 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
919 
920 pragma solidity ^0.8.0;
921 
922 
923 /**
924  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
925  * @dev See https://eips.ethereum.org/EIPS/eip-721
926  */
927 interface IERC721Metadata is IERC721 {
928     /**
929      * @dev Returns the token collection name.
930      */
931     function name() external view returns (string memory);
932 
933     /**
934      * @dev Returns the token collection symbol.
935      */
936     function symbol() external view returns (string memory);
937 
938     /**
939      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
940      */
941     function tokenURI(uint256 tokenId) external view returns (string memory);
942 }
943 
944 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
945 
946 
947 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
948 
949 pragma solidity ^0.8.0;
950 
951 
952 
953 
954 
955 
956 
957 
958 /**
959  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
960  * the Metadata extension, but not including the Enumerable extension, which is available separately as
961  * {ERC721Enumerable}.
962  */
963 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
964     using Address for address;
965     using Strings for uint256;
966 
967     // Token name
968     string private _name;
969 
970     // Token symbol
971     string private _symbol;
972 
973     // Mapping from token ID to owner address
974     mapping(uint256 => address) private _owners;
975 
976     // Mapping owner address to token count
977     mapping(address => uint256) private _balances;
978 
979     // Mapping from token ID to approved address
980     mapping(uint256 => address) private _tokenApprovals;
981 
982     // Mapping from owner to operator approvals
983     mapping(address => mapping(address => bool)) private _operatorApprovals;
984 
985     /**
986      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
987      */
988     constructor(string memory name_, string memory symbol_) {
989         _name = name_;
990         _symbol = symbol_;
991     }
992 
993     /**
994      * @dev See {IERC165-supportsInterface}.
995      */
996     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
997         return
998             interfaceId == type(IERC721).interfaceId ||
999             interfaceId == type(IERC721Metadata).interfaceId ||
1000             super.supportsInterface(interfaceId);
1001     }
1002 
1003     /**
1004      * @dev See {IERC721-balanceOf}.
1005      */
1006     function balanceOf(address owner) public view virtual override returns (uint256) {
1007         require(owner != address(0), "ERC721: address zero is not a valid owner");
1008         return _balances[owner];
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-ownerOf}.
1013      */
1014     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1015         address owner = _owners[tokenId];
1016         require(owner != address(0), "ERC721: invalid token ID");
1017         return owner;
1018     }
1019 
1020     /**
1021      * @dev See {IERC721Metadata-name}.
1022      */
1023     function name() public view virtual override returns (string memory) {
1024         return _name;
1025     }
1026 
1027     /**
1028      * @dev See {IERC721Metadata-symbol}.
1029      */
1030     function symbol() public view virtual override returns (string memory) {
1031         return _symbol;
1032     }
1033 
1034     /**
1035      * @dev See {IERC721Metadata-tokenURI}.
1036      */
1037     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1038         _requireMinted(tokenId);
1039 
1040         string memory baseURI = _baseURI();
1041         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1042     }
1043 
1044     /**
1045      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1046      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1047      * by default, can be overridden in child contracts.
1048      */
1049     function _baseURI() internal view virtual returns (string memory) {
1050         return "";
1051     }
1052 
1053     /**
1054      * @dev See {IERC721-approve}.
1055      */
1056     function approve(address to, uint256 tokenId) public virtual override {
1057         address owner = ERC721.ownerOf(tokenId);
1058         require(to != owner, "ERC721: approval to current owner");
1059 
1060         require(
1061             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1062             "ERC721: approve caller is not token owner nor approved for all"
1063         );
1064 
1065         _approve(to, tokenId);
1066     }
1067 
1068     /**
1069      * @dev See {IERC721-getApproved}.
1070      */
1071     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1072         _requireMinted(tokenId);
1073 
1074         return _tokenApprovals[tokenId];
1075     }
1076 
1077     /**
1078      * @dev See {IERC721-setApprovalForAll}.
1079      */
1080     function setApprovalForAll(address operator, bool approved) public virtual override {
1081         _setApprovalForAll(_msgSender(), operator, approved);
1082     }
1083 
1084     /**
1085      * @dev See {IERC721-isApprovedForAll}.
1086      */
1087     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1088         return _operatorApprovals[owner][operator];
1089     }
1090 
1091     /**
1092      * @dev See {IERC721-transferFrom}.
1093      */
1094     function transferFrom(
1095         address from,
1096         address to,
1097         uint256 tokenId
1098     ) public virtual override {
1099         //solhint-disable-next-line max-line-length
1100         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1101 
1102         _transfer(from, to, tokenId);
1103     }
1104 
1105     /**
1106      * @dev See {IERC721-safeTransferFrom}.
1107      */
1108     function safeTransferFrom(
1109         address from,
1110         address to,
1111         uint256 tokenId
1112     ) public virtual override {
1113         safeTransferFrom(from, to, tokenId, "");
1114     }
1115 
1116     /**
1117      * @dev See {IERC721-safeTransferFrom}.
1118      */
1119     function safeTransferFrom(
1120         address from,
1121         address to,
1122         uint256 tokenId,
1123         bytes memory data
1124     ) public virtual override {
1125         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1126         _safeTransfer(from, to, tokenId, data);
1127     }
1128 
1129     /**
1130      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1131      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1132      *
1133      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1134      *
1135      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1136      * implement alternative mechanisms to perform token transfer, such as signature-based.
1137      *
1138      * Requirements:
1139      *
1140      * - `from` cannot be the zero address.
1141      * - `to` cannot be the zero address.
1142      * - `tokenId` token must exist and be owned by `from`.
1143      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1144      *
1145      * Emits a {Transfer} event.
1146      */
1147     function _safeTransfer(
1148         address from,
1149         address to,
1150         uint256 tokenId,
1151         bytes memory data
1152     ) internal virtual {
1153         _transfer(from, to, tokenId);
1154         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1155     }
1156 
1157     /**
1158      * @dev Returns whether `tokenId` exists.
1159      *
1160      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1161      *
1162      * Tokens start existing when they are minted (`_mint`),
1163      * and stop existing when they are burned (`_burn`).
1164      */
1165     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1166         return _owners[tokenId] != address(0);
1167     }
1168 
1169     /**
1170      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1171      *
1172      * Requirements:
1173      *
1174      * - `tokenId` must exist.
1175      */
1176     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1177         address owner = ERC721.ownerOf(tokenId);
1178         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1179     }
1180 
1181     /**
1182      * @dev Safely mints `tokenId` and transfers it to `to`.
1183      *
1184      * Requirements:
1185      *
1186      * - `tokenId` must not exist.
1187      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1188      *
1189      * Emits a {Transfer} event.
1190      */
1191     function _safeMint(address to, uint256 tokenId) internal virtual {
1192         _safeMint(to, tokenId, "");
1193     }
1194 
1195     /**
1196      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1197      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1198      */
1199     function _safeMint(
1200         address to,
1201         uint256 tokenId,
1202         bytes memory data
1203     ) internal virtual {
1204         _mint(to, tokenId);
1205         require(
1206             _checkOnERC721Received(address(0), to, tokenId, data),
1207             "ERC721: transfer to non ERC721Receiver implementer"
1208         );
1209     }
1210 
1211     /**
1212      * @dev Mints `tokenId` and transfers it to `to`.
1213      *
1214      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1215      *
1216      * Requirements:
1217      *
1218      * - `tokenId` must not exist.
1219      * - `to` cannot be the zero address.
1220      *
1221      * Emits a {Transfer} event.
1222      */
1223     function _mint(address to, uint256 tokenId) internal virtual {
1224         require(to != address(0), "ERC721: mint to the zero address");
1225         require(!_exists(tokenId), "ERC721: token already minted");
1226 
1227         _beforeTokenTransfer(address(0), to, tokenId);
1228 
1229         _balances[to] += 1;
1230         _owners[tokenId] = to;
1231 
1232         emit Transfer(address(0), to, tokenId);
1233 
1234         _afterTokenTransfer(address(0), to, tokenId);
1235     }
1236 
1237     /**
1238      * @dev Destroys `tokenId`.
1239      * The approval is cleared when the token is burned.
1240      *
1241      * Requirements:
1242      *
1243      * - `tokenId` must exist.
1244      *
1245      * Emits a {Transfer} event.
1246      */
1247     function _burn(uint256 tokenId) internal virtual {
1248         address owner = ERC721.ownerOf(tokenId);
1249 
1250         _beforeTokenTransfer(owner, address(0), tokenId);
1251 
1252         // Clear approvals
1253         _approve(address(0), tokenId);
1254 
1255         _balances[owner] -= 1;
1256         delete _owners[tokenId];
1257 
1258         emit Transfer(owner, address(0), tokenId);
1259 
1260         _afterTokenTransfer(owner, address(0), tokenId);
1261     }
1262 
1263     /**
1264      * @dev Transfers `tokenId` from `from` to `to`.
1265      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1266      *
1267      * Requirements:
1268      *
1269      * - `to` cannot be the zero address.
1270      * - `tokenId` token must be owned by `from`.
1271      *
1272      * Emits a {Transfer} event.
1273      */
1274     function _transfer(
1275         address from,
1276         address to,
1277         uint256 tokenId
1278     ) internal virtual {
1279         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1280         require(to != address(0), "ERC721: transfer to the zero address");
1281 
1282         _beforeTokenTransfer(from, to, tokenId);
1283 
1284         // Clear approvals from the previous owner
1285         _approve(address(0), tokenId);
1286 
1287         _balances[from] -= 1;
1288         _balances[to] += 1;
1289         _owners[tokenId] = to;
1290 
1291         emit Transfer(from, to, tokenId);
1292 
1293         _afterTokenTransfer(from, to, tokenId);
1294     }
1295 
1296     /**
1297      * @dev Approve `to` to operate on `tokenId`
1298      *
1299      * Emits an {Approval} event.
1300      */
1301     function _approve(address to, uint256 tokenId) internal virtual {
1302         _tokenApprovals[tokenId] = to;
1303         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1304     }
1305 
1306     /**
1307      * @dev Approve `operator` to operate on all of `owner` tokens
1308      *
1309      * Emits an {ApprovalForAll} event.
1310      */
1311     function _setApprovalForAll(
1312         address owner,
1313         address operator,
1314         bool approved
1315     ) internal virtual {
1316         require(owner != operator, "ERC721: approve to caller");
1317         _operatorApprovals[owner][operator] = approved;
1318         emit ApprovalForAll(owner, operator, approved);
1319     }
1320 
1321     /**
1322      * @dev Reverts if the `tokenId` has not been minted yet.
1323      */
1324     function _requireMinted(uint256 tokenId) internal view virtual {
1325         require(_exists(tokenId), "ERC721: invalid token ID");
1326     }
1327 
1328     /**
1329      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1330      * The call is not executed if the target address is not a contract.
1331      *
1332      * @param from address representing the previous owner of the given token ID
1333      * @param to target address that will receive the tokens
1334      * @param tokenId uint256 ID of the token to be transferred
1335      * @param data bytes optional data to send along with the call
1336      * @return bool whether the call correctly returned the expected magic value
1337      */
1338     function _checkOnERC721Received(
1339         address from,
1340         address to,
1341         uint256 tokenId,
1342         bytes memory data
1343     ) private returns (bool) {
1344         if (to.isContract()) {
1345             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1346                 return retval == IERC721Receiver.onERC721Received.selector;
1347             } catch (bytes memory reason) {
1348                 if (reason.length == 0) {
1349                     revert("ERC721: transfer to non ERC721Receiver implementer");
1350                 } else {
1351                     /// @solidity memory-safe-assembly
1352                     assembly {
1353                         revert(add(32, reason), mload(reason))
1354                     }
1355                 }
1356             }
1357         } else {
1358             return true;
1359         }
1360     }
1361 
1362     /**
1363      * @dev Hook that is called before any token transfer. This includes minting
1364      * and burning.
1365      *
1366      * Calling conditions:
1367      *
1368      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1369      * transferred to `to`.
1370      * - When `from` is zero, `tokenId` will be minted for `to`.
1371      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1372      * - `from` and `to` are never both zero.
1373      *
1374      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1375      */
1376     function _beforeTokenTransfer(
1377         address from,
1378         address to,
1379         uint256 tokenId
1380     ) internal virtual {}
1381 
1382     /**
1383      * @dev Hook that is called after any transfer of tokens. This includes
1384      * minting and burning.
1385      *
1386      * Calling conditions:
1387      *
1388      * - when `from` and `to` are both non-zero.
1389      * - `from` and `to` are never both zero.
1390      *
1391      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1392      */
1393     function _afterTokenTransfer(
1394         address from,
1395         address to,
1396         uint256 tokenId
1397     ) internal virtual {}
1398 }
1399 
1400 // File: erc721a/contracts/IERC721A.sol
1401 
1402 
1403 // ERC721A Contracts v4.2.3
1404 // Creator: Chiru Labs
1405 
1406 pragma solidity ^0.8.4;
1407 
1408 /**
1409  * @dev Interface of ERC721A.
1410  */
1411 interface IERC721A {
1412     /**
1413      * The caller must own the token or be an approved operator.
1414      */
1415     error ApprovalCallerNotOwnerNorApproved();
1416 
1417     /**
1418      * The token does not exist.
1419      */
1420     error ApprovalQueryForNonexistentToken();
1421 
1422     /**
1423      * Cannot query the balance for the zero address.
1424      */
1425     error BalanceQueryForZeroAddress();
1426 
1427     /**
1428      * Cannot mint to the zero address.
1429      */
1430     error MintToZeroAddress();
1431 
1432     /**
1433      * The quantity of tokens minted must be more than zero.
1434      */
1435     error MintZeroQuantity();
1436 
1437     /**
1438      * The token does not exist.
1439      */
1440     error OwnerQueryForNonexistentToken();
1441 
1442     /**
1443      * The caller must own the token or be an approved operator.
1444      */
1445     error TransferCallerNotOwnerNorApproved();
1446 
1447     /**
1448      * The token must be owned by `from`.
1449      */
1450     error TransferFromIncorrectOwner();
1451 
1452     /**
1453      * Cannot safely transfer to a contract that does not implement the
1454      * ERC721Receiver interface.
1455      */
1456     error TransferToNonERC721ReceiverImplementer();
1457 
1458     /**
1459      * Cannot transfer to the zero address.
1460      */
1461     error TransferToZeroAddress();
1462 
1463     /**
1464      * The token does not exist.
1465      */
1466     error URIQueryForNonexistentToken();
1467 
1468     /**
1469      * The `quantity` minted with ERC2309 exceeds the safety limit.
1470      */
1471     error MintERC2309QuantityExceedsLimit();
1472 
1473     /**
1474      * The `extraData` cannot be set on an unintialized ownership slot.
1475      */
1476     error OwnershipNotInitializedForExtraData();
1477 
1478     // =============================================================
1479     //                            STRUCTS
1480     // =============================================================
1481 
1482     struct TokenOwnership {
1483         // The address of the owner.
1484         address addr;
1485         // Stores the start time of ownership with minimal overhead for tokenomics.
1486         uint64 startTimestamp;
1487         // Whether the token has been burned.
1488         bool burned;
1489         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1490         uint24 extraData;
1491     }
1492 
1493     // =============================================================
1494     //                         TOKEN COUNTERS
1495     // =============================================================
1496 
1497     /**
1498      * @dev Returns the total number of tokens in existence.
1499      * Burned tokens will reduce the count.
1500      * To get the total number of tokens minted, please see {_totalMinted}.
1501      */
1502     function totalSupply() external view returns (uint256);
1503 
1504     // =============================================================
1505     //                            IERC165
1506     // =============================================================
1507 
1508     /**
1509      * @dev Returns true if this contract implements the interface defined by
1510      * `interfaceId`. See the corresponding
1511      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1512      * to learn more about how these ids are created.
1513      *
1514      * This function call must use less than 30000 gas.
1515      */
1516     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1517 
1518     // =============================================================
1519     //                            IERC721
1520     // =============================================================
1521 
1522     /**
1523      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1524      */
1525     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1526 
1527     /**
1528      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1529      */
1530     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1531 
1532     /**
1533      * @dev Emitted when `owner` enables or disables
1534      * (`approved`) `operator` to manage all of its assets.
1535      */
1536     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1537 
1538     /**
1539      * @dev Returns the number of tokens in `owner`'s account.
1540      */
1541     function balanceOf(address owner) external view returns (uint256 balance);
1542 
1543     /**
1544      * @dev Returns the owner of the `tokenId` token.
1545      *
1546      * Requirements:
1547      *
1548      * - `tokenId` must exist.
1549      */
1550     function ownerOf(uint256 tokenId) external view returns (address owner);
1551 
1552     /**
1553      * @dev Safely transfers `tokenId` token from `from` to `to`,
1554      * checking first that contract recipients are aware of the ERC721 protocol
1555      * to prevent tokens from being forever locked.
1556      *
1557      * Requirements:
1558      *
1559      * - `from` cannot be the zero address.
1560      * - `to` cannot be the zero address.
1561      * - `tokenId` token must exist and be owned by `from`.
1562      * - If the caller is not `from`, it must be have been allowed to move
1563      * this token by either {approve} or {setApprovalForAll}.
1564      * - If `to` refers to a smart contract, it must implement
1565      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1566      *
1567      * Emits a {Transfer} event.
1568      */
1569     function safeTransferFrom(
1570         address from,
1571         address to,
1572         uint256 tokenId,
1573         bytes calldata data
1574     ) external payable;
1575 
1576     /**
1577      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1578      */
1579     function safeTransferFrom(
1580         address from,
1581         address to,
1582         uint256 tokenId
1583     ) external payable;
1584 
1585     /**
1586      * @dev Transfers `tokenId` from `from` to `to`.
1587      *
1588      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1589      * whenever possible.
1590      *
1591      * Requirements:
1592      *
1593      * - `from` cannot be the zero address.
1594      * - `to` cannot be the zero address.
1595      * - `tokenId` token must be owned by `from`.
1596      * - If the caller is not `from`, it must be approved to move this token
1597      * by either {approve} or {setApprovalForAll}.
1598      *
1599      * Emits a {Transfer} event.
1600      */
1601     function transferFrom(
1602         address from,
1603         address to,
1604         uint256 tokenId
1605     ) external payable;
1606 
1607     /**
1608      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1609      * The approval is cleared when the token is transferred.
1610      *
1611      * Only a single account can be approved at a time, so approving the
1612      * zero address clears previous approvals.
1613      *
1614      * Requirements:
1615      *
1616      * - The caller must own the token or be an approved operator.
1617      * - `tokenId` must exist.
1618      *
1619      * Emits an {Approval} event.
1620      */
1621     function approve(address to, uint256 tokenId) external payable;
1622 
1623     /**
1624      * @dev Approve or remove `operator` as an operator for the caller.
1625      * Operators can call {transferFrom} or {safeTransferFrom}
1626      * for any token owned by the caller.
1627      *
1628      * Requirements:
1629      *
1630      * - The `operator` cannot be the caller.
1631      *
1632      * Emits an {ApprovalForAll} event.
1633      */
1634     function setApprovalForAll(address operator, bool _approved) external;
1635 
1636     /**
1637      * @dev Returns the account approved for `tokenId` token.
1638      *
1639      * Requirements:
1640      *
1641      * - `tokenId` must exist.
1642      */
1643     function getApproved(uint256 tokenId) external view returns (address operator);
1644 
1645     /**
1646      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1647      *
1648      * See {setApprovalForAll}.
1649      */
1650     function isApprovedForAll(address owner, address operator) external view returns (bool);
1651 
1652     // =============================================================
1653     //                        IERC721Metadata
1654     // =============================================================
1655 
1656     /**
1657      * @dev Returns the token collection name.
1658      */
1659     function name() external view returns (string memory);
1660 
1661     /**
1662      * @dev Returns the token collection symbol.
1663      */
1664     function symbol() external view returns (string memory);
1665 
1666     /**
1667      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1668      */
1669     function tokenURI(uint256 tokenId) external view returns (string memory);
1670 
1671     // =============================================================
1672     //                           IERC2309
1673     // =============================================================
1674 
1675     /**
1676      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1677      * (inclusive) is transferred from `from` to `to`, as defined in the
1678      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1679      *
1680      * See {_mintERC2309} for more details.
1681      */
1682     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1683 }
1684 
1685 // File: erc721a/contracts/ERC721A.sol
1686 
1687 
1688 // ERC721A Contracts v4.2.3
1689 // Creator: Chiru Labs
1690 
1691 pragma solidity ^0.8.4;
1692 
1693 
1694 /**
1695  * @dev Interface of ERC721 token receiver.
1696  */
1697 interface ERC721A__IERC721Receiver {
1698     function onERC721Received(
1699         address operator,
1700         address from,
1701         uint256 tokenId,
1702         bytes calldata data
1703     ) external returns (bytes4);
1704 }
1705 
1706 /**
1707  * @title ERC721A
1708  *
1709  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1710  * Non-Fungible Token Standard, including the Metadata extension.
1711  * Optimized for lower gas during batch mints.
1712  *
1713  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1714  * starting from `_startTokenId()`.
1715  *
1716  * Assumptions:
1717  *
1718  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1719  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1720  */
1721 contract ERC721A is IERC721A {
1722     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1723     struct TokenApprovalRef {
1724         address value;
1725     }
1726 
1727     // =============================================================
1728     //                           CONSTANTS
1729     // =============================================================
1730 
1731     // Mask of an entry in packed address data.
1732     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1733 
1734     // The bit position of `numberMinted` in packed address data.
1735     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1736 
1737     // The bit position of `numberBurned` in packed address data.
1738     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1739 
1740     // The bit position of `aux` in packed address data.
1741     uint256 private constant _BITPOS_AUX = 192;
1742 
1743     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1744     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1745 
1746     // The bit position of `startTimestamp` in packed ownership.
1747     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1748 
1749     // The bit mask of the `burned` bit in packed ownership.
1750     uint256 private constant _BITMASK_BURNED = 1 << 224;
1751 
1752     // The bit position of the `nextInitialized` bit in packed ownership.
1753     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1754 
1755     // The bit mask of the `nextInitialized` bit in packed ownership.
1756     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1757 
1758     // The bit position of `extraData` in packed ownership.
1759     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1760 
1761     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1762     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1763 
1764     // The mask of the lower 160 bits for addresses.
1765     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1766 
1767     // The maximum `quantity` that can be minted with {_mintERC2309}.
1768     // This limit is to prevent overflows on the address data entries.
1769     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1770     // is required to cause an overflow, which is unrealistic.
1771     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1772 
1773     // The `Transfer` event signature is given by:
1774     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1775     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1776         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1777 
1778     // =============================================================
1779     //                            STORAGE
1780     // =============================================================
1781 
1782     // The next token ID to be minted.
1783     uint256 private _currentIndex;
1784 
1785     // The number of tokens burned.
1786     uint256 private _burnCounter;
1787 
1788     // Token name
1789     string private _name;
1790 
1791     // Token symbol
1792     string private _symbol;
1793 
1794     // Mapping from token ID to ownership details
1795     // An empty struct value does not necessarily mean the token is unowned.
1796     // See {_packedOwnershipOf} implementation for details.
1797     //
1798     // Bits Layout:
1799     // - [0..159]   `addr`
1800     // - [160..223] `startTimestamp`
1801     // - [224]      `burned`
1802     // - [225]      `nextInitialized`
1803     // - [232..255] `extraData`
1804     mapping(uint256 => uint256) private _packedOwnerships;
1805 
1806     // Mapping owner address to address data.
1807     //
1808     // Bits Layout:
1809     // - [0..63]    `balance`
1810     // - [64..127]  `numberMinted`
1811     // - [128..191] `numberBurned`
1812     // - [192..255] `aux`
1813     mapping(address => uint256) private _packedAddressData;
1814 
1815     // Mapping from token ID to approved address.
1816     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1817 
1818     // Mapping from owner to operator approvals
1819     mapping(address => mapping(address => bool)) private _operatorApprovals;
1820 
1821     // =============================================================
1822     //                          CONSTRUCTOR
1823     // =============================================================
1824 
1825     constructor(string memory name_, string memory symbol_) {
1826         _name = name_;
1827         _symbol = symbol_;
1828         _currentIndex = _startTokenId();
1829     }
1830 
1831     // =============================================================
1832     //                   TOKEN COUNTING OPERATIONS
1833     // =============================================================
1834 
1835     /**
1836      * @dev Returns the starting token ID.
1837      * To change the starting token ID, please override this function.
1838      */
1839     function _startTokenId() internal view virtual returns (uint256) {
1840         return 0;
1841     }
1842 
1843     /**
1844      * @dev Returns the next token ID to be minted.
1845      */
1846     function _nextTokenId() internal view virtual returns (uint256) {
1847         return _currentIndex;
1848     }
1849 
1850     /**
1851      * @dev Returns the total number of tokens in existence.
1852      * Burned tokens will reduce the count.
1853      * To get the total number of tokens minted, please see {_totalMinted}.
1854      */
1855     function totalSupply() public view virtual override returns (uint256) {
1856         // Counter underflow is impossible as _burnCounter cannot be incremented
1857         // more than `_currentIndex - _startTokenId()` times.
1858         unchecked {
1859             return _currentIndex - _burnCounter - _startTokenId();
1860         }
1861     }
1862 
1863     /**
1864      * @dev Returns the total amount of tokens minted in the contract.
1865      */
1866     function _totalMinted() internal view virtual returns (uint256) {
1867         // Counter underflow is impossible as `_currentIndex` does not decrement,
1868         // and it is initialized to `_startTokenId()`.
1869         unchecked {
1870             return _currentIndex - _startTokenId();
1871         }
1872     }
1873 
1874     /**
1875      * @dev Returns the total number of tokens burned.
1876      */
1877     function _totalBurned() internal view virtual returns (uint256) {
1878         return _burnCounter;
1879     }
1880 
1881     // =============================================================
1882     //                    ADDRESS DATA OPERATIONS
1883     // =============================================================
1884 
1885     /**
1886      * @dev Returns the number of tokens in `owner`'s account.
1887      */
1888     function balanceOf(address owner) public view virtual override returns (uint256) {
1889         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1890         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1891     }
1892 
1893     /**
1894      * Returns the number of tokens minted by `owner`.
1895      */
1896     function _numberMinted(address owner) internal view returns (uint256) {
1897         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1898     }
1899 
1900     /**
1901      * Returns the number of tokens burned by or on behalf of `owner`.
1902      */
1903     function _numberBurned(address owner) internal view returns (uint256) {
1904         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1905     }
1906 
1907     /**
1908      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1909      */
1910     function _getAux(address owner) internal view returns (uint64) {
1911         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1912     }
1913 
1914     /**
1915      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1916      * If there are multiple variables, please pack them into a uint64.
1917      */
1918     function _setAux(address owner, uint64 aux) internal virtual {
1919         uint256 packed = _packedAddressData[owner];
1920         uint256 auxCasted;
1921         // Cast `aux` with assembly to avoid redundant masking.
1922         assembly {
1923             auxCasted := aux
1924         }
1925         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1926         _packedAddressData[owner] = packed;
1927     }
1928 
1929     // =============================================================
1930     //                            IERC165
1931     // =============================================================
1932 
1933     /**
1934      * @dev Returns true if this contract implements the interface defined by
1935      * `interfaceId`. See the corresponding
1936      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1937      * to learn more about how these ids are created.
1938      *
1939      * This function call must use less than 30000 gas.
1940      */
1941     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1942         // The interface IDs are constants representing the first 4 bytes
1943         // of the XOR of all function selectors in the interface.
1944         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1945         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1946         return
1947             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1948             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1949             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1950     }
1951 
1952     // =============================================================
1953     //                        IERC721Metadata
1954     // =============================================================
1955 
1956     /**
1957      * @dev Returns the token collection name.
1958      */
1959     function name() public view virtual override returns (string memory) {
1960         return _name;
1961     }
1962 
1963     /**
1964      * @dev Returns the token collection symbol.
1965      */
1966     function symbol() public view virtual override returns (string memory) {
1967         return _symbol;
1968     }
1969 
1970     /**
1971      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1972      */
1973     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1974         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1975 
1976         string memory baseURI = _baseURI();
1977         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1978     }
1979 
1980     /**
1981      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1982      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1983      * by default, it can be overridden in child contracts.
1984      */
1985     function _baseURI() internal view virtual returns (string memory) {
1986         return '';
1987     }
1988 
1989     // =============================================================
1990     //                     OWNERSHIPS OPERATIONS
1991     // =============================================================
1992 
1993     /**
1994      * @dev Returns the owner of the `tokenId` token.
1995      *
1996      * Requirements:
1997      *
1998      * - `tokenId` must exist.
1999      */
2000     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2001         return address(uint160(_packedOwnershipOf(tokenId)));
2002     }
2003 
2004     /**
2005      * @dev Gas spent here starts off proportional to the maximum mint batch size.
2006      * It gradually moves to O(1) as tokens get transferred around over time.
2007      */
2008     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
2009         return _unpackedOwnership(_packedOwnershipOf(tokenId));
2010     }
2011 
2012     /**
2013      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
2014      */
2015     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
2016         return _unpackedOwnership(_packedOwnerships[index]);
2017     }
2018 
2019     /**
2020      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
2021      */
2022     function _initializeOwnershipAt(uint256 index) internal virtual {
2023         if (_packedOwnerships[index] == 0) {
2024             _packedOwnerships[index] = _packedOwnershipOf(index);
2025         }
2026     }
2027 
2028     /**
2029      * Returns the packed ownership data of `tokenId`.
2030      */
2031     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
2032         uint256 curr = tokenId;
2033 
2034         unchecked {
2035             if (_startTokenId() <= curr)
2036                 if (curr < _currentIndex) {
2037                     uint256 packed = _packedOwnerships[curr];
2038                     // If not burned.
2039                     if (packed & _BITMASK_BURNED == 0) {
2040                         // Invariant:
2041                         // There will always be an initialized ownership slot
2042                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
2043                         // before an unintialized ownership slot
2044                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
2045                         // Hence, `curr` will not underflow.
2046                         //
2047                         // We can directly compare the packed value.
2048                         // If the address is zero, packed will be zero.
2049                         while (packed == 0) {
2050                             packed = _packedOwnerships[--curr];
2051                         }
2052                         return packed;
2053                     }
2054                 }
2055         }
2056         revert OwnerQueryForNonexistentToken();
2057     }
2058 
2059     /**
2060      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
2061      */
2062     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
2063         ownership.addr = address(uint160(packed));
2064         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
2065         ownership.burned = packed & _BITMASK_BURNED != 0;
2066         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
2067     }
2068 
2069     /**
2070      * @dev Packs ownership data into a single uint256.
2071      */
2072     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
2073         assembly {
2074             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2075             owner := and(owner, _BITMASK_ADDRESS)
2076             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
2077             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
2078         }
2079     }
2080 
2081     /**
2082      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
2083      */
2084     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
2085         // For branchless setting of the `nextInitialized` flag.
2086         assembly {
2087             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
2088             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
2089         }
2090     }
2091 
2092     // =============================================================
2093     //                      APPROVAL OPERATIONS
2094     // =============================================================
2095 
2096     /**
2097      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2098      * The approval is cleared when the token is transferred.
2099      *
2100      * Only a single account can be approved at a time, so approving the
2101      * zero address clears previous approvals.
2102      *
2103      * Requirements:
2104      *
2105      * - The caller must own the token or be an approved operator.
2106      * - `tokenId` must exist.
2107      *
2108      * Emits an {Approval} event.
2109      */
2110     function approve(address to, uint256 tokenId) public payable virtual override {
2111         address owner = ownerOf(tokenId);
2112 
2113         if (_msgSenderERC721A() != owner)
2114             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
2115                 revert ApprovalCallerNotOwnerNorApproved();
2116             }
2117 
2118         _tokenApprovals[tokenId].value = to;
2119         emit Approval(owner, to, tokenId);
2120     }
2121 
2122     /**
2123      * @dev Returns the account approved for `tokenId` token.
2124      *
2125      * Requirements:
2126      *
2127      * - `tokenId` must exist.
2128      */
2129     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2130         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2131 
2132         return _tokenApprovals[tokenId].value;
2133     }
2134 
2135     /**
2136      * @dev Approve or remove `operator` as an operator for the caller.
2137      * Operators can call {transferFrom} or {safeTransferFrom}
2138      * for any token owned by the caller.
2139      *
2140      * Requirements:
2141      *
2142      * - The `operator` cannot be the caller.
2143      *
2144      * Emits an {ApprovalForAll} event.
2145      */
2146     function setApprovalForAll(address operator, bool approved) public virtual override {
2147         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
2148         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
2149     }
2150 
2151     /**
2152      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2153      *
2154      * See {setApprovalForAll}.
2155      */
2156     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2157         return _operatorApprovals[owner][operator];
2158     }
2159 
2160     /**
2161      * @dev Returns whether `tokenId` exists.
2162      *
2163      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2164      *
2165      * Tokens start existing when they are minted. See {_mint}.
2166      */
2167     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2168         return
2169             _startTokenId() <= tokenId &&
2170             tokenId < _currentIndex && // If within bounds,
2171             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
2172     }
2173 
2174     /**
2175      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
2176      */
2177     function _isSenderApprovedOrOwner(
2178         address approvedAddress,
2179         address owner,
2180         address msgSender
2181     ) private pure returns (bool result) {
2182         assembly {
2183             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2184             owner := and(owner, _BITMASK_ADDRESS)
2185             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
2186             msgSender := and(msgSender, _BITMASK_ADDRESS)
2187             // `msgSender == owner || msgSender == approvedAddress`.
2188             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
2189         }
2190     }
2191 
2192     /**
2193      * @dev Returns the storage slot and value for the approved address of `tokenId`.
2194      */
2195     function _getApprovedSlotAndAddress(uint256 tokenId)
2196         private
2197         view
2198         returns (uint256 approvedAddressSlot, address approvedAddress)
2199     {
2200         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
2201         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
2202         assembly {
2203             approvedAddressSlot := tokenApproval.slot
2204             approvedAddress := sload(approvedAddressSlot)
2205         }
2206     }
2207 
2208     // =============================================================
2209     //                      TRANSFER OPERATIONS
2210     // =============================================================
2211 
2212     /**
2213      * @dev Transfers `tokenId` from `from` to `to`.
2214      *
2215      * Requirements:
2216      *
2217      * - `from` cannot be the zero address.
2218      * - `to` cannot be the zero address.
2219      * - `tokenId` token must be owned by `from`.
2220      * - If the caller is not `from`, it must be approved to move this token
2221      * by either {approve} or {setApprovalForAll}.
2222      *
2223      * Emits a {Transfer} event.
2224      */
2225     function transferFrom(
2226         address from,
2227         address to,
2228         uint256 tokenId
2229     ) public payable virtual override {
2230         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2231 
2232         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
2233 
2234         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2235 
2236         // The nested ifs save around 20+ gas over a compound boolean condition.
2237         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2238             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2239 
2240         if (to == address(0)) revert TransferToZeroAddress();
2241 
2242         _beforeTokenTransfers(from, to, tokenId, 1);
2243 
2244         // Clear approvals from the previous owner.
2245         assembly {
2246             if approvedAddress {
2247                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2248                 sstore(approvedAddressSlot, 0)
2249             }
2250         }
2251 
2252         // Underflow of the sender's balance is impossible because we check for
2253         // ownership above and the recipient's balance can't realistically overflow.
2254         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2255         unchecked {
2256             // We can directly increment and decrement the balances.
2257             --_packedAddressData[from]; // Updates: `balance -= 1`.
2258             ++_packedAddressData[to]; // Updates: `balance += 1`.
2259 
2260             // Updates:
2261             // - `address` to the next owner.
2262             // - `startTimestamp` to the timestamp of transfering.
2263             // - `burned` to `false`.
2264             // - `nextInitialized` to `true`.
2265             _packedOwnerships[tokenId] = _packOwnershipData(
2266                 to,
2267                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2268             );
2269 
2270             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2271             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2272                 uint256 nextTokenId = tokenId + 1;
2273                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2274                 if (_packedOwnerships[nextTokenId] == 0) {
2275                     // If the next slot is within bounds.
2276                     if (nextTokenId != _currentIndex) {
2277                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2278                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2279                     }
2280                 }
2281             }
2282         }
2283 
2284         emit Transfer(from, to, tokenId);
2285         _afterTokenTransfers(from, to, tokenId, 1);
2286     }
2287 
2288     /**
2289      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2290      */
2291     function safeTransferFrom(
2292         address from,
2293         address to,
2294         uint256 tokenId
2295     ) public payable virtual override {
2296         safeTransferFrom(from, to, tokenId, '');
2297     }
2298 
2299     /**
2300      * @dev Safely transfers `tokenId` token from `from` to `to`.
2301      *
2302      * Requirements:
2303      *
2304      * - `from` cannot be the zero address.
2305      * - `to` cannot be the zero address.
2306      * - `tokenId` token must exist and be owned by `from`.
2307      * - If the caller is not `from`, it must be approved to move this token
2308      * by either {approve} or {setApprovalForAll}.
2309      * - If `to` refers to a smart contract, it must implement
2310      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2311      *
2312      * Emits a {Transfer} event.
2313      */
2314     function safeTransferFrom(
2315         address from,
2316         address to,
2317         uint256 tokenId,
2318         bytes memory _data
2319     ) public payable virtual override {
2320         transferFrom(from, to, tokenId);
2321         if (to.code.length != 0)
2322             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2323                 revert TransferToNonERC721ReceiverImplementer();
2324             }
2325     }
2326 
2327     /**
2328      * @dev Hook that is called before a set of serially-ordered token IDs
2329      * are about to be transferred. This includes minting.
2330      * And also called before burning one token.
2331      *
2332      * `startTokenId` - the first token ID to be transferred.
2333      * `quantity` - the amount to be transferred.
2334      *
2335      * Calling conditions:
2336      *
2337      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2338      * transferred to `to`.
2339      * - When `from` is zero, `tokenId` will be minted for `to`.
2340      * - When `to` is zero, `tokenId` will be burned by `from`.
2341      * - `from` and `to` are never both zero.
2342      */
2343     function _beforeTokenTransfers(
2344         address from,
2345         address to,
2346         uint256 startTokenId,
2347         uint256 quantity
2348     ) internal virtual {}
2349 
2350     /**
2351      * @dev Hook that is called after a set of serially-ordered token IDs
2352      * have been transferred. This includes minting.
2353      * And also called after one token has been burned.
2354      *
2355      * `startTokenId` - the first token ID to be transferred.
2356      * `quantity` - the amount to be transferred.
2357      *
2358      * Calling conditions:
2359      *
2360      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2361      * transferred to `to`.
2362      * - When `from` is zero, `tokenId` has been minted for `to`.
2363      * - When `to` is zero, `tokenId` has been burned by `from`.
2364      * - `from` and `to` are never both zero.
2365      */
2366     function _afterTokenTransfers(
2367         address from,
2368         address to,
2369         uint256 startTokenId,
2370         uint256 quantity
2371     ) internal virtual {}
2372 
2373     /**
2374      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2375      *
2376      * `from` - Previous owner of the given token ID.
2377      * `to` - Target address that will receive the token.
2378      * `tokenId` - Token ID to be transferred.
2379      * `_data` - Optional data to send along with the call.
2380      *
2381      * Returns whether the call correctly returned the expected magic value.
2382      */
2383     function _checkContractOnERC721Received(
2384         address from,
2385         address to,
2386         uint256 tokenId,
2387         bytes memory _data
2388     ) private returns (bool) {
2389         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2390             bytes4 retval
2391         ) {
2392             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2393         } catch (bytes memory reason) {
2394             if (reason.length == 0) {
2395                 revert TransferToNonERC721ReceiverImplementer();
2396             } else {
2397                 assembly {
2398                     revert(add(32, reason), mload(reason))
2399                 }
2400             }
2401         }
2402     }
2403 
2404     // =============================================================
2405     //                        MINT OPERATIONS
2406     // =============================================================
2407 
2408     /**
2409      * @dev Mints `quantity` tokens and transfers them to `to`.
2410      *
2411      * Requirements:
2412      *
2413      * - `to` cannot be the zero address.
2414      * - `quantity` must be greater than 0.
2415      *
2416      * Emits a {Transfer} event for each mint.
2417      */
2418     function _mint(address to, uint256 quantity) internal virtual {
2419         uint256 startTokenId = _currentIndex;
2420         if (quantity == 0) revert MintZeroQuantity();
2421 
2422         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2423 
2424         // Overflows are incredibly unrealistic.
2425         // `balance` and `numberMinted` have a maximum limit of 2**64.
2426         // `tokenId` has a maximum limit of 2**256.
2427         unchecked {
2428             // Updates:
2429             // - `balance += quantity`.
2430             // - `numberMinted += quantity`.
2431             //
2432             // We can directly add to the `balance` and `numberMinted`.
2433             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2434 
2435             // Updates:
2436             // - `address` to the owner.
2437             // - `startTimestamp` to the timestamp of minting.
2438             // - `burned` to `false`.
2439             // - `nextInitialized` to `quantity == 1`.
2440             _packedOwnerships[startTokenId] = _packOwnershipData(
2441                 to,
2442                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2443             );
2444 
2445             uint256 toMasked;
2446             uint256 end = startTokenId + quantity;
2447 
2448             // Use assembly to loop and emit the `Transfer` event for gas savings.
2449             // The duplicated `log4` removes an extra check and reduces stack juggling.
2450             // The assembly, together with the surrounding Solidity code, have been
2451             // delicately arranged to nudge the compiler into producing optimized opcodes.
2452             assembly {
2453                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2454                 toMasked := and(to, _BITMASK_ADDRESS)
2455                 // Emit the `Transfer` event.
2456                 log4(
2457                     0, // Start of data (0, since no data).
2458                     0, // End of data (0, since no data).
2459                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2460                     0, // `address(0)`.
2461                     toMasked, // `to`.
2462                     startTokenId // `tokenId`.
2463                 )
2464 
2465                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2466                 // that overflows uint256 will make the loop run out of gas.
2467                 // The compiler will optimize the `iszero` away for performance.
2468                 for {
2469                     let tokenId := add(startTokenId, 1)
2470                 } iszero(eq(tokenId, end)) {
2471                     tokenId := add(tokenId, 1)
2472                 } {
2473                     // Emit the `Transfer` event. Similar to above.
2474                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2475                 }
2476             }
2477             if (toMasked == 0) revert MintToZeroAddress();
2478 
2479             _currentIndex = end;
2480         }
2481         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2482     }
2483 
2484     /**
2485      * @dev Mints `quantity` tokens and transfers them to `to`.
2486      *
2487      * This function is intended for efficient minting only during contract creation.
2488      *
2489      * It emits only one {ConsecutiveTransfer} as defined in
2490      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2491      * instead of a sequence of {Transfer} event(s).
2492      *
2493      * Calling this function outside of contract creation WILL make your contract
2494      * non-compliant with the ERC721 standard.
2495      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2496      * {ConsecutiveTransfer} event is only permissible during contract creation.
2497      *
2498      * Requirements:
2499      *
2500      * - `to` cannot be the zero address.
2501      * - `quantity` must be greater than 0.
2502      *
2503      * Emits a {ConsecutiveTransfer} event.
2504      */
2505     function _mintERC2309(address to, uint256 quantity) internal virtual {
2506         uint256 startTokenId = _currentIndex;
2507         if (to == address(0)) revert MintToZeroAddress();
2508         if (quantity == 0) revert MintZeroQuantity();
2509         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2510 
2511         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2512 
2513         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2514         unchecked {
2515             // Updates:
2516             // - `balance += quantity`.
2517             // - `numberMinted += quantity`.
2518             //
2519             // We can directly add to the `balance` and `numberMinted`.
2520             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2521 
2522             // Updates:
2523             // - `address` to the owner.
2524             // - `startTimestamp` to the timestamp of minting.
2525             // - `burned` to `false`.
2526             // - `nextInitialized` to `quantity == 1`.
2527             _packedOwnerships[startTokenId] = _packOwnershipData(
2528                 to,
2529                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2530             );
2531 
2532             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2533 
2534             _currentIndex = startTokenId + quantity;
2535         }
2536         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2537     }
2538 
2539     /**
2540      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2541      *
2542      * Requirements:
2543      *
2544      * - If `to` refers to a smart contract, it must implement
2545      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2546      * - `quantity` must be greater than 0.
2547      *
2548      * See {_mint}.
2549      *
2550      * Emits a {Transfer} event for each mint.
2551      */
2552     function _safeMint(
2553         address to,
2554         uint256 quantity,
2555         bytes memory _data
2556     ) internal virtual {
2557         _mint(to, quantity);
2558 
2559         unchecked {
2560             if (to.code.length != 0) {
2561                 uint256 end = _currentIndex;
2562                 uint256 index = end - quantity;
2563                 do {
2564                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2565                         revert TransferToNonERC721ReceiverImplementer();
2566                     }
2567                 } while (index < end);
2568                 // Reentrancy protection.
2569                 if (_currentIndex != end) revert();
2570             }
2571         }
2572     }
2573 
2574     /**
2575      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2576      */
2577     function _safeMint(address to, uint256 quantity) internal virtual {
2578         _safeMint(to, quantity, '');
2579     }
2580 
2581     // =============================================================
2582     //                        BURN OPERATIONS
2583     // =============================================================
2584 
2585     /**
2586      * @dev Equivalent to `_burn(tokenId, false)`.
2587      */
2588     function _burn(uint256 tokenId) internal virtual {
2589         _burn(tokenId, false);
2590     }
2591 
2592     /**
2593      * @dev Destroys `tokenId`.
2594      * The approval is cleared when the token is burned.
2595      *
2596      * Requirements:
2597      *
2598      * - `tokenId` must exist.
2599      *
2600      * Emits a {Transfer} event.
2601      */
2602     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2603         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2604 
2605         address from = address(uint160(prevOwnershipPacked));
2606 
2607         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2608 
2609         if (approvalCheck) {
2610             // The nested ifs save around 20+ gas over a compound boolean condition.
2611             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2612                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2613         }
2614 
2615         _beforeTokenTransfers(from, address(0), tokenId, 1);
2616 
2617         // Clear approvals from the previous owner.
2618         assembly {
2619             if approvedAddress {
2620                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2621                 sstore(approvedAddressSlot, 0)
2622             }
2623         }
2624 
2625         // Underflow of the sender's balance is impossible because we check for
2626         // ownership above and the recipient's balance can't realistically overflow.
2627         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2628         unchecked {
2629             // Updates:
2630             // - `balance -= 1`.
2631             // - `numberBurned += 1`.
2632             //
2633             // We can directly decrement the balance, and increment the number burned.
2634             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2635             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2636 
2637             // Updates:
2638             // - `address` to the last owner.
2639             // - `startTimestamp` to the timestamp of burning.
2640             // - `burned` to `true`.
2641             // - `nextInitialized` to `true`.
2642             _packedOwnerships[tokenId] = _packOwnershipData(
2643                 from,
2644                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2645             );
2646 
2647             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2648             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2649                 uint256 nextTokenId = tokenId + 1;
2650                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2651                 if (_packedOwnerships[nextTokenId] == 0) {
2652                     // If the next slot is within bounds.
2653                     if (nextTokenId != _currentIndex) {
2654                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2655                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2656                     }
2657                 }
2658             }
2659         }
2660 
2661         emit Transfer(from, address(0), tokenId);
2662         _afterTokenTransfers(from, address(0), tokenId, 1);
2663 
2664         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2665         unchecked {
2666             _burnCounter++;
2667         }
2668     }
2669 
2670     // =============================================================
2671     //                     EXTRA DATA OPERATIONS
2672     // =============================================================
2673 
2674     /**
2675      * @dev Directly sets the extra data for the ownership data `index`.
2676      */
2677     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2678         uint256 packed = _packedOwnerships[index];
2679         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2680         uint256 extraDataCasted;
2681         // Cast `extraData` with assembly to avoid redundant masking.
2682         assembly {
2683             extraDataCasted := extraData
2684         }
2685         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2686         _packedOwnerships[index] = packed;
2687     }
2688 
2689     /**
2690      * @dev Called during each token transfer to set the 24bit `extraData` field.
2691      * Intended to be overridden by the cosumer contract.
2692      *
2693      * `previousExtraData` - the value of `extraData` before transfer.
2694      *
2695      * Calling conditions:
2696      *
2697      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2698      * transferred to `to`.
2699      * - When `from` is zero, `tokenId` will be minted for `to`.
2700      * - When `to` is zero, `tokenId` will be burned by `from`.
2701      * - `from` and `to` are never both zero.
2702      */
2703     function _extraData(
2704         address from,
2705         address to,
2706         uint24 previousExtraData
2707     ) internal view virtual returns (uint24) {}
2708 
2709     /**
2710      * @dev Returns the next extra data for the packed ownership data.
2711      * The returned result is shifted into position.
2712      */
2713     function _nextExtraData(
2714         address from,
2715         address to,
2716         uint256 prevOwnershipPacked
2717     ) private view returns (uint256) {
2718         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2719         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2720     }
2721 
2722     // =============================================================
2723     //                       OTHER OPERATIONS
2724     // =============================================================
2725 
2726     /**
2727      * @dev Returns the message sender (defaults to `msg.sender`).
2728      *
2729      * If you are writing GSN compatible contracts, you need to override this function.
2730      */
2731     function _msgSenderERC721A() internal view virtual returns (address) {
2732         return msg.sender;
2733     }
2734 
2735     /**
2736      * @dev Converts a uint256 to its ASCII string decimal representation.
2737      */
2738     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2739         assembly {
2740             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2741             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2742             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2743             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2744             let m := add(mload(0x40), 0xa0)
2745             // Update the free memory pointer to allocate.
2746             mstore(0x40, m)
2747             // Assign the `str` to the end.
2748             str := sub(m, 0x20)
2749             // Zeroize the slot after the string.
2750             mstore(str, 0)
2751 
2752             // Cache the end of the memory to calculate the length later.
2753             let end := str
2754 
2755             // We write the string from rightmost digit to leftmost digit.
2756             // The following is essentially a do-while loop that also handles the zero case.
2757             // prettier-ignore
2758             for { let temp := value } 1 {} {
2759                 str := sub(str, 1)
2760                 // Write the character to the pointer.
2761                 // The ASCII index of the '0' character is 48.
2762                 mstore8(str, add(48, mod(temp, 10)))
2763                 // Keep dividing `temp` until zero.
2764                 temp := div(temp, 10)
2765                 // prettier-ignore
2766                 if iszero(temp) { break }
2767             }
2768 
2769             let length := sub(end, str)
2770             // Move the pointer 32 bytes leftwards to make room for the length.
2771             str := sub(str, 0x20)
2772             // Store the length.
2773             mstore(str, length)
2774         }
2775     }
2776 }
2777 
2778 // File: contracts/GobzMutant.sol
2779 
2780 
2781 // Author @Akileus7 twitter.com/akileus7 Akileus.eth
2782 // Co-Author @atsu_eth twitter.com/atsu_eth
2783 // Owner: GobzNFT
2784 pragma solidity ^0.8.13;
2785 
2786 
2787 
2788 
2789 
2790 
2791 contract GobzMutant is ERC721A, Ownable {
2792     using Strings for uint256;
2793     using Counters for Counters.Counter;
2794 
2795     Counters.Counter private supply;
2796 
2797     bytes32 root;
2798     string uriPrefix;
2799     uint256 public immutable MAX_SUPPLY = 3333;
2800     uint256 public immutable MAX_PER_TX = 20;
2801     uint256 public immutable MAX_PER_TX_PRIVATE = 6;
2802 
2803     uint256 public MINT_PRICE_M1 = 0.05 ether;
2804     uint256 public MINT_PRICE_M2 = 0.1 ether;
2805     uint256 public MINT_PRICE_M3 = 0.2 ether;
2806 
2807     uint256[] TokenTypeM1;
2808     uint256[] TokenTypeM2;
2809     uint256[] TokenTypeM3;
2810 
2811     uint256 public M1_SPOT;
2812     uint256 public M2_SPOT;
2813     uint256 public M3_SPOT;
2814 
2815     bool public IS_PRE_SALE_ACTIVE = false;
2816     bool public IS_SALE_ACTIVE = false;
2817 
2818     enum MintType {
2819         M1,
2820         M2,
2821         M3
2822     }
2823 
2824     mapping(address => uint) MintCountPerAddress;
2825 
2826     constructor(
2827         string memory Name,
2828         string memory Symbol,
2829         string memory _URI,
2830         bytes32 _root
2831     ) ERC721A(Name, Symbol) {
2832         root = _root;
2833         setURI(_URI);
2834     }
2835 
2836     function setMerkleRoot(bytes32 merkleroot) public onlyOwner {
2837         root = merkleroot;
2838     }
2839 
2840     function ownerMint(
2841         address to,
2842         uint256 quantity,
2843         MintType typeofmint
2844     ) external onlyOwner {
2845         uint256 nextTokenId = _nextTokenId();
2846         require(nextTokenId + quantity <= MAX_SUPPLY, "Excedes max supply.");
2847         if (typeofmint == MintType.M1) {
2848             for (uint256 i = nextTokenId; i < nextTokenId + quantity; i++) {
2849                 TokenTypeM1.push(i);
2850             }
2851             M1_SPOT += quantity;
2852             _mint(to, quantity);
2853         }
2854         if (typeofmint == MintType.M2) {
2855             for (uint256 i = nextTokenId; i < nextTokenId + quantity; i++) {
2856                 TokenTypeM2.push(i);
2857             }
2858             M2_SPOT += quantity;
2859             _mint(to, quantity);
2860         }
2861         if (typeofmint == MintType.M3) {
2862             for (uint256 i = nextTokenId; i < nextTokenId + quantity; i++) {
2863                 TokenTypeM3.push(i);
2864             }
2865 
2866             M3_SPOT += quantity;
2867             _mint(to, quantity);
2868         }
2869     }
2870 
2871     function mintPrivateM1(uint quantity, bytes32[] calldata proof)
2872         external
2873         payable
2874     {
2875         require(IS_PRE_SALE_ACTIVE, "Pre-sale haven't started");
2876         uint256 nextTokenId = _nextTokenId();
2877         require(_verify(_leaf(msg.sender), proof), "Invalid merkle proof");
2878         require(nextTokenId + quantity <= MAX_SUPPLY, "Excedes max supply.");
2879         require(
2880             MintCountPerAddress[msg.sender] + quantity <= MAX_PER_TX_PRIVATE,
2881             "Exceeds allowance"
2882         );
2883         MintCountPerAddress[msg.sender] += quantity;
2884         require(
2885             MINT_PRICE_M1 * quantity <= msg.value,
2886             "Ether value sent is not correct"
2887         );
2888 
2889         for (uint256 i = nextTokenId; i < nextTokenId + quantity; i++) {
2890             TokenTypeM1.push(i);
2891         }
2892 
2893         M1_SPOT += quantity;
2894         _mint(msg.sender, quantity);
2895     }
2896 
2897     function mintPrivateM2(uint quantity, bytes32[] calldata proof)
2898         external
2899         payable
2900     {
2901         require(IS_PRE_SALE_ACTIVE, "Pre-sale haven't started");
2902         uint256 nextTokenId = _nextTokenId();
2903         require(_verify(_leaf(msg.sender), proof), "Invalid merkle proof");
2904         require(nextTokenId + quantity <= MAX_SUPPLY, "Excedes max supply.");
2905         require(
2906             MintCountPerAddress[msg.sender] + quantity <= MAX_PER_TX_PRIVATE,
2907             "Exceeds allowance"
2908         );
2909         MintCountPerAddress[msg.sender] += quantity;
2910         require(
2911             MINT_PRICE_M2 * quantity <= msg.value,
2912             "Ether value sent is not correct"
2913         );
2914 
2915         for (uint256 i = nextTokenId; i < nextTokenId + quantity; i++) {
2916             TokenTypeM2.push(i);
2917         }
2918 
2919         M2_SPOT += quantity;
2920         _mint(msg.sender, quantity);
2921     }
2922 
2923     function mintPrivateM3(uint quantity, bytes32[] calldata proof)
2924         external
2925         payable
2926     {
2927         require(IS_PRE_SALE_ACTIVE, "Pre-sale haven't started");
2928         uint256 nextTokenId = _nextTokenId();
2929         require(_verify(_leaf(msg.sender), proof), "Invalid merkle proof");
2930         require(nextTokenId + quantity <= MAX_SUPPLY, "Excedes max supply.");
2931         require(
2932             MintCountPerAddress[msg.sender] + quantity <= MAX_PER_TX_PRIVATE,
2933             "Exceeds allowance"
2934         );
2935         MintCountPerAddress[msg.sender] += quantity;
2936         require(
2937             MINT_PRICE_M3 * quantity <= msg.value,
2938             "Ether value sent is not correct"
2939         );
2940 
2941         for (uint256 i = nextTokenId; i < nextTokenId + quantity; i++) {
2942             TokenTypeM3.push(i);
2943         }
2944 
2945         M3_SPOT += quantity;
2946         _mint(msg.sender, quantity);
2947     }
2948 
2949     function mintM1(uint256 quantity) external payable {
2950         require(IS_SALE_ACTIVE, "Sale haven't started");
2951         uint256 nextTokenId = _nextTokenId();
2952         require(nextTokenId + quantity <= MAX_SUPPLY, "Excedes max supply.");
2953         require(
2954             MINT_PRICE_M1 * quantity <= msg.value,
2955             "Ether value sent is not correct"
2956         );
2957 
2958         for (uint256 i = nextTokenId; i < nextTokenId + quantity; i++) {
2959             TokenTypeM1.push(i);
2960         }
2961 
2962         M1_SPOT += quantity;
2963         _mint(msg.sender, quantity);
2964     }
2965 
2966     function mintM2(uint256 quantity) external payable {
2967         require(IS_SALE_ACTIVE, "Sale haven't started");
2968         uint256 nextTokenId = _nextTokenId();
2969         require(nextTokenId + quantity <= MAX_SUPPLY, "Excedes max supply.");
2970         require(
2971             MINT_PRICE_M2 * quantity <= msg.value,
2972             "Ether value sent is not correct"
2973         );
2974 
2975         for (uint256 i = nextTokenId; i < nextTokenId + quantity; i++) {
2976             TokenTypeM2.push(i);
2977         }
2978 
2979         M2_SPOT += quantity;
2980         _mint(msg.sender, quantity);
2981     }
2982 
2983     function mintM3(uint256 quantity) external payable {
2984         require(IS_SALE_ACTIVE, "Sale haven't started");
2985         uint256 nextTokenId = _nextTokenId();
2986         require(nextTokenId + quantity <= MAX_SUPPLY, "Excedes max supply.");
2987         require(
2988             MINT_PRICE_M3 * quantity <= msg.value,
2989             "Ether value sent is not correct"
2990         );
2991 
2992         for (uint256 i = nextTokenId; i < nextTokenId + quantity; i++) {
2993             TokenTypeM3.push(i);
2994         }
2995 
2996         M3_SPOT += quantity;
2997         _mint(msg.sender, quantity);
2998     }
2999 
3000     function getM1() public view returns (uint[] memory) {
3001         return TokenTypeM1;
3002     }
3003 
3004     function getM2() public view returns (uint[] memory) {
3005         return TokenTypeM2;
3006     }
3007 
3008     function getM3() public view returns (uint[] memory) {
3009         return TokenTypeM3;
3010     }
3011 
3012     function toggleSale() public onlyOwner {
3013         IS_SALE_ACTIVE = !IS_SALE_ACTIVE;
3014     }
3015 
3016     function togglePreSale() public onlyOwner {
3017         IS_PRE_SALE_ACTIVE = !IS_PRE_SALE_ACTIVE;
3018     }
3019 
3020     function walletOfOwner(address _owner)
3021         public
3022         view
3023         returns (uint256[] memory)
3024     {
3025         uint256 ownerTokenCount = balanceOf(_owner);
3026         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
3027         uint256 currentTokenId = 1;
3028         uint256 ownedTokenIndex = 0;
3029         while (
3030             ownedTokenIndex < ownerTokenCount && currentTokenId <= MAX_SUPPLY
3031         ) {
3032             address currentTokenOwner = ownerOf(currentTokenId);
3033             if (currentTokenOwner == _owner) {
3034                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
3035                 ownedTokenIndex++;
3036             }
3037             currentTokenId++;
3038         }
3039         return ownedTokenIds;
3040     }
3041 
3042     function tokenURI(uint256 _tokenId)
3043         public
3044         view
3045         virtual
3046         override
3047         returns (string memory)
3048     {
3049         require(
3050             _exists(_tokenId),
3051             "ERC721Metadata: URI query for nonexistent token"
3052         );
3053 
3054         string memory currentBaseURI = _baseURI();
3055         return
3056             bytes(currentBaseURI).length > 0
3057                 ? string(abi.encodePacked(currentBaseURI, _tokenId.toString()))
3058                 : "";
3059     }
3060 
3061     function withdraw() public onlyOwner {
3062         uint256 balance = address(this).balance;
3063         require(balance > 0);
3064         _withdraw(
3065             0x9d479E8998626daBabb8012b2053df58060EE5E3,
3066             address(this).balance
3067         );
3068     }
3069 
3070     function _withdraw(address _address, uint256 _amount) private {
3071         (bool success, ) = _address.call{value: _amount}("");
3072         require(success, "Transfer failed.");
3073     }
3074 
3075     function setURI(string memory URI) public onlyOwner {
3076         uriPrefix = URI;
3077     }
3078 
3079     function _baseURI() internal view virtual override returns (string memory) {
3080         return uriPrefix;
3081     }
3082 
3083     function _leaf(address account) internal pure returns (bytes32) {
3084         return keccak256(abi.encodePacked(account));
3085     }
3086 
3087     function _verify(bytes32 leaf, bytes32[] memory proof)
3088         internal
3089         view
3090         returns (bool)
3091     {
3092         return MerkleProof.verify(proof, root, leaf);
3093     }
3094 }