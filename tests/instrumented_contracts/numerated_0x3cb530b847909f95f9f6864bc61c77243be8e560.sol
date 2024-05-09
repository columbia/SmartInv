1 // File: @openzeppelin/contracts/utils/Address.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
5 
6 pragma solidity ^0.8.1;
7 
8 /**
9  * @dev Collection of functions related to the address type
10  */
11 library Address {
12     /**
13      * @dev Returns true if `account` is a contract.
14      *
15      * [IMPORTANT]
16      * ====
17      * It is unsafe to assume that an address for which this function returns
18      * false is an externally-owned account (EOA) and not a contract.
19      *
20      * Among others, `isContract` will return false for the following
21      * types of addresses:
22      *
23      *  - an externally-owned account
24      *  - a contract in construction
25      *  - an address where a contract will be created
26      *  - an address where a contract lived, but was destroyed
27      * ====
28      *
29      * [IMPORTANT]
30      * ====
31      * You shouldn't rely on `isContract` to protect against flash loan attacks!
32      *
33      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
34      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
35      * constructor.
36      * ====
37      */
38     function isContract(address account) internal view returns (bool) {
39         // This method relies on extcodesize/address.code.length, which returns 0
40         // for contracts in construction, since the code is only stored at the end
41         // of the constructor execution.
42 
43         return account.code.length > 0;
44     }
45 
46     /**
47      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
48      * `recipient`, forwarding all available gas and reverting on errors.
49      *
50      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
51      * of certain opcodes, possibly making contracts go over the 2300 gas limit
52      * imposed by `transfer`, making them unable to receive funds via
53      * `transfer`. {sendValue} removes this limitation.
54      *
55      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
56      *
57      * IMPORTANT: because control is transferred to `recipient`, care must be
58      * taken to not create reentrancy vulnerabilities. Consider using
59      * {ReentrancyGuard} or the
60      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
61      */
62     function sendValue(address payable recipient, uint256 amount) internal {
63         require(address(this).balance >= amount, "Address: insufficient balance");
64 
65         (bool success, ) = recipient.call{value: amount}("");
66         require(success, "Address: unable to send value, recipient may have reverted");
67     }
68 
69     /**
70      * @dev Performs a Solidity function call using a low level `call`. A
71      * plain `call` is an unsafe replacement for a function call: use this
72      * function instead.
73      *
74      * If `target` reverts with a revert reason, it is bubbled up by this
75      * function (like regular Solidity function calls).
76      *
77      * Returns the raw returned data. To convert to the expected return value,
78      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
79      *
80      * Requirements:
81      *
82      * - `target` must be a contract.
83      * - calling `target` with `data` must not revert.
84      *
85      * _Available since v3.1._
86      */
87     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
88         return functionCall(target, data, "Address: low-level call failed");
89     }
90 
91     /**
92      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
93      * `errorMessage` as a fallback revert reason when `target` reverts.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(
98         address target,
99         bytes memory data,
100         string memory errorMessage
101     ) internal returns (bytes memory) {
102         return functionCallWithValue(target, data, 0, errorMessage);
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
107      * but also transferring `value` wei to `target`.
108      *
109      * Requirements:
110      *
111      * - the calling contract must have an ETH balance of at least `value`.
112      * - the called Solidity function must be `payable`.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(
117         address target,
118         bytes memory data,
119         uint256 value
120     ) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
126      * with `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value,
134         string memory errorMessage
135     ) internal returns (bytes memory) {
136         require(address(this).balance >= value, "Address: insufficient balance for call");
137         require(isContract(target), "Address: call to non-contract");
138 
139         (bool success, bytes memory returndata) = target.call{value: value}(data);
140         return verifyCallResult(success, returndata, errorMessage);
141     }
142 
143     /**
144      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
145      * but performing a static call.
146      *
147      * _Available since v3.3._
148      */
149     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
150         return functionStaticCall(target, data, "Address: low-level static call failed");
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
155      * but performing a static call.
156      *
157      * _Available since v3.3._
158      */
159     function functionStaticCall(
160         address target,
161         bytes memory data,
162         string memory errorMessage
163     ) internal view returns (bytes memory) {
164         require(isContract(target), "Address: static call to non-contract");
165 
166         (bool success, bytes memory returndata) = target.staticcall(data);
167         return verifyCallResult(success, returndata, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but performing a delegate call.
173      *
174      * _Available since v3.4._
175      */
176     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
177         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
182      * but performing a delegate call.
183      *
184      * _Available since v3.4._
185      */
186     function functionDelegateCall(
187         address target,
188         bytes memory data,
189         string memory errorMessage
190     ) internal returns (bytes memory) {
191         require(isContract(target), "Address: delegate call to non-contract");
192 
193         (bool success, bytes memory returndata) = target.delegatecall(data);
194         return verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     /**
198      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
199      * revert reason using the provided one.
200      *
201      * _Available since v4.3._
202      */
203     function verifyCallResult(
204         bool success,
205         bytes memory returndata,
206         string memory errorMessage
207     ) internal pure returns (bytes memory) {
208         if (success) {
209             return returndata;
210         } else {
211             // Look for revert reason and bubble it up if present
212             if (returndata.length > 0) {
213                 // The easiest way to bubble the revert reason is using memory via assembly
214                 /// @solidity memory-safe-assembly
215                 assembly {
216                     let returndata_size := mload(returndata)
217                     revert(add(32, returndata), returndata_size)
218                 }
219             } else {
220                 revert(errorMessage);
221             }
222         }
223     }
224 }
225 
226 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
227 
228 
229 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
230 
231 pragma solidity ^0.8.0;
232 
233 /**
234  * @title ERC721 token receiver interface
235  * @dev Interface for any contract that wants to support safeTransfers
236  * from ERC721 asset contracts.
237  */
238 interface IERC721Receiver {
239     /**
240      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
241      * by `operator` from `from`, this function is called.
242      *
243      * It must return its Solidity selector to confirm the token transfer.
244      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
245      *
246      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
247      */
248     function onERC721Received(
249         address operator,
250         address from,
251         uint256 tokenId,
252         bytes calldata data
253     ) external returns (bytes4);
254 }
255 
256 // File: @openzeppelin/contracts/utils/Strings.sol
257 
258 
259 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
260 
261 pragma solidity ^0.8.0;
262 
263 /**
264  * @dev String operations.
265  */
266 library Strings {
267     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
268     uint8 private constant _ADDRESS_LENGTH = 20;
269 
270     /**
271      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
272      */
273     function toString(uint256 value) internal pure returns (string memory) {
274         // Inspired by OraclizeAPI's implementation - MIT licence
275         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
276 
277         if (value == 0) {
278             return "0";
279         }
280         uint256 temp = value;
281         uint256 digits;
282         while (temp != 0) {
283             digits++;
284             temp /= 10;
285         }
286         bytes memory buffer = new bytes(digits);
287         while (value != 0) {
288             digits -= 1;
289             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
290             value /= 10;
291         }
292         return string(buffer);
293     }
294 
295     /**
296      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
297      */
298     function toHexString(uint256 value) internal pure returns (string memory) {
299         if (value == 0) {
300             return "0x00";
301         }
302         uint256 temp = value;
303         uint256 length = 0;
304         while (temp != 0) {
305             length++;
306             temp >>= 8;
307         }
308         return toHexString(value, length);
309     }
310 
311     /**
312      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
313      */
314     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
315         bytes memory buffer = new bytes(2 * length + 2);
316         buffer[0] = "0";
317         buffer[1] = "x";
318         for (uint256 i = 2 * length + 1; i > 1; --i) {
319             buffer[i] = _HEX_SYMBOLS[value & 0xf];
320             value >>= 4;
321         }
322         require(value == 0, "Strings: hex length insufficient");
323         return string(buffer);
324     }
325 
326     /**
327      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
328      */
329     function toHexString(address addr) internal pure returns (string memory) {
330         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
331     }
332 }
333 
334 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
335 
336 
337 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
338 
339 pragma solidity ^0.8.0;
340 
341 /**
342  * @dev These functions deal with verification of Merkle Tree proofs.
343  *
344  * The proofs can be generated using the JavaScript library
345  * https://github.com/miguelmota/merkletreejs[merkletreejs].
346  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
347  *
348  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
349  *
350  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
351  * hashing, or use a hash function other than keccak256 for hashing leaves.
352  * This is because the concatenation of a sorted pair of internal nodes in
353  * the merkle tree could be reinterpreted as a leaf value.
354  */
355 library MerkleProof {
356     /**
357      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
358      * defined by `root`. For this, a `proof` must be provided, containing
359      * sibling hashes on the branch from the leaf to the root of the tree. Each
360      * pair of leaves and each pair of pre-images are assumed to be sorted.
361      */
362     function verify(
363         bytes32[] memory proof,
364         bytes32 root,
365         bytes32 leaf
366     ) internal pure returns (bool) {
367         return processProof(proof, leaf) == root;
368     }
369 
370     /**
371      * @dev Calldata version of {verify}
372      *
373      * _Available since v4.7._
374      */
375     function verifyCalldata(
376         bytes32[] calldata proof,
377         bytes32 root,
378         bytes32 leaf
379     ) internal pure returns (bool) {
380         return processProofCalldata(proof, leaf) == root;
381     }
382 
383     /**
384      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
385      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
386      * hash matches the root of the tree. When processing the proof, the pairs
387      * of leafs & pre-images are assumed to be sorted.
388      *
389      * _Available since v4.4._
390      */
391     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
392         bytes32 computedHash = leaf;
393         for (uint256 i = 0; i < proof.length; i++) {
394             computedHash = _hashPair(computedHash, proof[i]);
395         }
396         return computedHash;
397     }
398 
399     /**
400      * @dev Calldata version of {processProof}
401      *
402      * _Available since v4.7._
403      */
404     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
405         bytes32 computedHash = leaf;
406         for (uint256 i = 0; i < proof.length; i++) {
407             computedHash = _hashPair(computedHash, proof[i]);
408         }
409         return computedHash;
410     }
411 
412     /**
413      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
414      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
415      *
416      * _Available since v4.7._
417      */
418     function multiProofVerify(
419         bytes32[] memory proof,
420         bool[] memory proofFlags,
421         bytes32 root,
422         bytes32[] memory leaves
423     ) internal pure returns (bool) {
424         return processMultiProof(proof, proofFlags, leaves) == root;
425     }
426 
427     /**
428      * @dev Calldata version of {multiProofVerify}
429      *
430      * _Available since v4.7._
431      */
432     function multiProofVerifyCalldata(
433         bytes32[] calldata proof,
434         bool[] calldata proofFlags,
435         bytes32 root,
436         bytes32[] memory leaves
437     ) internal pure returns (bool) {
438         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
439     }
440 
441     /**
442      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
443      * consuming from one or the other at each step according to the instructions given by
444      * `proofFlags`.
445      *
446      * _Available since v4.7._
447      */
448     function processMultiProof(
449         bytes32[] memory proof,
450         bool[] memory proofFlags,
451         bytes32[] memory leaves
452     ) internal pure returns (bytes32 merkleRoot) {
453         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
454         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
455         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
456         // the merkle tree.
457         uint256 leavesLen = leaves.length;
458         uint256 totalHashes = proofFlags.length;
459 
460         // Check proof validity.
461         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
462 
463         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
464         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
465         bytes32[] memory hashes = new bytes32[](totalHashes);
466         uint256 leafPos = 0;
467         uint256 hashPos = 0;
468         uint256 proofPos = 0;
469         // At each step, we compute the next hash using two values:
470         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
471         //   get the next hash.
472         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
473         //   `proof` array.
474         for (uint256 i = 0; i < totalHashes; i++) {
475             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
476             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
477             hashes[i] = _hashPair(a, b);
478         }
479 
480         if (totalHashes > 0) {
481             return hashes[totalHashes - 1];
482         } else if (leavesLen > 0) {
483             return leaves[0];
484         } else {
485             return proof[0];
486         }
487     }
488 
489     /**
490      * @dev Calldata version of {processMultiProof}
491      *
492      * _Available since v4.7._
493      */
494     function processMultiProofCalldata(
495         bytes32[] calldata proof,
496         bool[] calldata proofFlags,
497         bytes32[] memory leaves
498     ) internal pure returns (bytes32 merkleRoot) {
499         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
500         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
501         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
502         // the merkle tree.
503         uint256 leavesLen = leaves.length;
504         uint256 totalHashes = proofFlags.length;
505 
506         // Check proof validity.
507         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
508 
509         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
510         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
511         bytes32[] memory hashes = new bytes32[](totalHashes);
512         uint256 leafPos = 0;
513         uint256 hashPos = 0;
514         uint256 proofPos = 0;
515         // At each step, we compute the next hash using two values:
516         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
517         //   get the next hash.
518         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
519         //   `proof` array.
520         for (uint256 i = 0; i < totalHashes; i++) {
521             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
522             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
523             hashes[i] = _hashPair(a, b);
524         }
525 
526         if (totalHashes > 0) {
527             return hashes[totalHashes - 1];
528         } else if (leavesLen > 0) {
529             return leaves[0];
530         } else {
531             return proof[0];
532         }
533     }
534 
535     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
536         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
537     }
538 
539     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
540         /// @solidity memory-safe-assembly
541         assembly {
542             mstore(0x00, a)
543             mstore(0x20, b)
544             value := keccak256(0x00, 0x40)
545         }
546     }
547 }
548 
549 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
550 
551 
552 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
553 
554 pragma solidity ^0.8.0;
555 
556 /**
557  * @dev Contract module that helps prevent reentrant calls to a function.
558  *
559  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
560  * available, which can be applied to functions to make sure there are no nested
561  * (reentrant) calls to them.
562  *
563  * Note that because there is a single `nonReentrant` guard, functions marked as
564  * `nonReentrant` may not call one another. This can be worked around by making
565  * those functions `private`, and then adding `external` `nonReentrant` entry
566  * points to them.
567  *
568  * TIP: If you would like to learn more about reentrancy and alternative ways
569  * to protect against it, check out our blog post
570  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
571  */
572 abstract contract ReentrancyGuard {
573     // Booleans are more expensive than uint256 or any type that takes up a full
574     // word because each write operation emits an extra SLOAD to first read the
575     // slot's contents, replace the bits taken up by the boolean, and then write
576     // back. This is the compiler's defense against contract upgrades and
577     // pointer aliasing, and it cannot be disabled.
578 
579     // The values being non-zero value makes deployment a bit more expensive,
580     // but in exchange the refund on every call to nonReentrant will be lower in
581     // amount. Since refunds are capped to a percentage of the total
582     // transaction's gas, it is best to keep them low in cases like this one, to
583     // increase the likelihood of the full refund coming into effect.
584     uint256 private constant _NOT_ENTERED = 1;
585     uint256 private constant _ENTERED = 2;
586 
587     uint256 private _status;
588 
589     constructor() {
590         _status = _NOT_ENTERED;
591     }
592 
593     /**
594      * @dev Prevents a contract from calling itself, directly or indirectly.
595      * Calling a `nonReentrant` function from another `nonReentrant`
596      * function is not supported. It is possible to prevent this from happening
597      * by making the `nonReentrant` function external, and making it call a
598      * `private` function that does the actual work.
599      */
600     modifier nonReentrant() {
601         // On the first call to nonReentrant, _notEntered will be true
602         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
603 
604         // Any calls to nonReentrant after this point will fail
605         _status = _ENTERED;
606 
607         _;
608 
609         // By storing the original value once again, a refund is triggered (see
610         // https://eips.ethereum.org/EIPS/eip-2200)
611         _status = _NOT_ENTERED;
612     }
613 }
614 
615 // File: @openzeppelin/contracts/utils/Context.sol
616 
617 
618 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
619 
620 pragma solidity ^0.8.0;
621 
622 /**
623  * @dev Provides information about the current execution context, including the
624  * sender of the transaction and its data. While these are generally available
625  * via msg.sender and msg.data, they should not be accessed in such a direct
626  * manner, since when dealing with meta-transactions the account sending and
627  * paying for execution may not be the actual sender (as far as an application
628  * is concerned).
629  *
630  * This contract is only required for intermediate, library-like contracts.
631  */
632 abstract contract Context {
633     function _msgSender() internal view virtual returns (address) {
634         return msg.sender;
635     }
636 
637     function _msgData() internal view virtual returns (bytes calldata) {
638         return msg.data;
639     }
640 }
641 
642 // File: @openzeppelin/contracts/access/Ownable.sol
643 
644 
645 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
646 
647 pragma solidity ^0.8.0;
648 
649 
650 /**
651  * @dev Contract module which provides a basic access control mechanism, where
652  * there is an account (an owner) that can be granted exclusive access to
653  * specific functions.
654  *
655  * By default, the owner account will be the one that deploys the contract. This
656  * can later be changed with {transferOwnership}.
657  *
658  * This module is used through inheritance. It will make available the modifier
659  * `onlyOwner`, which can be applied to your functions to restrict their use to
660  * the owner.
661  */
662 abstract contract Ownable is Context {
663     address private _owner;
664 
665     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
666 
667     /**
668      * @dev Initializes the contract setting the deployer as the initial owner.
669      */
670     constructor() {
671         _transferOwnership(_msgSender());
672     }
673 
674     /**
675      * @dev Throws if called by any account other than the owner.
676      */
677     modifier onlyOwner() {
678         _checkOwner();
679         _;
680     }
681 
682     /**
683      * @dev Returns the address of the current owner.
684      */
685     function owner() public view virtual returns (address) {
686         return _owner;
687     }
688 
689     /**
690      * @dev Throws if the sender is not the owner.
691      */
692     function _checkOwner() internal view virtual {
693         require(owner() == _msgSender(), "Ownable: caller is not the owner");
694     }
695 
696     /**
697      * @dev Leaves the contract without owner. It will not be possible to call
698      * `onlyOwner` functions anymore. Can only be called by the current owner.
699      *
700      * NOTE: Renouncing ownership will leave the contract without an owner,
701      * thereby removing any functionality that is only available to the owner.
702      */
703     function renounceOwnership() public virtual onlyOwner {
704         _transferOwnership(address(0));
705     }
706 
707     /**
708      * @dev Transfers ownership of the contract to a new account (`newOwner`).
709      * Can only be called by the current owner.
710      */
711     function transferOwnership(address newOwner) public virtual onlyOwner {
712         require(newOwner != address(0), "Ownable: new owner is the zero address");
713         _transferOwnership(newOwner);
714     }
715 
716     /**
717      * @dev Transfers ownership of the contract to a new account (`newOwner`).
718      * Internal function without access restriction.
719      */
720     function _transferOwnership(address newOwner) internal virtual {
721         address oldOwner = _owner;
722         _owner = newOwner;
723         emit OwnershipTransferred(oldOwner, newOwner);
724     }
725 }
726 
727 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
728 
729 
730 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
731 
732 pragma solidity ^0.8.0;
733 
734 /**
735  * @dev Interface of the ERC165 standard, as defined in the
736  * https://eips.ethereum.org/EIPS/eip-165[EIP].
737  *
738  * Implementers can declare support of contract interfaces, which can then be
739  * queried by others ({ERC165Checker}).
740  *
741  * For an implementation, see {ERC165}.
742  */
743 interface IERC165 {
744     /**
745      * @dev Returns true if this contract implements the interface defined by
746      * `interfaceId`. See the corresponding
747      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
748      * to learn more about how these ids are created.
749      *
750      * This function call must use less than 30 000 gas.
751      */
752     function supportsInterface(bytes4 interfaceId) external view returns (bool);
753 }
754 
755 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
756 
757 
758 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
759 
760 pragma solidity ^0.8.0;
761 
762 
763 /**
764  * @dev Implementation of the {IERC165} interface.
765  *
766  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
767  * for the additional interface id that will be supported. For example:
768  *
769  * ```solidity
770  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
771  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
772  * }
773  * ```
774  *
775  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
776  */
777 abstract contract ERC165 is IERC165 {
778     /**
779      * @dev See {IERC165-supportsInterface}.
780      */
781     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
782         return interfaceId == type(IERC165).interfaceId;
783     }
784 }
785 
786 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
787 
788 
789 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
790 
791 pragma solidity ^0.8.0;
792 
793 
794 /**
795  * @dev Required interface of an ERC721 compliant contract.
796  */
797 interface IERC721 is IERC165 {
798     /**
799      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
800      */
801     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
802 
803     /**
804      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
805      */
806     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
807 
808     /**
809      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
810      */
811     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
812 
813     /**
814      * @dev Returns the number of tokens in ``owner``'s account.
815      */
816     function balanceOf(address owner) external view returns (uint256 balance);
817 
818     /**
819      * @dev Returns the owner of the `tokenId` token.
820      *
821      * Requirements:
822      *
823      * - `tokenId` must exist.
824      */
825     function ownerOf(uint256 tokenId) external view returns (address owner);
826 
827     /**
828      * @dev Safely transfers `tokenId` token from `from` to `to`.
829      *
830      * Requirements:
831      *
832      * - `from` cannot be the zero address.
833      * - `to` cannot be the zero address.
834      * - `tokenId` token must exist and be owned by `from`.
835      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
836      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
837      *
838      * Emits a {Transfer} event.
839      */
840     function safeTransferFrom(
841         address from,
842         address to,
843         uint256 tokenId,
844         bytes calldata data
845     ) external;
846 
847     /**
848      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
849      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
850      *
851      * Requirements:
852      *
853      * - `from` cannot be the zero address.
854      * - `to` cannot be the zero address.
855      * - `tokenId` token must exist and be owned by `from`.
856      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
857      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
858      *
859      * Emits a {Transfer} event.
860      */
861     function safeTransferFrom(
862         address from,
863         address to,
864         uint256 tokenId
865     ) external;
866 
867     /**
868      * @dev Transfers `tokenId` token from `from` to `to`.
869      *
870      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
871      *
872      * Requirements:
873      *
874      * - `from` cannot be the zero address.
875      * - `to` cannot be the zero address.
876      * - `tokenId` token must be owned by `from`.
877      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
878      *
879      * Emits a {Transfer} event.
880      */
881     function transferFrom(
882         address from,
883         address to,
884         uint256 tokenId
885     ) external;
886 
887     /**
888      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
889      * The approval is cleared when the token is transferred.
890      *
891      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
892      *
893      * Requirements:
894      *
895      * - The caller must own the token or be an approved operator.
896      * - `tokenId` must exist.
897      *
898      * Emits an {Approval} event.
899      */
900     function approve(address to, uint256 tokenId) external;
901 
902     /**
903      * @dev Approve or remove `operator` as an operator for the caller.
904      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
905      *
906      * Requirements:
907      *
908      * - The `operator` cannot be the caller.
909      *
910      * Emits an {ApprovalForAll} event.
911      */
912     function setApprovalForAll(address operator, bool _approved) external;
913 
914     /**
915      * @dev Returns the account approved for `tokenId` token.
916      *
917      * Requirements:
918      *
919      * - `tokenId` must exist.
920      */
921     function getApproved(uint256 tokenId) external view returns (address operator);
922 
923     /**
924      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
925      *
926      * See {setApprovalForAll}
927      */
928     function isApprovedForAll(address owner, address operator) external view returns (bool);
929 }
930 
931 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
932 
933 
934 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
935 
936 pragma solidity ^0.8.0;
937 
938 
939 /**
940  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
941  * @dev See https://eips.ethereum.org/EIPS/eip-721
942  */
943 interface IERC721Metadata is IERC721 {
944     /**
945      * @dev Returns the token collection name.
946      */
947     function name() external view returns (string memory);
948 
949     /**
950      * @dev Returns the token collection symbol.
951      */
952     function symbol() external view returns (string memory);
953 
954     /**
955      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
956      */
957     function tokenURI(uint256 tokenId) external view returns (string memory);
958 }
959 
960 // File: erc721a@3.3.0/contracts/IERC721A.sol
961 
962 
963 // ERC721A Contracts v3.3.0
964 // Creator: Chiru Labs
965 
966 pragma solidity ^0.8.4;
967 
968 
969 
970 /**
971  * @dev Interface of an ERC721A compliant contract.
972  */
973 interface IERC721A is IERC721, IERC721Metadata {
974     /**
975      * The caller must own the token or be an approved operator.
976      */
977     error ApprovalCallerNotOwnerNorApproved();
978 
979     /**
980      * The token does not exist.
981      */
982     error ApprovalQueryForNonexistentToken();
983 
984     /**
985      * The caller cannot approve to their own address.
986      */
987     error ApproveToCaller();
988 
989     /**
990      * The caller cannot approve to the current owner.
991      */
992     error ApprovalToCurrentOwner();
993 
994     /**
995      * Cannot query the balance for the zero address.
996      */
997     error BalanceQueryForZeroAddress();
998 
999     /**
1000      * Cannot mint to the zero address.
1001      */
1002     error MintToZeroAddress();
1003 
1004     /**
1005      * The quantity of tokens minted must be more than zero.
1006      */
1007     error MintZeroQuantity();
1008 
1009     /**
1010      * The token does not exist.
1011      */
1012     error OwnerQueryForNonexistentToken();
1013 
1014     /**
1015      * The caller must own the token or be an approved operator.
1016      */
1017     error TransferCallerNotOwnerNorApproved();
1018 
1019     /**
1020      * The token must be owned by `from`.
1021      */
1022     error TransferFromIncorrectOwner();
1023 
1024     /**
1025      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
1026      */
1027     error TransferToNonERC721ReceiverImplementer();
1028 
1029     /**
1030      * Cannot transfer to the zero address.
1031      */
1032     error TransferToZeroAddress();
1033 
1034     /**
1035      * The token does not exist.
1036      */
1037     error URIQueryForNonexistentToken();
1038 
1039     // Compiler will pack this into a single 256bit word.
1040     struct TokenOwnership {
1041         // The address of the owner.
1042         address addr;
1043         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1044         uint64 startTimestamp;
1045         // Whether the token has been burned.
1046         bool burned;
1047     }
1048 
1049     // Compiler will pack this into a single 256bit word.
1050     struct AddressData {
1051         // Realistically, 2**64-1 is more than enough.
1052         uint64 balance;
1053         // Keeps track of mint count with minimal overhead for tokenomics.
1054         uint64 numberMinted;
1055         // Keeps track of burn count with minimal overhead for tokenomics.
1056         uint64 numberBurned;
1057         // For miscellaneous variable(s) pertaining to the address
1058         // (e.g. number of whitelist mint slots used).
1059         // If there are multiple variables, please pack them into a uint64.
1060         uint64 aux;
1061     }
1062 
1063     /**
1064      * @dev Returns the total amount of tokens stored by the contract.
1065      * 
1066      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
1067      */
1068     function totalSupply() external view returns (uint256);
1069 }
1070 
1071 // File: erc721a@3.3.0/contracts/ERC721A.sol
1072 
1073 
1074 // ERC721A Contracts v3.3.0
1075 // Creator: Chiru Labs
1076 
1077 pragma solidity ^0.8.4;
1078 
1079 
1080 
1081 
1082 
1083 
1084 
1085 /**
1086  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1087  * the Metadata extension. Built to optimize for lower gas during batch mints.
1088  *
1089  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1090  *
1091  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1092  *
1093  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1094  */
1095 contract ERC721A is Context, ERC165, IERC721A {
1096     using Address for address;
1097     using Strings for uint256;
1098 
1099     // The tokenId of the next token to be minted.
1100     uint256 internal _currentIndex;
1101 
1102     // The number of tokens burned.
1103     uint256 internal _burnCounter;
1104 
1105     // Token name
1106     string private _name;
1107 
1108     // Token symbol
1109     string private _symbol;
1110 
1111     // Mapping from token ID to ownership details
1112     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1113     mapping(uint256 => TokenOwnership) internal _ownerships;
1114 
1115     // Mapping owner address to address data
1116     mapping(address => AddressData) private _addressData;
1117 
1118     // Mapping from token ID to approved address
1119     mapping(uint256 => address) private _tokenApprovals;
1120 
1121     // Mapping from owner to operator approvals
1122     mapping(address => mapping(address => bool)) private _operatorApprovals;
1123 
1124     constructor(string memory name_, string memory symbol_) {
1125         _name = name_;
1126         _symbol = symbol_;
1127         _currentIndex = _startTokenId();
1128     }
1129 
1130     /**
1131      * To change the starting tokenId, please override this function.
1132      */
1133     function _startTokenId() internal view virtual returns (uint256) {
1134         return 0;
1135     }
1136 
1137     /**
1138      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1139      */
1140     function totalSupply() public view override returns (uint256) {
1141         // Counter underflow is impossible as _burnCounter cannot be incremented
1142         // more than _currentIndex - _startTokenId() times
1143         unchecked {
1144             return _currentIndex - _burnCounter - _startTokenId();
1145         }
1146     }
1147 
1148     /**
1149      * Returns the total amount of tokens minted in the contract.
1150      */
1151     function _totalMinted() internal view returns (uint256) {
1152         // Counter underflow is impossible as _currentIndex does not decrement,
1153         // and it is initialized to _startTokenId()
1154         unchecked {
1155             return _currentIndex - _startTokenId();
1156         }
1157     }
1158 
1159     /**
1160      * @dev See {IERC165-supportsInterface}.
1161      */
1162     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1163         return
1164             interfaceId == type(IERC721).interfaceId ||
1165             interfaceId == type(IERC721Metadata).interfaceId ||
1166             super.supportsInterface(interfaceId);
1167     }
1168 
1169     /**
1170      * @dev See {IERC721-balanceOf}.
1171      */
1172     function balanceOf(address owner) public view override returns (uint256) {
1173         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1174         return uint256(_addressData[owner].balance);
1175     }
1176 
1177     /**
1178      * Returns the number of tokens minted by `owner`.
1179      */
1180     function _numberMinted(address owner) internal view returns (uint256) {
1181         return uint256(_addressData[owner].numberMinted);
1182     }
1183 
1184     /**
1185      * Returns the number of tokens burned by or on behalf of `owner`.
1186      */
1187     function _numberBurned(address owner) internal view returns (uint256) {
1188         return uint256(_addressData[owner].numberBurned);
1189     }
1190 
1191     /**
1192      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1193      */
1194     function _getAux(address owner) internal view returns (uint64) {
1195         return _addressData[owner].aux;
1196     }
1197 
1198     /**
1199      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1200      * If there are multiple variables, please pack them into a uint64.
1201      */
1202     function _setAux(address owner, uint64 aux) internal {
1203         _addressData[owner].aux = aux;
1204     }
1205 
1206     /**
1207      * Gas spent here starts off proportional to the maximum mint batch size.
1208      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1209      */
1210     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1211         uint256 curr = tokenId;
1212 
1213         unchecked {
1214             if (_startTokenId() <= curr) if (curr < _currentIndex) {
1215                 TokenOwnership memory ownership = _ownerships[curr];
1216                 if (!ownership.burned) {
1217                     if (ownership.addr != address(0)) {
1218                         return ownership;
1219                     }
1220                     // Invariant:
1221                     // There will always be an ownership that has an address and is not burned
1222                     // before an ownership that does not have an address and is not burned.
1223                     // Hence, curr will not underflow.
1224                     while (true) {
1225                         curr--;
1226                         ownership = _ownerships[curr];
1227                         if (ownership.addr != address(0)) {
1228                             return ownership;
1229                         }
1230                     }
1231                 }
1232             }
1233         }
1234         revert OwnerQueryForNonexistentToken();
1235     }
1236 
1237     /**
1238      * @dev See {IERC721-ownerOf}.
1239      */
1240     function ownerOf(uint256 tokenId) public view override returns (address) {
1241         return _ownershipOf(tokenId).addr;
1242     }
1243 
1244     /**
1245      * @dev See {IERC721Metadata-name}.
1246      */
1247     function name() public view virtual override returns (string memory) {
1248         return _name;
1249     }
1250 
1251     /**
1252      * @dev See {IERC721Metadata-symbol}.
1253      */
1254     function symbol() public view virtual override returns (string memory) {
1255         return _symbol;
1256     }
1257 
1258     /**
1259      * @dev See {IERC721Metadata-tokenURI}.
1260      */
1261     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1262         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1263 
1264         string memory baseURI = _baseURI();
1265         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1266     }
1267 
1268     /**
1269      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1270      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1271      * by default, can be overriden in child contracts.
1272      */
1273     function _baseURI() internal view virtual returns (string memory) {
1274         return '';
1275     }
1276 
1277     /**
1278      * @dev See {IERC721-approve}.
1279      */
1280     function approve(address to, uint256 tokenId) public override {
1281         address owner = ERC721A.ownerOf(tokenId);
1282         if (to == owner) revert ApprovalToCurrentOwner();
1283 
1284         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
1285             revert ApprovalCallerNotOwnerNorApproved();
1286         }
1287 
1288         _approve(to, tokenId, owner);
1289     }
1290 
1291     /**
1292      * @dev See {IERC721-getApproved}.
1293      */
1294     function getApproved(uint256 tokenId) public view override returns (address) {
1295         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1296 
1297         return _tokenApprovals[tokenId];
1298     }
1299 
1300     /**
1301      * @dev See {IERC721-setApprovalForAll}.
1302      */
1303     function setApprovalForAll(address operator, bool approved) public virtual override {
1304         if (operator == _msgSender()) revert ApproveToCaller();
1305 
1306         _operatorApprovals[_msgSender()][operator] = approved;
1307         emit ApprovalForAll(_msgSender(), operator, approved);
1308     }
1309 
1310     /**
1311      * @dev See {IERC721-isApprovedForAll}.
1312      */
1313     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1314         return _operatorApprovals[owner][operator];
1315     }
1316 
1317     /**
1318      * @dev See {IERC721-transferFrom}.
1319      */
1320     function transferFrom(
1321         address from,
1322         address to,
1323         uint256 tokenId
1324     ) public virtual override {
1325         _transfer(from, to, tokenId);
1326     }
1327 
1328     /**
1329      * @dev See {IERC721-safeTransferFrom}.
1330      */
1331     function safeTransferFrom(
1332         address from,
1333         address to,
1334         uint256 tokenId
1335     ) public virtual override {
1336         safeTransferFrom(from, to, tokenId, '');
1337     }
1338 
1339     /**
1340      * @dev See {IERC721-safeTransferFrom}.
1341      */
1342     function safeTransferFrom(
1343         address from,
1344         address to,
1345         uint256 tokenId,
1346         bytes memory _data
1347     ) public virtual override {
1348         _transfer(from, to, tokenId);
1349         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1350             revert TransferToNonERC721ReceiverImplementer();
1351         }
1352     }
1353 
1354     /**
1355      * @dev Returns whether `tokenId` exists.
1356      *
1357      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1358      *
1359      * Tokens start existing when they are minted (`_mint`),
1360      */
1361     function _exists(uint256 tokenId) internal view returns (bool) {
1362         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1363     }
1364 
1365     /**
1366      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1367      */
1368     function _safeMint(address to, uint256 quantity) internal {
1369         _safeMint(to, quantity, '');
1370     }
1371 
1372     /**
1373      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1374      *
1375      * Requirements:
1376      *
1377      * - If `to` refers to a smart contract, it must implement
1378      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1379      * - `quantity` must be greater than 0.
1380      *
1381      * Emits a {Transfer} event.
1382      */
1383     function _safeMint(
1384         address to,
1385         uint256 quantity,
1386         bytes memory _data
1387     ) internal {
1388         uint256 startTokenId = _currentIndex;
1389         if (to == address(0)) revert MintToZeroAddress();
1390         if (quantity == 0) revert MintZeroQuantity();
1391 
1392         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1393 
1394         // Overflows are incredibly unrealistic.
1395         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1396         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1397         unchecked {
1398             _addressData[to].balance += uint64(quantity);
1399             _addressData[to].numberMinted += uint64(quantity);
1400 
1401             _ownerships[startTokenId].addr = to;
1402             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1403 
1404             uint256 updatedIndex = startTokenId;
1405             uint256 end = updatedIndex + quantity;
1406 
1407             if (to.isContract()) {
1408                 do {
1409                     emit Transfer(address(0), to, updatedIndex);
1410                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1411                         revert TransferToNonERC721ReceiverImplementer();
1412                     }
1413                 } while (updatedIndex < end);
1414                 // Reentrancy protection
1415                 if (_currentIndex != startTokenId) revert();
1416             } else {
1417                 do {
1418                     emit Transfer(address(0), to, updatedIndex++);
1419                 } while (updatedIndex < end);
1420             }
1421             _currentIndex = updatedIndex;
1422         }
1423         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1424     }
1425 
1426     /**
1427      * @dev Mints `quantity` tokens and transfers them to `to`.
1428      *
1429      * Requirements:
1430      *
1431      * - `to` cannot be the zero address.
1432      * - `quantity` must be greater than 0.
1433      *
1434      * Emits a {Transfer} event.
1435      */
1436     function _mint(address to, uint256 quantity) internal {
1437         uint256 startTokenId = _currentIndex;
1438         if (to == address(0)) revert MintToZeroAddress();
1439         if (quantity == 0) revert MintZeroQuantity();
1440 
1441         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1442 
1443         // Overflows are incredibly unrealistic.
1444         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1445         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1446         unchecked {
1447             _addressData[to].balance += uint64(quantity);
1448             _addressData[to].numberMinted += uint64(quantity);
1449 
1450             _ownerships[startTokenId].addr = to;
1451             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1452 
1453             uint256 updatedIndex = startTokenId;
1454             uint256 end = updatedIndex + quantity;
1455 
1456             do {
1457                 emit Transfer(address(0), to, updatedIndex++);
1458             } while (updatedIndex < end);
1459 
1460             _currentIndex = updatedIndex;
1461         }
1462         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1463     }
1464 
1465     /**
1466      * @dev Transfers `tokenId` from `from` to `to`.
1467      *
1468      * Requirements:
1469      *
1470      * - `to` cannot be the zero address.
1471      * - `tokenId` token must be owned by `from`.
1472      *
1473      * Emits a {Transfer} event.
1474      */
1475     function _transfer(
1476         address from,
1477         address to,
1478         uint256 tokenId
1479     ) private {
1480         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1481 
1482         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1483 
1484         bool isApprovedOrOwner = (_msgSender() == from ||
1485             isApprovedForAll(from, _msgSender()) ||
1486             getApproved(tokenId) == _msgSender());
1487 
1488         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1489         if (to == address(0)) revert TransferToZeroAddress();
1490 
1491         _beforeTokenTransfers(from, to, tokenId, 1);
1492 
1493         // Clear approvals from the previous owner
1494         _approve(address(0), tokenId, from);
1495 
1496         // Underflow of the sender's balance is impossible because we check for
1497         // ownership above and the recipient's balance can't realistically overflow.
1498         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1499         unchecked {
1500             _addressData[from].balance -= 1;
1501             _addressData[to].balance += 1;
1502 
1503             TokenOwnership storage currSlot = _ownerships[tokenId];
1504             currSlot.addr = to;
1505             currSlot.startTimestamp = uint64(block.timestamp);
1506 
1507             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1508             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1509             uint256 nextTokenId = tokenId + 1;
1510             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1511             if (nextSlot.addr == address(0)) {
1512                 // This will suffice for checking _exists(nextTokenId),
1513                 // as a burned slot cannot contain the zero address.
1514                 if (nextTokenId != _currentIndex) {
1515                     nextSlot.addr = from;
1516                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1517                 }
1518             }
1519         }
1520 
1521         emit Transfer(from, to, tokenId);
1522         _afterTokenTransfers(from, to, tokenId, 1);
1523     }
1524 
1525     /**
1526      * @dev Equivalent to `_burn(tokenId, false)`.
1527      */
1528     function _burn(uint256 tokenId) internal virtual {
1529         _burn(tokenId, false);
1530     }
1531 
1532     /**
1533      * @dev Destroys `tokenId`.
1534      * The approval is cleared when the token is burned.
1535      *
1536      * Requirements:
1537      *
1538      * - `tokenId` must exist.
1539      *
1540      * Emits a {Transfer} event.
1541      */
1542     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1543         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1544 
1545         address from = prevOwnership.addr;
1546 
1547         if (approvalCheck) {
1548             bool isApprovedOrOwner = (_msgSender() == from ||
1549                 isApprovedForAll(from, _msgSender()) ||
1550                 getApproved(tokenId) == _msgSender());
1551 
1552             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1553         }
1554 
1555         _beforeTokenTransfers(from, address(0), tokenId, 1);
1556 
1557         // Clear approvals from the previous owner
1558         _approve(address(0), tokenId, from);
1559 
1560         // Underflow of the sender's balance is impossible because we check for
1561         // ownership above and the recipient's balance can't realistically overflow.
1562         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1563         unchecked {
1564             AddressData storage addressData = _addressData[from];
1565             addressData.balance -= 1;
1566             addressData.numberBurned += 1;
1567 
1568             // Keep track of who burned the token, and the timestamp of burning.
1569             TokenOwnership storage currSlot = _ownerships[tokenId];
1570             currSlot.addr = from;
1571             currSlot.startTimestamp = uint64(block.timestamp);
1572             currSlot.burned = true;
1573 
1574             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1575             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1576             uint256 nextTokenId = tokenId + 1;
1577             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1578             if (nextSlot.addr == address(0)) {
1579                 // This will suffice for checking _exists(nextTokenId),
1580                 // as a burned slot cannot contain the zero address.
1581                 if (nextTokenId != _currentIndex) {
1582                     nextSlot.addr = from;
1583                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1584                 }
1585             }
1586         }
1587 
1588         emit Transfer(from, address(0), tokenId);
1589         _afterTokenTransfers(from, address(0), tokenId, 1);
1590 
1591         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1592         unchecked {
1593             _burnCounter++;
1594         }
1595     }
1596 
1597     /**
1598      * @dev Approve `to` to operate on `tokenId`
1599      *
1600      * Emits a {Approval} event.
1601      */
1602     function _approve(
1603         address to,
1604         uint256 tokenId,
1605         address owner
1606     ) private {
1607         _tokenApprovals[tokenId] = to;
1608         emit Approval(owner, to, tokenId);
1609     }
1610 
1611     /**
1612      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1613      *
1614      * @param from address representing the previous owner of the given token ID
1615      * @param to target address that will receive the tokens
1616      * @param tokenId uint256 ID of the token to be transferred
1617      * @param _data bytes optional data to send along with the call
1618      * @return bool whether the call correctly returned the expected magic value
1619      */
1620     function _checkContractOnERC721Received(
1621         address from,
1622         address to,
1623         uint256 tokenId,
1624         bytes memory _data
1625     ) private returns (bool) {
1626         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1627             return retval == IERC721Receiver(to).onERC721Received.selector;
1628         } catch (bytes memory reason) {
1629             if (reason.length == 0) {
1630                 revert TransferToNonERC721ReceiverImplementer();
1631             } else {
1632                 assembly {
1633                     revert(add(32, reason), mload(reason))
1634                 }
1635             }
1636         }
1637     }
1638 
1639     /**
1640      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1641      * And also called before burning one token.
1642      *
1643      * startTokenId - the first token id to be transferred
1644      * quantity - the amount to be transferred
1645      *
1646      * Calling conditions:
1647      *
1648      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1649      * transferred to `to`.
1650      * - When `from` is zero, `tokenId` will be minted for `to`.
1651      * - When `to` is zero, `tokenId` will be burned by `from`.
1652      * - `from` and `to` are never both zero.
1653      */
1654     function _beforeTokenTransfers(
1655         address from,
1656         address to,
1657         uint256 startTokenId,
1658         uint256 quantity
1659     ) internal virtual {}
1660 
1661     /**
1662      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1663      * minting.
1664      * And also called after one token has been burned.
1665      *
1666      * startTokenId - the first token id to be transferred
1667      * quantity - the amount to be transferred
1668      *
1669      * Calling conditions:
1670      *
1671      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1672      * transferred to `to`.
1673      * - When `from` is zero, `tokenId` has been minted for `to`.
1674      * - When `to` is zero, `tokenId` has been burned by `from`.
1675      * - `from` and `to` are never both zero.
1676      */
1677     function _afterTokenTransfers(
1678         address from,
1679         address to,
1680         uint256 startTokenId,
1681         uint256 quantity
1682     ) internal virtual {}
1683 }
1684 
1685 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1686 
1687 
1688 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1689 
1690 pragma solidity ^0.8.0;
1691 
1692 
1693 /**
1694  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1695  * @dev See https://eips.ethereum.org/EIPS/eip-721
1696  */
1697 interface IERC721Enumerable is IERC721 {
1698     /**
1699      * @dev Returns the total amount of tokens stored by the contract.
1700      */
1701     function totalSupply() external view returns (uint256);
1702 
1703     /**
1704      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1705      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1706      */
1707     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1708 
1709     /**
1710      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1711      * Use along with {totalSupply} to enumerate all tokens.
1712      */
1713     function tokenByIndex(uint256 index) external view returns (uint256);
1714 }
1715 
1716 // File: contracts/Elev8.sol
1717 
1718 
1719 
1720 pragma solidity 0.8.13;
1721 
1722 
1723 
1724 
1725 
1726 
1727 
1728 
1729 contract Elev8 is ERC721A, Ownable, ReentrancyGuard {
1730     using Strings for uint256;
1731 
1732     uint256 public constant GENESIS_SUPPLY = 888;
1733     uint256 public constant MAX_PER_PUBLIC_GENESIS_TX = 5;
1734     uint256 public constant MAX_PER_GENESIS_ADDRESS = 2;
1735     uint256 public constant MAX_PER_PUBLIC_MINT_TX = 10;
1736     uint256 public constant RESERVE_QTY = 18;
1737 
1738     uint256 public publicSalePrice = 0.04 ether;
1739     uint256 public maxSupply = 8888;
1740 
1741     uint256 public genesisMintCount;
1742     uint256 public balanceAfterTeamPayments;
1743 
1744     bytes32 public genesisMerkleRoot;
1745 
1746     bool public genesisMintActive;
1747     bool public genesisPublicMintActive;
1748     bool public publicMintActive;
1749 
1750     bool public genesisMintsRevealed;
1751     bool public publicMintsRevealed;
1752 
1753     mapping(address => uint256) public genesisMintCounts;
1754 
1755     string private _baseUri;
1756     string private _contractURI;
1757     address[2] private _admins;
1758 
1759     address private constant _PROJECT =
1760         0x15B31F13D09420c0ADCB3A9AF7be29d6AdCF31BA;
1761     address private constant _PICO = 
1762         0x86190c50d1dD3Eeb2Ab1dbb8E7195F2195AF321f;
1763 
1764     bool private _adminsSet = false;
1765     uint256 private _qtyReserved = 0;
1766 
1767     event GenesisMintStateChanged(address indexed caller, bool indexed active);
1768     event GenesisPublicMintStateChanged(address indexed caller, bool indexed active);
1769     event PublicMintStateChanged(address indexed caller, bool indexed active);
1770     event PublicSalePriceChanged(address indexed caller, uint256 indexed newPrice);
1771     event MaxSupplyChanged(address indexed caller, uint256 newValue);
1772     event TeamMemberPayment(
1773         address indexed recipient,
1774         uint256 totalSold,
1775         uint256 baseAmount,
1776         uint256 paymentAmount
1777     );
1778 
1779     modifier canActivate(bool active) {
1780         if (active) {
1781             require(
1782                 bytes(_baseUri).length > 0,
1783                 "Metadata url has not been set"
1784             );
1785         }
1786         _;
1787     }
1788 
1789     modifier onlyOwnerOrAdmin() {
1790         require(
1791             _msgSender() == owner() ||
1792                 (_adminsSet &&
1793                     (_msgSender() == _admins[0] || _msgSender() == _admins[1])),
1794             "Not owner or admin"
1795         );
1796         _;
1797     }
1798 
1799     modifier validProof(bytes32[] calldata merkleProof) {
1800         require(
1801             MerkleProof.verify(
1802                 merkleProof, 
1803                 genesisMerkleRoot, 
1804                 keccak256(abi.encodePacked(_msgSender()))
1805             ), 
1806             "Invalid proof"
1807         );
1808         _;
1809     }
1810 
1811     constructor(string memory name, string memory symbol)
1812         ERC721A(name, symbol)
1813     {
1814         require(
1815             bytes(name).length > 0 && bytes(symbol).length > 0,
1816             "Name and Symbol"
1817         );
1818     }
1819 
1820     function genesisMint(uint256 qty, bytes32[] calldata merkleProof) external nonReentrant validProof(merkleProof) {
1821         require(genesisMintActive, "Genesis minting inactive");
1822         require(
1823             genesisMintCount + qty + RESERVE_QTY <= GENESIS_SUPPLY,
1824             "Exceeds available supply"
1825         );
1826         require(genesisMintCounts[_msgSender()] + qty <= MAX_PER_GENESIS_ADDRESS, "Exceeds address quantity limit");
1827 
1828         genesisMintCount += qty;
1829         genesisMintCounts[_msgSender()] += qty;
1830 
1831         _internalMint(_msgSender(), qty);
1832     }
1833 
1834     function genesisPublicMint(uint256 qty) external nonReentrant {
1835         require(
1836             genesisPublicMintActive, 
1837             "Genesis public minting inactive"
1838         );
1839         require(
1840             genesisMintCount + qty + RESERVE_QTY <= GENESIS_SUPPLY,
1841             "Exceeds available supply"
1842         );
1843         require(qty <= MAX_PER_PUBLIC_GENESIS_TX, "Exceeds tx quantity limit");
1844 
1845         genesisMintCount += qty;
1846         _internalMint(_msgSender(), qty);
1847     }
1848 
1849     function mint(uint256 qty) external payable nonReentrant {
1850         require(publicMintActive, "Public minting inactive");
1851         require(msg.value == (publicSalePrice * qty), "Incorrect payment amount");
1852         require(qty <= MAX_PER_PUBLIC_MINT_TX, "Exceeds tx quantity limit");
1853 
1854         _internalMint(_msgSender(), qty);
1855     }
1856 
1857     function distributeFromReserve(uint256 qty, address recipient)
1858         external
1859         nonReentrant
1860         onlyOwner
1861     {
1862         require(_qtyReserved + qty <= RESERVE_QTY, "Exceeds reserve quantity");
1863 
1864         _qtyReserved += qty;
1865         _internalMint(recipient, qty);
1866     }
1867 
1868     function payTeam() external onlyOwnerOrAdmin nonReentrant {
1869         require(
1870             address(this).balance > balanceAfterTeamPayments,
1871             "No payable balance"
1872         );
1873         uint256 payableBalance = address(this).balance -
1874             balanceAfterTeamPayments;
1875 
1876         uint256 paymentAmount = (payableBalance * 10) / 100; // 10%
1877 
1878         // Keep track of the balance after each time the team is paid so we don't pay the team
1879         // on amounts they've already been paid from
1880         balanceAfterTeamPayments += (payableBalance - paymentAmount);
1881 
1882         require(payable(_PICO).send(paymentAmount), "Team payment failed");
1883 
1884         emit TeamMemberPayment(
1885             _PICO,
1886             totalSupply() - _qtyReserved - genesisMintCount, // This is the non-free mint qty
1887             payableBalance,
1888             paymentAmount
1889         );
1890     }
1891 
1892     function withdrawToProjectAccount(uint256 amount)
1893         external
1894         onlyOwner
1895         nonReentrant
1896     {
1897         require(amount > 0, "Amount cannot be zero");
1898         require(
1899             balanceAfterTeamPayments >= amount,
1900             "Exceeds withdrawable amount"
1901         );
1902 
1903         balanceAfterTeamPayments -= amount;
1904         require(payable(_PROJECT).send(amount), "Project withdraw failed");
1905     }
1906 
1907     function setBaseURI(string calldata baseURI) external onlyOwnerOrAdmin {
1908         require(bytes(baseURI).length > 0, "baseURI is required");
1909         _baseUri = baseURI;
1910     }
1911 
1912     function setAdmins(address[2] calldata adminAddresses) external onlyOwner {
1913         require(
1914             adminAddresses[0] != address(0) && adminAddresses[1] != address(0),
1915             "Invalid address"
1916         );
1917 
1918         _admins = adminAddresses;
1919         _adminsSet = true;
1920     }
1921 
1922     function setGenesisSaleActive(bool active)
1923         external
1924         onlyOwnerOrAdmin
1925         canActivate(active)
1926     {
1927         genesisMintActive = active;
1928         emit GenesisMintStateChanged(_msgSender(), active);
1929     }
1930 
1931      function setGenesisPublicSaleActive(bool active)
1932         external
1933         onlyOwnerOrAdmin
1934         canActivate(active)
1935     {
1936         genesisPublicMintActive = active;
1937         emit GenesisPublicMintStateChanged(_msgSender(), active);
1938     }
1939 
1940     function setPublicSaleActive(bool active)
1941         external
1942         onlyOwnerOrAdmin
1943         canActivate(active)
1944     {
1945         publicMintActive = active;
1946         emit GenesisMintStateChanged(_msgSender(), active);
1947     }
1948 
1949     function setPublicSalePrice(uint256 newPrice) external onlyOwnerOrAdmin {
1950         // The public sale price cannot be increased after the first public
1951         // mint, but it can be decreased. Any changes will be communicated beforehand
1952         require(newPrice <= publicSalePrice || totalSupply() <= GENESIS_SUPPLY, "Cannot increase price");
1953         publicSalePrice = newPrice;
1954         emit PublicSalePriceChanged(_msgSender(), newPrice);
1955     }
1956 
1957     function setMaxSupply(uint256 newValue) external onlyOwnerOrAdmin {
1958         require(newValue < maxSupply, "Cannot increase supply");
1959         require(newValue >= totalSupply(), "Total minted exceeds new value");
1960         maxSupply = newValue;
1961         emit MaxSupplyChanged(_msgSender(), newValue);
1962     }
1963 
1964     function setGenesisMerkleRoot(bytes32 merkleRoot) external onlyOwnerOrAdmin {
1965         genesisMerkleRoot = merkleRoot;
1966     }
1967 
1968     function revealGenesisMints() external onlyOwnerOrAdmin {
1969         genesisMintsRevealed = true;
1970     }
1971 
1972     function revealPublicMints() external onlyOwnerOrAdmin {
1973         publicMintsRevealed = true;
1974     }
1975 
1976     /// @dev Returns the tokenIds of the address. O(totalSupply) in complexity.
1977     /// Inspired by https://github.com/chiru-labs/ERC721A/issues/115#issue-1140835245
1978     /// Modified to bail out of the loop once we've found the expected number of tokens
1979     function tokensOfOwner(address owner)
1980         external
1981         view
1982         returns (uint256[] memory)
1983     {
1984         unchecked {
1985             uint256 ownerBalance = balanceOf(owner);
1986             uint256[] memory a = new uint256[](ownerBalance);
1987             uint256 end = _currentIndex;
1988             uint256 tokenIdsIdx;
1989             address currOwnershipAddr;
1990             for (uint256 i; i < end; i++) {
1991                 TokenOwnership memory ownership = _ownerships[i];
1992                 if (ownership.burned) {
1993                     continue;
1994                 }
1995                 if (ownership.addr != address(0)) {
1996                     currOwnershipAddr = ownership.addr;
1997                 }
1998                 if (currOwnershipAddr == owner) {
1999                     a[tokenIdsIdx++] = i;
2000                 }
2001                 // No need to continue if we've already collected the expected number
2002                 // of token ids for this owner, so let's bail
2003                 if (tokenIdsIdx == ownerBalance) {
2004                     break;
2005                 }
2006             }
2007             return a;
2008         }
2009     }
2010 
2011     function burn(uint256 tokenId) public {
2012         require(_ownerships[tokenId].addr == _msgSender(), "Not owner");
2013         _burn(tokenId);
2014     }
2015 
2016     function setContractURI(string memory newUri) public onlyOwner {
2017         _contractURI = newUri;
2018     }
2019 
2020     function tokenURI(uint256 tokenId)
2021         public
2022         view
2023         override
2024         returns (string memory)
2025     {
2026         require(_exists(tokenId), "Nonexistent tokenId");
2027         return
2028             string(
2029                 abi.encodePacked(_baseUri, "/", tokenId.toString())
2030             );
2031     }
2032 
2033     function contractURI() public view returns (string memory) {
2034         return _contractURI;
2035     }
2036 
2037     function supportsInterface(bytes4 interfaceId)
2038         public
2039         view
2040         virtual
2041         override
2042         returns (bool)
2043     {
2044         return super.supportsInterface(interfaceId);
2045     }
2046 
2047     function _baseURI() internal view virtual override returns (string memory) {
2048         return _baseUri;
2049     }
2050 
2051     /// @notice By default, ERC721A starts minting from 0, which is undesirable in our case, so we'll
2052     /// override that to start from 1
2053     function _startTokenId() internal view virtual override returns (uint256) {
2054         return 1;
2055     }
2056 
2057     function _internalMint(address recipient, uint256 qty) private {
2058         require(qty > 0, "Quantity cannot be zero");
2059         require(
2060             (totalSupply() + qty + (RESERVE_QTY - _qtyReserved)) <= maxSupply,
2061             "Exceeds total supply"
2062         );
2063         _safeMint(recipient, qty);
2064     }
2065 }