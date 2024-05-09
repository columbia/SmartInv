1 // SPDX-License-Identifier: GPL-3.0
2 // File: extensions/operator-filter/IOperatorFilterRegistry.sol
3 
4 pragma solidity ^0.8.13;
5 
6 interface IOperatorFilterRegistry {
7     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
8     function register(address registrant) external;
9     function registerAndSubscribe(address registrant, address subscription) external;
10     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
11     function unregister(address addr) external;
12     function updateOperator(address registrant, address operator, bool filtered) external;
13     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
14     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
15     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
16     function subscribe(address registrant, address registrantToSubscribe) external;
17     function unsubscribe(address registrant, bool copyExistingEntries) external;
18     function subscriptionOf(address addr) external returns (address registrant);
19     function subscribers(address registrant) external returns (address[] memory);
20     function subscriberAt(address registrant, uint256 index) external returns (address);
21     function copyEntriesOf(address registrant, address registrantToCopy) external;
22     function isOperatorFiltered(address registrant, address operator) external returns (bool);
23     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
24     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
25     function filteredOperators(address addr) external returns (address[] memory);
26     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
27     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
28     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
29     function isRegistered(address addr) external returns (bool);
30     function codeHashOf(address addr) external returns (bytes32);
31 }
32 
33 // File: extensions/operator-filter/OperatorFilterer.sol
34 
35 
36 pragma solidity ^0.8.13;
37 
38 
39 /**
40  * @title  OperatorFilterer
41  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
42  *         registrant's entries in the OperatorFilterRegistry.
43  */
44 abstract contract OperatorFilterer {
45     error OperatorNotAllowed(address operator);
46 
47     IOperatorFilterRegistry constant OPERATOR_FILTER_REGISTRY =
48         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
49 
50     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
51         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
52         // will not revert, but the contract will need to be registered with the registry once it is deployed in
53         // order for the modifier to filter addresses.
54         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
55             if (subscribe) {
56                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
57             } else {
58                 if (subscriptionOrRegistrantToCopy != address(0)) {
59                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
60                 } else {
61                     OPERATOR_FILTER_REGISTRY.register(address(this));
62                 }
63             }
64         }
65     }
66 
67     modifier onlyAllowedOperator(address from) virtual {
68         // Check registry code length to facilitate testing in environments without a deployed registry.
69         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
70             // Allow spending tokens from addresses with balance
71             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
72             // from an EOA.
73             if (from == msg.sender) {
74                 _;
75                 return;
76             }
77             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
78                 revert OperatorNotAllowed(msg.sender);
79             }
80         }
81         _;
82     }
83 
84     modifier onlyAllowedOperatorApproval(address operator) virtual {
85         // Check registry code length to facilitate testing in environments without a deployed registry.
86         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
87             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
88                 revert OperatorNotAllowed(operator);
89             }
90         }
91         _;
92     }
93 }
94 
95 // File: extensions/operator-filter/DefaultOperatorFilterer.sol
96 
97 
98 pragma solidity ^0.8.13;
99 
100 
101 /**
102  * @title  DefaultOperatorFilterer
103  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
104  */
105 abstract contract DefaultOperatorFilterer is OperatorFilterer {
106     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
107 
108     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
109 }
110 
111 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
112 
113 
114 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
115 
116 pragma solidity ^0.8.0;
117 
118 /**
119  * @dev These functions deal with verification of Merkle Tree proofs.
120  *
121  * The tree and the proofs can be generated using our
122  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
123  * You will find a quickstart guide in the readme.
124  *
125  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
126  * hashing, or use a hash function other than keccak256 for hashing leaves.
127  * This is because the concatenation of a sorted pair of internal nodes in
128  * the merkle tree could be reinterpreted as a leaf value.
129  * OpenZeppelin's JavaScript library generates merkle trees that are safe
130  * against this attack out of the box.
131  */
132 library MerkleProof {
133     /**
134      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
135      * defined by `root`. For this, a `proof` must be provided, containing
136      * sibling hashes on the branch from the leaf to the root of the tree. Each
137      * pair of leaves and each pair of pre-images are assumed to be sorted.
138      */
139     function verify(
140         bytes32[] memory proof,
141         bytes32 root,
142         bytes32 leaf
143     ) internal pure returns (bool) {
144         return processProof(proof, leaf) == root;
145     }
146 
147     /**
148      * @dev Calldata version of {verify}
149      *
150      * _Available since v4.7._
151      */
152     function verifyCalldata(
153         bytes32[] calldata proof,
154         bytes32 root,
155         bytes32 leaf
156     ) internal pure returns (bool) {
157         return processProofCalldata(proof, leaf) == root;
158     }
159 
160     /**
161      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
162      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
163      * hash matches the root of the tree. When processing the proof, the pairs
164      * of leafs & pre-images are assumed to be sorted.
165      *
166      * _Available since v4.4._
167      */
168     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
169         bytes32 computedHash = leaf;
170         for (uint256 i = 0; i < proof.length; i++) {
171             computedHash = _hashPair(computedHash, proof[i]);
172         }
173         return computedHash;
174     }
175 
176     /**
177      * @dev Calldata version of {processProof}
178      *
179      * _Available since v4.7._
180      */
181     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
182         bytes32 computedHash = leaf;
183         for (uint256 i = 0; i < proof.length; i++) {
184             computedHash = _hashPair(computedHash, proof[i]);
185         }
186         return computedHash;
187     }
188 
189     /**
190      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
191      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
192      *
193      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
194      *
195      * _Available since v4.7._
196      */
197     function multiProofVerify(
198         bytes32[] memory proof,
199         bool[] memory proofFlags,
200         bytes32 root,
201         bytes32[] memory leaves
202     ) internal pure returns (bool) {
203         return processMultiProof(proof, proofFlags, leaves) == root;
204     }
205 
206     /**
207      * @dev Calldata version of {multiProofVerify}
208      *
209      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
210      *
211      * _Available since v4.7._
212      */
213     function multiProofVerifyCalldata(
214         bytes32[] calldata proof,
215         bool[] calldata proofFlags,
216         bytes32 root,
217         bytes32[] memory leaves
218     ) internal pure returns (bool) {
219         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
220     }
221 
222     /**
223      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
224      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
225      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
226      * respectively.
227      *
228      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
229      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
230      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
231      *
232      * _Available since v4.7._
233      */
234     function processMultiProof(
235         bytes32[] memory proof,
236         bool[] memory proofFlags,
237         bytes32[] memory leaves
238     ) internal pure returns (bytes32 merkleRoot) {
239         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
240         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
241         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
242         // the merkle tree.
243         uint256 leavesLen = leaves.length;
244         uint256 totalHashes = proofFlags.length;
245 
246         // Check proof validity.
247         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
248 
249         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
250         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
251         bytes32[] memory hashes = new bytes32[](totalHashes);
252         uint256 leafPos = 0;
253         uint256 hashPos = 0;
254         uint256 proofPos = 0;
255         // At each step, we compute the next hash using two values:
256         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
257         //   get the next hash.
258         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
259         //   `proof` array.
260         for (uint256 i = 0; i < totalHashes; i++) {
261             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
262             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
263             hashes[i] = _hashPair(a, b);
264         }
265 
266         if (totalHashes > 0) {
267             return hashes[totalHashes - 1];
268         } else if (leavesLen > 0) {
269             return leaves[0];
270         } else {
271             return proof[0];
272         }
273     }
274 
275     /**
276      * @dev Calldata version of {processMultiProof}.
277      *
278      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
279      *
280      * _Available since v4.7._
281      */
282     function processMultiProofCalldata(
283         bytes32[] calldata proof,
284         bool[] calldata proofFlags,
285         bytes32[] memory leaves
286     ) internal pure returns (bytes32 merkleRoot) {
287         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
288         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
289         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
290         // the merkle tree.
291         uint256 leavesLen = leaves.length;
292         uint256 totalHashes = proofFlags.length;
293 
294         // Check proof validity.
295         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
296 
297         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
298         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
299         bytes32[] memory hashes = new bytes32[](totalHashes);
300         uint256 leafPos = 0;
301         uint256 hashPos = 0;
302         uint256 proofPos = 0;
303         // At each step, we compute the next hash using two values:
304         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
305         //   get the next hash.
306         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
307         //   `proof` array.
308         for (uint256 i = 0; i < totalHashes; i++) {
309             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
310             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
311             hashes[i] = _hashPair(a, b);
312         }
313 
314         if (totalHashes > 0) {
315             return hashes[totalHashes - 1];
316         } else if (leavesLen > 0) {
317             return leaves[0];
318         } else {
319             return proof[0];
320         }
321     }
322 
323     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
324         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
325     }
326 
327     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
328         /// @solidity memory-safe-assembly
329         assembly {
330             mstore(0x00, a)
331             mstore(0x20, b)
332             value := keccak256(0x00, 0x40)
333         }
334     }
335 }
336 
337 // File: @openzeppelin/contracts/utils/Counters.sol
338 
339 
340 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
341 
342 pragma solidity ^0.8.0;
343 
344 /**
345  * @title Counters
346  * @author Matt Condon (@shrugs)
347  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
348  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
349  *
350  * Include with `using Counters for Counters.Counter;`
351  */
352 library Counters {
353     struct Counter {
354         // This variable should never be directly accessed by users of the library: interactions must be restricted to
355         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
356         // this feature: see https://github.com/ethereum/solidity/issues/4637
357         uint256 _value; // default: 0
358     }
359 
360     function current(Counter storage counter) internal view returns (uint256) {
361         return counter._value;
362     }
363 
364     function increment(Counter storage counter) internal {
365         unchecked {
366             counter._value += 1;
367         }
368     }
369 
370     function decrement(Counter storage counter) internal {
371         uint256 value = counter._value;
372         require(value > 0, "Counter: decrement overflow");
373         unchecked {
374             counter._value = value - 1;
375         }
376     }
377 
378     function reset(Counter storage counter) internal {
379         counter._value = 0;
380     }
381 }
382 
383 // File: @openzeppelin/contracts/utils/Strings.sol
384 
385 
386 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
387 
388 pragma solidity ^0.8.0;
389 
390 /**
391  * @dev String operations.
392  */
393 library Strings {
394     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
395     uint8 private constant _ADDRESS_LENGTH = 20;
396 
397     /**
398      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
399      */
400     function toString(uint256 value) internal pure returns (string memory) {
401         // Inspired by OraclizeAPI's implementation - MIT licence
402         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
403 
404         if (value == 0) {
405             return "0";
406         }
407         uint256 temp = value;
408         uint256 digits;
409         while (temp != 0) {
410             digits++;
411             temp /= 10;
412         }
413         bytes memory buffer = new bytes(digits);
414         while (value != 0) {
415             digits -= 1;
416             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
417             value /= 10;
418         }
419         return string(buffer);
420     }
421 
422     /**
423      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
424      */
425     function toHexString(uint256 value) internal pure returns (string memory) {
426         if (value == 0) {
427             return "0x00";
428         }
429         uint256 temp = value;
430         uint256 length = 0;
431         while (temp != 0) {
432             length++;
433             temp >>= 8;
434         }
435         return toHexString(value, length);
436     }
437 
438     /**
439      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
440      */
441     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
442         bytes memory buffer = new bytes(2 * length + 2);
443         buffer[0] = "0";
444         buffer[1] = "x";
445         for (uint256 i = 2 * length + 1; i > 1; --i) {
446             buffer[i] = _HEX_SYMBOLS[value & 0xf];
447             value >>= 4;
448         }
449         require(value == 0, "Strings: hex length insufficient");
450         return string(buffer);
451     }
452 
453     /**
454      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
455      */
456     function toHexString(address addr) internal pure returns (string memory) {
457         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
458     }
459 }
460 
461 // File: @openzeppelin/contracts/utils/Context.sol
462 
463 
464 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
465 
466 pragma solidity ^0.8.0;
467 
468 /**
469  * @dev Provides information about the current execution context, including the
470  * sender of the transaction and its data. While these are generally available
471  * via msg.sender and msg.data, they should not be accessed in such a direct
472  * manner, since when dealing with meta-transactions the account sending and
473  * paying for execution may not be the actual sender (as far as an application
474  * is concerned).
475  *
476  * This contract is only required for intermediate, library-like contracts.
477  */
478 abstract contract Context {
479     function _msgSender() internal view virtual returns (address) {
480         return msg.sender;
481     }
482 
483     function _msgData() internal view virtual returns (bytes calldata) {
484         return msg.data;
485     }
486 }
487 
488 // File: @openzeppelin/contracts/access/Ownable.sol
489 
490 
491 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
492 
493 pragma solidity ^0.8.0;
494 
495 
496 /**
497  * @dev Contract module which provides a basic access control mechanism, where
498  * there is an account (an owner) that can be granted exclusive access to
499  * specific functions.
500  *
501  * By default, the owner account will be the one that deploys the contract. This
502  * can later be changed with {transferOwnership}.
503  *
504  * This module is used through inheritance. It will make available the modifier
505  * `onlyOwner`, which can be applied to your functions to restrict their use to
506  * the owner.
507  */
508 abstract contract Ownable is Context {
509     address private _owner;
510 
511     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
512 
513     /**
514      * @dev Initializes the contract setting the deployer as the initial owner.
515      */
516     constructor() {
517         _transferOwnership(_msgSender());
518     }
519 
520     /**
521      * @dev Throws if called by any account other than the owner.
522      */
523     modifier onlyOwner() {
524         _checkOwner();
525         _;
526     }
527 
528     /**
529      * @dev Returns the address of the current owner.
530      */
531     function owner() public view virtual returns (address) {
532         return _owner;
533     }
534 
535     /**
536      * @dev Throws if the sender is not the owner.
537      */
538     function _checkOwner() internal view virtual {
539         require(owner() == _msgSender(), "Ownable: caller is not the owner");
540     }
541 
542     /**
543      * @dev Leaves the contract without owner. It will not be possible to call
544      * `onlyOwner` functions anymore. Can only be called by the current owner.
545      *
546      * NOTE: Renouncing ownership will leave the contract without an owner,
547      * thereby removing any functionality that is only available to the owner.
548      */
549     function renounceOwnership() public virtual onlyOwner {
550         _transferOwnership(address(0));
551     }
552 
553     /**
554      * @dev Transfers ownership of the contract to a new account (`newOwner`).
555      * Can only be called by the current owner.
556      */
557     function transferOwnership(address newOwner) public virtual onlyOwner {
558         require(newOwner != address(0), "Ownable: new owner is the zero address");
559         _transferOwnership(newOwner);
560     }
561 
562     /**
563      * @dev Transfers ownership of the contract to a new account (`newOwner`).
564      * Internal function without access restriction.
565      */
566     function _transferOwnership(address newOwner) internal virtual {
567         address oldOwner = _owner;
568         _owner = newOwner;
569         emit OwnershipTransferred(oldOwner, newOwner);
570     }
571 }
572 
573 // File: @openzeppelin/contracts/utils/Address.sol
574 
575 
576 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
577 
578 pragma solidity ^0.8.1;
579 
580 /**
581  * @dev Collection of functions related to the address type
582  */
583 library Address {
584     /**
585      * @dev Returns true if `account` is a contract.
586      *
587      * [IMPORTANT]
588      * ====
589      * It is unsafe to assume that an address for which this function returns
590      * false is an externally-owned account (EOA) and not a contract.
591      *
592      * Among others, `isContract` will return false for the following
593      * types of addresses:
594      *
595      *  - an externally-owned account
596      *  - a contract in construction
597      *  - an address where a contract will be created
598      *  - an address where a contract lived, but was destroyed
599      * ====
600      *
601      * [IMPORTANT]
602      * ====
603      * You shouldn't rely on `isContract` to protect against flash loan attacks!
604      *
605      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
606      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
607      * constructor.
608      * ====
609      */
610     function isContract(address account) internal view returns (bool) {
611         // This method relies on extcodesize/address.code.length, which returns 0
612         // for contracts in construction, since the code is only stored at the end
613         // of the constructor execution.
614 
615         return account.code.length > 0;
616     }
617 
618     /**
619      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
620      * `recipient`, forwarding all available gas and reverting on errors.
621      *
622      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
623      * of certain opcodes, possibly making contracts go over the 2300 gas limit
624      * imposed by `transfer`, making them unable to receive funds via
625      * `transfer`. {sendValue} removes this limitation.
626      *
627      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
628      *
629      * IMPORTANT: because control is transferred to `recipient`, care must be
630      * taken to not create reentrancy vulnerabilities. Consider using
631      * {ReentrancyGuard} or the
632      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
633      */
634     function sendValue(address payable recipient, uint256 amount) internal {
635         require(address(this).balance >= amount, "Address: insufficient balance");
636 
637         (bool success, ) = recipient.call{value: amount}("");
638         require(success, "Address: unable to send value, recipient may have reverted");
639     }
640 
641     /**
642      * @dev Performs a Solidity function call using a low level `call`. A
643      * plain `call` is an unsafe replacement for a function call: use this
644      * function instead.
645      *
646      * If `target` reverts with a revert reason, it is bubbled up by this
647      * function (like regular Solidity function calls).
648      *
649      * Returns the raw returned data. To convert to the expected return value,
650      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
651      *
652      * Requirements:
653      *
654      * - `target` must be a contract.
655      * - calling `target` with `data` must not revert.
656      *
657      * _Available since v3.1._
658      */
659     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
660         return functionCall(target, data, "Address: low-level call failed");
661     }
662 
663     /**
664      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
665      * `errorMessage` as a fallback revert reason when `target` reverts.
666      *
667      * _Available since v3.1._
668      */
669     function functionCall(
670         address target,
671         bytes memory data,
672         string memory errorMessage
673     ) internal returns (bytes memory) {
674         return functionCallWithValue(target, data, 0, errorMessage);
675     }
676 
677     /**
678      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
679      * but also transferring `value` wei to `target`.
680      *
681      * Requirements:
682      *
683      * - the calling contract must have an ETH balance of at least `value`.
684      * - the called Solidity function must be `payable`.
685      *
686      * _Available since v3.1._
687      */
688     function functionCallWithValue(
689         address target,
690         bytes memory data,
691         uint256 value
692     ) internal returns (bytes memory) {
693         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
694     }
695 
696     /**
697      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
698      * with `errorMessage` as a fallback revert reason when `target` reverts.
699      *
700      * _Available since v3.1._
701      */
702     function functionCallWithValue(
703         address target,
704         bytes memory data,
705         uint256 value,
706         string memory errorMessage
707     ) internal returns (bytes memory) {
708         require(address(this).balance >= value, "Address: insufficient balance for call");
709         require(isContract(target), "Address: call to non-contract");
710 
711         (bool success, bytes memory returndata) = target.call{value: value}(data);
712         return verifyCallResult(success, returndata, errorMessage);
713     }
714 
715     /**
716      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
717      * but performing a static call.
718      *
719      * _Available since v3.3._
720      */
721     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
722         return functionStaticCall(target, data, "Address: low-level static call failed");
723     }
724 
725     /**
726      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
727      * but performing a static call.
728      *
729      * _Available since v3.3._
730      */
731     function functionStaticCall(
732         address target,
733         bytes memory data,
734         string memory errorMessage
735     ) internal view returns (bytes memory) {
736         require(isContract(target), "Address: static call to non-contract");
737 
738         (bool success, bytes memory returndata) = target.staticcall(data);
739         return verifyCallResult(success, returndata, errorMessage);
740     }
741 
742     /**
743      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
744      * but performing a delegate call.
745      *
746      * _Available since v3.4._
747      */
748     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
749         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
750     }
751 
752     /**
753      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
754      * but performing a delegate call.
755      *
756      * _Available since v3.4._
757      */
758     function functionDelegateCall(
759         address target,
760         bytes memory data,
761         string memory errorMessage
762     ) internal returns (bytes memory) {
763         require(isContract(target), "Address: delegate call to non-contract");
764 
765         (bool success, bytes memory returndata) = target.delegatecall(data);
766         return verifyCallResult(success, returndata, errorMessage);
767     }
768 
769     /**
770      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
771      * revert reason using the provided one.
772      *
773      * _Available since v4.3._
774      */
775     function verifyCallResult(
776         bool success,
777         bytes memory returndata,
778         string memory errorMessage
779     ) internal pure returns (bytes memory) {
780         if (success) {
781             return returndata;
782         } else {
783             // Look for revert reason and bubble it up if present
784             if (returndata.length > 0) {
785                 // The easiest way to bubble the revert reason is using memory via assembly
786                 /// @solidity memory-safe-assembly
787                 assembly {
788                     let returndata_size := mload(returndata)
789                     revert(add(32, returndata), returndata_size)
790                 }
791             } else {
792                 revert(errorMessage);
793             }
794         }
795     }
796 }
797 
798 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
799 
800 
801 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
802 
803 pragma solidity ^0.8.0;
804 
805 /**
806  * @title ERC721 token receiver interface
807  * @dev Interface for any contract that wants to support safeTransfers
808  * from ERC721 asset contracts.
809  */
810 interface IERC721Receiver {
811     /**
812      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
813      * by `operator` from `from`, this function is called.
814      *
815      * It must return its Solidity selector to confirm the token transfer.
816      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
817      *
818      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
819      */
820     function onERC721Received(
821         address operator,
822         address from,
823         uint256 tokenId,
824         bytes calldata data
825     ) external returns (bytes4);
826 }
827 
828 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
829 
830 
831 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
832 
833 pragma solidity ^0.8.0;
834 
835 /**
836  * @dev Interface of the ERC165 standard, as defined in the
837  * https://eips.ethereum.org/EIPS/eip-165[EIP].
838  *
839  * Implementers can declare support of contract interfaces, which can then be
840  * queried by others ({ERC165Checker}).
841  *
842  * For an implementation, see {ERC165}.
843  */
844 interface IERC165 {
845     /**
846      * @dev Returns true if this contract implements the interface defined by
847      * `interfaceId`. See the corresponding
848      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
849      * to learn more about how these ids are created.
850      *
851      * This function call must use less than 30 000 gas.
852      */
853     function supportsInterface(bytes4 interfaceId) external view returns (bool);
854 }
855 
856 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
857 
858 
859 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
860 
861 pragma solidity ^0.8.0;
862 
863 
864 /**
865  * @dev Implementation of the {IERC165} interface.
866  *
867  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
868  * for the additional interface id that will be supported. For example:
869  *
870  * ```solidity
871  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
872  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
873  * }
874  * ```
875  *
876  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
877  */
878 abstract contract ERC165 is IERC165 {
879     /**
880      * @dev See {IERC165-supportsInterface}.
881      */
882     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
883         return interfaceId == type(IERC165).interfaceId;
884     }
885 }
886 
887 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
888 
889 
890 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
891 
892 pragma solidity ^0.8.0;
893 
894 
895 /**
896  * @dev Required interface of an ERC721 compliant contract.
897  */
898 interface IERC721 is IERC165 {
899     /**
900      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
901      */
902     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
903 
904     /**
905      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
906      */
907     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
908 
909     /**
910      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
911      */
912     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
913 
914     /**
915      * @dev Returns the number of tokens in ``owner``'s account.
916      */
917     function balanceOf(address owner) external view returns (uint256 balance);
918 
919     /**
920      * @dev Returns the owner of the `tokenId` token.
921      *
922      * Requirements:
923      *
924      * - `tokenId` must exist.
925      */
926     function ownerOf(uint256 tokenId) external view returns (address owner);
927 
928     /**
929      * @dev Safely transfers `tokenId` token from `from` to `to`.
930      *
931      * Requirements:
932      *
933      * - `from` cannot be the zero address.
934      * - `to` cannot be the zero address.
935      * - `tokenId` token must exist and be owned by `from`.
936      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
937      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
938      *
939      * Emits a {Transfer} event.
940      */
941     function safeTransferFrom(
942         address from,
943         address to,
944         uint256 tokenId,
945         bytes calldata data
946     ) external;
947 
948     /**
949      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
950      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
951      *
952      * Requirements:
953      *
954      * - `from` cannot be the zero address.
955      * - `to` cannot be the zero address.
956      * - `tokenId` token must exist and be owned by `from`.
957      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
958      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
959      *
960      * Emits a {Transfer} event.
961      */
962     function safeTransferFrom(
963         address from,
964         address to,
965         uint256 tokenId
966     ) external;
967 
968     /**
969      * @dev Transfers `tokenId` token from `from` to `to`.
970      *
971      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
972      *
973      * Requirements:
974      *
975      * - `from` cannot be the zero address.
976      * - `to` cannot be the zero address.
977      * - `tokenId` token must be owned by `from`.
978      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
979      *
980      * Emits a {Transfer} event.
981      */
982     function transferFrom(
983         address from,
984         address to,
985         uint256 tokenId
986     ) external;
987 
988     /**
989      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
990      * The approval is cleared when the token is transferred.
991      *
992      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
993      *
994      * Requirements:
995      *
996      * - The caller must own the token or be an approved operator.
997      * - `tokenId` must exist.
998      *
999      * Emits an {Approval} event.
1000      */
1001     function approve(address to, uint256 tokenId) external;
1002 
1003     /**
1004      * @dev Approve or remove `operator` as an operator for the caller.
1005      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1006      *
1007      * Requirements:
1008      *
1009      * - The `operator` cannot be the caller.
1010      *
1011      * Emits an {ApprovalForAll} event.
1012      */
1013     function setApprovalForAll(address operator, bool _approved) external;
1014 
1015     /**
1016      * @dev Returns the account approved for `tokenId` token.
1017      *
1018      * Requirements:
1019      *
1020      * - `tokenId` must exist.
1021      */
1022     function getApproved(uint256 tokenId) external view returns (address operator);
1023 
1024     /**
1025      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1026      *
1027      * See {setApprovalForAll}
1028      */
1029     function isApprovedForAll(address owner, address operator) external view returns (bool);
1030 }
1031 
1032 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1033 
1034 
1035 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1036 
1037 pragma solidity ^0.8.0;
1038 
1039 
1040 /**
1041  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1042  * @dev See https://eips.ethereum.org/EIPS/eip-721
1043  */
1044 interface IERC721Enumerable is IERC721 {
1045     /**
1046      * @dev Returns the total amount of tokens stored by the contract.
1047      */
1048     function totalSupply() external view returns (uint256);
1049 
1050     /**
1051      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1052      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1053      */
1054     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1055 
1056     /**
1057      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1058      * Use along with {totalSupply} to enumerate all tokens.
1059      */
1060     function tokenByIndex(uint256 index) external view returns (uint256);
1061 }
1062 
1063 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1064 
1065 
1066 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1067 
1068 pragma solidity ^0.8.0;
1069 
1070 
1071 /**
1072  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1073  * @dev See https://eips.ethereum.org/EIPS/eip-721
1074  */
1075 interface IERC721Metadata is IERC721 {
1076     /**
1077      * @dev Returns the token collection name.
1078      */
1079     function name() external view returns (string memory);
1080 
1081     /**
1082      * @dev Returns the token collection symbol.
1083      */
1084     function symbol() external view returns (string memory);
1085 
1086     /**
1087      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1088      */
1089     function tokenURI(uint256 tokenId) external view returns (string memory);
1090 }
1091 
1092 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1093 
1094 
1095 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
1096 
1097 pragma solidity ^0.8.0;
1098 
1099 
1100 
1101 
1102 
1103 
1104 
1105 
1106 /**
1107  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1108  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1109  * {ERC721Enumerable}.
1110  */
1111 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1112     using Address for address;
1113     using Strings for uint256;
1114 
1115     // Token name
1116     string private _name;
1117 
1118     // Token symbol
1119     string private _symbol;
1120 
1121     // Mapping from token ID to owner address
1122     mapping(uint256 => address) private _owners;
1123 
1124     // Mapping owner address to token count
1125     mapping(address => uint256) private _balances;
1126 
1127     // Mapping from token ID to approved address
1128     mapping(uint256 => address) private _tokenApprovals;
1129 
1130     // Mapping from owner to operator approvals
1131     mapping(address => mapping(address => bool)) private _operatorApprovals;
1132 
1133     /**
1134      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1135      */
1136     constructor(string memory name_, string memory symbol_) {
1137         _name = name_;
1138         _symbol = symbol_;
1139     }
1140 
1141     /**
1142      * @dev See {IERC165-supportsInterface}.
1143      */
1144     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1145         return
1146             interfaceId == type(IERC721).interfaceId ||
1147             interfaceId == type(IERC721Metadata).interfaceId ||
1148             super.supportsInterface(interfaceId);
1149     }
1150 
1151     /**
1152      * @dev See {IERC721-balanceOf}.
1153      */
1154     function balanceOf(address owner) public view virtual override returns (uint256) {
1155         require(owner != address(0), "ERC721: address zero is not a valid owner");
1156         return _balances[owner];
1157     }
1158 
1159     /**
1160      * @dev See {IERC721-ownerOf}.
1161      */
1162     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1163         address owner = _owners[tokenId];
1164         require(owner != address(0), "ERC721: invalid token ID");
1165         return owner;
1166     }
1167 
1168     /**
1169      * @dev See {IERC721Metadata-name}.
1170      */
1171     function name() public view virtual override returns (string memory) {
1172         return _name;
1173     }
1174 
1175     /**
1176      * @dev See {IERC721Metadata-symbol}.
1177      */
1178     function symbol() public view virtual override returns (string memory) {
1179         return _symbol;
1180     }
1181 
1182     /**
1183      * @dev See {IERC721Metadata-tokenURI}.
1184      */
1185     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1186         _requireMinted(tokenId);
1187 
1188         string memory baseURI = _baseURI();
1189         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1190     }
1191 
1192     /**
1193      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1194      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1195      * by default, can be overridden in child contracts.
1196      */
1197     function _baseURI() internal view virtual returns (string memory) {
1198         return "";
1199     }
1200 
1201     /**
1202      * @dev See {IERC721-approve}.
1203      */
1204     function approve(address to, uint256 tokenId) public virtual override {
1205         address owner = ERC721.ownerOf(tokenId);
1206         require(to != owner, "ERC721: approval to current owner");
1207 
1208         require(
1209             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1210             "ERC721: approve caller is not token owner nor approved for all"
1211         );
1212 
1213         _approve(to, tokenId);
1214     }
1215 
1216     /**
1217      * @dev See {IERC721-getApproved}.
1218      */
1219     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1220         _requireMinted(tokenId);
1221 
1222         return _tokenApprovals[tokenId];
1223     }
1224 
1225     /**
1226      * @dev See {IERC721-setApprovalForAll}.
1227      */
1228     function setApprovalForAll(address operator, bool approved) public virtual override {
1229         _setApprovalForAll(_msgSender(), operator, approved);
1230     }
1231 
1232     /**
1233      * @dev See {IERC721-isApprovedForAll}.
1234      */
1235     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1236         return _operatorApprovals[owner][operator];
1237     }
1238 
1239     /**
1240      * @dev See {IERC721-transferFrom}.
1241      */
1242     function transferFrom(
1243         address from,
1244         address to,
1245         uint256 tokenId
1246     ) public virtual override {
1247         //solhint-disable-next-line max-line-length
1248         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1249 
1250         _transfer(from, to, tokenId);
1251     }
1252 
1253     /**
1254      * @dev See {IERC721-safeTransferFrom}.
1255      */
1256     function safeTransferFrom(
1257         address from,
1258         address to,
1259         uint256 tokenId
1260     ) public virtual override {
1261         safeTransferFrom(from, to, tokenId, "");
1262     }
1263 
1264     /**
1265      * @dev See {IERC721-safeTransferFrom}.
1266      */
1267     function safeTransferFrom(
1268         address from,
1269         address to,
1270         uint256 tokenId,
1271         bytes memory data
1272     ) public virtual override {
1273         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1274         _safeTransfer(from, to, tokenId, data);
1275     }
1276 
1277     /**
1278      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1279      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1280      *
1281      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1282      *
1283      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1284      * implement alternative mechanisms to perform token transfer, such as signature-based.
1285      *
1286      * Requirements:
1287      *
1288      * - `from` cannot be the zero address.
1289      * - `to` cannot be the zero address.
1290      * - `tokenId` token must exist and be owned by `from`.
1291      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1292      *
1293      * Emits a {Transfer} event.
1294      */
1295     function _safeTransfer(
1296         address from,
1297         address to,
1298         uint256 tokenId,
1299         bytes memory data
1300     ) internal virtual {
1301         _transfer(from, to, tokenId);
1302         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1303     }
1304 
1305     /**
1306      * @dev Returns whether `tokenId` exists.
1307      *
1308      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1309      *
1310      * Tokens start existing when they are minted (`_mint`),
1311      * and stop existing when they are burned (`_burn`).
1312      */
1313     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1314         return _owners[tokenId] != address(0);
1315     }
1316 
1317     /**
1318      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1319      *
1320      * Requirements:
1321      *
1322      * - `tokenId` must exist.
1323      */
1324     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1325         address owner = ERC721.ownerOf(tokenId);
1326         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1327     }
1328 
1329     /**
1330      * @dev Safely mints `tokenId` and transfers it to `to`.
1331      *
1332      * Requirements:
1333      *
1334      * - `tokenId` must not exist.
1335      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1336      *
1337      * Emits a {Transfer} event.
1338      */
1339     function _safeMint(address to, uint256 tokenId) internal virtual {
1340         _safeMint(to, tokenId, "");
1341     }
1342 
1343     /**
1344      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1345      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1346      */
1347     function _safeMint(
1348         address to,
1349         uint256 tokenId,
1350         bytes memory data
1351     ) internal virtual {
1352         _mint(to, tokenId);
1353         require(
1354             _checkOnERC721Received(address(0), to, tokenId, data),
1355             "ERC721: transfer to non ERC721Receiver implementer"
1356         );
1357     }
1358 
1359     /**
1360      * @dev Mints `tokenId` and transfers it to `to`.
1361      *
1362      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1363      *
1364      * Requirements:
1365      *
1366      * - `tokenId` must not exist.
1367      * - `to` cannot be the zero address.
1368      *
1369      * Emits a {Transfer} event.
1370      */
1371     function _mint(address to, uint256 tokenId) internal virtual {
1372         require(to != address(0), "ERC721: mint to the zero address");
1373         require(!_exists(tokenId), "ERC721: token already minted");
1374 
1375         _beforeTokenTransfer(address(0), to, tokenId);
1376 
1377         _balances[to] += 1;
1378         _owners[tokenId] = to;
1379 
1380         emit Transfer(address(0), to, tokenId);
1381 
1382         _afterTokenTransfer(address(0), to, tokenId);
1383     }
1384 
1385     /**
1386      * @dev Destroys `tokenId`.
1387      * The approval is cleared when the token is burned.
1388      *
1389      * Requirements:
1390      *
1391      * - `tokenId` must exist.
1392      *
1393      * Emits a {Transfer} event.
1394      */
1395     function _burn(uint256 tokenId) internal virtual {
1396         address owner = ERC721.ownerOf(tokenId);
1397 
1398         _beforeTokenTransfer(owner, address(0), tokenId);
1399 
1400         // Clear approvals
1401         _approve(address(0), tokenId);
1402 
1403         _balances[owner] -= 1;
1404         delete _owners[tokenId];
1405 
1406         emit Transfer(owner, address(0), tokenId);
1407 
1408         _afterTokenTransfer(owner, address(0), tokenId);
1409     }
1410 
1411     /**
1412      * @dev Transfers `tokenId` from `from` to `to`.
1413      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1414      *
1415      * Requirements:
1416      *
1417      * - `to` cannot be the zero address.
1418      * - `tokenId` token must be owned by `from`.
1419      *
1420      * Emits a {Transfer} event.
1421      */
1422     function _transfer(
1423         address from,
1424         address to,
1425         uint256 tokenId
1426     ) internal virtual {
1427         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1428         require(to != address(0), "ERC721: transfer to the zero address");
1429 
1430         _beforeTokenTransfer(from, to, tokenId);
1431 
1432         // Clear approvals from the previous owner
1433         _approve(address(0), tokenId);
1434 
1435         _balances[from] -= 1;
1436         _balances[to] += 1;
1437         _owners[tokenId] = to;
1438 
1439         emit Transfer(from, to, tokenId);
1440 
1441         _afterTokenTransfer(from, to, tokenId);
1442     }
1443 
1444     /**
1445      * @dev Approve `to` to operate on `tokenId`
1446      *
1447      * Emits an {Approval} event.
1448      */
1449     function _approve(address to, uint256 tokenId) internal virtual {
1450         _tokenApprovals[tokenId] = to;
1451         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1452     }
1453 
1454     /**
1455      * @dev Approve `operator` to operate on all of `owner` tokens
1456      *
1457      * Emits an {ApprovalForAll} event.
1458      */
1459     function _setApprovalForAll(
1460         address owner,
1461         address operator,
1462         bool approved
1463     ) internal virtual {
1464         require(owner != operator, "ERC721: approve to caller");
1465         _operatorApprovals[owner][operator] = approved;
1466         emit ApprovalForAll(owner, operator, approved);
1467     }
1468 
1469     /**
1470      * @dev Reverts if the `tokenId` has not been minted yet.
1471      */
1472     function _requireMinted(uint256 tokenId) internal view virtual {
1473         require(_exists(tokenId), "ERC721: invalid token ID");
1474     }
1475 
1476     /**
1477      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1478      * The call is not executed if the target address is not a contract.
1479      *
1480      * @param from address representing the previous owner of the given token ID
1481      * @param to target address that will receive the tokens
1482      * @param tokenId uint256 ID of the token to be transferred
1483      * @param data bytes optional data to send along with the call
1484      * @return bool whether the call correctly returned the expected magic value
1485      */
1486     function _checkOnERC721Received(
1487         address from,
1488         address to,
1489         uint256 tokenId,
1490         bytes memory data
1491     ) private returns (bool) {
1492         if (to.isContract()) {
1493             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1494                 return retval == IERC721Receiver.onERC721Received.selector;
1495             } catch (bytes memory reason) {
1496                 if (reason.length == 0) {
1497                     revert("ERC721: transfer to non ERC721Receiver implementer");
1498                 } else {
1499                     /// @solidity memory-safe-assembly
1500                     assembly {
1501                         revert(add(32, reason), mload(reason))
1502                     }
1503                 }
1504             }
1505         } else {
1506             return true;
1507         }
1508     }
1509 
1510     /**
1511      * @dev Hook that is called before any token transfer. This includes minting
1512      * and burning.
1513      *
1514      * Calling conditions:
1515      *
1516      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1517      * transferred to `to`.
1518      * - When `from` is zero, `tokenId` will be minted for `to`.
1519      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1520      * - `from` and `to` are never both zero.
1521      *
1522      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1523      */
1524     function _beforeTokenTransfer(
1525         address from,
1526         address to,
1527         uint256 tokenId
1528     ) internal virtual {}
1529 
1530     /**
1531      * @dev Hook that is called after any transfer of tokens. This includes
1532      * minting and burning.
1533      *
1534      * Calling conditions:
1535      *
1536      * - when `from` and `to` are both non-zero.
1537      * - `from` and `to` are never both zero.
1538      *
1539      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1540      */
1541     function _afterTokenTransfer(
1542         address from,
1543         address to,
1544         uint256 tokenId
1545     ) internal virtual {}
1546 }
1547 
1548 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1549 
1550 
1551 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721Burnable.sol)
1552 
1553 pragma solidity ^0.8.0;
1554 
1555 
1556 
1557 /**
1558  * @title ERC721 Burnable Token
1559  * @dev ERC721 Token that can be burned (destroyed).
1560  */
1561 abstract contract ERC721Burnable is Context, ERC721 {
1562     /**
1563      * @dev Burns `tokenId`. See {ERC721-_burn}.
1564      *
1565      * Requirements:
1566      *
1567      * - The caller must own `tokenId` or be an approved operator.
1568      */
1569     function burn(uint256 tokenId) public virtual {
1570         //solhint-disable-next-line max-line-length
1571         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1572         _burn(tokenId);
1573     }
1574 }
1575 
1576 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1577 
1578 
1579 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1580 
1581 pragma solidity ^0.8.0;
1582 
1583 
1584 
1585 /**
1586  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1587  * enumerability of all the token ids in the contract as well as all token ids owned by each
1588  * account.
1589  */
1590 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1591     // Mapping from owner to list of owned token IDs
1592     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1593 
1594     // Mapping from token ID to index of the owner tokens list
1595     mapping(uint256 => uint256) private _ownedTokensIndex;
1596 
1597     // Array with all token ids, used for enumeration
1598     uint256[] private _allTokens;
1599 
1600     // Mapping from token id to position in the allTokens array
1601     mapping(uint256 => uint256) private _allTokensIndex;
1602 
1603     /**
1604      * @dev See {IERC165-supportsInterface}.
1605      */
1606     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1607         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1608     }
1609 
1610     /**
1611      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1612      */
1613     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1614         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1615         return _ownedTokens[owner][index];
1616     }
1617 
1618     /**
1619      * @dev See {IERC721Enumerable-totalSupply}.
1620      */
1621     function totalSupply() public view virtual override returns (uint256) {
1622         return _allTokens.length;
1623     }
1624 
1625     /**
1626      * @dev See {IERC721Enumerable-tokenByIndex}.
1627      */
1628     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1629         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1630         return _allTokens[index];
1631     }
1632 
1633     /**
1634      * @dev Hook that is called before any token transfer. This includes minting
1635      * and burning.
1636      *
1637      * Calling conditions:
1638      *
1639      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1640      * transferred to `to`.
1641      * - When `from` is zero, `tokenId` will be minted for `to`.
1642      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1643      * - `from` cannot be the zero address.
1644      * - `to` cannot be the zero address.
1645      *
1646      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1647      */
1648     function _beforeTokenTransfer(
1649         address from,
1650         address to,
1651         uint256 tokenId
1652     ) internal virtual override {
1653         super._beforeTokenTransfer(from, to, tokenId);
1654 
1655         if (from == address(0)) {
1656             _addTokenToAllTokensEnumeration(tokenId);
1657         } else if (from != to) {
1658             _removeTokenFromOwnerEnumeration(from, tokenId);
1659         }
1660         if (to == address(0)) {
1661             _removeTokenFromAllTokensEnumeration(tokenId);
1662         } else if (to != from) {
1663             _addTokenToOwnerEnumeration(to, tokenId);
1664         }
1665     }
1666 
1667     /**
1668      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1669      * @param to address representing the new owner of the given token ID
1670      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1671      */
1672     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1673         uint256 length = ERC721.balanceOf(to);
1674         _ownedTokens[to][length] = tokenId;
1675         _ownedTokensIndex[tokenId] = length;
1676     }
1677 
1678     /**
1679      * @dev Private function to add a token to this extension's token tracking data structures.
1680      * @param tokenId uint256 ID of the token to be added to the tokens list
1681      */
1682     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1683         _allTokensIndex[tokenId] = _allTokens.length;
1684         _allTokens.push(tokenId);
1685     }
1686 
1687     /**
1688      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1689      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1690      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1691      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1692      * @param from address representing the previous owner of the given token ID
1693      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1694      */
1695     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1696         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1697         // then delete the last slot (swap and pop).
1698 
1699         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1700         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1701 
1702         // When the token to delete is the last token, the swap operation is unnecessary
1703         if (tokenIndex != lastTokenIndex) {
1704             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1705 
1706             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1707             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1708         }
1709 
1710         // This also deletes the contents at the last position of the array
1711         delete _ownedTokensIndex[tokenId];
1712         delete _ownedTokens[from][lastTokenIndex];
1713     }
1714 
1715     /**
1716      * @dev Private function to remove a token from this extension's token tracking data structures.
1717      * This has O(1) time complexity, but alters the order of the _allTokens array.
1718      * @param tokenId uint256 ID of the token to be removed from the tokens list
1719      */
1720     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1721         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1722         // then delete the last slot (swap and pop).
1723 
1724         uint256 lastTokenIndex = _allTokens.length - 1;
1725         uint256 tokenIndex = _allTokensIndex[tokenId];
1726 
1727         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1728         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1729         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1730         uint256 lastTokenId = _allTokens[lastTokenIndex];
1731 
1732         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1733         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1734 
1735         // This also deletes the contents at the last position of the array
1736         delete _allTokensIndex[tokenId];
1737         _allTokens.pop();
1738     }
1739 }
1740 
1741 // File: extensions/operator-filter/ContractAbstract.sol
1742 
1743 
1744 pragma solidity ^0.8.13;
1745 
1746 
1747 
1748 
1749 
1750 /**
1751  * @title  ERC721OnChain
1752  * @notice This example contract is configured to use the DefaultOperatorFilterer, which automatically registers the
1753  *         token and subscribes it to OpenSea's curated filters.
1754  *         Adding the onlyAllowedOperator modifier to the transferFrom and both safeTransferFrom methods ensures that
1755  *         the msg.sender (operator) is allowed by the OperatorFilterRegistry. Adding the onlyAllowedOperatorApproval
1756  *         modifier to the approval methods ensures that owners do not approve operators that are not allowed.
1757  */
1758 abstract contract ERC721OnChain is ERC721Enumerable, DefaultOperatorFilterer, Ownable, ERC721Burnable {
1759     constructor(
1760     string memory _name,
1761     string memory _symbol,
1762     string memory _initBaseURI,
1763     string memory _contractURI
1764   ) ERC721(_name, _symbol) {}
1765 
1766     function setApprovalForAll(address operator, bool approved) public override(ERC721, IERC721) virtual onlyAllowedOperatorApproval(operator) {
1767         super.setApprovalForAll(operator, approved);
1768     }
1769 
1770     function approve(address operator, uint256 tokenId) public override(ERC721, IERC721) virtual onlyAllowedOperatorApproval(operator) {
1771         super.approve(operator, tokenId);
1772     }
1773 
1774     function transferFrom(address from, address to, uint256 tokenId) public override(ERC721, IERC721) virtual onlyAllowedOperator(from) {
1775         super.transferFrom(from, to, tokenId);
1776     }
1777 
1778     function safeTransferFrom(address from, address to, uint256 tokenId) public override(ERC721, IERC721) virtual onlyAllowedOperator(from) {
1779         super.safeTransferFrom(from, to, tokenId);
1780     }
1781 
1782     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1783         public
1784         override(ERC721, IERC721)
1785         virtual
1786         onlyAllowedOperator(from)
1787     {
1788         super.safeTransferFrom(from, to, tokenId, data);
1789     }
1790      
1791     // The following functions are overrides required by Solidity.
1792 
1793     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1794         internal
1795         override(ERC721, ERC721Enumerable)
1796     {
1797         super._beforeTokenTransfer(from, to, tokenId);
1798     }
1799 
1800     function supportsInterface(bytes4 interfaceId)
1801         public
1802         view
1803         override(ERC721, ERC721Enumerable)
1804         returns (bool)
1805     {
1806         return super.supportsInterface(interfaceId);
1807     }
1808 }
1809 // File: contracts/WOM_MERKLE.sol
1810 
1811 
1812 
1813 pragma solidity ^0.8.4;
1814 
1815 
1816 
1817 
1818 
1819 contract WOM is ERC721OnChain {
1820   using Counters for Counters.Counter;
1821   using Strings for uint256;
1822 
1823   Counters.Counter private _tokenIdCounter;
1824 
1825   string public baseURI = "";
1826   string public baseExtension = ".json";
1827   string public customContractURI = "";
1828   uint256 public maxSupply = 1000;
1829   uint256 public maxMintAmount = 2;
1830   uint256 public maxNFTPerAddress = 2;
1831   bool public paused = false;
1832   bool public onlyWhitelisted = true;
1833   mapping(address => uint256) public addressMintedBalance;
1834   bytes32 public merkleRoot = 0x48b73e1b279cf47e870b8ed17a1257ddecd7beb6492cccf15c13f0a7fbea91a8;
1835 
1836   event Sale(
1837     uint256 id,
1838     uint256 cost,
1839     uint256 timestamp,
1840     address indexed buyer,
1841     string indexed tokenURI
1842   );
1843 
1844   struct SaleStruct {
1845     uint256 id;
1846     uint256 cost;
1847     uint256 timestamp;
1848     address buyer;
1849     string metadataURL;
1850   }
1851 
1852   SaleStruct[] minted;
1853 
1854   constructor(
1855     string memory _name,
1856     string memory _symbol,
1857     string memory _initBaseURI,
1858     string memory _contractURI
1859   ) ERC721OnChain(_name, _symbol, _initBaseURI, _contractURI) {
1860     setContractURI(_contractURI);
1861     setBaseURI(_initBaseURI);
1862   }
1863 
1864   // internal
1865   function _baseURI() internal view virtual override returns (string memory) {
1866     return baseURI;
1867   }
1868 
1869   // public
1870   function mint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable {
1871     require(!paused, "the contract is paused");
1872     uint256 supply = totalSupply();
1873     require(_mintAmount > 0, "need to mint at least 1 NFT");
1874     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1875 
1876     if (msg.sender != owner()) {
1877       uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1878       require(ownerMintedCount + _mintAmount <= maxNFTPerAddress, "max NFT per address exceeded");
1879       require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1880 
1881       if(onlyWhitelisted == true) {
1882           require(isWhitelisted(msg.sender, _merkleProof), "user is not whitelisted");
1883       }
1884     }
1885 
1886     for (uint256 i = 1; i <= _mintAmount; i++) {
1887       addressMintedBalance[msg.sender]++;
1888       uint256 tokenId = _tokenIdCounter.current() + 1;
1889       _tokenIdCounter.increment();
1890       _safeMint(msg.sender, tokenId);
1891 
1892       minted.push(
1893         SaleStruct(
1894           tokenId,
1895           msg.value,
1896           block.timestamp,
1897           msg.sender,
1898           tokenURI(tokenId)
1899         )
1900       );
1901       
1902       emit Sale(tokenId, msg.value, block.timestamp, msg.sender, tokenURI(tokenId));
1903     }
1904   }
1905   
1906   function contractURI() public view returns (string memory) {
1907     return customContractURI;
1908   }
1909 
1910   function isWhitelisted(address _user, bytes32[] calldata _merkleProof) public view returns (bool) {
1911     bytes32 leaf = keccak256(abi.encodePacked(_user));
1912     return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
1913   }
1914 
1915   function walletOfOwner(address _owner)
1916     public
1917     view
1918     returns (uint256[] memory)
1919   {
1920     uint256 ownerTokenCount = balanceOf(_owner);
1921     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1922     for (uint256 i; i < ownerTokenCount; i++) {
1923       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1924     }
1925     return tokenIds;
1926   }
1927 
1928   function tokenURI(uint256 tokenId)
1929     public
1930     view
1931     virtual
1932     override
1933     returns (string memory)
1934   {
1935     require(
1936       _exists(tokenId),
1937       "ERC721Metadata: URI query for nonexistent token"
1938     );
1939 
1940     string memory currentBaseURI = _baseURI();
1941     return bytes(currentBaseURI).length > 0
1942       ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1943       : "";
1944   }
1945 
1946   // Getters
1947 
1948   function getAllNFTs() public view onlyOwner returns (SaleStruct[] memory) {
1949     return minted;
1950   }
1951   
1952   function getAnNFT(uint256 tokenId) public view onlyOwner returns (SaleStruct memory) {
1953     return minted[tokenId - 1];
1954   }
1955   
1956   // Setters
1957 
1958   function setMaxMintAmount(uint256 _limit) public onlyOwner {
1959     maxMintAmount = _limit;
1960   }
1961 
1962   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1963     merkleRoot = _merkleRoot;
1964   }
1965   
1966   function setMaxNFTPerAddress(uint256 _limit) public onlyOwner {
1967     maxNFTPerAddress = _limit;
1968   }
1969 
1970   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1971     baseURI = _newBaseURI;
1972   }
1973 
1974   function setContractURI(string memory _newContractURI) public onlyOwner {
1975     customContractURI = _newContractURI;
1976   }
1977 
1978   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1979     baseExtension = _newBaseExtension;
1980   }
1981 
1982   function pause(bool _state) public onlyOwner {
1983     paused = _state;
1984   }
1985   
1986   function setOnlyWhitelisted(bool _state) public onlyOwner {
1987     onlyWhitelisted = _state;
1988   }
1989 
1990   function withdraw() public payable onlyOwner {
1991     // This will payout the contract balance to the owner.
1992     // Do not remove this otherwise you will not be able to withdraw the funds.
1993     // =============================================================================
1994     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1995     assert(os);
1996     // =============================================================================
1997   }
1998 }