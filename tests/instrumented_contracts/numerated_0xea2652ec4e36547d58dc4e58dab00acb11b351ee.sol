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
216 // File: @openzeppelin/contracts/utils/Counters.sol
217 
218 
219 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
220 
221 pragma solidity ^0.8.0;
222 
223 /**
224  * @title Counters
225  * @author Matt Condon (@shrugs)
226  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
227  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
228  *
229  * Include with `using Counters for Counters.Counter;`
230  */
231 library Counters {
232     struct Counter {
233         // This variable should never be directly accessed by users of the library: interactions must be restricted to
234         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
235         // this feature: see https://github.com/ethereum/solidity/issues/4637
236         uint256 _value; // default: 0
237     }
238 
239     function current(Counter storage counter) internal view returns (uint256) {
240         return counter._value;
241     }
242 
243     function increment(Counter storage counter) internal {
244         unchecked {
245             counter._value += 1;
246         }
247     }
248 
249     function decrement(Counter storage counter) internal {
250         uint256 value = counter._value;
251         require(value > 0, "Counter: decrement overflow");
252         unchecked {
253             counter._value = value - 1;
254         }
255     }
256 
257     function reset(Counter storage counter) internal {
258         counter._value = 0;
259     }
260 }
261 
262 // File: @openzeppelin/contracts/utils/Strings.sol
263 
264 
265 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
266 
267 pragma solidity ^0.8.0;
268 
269 /**
270  * @dev String operations.
271  */
272 library Strings {
273     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
274     uint8 private constant _ADDRESS_LENGTH = 20;
275 
276     /**
277      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
278      */
279     function toString(uint256 value) internal pure returns (string memory) {
280         // Inspired by OraclizeAPI's implementation - MIT licence
281         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
282 
283         if (value == 0) {
284             return "0";
285         }
286         uint256 temp = value;
287         uint256 digits;
288         while (temp != 0) {
289             digits++;
290             temp /= 10;
291         }
292         bytes memory buffer = new bytes(digits);
293         while (value != 0) {
294             digits -= 1;
295             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
296             value /= 10;
297         }
298         return string(buffer);
299     }
300 
301     /**
302      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
303      */
304     function toHexString(uint256 value) internal pure returns (string memory) {
305         if (value == 0) {
306             return "0x00";
307         }
308         uint256 temp = value;
309         uint256 length = 0;
310         while (temp != 0) {
311             length++;
312             temp >>= 8;
313         }
314         return toHexString(value, length);
315     }
316 
317     /**
318      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
319      */
320     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
321         bytes memory buffer = new bytes(2 * length + 2);
322         buffer[0] = "0";
323         buffer[1] = "x";
324         for (uint256 i = 2 * length + 1; i > 1; --i) {
325             buffer[i] = _HEX_SYMBOLS[value & 0xf];
326             value >>= 4;
327         }
328         require(value == 0, "Strings: hex length insufficient");
329         return string(buffer);
330     }
331 
332     /**
333      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
334      */
335     function toHexString(address addr) internal pure returns (string memory) {
336         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
337     }
338 }
339 
340 // File: @openzeppelin/contracts/utils/Context.sol
341 
342 
343 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
344 
345 pragma solidity ^0.8.0;
346 
347 /**
348  * @dev Provides information about the current execution context, including the
349  * sender of the transaction and its data. While these are generally available
350  * via msg.sender and msg.data, they should not be accessed in such a direct
351  * manner, since when dealing with meta-transactions the account sending and
352  * paying for execution may not be the actual sender (as far as an application
353  * is concerned).
354  *
355  * This contract is only required for intermediate, library-like contracts.
356  */
357 abstract contract Context {
358     function _msgSender() internal view virtual returns (address) {
359         return msg.sender;
360     }
361 
362     function _msgData() internal view virtual returns (bytes calldata) {
363         return msg.data;
364     }
365 }
366 
367 // File: @openzeppelin/contracts/access/Ownable.sol
368 
369 
370 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
371 
372 pragma solidity ^0.8.0;
373 
374 
375 /**
376  * @dev Contract module which provides a basic access control mechanism, where
377  * there is an account (an owner) that can be granted exclusive access to
378  * specific functions.
379  *
380  * By default, the owner account will be the one that deploys the contract. This
381  * can later be changed with {transferOwnership}.
382  *
383  * This module is used through inheritance. It will make available the modifier
384  * `onlyOwner`, which can be applied to your functions to restrict their use to
385  * the owner.
386  */
387 abstract contract Ownable is Context {
388     address private _owner;
389 
390     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
391 
392     /**
393      * @dev Initializes the contract setting the deployer as the initial owner.
394      */
395     constructor() {
396         _transferOwnership(_msgSender());
397     }
398 
399     /**
400      * @dev Throws if called by any account other than the owner.
401      */
402     modifier onlyOwner() {
403         _checkOwner();
404         _;
405     }
406 
407     /**
408      * @dev Returns the address of the current owner.
409      */
410     function owner() public view virtual returns (address) {
411         return _owner;
412     }
413 
414     /**
415      * @dev Throws if the sender is not the owner.
416      */
417     function _checkOwner() internal view virtual {
418         require(owner() == _msgSender(), "Ownable: caller is not the owner");
419     }
420 
421     /**
422      * @dev Leaves the contract without owner. It will not be possible to call
423      * `onlyOwner` functions anymore. Can only be called by the current owner.
424      *
425      * NOTE: Renouncing ownership will leave the contract without an owner,
426      * thereby removing any functionality that is only available to the owner.
427      */
428     function renounceOwnership() public virtual onlyOwner {
429         _transferOwnership(address(0));
430     }
431 
432     /**
433      * @dev Transfers ownership of the contract to a new account (`newOwner`).
434      * Can only be called by the current owner.
435      */
436     function transferOwnership(address newOwner) public virtual onlyOwner {
437         require(newOwner != address(0), "Ownable: new owner is the zero address");
438         _transferOwnership(newOwner);
439     }
440 
441     /**
442      * @dev Transfers ownership of the contract to a new account (`newOwner`).
443      * Internal function without access restriction.
444      */
445     function _transferOwnership(address newOwner) internal virtual {
446         address oldOwner = _owner;
447         _owner = newOwner;
448         emit OwnershipTransferred(oldOwner, newOwner);
449     }
450 }
451 
452 // File: @openzeppelin/contracts/utils/Address.sol
453 
454 
455 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
456 
457 pragma solidity ^0.8.1;
458 
459 /**
460  * @dev Collection of functions related to the address type
461  */
462 library Address {
463     /**
464      * @dev Returns true if `account` is a contract.
465      *
466      * [IMPORTANT]
467      * ====
468      * It is unsafe to assume that an address for which this function returns
469      * false is an externally-owned account (EOA) and not a contract.
470      *
471      * Among others, `isContract` will return false for the following
472      * types of addresses:
473      *
474      *  - an externally-owned account
475      *  - a contract in construction
476      *  - an address where a contract will be created
477      *  - an address where a contract lived, but was destroyed
478      * ====
479      *
480      * [IMPORTANT]
481      * ====
482      * You shouldn't rely on `isContract` to protect against flash loan attacks!
483      *
484      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
485      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
486      * constructor.
487      * ====
488      */
489     function isContract(address account) internal view returns (bool) {
490         // This method relies on extcodesize/address.code.length, which returns 0
491         // for contracts in construction, since the code is only stored at the end
492         // of the constructor execution.
493 
494         return account.code.length > 0;
495     }
496 
497     /**
498      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
499      * `recipient`, forwarding all available gas and reverting on errors.
500      *
501      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
502      * of certain opcodes, possibly making contracts go over the 2300 gas limit
503      * imposed by `transfer`, making them unable to receive funds via
504      * `transfer`. {sendValue} removes this limitation.
505      *
506      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
507      *
508      * IMPORTANT: because control is transferred to `recipient`, care must be
509      * taken to not create reentrancy vulnerabilities. Consider using
510      * {ReentrancyGuard} or the
511      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
512      */
513     function sendValue(address payable recipient, uint256 amount) internal {
514         require(address(this).balance >= amount, "Address: insufficient balance");
515 
516         (bool success, ) = recipient.call{value: amount}("");
517         require(success, "Address: unable to send value, recipient may have reverted");
518     }
519 
520     /**
521      * @dev Performs a Solidity function call using a low level `call`. A
522      * plain `call` is an unsafe replacement for a function call: use this
523      * function instead.
524      *
525      * If `target` reverts with a revert reason, it is bubbled up by this
526      * function (like regular Solidity function calls).
527      *
528      * Returns the raw returned data. To convert to the expected return value,
529      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
530      *
531      * Requirements:
532      *
533      * - `target` must be a contract.
534      * - calling `target` with `data` must not revert.
535      *
536      * _Available since v3.1._
537      */
538     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
539         return functionCall(target, data, "Address: low-level call failed");
540     }
541 
542     /**
543      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
544      * `errorMessage` as a fallback revert reason when `target` reverts.
545      *
546      * _Available since v3.1._
547      */
548     function functionCall(
549         address target,
550         bytes memory data,
551         string memory errorMessage
552     ) internal returns (bytes memory) {
553         return functionCallWithValue(target, data, 0, errorMessage);
554     }
555 
556     /**
557      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
558      * but also transferring `value` wei to `target`.
559      *
560      * Requirements:
561      *
562      * - the calling contract must have an ETH balance of at least `value`.
563      * - the called Solidity function must be `payable`.
564      *
565      * _Available since v3.1._
566      */
567     function functionCallWithValue(
568         address target,
569         bytes memory data,
570         uint256 value
571     ) internal returns (bytes memory) {
572         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
577      * with `errorMessage` as a fallback revert reason when `target` reverts.
578      *
579      * _Available since v3.1._
580      */
581     function functionCallWithValue(
582         address target,
583         bytes memory data,
584         uint256 value,
585         string memory errorMessage
586     ) internal returns (bytes memory) {
587         require(address(this).balance >= value, "Address: insufficient balance for call");
588         require(isContract(target), "Address: call to non-contract");
589 
590         (bool success, bytes memory returndata) = target.call{value: value}(data);
591         return verifyCallResult(success, returndata, errorMessage);
592     }
593 
594     /**
595      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
596      * but performing a static call.
597      *
598      * _Available since v3.3._
599      */
600     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
601         return functionStaticCall(target, data, "Address: low-level static call failed");
602     }
603 
604     /**
605      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
606      * but performing a static call.
607      *
608      * _Available since v3.3._
609      */
610     function functionStaticCall(
611         address target,
612         bytes memory data,
613         string memory errorMessage
614     ) internal view returns (bytes memory) {
615         require(isContract(target), "Address: static call to non-contract");
616 
617         (bool success, bytes memory returndata) = target.staticcall(data);
618         return verifyCallResult(success, returndata, errorMessage);
619     }
620 
621     /**
622      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
623      * but performing a delegate call.
624      *
625      * _Available since v3.4._
626      */
627     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
628         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
629     }
630 
631     /**
632      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
633      * but performing a delegate call.
634      *
635      * _Available since v3.4._
636      */
637     function functionDelegateCall(
638         address target,
639         bytes memory data,
640         string memory errorMessage
641     ) internal returns (bytes memory) {
642         require(isContract(target), "Address: delegate call to non-contract");
643 
644         (bool success, bytes memory returndata) = target.delegatecall(data);
645         return verifyCallResult(success, returndata, errorMessage);
646     }
647 
648     /**
649      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
650      * revert reason using the provided one.
651      *
652      * _Available since v4.3._
653      */
654     function verifyCallResult(
655         bool success,
656         bytes memory returndata,
657         string memory errorMessage
658     ) internal pure returns (bytes memory) {
659         if (success) {
660             return returndata;
661         } else {
662             // Look for revert reason and bubble it up if present
663             if (returndata.length > 0) {
664                 // The easiest way to bubble the revert reason is using memory via assembly
665                 /// @solidity memory-safe-assembly
666                 assembly {
667                     let returndata_size := mload(returndata)
668                     revert(add(32, returndata), returndata_size)
669                 }
670             } else {
671                 revert(errorMessage);
672             }
673         }
674     }
675 }
676 
677 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
678 
679 
680 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
681 
682 pragma solidity ^0.8.0;
683 
684 /**
685  * @title ERC721 token receiver interface
686  * @dev Interface for any contract that wants to support safeTransfers
687  * from ERC721 asset contracts.
688  */
689 interface IERC721Receiver {
690     /**
691      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
692      * by `operator` from `from`, this function is called.
693      *
694      * It must return its Solidity selector to confirm the token transfer.
695      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
696      *
697      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
698      */
699     function onERC721Received(
700         address operator,
701         address from,
702         uint256 tokenId,
703         bytes calldata data
704     ) external returns (bytes4);
705 }
706 
707 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
708 
709 
710 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
711 
712 pragma solidity ^0.8.0;
713 
714 /**
715  * @dev Interface of the ERC165 standard, as defined in the
716  * https://eips.ethereum.org/EIPS/eip-165[EIP].
717  *
718  * Implementers can declare support of contract interfaces, which can then be
719  * queried by others ({ERC165Checker}).
720  *
721  * For an implementation, see {ERC165}.
722  */
723 interface IERC165 {
724     /**
725      * @dev Returns true if this contract implements the interface defined by
726      * `interfaceId`. See the corresponding
727      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
728      * to learn more about how these ids are created.
729      *
730      * This function call must use less than 30 000 gas.
731      */
732     function supportsInterface(bytes4 interfaceId) external view returns (bool);
733 }
734 
735 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
736 
737 
738 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
739 
740 pragma solidity ^0.8.0;
741 
742 
743 /**
744  * @dev Implementation of the {IERC165} interface.
745  *
746  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
747  * for the additional interface id that will be supported. For example:
748  *
749  * ```solidity
750  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
751  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
752  * }
753  * ```
754  *
755  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
756  */
757 abstract contract ERC165 is IERC165 {
758     /**
759      * @dev See {IERC165-supportsInterface}.
760      */
761     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
762         return interfaceId == type(IERC165).interfaceId;
763     }
764 }
765 
766 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
767 
768 
769 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
770 
771 pragma solidity ^0.8.0;
772 
773 
774 /**
775  * @dev Required interface of an ERC721 compliant contract.
776  */
777 interface IERC721 is IERC165 {
778     /**
779      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
780      */
781     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
782 
783     /**
784      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
785      */
786     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
787 
788     /**
789      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
790      */
791     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
792 
793     /**
794      * @dev Returns the number of tokens in ``owner``'s account.
795      */
796     function balanceOf(address owner) external view returns (uint256 balance);
797 
798     /**
799      * @dev Returns the owner of the `tokenId` token.
800      *
801      * Requirements:
802      *
803      * - `tokenId` must exist.
804      */
805     function ownerOf(uint256 tokenId) external view returns (address owner);
806 
807     /**
808      * @dev Safely transfers `tokenId` token from `from` to `to`.
809      *
810      * Requirements:
811      *
812      * - `from` cannot be the zero address.
813      * - `to` cannot be the zero address.
814      * - `tokenId` token must exist and be owned by `from`.
815      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
816      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
817      *
818      * Emits a {Transfer} event.
819      */
820     function safeTransferFrom(
821         address from,
822         address to,
823         uint256 tokenId,
824         bytes calldata data
825     ) external;
826 
827     /**
828      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
829      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
830      *
831      * Requirements:
832      *
833      * - `from` cannot be the zero address.
834      * - `to` cannot be the zero address.
835      * - `tokenId` token must exist and be owned by `from`.
836      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
837      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
838      *
839      * Emits a {Transfer} event.
840      */
841     function safeTransferFrom(
842         address from,
843         address to,
844         uint256 tokenId
845     ) external;
846 
847     /**
848      * @dev Transfers `tokenId` token from `from` to `to`.
849      *
850      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
851      *
852      * Requirements:
853      *
854      * - `from` cannot be the zero address.
855      * - `to` cannot be the zero address.
856      * - `tokenId` token must be owned by `from`.
857      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
858      *
859      * Emits a {Transfer} event.
860      */
861     function transferFrom(
862         address from,
863         address to,
864         uint256 tokenId
865     ) external;
866 
867     /**
868      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
869      * The approval is cleared when the token is transferred.
870      *
871      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
872      *
873      * Requirements:
874      *
875      * - The caller must own the token or be an approved operator.
876      * - `tokenId` must exist.
877      *
878      * Emits an {Approval} event.
879      */
880     function approve(address to, uint256 tokenId) external;
881 
882     /**
883      * @dev Approve or remove `operator` as an operator for the caller.
884      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
885      *
886      * Requirements:
887      *
888      * - The `operator` cannot be the caller.
889      *
890      * Emits an {ApprovalForAll} event.
891      */
892     function setApprovalForAll(address operator, bool _approved) external;
893 
894     /**
895      * @dev Returns the account approved for `tokenId` token.
896      *
897      * Requirements:
898      *
899      * - `tokenId` must exist.
900      */
901     function getApproved(uint256 tokenId) external view returns (address operator);
902 
903     /**
904      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
905      *
906      * See {setApprovalForAll}
907      */
908     function isApprovedForAll(address owner, address operator) external view returns (bool);
909 }
910 
911 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
912 
913 
914 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
915 
916 pragma solidity ^0.8.0;
917 
918 
919 /**
920  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
921  * @dev See https://eips.ethereum.org/EIPS/eip-721
922  */
923 interface IERC721Metadata is IERC721 {
924     /**
925      * @dev Returns the token collection name.
926      */
927     function name() external view returns (string memory);
928 
929     /**
930      * @dev Returns the token collection symbol.
931      */
932     function symbol() external view returns (string memory);
933 
934     /**
935      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
936      */
937     function tokenURI(uint256 tokenId) external view returns (string memory);
938 }
939 
940 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
941 
942 
943 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
944 
945 pragma solidity ^0.8.0;
946 
947 
948 
949 
950 
951 
952 
953 
954 /**
955  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
956  * the Metadata extension, but not including the Enumerable extension, which is available separately as
957  * {ERC721Enumerable}.
958  */
959 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
960     using Address for address;
961     using Strings for uint256;
962 
963     // Token name
964     string private _name;
965 
966     // Token symbol
967     string private _symbol;
968 
969     // Mapping from token ID to owner address
970     mapping(uint256 => address) private _owners;
971 
972     // Mapping owner address to token count
973     mapping(address => uint256) private _balances;
974 
975     // Mapping from token ID to approved address
976     mapping(uint256 => address) private _tokenApprovals;
977 
978     // Mapping from owner to operator approvals
979     mapping(address => mapping(address => bool)) private _operatorApprovals;
980 
981     /**
982      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
983      */
984     constructor(string memory name_, string memory symbol_) {
985         _name = name_;
986         _symbol = symbol_;
987     }
988 
989     /**
990      * @dev See {IERC165-supportsInterface}.
991      */
992     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
993         return
994             interfaceId == type(IERC721).interfaceId ||
995             interfaceId == type(IERC721Metadata).interfaceId ||
996             super.supportsInterface(interfaceId);
997     }
998 
999     /**
1000      * @dev See {IERC721-balanceOf}.
1001      */
1002     function balanceOf(address owner) public view virtual override returns (uint256) {
1003         require(owner != address(0), "ERC721: address zero is not a valid owner");
1004         return _balances[owner];
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-ownerOf}.
1009      */
1010     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1011         address owner = _owners[tokenId];
1012         require(owner != address(0), "ERC721: invalid token ID");
1013         return owner;
1014     }
1015 
1016     /**
1017      * @dev See {IERC721Metadata-name}.
1018      */
1019     function name() public view virtual override returns (string memory) {
1020         return _name;
1021     }
1022 
1023     /**
1024      * @dev See {IERC721Metadata-symbol}.
1025      */
1026     function symbol() public view virtual override returns (string memory) {
1027         return _symbol;
1028     }
1029 
1030     /**
1031      * @dev See {IERC721Metadata-tokenURI}.
1032      */
1033     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1034         _requireMinted(tokenId);
1035 
1036         string memory baseURI = _baseURI();
1037         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1038     }
1039 
1040     /**
1041      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1042      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1043      * by default, can be overridden in child contracts.
1044      */
1045     function _baseURI() internal view virtual returns (string memory) {
1046         return "";
1047     }
1048 
1049     /**
1050      * @dev See {IERC721-approve}.
1051      */
1052     function approve(address to, uint256 tokenId) public virtual override {
1053         address owner = ERC721.ownerOf(tokenId);
1054         require(to != owner, "ERC721: approval to current owner");
1055 
1056         require(
1057             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1058             "ERC721: approve caller is not token owner nor approved for all"
1059         );
1060 
1061         _approve(to, tokenId);
1062     }
1063 
1064     /**
1065      * @dev See {IERC721-getApproved}.
1066      */
1067     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1068         _requireMinted(tokenId);
1069 
1070         return _tokenApprovals[tokenId];
1071     }
1072 
1073     /**
1074      * @dev See {IERC721-setApprovalForAll}.
1075      */
1076     function setApprovalForAll(address operator, bool approved) public virtual override {
1077         _setApprovalForAll(_msgSender(), operator, approved);
1078     }
1079 
1080     /**
1081      * @dev See {IERC721-isApprovedForAll}.
1082      */
1083     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1084         return _operatorApprovals[owner][operator];
1085     }
1086 
1087     /**
1088      * @dev See {IERC721-transferFrom}.
1089      */
1090     function transferFrom(
1091         address from,
1092         address to,
1093         uint256 tokenId
1094     ) public virtual override {
1095         //solhint-disable-next-line max-line-length
1096         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1097 
1098         _transfer(from, to, tokenId);
1099     }
1100 
1101     /**
1102      * @dev See {IERC721-safeTransferFrom}.
1103      */
1104     function safeTransferFrom(
1105         address from,
1106         address to,
1107         uint256 tokenId
1108     ) public virtual override {
1109         safeTransferFrom(from, to, tokenId, "");
1110     }
1111 
1112     /**
1113      * @dev See {IERC721-safeTransferFrom}.
1114      */
1115     function safeTransferFrom(
1116         address from,
1117         address to,
1118         uint256 tokenId,
1119         bytes memory data
1120     ) public virtual override {
1121         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1122         _safeTransfer(from, to, tokenId, data);
1123     }
1124 
1125     /**
1126      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1127      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1128      *
1129      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1130      *
1131      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1132      * implement alternative mechanisms to perform token transfer, such as signature-based.
1133      *
1134      * Requirements:
1135      *
1136      * - `from` cannot be the zero address.
1137      * - `to` cannot be the zero address.
1138      * - `tokenId` token must exist and be owned by `from`.
1139      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1140      *
1141      * Emits a {Transfer} event.
1142      */
1143     function _safeTransfer(
1144         address from,
1145         address to,
1146         uint256 tokenId,
1147         bytes memory data
1148     ) internal virtual {
1149         _transfer(from, to, tokenId);
1150         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1151     }
1152 
1153     /**
1154      * @dev Returns whether `tokenId` exists.
1155      *
1156      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1157      *
1158      * Tokens start existing when they are minted (`_mint`),
1159      * and stop existing when they are burned (`_burn`).
1160      */
1161     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1162         return _owners[tokenId] != address(0);
1163     }
1164 
1165     /**
1166      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1167      *
1168      * Requirements:
1169      *
1170      * - `tokenId` must exist.
1171      */
1172     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1173         address owner = ERC721.ownerOf(tokenId);
1174         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1175     }
1176 
1177     /**
1178      * @dev Safely mints `tokenId` and transfers it to `to`.
1179      *
1180      * Requirements:
1181      *
1182      * - `tokenId` must not exist.
1183      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1184      *
1185      * Emits a {Transfer} event.
1186      */
1187     function _safeMint(address to, uint256 tokenId) internal virtual {
1188         _safeMint(to, tokenId, "");
1189     }
1190 
1191     /**
1192      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1193      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1194      */
1195     function _safeMint(
1196         address to,
1197         uint256 tokenId,
1198         bytes memory data
1199     ) internal virtual {
1200         _mint(to, tokenId);
1201         require(
1202             _checkOnERC721Received(address(0), to, tokenId, data),
1203             "ERC721: transfer to non ERC721Receiver implementer"
1204         );
1205     }
1206 
1207     /**
1208      * @dev Mints `tokenId` and transfers it to `to`.
1209      *
1210      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1211      *
1212      * Requirements:
1213      *
1214      * - `tokenId` must not exist.
1215      * - `to` cannot be the zero address.
1216      *
1217      * Emits a {Transfer} event.
1218      */
1219     function _mint(address to, uint256 tokenId) internal virtual {
1220         require(to != address(0), "ERC721: mint to the zero address");
1221         require(!_exists(tokenId), "ERC721: token already minted");
1222 
1223         _beforeTokenTransfer(address(0), to, tokenId);
1224 
1225         _balances[to] += 1;
1226         _owners[tokenId] = to;
1227 
1228         emit Transfer(address(0), to, tokenId);
1229 
1230         _afterTokenTransfer(address(0), to, tokenId);
1231     }
1232 
1233     /**
1234      * @dev Destroys `tokenId`.
1235      * The approval is cleared when the token is burned.
1236      *
1237      * Requirements:
1238      *
1239      * - `tokenId` must exist.
1240      *
1241      * Emits a {Transfer} event.
1242      */
1243     function _burn(uint256 tokenId) internal virtual {
1244         address owner = ERC721.ownerOf(tokenId);
1245 
1246         _beforeTokenTransfer(owner, address(0), tokenId);
1247 
1248         // Clear approvals
1249         _approve(address(0), tokenId);
1250 
1251         _balances[owner] -= 1;
1252         delete _owners[tokenId];
1253 
1254         emit Transfer(owner, address(0), tokenId);
1255 
1256         _afterTokenTransfer(owner, address(0), tokenId);
1257     }
1258 
1259     /**
1260      * @dev Transfers `tokenId` from `from` to `to`.
1261      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1262      *
1263      * Requirements:
1264      *
1265      * - `to` cannot be the zero address.
1266      * - `tokenId` token must be owned by `from`.
1267      *
1268      * Emits a {Transfer} event.
1269      */
1270     function _transfer(
1271         address from,
1272         address to,
1273         uint256 tokenId
1274     ) internal virtual {
1275         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1276         require(to != address(0), "ERC721: transfer to the zero address");
1277 
1278         _beforeTokenTransfer(from, to, tokenId);
1279 
1280         // Clear approvals from the previous owner
1281         _approve(address(0), tokenId);
1282 
1283         _balances[from] -= 1;
1284         _balances[to] += 1;
1285         _owners[tokenId] = to;
1286 
1287         emit Transfer(from, to, tokenId);
1288 
1289         _afterTokenTransfer(from, to, tokenId);
1290     }
1291 
1292     /**
1293      * @dev Approve `to` to operate on `tokenId`
1294      *
1295      * Emits an {Approval} event.
1296      */
1297     function _approve(address to, uint256 tokenId) internal virtual {
1298         _tokenApprovals[tokenId] = to;
1299         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1300     }
1301 
1302     /**
1303      * @dev Approve `operator` to operate on all of `owner` tokens
1304      *
1305      * Emits an {ApprovalForAll} event.
1306      */
1307     function _setApprovalForAll(
1308         address owner,
1309         address operator,
1310         bool approved
1311     ) internal virtual {
1312         require(owner != operator, "ERC721: approve to caller");
1313         _operatorApprovals[owner][operator] = approved;
1314         emit ApprovalForAll(owner, operator, approved);
1315     }
1316 
1317     /**
1318      * @dev Reverts if the `tokenId` has not been minted yet.
1319      */
1320     function _requireMinted(uint256 tokenId) internal view virtual {
1321         require(_exists(tokenId), "ERC721: invalid token ID");
1322     }
1323 
1324     /**
1325      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1326      * The call is not executed if the target address is not a contract.
1327      *
1328      * @param from address representing the previous owner of the given token ID
1329      * @param to target address that will receive the tokens
1330      * @param tokenId uint256 ID of the token to be transferred
1331      * @param data bytes optional data to send along with the call
1332      * @return bool whether the call correctly returned the expected magic value
1333      */
1334     function _checkOnERC721Received(
1335         address from,
1336         address to,
1337         uint256 tokenId,
1338         bytes memory data
1339     ) private returns (bool) {
1340         if (to.isContract()) {
1341             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1342                 return retval == IERC721Receiver.onERC721Received.selector;
1343             } catch (bytes memory reason) {
1344                 if (reason.length == 0) {
1345                     revert("ERC721: transfer to non ERC721Receiver implementer");
1346                 } else {
1347                     /// @solidity memory-safe-assembly
1348                     assembly {
1349                         revert(add(32, reason), mload(reason))
1350                     }
1351                 }
1352             }
1353         } else {
1354             return true;
1355         }
1356     }
1357 
1358     /**
1359      * @dev Hook that is called before any token transfer. This includes minting
1360      * and burning.
1361      *
1362      * Calling conditions:
1363      *
1364      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1365      * transferred to `to`.
1366      * - When `from` is zero, `tokenId` will be minted for `to`.
1367      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1368      * - `from` and `to` are never both zero.
1369      *
1370      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1371      */
1372     function _beforeTokenTransfer(
1373         address from,
1374         address to,
1375         uint256 tokenId
1376     ) internal virtual {}
1377 
1378     /**
1379      * @dev Hook that is called after any transfer of tokens. This includes
1380      * minting and burning.
1381      *
1382      * Calling conditions:
1383      *
1384      * - when `from` and `to` are both non-zero.
1385      * - `from` and `to` are never both zero.
1386      *
1387      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1388      */
1389     function _afterTokenTransfer(
1390         address from,
1391         address to,
1392         uint256 tokenId
1393     ) internal virtual {}
1394 }
1395 
1396 // File: TBT.sol
1397 
1398 //SPDX-License-Identifier: Unlicense
1399 pragma solidity ^0.8.0;
1400 
1401 
1402 
1403 
1404 
1405 contract CatBloxTBT is ERC721, Ownable {
1406     using Counters for Counters.Counter;
1407     using Strings for uint256;
1408 
1409     Counters.Counter private tokenCounter;
1410 
1411     string public baseURI;
1412     string public provenanceHash;
1413     bool public isClaimingActive;
1414     bytes32 public claimListMerkleRoot;
1415 
1416     uint256 public immutable maxTokens;
1417 
1418     mapping(address => uint256) public claimListMintCounts;
1419 
1420     // ============ ACCESS CONTROL/SANITY MODIFIERS ============
1421 
1422     modifier claimListActive() {
1423         require(isClaimingActive, "Claim list not active");
1424         _;
1425     }
1426 
1427     modifier totalNotExceeded(uint256 numberOfTokens) {
1428         require(
1429             tokenCounter.current() + numberOfTokens <= maxTokens,
1430             "Not enough tokens remaining to claim"
1431         );
1432         _;
1433     }
1434 
1435     modifier isValidMerkleProof(bytes32[] calldata merkleProof, bytes32 root, uint256 maxClaimable) {
1436         require(
1437             MerkleProof.verify(
1438                 merkleProof,
1439                 root,
1440                 keccak256(abi.encodePacked(msg.sender, maxClaimable))
1441             ),
1442             "Proof does not exist in tree"
1443         );
1444         _;
1445     }
1446 
1447     constructor(string memory _baseURI, uint256 _maxTokens) ERC721("CatBloxTBT", "CBLXTBT") {
1448         baseURI = _baseURI;
1449         maxTokens = _maxTokens;
1450     }
1451 
1452     // ============ PUBLIC FUNCTION FOR CLAIMING ============
1453 
1454     function claim(
1455         uint256 numberOfTokens,
1456         uint256 maxClaimable,
1457         bytes32[] calldata merkleProof
1458     )
1459         external
1460         claimListActive
1461         totalNotExceeded(numberOfTokens)
1462         isValidMerkleProof(merkleProof, claimListMerkleRoot, maxClaimable)
1463     {
1464         uint256 numAlreadyMinted = claimListMintCounts[msg.sender];
1465         require(numAlreadyMinted + numberOfTokens <= maxClaimable, "Exceeds max claimable");
1466         claimListMintCounts[msg.sender] = numAlreadyMinted + numberOfTokens;
1467 
1468         for (uint256 i = 0; i < numberOfTokens; i++) {
1469             _safeMint(msg.sender, nextTokenId());
1470         }
1471     }
1472 
1473     // ============ PUBLIC READ-ONLY FUNCTIONS ============
1474 
1475     function totalSupply() external view returns (uint256) {
1476         return tokenCounter.current();
1477     }
1478 
1479     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
1480 
1481     function setBaseURI(string memory _baseURI) external onlyOwner {
1482         baseURI = _baseURI;
1483     }
1484 
1485     function setProvenanceHash(string memory _hash) external onlyOwner {
1486         provenanceHash = _hash;
1487     }
1488 
1489     // Toggle Claiming Active / Inactive 
1490 
1491     function setClaimingActive(bool _isClaimingActive) external onlyOwner {
1492         isClaimingActive = _isClaimingActive;
1493     }
1494 
1495     // Set Merkle Roots 
1496 
1497     function setClaimListMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1498         claimListMerkleRoot = _merkleRoot;
1499     }
1500 
1501     // ============ SUPPORTING FUNCTIONS ============
1502 
1503     function nextTokenId() private returns (uint256) {
1504         tokenCounter.increment();
1505         return tokenCounter.current();
1506     }
1507 
1508     /**
1509      * @dev See {IERC721Metadata-tokenURI}.
1510      */
1511     function tokenURI(uint256 tokenId)
1512         public
1513         view
1514         virtual
1515         override
1516         returns (string memory)
1517     {
1518         require(_exists(tokenId), "Nonexistent token");
1519 
1520         return string(abi.encodePacked(baseURI, tokenId.toString()));
1521     }
1522 
1523 }