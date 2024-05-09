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
216 // File: @openzeppelin/contracts/utils/Strings.sol
217 
218 
219 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
220 
221 pragma solidity ^0.8.0;
222 
223 /**
224  * @dev String operations.
225  */
226 library Strings {
227     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
228     uint8 private constant _ADDRESS_LENGTH = 20;
229 
230     /**
231      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
232      */
233     function toString(uint256 value) internal pure returns (string memory) {
234         // Inspired by OraclizeAPI's implementation - MIT licence
235         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
236 
237         if (value == 0) {
238             return "0";
239         }
240         uint256 temp = value;
241         uint256 digits;
242         while (temp != 0) {
243             digits++;
244             temp /= 10;
245         }
246         bytes memory buffer = new bytes(digits);
247         while (value != 0) {
248             digits -= 1;
249             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
250             value /= 10;
251         }
252         return string(buffer);
253     }
254 
255     /**
256      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
257      */
258     function toHexString(uint256 value) internal pure returns (string memory) {
259         if (value == 0) {
260             return "0x00";
261         }
262         uint256 temp = value;
263         uint256 length = 0;
264         while (temp != 0) {
265             length++;
266             temp >>= 8;
267         }
268         return toHexString(value, length);
269     }
270 
271     /**
272      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
273      */
274     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
275         bytes memory buffer = new bytes(2 * length + 2);
276         buffer[0] = "0";
277         buffer[1] = "x";
278         for (uint256 i = 2 * length + 1; i > 1; --i) {
279             buffer[i] = _HEX_SYMBOLS[value & 0xf];
280             value >>= 4;
281         }
282         require(value == 0, "Strings: hex length insufficient");
283         return string(buffer);
284     }
285 
286     /**
287      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
288      */
289     function toHexString(address addr) internal pure returns (string memory) {
290         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
291     }
292 }
293 
294 // File: @openzeppelin/contracts/utils/Context.sol
295 
296 
297 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
298 
299 pragma solidity ^0.8.0;
300 
301 /**
302  * @dev Provides information about the current execution context, including the
303  * sender of the transaction and its data. While these are generally available
304  * via msg.sender and msg.data, they should not be accessed in such a direct
305  * manner, since when dealing with meta-transactions the account sending and
306  * paying for execution may not be the actual sender (as far as an application
307  * is concerned).
308  *
309  * This contract is only required for intermediate, library-like contracts.
310  */
311 abstract contract Context {
312     function _msgSender() internal view virtual returns (address) {
313         return msg.sender;
314     }
315 
316     function _msgData() internal view virtual returns (bytes calldata) {
317         return msg.data;
318     }
319 }
320 
321 // File: @openzeppelin/contracts/access/Ownable.sol
322 
323 
324 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
325 
326 pragma solidity ^0.8.0;
327 
328 
329 /**
330  * @dev Contract module which provides a basic access control mechanism, where
331  * there is an account (an owner) that can be granted exclusive access to
332  * specific functions.
333  *
334  * By default, the owner account will be the one that deploys the contract. This
335  * can later be changed with {transferOwnership}.
336  *
337  * This module is used through inheritance. It will make available the modifier
338  * `onlyOwner`, which can be applied to your functions to restrict their use to
339  * the owner.
340  */
341 abstract contract Ownable is Context {
342     address private _owner;
343 
344     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
345 
346     /**
347      * @dev Initializes the contract setting the deployer as the initial owner.
348      */
349     constructor() {
350         _transferOwnership(_msgSender());
351     }
352 
353     /**
354      * @dev Throws if called by any account other than the owner.
355      */
356     modifier onlyOwner() {
357         _checkOwner();
358         _;
359     }
360 
361     /**
362      * @dev Returns the address of the current owner.
363      */
364     function owner() public view virtual returns (address) {
365         return _owner;
366     }
367 
368     /**
369      * @dev Throws if the sender is not the owner.
370      */
371     function _checkOwner() internal view virtual {
372         require(owner() == _msgSender(), "Ownable: caller is not the owner");
373     }
374 
375     /**
376      * @dev Leaves the contract without owner. It will not be possible to call
377      * `onlyOwner` functions anymore. Can only be called by the current owner.
378      *
379      * NOTE: Renouncing ownership will leave the contract without an owner,
380      * thereby removing any functionality that is only available to the owner.
381      */
382     function renounceOwnership() public virtual onlyOwner {
383         _transferOwnership(address(0));
384     }
385 
386     /**
387      * @dev Transfers ownership of the contract to a new account (`newOwner`).
388      * Can only be called by the current owner.
389      */
390     function transferOwnership(address newOwner) public virtual onlyOwner {
391         require(newOwner != address(0), "Ownable: new owner is the zero address");
392         _transferOwnership(newOwner);
393     }
394 
395     /**
396      * @dev Transfers ownership of the contract to a new account (`newOwner`).
397      * Internal function without access restriction.
398      */
399     function _transferOwnership(address newOwner) internal virtual {
400         address oldOwner = _owner;
401         _owner = newOwner;
402         emit OwnershipTransferred(oldOwner, newOwner);
403     }
404 }
405 
406 // File: @openzeppelin/contracts/utils/Address.sol
407 
408 
409 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
410 
411 pragma solidity ^0.8.1;
412 
413 /**
414  * @dev Collection of functions related to the address type
415  */
416 library Address {
417     /**
418      * @dev Returns true if `account` is a contract.
419      *
420      * [IMPORTANT]
421      * ====
422      * It is unsafe to assume that an address for which this function returns
423      * false is an externally-owned account (EOA) and not a contract.
424      *
425      * Among others, `isContract` will return false for the following
426      * types of addresses:
427      *
428      *  - an externally-owned account
429      *  - a contract in construction
430      *  - an address where a contract will be created
431      *  - an address where a contract lived, but was destroyed
432      * ====
433      *
434      * [IMPORTANT]
435      * ====
436      * You shouldn't rely on `isContract` to protect against flash loan attacks!
437      *
438      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
439      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
440      * constructor.
441      * ====
442      */
443     function isContract(address account) internal view returns (bool) {
444         // This method relies on extcodesize/address.code.length, which returns 0
445         // for contracts in construction, since the code is only stored at the end
446         // of the constructor execution.
447 
448         return account.code.length > 0;
449     }
450 
451     /**
452      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
453      * `recipient`, forwarding all available gas and reverting on errors.
454      *
455      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
456      * of certain opcodes, possibly making contracts go over the 2300 gas limit
457      * imposed by `transfer`, making them unable to receive funds via
458      * `transfer`. {sendValue} removes this limitation.
459      *
460      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
461      *
462      * IMPORTANT: because control is transferred to `recipient`, care must be
463      * taken to not create reentrancy vulnerabilities. Consider using
464      * {ReentrancyGuard} or the
465      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
466      */
467     function sendValue(address payable recipient, uint256 amount) internal {
468         require(address(this).balance >= amount, "Address: insufficient balance");
469 
470         (bool success, ) = recipient.call{value: amount}("");
471         require(success, "Address: unable to send value, recipient may have reverted");
472     }
473 
474     /**
475      * @dev Performs a Solidity function call using a low level `call`. A
476      * plain `call` is an unsafe replacement for a function call: use this
477      * function instead.
478      *
479      * If `target` reverts with a revert reason, it is bubbled up by this
480      * function (like regular Solidity function calls).
481      *
482      * Returns the raw returned data. To convert to the expected return value,
483      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
484      *
485      * Requirements:
486      *
487      * - `target` must be a contract.
488      * - calling `target` with `data` must not revert.
489      *
490      * _Available since v3.1._
491      */
492     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
493         return functionCall(target, data, "Address: low-level call failed");
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
498      * `errorMessage` as a fallback revert reason when `target` reverts.
499      *
500      * _Available since v3.1._
501      */
502     function functionCall(
503         address target,
504         bytes memory data,
505         string memory errorMessage
506     ) internal returns (bytes memory) {
507         return functionCallWithValue(target, data, 0, errorMessage);
508     }
509 
510     /**
511      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
512      * but also transferring `value` wei to `target`.
513      *
514      * Requirements:
515      *
516      * - the calling contract must have an ETH balance of at least `value`.
517      * - the called Solidity function must be `payable`.
518      *
519      * _Available since v3.1._
520      */
521     function functionCallWithValue(
522         address target,
523         bytes memory data,
524         uint256 value
525     ) internal returns (bytes memory) {
526         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
527     }
528 
529     /**
530      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
531      * with `errorMessage` as a fallback revert reason when `target` reverts.
532      *
533      * _Available since v3.1._
534      */
535     function functionCallWithValue(
536         address target,
537         bytes memory data,
538         uint256 value,
539         string memory errorMessage
540     ) internal returns (bytes memory) {
541         require(address(this).balance >= value, "Address: insufficient balance for call");
542         require(isContract(target), "Address: call to non-contract");
543 
544         (bool success, bytes memory returndata) = target.call{value: value}(data);
545         return verifyCallResult(success, returndata, errorMessage);
546     }
547 
548     /**
549      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
550      * but performing a static call.
551      *
552      * _Available since v3.3._
553      */
554     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
555         return functionStaticCall(target, data, "Address: low-level static call failed");
556     }
557 
558     /**
559      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
560      * but performing a static call.
561      *
562      * _Available since v3.3._
563      */
564     function functionStaticCall(
565         address target,
566         bytes memory data,
567         string memory errorMessage
568     ) internal view returns (bytes memory) {
569         require(isContract(target), "Address: static call to non-contract");
570 
571         (bool success, bytes memory returndata) = target.staticcall(data);
572         return verifyCallResult(success, returndata, errorMessage);
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
577      * but performing a delegate call.
578      *
579      * _Available since v3.4._
580      */
581     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
582         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
583     }
584 
585     /**
586      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
587      * but performing a delegate call.
588      *
589      * _Available since v3.4._
590      */
591     function functionDelegateCall(
592         address target,
593         bytes memory data,
594         string memory errorMessage
595     ) internal returns (bytes memory) {
596         require(isContract(target), "Address: delegate call to non-contract");
597 
598         (bool success, bytes memory returndata) = target.delegatecall(data);
599         return verifyCallResult(success, returndata, errorMessage);
600     }
601 
602     /**
603      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
604      * revert reason using the provided one.
605      *
606      * _Available since v4.3._
607      */
608     function verifyCallResult(
609         bool success,
610         bytes memory returndata,
611         string memory errorMessage
612     ) internal pure returns (bytes memory) {
613         if (success) {
614             return returndata;
615         } else {
616             // Look for revert reason and bubble it up if present
617             if (returndata.length > 0) {
618                 // The easiest way to bubble the revert reason is using memory via assembly
619                 /// @solidity memory-safe-assembly
620                 assembly {
621                     let returndata_size := mload(returndata)
622                     revert(add(32, returndata), returndata_size)
623                 }
624             } else {
625                 revert(errorMessage);
626             }
627         }
628     }
629 }
630 
631 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
632 
633 
634 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
635 
636 pragma solidity ^0.8.0;
637 
638 /**
639  * @title ERC721 token receiver interface
640  * @dev Interface for any contract that wants to support safeTransfers
641  * from ERC721 asset contracts.
642  */
643 interface IERC721Receiver {
644     /**
645      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
646      * by `operator` from `from`, this function is called.
647      *
648      * It must return its Solidity selector to confirm the token transfer.
649      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
650      *
651      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
652      */
653     function onERC721Received(
654         address operator,
655         address from,
656         uint256 tokenId,
657         bytes calldata data
658     ) external returns (bytes4);
659 }
660 
661 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
662 
663 
664 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
665 
666 pragma solidity ^0.8.0;
667 
668 /**
669  * @dev Interface of the ERC165 standard, as defined in the
670  * https://eips.ethereum.org/EIPS/eip-165[EIP].
671  *
672  * Implementers can declare support of contract interfaces, which can then be
673  * queried by others ({ERC165Checker}).
674  *
675  * For an implementation, see {ERC165}.
676  */
677 interface IERC165 {
678     /**
679      * @dev Returns true if this contract implements the interface defined by
680      * `interfaceId`. See the corresponding
681      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
682      * to learn more about how these ids are created.
683      *
684      * This function call must use less than 30 000 gas.
685      */
686     function supportsInterface(bytes4 interfaceId) external view returns (bool);
687 }
688 
689 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
690 
691 
692 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
693 
694 pragma solidity ^0.8.0;
695 
696 
697 /**
698  * @dev Implementation of the {IERC165} interface.
699  *
700  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
701  * for the additional interface id that will be supported. For example:
702  *
703  * ```solidity
704  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
705  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
706  * }
707  * ```
708  *
709  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
710  */
711 abstract contract ERC165 is IERC165 {
712     /**
713      * @dev See {IERC165-supportsInterface}.
714      */
715     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
716         return interfaceId == type(IERC165).interfaceId;
717     }
718 }
719 
720 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
721 
722 
723 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
724 
725 pragma solidity ^0.8.0;
726 
727 
728 /**
729  * @dev Required interface of an ERC721 compliant contract.
730  */
731 interface IERC721 is IERC165 {
732     /**
733      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
734      */
735     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
736 
737     /**
738      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
739      */
740     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
741 
742     /**
743      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
744      */
745     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
746 
747     /**
748      * @dev Returns the number of tokens in ``owner``'s account.
749      */
750     function balanceOf(address owner) external view returns (uint256 balance);
751 
752     /**
753      * @dev Returns the owner of the `tokenId` token.
754      *
755      * Requirements:
756      *
757      * - `tokenId` must exist.
758      */
759     function ownerOf(uint256 tokenId) external view returns (address owner);
760 
761     /**
762      * @dev Safely transfers `tokenId` token from `from` to `to`.
763      *
764      * Requirements:
765      *
766      * - `from` cannot be the zero address.
767      * - `to` cannot be the zero address.
768      * - `tokenId` token must exist and be owned by `from`.
769      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
770      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
771      *
772      * Emits a {Transfer} event.
773      */
774     function safeTransferFrom(
775         address from,
776         address to,
777         uint256 tokenId,
778         bytes calldata data
779     ) external;
780 
781     /**
782      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
783      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
784      *
785      * Requirements:
786      *
787      * - `from` cannot be the zero address.
788      * - `to` cannot be the zero address.
789      * - `tokenId` token must exist and be owned by `from`.
790      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
791      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
792      *
793      * Emits a {Transfer} event.
794      */
795     function safeTransferFrom(
796         address from,
797         address to,
798         uint256 tokenId
799     ) external;
800 
801     /**
802      * @dev Transfers `tokenId` token from `from` to `to`.
803      *
804      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
805      *
806      * Requirements:
807      *
808      * - `from` cannot be the zero address.
809      * - `to` cannot be the zero address.
810      * - `tokenId` token must be owned by `from`.
811      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
812      *
813      * Emits a {Transfer} event.
814      */
815     function transferFrom(
816         address from,
817         address to,
818         uint256 tokenId
819     ) external;
820 
821     /**
822      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
823      * The approval is cleared when the token is transferred.
824      *
825      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
826      *
827      * Requirements:
828      *
829      * - The caller must own the token or be an approved operator.
830      * - `tokenId` must exist.
831      *
832      * Emits an {Approval} event.
833      */
834     function approve(address to, uint256 tokenId) external;
835 
836     /**
837      * @dev Approve or remove `operator` as an operator for the caller.
838      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
839      *
840      * Requirements:
841      *
842      * - The `operator` cannot be the caller.
843      *
844      * Emits an {ApprovalForAll} event.
845      */
846     function setApprovalForAll(address operator, bool _approved) external;
847 
848     /**
849      * @dev Returns the account approved for `tokenId` token.
850      *
851      * Requirements:
852      *
853      * - `tokenId` must exist.
854      */
855     function getApproved(uint256 tokenId) external view returns (address operator);
856 
857     /**
858      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
859      *
860      * See {setApprovalForAll}
861      */
862     function isApprovedForAll(address owner, address operator) external view returns (bool);
863 }
864 
865 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
866 
867 
868 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
869 
870 pragma solidity ^0.8.0;
871 
872 
873 /**
874  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
875  * @dev See https://eips.ethereum.org/EIPS/eip-721
876  */
877 interface IERC721Metadata is IERC721 {
878     /**
879      * @dev Returns the token collection name.
880      */
881     function name() external view returns (string memory);
882 
883     /**
884      * @dev Returns the token collection symbol.
885      */
886     function symbol() external view returns (string memory);
887 
888     /**
889      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
890      */
891     function tokenURI(uint256 tokenId) external view returns (string memory);
892 }
893 
894 // File: ERC721A.sol
895 
896 
897 // Creator: Chiru Labs
898 
899 pragma solidity ^0.8.4;
900 
901 
902 
903 
904 
905 
906 
907 
908 error ApprovalCallerNotOwnerNorApproved();
909 error ApprovalQueryForNonexistentToken();
910 error ApproveToCaller();
911 error ApprovalToCurrentOwner();
912 error BalanceQueryForZeroAddress();
913 error MintToZeroAddress();
914 error MintZeroQuantity();
915 error OwnerQueryForNonexistentToken();
916 error TransferCallerNotOwnerNorApproved();
917 error TransferFromIncorrectOwner();
918 error TransferToNonERC721ReceiverImplementer();
919 error TransferToZeroAddress();
920 error URIQueryForNonexistentToken();
921 
922 /**
923  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
924  * the Metadata extension. Built to optimize for lower gas during batch mints.
925  *
926  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
927  *
928  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
929  *
930  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
931  */
932 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
933     using Address for address;
934     using Strings for uint256;
935 
936     // Compiler will pack this into a single 256bit word.
937     struct TokenOwnership {
938         // The address of the owner.
939         address addr;
940         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
941         uint64 startTimestamp;
942         // Whether the token has been burned.
943         bool burned;
944     }
945 
946     // Compiler will pack this into a single 256bit word.
947     struct AddressData {
948         // Realistically, 2**64-1 is more than enough.
949         uint64 balance;
950         // Keeps track of mint count with minimal overhead for tokenomics.
951         uint64 numberMinted;
952         // Keeps track of burn count with minimal overhead for tokenomics.
953         uint64 numberBurned;
954         // For miscellaneous variable(s) pertaining to the address
955         // (e.g. number of whitelist mint slots used).
956         // If there are multiple variables, please pack them into a uint64.
957         uint64 aux;
958     }
959 
960     // The tokenId of the next token to be minted.
961     uint256 internal _currentIndex;
962 
963     // The number of tokens burned.
964     uint256 internal _burnCounter;
965 
966     // Token name
967     string private _name;
968 
969     // Token symbol
970     string private _symbol;
971 
972     // Mapping from token ID to ownership details
973     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
974     mapping(uint256 => TokenOwnership) internal _ownerships;
975 
976     // Mapping owner address to address data
977     mapping(address => AddressData) private _addressData;
978 
979     // Mapping from token ID to approved address
980     mapping(uint256 => address) private _tokenApprovals;
981 
982     // Mapping from owner to operator approvals
983     mapping(address => mapping(address => bool)) private _operatorApprovals;
984 
985     constructor(string memory name_, string memory symbol_) {
986         _name = name_;
987         _symbol = symbol_;
988         _currentIndex = _startTokenId();
989     }
990 
991     /**
992      * To change the starting tokenId, please override this function.
993      */
994     function _startTokenId() internal view virtual returns (uint256) {
995         return 1;
996     }
997 
998     /**
999      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1000      */
1001     function totalSupply() public view returns (uint256) {
1002         // Counter underflow is impossible as _burnCounter cannot be incremented
1003         // more than _currentIndex - _startTokenId() times
1004         unchecked {
1005             return _currentIndex - _burnCounter - _startTokenId();
1006         }
1007     }
1008 
1009     /**
1010      * Returns the total amount of tokens minted in the contract.
1011      */
1012     function _totalMinted() internal view returns (uint256) {
1013         // Counter underflow is impossible as _currentIndex does not decrement,
1014         // and it is initialized to _startTokenId()
1015         unchecked {
1016             return _currentIndex - _startTokenId();
1017         }
1018     }
1019 
1020     /**
1021      * @dev See {IERC165-supportsInterface}.
1022      */
1023     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1024         return
1025             interfaceId == type(IERC721).interfaceId ||
1026             interfaceId == type(IERC721Metadata).interfaceId ||
1027             super.supportsInterface(interfaceId);
1028     }
1029 
1030     /**
1031      * @dev See {IERC721-balanceOf}.
1032      */
1033     function balanceOf(address owner) public view override returns (uint256) {
1034         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1035         return uint256(_addressData[owner].balance);
1036     }
1037 
1038     /**
1039      * Returns the number of tokens minted by `owner`.
1040      */
1041     function _numberMinted(address owner) internal view returns (uint256) {
1042         return uint256(_addressData[owner].numberMinted);
1043     }
1044 
1045     /**
1046      * Returns the number of tokens burned by or on behalf of `owner`.
1047      */
1048     function _numberBurned(address owner) internal view returns (uint256) {
1049         return uint256(_addressData[owner].numberBurned);
1050     }
1051 
1052     /**
1053      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1054      */
1055     function _getAux(address owner) internal view returns (uint64) {
1056         return _addressData[owner].aux;
1057     }
1058 
1059     /**
1060      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1061      * If there are multiple variables, please pack them into a uint64.
1062      */
1063     function _setAux(address owner, uint64 aux) internal {
1064         _addressData[owner].aux = aux;
1065     }
1066 
1067     /**
1068      * Gas spent here starts off proportional to the maximum mint batch size.
1069      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1070      */
1071     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1072         uint256 curr = tokenId;
1073 
1074         unchecked {
1075             if (_startTokenId() <= curr && curr < _currentIndex) {
1076                 TokenOwnership memory ownership = _ownerships[curr];
1077                 if (!ownership.burned) {
1078                     if (ownership.addr != address(0)) {
1079                         return ownership;
1080                     }
1081                     // Invariant:
1082                     // There will always be an ownership that has an address and is not burned
1083                     // before an ownership that does not have an address and is not burned.
1084                     // Hence, curr will not underflow.
1085                     while (true) {
1086                         curr--;
1087                         ownership = _ownerships[curr];
1088                         if (ownership.addr != address(0)) {
1089                             return ownership;
1090                         }
1091                     }
1092                 }
1093             }
1094         }
1095         revert OwnerQueryForNonexistentToken();
1096     }
1097 
1098     /**
1099      * @dev See {IERC721-ownerOf}.
1100      */
1101     function ownerOf(uint256 tokenId) public view override returns (address) {
1102         return _ownershipOf(tokenId).addr;
1103     }
1104 
1105     /**
1106      * @dev See {IERC721Metadata-name}.
1107      */
1108     function name() public view virtual override returns (string memory) {
1109         return _name;
1110     }
1111 
1112     /**
1113      * @dev See {IERC721Metadata-symbol}.
1114      */
1115     function symbol() public view virtual override returns (string memory) {
1116         return _symbol;
1117     }
1118 
1119     /**
1120      * @dev See {IERC721Metadata-tokenURI}.
1121      */
1122     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1123         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1124 
1125         string memory baseURI = _baseURI();
1126         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1127     }
1128 
1129     /**
1130      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1131      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1132      * by default, can be overriden in child contracts.
1133      */
1134     function _baseURI() internal view virtual returns (string memory) {
1135         return '';
1136     }
1137 
1138     /**
1139      * @dev See {IERC721-approve}.
1140      */
1141     function approve(address to, uint256 tokenId) public override {
1142         address owner = ERC721A.ownerOf(tokenId);
1143         if (to == owner) revert ApprovalToCurrentOwner();
1144 
1145         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1146             revert ApprovalCallerNotOwnerNorApproved();
1147         }
1148 
1149         _approve(to, tokenId, owner);
1150     }
1151 
1152     /**
1153      * @dev See {IERC721-getApproved}.
1154      */
1155     function getApproved(uint256 tokenId) public view override returns (address) {
1156         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1157 
1158         return _tokenApprovals[tokenId];
1159     }
1160 
1161     /**
1162      * @dev See {IERC721-setApprovalForAll}.
1163      */
1164     function setApprovalForAll(address operator, bool approved) public virtual override {
1165         if (operator == _msgSender()) revert ApproveToCaller();
1166 
1167         _operatorApprovals[_msgSender()][operator] = approved;
1168         emit ApprovalForAll(_msgSender(), operator, approved);
1169     }
1170 
1171     /**
1172      * @dev See {IERC721-isApprovedForAll}.
1173      */
1174     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1175         return _operatorApprovals[owner][operator];
1176     }
1177 
1178     /**
1179      * @dev See {IERC721-transferFrom}.
1180      */
1181     function transferFrom(
1182         address from,
1183         address to,
1184         uint256 tokenId
1185     ) public virtual override {
1186         _transfer(from, to, tokenId);
1187     }
1188 
1189     /**
1190      * @dev See {IERC721-safeTransferFrom}.
1191      */
1192     function safeTransferFrom(
1193         address from,
1194         address to,
1195         uint256 tokenId
1196     ) public virtual override {
1197         safeTransferFrom(from, to, tokenId, '');
1198     }
1199 
1200     /**
1201      * @dev See {IERC721-safeTransferFrom}.
1202      */
1203     function safeTransferFrom(
1204         address from,
1205         address to,
1206         uint256 tokenId,
1207         bytes memory _data
1208     ) public virtual override {
1209         _transfer(from, to, tokenId);
1210         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1211             revert TransferToNonERC721ReceiverImplementer();
1212         }
1213     }
1214 
1215     /**
1216      * @dev Returns whether `tokenId` exists.
1217      *
1218      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1219      *
1220      * Tokens start existing when they are minted (`_mint`),
1221      */
1222     function _exists(uint256 tokenId) internal view returns (bool) {
1223         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1224     }
1225 
1226     function _safeMint(address to, uint256 quantity) internal {
1227         _safeMint(to, quantity, '');
1228     }
1229 
1230     /**
1231      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1232      *
1233      * Requirements:
1234      *
1235      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1236      * - `quantity` must be greater than 0.
1237      *
1238      * Emits a {Transfer} event.
1239      */
1240     function _safeMint(
1241         address to,
1242         uint256 quantity,
1243         bytes memory _data
1244     ) internal {
1245         _mint(to, quantity, _data, true);
1246     }
1247 
1248     /**
1249      * @dev Mints `quantity` tokens and transfers them to `to`.
1250      *
1251      * Requirements:
1252      *
1253      * - `to` cannot be the zero address.
1254      * - `quantity` must be greater than 0.
1255      *
1256      * Emits a {Transfer} event.
1257      */
1258     function _mint(
1259         address to,
1260         uint256 quantity,
1261         bytes memory _data,
1262         bool safe
1263     ) internal {
1264         uint256 startTokenId = _currentIndex;
1265         if (to == address(0)) revert MintToZeroAddress();
1266         if (quantity == 0) revert MintZeroQuantity();
1267 
1268         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1269 
1270         // Overflows are incredibly unrealistic.
1271         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1272         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1273         unchecked {
1274             _addressData[to].balance += uint64(quantity);
1275             _addressData[to].numberMinted += uint64(quantity);
1276 
1277             _ownerships[startTokenId].addr = to;
1278             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1279 
1280             uint256 updatedIndex = startTokenId;
1281             uint256 end = updatedIndex + quantity;
1282 
1283             if (safe && to.isContract()) {
1284                 do {
1285                     emit Transfer(address(0), to, updatedIndex);
1286                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1287                         revert TransferToNonERC721ReceiverImplementer();
1288                     }
1289                 } while (updatedIndex != end);
1290                 // Reentrancy protection
1291                 if (_currentIndex != startTokenId) revert();
1292             } else {
1293                 do {
1294                     emit Transfer(address(0), to, updatedIndex++);
1295                 } while (updatedIndex != end);
1296             }
1297             _currentIndex = updatedIndex;
1298         }
1299         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1300     }
1301 
1302     /**
1303      * @dev Transfers `tokenId` from `from` to `to`.
1304      *
1305      * Requirements:
1306      *
1307      * - `to` cannot be the zero address.
1308      * - `tokenId` token must be owned by `from`.
1309      *
1310      * Emits a {Transfer} event.
1311      */
1312     function _transfer(
1313         address from,
1314         address to,
1315         uint256 tokenId
1316     ) private {
1317         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1318 
1319         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1320 
1321         bool isApprovedOrOwner = (_msgSender() == from ||
1322             isApprovedForAll(from, _msgSender()) ||
1323             getApproved(tokenId) == _msgSender());
1324 
1325         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1326         if (to == address(0)) revert TransferToZeroAddress();
1327 
1328         _beforeTokenTransfers(from, to, tokenId, 1);
1329 
1330         // Clear approvals from the previous owner
1331         _approve(address(0), tokenId, from);
1332 
1333         // Underflow of the sender's balance is impossible because we check for
1334         // ownership above and the recipient's balance can't realistically overflow.
1335         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1336         unchecked {
1337             _addressData[from].balance -= 1;
1338             _addressData[to].balance += 1;
1339 
1340             TokenOwnership storage currSlot = _ownerships[tokenId];
1341             currSlot.addr = to;
1342             currSlot.startTimestamp = uint64(block.timestamp);
1343 
1344             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1345             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1346             uint256 nextTokenId = tokenId + 1;
1347             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1348             if (nextSlot.addr == address(0)) {
1349                 // This will suffice for checking _exists(nextTokenId),
1350                 // as a burned slot cannot contain the zero address.
1351                 if (nextTokenId != _currentIndex) {
1352                     nextSlot.addr = from;
1353                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1354                 }
1355             }
1356         }
1357 
1358         emit Transfer(from, to, tokenId);
1359         _afterTokenTransfers(from, to, tokenId, 1);
1360     }
1361 
1362     /**
1363      * @dev This is equivalent to _burn(tokenId, false)
1364      */
1365     function _burn(uint256 tokenId) internal virtual {
1366         _burn(tokenId, false);
1367     }
1368 
1369     /**
1370      * @dev Destroys `tokenId`.
1371      * The approval is cleared when the token is burned.
1372      *
1373      * Requirements:
1374      *
1375      * - `tokenId` must exist.
1376      *
1377      * Emits a {Transfer} event.
1378      */
1379     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1380         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1381 
1382         address from = prevOwnership.addr;
1383 
1384         if (approvalCheck) {
1385             bool isApprovedOrOwner = (_msgSender() == from ||
1386                 isApprovedForAll(from, _msgSender()) ||
1387                 getApproved(tokenId) == _msgSender());
1388 
1389             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1390         }
1391 
1392         _beforeTokenTransfers(from, address(0), tokenId, 1);
1393 
1394         // Clear approvals from the previous owner
1395         _approve(address(0), tokenId, from);
1396 
1397         // Underflow of the sender's balance is impossible because we check for
1398         // ownership above and the recipient's balance can't realistically overflow.
1399         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1400         unchecked {
1401             AddressData storage addressData = _addressData[from];
1402             addressData.balance -= 1;
1403             addressData.numberBurned += 1;
1404 
1405             // Keep track of who burned the token, and the timestamp of burning.
1406             TokenOwnership storage currSlot = _ownerships[tokenId];
1407             currSlot.addr = from;
1408             currSlot.startTimestamp = uint64(block.timestamp);
1409             currSlot.burned = true;
1410 
1411             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1412             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1413             uint256 nextTokenId = tokenId + 1;
1414             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1415             if (nextSlot.addr == address(0)) {
1416                 // This will suffice for checking _exists(nextTokenId),
1417                 // as a burned slot cannot contain the zero address.
1418                 if (nextTokenId != _currentIndex) {
1419                     nextSlot.addr = from;
1420                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1421                 }
1422             }
1423         }
1424 
1425         emit Transfer(from, address(0), tokenId);
1426         _afterTokenTransfers(from, address(0), tokenId, 1);
1427 
1428         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1429         unchecked {
1430             _burnCounter++;
1431         }
1432     }
1433 
1434     /**
1435      * @dev Approve `to` to operate on `tokenId`
1436      *
1437      * Emits a {Approval} event.
1438      */
1439     function _approve(
1440         address to,
1441         uint256 tokenId,
1442         address owner
1443     ) private {
1444         _tokenApprovals[tokenId] = to;
1445         emit Approval(owner, to, tokenId);
1446     }
1447 
1448     /**
1449      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1450      *
1451      * @param from address representing the previous owner of the given token ID
1452      * @param to target address that will receive the tokens
1453      * @param tokenId uint256 ID of the token to be transferred
1454      * @param _data bytes optional data to send along with the call
1455      * @return bool whether the call correctly returned the expected magic value
1456      */
1457     function _checkContractOnERC721Received(
1458         address from,
1459         address to,
1460         uint256 tokenId,
1461         bytes memory _data
1462     ) private returns (bool) {
1463         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1464             return retval == IERC721Receiver(to).onERC721Received.selector;
1465         } catch (bytes memory reason) {
1466             if (reason.length == 0) {
1467                 revert TransferToNonERC721ReceiverImplementer();
1468             } else {
1469                 assembly {
1470                     revert(add(32, reason), mload(reason))
1471                 }
1472             }
1473         }
1474     }
1475 
1476     /**
1477      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1478      * And also called before burning one token.
1479      *
1480      * startTokenId - the first token id to be transferred
1481      * quantity - the amount to be transferred
1482      *
1483      * Calling conditions:
1484      *
1485      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1486      * transferred to `to`.
1487      * - When `from` is zero, `tokenId` will be minted for `to`.
1488      * - When `to` is zero, `tokenId` will be burned by `from`.
1489      * - `from` and `to` are never both zero.
1490      */
1491     function _beforeTokenTransfers(
1492         address from,
1493         address to,
1494         uint256 startTokenId,
1495         uint256 quantity
1496     ) internal virtual {}
1497 
1498     /**
1499      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1500      * minting.
1501      * And also called after one token has been burned.
1502      *
1503      * startTokenId - the first token id to be transferred
1504      * quantity - the amount to be transferred
1505      *
1506      * Calling conditions:
1507      *
1508      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1509      * transferred to `to`.
1510      * - When `from` is zero, `tokenId` has been minted for `to`.
1511      * - When `to` is zero, `tokenId` has been burned by `from`.
1512      * - `from` and `to` are never both zero.
1513      */
1514     function _afterTokenTransfers(
1515         address from,
1516         address to,
1517         uint256 startTokenId,
1518         uint256 quantity
1519     ) internal virtual {}
1520 }
1521 // File: KyoshiKingdom.sol
1522 
1523 
1524 pragma solidity ^0.8.0;
1525 
1526 
1527 
1528 
1529 
1530 contract KyoshiKingdom is ERC721A, Ownable {
1531     using Strings for uint256;
1532 
1533     string public hiddenMetadataUri = "ipfs://QmRF79vsaSFruJ1unds8MUCEDiBvmAXgnapkXmBWNuXMMT/hidden.json";
1534     string public baseURI;
1535     string public baseExtension = ".json";
1536     bool public presale = false;
1537     bool public publicSale = false;
1538     bool public revealed;
1539     bytes32 public merkleRoot;
1540     uint256 public maxSupply = 5555;
1541     uint256 public freeSupply = 555;
1542     uint256 public maxWhitelist = 8;
1543     uint256 public maxPublic = 8;
1544     uint256 public maxFreeMint = 1;
1545     uint256 public maxPerTx = 4;
1546     uint256 public presaleCost = .02 ether;
1547     uint256 public publicCost = .02 ether;
1548 
1549 
1550     constructor(string memory _initBaseURI) ERC721A("Kyoshi's Kingdom", "KK") {
1551         setBaseURI(_initBaseURI);
1552     }
1553 
1554     // whitelist mint
1555     function whitelistMint(uint256 quantity, bytes32[] calldata _merkleProof)
1556         public
1557         payable
1558     {
1559         require(presale, "The whitelist sale is not enabled!"); 
1560         uint256 supply = totalSupply();
1561         require(quantity > 0, "Quantity Must Be Higher Than Zero");
1562         require(quantity <= maxPerTx, "Quantity Exceeds The Limit");
1563         require(supply + quantity <= maxSupply, "Max Supply Reached");
1564         require(
1565             balanceOf(msg.sender) + quantity <= maxWhitelist,
1566             "You're not allowed to mint this Much!"
1567         );
1568         require(msg.value >= presaleCost * quantity, "Not enough ether!");
1569 
1570         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1571         require(
1572             MerkleProof.verify(_merkleProof, merkleRoot, leaf),
1573             "Invalid proof!"
1574         );
1575 
1576         _safeMint(msg.sender, quantity);
1577 
1578     }
1579 
1580     // public mint
1581     function mint(uint256 quantity) external payable {
1582         require(publicSale, "The public sale is not enabled!");
1583         uint256 supply = totalSupply();
1584         require(quantity > 0, "Quantity must be higher than zero!");
1585         
1586 
1587         if (supply < freeSupply) {
1588             require(
1589                 balanceOf(msg.sender) + quantity <= maxFreeMint,
1590                 "You're not allowed to mint this Much!"
1591             );
1592         } else {
1593             require(quantity <= maxPerTx, "Quantity Exceeds The Limit");
1594             require(supply + quantity <= maxSupply, "Max supply reached!");
1595             require(
1596                 balanceOf(msg.sender) + quantity <= maxPublic,
1597                 "You're not allowed to mint this Much!"
1598             );
1599             require(msg.value >= publicCost * quantity, "Not enough ether!");
1600         }
1601 
1602         _safeMint(msg.sender, quantity);
1603     }
1604 
1605     function devMint(uint256 quantity) external onlyOwner {
1606         uint256 supply = totalSupply();
1607         require(quantity > 0, "Quantity must be higher than zero!");
1608         require(supply + quantity <= maxSupply, "Max supply reached!");
1609         _safeMint(msg.sender, quantity);
1610     }
1611 
1612     // internal
1613     function _baseURI() internal view virtual override returns (string memory) {
1614         return baseURI;
1615     }
1616 
1617     function tokenURI(uint256 tokenId)
1618         public
1619         view
1620         virtual
1621         override
1622         returns (string memory)
1623     {
1624         require(
1625             _exists(tokenId),
1626             "ERC721Metadata: URI query for nonexistent token"
1627         );
1628 
1629         if (!revealed) {
1630             return hiddenMetadataUri;
1631         }
1632 
1633         string memory currentBaseURI = _baseURI();
1634 
1635         return
1636             bytes(currentBaseURI).length > 0
1637                 ? string(
1638                     abi.encodePacked(
1639                         currentBaseURI,
1640                         tokenId.toString(),
1641                         baseExtension
1642                     )
1643                 )
1644                 : "";
1645     }
1646 
1647     function setMaxSupply(uint256 _amount) public onlyOwner {
1648         maxSupply = _amount;
1649     }
1650 
1651     function setFreeSupply(uint256 _amount) public onlyOwner {
1652         freeSupply = _amount;
1653     }
1654 
1655     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1656         merkleRoot = _merkleRoot;
1657     }
1658 
1659     function setSale(bool _presale, bool _publicSale) public onlyOwner {
1660         presale = _presale;
1661         publicSale = _publicSale;
1662     }
1663 
1664     function setMax(uint256 _presale, uint256 _public, uint256 _free) public onlyOwner {
1665         maxWhitelist = _presale;
1666         maxPublic = _public;
1667         maxFreeMint = _free;
1668     }
1669 
1670     function setTx(uint256 _amount) public onlyOwner {
1671         maxPerTx = _amount;
1672     }
1673 
1674     function setPrice(uint256 _whitelistCost, uint256 _publicCost) public onlyOwner {
1675         presaleCost = _whitelistCost;
1676         publicCost = _publicCost;
1677     }
1678 
1679     function setReveal(bool _state) public onlyOwner {
1680         revealed = _state;
1681     }
1682 
1683     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1684         baseURI = _newBaseURI;
1685     }
1686 
1687     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1688         hiddenMetadataUri = _hiddenMetadataUri;
1689     }
1690 
1691     function airdrop(uint256 quantity, address _address) public onlyOwner {
1692         uint256 supply = totalSupply();
1693         require(quantity > 0, "Quantity must be higher than zero!");
1694         require(supply + quantity <= maxSupply, "Max supply reached!");
1695         _safeMint(_address, quantity);
1696     }
1697 
1698     function setBaseExtension(string memory _newBaseExtension)
1699         public
1700         onlyOwner
1701     {
1702         baseExtension = _newBaseExtension;
1703     }
1704 
1705     function withdraw() public onlyOwner {
1706         (bool ts, ) = payable(owner()).call{value: address(this).balance}("");
1707         require(ts);
1708     }
1709 }