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
925 // File: ERC721A.sol
926 
927 
928 // Creator: Chiru Labs
929 
930 pragma solidity ^0.8.4;
931 
932 
933 
934 
935 
936 
937 
938 
939 
940 error ApprovalCallerNotOwnerNorApproved();
941 error ApprovalQueryForNonexistentToken();
942 error ApproveToCaller();
943 error ApprovalToCurrentOwner();
944 error BalanceQueryForZeroAddress();
945 error MintedQueryForZeroAddress();
946 error MintToZeroAddress();
947 error MintZeroQuantity();
948 error OwnerIndexOutOfBounds();
949 error OwnerQueryForNonexistentToken();
950 error TokenIndexOutOfBounds();
951 error TransferCallerNotOwnerNorApproved();
952 error TransferFromIncorrectOwner();
953 error TransferToNonERC721ReceiverImplementer();
954 error TransferToZeroAddress();
955 error UnableDetermineTokenOwner();
956 error URIQueryForNonexistentToken();
957 
958 /**
959  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
960  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
961  *
962  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
963  *
964  * Does not support burning tokens to address(0).
965  *
966  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
967  */
968 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
969     using Address for address;
970     using Strings for uint256;
971 
972     struct TokenOwnership {
973         address addr;
974         uint64 startTimestamp;
975     }
976 
977     struct AddressData {
978         uint128 balance;
979         uint128 numberMinted;
980     }
981 
982     uint256 internal _currentIndex;
983 
984     // Token name
985     string private _name;
986 
987     // Token symbol
988     string private _symbol;
989 
990     // Mapping from token ID to ownership details
991     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
992     mapping(uint256 => TokenOwnership) internal _ownerships;
993 
994     // Mapping owner address to address data
995     mapping(address => AddressData) private _addressData;
996 
997     // Mapping from token ID to approved address
998     mapping(uint256 => address) private _tokenApprovals;
999 
1000     // Mapping from owner to operator approvals
1001     mapping(address => mapping(address => bool)) private _operatorApprovals;
1002 
1003     constructor(string memory name_, string memory symbol_) {
1004         _name = name_;
1005         _symbol = symbol_;
1006     }
1007 
1008     /**
1009      * @dev See {IERC721Enumerable-totalSupply}.
1010      */
1011     function totalSupply() public view override returns (uint256) {
1012         return _currentIndex;
1013     }
1014 
1015     /**
1016      * @dev See {IERC721Enumerable-tokenByIndex}.
1017      */
1018     function tokenByIndex(uint256 index) public view override returns (uint256) {
1019         if (index >= totalSupply()) revert TokenIndexOutOfBounds();
1020         return index;
1021     }
1022 
1023     /**
1024      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1025      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1026      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1027      */
1028     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1029         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
1030         uint256 numMintedSoFar = totalSupply();
1031         uint256 tokenIdsIdx;
1032         address currOwnershipAddr;
1033 
1034         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1035         unchecked {
1036             for (uint256 i; i < numMintedSoFar; i++) {
1037                 TokenOwnership memory ownership = _ownerships[i];
1038                 if (ownership.addr != address(0)) {
1039                     currOwnershipAddr = ownership.addr;
1040                 }
1041                 if (currOwnershipAddr == owner) {
1042                     if (tokenIdsIdx == index) {
1043                         return i;
1044                     }
1045                     tokenIdsIdx++;
1046                 }
1047             }
1048         }
1049 
1050         // Execution should never reach this point.
1051         assert(false);
1052     }
1053 
1054     /**
1055      * @dev See {IERC165-supportsInterface}.
1056      */
1057     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1058         return
1059             interfaceId == type(IERC721).interfaceId ||
1060             interfaceId == type(IERC721Metadata).interfaceId ||
1061             interfaceId == type(IERC721Enumerable).interfaceId ||
1062             super.supportsInterface(interfaceId);
1063     }
1064 
1065     /**
1066      * @dev See {IERC721-balanceOf}.
1067      */
1068     function balanceOf(address owner) public view override returns (uint256) {
1069         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1070         return uint256(_addressData[owner].balance);
1071     }
1072 
1073     function _numberMinted(address owner) internal view returns (uint256) {
1074         if (owner == address(0)) revert MintedQueryForZeroAddress();
1075         return uint256(_addressData[owner].numberMinted);
1076     }
1077 
1078     /**
1079      * Gas spent here starts off proportional to the maximum mint batch size.
1080      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1081      */
1082     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1083         if (!_exists(tokenId)) revert OwnerQueryForNonexistentToken();
1084 
1085         unchecked {
1086             for (uint256 curr = tokenId; curr >= 0; curr--) {
1087                 TokenOwnership memory ownership = _ownerships[curr];
1088                 if (ownership.addr != address(0)) {
1089                     return ownership;
1090                 }
1091             }
1092         }
1093 
1094         revert UnableDetermineTokenOwner();
1095     }
1096 
1097     /**
1098      * @dev See {IERC721-ownerOf}.
1099      */
1100     function ownerOf(uint256 tokenId) public view override returns (address) {
1101         return ownershipOf(tokenId).addr;
1102     }
1103 
1104     /**
1105      * @dev See {IERC721Metadata-name}.
1106      */
1107     function name() public view virtual override returns (string memory) {
1108         return _name;
1109     }
1110 
1111     /**
1112      * @dev See {IERC721Metadata-symbol}.
1113      */
1114     function symbol() public view virtual override returns (string memory) {
1115         return _symbol;
1116     }
1117 
1118     /**
1119      * @dev See {IERC721Metadata-tokenURI}.
1120      */
1121     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1122         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1123 
1124         string memory baseURI = _baseURI();
1125         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1126     }
1127 
1128     /**
1129      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1130      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1131      * by default, can be overriden in child contracts.
1132      */
1133     function _baseURI() internal view virtual returns (string memory) {
1134         return '';
1135     }
1136 
1137     /**
1138      * @dev See {IERC721-approve}.
1139      */
1140     function approve(address to, uint256 tokenId) public override {
1141         address owner = ERC721A.ownerOf(tokenId);
1142         if (to == owner) revert ApprovalToCurrentOwner();
1143 
1144         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) revert ApprovalCallerNotOwnerNorApproved();
1145 
1146         _approve(to, tokenId, owner);
1147     }
1148 
1149     /**
1150      * @dev See {IERC721-getApproved}.
1151      */
1152     function getApproved(uint256 tokenId) public view override returns (address) {
1153         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1154 
1155         return _tokenApprovals[tokenId];
1156     }
1157 
1158     /**
1159      * @dev See {IERC721-setApprovalForAll}.
1160      */
1161     function setApprovalForAll(address operator, bool approved) public override {
1162         if (operator == _msgSender()) revert ApproveToCaller();
1163 
1164         _operatorApprovals[_msgSender()][operator] = approved;
1165         emit ApprovalForAll(_msgSender(), operator, approved);
1166     }
1167 
1168     /**
1169      * @dev See {IERC721-isApprovedForAll}.
1170      */
1171     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1172         return _operatorApprovals[owner][operator];
1173     }
1174 
1175     /**
1176      * @dev See {IERC721-transferFrom}.
1177      */
1178     function transferFrom(
1179         address from,
1180         address to,
1181         uint256 tokenId
1182     ) public virtual override {
1183         _transfer(from, to, tokenId);
1184     }
1185 
1186     /**
1187      * @dev See {IERC721-safeTransferFrom}.
1188      */
1189     function safeTransferFrom(
1190         address from,
1191         address to,
1192         uint256 tokenId
1193     ) public virtual override {
1194         safeTransferFrom(from, to, tokenId, '');
1195     }
1196 
1197     /**
1198      * @dev See {IERC721-safeTransferFrom}.
1199      */
1200     function safeTransferFrom(
1201         address from,
1202         address to,
1203         uint256 tokenId,
1204         bytes memory _data
1205     ) public override {
1206         _transfer(from, to, tokenId);
1207         if (!_checkOnERC721Received(from, to, tokenId, _data)) revert TransferToNonERC721ReceiverImplementer();
1208     }
1209 
1210     /**
1211      * @dev Returns whether `tokenId` exists.
1212      *
1213      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1214      *
1215      * Tokens start existing when they are minted (`_mint`),
1216      */
1217     function _exists(uint256 tokenId) internal view returns (bool) {
1218         return tokenId < _currentIndex;
1219     }
1220 
1221     function _safeMint(address to, uint256 quantity) internal {
1222         _safeMint(to, quantity, '');
1223     }
1224 
1225     /**
1226      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1227      *
1228      * Requirements:
1229      *
1230      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1231      * - `quantity` must be greater than 0.
1232      *
1233      * Emits a {Transfer} event.
1234      */
1235     function _safeMint(
1236         address to,
1237         uint256 quantity,
1238         bytes memory _data
1239     ) internal {
1240         _mint(to, quantity, _data, true);
1241     }
1242 
1243     /**
1244      * @dev Mints `quantity` tokens and transfers them to `to`.
1245      *
1246      * Requirements:
1247      *
1248      * - `to` cannot be the zero address.
1249      * - `quantity` must be greater than 0.
1250      *
1251      * Emits a {Transfer} event.
1252      */
1253     function _mint(
1254         address to,
1255         uint256 quantity,
1256         bytes memory _data,
1257         bool safe
1258     ) internal {
1259         uint256 startTokenId = _currentIndex;
1260         if (to == address(0)) revert MintToZeroAddress();
1261         if (quantity == 0) revert MintZeroQuantity();
1262 
1263         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1264 
1265         // Overflows are incredibly unrealistic.
1266         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1267         // updatedIndex overflows if _currentIndex + quantity > 1.56e77 (2**256) - 1
1268         unchecked {
1269             _addressData[to].balance += uint128(quantity);
1270             _addressData[to].numberMinted += uint128(quantity);
1271 
1272             _ownerships[startTokenId].addr = to;
1273             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1274 
1275             uint256 updatedIndex = startTokenId;
1276 
1277             for (uint256 i; i < quantity; i++) {
1278                 emit Transfer(address(0), to, updatedIndex);
1279                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1280                     revert TransferToNonERC721ReceiverImplementer();
1281                 }
1282 
1283                 updatedIndex++;
1284             }
1285 
1286             _currentIndex = updatedIndex;
1287         }
1288 
1289         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1290     }
1291 
1292     /**
1293      * @dev Transfers `tokenId` from `from` to `to`.
1294      *
1295      * Requirements:
1296      *
1297      * - `to` cannot be the zero address.
1298      * - `tokenId` token must be owned by `from`.
1299      *
1300      * Emits a {Transfer} event.
1301      */
1302     function _transfer(
1303         address from,
1304         address to,
1305         uint256 tokenId
1306     ) private {
1307         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1308 
1309         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1310             getApproved(tokenId) == _msgSender() ||
1311             isApprovedForAll(prevOwnership.addr, _msgSender()));
1312 
1313         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1314         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1315         if (to == address(0)) revert TransferToZeroAddress();
1316 
1317         _beforeTokenTransfers(from, to, tokenId, 1);
1318 
1319         // Clear approvals from the previous owner
1320         _approve(address(0), tokenId, prevOwnership.addr);
1321 
1322         // Underflow of the sender's balance is impossible because we check for
1323         // ownership above and the recipient's balance can't realistically overflow.
1324         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1325         unchecked {
1326             _addressData[from].balance -= 1;
1327             _addressData[to].balance += 1;
1328 
1329             _ownerships[tokenId].addr = to;
1330             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1331 
1332             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1333             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1334             uint256 nextTokenId = tokenId + 1;
1335             if (_ownerships[nextTokenId].addr == address(0)) {
1336                 if (_exists(nextTokenId)) {
1337                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1338                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1339                 }
1340             }
1341         }
1342 
1343         emit Transfer(from, to, tokenId);
1344         _afterTokenTransfers(from, to, tokenId, 1);
1345     }
1346 
1347     /**
1348      * @dev Approve `to` to operate on `tokenId`
1349      *
1350      * Emits a {Approval} event.
1351      */
1352     function _approve(
1353         address to,
1354         uint256 tokenId,
1355         address owner
1356     ) private {
1357         _tokenApprovals[tokenId] = to;
1358         emit Approval(owner, to, tokenId);
1359     }
1360 
1361     /**
1362      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1363      * The call is not executed if the target address is not a contract.
1364      *
1365      * @param from address representing the previous owner of the given token ID
1366      * @param to target address that will receive the tokens
1367      * @param tokenId uint256 ID of the token to be transferred
1368      * @param _data bytes optional data to send along with the call
1369      * @return bool whether the call correctly returned the expected magic value
1370      */
1371     function _checkOnERC721Received(
1372         address from,
1373         address to,
1374         uint256 tokenId,
1375         bytes memory _data
1376     ) private returns (bool) {
1377         if (to.isContract()) {
1378             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1379                 return retval == IERC721Receiver(to).onERC721Received.selector;
1380             } catch (bytes memory reason) {
1381                 if (reason.length == 0) revert TransferToNonERC721ReceiverImplementer();
1382                 else {
1383                     assembly {
1384                         revert(add(32, reason), mload(reason))
1385                     }
1386                 }
1387             }
1388         } else {
1389             return true;
1390         }
1391     }
1392 
1393     /**
1394      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1395      *
1396      * startTokenId - the first token id to be transferred
1397      * quantity - the amount to be transferred
1398      *
1399      * Calling conditions:
1400      *
1401      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1402      * transferred to `to`.
1403      * - When `from` is zero, `tokenId` will be minted for `to`.
1404      */
1405     function _beforeTokenTransfers(
1406         address from,
1407         address to,
1408         uint256 startTokenId,
1409         uint256 quantity
1410     ) internal virtual {}
1411 
1412     /**
1413      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1414      * minting.
1415      *
1416      * startTokenId - the first token id to be transferred
1417      * quantity - the amount to be transferred
1418      *
1419      * Calling conditions:
1420      *
1421      * - when `from` and `to` are both non-zero.
1422      * - `from` and `to` are never both zero.
1423      */
1424     function _afterTokenTransfers(
1425         address from,
1426         address to,
1427         uint256 startTokenId,
1428         uint256 quantity
1429     ) internal virtual {}
1430 }
1431 // File: DasPepe.sol
1432 
1433 //SPDX-License-Identifier: MIT
1434 //IN BILLIONAIRE WE TRUST
1435 
1436 /*
1437 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1438 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1439 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1440 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#(((((##%&@@@@@@@@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1441 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%#(((((%@@@@@@@@@@%(@@@/,,,,,,,,,,,,,,,,,,,,./%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1442 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&#(((%@@@@%*,,**(%@@@@@@&#((#((((((((((((((((###%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1443 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#(&@@@(,/&@@@@&%#(((((((((#@%(((((((((((((((((((((((((((((#@@@@@@@@@@@@@@@@@@@@@@@@@@@
1444 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#@@/(@@@&((((((((((((((((((((@@#(((((((((((((((((((((((((((((@@@@@@@@@@@@@@@@@@@@@@@@@@@
1445 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#(((((((((((((((((((((((((((((%@%(((((((((((((((((((((((((((((&@@@@@@@@@@@@@@@@@@@@@@@@@@
1446 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%#((((((((((((((((((((((((((((((@%(((((((((((((((((((((((((((((&@@@@@@@@@@@@@@@@@@@@@@@@@@
1447 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#(((((((((((((((((((((((((((((((&&#(((((((((((((####(((((((((((@@@@@@@@@@@@@@@@@@@@@@@@@@@
1448 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@&#(((((((((((((((((####%%&&%%##(((@#((((%&&%#########%&@@@@@@(((@@@@@@@@@@@@@@@@@@@@@@@@@@@
1449 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@%((((((((((#%@@@@@&#((((((((((((((&(((((((((((((((((((((((((((((@@@@@@@@@@@@@@@@@@@@@@@@@@@
1450 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@#(((((((%#(((((((((((((((((((((((((#((((((((((((((((((((((((((((@@@@@@@@@@@@@@@@@@@@@@@@@@@
1451 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((#@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1452 @@@@@@@@@@@@@@@@@@@@@@@@@@&#((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((%@@@@@@@@@@@@@@@@@@@@@@@
1453 @@@@@@@@@@@@@@@@@@@@@@@%#(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((%@@@@@@@@@@@@@@@@@@@@@
1454 @@@@@@@@@@@@@@@@@@@@@@#(((((((%&((((@@&((((((((((((((((((((((((((((((((((((((((((((((((((((((((((%@@@@@@@@@@@@@@@@@@@@@@
1455 @@@@@@@@@@@@@@@@@@@@@%(((((((@&((((@(///@@@&#(((((((((((((((##%%&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@%(////@@@@@@@@@@@@@@@@@@@@
1456 @@@@@@@@@@@@@@@@@@@@@#(((((((&((((@@&@@#/////////(((/////////////////////////////////////////////#@@@@@@@@@@@@@@@@@@@@@@
1457 @@@@@@@@@@@@@@@@@@@@&#((((((((((((#@@&/(%@@@@%(/////////////////////////////////////////(#%@@@@@%#(#@@@@@@@@@@@@@@@@@@@@
1458 @@@@@@@@@@@@@@@@@@@@&#(((((((((((((((((@@@@#/(##%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&%%######((//////&@@@@@@@@@@@@@@@@@@@@@@@
1459 @@@@@@@@@@@@@@@@@@@@@#(((((((((((((((((((((((%@@@@@@@@@@&&%#((/////////////((((#%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1460 @@@@@@@@@@@@@@@@@@@@@@@#(((((((((((((((((((((((((((((((((((((((((((###(((((((((((((((((((((#@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1461 @@@@@@@@@@@@@@@@@@@@@@@@@@%((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((&@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1462 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1463 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#((((((((((((((((((((((((((((((((((#&(((((((((((((((((#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1464 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(((((((((((((((((((((((((((((((#%##((((((((((((((((#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1465 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&(((((#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1466 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&((((((((((((((((((((((((((((((&@@@@@%((((((((((((((((#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1467 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@((((((((((((((((((((((@&(%@#@@(((((((%@@@@@@@%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1468 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#((((((((((((((((((((((((&@#(%@%#@#((((((((((((((((@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1469 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&#(@@#((((((@@@@@@@@@@@&&((&@((#@%(@@((%@@@@&%((((((&&#%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1470 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@&#(((((((((((((((((((((((((((((%@#(#@&(#@(((((((((((((((((((((((((((#@@@@@@@@@@@@@@@@@@@@@@
1471 @@@@@@@@@@@@@@@@@@@@@@@@@@@@#(((((((((((((((((((((((((((#@@#@#((@&#(@@(((((((((((((((((((((((((((((@@@@@@@@@@@@@@@@@@@@@
1472 @@@@@@@@@@@@@@@@@@@@@@@@@@@#(((((((((((((((((((((((((((#@%(((((@@#(##@@((((((((((((((((((((&(((((((%@@@@@@@@@@@@@@@@@@@@
1473 @@@@@@@@@@@@@@@@@@@@@@@@@@#(((((((((((((((((((((((((((#@@(((((%@%(((%@&(((((((((((((((((((#@(((((((#@@@@@@@@@@@@@@@@@@@@
1474 @@@@@@@@@@@@@@@@@@@@@@@@@#(((((((((((((((@#((((((((((#@@@@%%##&&%%@@@@@#((((((((((((((((((#@@(((((((@@@@@@@@@@@@@@@@@@@@
1475 */
1476 
1477 
1478 pragma solidity ^0.8.7;
1479 
1480 
1481 
1482 
1483 contract DasPepe is ERC721A, Ownable {
1484     using Strings for uint256;
1485 
1486     uint256 public constant MAX_SUPPLY = 3333;
1487     uint256 public constant WHITELIST_PRICE = 0.0069 ether;
1488     uint256 public constant PUBLIC_PRICE = 0.01 ether;
1489 
1490     uint256 public constant MAX_QUANTITY = 1;
1491 
1492     address public constant THE_BLUFF_WALLET = 0xCF5BC8b7eA1856373d969169060e2E5fFA78825A;
1493     address public constant DEV_WALLET = 0xAf28876b65f86C0dfAa0Eb5cBe0C5Cb7abf7CC3e;
1494 
1495     mapping(address => bool) public whitelistedMint;
1496     mapping(address => bool) public publicMint;
1497     mapping(address => uint256) public holdersMintAmt;
1498 
1499     bool public mintTime = false;
1500     bool public publicMintTime = false;
1501 
1502     string private baseTokenUri = "https://stfupals.mypinata.cloud/ipfs/QmW9VzAZ8EBV4CrESYqvZkd8jCuv61gttD334WCirrp9Fj/";
1503 
1504     bytes32 public holdersMerkleRoot = 0x07e1a5b2aa5adeac0870d2eb53677fb8369dc6dd6ab197a681c912e470a63aa2;
1505     bytes32 public whitelistMerkleRoot = 0xc6447635f3e99855115175950944a899c30ce4dfd3ef7ed4361c62de21d43d7c;
1506 
1507     constructor() ERC721A("DasPepe", "DPP") {
1508 
1509         _safeMint(THE_BLUFF_WALLET, 45);
1510         _safeMint(DEV_WALLET, 10);
1511 
1512     }
1513 
1514     function holdersMint(uint256 _quantity, bytes32[] calldata _merkleProof) external payable {
1515 
1516         require(_quantity > 0, "Quantity Cant be 0");
1517         require((totalSupply() + _quantity) <= MAX_SUPPLY, "Out Of Stock!");
1518         require(mintTime, "It is not time to mint");
1519         require(holdersMintAmt[msg.sender] + _quantity <= 2, "Already Minted!");
1520         require(msg.value >= _quantity * WHITELIST_PRICE, "Not enough Ether");
1521 
1522         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1523         require(MerkleProof.verify(_merkleProof, holdersMerkleRoot, leaf), "Invalid Merkle Proof");
1524 
1525             holdersMintAmt[msg.sender] += _quantity;
1526             _safeMint(msg.sender, _quantity);
1527 
1528 
1529     }
1530 
1531     function whitelistMint(bytes32[] calldata _merkleProof) external payable {
1532 
1533         require((totalSupply() + 1) <= MAX_SUPPLY, "Out Of Stock!");
1534         require(mintTime, "It is not time to mint");
1535         require(whitelistedMint[msg.sender] == false, "Already Minted!");
1536         require(msg.value >= WHITELIST_PRICE, "Not enough Ether");
1537 
1538         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1539         require(MerkleProof.verify(_merkleProof, whitelistMerkleRoot, leaf), "Invalid Merkle Proof");
1540 
1541             whitelistedMint[msg.sender] = true;
1542             _safeMint(msg.sender, MAX_QUANTITY);
1543 
1544     }
1545 
1546     function mint() external payable {
1547 
1548         require((totalSupply() + 1) <= MAX_SUPPLY, "Out Of Stock!");
1549         require(publicMintTime, "It is not time to mint");
1550         require(publicMint[msg.sender] == false, "Already Minted!");
1551         require(msg.value >= PUBLIC_PRICE, "Not enough Ether");
1552 
1553             publicMint[msg.sender] = true;
1554             _safeMint(msg.sender, MAX_QUANTITY);
1555 
1556     }
1557 
1558     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1559         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1560 
1561         uint256 trueId = tokenId;
1562 
1563         return bytes(baseTokenUri).length > 0 ? string(abi.encodePacked(baseTokenUri, trueId.toString(), ".json")) : "";
1564     }
1565 
1566     function setTokenURI(string memory _baseTokenUri) external onlyOwner {
1567         baseTokenUri = _baseTokenUri;
1568     }
1569 
1570     function flipState() public onlyOwner {
1571 
1572         mintTime = !mintTime;
1573     }
1574 
1575     function flipStatePublic() public onlyOwner {
1576 
1577         publicMintTime = !publicMintTime;
1578     }
1579 
1580     function setHoldersMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1581 
1582         holdersMerkleRoot = _merkleRoot;
1583 
1584     }
1585 
1586     function setWhitelistMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1587 
1588         whitelistMerkleRoot = _merkleRoot;
1589 
1590     }
1591 
1592     function withdraw() external onlyOwner {
1593 
1594         uint256 balance = address(this).balance;
1595 
1596         Address.sendValue(payable(owner()), balance);
1597     }
1598 
1599 }