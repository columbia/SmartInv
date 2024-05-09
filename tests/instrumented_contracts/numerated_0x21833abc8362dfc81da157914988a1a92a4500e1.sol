1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13     uint8 private constant _ADDRESS_LENGTH = 20;
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 
71     /**
72      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
73      */
74     function toHexString(address addr) internal pure returns (string memory) {
75         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
76     }
77 }
78 
79 // File: @openzeppelin/contracts/utils/Address.sol
80 
81 
82 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
83 
84 pragma solidity ^0.8.1;
85 
86 /**
87  * @dev Collection of functions related to the address type
88  */
89 library Address {
90     /**
91      * @dev Returns true if `account` is a contract.
92      *
93      * [IMPORTANT]
94      * ====
95      * It is unsafe to assume that an address for which this function returns
96      * false is an externally-owned account (EOA) and not a contract.
97      *
98      * Among others, `isContract` will return false for the following
99      * types of addresses:
100      *
101      *  - an externally-owned account
102      *  - a contract in construction
103      *  - an address where a contract will be created
104      *  - an address where a contract lived, but was destroyed
105      * ====
106      *
107      * [IMPORTANT]
108      * ====
109      * You shouldn't rely on `isContract` to protect against flash loan attacks!
110      *
111      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
112      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
113      * constructor.
114      * ====
115      */
116     function isContract(address account) internal view returns (bool) {
117         // This method relies on extcodesize/address.code.length, which returns 0
118         // for contracts in construction, since the code is only stored at the end
119         // of the constructor execution.
120 
121         return account.code.length > 0;
122     }
123 
124     /**
125      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
126      * `recipient`, forwarding all available gas and reverting on errors.
127      *
128      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
129      * of certain opcodes, possibly making contracts go over the 2300 gas limit
130      * imposed by `transfer`, making them unable to receive funds via
131      * `transfer`. {sendValue} removes this limitation.
132      *
133      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
134      *
135      * IMPORTANT: because control is transferred to `recipient`, care must be
136      * taken to not create reentrancy vulnerabilities. Consider using
137      * {ReentrancyGuard} or the
138      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
139      */
140     function sendValue(address payable recipient, uint256 amount) internal {
141         require(address(this).balance >= amount, "Address: insufficient balance");
142 
143         (bool success, ) = recipient.call{value: amount}("");
144         require(success, "Address: unable to send value, recipient may have reverted");
145     }
146 
147     /**
148      * @dev Performs a Solidity function call using a low level `call`. A
149      * plain `call` is an unsafe replacement for a function call: use this
150      * function instead.
151      *
152      * If `target` reverts with a revert reason, it is bubbled up by this
153      * function (like regular Solidity function calls).
154      *
155      * Returns the raw returned data. To convert to the expected return value,
156      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
157      *
158      * Requirements:
159      *
160      * - `target` must be a contract.
161      * - calling `target` with `data` must not revert.
162      *
163      * _Available since v3.1._
164      */
165     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
166         return functionCall(target, data, "Address: low-level call failed");
167     }
168 
169     /**
170      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
171      * `errorMessage` as a fallback revert reason when `target` reverts.
172      *
173      * _Available since v3.1._
174      */
175     function functionCall(
176         address target,
177         bytes memory data,
178         string memory errorMessage
179     ) internal returns (bytes memory) {
180         return functionCallWithValue(target, data, 0, errorMessage);
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
185      * but also transferring `value` wei to `target`.
186      *
187      * Requirements:
188      *
189      * - the calling contract must have an ETH balance of at least `value`.
190      * - the called Solidity function must be `payable`.
191      *
192      * _Available since v3.1._
193      */
194     function functionCallWithValue(
195         address target,
196         bytes memory data,
197         uint256 value
198     ) internal returns (bytes memory) {
199         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
204      * with `errorMessage` as a fallback revert reason when `target` reverts.
205      *
206      * _Available since v3.1._
207      */
208     function functionCallWithValue(
209         address target,
210         bytes memory data,
211         uint256 value,
212         string memory errorMessage
213     ) internal returns (bytes memory) {
214         require(address(this).balance >= value, "Address: insufficient balance for call");
215         require(isContract(target), "Address: call to non-contract");
216 
217         (bool success, bytes memory returndata) = target.call{value: value}(data);
218         return verifyCallResult(success, returndata, errorMessage);
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
223      * but performing a static call.
224      *
225      * _Available since v3.3._
226      */
227     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
228         return functionStaticCall(target, data, "Address: low-level static call failed");
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
233      * but performing a static call.
234      *
235      * _Available since v3.3._
236      */
237     function functionStaticCall(
238         address target,
239         bytes memory data,
240         string memory errorMessage
241     ) internal view returns (bytes memory) {
242         require(isContract(target), "Address: static call to non-contract");
243 
244         (bool success, bytes memory returndata) = target.staticcall(data);
245         return verifyCallResult(success, returndata, errorMessage);
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
250      * but performing a delegate call.
251      *
252      * _Available since v3.4._
253      */
254     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
255         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
260      * but performing a delegate call.
261      *
262      * _Available since v3.4._
263      */
264     function functionDelegateCall(
265         address target,
266         bytes memory data,
267         string memory errorMessage
268     ) internal returns (bytes memory) {
269         require(isContract(target), "Address: delegate call to non-contract");
270 
271         (bool success, bytes memory returndata) = target.delegatecall(data);
272         return verifyCallResult(success, returndata, errorMessage);
273     }
274 
275     /**
276      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
277      * revert reason using the provided one.
278      *
279      * _Available since v4.3._
280      */
281     function verifyCallResult(
282         bool success,
283         bytes memory returndata,
284         string memory errorMessage
285     ) internal pure returns (bytes memory) {
286         if (success) {
287             return returndata;
288         } else {
289             // Look for revert reason and bubble it up if present
290             if (returndata.length > 0) {
291                 // The easiest way to bubble the revert reason is using memory via assembly
292                 /// @solidity memory-safe-assembly
293                 assembly {
294                     let returndata_size := mload(returndata)
295                     revert(add(32, returndata), returndata_size)
296                 }
297             } else {
298                 revert(errorMessage);
299             }
300         }
301     }
302 }
303 
304 // File: @openzeppelin/contracts/utils/Context.sol
305 
306 
307 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
308 
309 pragma solidity ^0.8.0;
310 
311 /**
312  * @dev Provides information about the current execution context, including the
313  * sender of the transaction and its data. While these are generally available
314  * via msg.sender and msg.data, they should not be accessed in such a direct
315  * manner, since when dealing with meta-transactions the account sending and
316  * paying for execution may not be the actual sender (as far as an application
317  * is concerned).
318  *
319  * This contract is only required for intermediate, library-like contracts.
320  */
321 abstract contract Context {
322     function _msgSender() internal view virtual returns (address) {
323         return msg.sender;
324     }
325 
326     function _msgData() internal view virtual returns (bytes calldata) {
327         return msg.data;
328     }
329 }
330 
331 // File: @openzeppelin/contracts/access/Ownable.sol
332 
333 
334 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
335 
336 pragma solidity ^0.8.0;
337 
338 
339 /**
340  * @dev Contract module which provides a basic access control mechanism, where
341  * there is an account (an owner) that can be granted exclusive access to
342  * specific functions.
343  *
344  * By default, the owner account will be the one that deploys the contract. This
345  * can later be changed with {transferOwnership}.
346  *
347  * This module is used through inheritance. It will make available the modifier
348  * `onlyOwner`, which can be applied to your functions to restrict their use to
349  * the owner.
350  */
351 abstract contract Ownable is Context {
352     address private _owner;
353 
354     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
355 
356     /**
357      * @dev Initializes the contract setting the deployer as the initial owner.
358      */
359     constructor() {
360         _transferOwnership(_msgSender());
361     }
362 
363     /**
364      * @dev Throws if called by any account other than the owner.
365      */
366     modifier onlyOwner() {
367         _checkOwner();
368         _;
369     }
370 
371     /**
372      * @dev Returns the address of the current owner.
373      */
374     function owner() public view virtual returns (address) {
375         return _owner;
376     }
377 
378     /**
379      * @dev Throws if the sender is not the owner.
380      */
381     function _checkOwner() internal view virtual {
382         require(owner() == _msgSender(), "Ownable: caller is not the owner");
383     }
384 
385     /**
386      * @dev Leaves the contract without owner. It will not be possible to call
387      * `onlyOwner` functions anymore. Can only be called by the current owner.
388      *
389      * NOTE: Renouncing ownership will leave the contract without an owner,
390      * thereby removing any functionality that is only available to the owner.
391      */
392     function renounceOwnership() public virtual onlyOwner {
393         _transferOwnership(address(0));
394     }
395 
396     /**
397      * @dev Transfers ownership of the contract to a new account (`newOwner`).
398      * Can only be called by the current owner.
399      */
400     function transferOwnership(address newOwner) public virtual onlyOwner {
401         require(newOwner != address(0), "Ownable: new owner is the zero address");
402         _transferOwnership(newOwner);
403     }
404 
405     /**
406      * @dev Transfers ownership of the contract to a new account (`newOwner`).
407      * Internal function without access restriction.
408      */
409     function _transferOwnership(address newOwner) internal virtual {
410         address oldOwner = _owner;
411         _owner = newOwner;
412         emit OwnershipTransferred(oldOwner, newOwner);
413     }
414 }
415 
416 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/MerkleProof.sol
417 
418 
419 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
420 
421 pragma solidity ^0.8.0;
422 
423 /**
424  * @dev These functions deal with verification of Merkle Tree proofs.
425  *
426  * The proofs can be generated using the JavaScript library
427  * https://github.com/miguelmota/merkletreejs[merkletreejs].
428  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
429  *
430  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
431  *
432  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
433  * hashing, or use a hash function other than keccak256 for hashing leaves.
434  * This is because the concatenation of a sorted pair of internal nodes in
435  * the merkle tree could be reinterpreted as a leaf value.
436  */
437 library MerkleProof {
438     /**
439      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
440      * defined by `root`. For this, a `proof` must be provided, containing
441      * sibling hashes on the branch from the leaf to the root of the tree. Each
442      * pair of leaves and each pair of pre-images are assumed to be sorted.
443      */
444     function verify(
445         bytes32[] memory proof,
446         bytes32 root,
447         bytes32 leaf
448     ) internal pure returns (bool) {
449         return processProof(proof, leaf) == root;
450     }
451 
452     /**
453      * @dev Calldata version of {verify}
454      *
455      * _Available since v4.7._
456      */
457     function verifyCalldata(
458         bytes32[] calldata proof,
459         bytes32 root,
460         bytes32 leaf
461     ) internal pure returns (bool) {
462         return processProofCalldata(proof, leaf) == root;
463     }
464 
465     /**
466      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
467      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
468      * hash matches the root of the tree. When processing the proof, the pairs
469      * of leafs & pre-images are assumed to be sorted.
470      *
471      * _Available since v4.4._
472      */
473     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
474         bytes32 computedHash = leaf;
475         for (uint256 i = 0; i < proof.length; i++) {
476             computedHash = _hashPair(computedHash, proof[i]);
477         }
478         return computedHash;
479     }
480 
481     /**
482      * @dev Calldata version of {processProof}
483      *
484      * _Available since v4.7._
485      */
486     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
487         bytes32 computedHash = leaf;
488         for (uint256 i = 0; i < proof.length; i++) {
489             computedHash = _hashPair(computedHash, proof[i]);
490         }
491         return computedHash;
492     }
493 
494     /**
495      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
496      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
497      *
498      * _Available since v4.7._
499      */
500     function multiProofVerify(
501         bytes32[] memory proof,
502         bool[] memory proofFlags,
503         bytes32 root,
504         bytes32[] memory leaves
505     ) internal pure returns (bool) {
506         return processMultiProof(proof, proofFlags, leaves) == root;
507     }
508 
509     /**
510      * @dev Calldata version of {multiProofVerify}
511      *
512      * _Available since v4.7._
513      */
514     function multiProofVerifyCalldata(
515         bytes32[] calldata proof,
516         bool[] calldata proofFlags,
517         bytes32 root,
518         bytes32[] memory leaves
519     ) internal pure returns (bool) {
520         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
521     }
522 
523     /**
524      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
525      * consuming from one or the other at each step according to the instructions given by
526      * `proofFlags`.
527      *
528      * _Available since v4.7._
529      */
530     function processMultiProof(
531         bytes32[] memory proof,
532         bool[] memory proofFlags,
533         bytes32[] memory leaves
534     ) internal pure returns (bytes32 merkleRoot) {
535         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
536         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
537         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
538         // the merkle tree.
539         uint256 leavesLen = leaves.length;
540         uint256 totalHashes = proofFlags.length;
541 
542         // Check proof validity.
543         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
544 
545         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
546         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
547         bytes32[] memory hashes = new bytes32[](totalHashes);
548         uint256 leafPos = 0;
549         uint256 hashPos = 0;
550         uint256 proofPos = 0;
551         // At each step, we compute the next hash using two values:
552         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
553         //   get the next hash.
554         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
555         //   `proof` array.
556         for (uint256 i = 0; i < totalHashes; i++) {
557             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
558             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
559             hashes[i] = _hashPair(a, b);
560         }
561 
562         if (totalHashes > 0) {
563             return hashes[totalHashes - 1];
564         } else if (leavesLen > 0) {
565             return leaves[0];
566         } else {
567             return proof[0];
568         }
569     }
570 
571     /**
572      * @dev Calldata version of {processMultiProof}
573      *
574      * _Available since v4.7._
575      */
576     function processMultiProofCalldata(
577         bytes32[] calldata proof,
578         bool[] calldata proofFlags,
579         bytes32[] memory leaves
580     ) internal pure returns (bytes32 merkleRoot) {
581         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
582         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
583         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
584         // the merkle tree.
585         uint256 leavesLen = leaves.length;
586         uint256 totalHashes = proofFlags.length;
587 
588         // Check proof validity.
589         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
590 
591         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
592         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
593         bytes32[] memory hashes = new bytes32[](totalHashes);
594         uint256 leafPos = 0;
595         uint256 hashPos = 0;
596         uint256 proofPos = 0;
597         // At each step, we compute the next hash using two values:
598         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
599         //   get the next hash.
600         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
601         //   `proof` array.
602         for (uint256 i = 0; i < totalHashes; i++) {
603             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
604             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
605             hashes[i] = _hashPair(a, b);
606         }
607 
608         if (totalHashes > 0) {
609             return hashes[totalHashes - 1];
610         } else if (leavesLen > 0) {
611             return leaves[0];
612         } else {
613             return proof[0];
614         }
615     }
616 
617     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
618         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
619     }
620 
621     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
622         /// @solidity memory-safe-assembly
623         assembly {
624             mstore(0x00, a)
625             mstore(0x20, b)
626             value := keccak256(0x00, 0x40)
627         }
628     }
629 }
630 
631 // File: erc721a/contracts/IERC721A.sol
632 
633 
634 // ERC721A Contracts v4.2.0
635 // Creator: Chiru Labs
636 
637 pragma solidity ^0.8.4;
638 
639 /**
640  * @dev Interface of ERC721A.
641  */
642 interface IERC721A {
643     /**
644      * The caller must own the token or be an approved operator.
645      */
646     error ApprovalCallerNotOwnerNorApproved();
647 
648     /**
649      * The token does not exist.
650      */
651     error ApprovalQueryForNonexistentToken();
652 
653     /**
654      * The caller cannot approve to their own address.
655      */
656     error ApproveToCaller();
657 
658     /**
659      * Cannot query the balance for the zero address.
660      */
661     error BalanceQueryForZeroAddress();
662 
663     /**
664      * Cannot mint to the zero address.
665      */
666     error MintToZeroAddress();
667 
668     /**
669      * The quantity of tokens minted must be more than zero.
670      */
671     error MintZeroQuantity();
672 
673     /**
674      * The token does not exist.
675      */
676     error OwnerQueryForNonexistentToken();
677 
678     /**
679      * The caller must own the token or be an approved operator.
680      */
681     error TransferCallerNotOwnerNorApproved();
682 
683     /**
684      * The token must be owned by `from`.
685      */
686     error TransferFromIncorrectOwner();
687 
688     /**
689      * Cannot safely transfer to a contract that does not implement the
690      * ERC721Receiver interface.
691      */
692     error TransferToNonERC721ReceiverImplementer();
693 
694     /**
695      * Cannot transfer to the zero address.
696      */
697     error TransferToZeroAddress();
698 
699     /**
700      * The token does not exist.
701      */
702     error URIQueryForNonexistentToken();
703 
704     /**
705      * The `quantity` minted with ERC2309 exceeds the safety limit.
706      */
707     error MintERC2309QuantityExceedsLimit();
708 
709     /**
710      * The `extraData` cannot be set on an unintialized ownership slot.
711      */
712     error OwnershipNotInitializedForExtraData();
713 
714     // =============================================================
715     //                            STRUCTS
716     // =============================================================
717 
718     struct TokenOwnership {
719         // The address of the owner.
720         address addr;
721         // Stores the start time of ownership with minimal overhead for tokenomics.
722         uint64 startTimestamp;
723         // Whether the token has been burned.
724         bool burned;
725         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
726         uint24 extraData;
727     }
728 
729     // =============================================================
730     //                         TOKEN COUNTERS
731     // =============================================================
732 
733     /**
734      * @dev Returns the total number of tokens in existence.
735      * Burned tokens will reduce the count.
736      * To get the total number of tokens minted, please see {_totalMinted}.
737      */
738     function totalSupply() external view returns (uint256);
739 
740     // =============================================================
741     //                            IERC165
742     // =============================================================
743 
744     /**
745      * @dev Returns true if this contract implements the interface defined by
746      * `interfaceId`. See the corresponding
747      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
748      * to learn more about how these ids are created.
749      *
750      * This function call must use less than 30000 gas.
751      */
752     function supportsInterface(bytes4 interfaceId) external view returns (bool);
753 
754     // =============================================================
755     //                            IERC721
756     // =============================================================
757 
758     /**
759      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
760      */
761     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
762 
763     /**
764      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
765      */
766     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
767 
768     /**
769      * @dev Emitted when `owner` enables or disables
770      * (`approved`) `operator` to manage all of its assets.
771      */
772     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
773 
774     /**
775      * @dev Returns the number of tokens in `owner`'s account.
776      */
777     function balanceOf(address owner) external view returns (uint256 balance);
778 
779     /**
780      * @dev Returns the owner of the `tokenId` token.
781      *
782      * Requirements:
783      *
784      * - `tokenId` must exist.
785      */
786     function ownerOf(uint256 tokenId) external view returns (address owner);
787 
788     /**
789      * @dev Safely transfers `tokenId` token from `from` to `to`,
790      * checking first that contract recipients are aware of the ERC721 protocol
791      * to prevent tokens from being forever locked.
792      *
793      * Requirements:
794      *
795      * - `from` cannot be the zero address.
796      * - `to` cannot be the zero address.
797      * - `tokenId` token must exist and be owned by `from`.
798      * - If the caller is not `from`, it must be have been allowed to move
799      * this token by either {approve} or {setApprovalForAll}.
800      * - If `to` refers to a smart contract, it must implement
801      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
802      *
803      * Emits a {Transfer} event.
804      */
805     function safeTransferFrom(
806         address from,
807         address to,
808         uint256 tokenId,
809         bytes calldata data
810     ) external;
811 
812     /**
813      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
814      */
815     function safeTransferFrom(
816         address from,
817         address to,
818         uint256 tokenId
819     ) external;
820 
821     /**
822      * @dev Transfers `tokenId` from `from` to `to`.
823      *
824      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
825      * whenever possible.
826      *
827      * Requirements:
828      *
829      * - `from` cannot be the zero address.
830      * - `to` cannot be the zero address.
831      * - `tokenId` token must be owned by `from`.
832      * - If the caller is not `from`, it must be approved to move this token
833      * by either {approve} or {setApprovalForAll}.
834      *
835      * Emits a {Transfer} event.
836      */
837     function transferFrom(
838         address from,
839         address to,
840         uint256 tokenId
841     ) external;
842 
843     /**
844      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
845      * The approval is cleared when the token is transferred.
846      *
847      * Only a single account can be approved at a time, so approving the
848      * zero address clears previous approvals.
849      *
850      * Requirements:
851      *
852      * - The caller must own the token or be an approved operator.
853      * - `tokenId` must exist.
854      *
855      * Emits an {Approval} event.
856      */
857     function approve(address to, uint256 tokenId) external;
858 
859     /**
860      * @dev Approve or remove `operator` as an operator for the caller.
861      * Operators can call {transferFrom} or {safeTransferFrom}
862      * for any token owned by the caller.
863      *
864      * Requirements:
865      *
866      * - The `operator` cannot be the caller.
867      *
868      * Emits an {ApprovalForAll} event.
869      */
870     function setApprovalForAll(address operator, bool _approved) external;
871 
872     /**
873      * @dev Returns the account approved for `tokenId` token.
874      *
875      * Requirements:
876      *
877      * - `tokenId` must exist.
878      */
879     function getApproved(uint256 tokenId) external view returns (address operator);
880 
881     /**
882      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
883      *
884      * See {setApprovalForAll}.
885      */
886     function isApprovedForAll(address owner, address operator) external view returns (bool);
887 
888     // =============================================================
889     //                        IERC721Metadata
890     // =============================================================
891 
892     /**
893      * @dev Returns the token collection name.
894      */
895     function name() external view returns (string memory);
896 
897     /**
898      * @dev Returns the token collection symbol.
899      */
900     function symbol() external view returns (string memory);
901 
902     /**
903      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
904      */
905     function tokenURI(uint256 tokenId) external view returns (string memory);
906 
907     // =============================================================
908     //                           IERC2309
909     // =============================================================
910 
911     /**
912      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
913      * (inclusive) is transferred from `from` to `to`, as defined in the
914      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
915      *
916      * See {_mintERC2309} for more details.
917      */
918     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
919 }
920 
921 // File: erc721a/contracts/ERC721A.sol
922 
923 
924 // ERC721A Contracts v4.2.0
925 // Creator: Chiru Labs
926 
927 pragma solidity ^0.8.4;
928 
929 
930 /**
931  * @dev Interface of ERC721 token receiver.
932  */
933 interface ERC721A__IERC721Receiver {
934     function onERC721Received(
935         address operator,
936         address from,
937         uint256 tokenId,
938         bytes calldata data
939     ) external returns (bytes4);
940 }
941 
942 /**
943  * @title ERC721A
944  *
945  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
946  * Non-Fungible Token Standard, including the Metadata extension.
947  * Optimized for lower gas during batch mints.
948  *
949  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
950  * starting from `_startTokenId()`.
951  *
952  * Assumptions:
953  *
954  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
955  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
956  */
957 contract ERC721A is IERC721A {
958     // Reference type for token approval.
959     struct TokenApprovalRef {
960         address value;
961     }
962 
963     // =============================================================
964     //                           CONSTANTS
965     // =============================================================
966 
967     // Mask of an entry in packed address data.
968     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
969 
970     // The bit position of `numberMinted` in packed address data.
971     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
972 
973     // The bit position of `numberBurned` in packed address data.
974     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
975 
976     // The bit position of `aux` in packed address data.
977     uint256 private constant _BITPOS_AUX = 192;
978 
979     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
980     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
981 
982     // The bit position of `startTimestamp` in packed ownership.
983     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
984 
985     // The bit mask of the `burned` bit in packed ownership.
986     uint256 private constant _BITMASK_BURNED = 1 << 224;
987 
988     // The bit position of the `nextInitialized` bit in packed ownership.
989     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
990 
991     // The bit mask of the `nextInitialized` bit in packed ownership.
992     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
993 
994     // The bit position of `extraData` in packed ownership.
995     uint256 private constant _BITPOS_EXTRA_DATA = 232;
996 
997     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
998     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
999 
1000     // The mask of the lower 160 bits for addresses.
1001     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1002 
1003     // The maximum `quantity` that can be minted with {_mintERC2309}.
1004     // This limit is to prevent overflows on the address data entries.
1005     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1006     // is required to cause an overflow, which is unrealistic.
1007     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1008 
1009     // The `Transfer` event signature is given by:
1010     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1011     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1012         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1013 
1014     // =============================================================
1015     //                            STORAGE
1016     // =============================================================
1017 
1018     // The next token ID to be minted.
1019     uint256 private _currentIndex;
1020 
1021     // The number of tokens burned.
1022     uint256 private _burnCounter;
1023 
1024     // Token name
1025     string private _name;
1026 
1027     // Token symbol
1028     string private _symbol;
1029 
1030     // Mapping from token ID to ownership details
1031     // An empty struct value does not necessarily mean the token is unowned.
1032     // See {_packedOwnershipOf} implementation for details.
1033     //
1034     // Bits Layout:
1035     // - [0..159]   `addr`
1036     // - [160..223] `startTimestamp`
1037     // - [224]      `burned`
1038     // - [225]      `nextInitialized`
1039     // - [232..255] `extraData`
1040     mapping(uint256 => uint256) private _packedOwnerships;
1041 
1042     // Mapping owner address to address data.
1043     //
1044     // Bits Layout:
1045     // - [0..63]    `balance`
1046     // - [64..127]  `numberMinted`
1047     // - [128..191] `numberBurned`
1048     // - [192..255] `aux`
1049     mapping(address => uint256) private _packedAddressData;
1050 
1051     // Mapping from token ID to approved address.
1052     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1053 
1054     // Mapping from owner to operator approvals
1055     mapping(address => mapping(address => bool)) private _operatorApprovals;
1056 
1057     // =============================================================
1058     //                          CONSTRUCTOR
1059     // =============================================================
1060 
1061     constructor(string memory name_, string memory symbol_) {
1062         _name = name_;
1063         _symbol = symbol_;
1064         _currentIndex = _startTokenId();
1065     }
1066 
1067     // =============================================================
1068     //                   TOKEN COUNTING OPERATIONS
1069     // =============================================================
1070 
1071     /**
1072      * @dev Returns the starting token ID.
1073      * To change the starting token ID, please override this function.
1074      */
1075     function _startTokenId() internal view virtual returns (uint256) {
1076         return 0;
1077     }
1078 
1079     /**
1080      * @dev Returns the next token ID to be minted.
1081      */
1082     function _nextTokenId() internal view virtual returns (uint256) {
1083         return _currentIndex;
1084     }
1085 
1086     /**
1087      * @dev Returns the total number of tokens in existence.
1088      * Burned tokens will reduce the count.
1089      * To get the total number of tokens minted, please see {_totalMinted}.
1090      */
1091     function totalSupply() public view virtual override returns (uint256) {
1092         // Counter underflow is impossible as _burnCounter cannot be incremented
1093         // more than `_currentIndex - _startTokenId()` times.
1094         unchecked {
1095             return _currentIndex - _burnCounter - _startTokenId();
1096         }
1097     }
1098 
1099     /**
1100      * @dev Returns the total amount of tokens minted in the contract.
1101      */
1102     function _totalMinted() internal view virtual returns (uint256) {
1103         // Counter underflow is impossible as `_currentIndex` does not decrement,
1104         // and it is initialized to `_startTokenId()`.
1105         unchecked {
1106             return _currentIndex - _startTokenId();
1107         }
1108     }
1109 
1110     /**
1111      * @dev Returns the total number of tokens burned.
1112      */
1113     function _totalBurned() internal view virtual returns (uint256) {
1114         return _burnCounter;
1115     }
1116 
1117     // =============================================================
1118     //                    ADDRESS DATA OPERATIONS
1119     // =============================================================
1120 
1121     /**
1122      * @dev Returns the number of tokens in `owner`'s account.
1123      */
1124     function balanceOf(address owner) public view virtual override returns (uint256) {
1125         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1126         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1127     }
1128 
1129     /**
1130      * Returns the number of tokens minted by `owner`.
1131      */
1132     function _numberMinted(address owner) internal view returns (uint256) {
1133         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1134     }
1135 
1136     /**
1137      * Returns the number of tokens burned by or on behalf of `owner`.
1138      */
1139     function _numberBurned(address owner) internal view returns (uint256) {
1140         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1141     }
1142 
1143     /**
1144      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1145      */
1146     function _getAux(address owner) internal view returns (uint64) {
1147         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1148     }
1149 
1150     /**
1151      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1152      * If there are multiple variables, please pack them into a uint64.
1153      */
1154     function _setAux(address owner, uint64 aux) internal virtual {
1155         uint256 packed = _packedAddressData[owner];
1156         uint256 auxCasted;
1157         // Cast `aux` with assembly to avoid redundant masking.
1158         assembly {
1159             auxCasted := aux
1160         }
1161         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1162         _packedAddressData[owner] = packed;
1163     }
1164 
1165     // =============================================================
1166     //                            IERC165
1167     // =============================================================
1168 
1169     /**
1170      * @dev Returns true if this contract implements the interface defined by
1171      * `interfaceId`. See the corresponding
1172      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1173      * to learn more about how these ids are created.
1174      *
1175      * This function call must use less than 30000 gas.
1176      */
1177     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1178         // The interface IDs are constants representing the first 4 bytes
1179         // of the XOR of all function selectors in the interface.
1180         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1181         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1182         return
1183             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1184             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1185             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1186     }
1187 
1188     // =============================================================
1189     //                        IERC721Metadata
1190     // =============================================================
1191 
1192     /**
1193      * @dev Returns the token collection name.
1194      */
1195     function name() public view virtual override returns (string memory) {
1196         return _name;
1197     }
1198 
1199     /**
1200      * @dev Returns the token collection symbol.
1201      */
1202     function symbol() public view virtual override returns (string memory) {
1203         return _symbol;
1204     }
1205 
1206     /**
1207      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1208      */
1209     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1210         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1211 
1212         string memory baseURI = _baseURI();
1213         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1214     }
1215 
1216     /**
1217      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1218      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1219      * by default, it can be overridden in child contracts.
1220      */
1221     function _baseURI() internal view virtual returns (string memory) {
1222         return '';
1223     }
1224 
1225     // =============================================================
1226     //                     OWNERSHIPS OPERATIONS
1227     // =============================================================
1228 
1229     /**
1230      * @dev Returns the owner of the `tokenId` token.
1231      *
1232      * Requirements:
1233      *
1234      * - `tokenId` must exist.
1235      */
1236     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1237         return address(uint160(_packedOwnershipOf(tokenId)));
1238     }
1239 
1240     /**
1241      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1242      * It gradually moves to O(1) as tokens get transferred around over time.
1243      */
1244     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1245         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1246     }
1247 
1248     /**
1249      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1250      */
1251     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1252         return _unpackedOwnership(_packedOwnerships[index]);
1253     }
1254 
1255     /**
1256      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1257      */
1258     function _initializeOwnershipAt(uint256 index) internal virtual {
1259         if (_packedOwnerships[index] == 0) {
1260             _packedOwnerships[index] = _packedOwnershipOf(index);
1261         }
1262     }
1263 
1264     /**
1265      * Returns the packed ownership data of `tokenId`.
1266      */
1267     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1268         uint256 curr = tokenId;
1269 
1270         unchecked {
1271             if (_startTokenId() <= curr)
1272                 if (curr < _currentIndex) {
1273                     uint256 packed = _packedOwnerships[curr];
1274                     // If not burned.
1275                     if (packed & _BITMASK_BURNED == 0) {
1276                         // Invariant:
1277                         // There will always be an initialized ownership slot
1278                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1279                         // before an unintialized ownership slot
1280                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1281                         // Hence, `curr` will not underflow.
1282                         //
1283                         // We can directly compare the packed value.
1284                         // If the address is zero, packed will be zero.
1285                         while (packed == 0) {
1286                             packed = _packedOwnerships[--curr];
1287                         }
1288                         return packed;
1289                     }
1290                 }
1291         }
1292         revert OwnerQueryForNonexistentToken();
1293     }
1294 
1295     /**
1296      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1297      */
1298     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1299         ownership.addr = address(uint160(packed));
1300         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1301         ownership.burned = packed & _BITMASK_BURNED != 0;
1302         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1303     }
1304 
1305     /**
1306      * @dev Packs ownership data into a single uint256.
1307      */
1308     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1309         assembly {
1310             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1311             owner := and(owner, _BITMASK_ADDRESS)
1312             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1313             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1314         }
1315     }
1316 
1317     /**
1318      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1319      */
1320     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1321         // For branchless setting of the `nextInitialized` flag.
1322         assembly {
1323             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1324             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1325         }
1326     }
1327 
1328     // =============================================================
1329     //                      APPROVAL OPERATIONS
1330     // =============================================================
1331 
1332     /**
1333      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1334      * The approval is cleared when the token is transferred.
1335      *
1336      * Only a single account can be approved at a time, so approving the
1337      * zero address clears previous approvals.
1338      *
1339      * Requirements:
1340      *
1341      * - The caller must own the token or be an approved operator.
1342      * - `tokenId` must exist.
1343      *
1344      * Emits an {Approval} event.
1345      */
1346     function approve(address to, uint256 tokenId) public virtual override {
1347         address owner = ownerOf(tokenId);
1348 
1349         if (_msgSenderERC721A() != owner)
1350             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1351                 revert ApprovalCallerNotOwnerNorApproved();
1352             }
1353 
1354         _tokenApprovals[tokenId].value = to;
1355         emit Approval(owner, to, tokenId);
1356     }
1357 
1358     /**
1359      * @dev Returns the account approved for `tokenId` token.
1360      *
1361      * Requirements:
1362      *
1363      * - `tokenId` must exist.
1364      */
1365     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1366         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1367 
1368         return _tokenApprovals[tokenId].value;
1369     }
1370 
1371     /**
1372      * @dev Approve or remove `operator` as an operator for the caller.
1373      * Operators can call {transferFrom} or {safeTransferFrom}
1374      * for any token owned by the caller.
1375      *
1376      * Requirements:
1377      *
1378      * - The `operator` cannot be the caller.
1379      *
1380      * Emits an {ApprovalForAll} event.
1381      */
1382     function setApprovalForAll(address operator, bool approved) public virtual override {
1383         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1384 
1385         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1386         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1387     }
1388 
1389     /**
1390      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1391      *
1392      * See {setApprovalForAll}.
1393      */
1394     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1395         return _operatorApprovals[owner][operator];
1396     }
1397 
1398     /**
1399      * @dev Returns whether `tokenId` exists.
1400      *
1401      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1402      *
1403      * Tokens start existing when they are minted. See {_mint}.
1404      */
1405     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1406         return
1407             _startTokenId() <= tokenId &&
1408             tokenId < _currentIndex && // If within bounds,
1409             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1410     }
1411 
1412     /**
1413      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1414      */
1415     function _isSenderApprovedOrOwner(
1416         address approvedAddress,
1417         address owner,
1418         address msgSender
1419     ) private pure returns (bool result) {
1420         assembly {
1421             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1422             owner := and(owner, _BITMASK_ADDRESS)
1423             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1424             msgSender := and(msgSender, _BITMASK_ADDRESS)
1425             // `msgSender == owner || msgSender == approvedAddress`.
1426             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1427         }
1428     }
1429 
1430     /**
1431      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1432      */
1433     function _getApprovedSlotAndAddress(uint256 tokenId)
1434         private
1435         view
1436         returns (uint256 approvedAddressSlot, address approvedAddress)
1437     {
1438         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1439         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1440         assembly {
1441             approvedAddressSlot := tokenApproval.slot
1442             approvedAddress := sload(approvedAddressSlot)
1443         }
1444     }
1445 
1446     // =============================================================
1447     //                      TRANSFER OPERATIONS
1448     // =============================================================
1449 
1450     /**
1451      * @dev Transfers `tokenId` from `from` to `to`.
1452      *
1453      * Requirements:
1454      *
1455      * - `from` cannot be the zero address.
1456      * - `to` cannot be the zero address.
1457      * - `tokenId` token must be owned by `from`.
1458      * - If the caller is not `from`, it must be approved to move this token
1459      * by either {approve} or {setApprovalForAll}.
1460      *
1461      * Emits a {Transfer} event.
1462      */
1463     function transferFrom(
1464         address from,
1465         address to,
1466         uint256 tokenId
1467     ) public virtual override {
1468         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1469 
1470         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1471 
1472         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1473 
1474         // The nested ifs save around 20+ gas over a compound boolean condition.
1475         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1476             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1477 
1478         if (to == address(0)) revert TransferToZeroAddress();
1479 
1480         _beforeTokenTransfers(from, to, tokenId, 1);
1481 
1482         // Clear approvals from the previous owner.
1483         assembly {
1484             if approvedAddress {
1485                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1486                 sstore(approvedAddressSlot, 0)
1487             }
1488         }
1489 
1490         // Underflow of the sender's balance is impossible because we check for
1491         // ownership above and the recipient's balance can't realistically overflow.
1492         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1493         unchecked {
1494             // We can directly increment and decrement the balances.
1495             --_packedAddressData[from]; // Updates: `balance -= 1`.
1496             ++_packedAddressData[to]; // Updates: `balance += 1`.
1497 
1498             // Updates:
1499             // - `address` to the next owner.
1500             // - `startTimestamp` to the timestamp of transfering.
1501             // - `burned` to `false`.
1502             // - `nextInitialized` to `true`.
1503             _packedOwnerships[tokenId] = _packOwnershipData(
1504                 to,
1505                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1506             );
1507 
1508             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1509             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1510                 uint256 nextTokenId = tokenId + 1;
1511                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1512                 if (_packedOwnerships[nextTokenId] == 0) {
1513                     // If the next slot is within bounds.
1514                     if (nextTokenId != _currentIndex) {
1515                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1516                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1517                     }
1518                 }
1519             }
1520         }
1521 
1522         emit Transfer(from, to, tokenId);
1523         _afterTokenTransfers(from, to, tokenId, 1);
1524     }
1525 
1526     /**
1527      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1528      */
1529     function safeTransferFrom(
1530         address from,
1531         address to,
1532         uint256 tokenId
1533     ) public virtual override {
1534         safeTransferFrom(from, to, tokenId, '');
1535     }
1536 
1537     /**
1538      * @dev Safely transfers `tokenId` token from `from` to `to`.
1539      *
1540      * Requirements:
1541      *
1542      * - `from` cannot be the zero address.
1543      * - `to` cannot be the zero address.
1544      * - `tokenId` token must exist and be owned by `from`.
1545      * - If the caller is not `from`, it must be approved to move this token
1546      * by either {approve} or {setApprovalForAll}.
1547      * - If `to` refers to a smart contract, it must implement
1548      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1549      *
1550      * Emits a {Transfer} event.
1551      */
1552     function safeTransferFrom(
1553         address from,
1554         address to,
1555         uint256 tokenId,
1556         bytes memory _data
1557     ) public virtual override {
1558         transferFrom(from, to, tokenId);
1559         if (to.code.length != 0)
1560             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1561                 revert TransferToNonERC721ReceiverImplementer();
1562             }
1563     }
1564 
1565     /**
1566      * @dev Hook that is called before a set of serially-ordered token IDs
1567      * are about to be transferred. This includes minting.
1568      * And also called before burning one token.
1569      *
1570      * `startTokenId` - the first token ID to be transferred.
1571      * `quantity` - the amount to be transferred.
1572      *
1573      * Calling conditions:
1574      *
1575      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1576      * transferred to `to`.
1577      * - When `from` is zero, `tokenId` will be minted for `to`.
1578      * - When `to` is zero, `tokenId` will be burned by `from`.
1579      * - `from` and `to` are never both zero.
1580      */
1581     function _beforeTokenTransfers(
1582         address from,
1583         address to,
1584         uint256 startTokenId,
1585         uint256 quantity
1586     ) internal virtual {}
1587 
1588     /**
1589      * @dev Hook that is called after a set of serially-ordered token IDs
1590      * have been transferred. This includes minting.
1591      * And also called after one token has been burned.
1592      *
1593      * `startTokenId` - the first token ID to be transferred.
1594      * `quantity` - the amount to be transferred.
1595      *
1596      * Calling conditions:
1597      *
1598      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1599      * transferred to `to`.
1600      * - When `from` is zero, `tokenId` has been minted for `to`.
1601      * - When `to` is zero, `tokenId` has been burned by `from`.
1602      * - `from` and `to` are never both zero.
1603      */
1604     function _afterTokenTransfers(
1605         address from,
1606         address to,
1607         uint256 startTokenId,
1608         uint256 quantity
1609     ) internal virtual {}
1610 
1611     /**
1612      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1613      *
1614      * `from` - Previous owner of the given token ID.
1615      * `to` - Target address that will receive the token.
1616      * `tokenId` - Token ID to be transferred.
1617      * `_data` - Optional data to send along with the call.
1618      *
1619      * Returns whether the call correctly returned the expected magic value.
1620      */
1621     function _checkContractOnERC721Received(
1622         address from,
1623         address to,
1624         uint256 tokenId,
1625         bytes memory _data
1626     ) private returns (bool) {
1627         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1628             bytes4 retval
1629         ) {
1630             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1631         } catch (bytes memory reason) {
1632             if (reason.length == 0) {
1633                 revert TransferToNonERC721ReceiverImplementer();
1634             } else {
1635                 assembly {
1636                     revert(add(32, reason), mload(reason))
1637                 }
1638             }
1639         }
1640     }
1641 
1642     // =============================================================
1643     //                        MINT OPERATIONS
1644     // =============================================================
1645 
1646     /**
1647      * @dev Mints `quantity` tokens and transfers them to `to`.
1648      *
1649      * Requirements:
1650      *
1651      * - `to` cannot be the zero address.
1652      * - `quantity` must be greater than 0.
1653      *
1654      * Emits a {Transfer} event for each mint.
1655      */
1656     function _mint(address to, uint256 quantity) internal virtual {
1657         uint256 startTokenId = _currentIndex;
1658         if (quantity == 0) revert MintZeroQuantity();
1659 
1660         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1661 
1662         // Overflows are incredibly unrealistic.
1663         // `balance` and `numberMinted` have a maximum limit of 2**64.
1664         // `tokenId` has a maximum limit of 2**256.
1665         unchecked {
1666             // Updates:
1667             // - `balance += quantity`.
1668             // - `numberMinted += quantity`.
1669             //
1670             // We can directly add to the `balance` and `numberMinted`.
1671             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1672 
1673             // Updates:
1674             // - `address` to the owner.
1675             // - `startTimestamp` to the timestamp of minting.
1676             // - `burned` to `false`.
1677             // - `nextInitialized` to `quantity == 1`.
1678             _packedOwnerships[startTokenId] = _packOwnershipData(
1679                 to,
1680                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1681             );
1682 
1683             uint256 toMasked;
1684             uint256 end = startTokenId + quantity;
1685 
1686             // Use assembly to loop and emit the `Transfer` event for gas savings.
1687             assembly {
1688                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1689                 toMasked := and(to, _BITMASK_ADDRESS)
1690                 // Emit the `Transfer` event.
1691                 log4(
1692                     0, // Start of data (0, since no data).
1693                     0, // End of data (0, since no data).
1694                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1695                     0, // `address(0)`.
1696                     toMasked, // `to`.
1697                     startTokenId // `tokenId`.
1698                 )
1699 
1700                 for {
1701                     let tokenId := add(startTokenId, 1)
1702                 } iszero(eq(tokenId, end)) {
1703                     tokenId := add(tokenId, 1)
1704                 } {
1705                     // Emit the `Transfer` event. Similar to above.
1706                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1707                 }
1708             }
1709             if (toMasked == 0) revert MintToZeroAddress();
1710 
1711             _currentIndex = end;
1712         }
1713         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1714     }
1715 
1716     /**
1717      * @dev Mints `quantity` tokens and transfers them to `to`.
1718      *
1719      * This function is intended for efficient minting only during contract creation.
1720      *
1721      * It emits only one {ConsecutiveTransfer} as defined in
1722      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1723      * instead of a sequence of {Transfer} event(s).
1724      *
1725      * Calling this function outside of contract creation WILL make your contract
1726      * non-compliant with the ERC721 standard.
1727      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1728      * {ConsecutiveTransfer} event is only permissible during contract creation.
1729      *
1730      * Requirements:
1731      *
1732      * - `to` cannot be the zero address.
1733      * - `quantity` must be greater than 0.
1734      *
1735      * Emits a {ConsecutiveTransfer} event.
1736      */
1737     function _mintERC2309(address to, uint256 quantity) internal virtual {
1738         uint256 startTokenId = _currentIndex;
1739         if (to == address(0)) revert MintToZeroAddress();
1740         if (quantity == 0) revert MintZeroQuantity();
1741         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1742 
1743         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1744 
1745         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1746         unchecked {
1747             // Updates:
1748             // - `balance += quantity`.
1749             // - `numberMinted += quantity`.
1750             //
1751             // We can directly add to the `balance` and `numberMinted`.
1752             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1753 
1754             // Updates:
1755             // - `address` to the owner.
1756             // - `startTimestamp` to the timestamp of minting.
1757             // - `burned` to `false`.
1758             // - `nextInitialized` to `quantity == 1`.
1759             _packedOwnerships[startTokenId] = _packOwnershipData(
1760                 to,
1761                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1762             );
1763 
1764             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1765 
1766             _currentIndex = startTokenId + quantity;
1767         }
1768         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1769     }
1770 
1771     /**
1772      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1773      *
1774      * Requirements:
1775      *
1776      * - If `to` refers to a smart contract, it must implement
1777      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1778      * - `quantity` must be greater than 0.
1779      *
1780      * See {_mint}.
1781      *
1782      * Emits a {Transfer} event for each mint.
1783      */
1784     function _safeMint(
1785         address to,
1786         uint256 quantity,
1787         bytes memory _data
1788     ) internal virtual {
1789         _mint(to, quantity);
1790 
1791         unchecked {
1792             if (to.code.length != 0) {
1793                 uint256 end = _currentIndex;
1794                 uint256 index = end - quantity;
1795                 do {
1796                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1797                         revert TransferToNonERC721ReceiverImplementer();
1798                     }
1799                 } while (index < end);
1800                 // Reentrancy protection.
1801                 if (_currentIndex != end) revert();
1802             }
1803         }
1804     }
1805 
1806     /**
1807      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1808      */
1809     function _safeMint(address to, uint256 quantity) internal virtual {
1810         _safeMint(to, quantity, '');
1811     }
1812 
1813     // =============================================================
1814     //                        BURN OPERATIONS
1815     // =============================================================
1816 
1817     /**
1818      * @dev Equivalent to `_burn(tokenId, false)`.
1819      */
1820     function _burn(uint256 tokenId) internal virtual {
1821         _burn(tokenId, false);
1822     }
1823 
1824     /**
1825      * @dev Destroys `tokenId`.
1826      * The approval is cleared when the token is burned.
1827      *
1828      * Requirements:
1829      *
1830      * - `tokenId` must exist.
1831      *
1832      * Emits a {Transfer} event.
1833      */
1834     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1835         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1836 
1837         address from = address(uint160(prevOwnershipPacked));
1838 
1839         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1840 
1841         if (approvalCheck) {
1842             // The nested ifs save around 20+ gas over a compound boolean condition.
1843             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1844                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1845         }
1846 
1847         _beforeTokenTransfers(from, address(0), tokenId, 1);
1848 
1849         // Clear approvals from the previous owner.
1850         assembly {
1851             if approvedAddress {
1852                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1853                 sstore(approvedAddressSlot, 0)
1854             }
1855         }
1856 
1857         // Underflow of the sender's balance is impossible because we check for
1858         // ownership above and the recipient's balance can't realistically overflow.
1859         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1860         unchecked {
1861             // Updates:
1862             // - `balance -= 1`.
1863             // - `numberBurned += 1`.
1864             //
1865             // We can directly decrement the balance, and increment the number burned.
1866             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1867             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1868 
1869             // Updates:
1870             // - `address` to the last owner.
1871             // - `startTimestamp` to the timestamp of burning.
1872             // - `burned` to `true`.
1873             // - `nextInitialized` to `true`.
1874             _packedOwnerships[tokenId] = _packOwnershipData(
1875                 from,
1876                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1877             );
1878 
1879             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1880             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1881                 uint256 nextTokenId = tokenId + 1;
1882                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1883                 if (_packedOwnerships[nextTokenId] == 0) {
1884                     // If the next slot is within bounds.
1885                     if (nextTokenId != _currentIndex) {
1886                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1887                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1888                     }
1889                 }
1890             }
1891         }
1892 
1893         emit Transfer(from, address(0), tokenId);
1894         _afterTokenTransfers(from, address(0), tokenId, 1);
1895 
1896         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1897         unchecked {
1898             _burnCounter++;
1899         }
1900     }
1901 
1902     // =============================================================
1903     //                     EXTRA DATA OPERATIONS
1904     // =============================================================
1905 
1906     /**
1907      * @dev Directly sets the extra data for the ownership data `index`.
1908      */
1909     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1910         uint256 packed = _packedOwnerships[index];
1911         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1912         uint256 extraDataCasted;
1913         // Cast `extraData` with assembly to avoid redundant masking.
1914         assembly {
1915             extraDataCasted := extraData
1916         }
1917         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1918         _packedOwnerships[index] = packed;
1919     }
1920 
1921     /**
1922      * @dev Called during each token transfer to set the 24bit `extraData` field.
1923      * Intended to be overridden by the cosumer contract.
1924      *
1925      * `previousExtraData` - the value of `extraData` before transfer.
1926      *
1927      * Calling conditions:
1928      *
1929      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1930      * transferred to `to`.
1931      * - When `from` is zero, `tokenId` will be minted for `to`.
1932      * - When `to` is zero, `tokenId` will be burned by `from`.
1933      * - `from` and `to` are never both zero.
1934      */
1935     function _extraData(
1936         address from,
1937         address to,
1938         uint24 previousExtraData
1939     ) internal view virtual returns (uint24) {}
1940 
1941     /**
1942      * @dev Returns the next extra data for the packed ownership data.
1943      * The returned result is shifted into position.
1944      */
1945     function _nextExtraData(
1946         address from,
1947         address to,
1948         uint256 prevOwnershipPacked
1949     ) private view returns (uint256) {
1950         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1951         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1952     }
1953 
1954     // =============================================================
1955     //                       OTHER OPERATIONS
1956     // =============================================================
1957 
1958     /**
1959      * @dev Returns the message sender (defaults to `msg.sender`).
1960      *
1961      * If you are writing GSN compatible contracts, you need to override this function.
1962      */
1963     function _msgSenderERC721A() internal view virtual returns (address) {
1964         return msg.sender;
1965     }
1966 
1967     /**
1968      * @dev Converts a uint256 to its ASCII string decimal representation.
1969      */
1970     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
1971         assembly {
1972             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1973             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1974             // We will need 1 32-byte word to store the length,
1975             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1976             ptr := add(mload(0x40), 128)
1977             // Update the free memory pointer to allocate.
1978             mstore(0x40, ptr)
1979 
1980             // Cache the end of the memory to calculate the length later.
1981             let end := ptr
1982 
1983             // We write the string from the rightmost digit to the leftmost digit.
1984             // The following is essentially a do-while loop that also handles the zero case.
1985             // Costs a bit more than early returning for the zero case,
1986             // but cheaper in terms of deployment and overall runtime costs.
1987             for {
1988                 // Initialize and perform the first pass without check.
1989                 let temp := value
1990                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1991                 ptr := sub(ptr, 1)
1992                 // Write the character to the pointer.
1993                 // The ASCII index of the '0' character is 48.
1994                 mstore8(ptr, add(48, mod(temp, 10)))
1995                 temp := div(temp, 10)
1996             } temp {
1997                 // Keep dividing `temp` until zero.
1998                 temp := div(temp, 10)
1999             } {
2000                 // Body of the for loop.
2001                 ptr := sub(ptr, 1)
2002                 mstore8(ptr, add(48, mod(temp, 10)))
2003             }
2004 
2005             let length := sub(end, ptr)
2006             // Move the pointer 32 bytes leftwards to make room for the length.
2007             ptr := sub(ptr, 32)
2008             // Store the length.
2009             mstore(ptr, length)
2010         }
2011     }
2012 }
2013 
2014 // File: contracts/UW.sol
2015 
2016 
2017 
2018 
2019 
2020 
2021 
2022 
2023 pragma solidity ^0.8.0;
2024 
2025 contract UW is ERC721A, Ownable {
2026     using Address for address;
2027     using Strings for uint256;
2028 
2029     // URI variables in IPFS
2030     string private uriPrefix = "";
2031     string private uriSuffix = ".json";
2032     string public hiddenMetadataUri;
2033 
2034     // Initializing variables
2035     uint256 public whitelistPrice = 0.02 ether; 
2036     uint256 public publicPrice = 0.03 ether; 
2037     uint256 public maxSupply = 2500;
2038     uint256 public maxMintAmountWhitelist = 10;
2039     uint256 public maxMintAmountPublic = 25;
2040     mapping(address => uint256) public allowlistCount; 
2041 
2042     // Initialized as paused and not revealed.
2043     bool public paused = true;
2044     bool public revealed = false;
2045     uint32 public publicSaleStartTime;
2046     uint32 public whitelistSaleStartTime;
2047 
2048     bytes32 private whitelistMerkleRoot;
2049     constructor() ERC721A("The Underworld", "UDW") {
2050         // set hidden uri from IPFS
2051         setHiddenMetadataUri("ipfs://QmNVFkrsLQtmF252kAXPKKh8csiERS6hbKy7V7smyVcbYJ/Hidden.json");
2052 
2053         // public launch time, update to prevent botting
2054         setPublicSaleStartTime(1661094000);
2055         setWhitelistSaleStartTime(1661007600);
2056         
2057         // held back on contract launch for team
2058         _safeMint(msg.sender, 200);    
2059     }
2060 
2061     // checkes total supply does not exceed max supply and contract not paused
2062     modifier mintCompliance(uint256 _mintAmount) {
2063         require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
2064         require(!paused, "NFT is not available for mint");
2065         _;
2066     }
2067 
2068     // general mint
2069     function publicMint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
2070         require(isPublicSaleOn() == true, "Public sale has not begun yet");
2071         require(_mintAmount > 0 && _numberMinted(msg.sender) + _mintAmount - allowlistCount[msg.sender] <= maxMintAmountPublic, "Invalid mint amount!");
2072         require(msg.value >= publicPrice * _mintAmount, "Insufficient funds!");
2073         _safeMint(msg.sender, _mintAmount);
2074         refundIfOver(publicPrice * _mintAmount);
2075     }
2076 
2077     // allowlist Mint
2078     function allowlistMint(bytes32[] calldata merkleProof, uint256 _mintAmount) public payable mintCompliance(_mintAmount) isValidMerkleProof(merkleProof, whitelistMerkleRoot){
2079         require(isWhitelistSaleOn() == true, "Whitelist sale has not begun yet");
2080         require(_mintAmount > 0 && _numberMinted(msg.sender) + _mintAmount <= maxMintAmountWhitelist, "Invalid mint amount!");
2081         require(msg.value >= whitelistPrice * _mintAmount, "Insufficient funds!");
2082         allowlistCount[msg.sender]+=_mintAmount;
2083         _safeMint(msg.sender, _mintAmount);
2084         refundIfOver(whitelistPrice * _mintAmount);
2085     }
2086 
2087     // set whitelist merkleroot node
2088     function setWhitelistMerkleRoot(bytes32 merkleRoot) external onlyOwner {
2089         whitelistMerkleRoot = merkleRoot;
2090     }
2091 
2092     // verify merkle proof 
2093     modifier isValidMerkleProof(bytes32[] calldata merkleProof, bytes32 root) {
2094         require(MerkleProof.verify(
2095                 merkleProof,
2096                 root,
2097                 keccak256(abi.encodePacked(msg.sender))),
2098             "Address does not exist in list"
2099         );
2100         _;
2101     }
2102 
2103     // for dev minting etc
2104     function devMint(uint256 _mintAmount) external onlyOwner {
2105         require(totalSupply() + _mintAmount <= maxSupply, "Too many already minted before dev mint");
2106         _safeMint(msg.sender, _mintAmount);
2107         
2108     }
2109 
2110     // refund if value sent is more than price
2111     function refundIfOver(uint256 price) private {
2112         require(msg.value <= price, "Need to send more ETH.");
2113         if (msg.value > price) {
2114         payable(msg.sender).transfer(msg.value - price);
2115         }
2116     }
2117 
2118     // check if public sale is on
2119     function isPublicSaleOn() public view returns (bool) {
2120         return block.timestamp >= publicSaleStartTime;
2121     }
2122 
2123     // check if whitelist sale is on
2124     function isWhitelistSaleOn() public view returns (bool) {
2125         return block.timestamp >= whitelistSaleStartTime;
2126     }
2127 
2128     /* Setters and Getters */
2129     function setPublicPrice(uint32 _publicPrice) public onlyOwner{
2130         publicPrice = _publicPrice;
2131     }
2132 
2133     function setWhitelistPrice(uint32 _whitelistPrice) public onlyOwner{
2134         whitelistPrice = _whitelistPrice;
2135     }
2136     
2137     // set public sale start time
2138     function setPublicSaleStartTime(uint32 timestamp) public onlyOwner{
2139         publicSaleStartTime = timestamp;
2140     }
2141 
2142     // set whitelist sale start time
2143     function setWhitelistSaleStartTime(uint32 timestamp) public onlyOwner{
2144         whitelistSaleStartTime = timestamp;
2145     }
2146 
2147     // set whitelist max mint if needed
2148     function setMaxMintAmountWhitelist(uint32 _maxMintAmountWhitelist) public onlyOwner{
2149         maxMintAmountWhitelist = _maxMintAmountWhitelist;
2150     }
2151 
2152     // set public max mint if needed
2153     function setMaxMintAmountPublic(uint32 _maxMintAmountPublic) public onlyOwner{
2154         maxMintAmountPublic = _maxMintAmountPublic;
2155     }
2156 
2157     //  reveal 
2158     function toggleReveal() public onlyOwner {
2159         revealed = !revealed;
2160     }
2161     
2162     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
2163         hiddenMetadataUri = _hiddenMetadataUri;
2164     }
2165 
2166     function setMaxSupply(uint32 _maxSupply) public onlyOwner {
2167         maxSupply = _maxSupply;
2168     }
2169 
2170     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2171         uriPrefix = _uriPrefix;
2172     }
2173 
2174     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2175         uriSuffix = _uriSuffix;
2176     }
2177 
2178     function setPause(bool _state) public onlyOwner {
2179         paused = _state;
2180     }
2181 
2182     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2183         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2184         if (revealed == false) {
2185             return bytes(hiddenMetadataUri).length != 0 ? string(abi.encodePacked(hiddenMetadataUri)) : '';
2186         }
2187         string memory baseURI = _baseURI();
2188         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), uriSuffix)) : '';
2189     }
2190 
2191     function _baseURI() internal view virtual override returns (string memory) {
2192         return uriPrefix;
2193     }
2194 
2195     function withdraw() public payable onlyOwner {
2196         // This will payout the owner the contract balance.
2197         // Do not remove this otherwise you will not be able to withdraw the funds.
2198         // =============================================================================
2199         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
2200         require(os);
2201         // =============================================================================
2202     }
2203 }