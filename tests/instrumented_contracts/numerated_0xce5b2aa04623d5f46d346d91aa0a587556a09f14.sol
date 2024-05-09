1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/MerkleProof.sol
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
216 // File: contracts/MisfitsNFT.sol
217 
218 /**
219  *Submitted for verification at Etherscan.io on 2022-07-26
220 */
221 
222 // File: @openzeppelin/contracts/utils/Strings.sol
223 
224 
225 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
226 
227 pragma solidity ^0.8.0;
228 
229 /**
230  * @dev String operations.
231  */
232 library Strings {
233     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
234 
235     /**
236      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
237      */
238     function toString(uint256 value) internal pure returns (string memory) {
239         // Inspired by OraclizeAPI's implementation - MIT licence
240         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
241 
242         if (value == 0) {
243             return "0";
244         }
245         uint256 temp = value;
246         uint256 digits;
247         while (temp != 0) {
248             digits++;
249             temp /= 10;
250         }
251         bytes memory buffer = new bytes(digits);
252         while (value != 0) {
253             digits -= 1;
254             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
255             value /= 10;
256         }
257         return string(buffer);
258     }
259 
260     /**
261      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
262      */
263     function toHexString(uint256 value) internal pure returns (string memory) {
264         if (value == 0) {
265             return "0x00";
266         }
267         uint256 temp = value;
268         uint256 length = 0;
269         while (temp != 0) {
270             length++;
271             temp >>= 8;
272         }
273         return toHexString(value, length);
274     }
275 
276     /**
277      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
278      */
279     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
280         bytes memory buffer = new bytes(2 * length + 2);
281         buffer[0] = "0";
282         buffer[1] = "x";
283         for (uint256 i = 2 * length + 1; i > 1; --i) {
284             buffer[i] = _HEX_SYMBOLS[value & 0xf];
285             value >>= 4;
286         }
287         require(value == 0, "Strings: hex length insufficient");
288         return string(buffer);
289     }
290 }
291 
292 // File: @openzeppelin/contracts/utils/Context.sol
293 
294 
295 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
296 
297 pragma solidity ^0.8.0;
298 
299 /**
300  * @dev Provides information about the current execution context, including the
301  * sender of the transaction and its data. While these are generally available
302  * via msg.sender and msg.data, they should not be accessed in such a direct
303  * manner, since when dealing with meta-transactions the account sending and
304  * paying for execution may not be the actual sender (as far as an application
305  * is concerned).
306  *
307  * This contract is only required for intermediate, library-like contracts.
308  */
309 abstract contract Context {
310     function _msgSender() internal view virtual returns (address) {
311         return msg.sender;
312     }
313 
314     function _msgData() internal view virtual returns (bytes calldata) {
315         return msg.data;
316     }
317 }
318 
319 // File: @openzeppelin/contracts/access/Ownable.sol
320 
321 
322 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
323 
324 pragma solidity ^0.8.0;
325 
326 
327 /**
328  * @dev Contract module which provides a basic access control mechanism, where
329  * there is an account (an owner) that can be granted exclusive access to
330  * specific functions.
331  *
332  * By default, the owner account will be the one that deploys the contract. This
333  * can later be changed with {transferOwnership}.
334  *
335  * This module is used through inheritance. It will make available the modifier
336  * `onlyOwner`, which can be applied to your functions to restrict their use to
337  * the owner.
338  */
339 abstract contract Ownable is Context {
340     address private _owner;
341 
342     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
343 
344     /**
345      * @dev Initializes the contract setting the deployer as the initial owner.
346      */
347     constructor() {
348         _transferOwnership(_msgSender());
349     }
350 
351     /**
352      * @dev Returns the address of the current owner.
353      */
354     function owner() public view virtual returns (address) {
355         return _owner;
356     }
357 
358     /**
359      * @dev Throws if called by any account other than the owner.
360      */
361     modifier onlyOwner() {
362         require(owner() == _msgSender(), "Ownable: caller is not the owner");
363         _;
364     }
365 
366     /**
367      * @dev Leaves the contract without owner. It will not be possible to call
368      * `onlyOwner` functions anymore. Can only be called by the current owner.
369      *
370      * NOTE: Renouncing ownership will leave the contract without an owner,
371      * thereby removing any functionality that is only available to the owner.
372      */
373     function renounceOwnership() public virtual onlyOwner {
374         _transferOwnership(address(0));
375     }
376 
377     /**
378      * @dev Transfers ownership of the contract to a new account (`newOwner`).
379      * Can only be called by the current owner.
380      */
381     function transferOwnership(address newOwner) public virtual onlyOwner {
382         require(newOwner != address(0), "Ownable: new owner is the zero address");
383         _transferOwnership(newOwner);
384     }
385 
386     /**
387      * @dev Transfers ownership of the contract to a new account (`newOwner`).
388      * Internal function without access restriction.
389      */
390     function _transferOwnership(address newOwner) internal virtual {
391         address oldOwner = _owner;
392         _owner = newOwner;
393         emit OwnershipTransferred(oldOwner, newOwner);
394     }
395 }
396 
397 // File: @openzeppelin/contracts/utils/Address.sol
398 
399 
400 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
401 
402 pragma solidity ^0.8.1;
403 
404 /**
405  * @dev Collection of functions related to the address type
406  */
407 library Address {
408     /**
409      * @dev Returns true if `account` is a contract.
410      *
411      * [IMPORTANT]
412      * ====
413      * It is unsafe to assume that an address for which this function returns
414      * false is an externally-owned account (EOA) and not a contract.
415      *
416      * Among others, `isContract` will return false for the following
417      * types of addresses:
418      *
419      *  - an externally-owned account
420      *  - a contract in construction
421      *  - an address where a contract will be created
422      *  - an address where a contract lived, but was destroyed
423      * ====
424      *
425      * [IMPORTANT]
426      * ====
427      * You shouldn't rely on `isContract` to protect against flash loan attacks!
428      *
429      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
430      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
431      * constructor.
432      * ====
433      */
434     function isContract(address account) internal view returns (bool) {
435         // This method relies on extcodesize/address.code.length, which returns 0
436         // for contracts in construction, since the code is only stored at the end
437         // of the constructor execution.
438 
439         return account.code.length > 0;
440     }
441 
442     /**
443      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
444      * `recipient`, forwarding all available gas and reverting on errors.
445      *
446      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
447      * of certain opcodes, possibly making contracts go over the 2300 gas limit
448      * imposed by `transfer`, making them unable to receive funds via
449      * `transfer`. {sendValue} removes this limitation.
450      *
451      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
452      *
453      * IMPORTANT: because control is transferred to `recipient`, care must be
454      * taken to not create reentrancy vulnerabilities. Consider using
455      * {ReentrancyGuard} or the
456      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
457      */
458     function sendValue(address payable recipient, uint256 amount) internal {
459         require(address(this).balance >= amount, "Address: insufficient balance");
460 
461         (bool success, ) = recipient.call{value: amount}("");
462         require(success, "Address: unable to send value, recipient may have reverted");
463     }
464 
465     /**
466      * @dev Performs a Solidity function call using a low level `call`. A
467      * plain `call` is an unsafe replacement for a function call: use this
468      * function instead.
469      *
470      * If `target` reverts with a revert reason, it is bubbled up by this
471      * function (like regular Solidity function calls).
472      *
473      * Returns the raw returned data. To convert to the expected return value,
474      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
475      *
476      * Requirements:
477      *
478      * - `target` must be a contract.
479      * - calling `target` with `data` must not revert.
480      *
481      * _Available since v3.1._
482      */
483     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
484         return functionCall(target, data, "Address: low-level call failed");
485     }
486 
487     /**
488      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
489      * `errorMessage` as a fallback revert reason when `target` reverts.
490      *
491      * _Available since v3.1._
492      */
493     function functionCall(
494         address target,
495         bytes memory data,
496         string memory errorMessage
497     ) internal returns (bytes memory) {
498         return functionCallWithValue(target, data, 0, errorMessage);
499     }
500 
501     /**
502      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
503      * but also transferring `value` wei to `target`.
504      *
505      * Requirements:
506      *
507      * - the calling contract must have an ETH balance of at least `value`.
508      * - the called Solidity function must be `payable`.
509      *
510      * _Available since v3.1._
511      */
512     function functionCallWithValue(
513         address target,
514         bytes memory data,
515         uint256 value
516     ) internal returns (bytes memory) {
517         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
522      * with `errorMessage` as a fallback revert reason when `target` reverts.
523      *
524      * _Available since v3.1._
525      */
526     function functionCallWithValue(
527         address target,
528         bytes memory data,
529         uint256 value,
530         string memory errorMessage
531     ) internal returns (bytes memory) {
532         require(address(this).balance >= value, "Address: insufficient balance for call");
533         require(isContract(target), "Address: call to non-contract");
534 
535         (bool success, bytes memory returndata) = target.call{value: value}(data);
536         return verifyCallResult(success, returndata, errorMessage);
537     }
538 
539     /**
540      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
541      * but performing a static call.
542      *
543      * _Available since v3.3._
544      */
545     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
546         return functionStaticCall(target, data, "Address: low-level static call failed");
547     }
548 
549     /**
550      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
551      * but performing a static call.
552      *
553      * _Available since v3.3._
554      */
555     function functionStaticCall(
556         address target,
557         bytes memory data,
558         string memory errorMessage
559     ) internal view returns (bytes memory) {
560         require(isContract(target), "Address: static call to non-contract");
561 
562         (bool success, bytes memory returndata) = target.staticcall(data);
563         return verifyCallResult(success, returndata, errorMessage);
564     }
565 
566     /**
567      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
568      * but performing a delegate call.
569      *
570      * _Available since v3.4._
571      */
572     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
573         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
574     }
575 
576     /**
577      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
578      * but performing a delegate call.
579      *
580      * _Available since v3.4._
581      */
582     function functionDelegateCall(
583         address target,
584         bytes memory data,
585         string memory errorMessage
586     ) internal returns (bytes memory) {
587         require(isContract(target), "Address: delegate call to non-contract");
588 
589         (bool success, bytes memory returndata) = target.delegatecall(data);
590         return verifyCallResult(success, returndata, errorMessage);
591     }
592 
593     /**
594      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
595      * revert reason using the provided one.
596      *
597      * _Available since v4.3._
598      */
599     function verifyCallResult(
600         bool success,
601         bytes memory returndata,
602         string memory errorMessage
603     ) internal pure returns (bytes memory) {
604         if (success) {
605             return returndata;
606         } else {
607             // Look for revert reason and bubble it up if present
608             if (returndata.length > 0) {
609                 // The easiest way to bubble the revert reason is using memory via assembly
610 
611                 assembly {
612                     let returndata_size := mload(returndata)
613                     revert(add(32, returndata), returndata_size)
614                 }
615             } else {
616                 revert(errorMessage);
617             }
618         }
619     }
620 }
621 
622 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
623 
624 
625 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
626 
627 pragma solidity ^0.8.0;
628 
629 /**
630  * @title ERC721 token receiver interface
631  * @dev Interface for any contract that wants to support safeTransfers
632  * from ERC721 asset contracts.
633  */
634 interface IERC721Receiver {
635     /**
636      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
637      * by `operator` from `from`, this function is called.
638      *
639      * It must return its Solidity selector to confirm the token transfer.
640      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
641      *
642      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
643      */
644     function onERC721Received(
645         address operator,
646         address from,
647         uint256 tokenId,
648         bytes calldata data
649     ) external returns (bytes4);
650 }
651 
652 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
653 
654 
655 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
656 
657 pragma solidity ^0.8.0;
658 
659 /**
660  * @dev Interface of the ERC165 standard, as defined in the
661  * https://eips.ethereum.org/EIPS/eip-165[EIP].
662  *
663  * Implementers can declare support of contract interfaces, which can then be
664  * queried by others ({ERC165Checker}).
665  *
666  * For an implementation, see {ERC165}.
667  */
668 interface IERC165 {
669     /**
670      * @dev Returns true if this contract implements the interface defined by
671      * `interfaceId`. See the corresponding
672      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
673      * to learn more about how these ids are created.
674      *
675      * This function call must use less than 30 000 gas.
676      */
677     function supportsInterface(bytes4 interfaceId) external view returns (bool);
678 }
679 
680 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
681 
682 
683 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
684 
685 pragma solidity ^0.8.0;
686 
687 
688 /**
689  * @dev Implementation of the {IERC165} interface.
690  *
691  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
692  * for the additional interface id that will be supported. For example:
693  *
694  * ```solidity
695  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
696  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
697  * }
698  * ```
699  *
700  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
701  */
702 abstract contract ERC165 is IERC165 {
703     /**
704      * @dev See {IERC165-supportsInterface}.
705      */
706     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
707         return interfaceId == type(IERC165).interfaceId;
708     }
709 }
710 
711 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
712 
713 
714 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
715 
716 pragma solidity ^0.8.0;
717 
718 
719 /**
720  * @dev Required interface of an ERC721 compliant contract.
721  */
722 interface IERC721 is IERC165 {
723     /**
724      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
725      */
726     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
727 
728     /**
729      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
730      */
731     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
732 
733     /**
734      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
735      */
736     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
737 
738     /**
739      * @dev Returns the number of tokens in ``owner``'s account.
740      */
741     function balanceOf(address owner) external view returns (uint256 balance);
742 
743     /**
744      * @dev Returns the owner of the `tokenId` token.
745      *
746      * Requirements:
747      *
748      * - `tokenId` must exist.
749      */
750     function ownerOf(uint256 tokenId) external view returns (address owner);
751 
752     /**
753      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
754      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
755      *
756      * Requirements:
757      *
758      * - `from` cannot be the zero address.
759      * - `to` cannot be the zero address.
760      * - `tokenId` token must exist and be owned by `from`.
761      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
762      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
763      *
764      * Emits a {Transfer} event.
765      */
766     function safeTransferFrom(
767         address from,
768         address to,
769         uint256 tokenId
770     ) external;
771 
772     /**
773      * @dev Transfers `tokenId` token from `from` to `to`.
774      *
775      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
776      *
777      * Requirements:
778      *
779      * - `from` cannot be the zero address.
780      * - `to` cannot be the zero address.
781      * - `tokenId` token must be owned by `from`.
782      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
783      *
784      * Emits a {Transfer} event.
785      */
786     function transferFrom(
787         address from,
788         address to,
789         uint256 tokenId
790     ) external;
791 
792     /**
793      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
794      * The approval is cleared when the token is transferred.
795      *
796      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
797      *
798      * Requirements:
799      *
800      * - The caller must own the token or be an approved operator.
801      * - `tokenId` must exist.
802      *
803      * Emits an {Approval} event.
804      */
805     function approve(address to, uint256 tokenId) external;
806 
807     /**
808      * @dev Returns the account approved for `tokenId` token.
809      *
810      * Requirements:
811      *
812      * - `tokenId` must exist.
813      */
814     function getApproved(uint256 tokenId) external view returns (address operator);
815 
816     /**
817      * @dev Approve or remove `operator` as an operator for the caller.
818      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
819      *
820      * Requirements:
821      *
822      * - The `operator` cannot be the caller.
823      *
824      * Emits an {ApprovalForAll} event.
825      */
826     function setApprovalForAll(address operator, bool _approved) external;
827 
828     /**
829      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
830      *
831      * See {setApprovalForAll}
832      */
833     function isApprovedForAll(address owner, address operator) external view returns (bool);
834 
835     /**
836      * @dev Safely transfers `tokenId` token from `from` to `to`.
837      *
838      * Requirements:
839      *
840      * - `from` cannot be the zero address.
841      * - `to` cannot be the zero address.
842      * - `tokenId` token must exist and be owned by `from`.
843      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
844      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
845      *
846      * Emits a {Transfer} event.
847      */
848     function safeTransferFrom(
849         address from,
850         address to,
851         uint256 tokenId,
852         bytes calldata data
853     ) external;
854 }
855 
856 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
857 
858 
859 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
860 
861 pragma solidity ^0.8.0;
862 
863 
864 /**
865  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
866  * @dev See https://eips.ethereum.org/EIPS/eip-721
867  */
868 interface IERC721Enumerable is IERC721 {
869     /**
870      * @dev Returns the total amount of tokens stored by the contract.
871      */
872     function totalSupply() external view returns (uint256);
873 
874     /**
875      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
876      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
877      */
878     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
879 
880     /**
881      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
882      * Use along with {totalSupply} to enumerate all tokens.
883      */
884     function tokenByIndex(uint256 index) external view returns (uint256);
885 }
886 
887 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
888 
889 
890 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
891 
892 pragma solidity ^0.8.0;
893 
894 
895 /**
896  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
897  * @dev See https://eips.ethereum.org/EIPS/eip-721
898  */
899 interface IERC721Metadata is IERC721 {
900     /**
901      * @dev Returns the token collection name.
902      */
903     function name() external view returns (string memory);
904 
905     /**
906      * @dev Returns the token collection symbol.
907      */
908     function symbol() external view returns (string memory);
909 
910     /**
911      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
912      */
913     function tokenURI(uint256 tokenId) external view returns (string memory);
914 }
915 
916 // File: contracts/ERC721A.sol
917 
918 
919 // Creator: Chiru Labs
920 
921 pragma solidity ^0.8.4;
922 
923 
924 
925 
926 
927 
928 
929 
930 
931 error ApprovalCallerNotOwnerNorApproved();
932 error ApprovalQueryForNonexistentToken();
933 error ApproveToCaller();
934 error ApprovalToCurrentOwner();
935 error BalanceQueryForZeroAddress();
936 error MintedQueryForZeroAddress();
937 error BurnedQueryForZeroAddress();
938 error AuxQueryForZeroAddress();
939 error MintToZeroAddress();
940 error MintZeroQuantity();
941 error OwnerIndexOutOfBounds();
942 error OwnerQueryForNonexistentToken();
943 error TokenIndexOutOfBounds();
944 error TransferCallerNotOwnerNorApproved();
945 error TransferFromIncorrectOwner();
946 error TransferToNonERC721ReceiverImplementer();
947 error TransferToZeroAddress();
948 error URIQueryForNonexistentToken();
949 
950 /**
951  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
952  * the Metadata extension. Built to optimize for lower gas during batch mints.
953  *
954  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
955  *
956  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
957  *
958  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
959  */
960 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
961     using Address for address;
962     using Strings for uint256;
963 
964     // Compiler will pack this into a single 256bit word.
965     struct TokenOwnership {
966         // The address of the owner.
967         address addr;
968         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
969         uint64 startTimestamp;
970         // Whether the token has been burned.
971         bool burned;
972     }
973 
974     // Compiler will pack this into a single 256bit word.
975     struct AddressData {
976         // Realistically, 2**64-1 is more than enough.
977         uint64 balance;
978         // Keeps track of mint count with minimal overhead for tokenomics.
979         uint64 numberMinted;
980         // Keeps track of burn count with minimal overhead for tokenomics.
981         uint64 numberBurned;
982         // For miscellaneous variable(s) pertaining to the address
983         // (e.g. number of whitelist mint slots used).
984         // If there are multiple variables, please pack them into a uint64.
985         uint64 aux;
986     }
987 
988     // The tokenId of the next token to be minted.
989     uint256 internal _currentIndex;
990 
991     // The number of tokens burned.
992     uint256 internal _burnCounter;
993 
994     // Token name
995     string private _name;
996 
997     // Token symbol
998     string private _symbol;
999 
1000     // Mapping from token ID to ownership details
1001     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1002     mapping(uint256 => TokenOwnership) internal _ownerships;
1003 
1004     // Mapping owner address to address data
1005     mapping(address => AddressData) private _addressData;
1006 
1007     // Mapping from token ID to approved address
1008     mapping(uint256 => address) private _tokenApprovals;
1009 
1010     // Mapping from owner to operator approvals
1011     mapping(address => mapping(address => bool)) private _operatorApprovals;
1012 
1013     constructor(string memory name_, string memory symbol_) {
1014         _name = name_;
1015         _symbol = symbol_;
1016         _currentIndex = _startTokenId();
1017     }
1018 
1019     /**
1020      * To change the starting tokenId, please override this function.
1021      */
1022     function _startTokenId() internal view virtual returns (uint256) {
1023         return 0;
1024     }
1025 
1026     /**
1027      * @dev See {IERC721Enumerable-totalSupply}.
1028      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1029      */
1030     function totalSupply() public view returns (uint256) {
1031         // Counter underflow is impossible as _burnCounter cannot be incremented
1032         // more than _currentIndex - _startTokenId() times
1033         unchecked {
1034             return _currentIndex - _burnCounter - _startTokenId();
1035         }
1036     }
1037 
1038     /**
1039      * Returns the total amount of tokens minted in the contract.
1040      */
1041     function _totalMinted() internal view returns (uint256) {
1042         // Counter underflow is impossible as _currentIndex does not decrement,
1043         // and it is initialized to _startTokenId()
1044         unchecked {
1045             return _currentIndex - _startTokenId();
1046         }
1047     }
1048 
1049     /**
1050      * @dev See {IERC165-supportsInterface}.
1051      */
1052     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1053         return
1054             interfaceId == type(IERC721).interfaceId ||
1055             interfaceId == type(IERC721Metadata).interfaceId ||
1056             super.supportsInterface(interfaceId);
1057     }
1058 
1059     /**
1060      * @dev See {IERC721-balanceOf}.
1061      */
1062     function balanceOf(address owner) public view override returns (uint256) {
1063         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1064         return uint256(_addressData[owner].balance);
1065     }
1066 
1067     /**
1068      * Returns the number of tokens minted by `owner`.
1069      */
1070     function _numberMinted(address owner) internal view returns (uint256) {
1071         if (owner == address(0)) revert MintedQueryForZeroAddress();
1072         return uint256(_addressData[owner].numberMinted);
1073     }
1074 
1075     /**
1076      * Returns the number of tokens burned by or on behalf of `owner`.
1077      */
1078     function _numberBurned(address owner) internal view returns (uint256) {
1079         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1080         return uint256(_addressData[owner].numberBurned);
1081     }
1082 
1083     /**
1084      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1085      */
1086     function _getAux(address owner) internal view returns (uint64) {
1087         if (owner == address(0)) revert AuxQueryForZeroAddress();
1088         return _addressData[owner].aux;
1089     }
1090 
1091     /**
1092      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1093      * If there are multiple variables, please pack them into a uint64.
1094      */
1095     function _setAux(address owner, uint64 aux) internal {
1096         if (owner == address(0)) revert AuxQueryForZeroAddress();
1097         _addressData[owner].aux = aux;
1098     }
1099 
1100     /**
1101      * Gas spent here starts off proportional to the maximum mint batch size.
1102      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1103      */
1104     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1105         uint256 curr = tokenId;
1106 
1107         unchecked {
1108             if (_startTokenId() <= curr && curr < _currentIndex) {
1109                 TokenOwnership memory ownership = _ownerships[curr];
1110                 if (!ownership.burned) {
1111                     if (ownership.addr != address(0)) {
1112                         return ownership;
1113                     }
1114                     // Invariant:
1115                     // There will always be an ownership that has an address and is not burned
1116                     // before an ownership that does not have an address and is not burned.
1117                     // Hence, curr will not underflow.
1118                     while (true) {
1119                         curr--;
1120                         ownership = _ownerships[curr];
1121                         if (ownership.addr != address(0)) {
1122                             return ownership;
1123                         }
1124                     }
1125                 }
1126             }
1127         }
1128         revert OwnerQueryForNonexistentToken();
1129     }
1130 
1131     /**
1132      * @dev See {IERC721-ownerOf}.
1133      */
1134     function ownerOf(uint256 tokenId) public view override returns (address) {
1135         return ownershipOf(tokenId).addr;
1136     }
1137 
1138     /**
1139      * @dev See {IERC721Metadata-name}.
1140      */
1141     function name() public view virtual override returns (string memory) {
1142         return _name;
1143     }
1144 
1145     /**
1146      * @dev See {IERC721Metadata-symbol}.
1147      */
1148     function symbol() public view virtual override returns (string memory) {
1149         return _symbol;
1150     }
1151 
1152     /**
1153      * @dev See {IERC721Metadata-tokenURI}.
1154      */
1155     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1156         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1157 
1158         string memory baseURI = _baseURI();
1159         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '';
1160     }
1161 
1162     /**
1163      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1164      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1165      * by default, can be overriden in child contracts.
1166      */
1167     function _baseURI() internal view virtual returns (string memory) {
1168         return '';
1169     }
1170 
1171     /**
1172      * @dev See {IERC721-approve}.
1173      */
1174     function approve(address to, uint256 tokenId) public override {
1175         address owner = ERC721A.ownerOf(tokenId);
1176         if (to == owner) revert ApprovalToCurrentOwner();
1177 
1178         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1179             revert ApprovalCallerNotOwnerNorApproved();
1180         }
1181 
1182         _approve(to, tokenId, owner);
1183     }
1184 
1185     /**
1186      * @dev See {IERC721-getApproved}.
1187      */
1188     function getApproved(uint256 tokenId) public view override returns (address) {
1189         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1190 
1191         return _tokenApprovals[tokenId];
1192     }
1193 
1194     /**
1195      * @dev See {IERC721-setApprovalForAll}.
1196      */
1197     function setApprovalForAll(address operator, bool approved) public override {
1198         if (operator == _msgSender()) revert ApproveToCaller();
1199 
1200         _operatorApprovals[_msgSender()][operator] = approved;
1201         emit ApprovalForAll(_msgSender(), operator, approved);
1202     }
1203 
1204     /**
1205      * @dev See {IERC721-isApprovedForAll}.
1206      */
1207     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1208         return _operatorApprovals[owner][operator];
1209     }
1210 
1211     /**
1212      * @dev See {IERC721-transferFrom}.
1213      */
1214     function transferFrom(
1215         address from,
1216         address to,
1217         uint256 tokenId
1218     ) public virtual override {
1219         _transfer(from, to, tokenId);
1220     }
1221 
1222     /**
1223      * @dev See {IERC721-safeTransferFrom}.
1224      */
1225     function safeTransferFrom(
1226         address from,
1227         address to,
1228         uint256 tokenId
1229     ) public virtual override {
1230         safeTransferFrom(from, to, tokenId, '');
1231     }
1232 
1233     /**
1234      * @dev See {IERC721-safeTransferFrom}.
1235      */
1236     function safeTransferFrom(
1237         address from,
1238         address to,
1239         uint256 tokenId,
1240         bytes memory _data
1241     ) public virtual override {
1242         _transfer(from, to, tokenId);
1243         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1244             revert TransferToNonERC721ReceiverImplementer();
1245         }
1246     }
1247 
1248     /**
1249      * @dev Returns whether `tokenId` exists.
1250      *
1251      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1252      *
1253      * Tokens start existing when they are minted (`_mint`),
1254      */
1255     function _exists(uint256 tokenId) internal view returns (bool) {
1256         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1257             !_ownerships[tokenId].burned;
1258     }
1259 
1260     function _safeMint(address to, uint256 quantity) internal {
1261         _safeMint(to, quantity, '');
1262     }
1263 
1264     /**
1265      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1266      *
1267      * Requirements:
1268      *
1269      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1270      * - `quantity` must be greater than 0.
1271      *
1272      * Emits a {Transfer} event.
1273      */
1274     function _safeMint(
1275         address to,
1276         uint256 quantity,
1277         bytes memory _data
1278     ) internal {
1279         _mint(to, quantity, _data, true);
1280     }
1281 
1282     /**
1283      * @dev Mints `quantity` tokens and transfers them to `to`.
1284      *
1285      * Requirements:
1286      *
1287      * - `to` cannot be the zero address.
1288      * - `quantity` must be greater than 0.
1289      *
1290      * Emits a {Transfer} event.
1291      */
1292     function _mint(
1293         address to,
1294         uint256 quantity,
1295         bytes memory _data,
1296         bool safe
1297     ) internal {
1298         uint256 startTokenId = _currentIndex;
1299         if (to == address(0)) revert MintToZeroAddress();
1300         if (quantity == 0) revert MintZeroQuantity();
1301 
1302         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1303 
1304         // Overflows are incredibly unrealistic.
1305         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1306         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1307         unchecked {
1308             _addressData[to].balance += uint64(quantity);
1309             _addressData[to].numberMinted += uint64(quantity);
1310 
1311             _ownerships[startTokenId].addr = to;
1312             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1313 
1314             uint256 updatedIndex = startTokenId;
1315             uint256 end = updatedIndex + quantity;
1316 
1317             if (safe && to.isContract()) {
1318                 do {
1319                     emit Transfer(address(0), to, updatedIndex);
1320                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1321                         revert TransferToNonERC721ReceiverImplementer();
1322                     }
1323                 } while (updatedIndex != end);
1324                 // Reentrancy protection
1325                 if (_currentIndex != startTokenId) revert();
1326             } else {
1327                 do {
1328                     emit Transfer(address(0), to, updatedIndex++);
1329                 } while (updatedIndex != end);
1330             }
1331             _currentIndex = updatedIndex;
1332         }
1333         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1334     }
1335 
1336     /**
1337      * @dev Transfers `tokenId` from `from` to `to`.
1338      *
1339      * Requirements:
1340      *
1341      * - `to` cannot be the zero address.
1342      * - `tokenId` token must be owned by `from`.
1343      *
1344      * Emits a {Transfer} event.
1345      */
1346     function _transfer(
1347         address from,
1348         address to,
1349         uint256 tokenId
1350     ) private {
1351         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1352 
1353         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1354             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1355             getApproved(tokenId) == _msgSender());
1356 
1357         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1358         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1359         if (to == address(0)) revert TransferToZeroAddress();
1360 
1361         _beforeTokenTransfers(from, to, tokenId, 1);
1362 
1363         // Clear approvals from the previous owner
1364         _approve(address(0), tokenId, prevOwnership.addr);
1365 
1366         // Underflow of the sender's balance is impossible because we check for
1367         // ownership above and the recipient's balance can't realistically overflow.
1368         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1369         unchecked {
1370             _addressData[from].balance -= 1;
1371             _addressData[to].balance += 1;
1372 
1373             _ownerships[tokenId].addr = to;
1374             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1375 
1376             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1377             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1378             uint256 nextTokenId = tokenId + 1;
1379             if (_ownerships[nextTokenId].addr == address(0)) {
1380                 // This will suffice for checking _exists(nextTokenId),
1381                 // as a burned slot cannot contain the zero address.
1382                 if (nextTokenId < _currentIndex) {
1383                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1384                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1385                 }
1386             }
1387         }
1388 
1389         emit Transfer(from, to, tokenId);
1390         _afterTokenTransfers(from, to, tokenId, 1);
1391     }
1392 
1393     /**
1394      * @dev Destroys `tokenId`.
1395      * The approval is cleared when the token is burned.
1396      *
1397      * Requirements:
1398      *
1399      * - `tokenId` must exist.
1400      *
1401      * Emits a {Transfer} event.
1402      */
1403     function _burn(uint256 tokenId) internal virtual {
1404         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1405 
1406         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1407 
1408         // Clear approvals from the previous owner
1409         _approve(address(0), tokenId, prevOwnership.addr);
1410 
1411         // Underflow of the sender's balance is impossible because we check for
1412         // ownership above and the recipient's balance can't realistically overflow.
1413         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1414         unchecked {
1415             _addressData[prevOwnership.addr].balance -= 1;
1416             _addressData[prevOwnership.addr].numberBurned += 1;
1417 
1418             // Keep track of who burned the token, and the timestamp of burning.
1419             _ownerships[tokenId].addr = prevOwnership.addr;
1420             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1421             _ownerships[tokenId].burned = true;
1422 
1423             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1424             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1425             uint256 nextTokenId = tokenId + 1;
1426             if (_ownerships[nextTokenId].addr == address(0)) {
1427                 // This will suffice for checking _exists(nextTokenId),
1428                 // as a burned slot cannot contain the zero address.
1429                 if (nextTokenId < _currentIndex) {
1430                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1431                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1432                 }
1433             }
1434         }
1435 
1436         emit Transfer(prevOwnership.addr, address(0), tokenId);
1437         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1438 
1439         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1440         unchecked {
1441             _burnCounter++;
1442         }
1443     }
1444 
1445     /**
1446      * @dev Approve `to` to operate on `tokenId`
1447      *
1448      * Emits a {Approval} event.
1449      */
1450     function _approve(
1451         address to,
1452         uint256 tokenId,
1453         address owner
1454     ) private {
1455         _tokenApprovals[tokenId] = to;
1456         emit Approval(owner, to, tokenId);
1457     }
1458 
1459     /**
1460      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1461      *
1462      * @param from address representing the previous owner of the given token ID
1463      * @param to target address that will receive the tokens
1464      * @param tokenId uint256 ID of the token to be transferred
1465      * @param _data bytes optional data to send along with the call
1466      * @return bool whether the call correctly returned the expected magic value
1467      */
1468     function _checkContractOnERC721Received(
1469         address from,
1470         address to,
1471         uint256 tokenId,
1472         bytes memory _data
1473     ) private returns (bool) {
1474         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1475             return retval == IERC721Receiver(to).onERC721Received.selector;
1476         } catch (bytes memory reason) {
1477             if (reason.length == 0) {
1478                 revert TransferToNonERC721ReceiverImplementer();
1479             } else {
1480                 assembly {
1481                     revert(add(32, reason), mload(reason))
1482                 }
1483             }
1484         }
1485     }
1486 
1487     /**
1488      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1489      * And also called before burning one token.
1490      *
1491      * startTokenId - the first token id to be transferred
1492      * quantity - the amount to be transferred
1493      *
1494      * Calling conditions:
1495      *
1496      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1497      * transferred to `to`.
1498      * - When `from` is zero, `tokenId` will be minted for `to`.
1499      * - When `to` is zero, `tokenId` will be burned by `from`.
1500      * - `from` and `to` are never both zero.
1501      */
1502     function _beforeTokenTransfers(
1503         address from,
1504         address to,
1505         uint256 startTokenId,
1506         uint256 quantity
1507     ) internal virtual {}
1508 
1509     /**
1510      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1511      * minting.
1512      * And also called after one token has been burned.
1513      *
1514      * startTokenId - the first token id to be transferred
1515      * quantity - the amount to be transferred
1516      *
1517      * Calling conditions:
1518      *
1519      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1520      * transferred to `to`.
1521      * - When `from` is zero, `tokenId` has been minted for `to`.
1522      * - When `to` is zero, `tokenId` has been burned by `from`.
1523      * - `from` and `to` are never both zero.
1524      */
1525     function _afterTokenTransfers(
1526         address from,
1527         address to,
1528         uint256 startTokenId,
1529         uint256 quantity
1530     ) internal virtual {}
1531 }
1532 // File: contracts/MisfitsNFT.sol
1533 
1534 
1535 pragma solidity ^0.8.4;
1536 
1537 
1538 
1539 contract OwnableDelegateProxy {}
1540 
1541 contract ProxyRegistry {
1542     mapping(address => OwnableDelegateProxy) public proxies;
1543 }
1544 
1545 contract MisfitsNFT is ERC721A, Ownable {
1546     address public MINTER;
1547     string baseURI;
1548     string contractUri;
1549     address proxyRegistryAddress;
1550 
1551     modifier onlyMinter() {
1552         require(_msgSender() == MINTER || _msgSender() == owner(), "ACCESS_FORBIDDEN");
1553         _;
1554     }
1555 
1556     // Post Reveal URI: https://themisfitsnft.mypinata.cloud/ipfs/QmTavHME8q6nUu9n9NJ9P5CA2HTmM58mFm1unFoesovxZS/
1557     // Pre Reveal URI: https://themisfitsnft.mypinata.cloud/ipfs/QmdJio7ySn3R3UwKT3oqSySPZUAwz1xKvvxJqXk7Nb2rqz/
1558     // Contract URI: https://themisfitsnft.mypinata.cloud/ipfs/QmRcU3DVpy3ZPXbme4bLyrWH9uzdDGyksa85u5dnDGx48E
1559     // Rinkeby proxy: 0xf57b2c51ded3a29e6891aba85459d600256cf317
1560     // Mainnet proxy: 0xa5409ec958c83c3f309868babaca7c86dcb077c1
1561     constructor(address _minter, string memory _tokenUri, string memory _contractUri, address _proxyRegistryAddress) ERC721A("MisfitsNFT", "MISFITS") {
1562         MINTER = _minter;
1563         baseURI = _tokenUri;
1564         contractUri = _contractUri;
1565         proxyRegistryAddress = _proxyRegistryAddress;
1566     }
1567 
1568     function contractURI() public view returns (string memory) {
1569         return contractUri;
1570     }
1571 
1572     function setMinterContract(address _newMinter) external onlyOwner {
1573         MINTER = _newMinter;
1574     }
1575 
1576     function setBaseUri(string memory _newUri) external onlyOwner {
1577         baseURI = _newUri;
1578     }
1579 
1580     function setContractUri(string memory _newUri) external onlyOwner {
1581         contractUri = _newUri;
1582     }
1583 
1584     function _startTokenId() internal pure override returns (uint256) {
1585         return 1;
1586     }
1587 
1588     function _baseURI() internal view override returns (string memory) {
1589         return baseURI;
1590     }
1591 
1592     function mint(address recipient, uint256 quantity) external onlyMinter {
1593         _mint(recipient, quantity, "", true);
1594     }
1595 
1596     function isApprovedForAll(address owner, address operator)
1597         override
1598         public
1599         view
1600         returns (bool)
1601     {
1602         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1603         if (address(proxyRegistry.proxies(owner)) == operator) {
1604             return true;
1605         }
1606 
1607         return super.isApprovedForAll(owner, operator);
1608     }
1609 }
1610 // File: contracts/MisfitsMinter.sol
1611 
1612 
1613 pragma solidity ^0.8.4;
1614 
1615 
1616 
1617 contract MisfitsNFTMinter is Ownable {
1618     MisfitsNFT parentContract = MisfitsNFT(0x7c98eF950DcB9D1cC035636aab4291A81711237A);
1619     uint16 public remainingSupply;
1620     uint256 public mintFee;
1621 
1622     constructor() {
1623         remainingSupply = 1314;
1624         mintFee = 35000000000000000;
1625     }
1626 
1627     function setParentContract(address _newContract) external onlyOwner {
1628         parentContract = MisfitsNFT(_newContract);
1629     }
1630 
1631     function setReleaseAmount(uint16 newAmount) external onlyOwner {
1632         remainingSupply = newAmount;
1633     }
1634 
1635     function setMintFee(uint256 newFee) external onlyOwner {
1636         mintFee = newFee;
1637     }
1638 
1639     function mint(uint256 quantity) external payable {
1640         require(remainingSupply >= quantity, "ROUND_LIMIT_EXCEEDS");
1641         require(msg.value >= mintFee * quantity, "INSUFFICIENT_FEE");
1642 
1643         parentContract.mint(_msgSender(), quantity);
1644         payable(owner()).transfer(msg.value);
1645 
1646         remainingSupply -= uint8(quantity);
1647     }
1648 }