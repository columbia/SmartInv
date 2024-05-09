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
324 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
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
354      * @dev Returns the address of the current owner.
355      */
356     function owner() public view virtual returns (address) {
357         return _owner;
358     }
359 
360     /**
361      * @dev Throws if called by any account other than the owner.
362      */
363     modifier onlyOwner() {
364         require(owner() == _msgSender(), "Ownable: caller is not the owner");
365         _;
366     }
367 
368     /**
369      * @dev Leaves the contract without owner. It will not be possible to call
370      * `onlyOwner` functions anymore. Can only be called by the current owner.
371      *
372      * NOTE: Renouncing ownership will leave the contract without an owner,
373      * thereby removing any functionality that is only available to the owner.
374      */
375     function renounceOwnership() public virtual onlyOwner {
376         _transferOwnership(address(0));
377     }
378 
379     /**
380      * @dev Transfers ownership of the contract to a new account (`newOwner`).
381      * Can only be called by the current owner.
382      */
383     function transferOwnership(address newOwner) public virtual onlyOwner {
384         require(newOwner != address(0), "Ownable: new owner is the zero address");
385         _transferOwnership(newOwner);
386     }
387 
388     /**
389      * @dev Transfers ownership of the contract to a new account (`newOwner`).
390      * Internal function without access restriction.
391      */
392     function _transferOwnership(address newOwner) internal virtual {
393         address oldOwner = _owner;
394         _owner = newOwner;
395         emit OwnershipTransferred(oldOwner, newOwner);
396     }
397 }
398 
399 // File: @openzeppelin/contracts/utils/Address.sol
400 
401 
402 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
403 
404 pragma solidity ^0.8.0;
405 
406 /**
407  * @dev Collection of functions related to the address type
408  */
409 library Address {
410     /**
411      * @dev Returns true if `account` is a contract.
412      *
413      * [IMPORTANT]
414      * ====
415      * It is unsafe to assume that an address for which this function returns
416      * false is an externally-owned account (EOA) and not a contract.
417      *
418      * Among others, `isContract` will return false for the following
419      * types of addresses:
420      *
421      *  - an externally-owned account
422      *  - a contract in construction
423      *  - an address where a contract will be created
424      *  - an address where a contract lived, but was destroyed
425      * ====
426      */
427     function isContract(address account) internal view returns (bool) {
428         // This method relies on extcodesize, which returns 0 for contracts in
429         // construction, since the code is only stored at the end of the
430         // constructor execution.
431 
432         uint256 size;
433         assembly {
434             size := extcodesize(account)
435         }
436         return size > 0;
437     }
438 
439     /**
440      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
441      * `recipient`, forwarding all available gas and reverting on errors.
442      *
443      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
444      * of certain opcodes, possibly making contracts go over the 2300 gas limit
445      * imposed by `transfer`, making them unable to receive funds via
446      * `transfer`. {sendValue} removes this limitation.
447      *
448      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
449      *
450      * IMPORTANT: because control is transferred to `recipient`, care must be
451      * taken to not create reentrancy vulnerabilities. Consider using
452      * {ReentrancyGuard} or the
453      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
454      */
455     function sendValue(address payable recipient, uint256 amount) internal {
456         require(address(this).balance >= amount, "Address: insufficient balance");
457 
458         (bool success, ) = recipient.call{value: amount}("");
459         require(success, "Address: unable to send value, recipient may have reverted");
460     }
461 
462     /**
463      * @dev Performs a Solidity function call using a low level `call`. A
464      * plain `call` is an unsafe replacement for a function call: use this
465      * function instead.
466      *
467      * If `target` reverts with a revert reason, it is bubbled up by this
468      * function (like regular Solidity function calls).
469      *
470      * Returns the raw returned data. To convert to the expected return value,
471      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
472      *
473      * Requirements:
474      *
475      * - `target` must be a contract.
476      * - calling `target` with `data` must not revert.
477      *
478      * _Available since v3.1._
479      */
480     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
481         return functionCall(target, data, "Address: low-level call failed");
482     }
483 
484     /**
485      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
486      * `errorMessage` as a fallback revert reason when `target` reverts.
487      *
488      * _Available since v3.1._
489      */
490     function functionCall(
491         address target,
492         bytes memory data,
493         string memory errorMessage
494     ) internal returns (bytes memory) {
495         return functionCallWithValue(target, data, 0, errorMessage);
496     }
497 
498     /**
499      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
500      * but also transferring `value` wei to `target`.
501      *
502      * Requirements:
503      *
504      * - the calling contract must have an ETH balance of at least `value`.
505      * - the called Solidity function must be `payable`.
506      *
507      * _Available since v3.1._
508      */
509     function functionCallWithValue(
510         address target,
511         bytes memory data,
512         uint256 value
513     ) internal returns (bytes memory) {
514         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
515     }
516 
517     /**
518      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
519      * with `errorMessage` as a fallback revert reason when `target` reverts.
520      *
521      * _Available since v3.1._
522      */
523     function functionCallWithValue(
524         address target,
525         bytes memory data,
526         uint256 value,
527         string memory errorMessage
528     ) internal returns (bytes memory) {
529         require(address(this).balance >= value, "Address: insufficient balance for call");
530         require(isContract(target), "Address: call to non-contract");
531 
532         (bool success, bytes memory returndata) = target.call{value: value}(data);
533         return verifyCallResult(success, returndata, errorMessage);
534     }
535 
536     /**
537      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
538      * but performing a static call.
539      *
540      * _Available since v3.3._
541      */
542     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
543         return functionStaticCall(target, data, "Address: low-level static call failed");
544     }
545 
546     /**
547      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
548      * but performing a static call.
549      *
550      * _Available since v3.3._
551      */
552     function functionStaticCall(
553         address target,
554         bytes memory data,
555         string memory errorMessage
556     ) internal view returns (bytes memory) {
557         require(isContract(target), "Address: static call to non-contract");
558 
559         (bool success, bytes memory returndata) = target.staticcall(data);
560         return verifyCallResult(success, returndata, errorMessage);
561     }
562 
563     /**
564      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
565      * but performing a delegate call.
566      *
567      * _Available since v3.4._
568      */
569     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
570         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
571     }
572 
573     /**
574      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
575      * but performing a delegate call.
576      *
577      * _Available since v3.4._
578      */
579     function functionDelegateCall(
580         address target,
581         bytes memory data,
582         string memory errorMessage
583     ) internal returns (bytes memory) {
584         require(isContract(target), "Address: delegate call to non-contract");
585 
586         (bool success, bytes memory returndata) = target.delegatecall(data);
587         return verifyCallResult(success, returndata, errorMessage);
588     }
589 
590     /**
591      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
592      * revert reason using the provided one.
593      *
594      * _Available since v4.3._
595      */
596     function verifyCallResult(
597         bool success,
598         bytes memory returndata,
599         string memory errorMessage
600     ) internal pure returns (bytes memory) {
601         if (success) {
602             return returndata;
603         } else {
604             // Look for revert reason and bubble it up if present
605             if (returndata.length > 0) {
606                 // The easiest way to bubble the revert reason is using memory via assembly
607 
608                 assembly {
609                     let returndata_size := mload(returndata)
610                     revert(add(32, returndata), returndata_size)
611                 }
612             } else {
613                 revert(errorMessage);
614             }
615         }
616     }
617 }
618 
619 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
620 
621 
622 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
623 
624 pragma solidity ^0.8.0;
625 
626 /**
627  * @title ERC721 token receiver interface
628  * @dev Interface for any contract that wants to support safeTransfers
629  * from ERC721 asset contracts.
630  */
631 interface IERC721Receiver {
632     /**
633      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
634      * by `operator` from `from`, this function is called.
635      *
636      * It must return its Solidity selector to confirm the token transfer.
637      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
638      *
639      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
640      */
641     function onERC721Received(
642         address operator,
643         address from,
644         uint256 tokenId,
645         bytes calldata data
646     ) external returns (bytes4);
647 }
648 
649 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
650 
651 
652 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
653 
654 pragma solidity ^0.8.0;
655 
656 /**
657  * @dev Interface of the ERC165 standard, as defined in the
658  * https://eips.ethereum.org/EIPS/eip-165[EIP].
659  *
660  * Implementers can declare support of contract interfaces, which can then be
661  * queried by others ({ERC165Checker}).
662  *
663  * For an implementation, see {ERC165}.
664  */
665 interface IERC165 {
666     /**
667      * @dev Returns true if this contract implements the interface defined by
668      * `interfaceId`. See the corresponding
669      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
670      * to learn more about how these ids are created.
671      *
672      * This function call must use less than 30 000 gas.
673      */
674     function supportsInterface(bytes4 interfaceId) external view returns (bool);
675 }
676 
677 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
678 
679 
680 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
681 
682 pragma solidity ^0.8.0;
683 
684 
685 /**
686  * @dev Implementation of the {IERC165} interface.
687  *
688  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
689  * for the additional interface id that will be supported. For example:
690  *
691  * ```solidity
692  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
693  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
694  * }
695  * ```
696  *
697  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
698  */
699 abstract contract ERC165 is IERC165 {
700     /**
701      * @dev See {IERC165-supportsInterface}.
702      */
703     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
704         return interfaceId == type(IERC165).interfaceId;
705     }
706 }
707 
708 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
709 
710 
711 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
712 
713 pragma solidity ^0.8.0;
714 
715 
716 /**
717  * @dev Required interface of an ERC721 compliant contract.
718  */
719 interface IERC721 is IERC165 {
720     /**
721      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
722      */
723     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
724 
725     /**
726      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
727      */
728     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
729 
730     /**
731      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
732      */
733     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
734 
735     /**
736      * @dev Returns the number of tokens in ``owner``'s account.
737      */
738     function balanceOf(address owner) external view returns (uint256 balance);
739 
740     /**
741      * @dev Returns the owner of the `tokenId` token.
742      *
743      * Requirements:
744      *
745      * - `tokenId` must exist.
746      */
747     function ownerOf(uint256 tokenId) external view returns (address owner);
748 
749     /**
750      * @dev Safely transfers `tokenId` token from `from` to `to`.
751      *
752      * Requirements:
753      *
754      * - `from` cannot be the zero address.
755      * - `to` cannot be the zero address.
756      * - `tokenId` token must exist and be owned by `from`.
757      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
758      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
759      *
760      * Emits a {Transfer} event.
761      */
762     function safeTransferFrom(
763         address from,
764         address to,
765         uint256 tokenId,
766         bytes calldata data
767     ) external;
768 
769     /**
770      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
771      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
772      *
773      * Requirements:
774      *
775      * - `from` cannot be the zero address.
776      * - `to` cannot be the zero address.
777      * - `tokenId` token must exist and be owned by `from`.
778      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
779      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
780      *
781      * Emits a {Transfer} event.
782      */
783     function safeTransferFrom(
784         address from,
785         address to,
786         uint256 tokenId
787     ) external;
788 
789     /**
790      * @dev Transfers `tokenId` token from `from` to `to`.
791      *
792      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
793      *
794      * Requirements:
795      *
796      * - `from` cannot be the zero address.
797      * - `to` cannot be the zero address.
798      * - `tokenId` token must be owned by `from`.
799      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
800      *
801      * Emits a {Transfer} event.
802      */
803     function transferFrom(
804         address from,
805         address to,
806         uint256 tokenId
807     ) external;
808 
809     /**
810      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
811      * The approval is cleared when the token is transferred.
812      *
813      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
814      *
815      * Requirements:
816      *
817      * - The caller must own the token or be an approved operator.
818      * - `tokenId` must exist.
819      *
820      * Emits an {Approval} event.
821      */
822     function approve(address to, uint256 tokenId) external;
823 
824     /**
825      * @dev Approve or remove `operator` as an operator for the caller.
826      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
827      *
828      * Requirements:
829      *
830      * - The `operator` cannot be the caller.
831      *
832      * Emits an {ApprovalForAll} event.
833      */
834     function setApprovalForAll(address operator, bool _approved) external;
835 
836     /**
837      * @dev Returns the account approved for `tokenId` token.
838      *
839      * Requirements:
840      *
841      * - `tokenId` must exist.
842      */
843     function getApproved(uint256 tokenId) external view returns (address operator);
844 
845     /**
846      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
847      *
848      * See {setApprovalForAll}
849      */
850     function isApprovedForAll(address owner, address operator) external view returns (bool);
851 }
852 
853 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
854 
855 
856 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
857 
858 pragma solidity ^0.8.0;
859 
860 
861 /**
862  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
863  * @dev See https://eips.ethereum.org/EIPS/eip-721
864  */
865 interface IERC721Metadata is IERC721 {
866     /**
867      * @dev Returns the token collection name.
868      */
869     function name() external view returns (string memory);
870 
871     /**
872      * @dev Returns the token collection symbol.
873      */
874     function symbol() external view returns (string memory);
875 
876     /**
877      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
878      */
879     function tokenURI(uint256 tokenId) external view returns (string memory);
880 }
881 
882 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
883 
884 
885 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
886 
887 pragma solidity ^0.8.0;
888 
889 
890 
891 
892 
893 
894 
895 
896 /**
897  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
898  * the Metadata extension, but not including the Enumerable extension, which is available separately as
899  * {ERC721Enumerable}.
900  */
901 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
902     using Address for address;
903     using Strings for uint256;
904 
905     // Token name
906     string private _name;
907 
908     // Token symbol
909     string private _symbol;
910 
911     // Mapping from token ID to owner address
912     mapping(uint256 => address) private _owners;
913 
914     // Mapping owner address to token count
915     mapping(address => uint256) private _balances;
916 
917     // Mapping from token ID to approved address
918     mapping(uint256 => address) private _tokenApprovals;
919 
920     // Mapping from owner to operator approvals
921     mapping(address => mapping(address => bool)) private _operatorApprovals;
922 
923     /**
924      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
925      */
926     constructor(string memory name_, string memory symbol_) {
927         _name = name_;
928         _symbol = symbol_;
929     }
930 
931     /**
932      * @dev See {IERC165-supportsInterface}.
933      */
934     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
935         return
936             interfaceId == type(IERC721).interfaceId ||
937             interfaceId == type(IERC721Metadata).interfaceId ||
938             super.supportsInterface(interfaceId);
939     }
940 
941     /**
942      * @dev See {IERC721-balanceOf}.
943      */
944     function balanceOf(address owner) public view virtual override returns (uint256) {
945         require(owner != address(0), "ERC721: address zero is not a valid owner");
946         return _balances[owner];
947     }
948 
949     /**
950      * @dev See {IERC721-ownerOf}.
951      */
952     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
953         address owner = _owners[tokenId];
954         require(owner != address(0), "ERC721: invalid token ID");
955         return owner;
956     }
957 
958     /**
959      * @dev See {IERC721Metadata-name}.
960      */
961     function name() public view virtual override returns (string memory) {
962         return _name;
963     }
964 
965     /**
966      * @dev See {IERC721Metadata-symbol}.
967      */
968     function symbol() public view virtual override returns (string memory) {
969         return _symbol;
970     }
971 
972     /**
973      * @dev See {IERC721Metadata-tokenURI}.
974      */
975     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
976         _requireMinted(tokenId);
977 
978         string memory baseURI = _baseURI();
979         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
980     }
981 
982     /**
983      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
984      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
985      * by default, can be overridden in child contracts.
986      */
987     function _baseURI() internal view virtual returns (string memory) {
988         return "";
989     }
990 
991     /**
992      * @dev See {IERC721-approve}.
993      */
994     function approve(address to, uint256 tokenId) public virtual override {
995         address owner = ERC721.ownerOf(tokenId);
996         require(to != owner, "ERC721: approval to current owner");
997 
998         require(
999             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1000             "ERC721: approve caller is not token owner nor approved for all"
1001         );
1002 
1003         _approve(to, tokenId);
1004     }
1005 
1006     /**
1007      * @dev See {IERC721-getApproved}.
1008      */
1009     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1010         _requireMinted(tokenId);
1011 
1012         return _tokenApprovals[tokenId];
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-setApprovalForAll}.
1017      */
1018     function setApprovalForAll(address operator, bool approved) public virtual override {
1019         _setApprovalForAll(_msgSender(), operator, approved);
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-isApprovedForAll}.
1024      */
1025     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1026         return _operatorApprovals[owner][operator];
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-transferFrom}.
1031      */
1032     function transferFrom(
1033         address from,
1034         address to,
1035         uint256 tokenId
1036     ) public virtual override {
1037         //solhint-disable-next-line max-line-length
1038         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1039 
1040         _transfer(from, to, tokenId);
1041     }
1042 
1043     /**
1044      * @dev See {IERC721-safeTransferFrom}.
1045      */
1046     function safeTransferFrom(
1047         address from,
1048         address to,
1049         uint256 tokenId
1050     ) public virtual override {
1051         safeTransferFrom(from, to, tokenId, "");
1052     }
1053 
1054     /**
1055      * @dev See {IERC721-safeTransferFrom}.
1056      */
1057     function safeTransferFrom(
1058         address from,
1059         address to,
1060         uint256 tokenId,
1061         bytes memory data
1062     ) public virtual override {
1063         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1064         _safeTransfer(from, to, tokenId, data);
1065     }
1066 
1067     /**
1068      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1069      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1070      *
1071      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1072      *
1073      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1074      * implement alternative mechanisms to perform token transfer, such as signature-based.
1075      *
1076      * Requirements:
1077      *
1078      * - `from` cannot be the zero address.
1079      * - `to` cannot be the zero address.
1080      * - `tokenId` token must exist and be owned by `from`.
1081      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1082      *
1083      * Emits a {Transfer} event.
1084      */
1085     function _safeTransfer(
1086         address from,
1087         address to,
1088         uint256 tokenId,
1089         bytes memory data
1090     ) internal virtual {
1091         _transfer(from, to, tokenId);
1092         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1093     }
1094 
1095     /**
1096      * @dev Returns whether `tokenId` exists.
1097      *
1098      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1099      *
1100      * Tokens start existing when they are minted (`_mint`),
1101      * and stop existing when they are burned (`_burn`).
1102      */
1103     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1104         return _owners[tokenId] != address(0);
1105     }
1106 
1107     /**
1108      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1109      *
1110      * Requirements:
1111      *
1112      * - `tokenId` must exist.
1113      */
1114     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1115         address owner = ERC721.ownerOf(tokenId);
1116         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1117     }
1118 
1119     /**
1120      * @dev Safely mints `tokenId` and transfers it to `to`.
1121      *
1122      * Requirements:
1123      *
1124      * - `tokenId` must not exist.
1125      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1126      *
1127      * Emits a {Transfer} event.
1128      */
1129     function _safeMint(address to, uint256 tokenId) internal virtual {
1130         _safeMint(to, tokenId, "");
1131     }
1132 
1133     /**
1134      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1135      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1136      */
1137     function _safeMint(
1138         address to,
1139         uint256 tokenId,
1140         bytes memory data
1141     ) internal virtual {
1142         _mint(to, tokenId);
1143         require(
1144             _checkOnERC721Received(address(0), to, tokenId, data),
1145             "ERC721: transfer to non ERC721Receiver implementer"
1146         );
1147     }
1148 
1149     /**
1150      * @dev Mints `tokenId` and transfers it to `to`.
1151      *
1152      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1153      *
1154      * Requirements:
1155      *
1156      * - `tokenId` must not exist.
1157      * - `to` cannot be the zero address.
1158      *
1159      * Emits a {Transfer} event.
1160      */
1161     function _mint(address to, uint256 tokenId) internal virtual {
1162         require(to != address(0), "ERC721: mint to the zero address");
1163         require(!_exists(tokenId), "ERC721: token already minted");
1164 
1165         _beforeTokenTransfer(address(0), to, tokenId);
1166 
1167         _balances[to] += 1;
1168         _owners[tokenId] = to;
1169 
1170         emit Transfer(address(0), to, tokenId);
1171 
1172         _afterTokenTransfer(address(0), to, tokenId);
1173     }
1174 
1175     /**
1176      * @dev Destroys `tokenId`.
1177      * The approval is cleared when the token is burned.
1178      *
1179      * Requirements:
1180      *
1181      * - `tokenId` must exist.
1182      *
1183      * Emits a {Transfer} event.
1184      */
1185     function _burn(uint256 tokenId) internal virtual {
1186         address owner = ERC721.ownerOf(tokenId);
1187 
1188         _beforeTokenTransfer(owner, address(0), tokenId);
1189 
1190         // Clear approvals
1191         _approve(address(0), tokenId);
1192 
1193         _balances[owner] -= 1;
1194         delete _owners[tokenId];
1195 
1196         emit Transfer(owner, address(0), tokenId);
1197 
1198         _afterTokenTransfer(owner, address(0), tokenId);
1199     }
1200 
1201     /**
1202      * @dev Transfers `tokenId` from `from` to `to`.
1203      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1204      *
1205      * Requirements:
1206      *
1207      * - `to` cannot be the zero address.
1208      * - `tokenId` token must be owned by `from`.
1209      *
1210      * Emits a {Transfer} event.
1211      */
1212     function _transfer(
1213         address from,
1214         address to,
1215         uint256 tokenId
1216     ) internal virtual {
1217         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1218         require(to != address(0), "ERC721: transfer to the zero address");
1219 
1220         _beforeTokenTransfer(from, to, tokenId);
1221 
1222         // Clear approvals from the previous owner
1223         _approve(address(0), tokenId);
1224 
1225         _balances[from] -= 1;
1226         _balances[to] += 1;
1227         _owners[tokenId] = to;
1228 
1229         emit Transfer(from, to, tokenId);
1230 
1231         _afterTokenTransfer(from, to, tokenId);
1232     }
1233 
1234     /**
1235      * @dev Approve `to` to operate on `tokenId`
1236      *
1237      * Emits an {Approval} event.
1238      */
1239     function _approve(address to, uint256 tokenId) internal virtual {
1240         _tokenApprovals[tokenId] = to;
1241         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1242     }
1243 
1244     /**
1245      * @dev Approve `operator` to operate on all of `owner` tokens
1246      *
1247      * Emits an {ApprovalForAll} event.
1248      */
1249     function _setApprovalForAll(
1250         address owner,
1251         address operator,
1252         bool approved
1253     ) internal virtual {
1254         require(owner != operator, "ERC721: approve to caller");
1255         _operatorApprovals[owner][operator] = approved;
1256         emit ApprovalForAll(owner, operator, approved);
1257     }
1258 
1259     /**
1260      * @dev Reverts if the `tokenId` has not been minted yet.
1261      */
1262     function _requireMinted(uint256 tokenId) internal view virtual {
1263         require(_exists(tokenId), "ERC721: invalid token ID");
1264     }
1265 
1266     /**
1267      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1268      * The call is not executed if the target address is not a contract.
1269      *
1270      * @param from address representing the previous owner of the given token ID
1271      * @param to target address that will receive the tokens
1272      * @param tokenId uint256 ID of the token to be transferred
1273      * @param data bytes optional data to send along with the call
1274      * @return bool whether the call correctly returned the expected magic value
1275      */
1276     function _checkOnERC721Received(
1277         address from,
1278         address to,
1279         uint256 tokenId,
1280         bytes memory data
1281     ) private returns (bool) {
1282         if (to.isContract()) {
1283             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1284                 return retval == IERC721Receiver.onERC721Received.selector;
1285             } catch (bytes memory reason) {
1286                 if (reason.length == 0) {
1287                     revert("ERC721: transfer to non ERC721Receiver implementer");
1288                 } else {
1289                     /// @solidity memory-safe-assembly
1290                     assembly {
1291                         revert(add(32, reason), mload(reason))
1292                     }
1293                 }
1294             }
1295         } else {
1296             return true;
1297         }
1298     }
1299 
1300     /**
1301      * @dev Hook that is called before any token transfer. This includes minting
1302      * and burning.
1303      *
1304      * Calling conditions:
1305      *
1306      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1307      * transferred to `to`.
1308      * - When `from` is zero, `tokenId` will be minted for `to`.
1309      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1310      * - `from` and `to` are never both zero.
1311      *
1312      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1313      */
1314     function _beforeTokenTransfer(
1315         address from,
1316         address to,
1317         uint256 tokenId
1318     ) internal virtual {}
1319 
1320     /**
1321      * @dev Hook that is called after any transfer of tokens. This includes
1322      * minting and burning.
1323      *
1324      * Calling conditions:
1325      *
1326      * - when `from` and `to` are both non-zero.
1327      * - `from` and `to` are never both zero.
1328      *
1329      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1330      */
1331     function _afterTokenTransfer(
1332         address from,
1333         address to,
1334         uint256 tokenId
1335     ) internal virtual {}
1336 }
1337 
1338 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1339 
1340 
1341 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
1342 
1343 pragma solidity ^0.8.0;
1344 
1345 /**
1346  * @dev Interface of the ERC20 standard as defined in the EIP.
1347  */
1348 interface IERC20 {
1349     /**
1350      * @dev Returns the amount of tokens in existence.
1351      */
1352     function totalSupply() external view returns (uint256);
1353 
1354     /**
1355      * @dev Returns the amount of tokens owned by `account`.
1356      */
1357     function balanceOf(address account) external view returns (uint256);
1358 
1359     /**
1360      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1361      *
1362      * Returns a boolean value indicating whether the operation succeeded.
1363      *
1364      * Emits a {Transfer} event.
1365      */
1366     function transfer(address recipient, uint256 amount) external returns (bool);
1367 
1368     /**
1369      * @dev Returns the remaining number of tokens that `spender` will be
1370      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1371      * zero by default.
1372      *
1373      * This value changes when {approve} or {transferFrom} are called.
1374      */
1375     function allowance(address owner, address spender) external view returns (uint256);
1376 
1377     /**
1378      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1379      *
1380      * Returns a boolean value indicating whether the operation succeeded.
1381      *
1382      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1383      * that someone may use both the old and the new allowance by unfortunate
1384      * transaction ordering. One possible solution to mitigate this race
1385      * condition is to first reduce the spender's allowance to 0 and set the
1386      * desired value afterwards:
1387      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1388      *
1389      * Emits an {Approval} event.
1390      */
1391     function approve(address spender, uint256 amount) external returns (bool);
1392 
1393     /**
1394      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1395      * allowance mechanism. `amount` is then deducted from the caller's
1396      * allowance.
1397      *
1398      * Returns a boolean value indicating whether the operation succeeded.
1399      *
1400      * Emits a {Transfer} event.
1401      */
1402     function transferFrom(
1403         address sender,
1404         address recipient,
1405         uint256 amount
1406     ) external returns (bool);
1407 
1408     /**
1409      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1410      * another (`to`).
1411      *
1412      * Note that `value` may be zero.
1413      */
1414     event Transfer(address indexed from, address indexed to, uint256 value);
1415 
1416     /**
1417      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1418      * a call to {approve}. `value` is the new allowance.
1419      */
1420     event Approval(address indexed owner, address indexed spender, uint256 value);
1421 }
1422 
1423 // File: contracts/GemApeClubNFT.sol
1424 //SPDX-License-Identifier: UNLICENSED
1425 pragma solidity ^0.8.15;
1426 
1427 
1428 
1429 contract NFT is ERC721, Ownable {
1430     uint256 private nextTokenId = 1;
1431     
1432     
1433     
1434     
1435     uint8 public mintMode = 0; 
1436     string baseExtension = ".json";
1437     string baseURI = "ipfs://QmXR6UF1Zc6AzQvBSuDrpw715pXBDScvvAhqVrHmtnbkaQ/";
1438 
1439     
1440     uint256 public mintCost = 20000000000000000; 
1441 
1442     uint16 public maxSupply = 5000;
1443     
1444     
1445     
1446     mapping (address => uint8) private whitelistA; 
1447     
1448     
1449     bytes32 public merkleRootWhiteListB = 0x00d62ab26f2f0a248831bf7c127d98c614e1cc774dc7c899a519d682e02c9c14;
1450     uint8 private freeMintsWithlistB = 2;
1451 
1452     uint8 private freePublicMints = 1; 
1453 
1454     mapping (address => uint8) private minters; 
1455 
1456     
1457     bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
1458     address private royalties_recipient;
1459     uint96 private royalties_basepoints;
1460     constructor() ERC721("GemApeClub", "GAC") {
1461     
1462         setRoyalties(msg.sender, 1000);
1463     }
1464 
1465 
1466 
1467     function cost(address account, bytes32[] calldata _merkleProof, uint16 nfts) public view returns (uint256) {
1468         
1469         uint16 _freeMintsLeft = uint16(freeMintsLeft(account, _merkleProof));
1470 
1471         
1472         if(_freeMintsLeft >= nfts) {
1473             return 0; 
1474         } else {
1475             return mintCost * (nfts - _freeMintsLeft);
1476         }
1477     }
1478 
1479 
1480     function isOnWhitelistB(address account, bytes32[] calldata _merkleProof) public view returns (bool) {
1481         
1482         bytes32 leaf = keccak256(abi.encodePacked(account));
1483         bool onWhitelistB = MerkleProof.verify(_merkleProof, merkleRootWhiteListB, leaf);
1484         return onWhitelistB;
1485     }
1486     
1487     
1488     function freeMintsLeft(address account, bytes32[] calldata _merkleProof) public view returns (uint8) { 
1489         uint8 _freeMints = whitelistA[account];
1490         if(_freeMints == 0 && isOnWhitelistB(account, _merkleProof)) { 
1491             _freeMints = freeMintsWithlistB;
1492         }
1493         if(_freeMints == 0 && mintMode>1) { 
1494             _freeMints = freePublicMints;
1495         }
1496 
1497         
1498         if(minters[account] > 0) {
1499             if(_freeMints >= minters[account]) {
1500                 _freeMints = _freeMints - minters[account];
1501             } else {
1502                 _freeMints = 0;
1503             }
1504         }
1505         return _freeMints;
1506     }
1507 
1508     
1509     function freeMintsLeftNoWL(address account) public view returns (uint8) { 
1510         uint8 _freeMints = freePublicMints;
1511 
1512         
1513         if(minters[account] > 0) {
1514             if(_freeMints >= minters[account]) {
1515                 _freeMints = _freeMints - minters[account];
1516             } else {
1517                 _freeMints = 0;
1518             }
1519         }
1520         return _freeMints;
1521     }    
1522 
1523     
1524     
1525     
1526     
1527     function mint_free() public { 
1528         require(mintMode > 1, "Not in public sale yet.");
1529         uint16 _freeMintsLeft = freeMintsLeftNoWL(msg.sender);
1530         require(_freeMintsLeft > 0, "ERROR: No free mints left for you");
1531              
1532         doMint(msg.sender, _freeMintsLeft);
1533     }
1534 
1535     
1536     
1537     
1538     
1539     
1540     function mint(uint16 _mintAmount, bytes32[] calldata _merkleProof) public payable { 
1541         require(mintMode > 0, "ERROR: Minting closed.");
1542         require(isOnWhitelistAOrB(msg.sender, _merkleProof) || mintMode > 1, "ERROR: You are not on the whitelist. Wait for public sale.");
1543 
1544         
1545         
1546         
1547         if (mintCost > 0) {
1548           require(msg.value >= cost(msg.sender, _merkleProof, _mintAmount), "ERROR: Not enough value sent to cover cost. call cost function to assess the costs.");
1549         }
1550         doMint(msg.sender, _mintAmount);
1551     }
1552 
1553     
1554     function doMint(address to, uint16 _mintAmount) private { 
1555         require(_mintAmount > 0, "ERROR: Mint amount must be > 0");
1556         require(nextTokenId-1 + _mintAmount <= maxSupply, "ERROR: Collection is fully minted!");
1557     
1558         for (uint16 i = 1; i <= _mintAmount; i++) {
1559             _safeMint(to, nextTokenId);
1560             nextTokenId++; 
1561             
1562             minters[to] = minters[to]+1;
1563         }
1564     }
1565     
1566   
1567     
1568     function mintByOwner(address to, uint16 mintAmount) public onlyOwner { 
1569         doMint(to, mintAmount);
1570     }
1571 
1572     
1573     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view returns (address receiver, uint256 royaltyAmount) {
1574         return (royalties_recipient, _salePrice * royalties_basepoints / 10000);
1575     }
1576 
1577     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721) returns (bool) {
1578         if(interfaceId == _INTERFACE_ID_ERC2981) {
1579             return true;
1580         }
1581         return super.supportsInterface(interfaceId);
1582     } 
1583 
1584      function _baseURI() internal view virtual override returns (string memory) {
1585         return baseURI;
1586     }     
1587     
1588     function tokenURI(uint256 _tokenId) public view override(ERC721) returns (string memory) {
1589         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1590         return string(abi.encodePacked(_baseURI(), Strings.toString(_tokenId), baseExtension));
1591 
1592     }
1593 
1594      
1595     function totalSupply() public view returns (uint256) {
1596         return nextTokenId-1;
1597     }
1598     
1599     function walletOfOwner(address _owner) public view returns (uint256[] memory){
1600         uint256 ownerTokenCount = balanceOf(_owner);
1601         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1602         uint256 counter = 0;
1603         for (uint256 i=1; i < nextTokenId; i++) {
1604             if(_exists(i) && ownerOf(i)==_owner)
1605             tokenIds[counter++] = i;
1606         }
1607         return tokenIds;
1608     }
1609 
1610     function setBaseURI(string memory newbaseURI) public onlyOwner {
1611         baseURI = newbaseURI;
1612     }
1613     
1614     function setExtension(string memory newbaseExtension) public onlyOwner {
1615         baseExtension = newbaseExtension;
1616     }
1617     
1618     function setMintCost(uint256 _mintCost) public onlyOwner {
1619         mintCost = _mintCost;
1620     }
1621 
1622     
1623     function setRoyalties(address _recipient, uint96 _basepoints) public onlyOwner {
1624         require(_basepoints<=10000, "Royalties: basepoint max is 10000 for 100% royalties");
1625           royalties_recipient = _recipient;
1626           royalties_basepoints = _basepoints;
1627     }
1628     
1629     
1630     function setFreeMintAmounts(uint8 _newFreeMintsWithlistB, uint8 _newFreeMintsPublic) public onlyOwner {
1631         if(freePublicMints != _newFreeMintsPublic) {
1632             freePublicMints = _newFreeMintsPublic;
1633         }
1634         if(freeMintsWithlistB != _newFreeMintsWithlistB) {
1635             freeMintsWithlistB = _newFreeMintsWithlistB;
1636         }
1637     }
1638     
1639 
1640     function setMaxSupply(uint16 _maxSupply) public onlyOwner {
1641         maxSupply = _maxSupply;
1642     }
1643 
1644     
1645     
1646     
1647     function setMintMode(uint8 _mintMode) public onlyOwner {
1648         mintMode = _mintMode;
1649     }
1650 
1651     
1652     function addWhitelistA(address[] memory accounts, uint8 amount) external onlyOwner {
1653         for (uint256 i = 0; i < accounts.length; i++) {
1654             whitelistA[accounts[i]] = amount;
1655         }
1656     }
1657 
1658    function isOnWhitelistA(address _account) public view returns (uint8) {
1659         return whitelistA[_account];
1660     }    
1661 
1662     
1663     function setMerkleRootWhiteListB(bytes32 _merkleRootWhiteListB) external onlyOwner {
1664         merkleRootWhiteListB = _merkleRootWhiteListB;
1665     }
1666 
1667 
1668     function getMerkleRootWhiteListB() public view onlyOwner returns (bytes32) {
1669         return merkleRootWhiteListB;
1670     }
1671 
1672     function isOnWhitelistAOrB(address _account, bytes32[] calldata _merkleProof) public view returns (bool){
1673         return whitelistA[_account]>0 || isOnWhitelistB(_account, _merkleProof);
1674     } 
1675 
1676     
1677     
1678     function balance() public view onlyOwner returns (uint256) {
1679         return address(this).balance;
1680     }
1681 
1682     function withdraw() public payable onlyOwner {
1683         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1684         require(os);
1685     }
1686 }