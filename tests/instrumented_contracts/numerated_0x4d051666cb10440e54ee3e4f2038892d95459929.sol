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
865 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
866 
867 
868 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
869 
870 pragma solidity ^0.8.0;
871 
872 
873 /**
874  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
875  * @dev See https://eips.ethereum.org/EIPS/eip-721
876  */
877 interface IERC721Enumerable is IERC721 {
878     /**
879      * @dev Returns the total amount of tokens stored by the contract.
880      */
881     function totalSupply() external view returns (uint256);
882 
883     /**
884      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
885      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
886      */
887     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
888 
889     /**
890      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
891      * Use along with {totalSupply} to enumerate all tokens.
892      */
893     function tokenByIndex(uint256 index) external view returns (uint256);
894 }
895 
896 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
897 
898 
899 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
900 
901 pragma solidity ^0.8.0;
902 
903 
904 /**
905  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
906  * @dev See https://eips.ethereum.org/EIPS/eip-721
907  */
908 interface IERC721Metadata is IERC721 {
909     /**
910      * @dev Returns the token collection name.
911      */
912     function name() external view returns (string memory);
913 
914     /**
915      * @dev Returns the token collection symbol.
916      */
917     function symbol() external view returns (string memory);
918 
919     /**
920      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
921      */
922     function tokenURI(uint256 tokenId) external view returns (string memory);
923 }
924 
925 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
926 
927 
928 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
929 
930 pragma solidity ^0.8.0;
931 
932 
933 
934 
935 
936 
937 
938 
939 /**
940  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
941  * the Metadata extension, but not including the Enumerable extension, which is available separately as
942  * {ERC721Enumerable}.
943  */
944 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
945     using Address for address;
946     using Strings for uint256;
947 
948     // Token name
949     string private _name;
950 
951     // Token symbol
952     string private _symbol;
953 
954     // Mapping from token ID to owner address
955     mapping(uint256 => address) private _owners;
956 
957     // Mapping owner address to token count
958     mapping(address => uint256) private _balances;
959 
960     // Mapping from token ID to approved address
961     mapping(uint256 => address) private _tokenApprovals;
962 
963     // Mapping from owner to operator approvals
964     mapping(address => mapping(address => bool)) private _operatorApprovals;
965 
966     /**
967      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
968      */
969     constructor(string memory name_, string memory symbol_) {
970         _name = name_;
971         _symbol = symbol_;
972     }
973 
974     /**
975      * @dev See {IERC165-supportsInterface}.
976      */
977     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
978         return
979             interfaceId == type(IERC721).interfaceId ||
980             interfaceId == type(IERC721Metadata).interfaceId ||
981             super.supportsInterface(interfaceId);
982     }
983 
984     /**
985      * @dev See {IERC721-balanceOf}.
986      */
987     function balanceOf(address owner) public view virtual override returns (uint256) {
988         require(owner != address(0), "ERC721: address zero is not a valid owner");
989         return _balances[owner];
990     }
991 
992     /**
993      * @dev See {IERC721-ownerOf}.
994      */
995     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
996         address owner = _owners[tokenId];
997         require(owner != address(0), "ERC721: invalid token ID");
998         return owner;
999     }
1000 
1001     /**
1002      * @dev See {IERC721Metadata-name}.
1003      */
1004     function name() public view virtual override returns (string memory) {
1005         return _name;
1006     }
1007 
1008     /**
1009      * @dev See {IERC721Metadata-symbol}.
1010      */
1011     function symbol() public view virtual override returns (string memory) {
1012         return _symbol;
1013     }
1014 
1015     /**
1016      * @dev See {IERC721Metadata-tokenURI}.
1017      */
1018     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1019         _requireMinted(tokenId);
1020 
1021         string memory baseURI = _baseURI();
1022         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1023     }
1024 
1025     /**
1026      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1027      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1028      * by default, can be overridden in child contracts.
1029      */
1030     function _baseURI() internal view virtual returns (string memory) {
1031         return "";
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-approve}.
1036      */
1037     function approve(address to, uint256 tokenId) public virtual override {
1038         address owner = ERC721.ownerOf(tokenId);
1039         require(to != owner, "ERC721: approval to current owner");
1040 
1041         require(
1042             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1043             "ERC721: approve caller is not token owner nor approved for all"
1044         );
1045 
1046         _approve(to, tokenId);
1047     }
1048 
1049     /**
1050      * @dev See {IERC721-getApproved}.
1051      */
1052     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1053         _requireMinted(tokenId);
1054 
1055         return _tokenApprovals[tokenId];
1056     }
1057 
1058     /**
1059      * @dev See {IERC721-setApprovalForAll}.
1060      */
1061     function setApprovalForAll(address operator, bool approved) public virtual override {
1062         _setApprovalForAll(_msgSender(), operator, approved);
1063     }
1064 
1065     /**
1066      * @dev See {IERC721-isApprovedForAll}.
1067      */
1068     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1069         return _operatorApprovals[owner][operator];
1070     }
1071 
1072     /**
1073      * @dev See {IERC721-transferFrom}.
1074      */
1075     function transferFrom(
1076         address from,
1077         address to,
1078         uint256 tokenId
1079     ) public virtual override {
1080         //solhint-disable-next-line max-line-length
1081         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1082 
1083         _transfer(from, to, tokenId);
1084     }
1085 
1086     /**
1087      * @dev See {IERC721-safeTransferFrom}.
1088      */
1089     function safeTransferFrom(
1090         address from,
1091         address to,
1092         uint256 tokenId
1093     ) public virtual override {
1094         safeTransferFrom(from, to, tokenId, "");
1095     }
1096 
1097     /**
1098      * @dev See {IERC721-safeTransferFrom}.
1099      */
1100     function safeTransferFrom(
1101         address from,
1102         address to,
1103         uint256 tokenId,
1104         bytes memory data
1105     ) public virtual override {
1106         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1107         _safeTransfer(from, to, tokenId, data);
1108     }
1109 
1110     /**
1111      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1112      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1113      *
1114      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1115      *
1116      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1117      * implement alternative mechanisms to perform token transfer, such as signature-based.
1118      *
1119      * Requirements:
1120      *
1121      * - `from` cannot be the zero address.
1122      * - `to` cannot be the zero address.
1123      * - `tokenId` token must exist and be owned by `from`.
1124      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1125      *
1126      * Emits a {Transfer} event.
1127      */
1128     function _safeTransfer(
1129         address from,
1130         address to,
1131         uint256 tokenId,
1132         bytes memory data
1133     ) internal virtual {
1134         _transfer(from, to, tokenId);
1135         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1136     }
1137 
1138     /**
1139      * @dev Returns whether `tokenId` exists.
1140      *
1141      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1142      *
1143      * Tokens start existing when they are minted (`_mint`),
1144      * and stop existing when they are burned (`_burn`).
1145      */
1146     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1147         return _owners[tokenId] != address(0);
1148     }
1149 
1150     /**
1151      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1152      *
1153      * Requirements:
1154      *
1155      * - `tokenId` must exist.
1156      */
1157     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1158         address owner = ERC721.ownerOf(tokenId);
1159         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1160     }
1161 
1162     /**
1163      * @dev Safely mints `tokenId` and transfers it to `to`.
1164      *
1165      * Requirements:
1166      *
1167      * - `tokenId` must not exist.
1168      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1169      *
1170      * Emits a {Transfer} event.
1171      */
1172     function _safeMint(address to, uint256 tokenId) internal virtual {
1173         _safeMint(to, tokenId, "");
1174     }
1175 
1176     /**
1177      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1178      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1179      */
1180     function _safeMint(
1181         address to,
1182         uint256 tokenId,
1183         bytes memory data
1184     ) internal virtual {
1185         _mint(to, tokenId);
1186         require(
1187             _checkOnERC721Received(address(0), to, tokenId, data),
1188             "ERC721: transfer to non ERC721Receiver implementer"
1189         );
1190     }
1191 
1192     /**
1193      * @dev Mints `tokenId` and transfers it to `to`.
1194      *
1195      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1196      *
1197      * Requirements:
1198      *
1199      * - `tokenId` must not exist.
1200      * - `to` cannot be the zero address.
1201      *
1202      * Emits a {Transfer} event.
1203      */
1204     function _mint(address to, uint256 tokenId) internal virtual {
1205         require(to != address(0), "ERC721: mint to the zero address");
1206         require(!_exists(tokenId), "ERC721: token already minted");
1207 
1208         _beforeTokenTransfer(address(0), to, tokenId);
1209 
1210         _balances[to] += 1;
1211         _owners[tokenId] = to;
1212 
1213         emit Transfer(address(0), to, tokenId);
1214 
1215         _afterTokenTransfer(address(0), to, tokenId);
1216     }
1217 
1218     /**
1219      * @dev Destroys `tokenId`.
1220      * The approval is cleared when the token is burned.
1221      *
1222      * Requirements:
1223      *
1224      * - `tokenId` must exist.
1225      *
1226      * Emits a {Transfer} event.
1227      */
1228     function _burn(uint256 tokenId) internal virtual {
1229         address owner = ERC721.ownerOf(tokenId);
1230 
1231         _beforeTokenTransfer(owner, address(0), tokenId);
1232 
1233         // Clear approvals
1234         _approve(address(0), tokenId);
1235 
1236         _balances[owner] -= 1;
1237         delete _owners[tokenId];
1238 
1239         emit Transfer(owner, address(0), tokenId);
1240 
1241         _afterTokenTransfer(owner, address(0), tokenId);
1242     }
1243 
1244     /**
1245      * @dev Transfers `tokenId` from `from` to `to`.
1246      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1247      *
1248      * Requirements:
1249      *
1250      * - `to` cannot be the zero address.
1251      * - `tokenId` token must be owned by `from`.
1252      *
1253      * Emits a {Transfer} event.
1254      */
1255     function _transfer(
1256         address from,
1257         address to,
1258         uint256 tokenId
1259     ) internal virtual {
1260         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1261         require(to != address(0), "ERC721: transfer to the zero address");
1262 
1263         _beforeTokenTransfer(from, to, tokenId);
1264 
1265         // Clear approvals from the previous owner
1266         _approve(address(0), tokenId);
1267 
1268         _balances[from] -= 1;
1269         _balances[to] += 1;
1270         _owners[tokenId] = to;
1271 
1272         emit Transfer(from, to, tokenId);
1273 
1274         _afterTokenTransfer(from, to, tokenId);
1275     }
1276 
1277     /**
1278      * @dev Approve `to` to operate on `tokenId`
1279      *
1280      * Emits an {Approval} event.
1281      */
1282     function _approve(address to, uint256 tokenId) internal virtual {
1283         _tokenApprovals[tokenId] = to;
1284         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1285     }
1286 
1287     /**
1288      * @dev Approve `operator` to operate on all of `owner` tokens
1289      *
1290      * Emits an {ApprovalForAll} event.
1291      */
1292     function _setApprovalForAll(
1293         address owner,
1294         address operator,
1295         bool approved
1296     ) internal virtual {
1297         require(owner != operator, "ERC721: approve to caller");
1298         _operatorApprovals[owner][operator] = approved;
1299         emit ApprovalForAll(owner, operator, approved);
1300     }
1301 
1302     /**
1303      * @dev Reverts if the `tokenId` has not been minted yet.
1304      */
1305     function _requireMinted(uint256 tokenId) internal view virtual {
1306         require(_exists(tokenId), "ERC721: invalid token ID");
1307     }
1308 
1309     /**
1310      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1311      * The call is not executed if the target address is not a contract.
1312      *
1313      * @param from address representing the previous owner of the given token ID
1314      * @param to target address that will receive the tokens
1315      * @param tokenId uint256 ID of the token to be transferred
1316      * @param data bytes optional data to send along with the call
1317      * @return bool whether the call correctly returned the expected magic value
1318      */
1319     function _checkOnERC721Received(
1320         address from,
1321         address to,
1322         uint256 tokenId,
1323         bytes memory data
1324     ) private returns (bool) {
1325         if (to.isContract()) {
1326             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1327                 return retval == IERC721Receiver.onERC721Received.selector;
1328             } catch (bytes memory reason) {
1329                 if (reason.length == 0) {
1330                     revert("ERC721: transfer to non ERC721Receiver implementer");
1331                 } else {
1332                     /// @solidity memory-safe-assembly
1333                     assembly {
1334                         revert(add(32, reason), mload(reason))
1335                     }
1336                 }
1337             }
1338         } else {
1339             return true;
1340         }
1341     }
1342 
1343     /**
1344      * @dev Hook that is called before any token transfer. This includes minting
1345      * and burning.
1346      *
1347      * Calling conditions:
1348      *
1349      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1350      * transferred to `to`.
1351      * - When `from` is zero, `tokenId` will be minted for `to`.
1352      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1353      * - `from` and `to` are never both zero.
1354      *
1355      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1356      */
1357     function _beforeTokenTransfer(
1358         address from,
1359         address to,
1360         uint256 tokenId
1361     ) internal virtual {}
1362 
1363     /**
1364      * @dev Hook that is called after any transfer of tokens. This includes
1365      * minting and burning.
1366      *
1367      * Calling conditions:
1368      *
1369      * - when `from` and `to` are both non-zero.
1370      * - `from` and `to` are never both zero.
1371      *
1372      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1373      */
1374     function _afterTokenTransfer(
1375         address from,
1376         address to,
1377         uint256 tokenId
1378     ) internal virtual {}
1379 }
1380 
1381 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1382 
1383 
1384 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1385 
1386 pragma solidity ^0.8.0;
1387 
1388 
1389 
1390 /**
1391  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1392  * enumerability of all the token ids in the contract as well as all token ids owned by each
1393  * account.
1394  */
1395 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1396     // Mapping from owner to list of owned token IDs
1397     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1398 
1399     // Mapping from token ID to index of the owner tokens list
1400     mapping(uint256 => uint256) private _ownedTokensIndex;
1401 
1402     // Array with all token ids, used for enumeration
1403     uint256[] private _allTokens;
1404 
1405     // Mapping from token id to position in the allTokens array
1406     mapping(uint256 => uint256) private _allTokensIndex;
1407 
1408     /**
1409      * @dev See {IERC165-supportsInterface}.
1410      */
1411     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1412         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1413     }
1414 
1415     /**
1416      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1417      */
1418     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1419         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1420         return _ownedTokens[owner][index];
1421     }
1422 
1423     /**
1424      * @dev See {IERC721Enumerable-totalSupply}.
1425      */
1426     function totalSupply() public view virtual override returns (uint256) {
1427         return _allTokens.length;
1428     }
1429 
1430     /**
1431      * @dev See {IERC721Enumerable-tokenByIndex}.
1432      */
1433     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1434         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1435         return _allTokens[index];
1436     }
1437 
1438     /**
1439      * @dev Hook that is called before any token transfer. This includes minting
1440      * and burning.
1441      *
1442      * Calling conditions:
1443      *
1444      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1445      * transferred to `to`.
1446      * - When `from` is zero, `tokenId` will be minted for `to`.
1447      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1448      * - `from` cannot be the zero address.
1449      * - `to` cannot be the zero address.
1450      *
1451      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1452      */
1453     function _beforeTokenTransfer(
1454         address from,
1455         address to,
1456         uint256 tokenId
1457     ) internal virtual override {
1458         super._beforeTokenTransfer(from, to, tokenId);
1459 
1460         if (from == address(0)) {
1461             _addTokenToAllTokensEnumeration(tokenId);
1462         } else if (from != to) {
1463             _removeTokenFromOwnerEnumeration(from, tokenId);
1464         }
1465         if (to == address(0)) {
1466             _removeTokenFromAllTokensEnumeration(tokenId);
1467         } else if (to != from) {
1468             _addTokenToOwnerEnumeration(to, tokenId);
1469         }
1470     }
1471 
1472     /**
1473      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1474      * @param to address representing the new owner of the given token ID
1475      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1476      */
1477     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1478         uint256 length = ERC721.balanceOf(to);
1479         _ownedTokens[to][length] = tokenId;
1480         _ownedTokensIndex[tokenId] = length;
1481     }
1482 
1483     /**
1484      * @dev Private function to add a token to this extension's token tracking data structures.
1485      * @param tokenId uint256 ID of the token to be added to the tokens list
1486      */
1487     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1488         _allTokensIndex[tokenId] = _allTokens.length;
1489         _allTokens.push(tokenId);
1490     }
1491 
1492     /**
1493      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1494      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1495      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1496      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1497      * @param from address representing the previous owner of the given token ID
1498      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1499      */
1500     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1501         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1502         // then delete the last slot (swap and pop).
1503 
1504         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1505         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1506 
1507         // When the token to delete is the last token, the swap operation is unnecessary
1508         if (tokenIndex != lastTokenIndex) {
1509             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1510 
1511             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1512             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1513         }
1514 
1515         // This also deletes the contents at the last position of the array
1516         delete _ownedTokensIndex[tokenId];
1517         delete _ownedTokens[from][lastTokenIndex];
1518     }
1519 
1520     /**
1521      * @dev Private function to remove a token from this extension's token tracking data structures.
1522      * This has O(1) time complexity, but alters the order of the _allTokens array.
1523      * @param tokenId uint256 ID of the token to be removed from the tokens list
1524      */
1525     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1526         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1527         // then delete the last slot (swap and pop).
1528 
1529         uint256 lastTokenIndex = _allTokens.length - 1;
1530         uint256 tokenIndex = _allTokensIndex[tokenId];
1531 
1532         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1533         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1534         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1535         uint256 lastTokenId = _allTokens[lastTokenIndex];
1536 
1537         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1538         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1539 
1540         // This also deletes the contents at the last position of the array
1541         delete _allTokensIndex[tokenId];
1542         _allTokens.pop();
1543     }
1544 }
1545 
1546 // File: Remaster_Enumeration.sol
1547 
1548 //SPDX-License-Identifier: Unlicense
1549 pragma solidity ^0.8.0;
1550 
1551 
1552 // import "@openzeppelin/contracts/utils/Counters.sol";
1553 
1554 
1555 
1556 /**                                         .         .
1557 8 888888888o.   8 8888888888            ,8.       ,8.                   .8.            d888888o. 8888888 8888888888 8 8888888888   8 888888888o.
1558 8 8888    `88.  8 8888                 ,888.     ,888.                 .888.         .`8888:' `88.     8 8888       8 8888         8 8888    `88.
1559 8 8888     `88  8 8888                .`8888.   .`8888.               :88888.        8.`8888.   Y8     8 8888       8 8888         8 8888     `88
1560 8 8888     ,88  8 8888               ,8.`8888. ,8.`8888.             . `88888.       `8.`8888.         8 8888       8 8888         8 8888     ,88
1561 8 8888.   ,88'  8 888888888888      ,8'8.`8888,8^8.`8888.           .8. `88888.       `8.`8888.        8 8888       8 888888888888 8 8888.   ,88'
1562 8 888888888P'   8 8888             ,8' `8.`8888' `8.`8888.         .8`8. `88888.       `8.`8888.       8 8888       8 8888         8 888888888P'
1563 8 8888`8b       8 8888            ,8'   `8.`88'   `8.`8888.       .8' `8. `88888.       `8.`8888.      8 8888       8 8888         8 8888`8b
1564 8 8888 `8b.     8 8888           ,8'     `8.`'     `8.`8888.     .8'   `8. `88888.  8b   `8.`8888.     8 8888       8 8888         8 8888 `8b.
1565 8 8888   `8b.   8 8888          ,8'       `8        `8.`8888.   .888888888. `88888. `8b.  ;8.`8888     8 8888       8 8888         8 8888   `8b.
1566 8 8888     `88. 8 888888888888 ,8'         `         `8.`8888. .8'       `8. `88888. `Y8888P ,88P'     8 8888       8 888888888888 8 8888     `88.
1567 */
1568 
1569 interface R0 {
1570     // R2 Functions
1571     function signedUpdateOwnership(
1572         uint256 _tokenId,
1573         address _owner,
1574         bytes memory readSignature,
1575         bool _signed
1576     ) external;
1577     function getNFTContract() external view returns (address);
1578     function emitLicenseOwnerChange(
1579         uint8 _licenseId,
1580         uint256 _tokenId,
1581         address _from,
1582         address _to,
1583         bytes memory _licenseHash,
1584         uint256 _expiry
1585     ) external;
1586     function getR3Address(uint8 _licenseId, uint256 _tokenId)
1587         external
1588         view
1589         returns (address);
1590     function contractHash() external view returns (string memory);
1591     function signBlock() external view returns (uint256);
1592     function getLicenseIssuedHash(uint256 _tokenId)
1593         external
1594         view
1595         returns (bytes32);
1596     function r2Transfer(
1597         address from,
1598         address to,
1599         uint256 tokenId
1600     ) external;
1601     function getLicenseHash(uint8 _licenseId, uint256 _tokenId)
1602         external
1603         view
1604         returns (bytes memory);
1605     function escrow() external view returns (address);
1606     function getAllParties()
1607         external
1608         view
1609         returns (
1610             address,
1611             uint16,
1612             address,
1613             uint16,
1614             address,
1615             uint16,
1616             address,
1617             uint16
1618         );
1619     function getBaseSigners() external view returns (address, address);
1620     // R2 - Demo functions additions
1621     function marketWhitelist(address) external view returns(bool);
1622     function isUserSignatureValid(address, uint256) external view returns(bool);
1623     // IERC721 functions:
1624     function ownerOf(uint256 tokenId) external view returns (address owner);
1625     // IERC20 functions:
1626     function balanceOf(address account) external view returns (uint256);
1627     function transfer(address to, uint256 amount) external returns (bool);
1628     // R3 Functions
1629     function getR3EscrowElements()
1630         external
1631         view
1632         returns (
1633             uint16,
1634             uint16,
1635             uint16,
1636             address,
1637             uint16
1638         );
1639     function getR2AddressFromR3() external returns (address);
1640     // Escrow Functions
1641     function receieveTo(address _to) external payable;
1642     function payCommission() external payable;
1643     function withdraw() external;
1644     // Ownable
1645     function owner() external returns (address);
1646 }
1647 
1648 contract CryptTVScamp is ERC721, Ownable, ERC721Enumerable {
1649 
1650     bytes32 constant CLAIM = keccak256("CLAIM");
1651     bytes32 constant RESERVE = keccak256("RESERVE");
1652 
1653     // using Counters for Counters.Counter;
1654 
1655     struct Claim{
1656         bool isActive;
1657         bytes32 merkleRoot;
1658         mapping(address => uint256) mintCount;
1659     }
1660 
1661     bool public isNormalTransferEnabled = true;
1662     bool public isBuyerSignatureRequired;
1663     bool public isP2PEnabled = true;
1664 
1665     uint32 public immutable maxTokens;
1666     // Counters.Counter private tokenCounter;
1667 
1668     string public provenanceHash;
1669     string public baseURI;
1670 
1671     R0 public r2Contract;
1672 
1673     mapping(bytes32=>Claim) claimData;
1674 
1675 
1676     constructor(string memory _newBaseURI, uint32 _maxTokens) ERC721("CryptTVScamp", "CTVS") {
1677         baseURI = _newBaseURI;
1678         maxTokens = _maxTokens;
1679     }
1680 
1681     // ============ ERC721Enumerable OverRides =============
1682 
1683     function _beforeTokenTransfer(
1684         address from,
1685         address to,
1686         uint256 tokenId
1687     ) internal override(ERC721, ERC721Enumerable) {
1688         super._beforeTokenTransfer(from, to, tokenId);
1689     }
1690 
1691     function supportsInterface(bytes4 interfaceId)
1692         public
1693         view
1694         override(ERC721, ERC721Enumerable)
1695         returns (bool)
1696     {
1697         return super.supportsInterface(interfaceId);
1698     }
1699 
1700     // ============ ACCESS CONTROL/SANITY MODIFIERS ============
1701 
1702     modifier claimActive(bytes32 claimType) {
1703         require(claimData[claimType].isActive, "Claim list not active");
1704         _;
1705     }
1706 
1707     modifier totalNotExceeded(uint256 numberOfTokens) {
1708         require(
1709             totalSupply() + numberOfTokens <= maxTokens,
1710             "Not enough tokens remaining to claim"
1711         );
1712         _;
1713     }
1714 
1715     modifier isValidMerkleProof(bytes32[] calldata merkleProof, bytes32 root, uint256 maxClaimable) {
1716         require(
1717             MerkleProof.verify(
1718                 merkleProof,
1719                 root,
1720                 keccak256(abi.encodePacked(msg.sender, maxClaimable))
1721             ),
1722             "Proof does not exist in tree"
1723         );
1724         _;
1725     }
1726 
1727      /// @notice Functions using this modifier can only be called by the R2 contract.
1728     modifier onlyR2() {
1729         require(msg.sender == address(r2Contract), "Only R2 can call");
1730         _;
1731     }
1732 
1733     modifier R2Defined(){
1734         require(address(r2Contract) != address(0), "R2 address not set");
1735         _;
1736     }    
1737 
1738     // ============ PUBLIC FUNCTIONS FOR CLAIMING ============
1739     function claim(uint256 numberOfTokens, uint256 maxClaimable, bytes32[] calldata merkleProof,bytes memory readSignature) external{
1740         _claim(numberOfTokens, maxClaimable, merkleProof,readSignature,CLAIM);
1741     }
1742 
1743     function claimReserve(uint256 numberOfTokens, uint256 maxClaimable, bytes32[] calldata merkleProof,bytes memory readSignature) external{
1744         _claim( numberOfTokens,  maxClaimable,  merkleProof,readSignature,RESERVE);
1745     }
1746 
1747     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
1748 
1749     function setBaseURI(string memory _newBaseURI) external onlyOwner {
1750         baseURI = _newBaseURI;
1751     }
1752 
1753     function setProvenanceHash(string memory _hash) external onlyOwner {
1754         provenanceHash = _hash;
1755     }
1756 
1757     // Toggle Claiming Active / Inactive 
1758     function setClaimingActive(bool _isClaimingActive) external onlyOwner {
1759         setClaimingActive(_isClaimingActive,CLAIM);
1760     }
1761   
1762     // Toggle Reserve Claiming Active / Inactive 
1763     function setReserveClaimingActive(bool _isReserveClaimingActive) external onlyOwner {
1764         setClaimingActive(_isReserveClaimingActive,RESERVE);
1765     }
1766 
1767     // Set Merkle Roots 
1768     function setClaimListMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1769         setMerkleRoot(_merkleRoot,CLAIM);
1770     }
1771     // Set Reserve Merkle Roots 
1772     function setReserveClaimListMerkleRoot(bytes32 _reserveMerkleRoot) external onlyOwner {
1773         setMerkleRoot(_reserveMerkleRoot,RESERVE);
1774     }
1775     
1776     /// @notice Function to flip the Normal transfers enabled 
1777     function setNormalTransferEnabled(bool _isNormalTransferEnabled) external onlyOwner {
1778         isNormalTransferEnabled = _isNormalTransferEnabled;
1779     }
1780 
1781     // Function to flip the buyer signature required state on or off
1782     function setBuyerSignatureRequired(bool _isBuyerSignatureRequired) external onlyOwner {
1783         isBuyerSignatureRequired = _isBuyerSignatureRequired;
1784     }
1785 
1786     /// @notice Function to flip the P2P transfers when buyer signature is required
1787     function setP2PTransferEnabled(bool _isP2PEnabled) external onlyOwner {
1788         isP2PEnabled = _isP2PEnabled;
1789     }
1790 
1791      //Set R2 Address for this contract
1792     function setR2Address(address _r2Address) external onlyOwner {
1793         r2Contract = R0(_r2Address);
1794     }
1795 
1796     function r2Transfer(
1797         address from,
1798         address to,
1799         uint256 tokenId
1800     ) external onlyR2 R2Defined {
1801         _safeTransfer(from, to, tokenId, "");
1802     }
1803     // ============ INTERNAL ============
1804     function setClaimingActive(bool isActive,bytes32 claimType) internal {
1805             claimData[claimType].isActive = isActive;
1806     }
1807 
1808     function setMerkleRoot(bytes32 merkleRoot,bytes32 claimType) internal {
1809         claimData[claimType].merkleRoot = merkleRoot;
1810     }
1811 
1812     function _claim(
1813         uint256 numberOfTokens,
1814         uint256 maxClaimable,
1815         bytes32[] calldata merkleProof,
1816         bytes memory readSignature,
1817         bytes32 claimType
1818     )
1819         internal
1820         claimActive(claimType)
1821         totalNotExceeded(numberOfTokens)
1822         isValidMerkleProof(merkleProof, claimData[claimType].merkleRoot, maxClaimable)
1823         R2Defined
1824     {
1825         uint256 numAlreadyMinted = claimData[claimType].mintCount[msg.sender];
1826         require(numAlreadyMinted + numberOfTokens <= maxClaimable, "Exceeds max claimable");
1827         claimData[claimType].mintCount[msg.sender] = numAlreadyMinted + numberOfTokens;
1828         uint tokenId=totalSupply() + 1;
1829         for (uint256 i = 0; i < numberOfTokens; i++) {    
1830             _safeMint(msg.sender,tokenId );
1831             r2Contract.signedUpdateOwnership(tokenId, msg.sender, readSignature, true);
1832             tokenId++;
1833         }
1834     }
1835 
1836     // ============ OVERRIDES ============
1837 
1838         function _transfer(
1839         address from,
1840         address to,
1841         uint256 tokenId
1842     ) internal  R2Defined override {
1843         if(msg.sender == address(r2Contract)){
1844             super._transfer(from,to,tokenId);
1845             return;  
1846         }
1847         require(isNormalTransferEnabled, "Disabled");
1848         // * Buyer is required to sign TOS beforehand if set to true
1849         if (isBuyerSignatureRequired || r2Contract.getLicenseIssuedHash(tokenId) != "") {
1850 
1851             // Allow/Disallow P2P transfers when isBuyerSigReq = true
1852             if (!isP2PEnabled) {
1853                 require(
1854                     r2Contract.marketWhitelist(msg.sender),
1855                     "Caller isnt whitelisted"
1856                 );
1857             }
1858             require(
1859                 r2Contract.isUserSignatureValid(to, tokenId),
1860                 "buyer hasnt signed TOS"
1861             );
1862         }
1863 
1864 
1865         super._transfer(from,to,tokenId);
1866         r2Contract.signedUpdateOwnership(tokenId, to, "", false);
1867     }
1868 
1869     function _baseURI()
1870         internal view virtual  
1871         override
1872         returns (string memory)
1873     {
1874         return baseURI;
1875     }
1876 
1877 }