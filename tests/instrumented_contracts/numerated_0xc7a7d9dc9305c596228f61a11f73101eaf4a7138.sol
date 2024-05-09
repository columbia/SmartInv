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
216 // File: @openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol
217 
218 
219 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
220 
221 pragma solidity ^0.8.0;
222 
223 /**
224  * @dev String operations.
225  */
226 library StringsUpgradeable {
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
294 // File: @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol
295 
296 
297 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
298 
299 pragma solidity ^0.8.1;
300 
301 /**
302  * @dev Collection of functions related to the address type
303  */
304 library AddressUpgradeable {
305     /**
306      * @dev Returns true if `account` is a contract.
307      *
308      * [IMPORTANT]
309      * ====
310      * It is unsafe to assume that an address for which this function returns
311      * false is an externally-owned account (EOA) and not a contract.
312      *
313      * Among others, `isContract` will return false for the following
314      * types of addresses:
315      *
316      *  - an externally-owned account
317      *  - a contract in construction
318      *  - an address where a contract will be created
319      *  - an address where a contract lived, but was destroyed
320      * ====
321      *
322      * [IMPORTANT]
323      * ====
324      * You shouldn't rely on `isContract` to protect against flash loan attacks!
325      *
326      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
327      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
328      * constructor.
329      * ====
330      */
331     function isContract(address account) internal view returns (bool) {
332         // This method relies on extcodesize/address.code.length, which returns 0
333         // for contracts in construction, since the code is only stored at the end
334         // of the constructor execution.
335 
336         return account.code.length > 0;
337     }
338 
339     /**
340      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
341      * `recipient`, forwarding all available gas and reverting on errors.
342      *
343      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
344      * of certain opcodes, possibly making contracts go over the 2300 gas limit
345      * imposed by `transfer`, making them unable to receive funds via
346      * `transfer`. {sendValue} removes this limitation.
347      *
348      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
349      *
350      * IMPORTANT: because control is transferred to `recipient`, care must be
351      * taken to not create reentrancy vulnerabilities. Consider using
352      * {ReentrancyGuard} or the
353      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
354      */
355     function sendValue(address payable recipient, uint256 amount) internal {
356         require(address(this).balance >= amount, "Address: insufficient balance");
357 
358         (bool success, ) = recipient.call{value: amount}("");
359         require(success, "Address: unable to send value, recipient may have reverted");
360     }
361 
362     /**
363      * @dev Performs a Solidity function call using a low level `call`. A
364      * plain `call` is an unsafe replacement for a function call: use this
365      * function instead.
366      *
367      * If `target` reverts with a revert reason, it is bubbled up by this
368      * function (like regular Solidity function calls).
369      *
370      * Returns the raw returned data. To convert to the expected return value,
371      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
372      *
373      * Requirements:
374      *
375      * - `target` must be a contract.
376      * - calling `target` with `data` must not revert.
377      *
378      * _Available since v3.1._
379      */
380     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
381         return functionCall(target, data, "Address: low-level call failed");
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
386      * `errorMessage` as a fallback revert reason when `target` reverts.
387      *
388      * _Available since v3.1._
389      */
390     function functionCall(
391         address target,
392         bytes memory data,
393         string memory errorMessage
394     ) internal returns (bytes memory) {
395         return functionCallWithValue(target, data, 0, errorMessage);
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
400      * but also transferring `value` wei to `target`.
401      *
402      * Requirements:
403      *
404      * - the calling contract must have an ETH balance of at least `value`.
405      * - the called Solidity function must be `payable`.
406      *
407      * _Available since v3.1._
408      */
409     function functionCallWithValue(
410         address target,
411         bytes memory data,
412         uint256 value
413     ) internal returns (bytes memory) {
414         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
419      * with `errorMessage` as a fallback revert reason when `target` reverts.
420      *
421      * _Available since v3.1._
422      */
423     function functionCallWithValue(
424         address target,
425         bytes memory data,
426         uint256 value,
427         string memory errorMessage
428     ) internal returns (bytes memory) {
429         require(address(this).balance >= value, "Address: insufficient balance for call");
430         require(isContract(target), "Address: call to non-contract");
431 
432         (bool success, bytes memory returndata) = target.call{value: value}(data);
433         return verifyCallResult(success, returndata, errorMessage);
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
438      * but performing a static call.
439      *
440      * _Available since v3.3._
441      */
442     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
443         return functionStaticCall(target, data, "Address: low-level static call failed");
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
448      * but performing a static call.
449      *
450      * _Available since v3.3._
451      */
452     function functionStaticCall(
453         address target,
454         bytes memory data,
455         string memory errorMessage
456     ) internal view returns (bytes memory) {
457         require(isContract(target), "Address: static call to non-contract");
458 
459         (bool success, bytes memory returndata) = target.staticcall(data);
460         return verifyCallResult(success, returndata, errorMessage);
461     }
462 
463     /**
464      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
465      * revert reason using the provided one.
466      *
467      * _Available since v4.3._
468      */
469     function verifyCallResult(
470         bool success,
471         bytes memory returndata,
472         string memory errorMessage
473     ) internal pure returns (bytes memory) {
474         if (success) {
475             return returndata;
476         } else {
477             // Look for revert reason and bubble it up if present
478             if (returndata.length > 0) {
479                 // The easiest way to bubble the revert reason is using memory via assembly
480                 /// @solidity memory-safe-assembly
481                 assembly {
482                     let returndata_size := mload(returndata)
483                     revert(add(32, returndata), returndata_size)
484                 }
485             } else {
486                 revert(errorMessage);
487             }
488         }
489     }
490 }
491 
492 // File: @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol
493 
494 
495 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/utils/Initializable.sol)
496 
497 pragma solidity ^0.8.2;
498 
499 
500 /**
501  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
502  * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
503  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
504  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
505  *
506  * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
507  * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
508  * case an upgrade adds a module that needs to be initialized.
509  *
510  * For example:
511  *
512  * [.hljs-theme-light.nopadding]
513  * ```
514  * contract MyToken is ERC20Upgradeable {
515  *     function initialize() initializer public {
516  *         __ERC20_init("MyToken", "MTK");
517  *     }
518  * }
519  * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
520  *     function initializeV2() reinitializer(2) public {
521  *         __ERC20Permit_init("MyToken");
522  *     }
523  * }
524  * ```
525  *
526  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
527  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
528  *
529  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
530  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
531  *
532  * [CAUTION]
533  * ====
534  * Avoid leaving a contract uninitialized.
535  *
536  * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
537  * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
538  * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
539  *
540  * [.hljs-theme-light.nopadding]
541  * ```
542  * /// @custom:oz-upgrades-unsafe-allow constructor
543  * constructor() {
544  *     _disableInitializers();
545  * }
546  * ```
547  * ====
548  */
549 abstract contract Initializable {
550     /**
551      * @dev Indicates that the contract has been initialized.
552      * @custom:oz-retyped-from bool
553      */
554     uint8 private _initialized;
555 
556     /**
557      * @dev Indicates that the contract is in the process of being initialized.
558      */
559     bool private _initializing;
560 
561     /**
562      * @dev Triggered when the contract has been initialized or reinitialized.
563      */
564     event Initialized(uint8 version);
565 
566     /**
567      * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
568      * `onlyInitializing` functions can be used to initialize parent contracts. Equivalent to `reinitializer(1)`.
569      */
570     modifier initializer() {
571         bool isTopLevelCall = !_initializing;
572         require(
573             (isTopLevelCall && _initialized < 1) || (!AddressUpgradeable.isContract(address(this)) && _initialized == 1),
574             "Initializable: contract is already initialized"
575         );
576         _initialized = 1;
577         if (isTopLevelCall) {
578             _initializing = true;
579         }
580         _;
581         if (isTopLevelCall) {
582             _initializing = false;
583             emit Initialized(1);
584         }
585     }
586 
587     /**
588      * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
589      * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
590      * used to initialize parent contracts.
591      *
592      * `initializer` is equivalent to `reinitializer(1)`, so a reinitializer may be used after the original
593      * initialization step. This is essential to configure modules that are added through upgrades and that require
594      * initialization.
595      *
596      * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
597      * a contract, executing them in the right order is up to the developer or operator.
598      */
599     modifier reinitializer(uint8 version) {
600         require(!_initializing && _initialized < version, "Initializable: contract is already initialized");
601         _initialized = version;
602         _initializing = true;
603         _;
604         _initializing = false;
605         emit Initialized(version);
606     }
607 
608     /**
609      * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
610      * {initializer} and {reinitializer} modifiers, directly or indirectly.
611      */
612     modifier onlyInitializing() {
613         require(_initializing, "Initializable: contract is not initializing");
614         _;
615     }
616 
617     /**
618      * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
619      * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
620      * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
621      * through proxies.
622      */
623     function _disableInitializers() internal virtual {
624         require(!_initializing, "Initializable: contract is initializing");
625         if (_initialized < type(uint8).max) {
626             _initialized = type(uint8).max;
627             emit Initialized(type(uint8).max);
628         }
629     }
630 }
631 
632 // File: @openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol
633 
634 
635 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
636 
637 pragma solidity ^0.8.0;
638 
639 
640 /**
641  * @dev Provides information about the current execution context, including the
642  * sender of the transaction and its data. While these are generally available
643  * via msg.sender and msg.data, they should not be accessed in such a direct
644  * manner, since when dealing with meta-transactions the account sending and
645  * paying for execution may not be the actual sender (as far as an application
646  * is concerned).
647  *
648  * This contract is only required for intermediate, library-like contracts.
649  */
650 abstract contract ContextUpgradeable is Initializable {
651     function __Context_init() internal onlyInitializing {
652     }
653 
654     function __Context_init_unchained() internal onlyInitializing {
655     }
656     function _msgSender() internal view virtual returns (address) {
657         return msg.sender;
658     }
659 
660     function _msgData() internal view virtual returns (bytes calldata) {
661         return msg.data;
662     }
663 
664     /**
665      * @dev This empty reserved space is put in place to allow future versions to add new
666      * variables without shifting down storage in the inheritance chain.
667      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
668      */
669     uint256[50] private __gap;
670 }
671 
672 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
673 
674 
675 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
676 
677 pragma solidity ^0.8.0;
678 
679 /**
680  * @title ERC721 token receiver interface
681  * @dev Interface for any contract that wants to support safeTransfers
682  * from ERC721 asset contracts.
683  */
684 interface IERC721Receiver {
685     /**
686      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
687      * by `operator` from `from`, this function is called.
688      *
689      * It must return its Solidity selector to confirm the token transfer.
690      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
691      *
692      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
693      */
694     function onERC721Received(
695         address operator,
696         address from,
697         uint256 tokenId,
698         bytes calldata data
699     ) external returns (bytes4);
700 }
701 
702 // File: @openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol
703 
704 
705 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
706 
707 pragma solidity ^0.8.0;
708 
709 /**
710  * @dev Interface of the ERC165 standard, as defined in the
711  * https://eips.ethereum.org/EIPS/eip-165[EIP].
712  *
713  * Implementers can declare support of contract interfaces, which can then be
714  * queried by others ({ERC165Checker}).
715  *
716  * For an implementation, see {ERC165}.
717  */
718 interface IERC165Upgradeable {
719     /**
720      * @dev Returns true if this contract implements the interface defined by
721      * `interfaceId`. See the corresponding
722      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
723      * to learn more about how these ids are created.
724      *
725      * This function call must use less than 30 000 gas.
726      */
727     function supportsInterface(bytes4 interfaceId) external view returns (bool);
728 }
729 
730 // File: @openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol
731 
732 
733 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
734 
735 pragma solidity ^0.8.0;
736 
737 
738 
739 /**
740  * @dev Implementation of the {IERC165} interface.
741  *
742  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
743  * for the additional interface id that will be supported. For example:
744  *
745  * ```solidity
746  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
747  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
748  * }
749  * ```
750  *
751  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
752  */
753 abstract contract ERC165Upgradeable is Initializable, IERC165Upgradeable {
754     function __ERC165_init() internal onlyInitializing {
755     }
756 
757     function __ERC165_init_unchained() internal onlyInitializing {
758     }
759     /**
760      * @dev See {IERC165-supportsInterface}.
761      */
762     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
763         return interfaceId == type(IERC165Upgradeable).interfaceId;
764     }
765 
766     /**
767      * @dev This empty reserved space is put in place to allow future versions to add new
768      * variables without shifting down storage in the inheritance chain.
769      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
770      */
771     uint256[50] private __gap;
772 }
773 
774 // File: @openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol
775 
776 
777 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
778 
779 pragma solidity ^0.8.0;
780 
781 
782 /**
783  * @dev Required interface of an ERC721 compliant contract.
784  */
785 interface IERC721Upgradeable is IERC165Upgradeable {
786     /**
787      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
788      */
789     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
790 
791     /**
792      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
793      */
794     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
795 
796     /**
797      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
798      */
799     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
800 
801     /**
802      * @dev Returns the number of tokens in ``owner``'s account.
803      */
804     function balanceOf(address owner) external view returns (uint256 balance);
805 
806     /**
807      * @dev Returns the owner of the `tokenId` token.
808      *
809      * Requirements:
810      *
811      * - `tokenId` must exist.
812      */
813     function ownerOf(uint256 tokenId) external view returns (address owner);
814 
815     /**
816      * @dev Safely transfers `tokenId` token from `from` to `to`.
817      *
818      * Requirements:
819      *
820      * - `from` cannot be the zero address.
821      * - `to` cannot be the zero address.
822      * - `tokenId` token must exist and be owned by `from`.
823      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
824      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
825      *
826      * Emits a {Transfer} event.
827      */
828     function safeTransferFrom(
829         address from,
830         address to,
831         uint256 tokenId,
832         bytes calldata data
833     ) external;
834 
835     /**
836      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
837      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
838      *
839      * Requirements:
840      *
841      * - `from` cannot be the zero address.
842      * - `to` cannot be the zero address.
843      * - `tokenId` token must exist and be owned by `from`.
844      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
845      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
846      *
847      * Emits a {Transfer} event.
848      */
849     function safeTransferFrom(
850         address from,
851         address to,
852         uint256 tokenId
853     ) external;
854 
855     /**
856      * @dev Transfers `tokenId` token from `from` to `to`.
857      *
858      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
859      *
860      * Requirements:
861      *
862      * - `from` cannot be the zero address.
863      * - `to` cannot be the zero address.
864      * - `tokenId` token must be owned by `from`.
865      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
866      *
867      * Emits a {Transfer} event.
868      */
869     function transferFrom(
870         address from,
871         address to,
872         uint256 tokenId
873     ) external;
874 
875     /**
876      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
877      * The approval is cleared when the token is transferred.
878      *
879      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
880      *
881      * Requirements:
882      *
883      * - The caller must own the token or be an approved operator.
884      * - `tokenId` must exist.
885      *
886      * Emits an {Approval} event.
887      */
888     function approve(address to, uint256 tokenId) external;
889 
890     /**
891      * @dev Approve or remove `operator` as an operator for the caller.
892      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
893      *
894      * Requirements:
895      *
896      * - The `operator` cannot be the caller.
897      *
898      * Emits an {ApprovalForAll} event.
899      */
900     function setApprovalForAll(address operator, bool _approved) external;
901 
902     /**
903      * @dev Returns the account approved for `tokenId` token.
904      *
905      * Requirements:
906      *
907      * - `tokenId` must exist.
908      */
909     function getApproved(uint256 tokenId) external view returns (address operator);
910 
911     /**
912      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
913      *
914      * See {setApprovalForAll}
915      */
916     function isApprovedForAll(address owner, address operator) external view returns (bool);
917 }
918 
919 // File: @openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721MetadataUpgradeable.sol
920 
921 
922 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
923 
924 pragma solidity ^0.8.0;
925 
926 
927 /**
928  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
929  * @dev See https://eips.ethereum.org/EIPS/eip-721
930  */
931 interface IERC721MetadataUpgradeable is IERC721Upgradeable {
932     /**
933      * @dev Returns the token collection name.
934      */
935     function name() external view returns (string memory);
936 
937     /**
938      * @dev Returns the token collection symbol.
939      */
940     function symbol() external view returns (string memory);
941 
942     /**
943      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
944      */
945     function tokenURI(uint256 tokenId) external view returns (string memory);
946 }
947 
948 // File: nfa.sol
949 
950 
951 
952 pragma solidity ^0.8.4;
953 
954 
955 
956 
957 
958 
959 
960 
961 
962 
963 error ApprovalCallerNotOwnerNorApproved();
964 error ApprovalQueryForNonexistentToken();
965 error ApproveToCaller();
966 error ApprovalToCurrentOwner();
967 error BalanceQueryForZeroAddress();
968 error MintToZeroAddress();
969 error MintZeroQuantity();
970 error OwnerQueryForNonexistentToken();
971 error TransferCallerNotOwnerNorApproved();
972 error TransferFromIncorrectOwner();
973 error TransferToNonERC721ReceiverImplementer();
974 error TransferToZeroAddress();
975 error URIQueryForNonexistentToken();
976 
977 interface IERC2981Royalties {
978     function royaltyInfo(uint256 _tokenId, uint256 _value)
979         external
980         view
981         returns (address _receiver, uint256 _royaltyAmount);
982 }
983 
984 abstract contract ERC2981PerTokenRoyalties is ERC165Upgradeable, IERC2981Royalties {
985     struct Royalty {
986         address recipient;
987         uint256 value;
988     }
989 
990     mapping(uint256 => Royalty) internal _royalties;
991     address _treasury;
992     uint256 _royaltyFee;
993 
994     /// @dev Sets token royalties
995     /// @param id the token id fir which we register the royalties
996     /// @param recipient recipient of the royalties
997     /// @param value percentage (using 2 decimals - 10000 = 100, 0 = 0)
998     function _setTokenRoyalty(
999         uint256 id,
1000         address recipient,
1001         uint256 value
1002     ) internal {
1003         require(value <= 10000, 'ERC2981Royalties: Too high');
1004 
1005         _royalties[id] = Royalty(recipient, value);
1006     }
1007 
1008     /// @inheritdoc IERC2981Royalties
1009     function royaltyInfo(uint256 tokenId, uint256 value)
1010         external
1011         view
1012         override
1013         returns (address receiver, uint256 royaltyAmount)
1014     {
1015         return (_treasury, (value * _royaltyFee) / 10000);
1016     }
1017 }
1018 
1019 
1020 contract ERC721A is 
1021     Initializable,
1022     ContextUpgradeable,
1023     ERC165Upgradeable,
1024     IERC721Upgradeable,
1025     IERC721MetadataUpgradeable,
1026     ERC2981PerTokenRoyalties {
1027     using AddressUpgradeable for address;
1028     using StringsUpgradeable for uint256;
1029 
1030     // Compiler will pack this into a single 256bit word.
1031     struct TokenOwnership {
1032         // The address of the owner.
1033         address addr;
1034         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1035         uint64 startTimestamp;
1036         // Whether the token has been burned.
1037         bool burned;
1038     }
1039 
1040     // Compiler will pack this into a single 256bit word.
1041     struct AddressData {
1042         // Realistically, 2**64-1 is more than enough.
1043         uint64 balance;
1044         // Keeps track of mint count with minimal overhead for tokenomics.
1045         uint64 numberMinted;
1046         // Keeps track of burn count with minimal overhead for tokenomics.
1047         uint64 numberBurned;
1048         // For miscellaneous variable(s) pertaining to the address
1049         // (e.g. number of whitelist mint slots used).
1050         // If there are multiple variables, please pack them into a uint64.
1051         uint64 aux;
1052     }
1053 
1054     // The tokenId of the next token to be minted.
1055     uint256 internal _currentIndex;
1056 
1057     // The number of tokens burned.
1058     uint256 internal _burnCounter;
1059 
1060     // Token name
1061     string private _name;
1062 
1063     // Token symbol
1064     string private _symbol;
1065 
1066     // Mapping from token ID to ownership details
1067     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1068     mapping(uint256 => TokenOwnership) internal _ownerships;
1069 
1070     // Mapping owner address to address data
1071     mapping(address => AddressData) private _addressData;
1072 
1073     // Mapping from token ID to approved address
1074     mapping(uint256 => address) private _tokenApprovals;
1075 
1076     // Mapping from owner to operator approvals
1077     mapping(address => mapping(address => bool)) private _operatorApprovals;
1078 
1079     constructor(string memory name_, string memory symbol_) {
1080         _name = name_;
1081         _symbol = symbol_;
1082         _currentIndex = _startTokenId();
1083     }
1084 
1085     /**
1086      * To change the starting tokenId, please override this function.
1087      */
1088     function _startTokenId() internal view virtual returns (uint256) {
1089         return 1;
1090     }
1091 
1092     /**
1093      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1094      */
1095     function totalSupply() public view returns (uint256) {
1096         // Counter underflow is impossible as _burnCounter cannot be incremented
1097         // more than _currentIndex - _startTokenId() times
1098         unchecked {
1099             return _currentIndex - _burnCounter - _startTokenId();
1100         }
1101     }
1102 
1103     /**
1104      * Returns the total amount of tokens minted in the contract.
1105      */
1106     function _totalMinted() internal view returns (uint256) {
1107         // Counter underflow is impossible as _currentIndex does not decrement,
1108         // and it is initialized to _startTokenId()
1109         unchecked {
1110             return _currentIndex - _startTokenId();
1111         }
1112     }
1113 
1114     /**
1115      * @dev See {IERC165-supportsInterface}.
1116      */
1117     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165Upgradeable, IERC165Upgradeable) returns (bool) {
1118         return
1119             interfaceId == type(IERC721Upgradeable).interfaceId ||
1120             interfaceId == type(IERC721MetadataUpgradeable).interfaceId ||
1121             super.supportsInterface(interfaceId);
1122     }
1123 
1124     /**
1125      * @dev See {IERC721-balanceOf}.
1126      */
1127     function balanceOf(address owner) public view override returns (uint256) {
1128         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1129         return uint256(_addressData[owner].balance);
1130     }
1131 
1132     /**
1133      * Returns the number of tokens minted by `owner`.
1134      */
1135     function _numberMinted(address owner) internal view returns (uint256) {
1136         return uint256(_addressData[owner].numberMinted);
1137     }
1138 
1139     /**
1140      * Returns the number of tokens burned by or on behalf of `owner`.
1141      */
1142     function _numberBurned(address owner) internal view returns (uint256) {
1143         return uint256(_addressData[owner].numberBurned);
1144     }
1145 
1146     /**
1147      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1148      */
1149     function _getAux(address owner) internal view returns (uint64) {
1150         return _addressData[owner].aux;
1151     }
1152 
1153     /**
1154      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1155      * If there are multiple variables, please pack them into a uint64.
1156      */
1157     function _setAux(address owner, uint64 aux) internal {
1158         _addressData[owner].aux = aux;
1159     }
1160 
1161     /**
1162      * Gas spent here starts off proportional to the maximum mint batch size.
1163      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1164      */
1165     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1166         uint256 curr = tokenId;
1167 
1168         unchecked {
1169             if (_startTokenId() <= curr && curr < _currentIndex) {
1170                 TokenOwnership memory ownership = _ownerships[curr];
1171                 if (!ownership.burned) {
1172                     if (ownership.addr != address(0)) {
1173                         return ownership;
1174                     }
1175                     // Invariant:
1176                     // There will always be an ownership that has an address and is not burned
1177                     // before an ownership that does not have an address and is not burned.
1178                     // Hence, curr will not underflow.
1179                     while (true) {
1180                         curr--;
1181                         ownership = _ownerships[curr];
1182                         if (ownership.addr != address(0)) {
1183                             return ownership;
1184                         }
1185                     }
1186                 }
1187             }
1188         }
1189         revert OwnerQueryForNonexistentToken();
1190     }
1191 
1192     /**
1193      * @dev See {IERC721-ownerOf}.
1194      */
1195     function ownerOf(uint256 tokenId) public view override returns (address) {
1196         return _ownershipOf(tokenId).addr;
1197     }
1198 
1199     /**
1200      * @dev See {IERC721Metadata-name}.
1201      */
1202     function name() public view virtual override returns (string memory) {
1203         return _name;
1204     }
1205 
1206     /**
1207      * @dev See {IERC721Metadata-symbol}.
1208      */
1209     function symbol() public view virtual override returns (string memory) {
1210         return _symbol;
1211     }
1212 
1213     /**
1214      * @dev See {IERC721Metadata-tokenURI}.
1215      */
1216     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1217         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1218 
1219         string memory baseURI = _baseURI();
1220         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1221     }
1222 
1223     /**
1224      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1225      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1226      * by default, can be overriden in child contracts.
1227      */
1228     function _baseURI() internal view virtual returns (string memory) {
1229         return '';
1230     }
1231 
1232     /**
1233      * @dev See {IERC721-approve}.
1234      */
1235     function approve(address to, uint256 tokenId) public override {
1236         address owner = ERC721A.ownerOf(tokenId);
1237         if (to == owner) revert ApprovalToCurrentOwner();
1238 
1239         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1240             revert ApprovalCallerNotOwnerNorApproved();
1241         }
1242 
1243         _approve(to, tokenId, owner);
1244     }
1245 
1246     /**
1247      * @dev See {IERC721-getApproved}.
1248      */
1249     function getApproved(uint256 tokenId) public view override returns (address) {
1250         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1251 
1252         return _tokenApprovals[tokenId];
1253     }
1254 
1255     /**
1256      * @dev See {IERC721-setApprovalForAll}.
1257      */
1258     function setApprovalForAll(address operator, bool approved) public virtual override {
1259         if (operator == _msgSender()) revert ApproveToCaller();
1260 
1261         _operatorApprovals[_msgSender()][operator] = approved;
1262         emit ApprovalForAll(_msgSender(), operator, approved);
1263     }
1264 
1265     /**
1266      * @dev See {IERC721-isApprovedForAll}.
1267      */
1268     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1269         return _operatorApprovals[owner][operator];
1270     }
1271 
1272     /**
1273      * @dev See {IERC721-transferFrom}.
1274      */
1275     function transferFrom(
1276         address from,
1277         address to,
1278         uint256 tokenId
1279     ) public virtual override {
1280         _transfer(from, to, tokenId);
1281     }
1282 
1283     /**
1284      * @dev See {IERC721-safeTransferFrom}.
1285      */
1286     function safeTransferFrom(
1287         address from,
1288         address to,
1289         uint256 tokenId
1290     ) public virtual override {
1291         safeTransferFrom(from, to, tokenId, '');
1292     }
1293 
1294     /**
1295      * @dev See {IERC721-safeTransferFrom}.
1296      */
1297     function safeTransferFrom(
1298         address from,
1299         address to,
1300         uint256 tokenId,
1301         bytes memory _data
1302     ) public virtual override {
1303         _transfer(from, to, tokenId);
1304         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1305             revert TransferToNonERC721ReceiverImplementer();
1306         }
1307     }
1308 
1309     /**
1310      * @dev Returns whether `tokenId` exists.
1311      *
1312      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1313      *
1314      * Tokens start existing when they are minted (`_mint`),
1315      */
1316     function _exists(uint256 tokenId) internal view returns (bool) {
1317         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1318             !_ownerships[tokenId].burned;
1319     }
1320 
1321     function _safeMint(address to, uint256 quantity) internal {
1322         _safeMint(to, quantity, '');
1323     }
1324 
1325     /**
1326      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1327      *
1328      * Requirements:
1329      *
1330      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1331      * - `quantity` must be greater than 0.
1332      *
1333      * Emits a {Transfer} event.
1334      */
1335     function _safeMint(
1336         address to,
1337         uint256 quantity,
1338         bytes memory _data
1339     ) internal {
1340         _mint(to, quantity, _data, true);
1341     }
1342 
1343     /**
1344      * @dev Mints `quantity` tokens and transfers them to `to`.
1345      *
1346      * Requirements:
1347      *
1348      * - `to` cannot be the zero address.
1349      * - `quantity` must be greater than 0.
1350      *
1351      * Emits a {Transfer} event.
1352      */
1353     function _mint(
1354         address to,
1355         uint256 quantity,
1356         bytes memory _data,
1357         bool safe
1358     ) internal {
1359         uint256 startTokenId = _currentIndex;
1360         if (to == address(0)) revert MintToZeroAddress();
1361         if (quantity == 0) revert MintZeroQuantity();
1362 
1363         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1364 
1365         // Overflows are incredibly unrealistic.
1366         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1367         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1368         unchecked {
1369             _addressData[to].balance += uint64(quantity);
1370             _addressData[to].numberMinted += uint64(quantity);
1371 
1372             _ownerships[startTokenId].addr = to;
1373             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1374 
1375             uint256 updatedIndex = startTokenId;
1376             uint256 end = updatedIndex + quantity;
1377 
1378             if (safe && to.isContract()) {
1379                 do {
1380                     emit Transfer(address(0), to, updatedIndex);
1381                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1382                         revert TransferToNonERC721ReceiverImplementer();
1383                     }
1384                 } while (updatedIndex != end);
1385                 // Reentrancy protection
1386                 if (_currentIndex != startTokenId) revert();
1387             } else {
1388                 do {
1389                     emit Transfer(address(0), to, updatedIndex++);
1390                 } while (updatedIndex != end);
1391             }
1392             _currentIndex = updatedIndex;
1393         }
1394         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1395     }
1396 
1397     /**
1398      * @dev Transfers `tokenId` from `from` to `to`.
1399      *
1400      * Requirements:
1401      *
1402      * - `to` cannot be the zero address.
1403      * - `tokenId` token must be owned by `from`.
1404      *
1405      * Emits a {Transfer} event.
1406      */
1407     function _transfer(
1408         address from,
1409         address to,
1410         uint256 tokenId
1411     ) private {
1412         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1413 
1414         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1415 
1416         bool isApprovedOrOwner = (_msgSender() == from ||
1417             isApprovedForAll(from, _msgSender()) ||
1418             getApproved(tokenId) == _msgSender());
1419 
1420         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1421         if (to == address(0)) revert TransferToZeroAddress();
1422 
1423         _beforeTokenTransfers(from, to, tokenId, 1);
1424 
1425         // Clear approvals from the previous owner
1426         _approve(address(0), tokenId, from);
1427 
1428         // Underflow of the sender's balance is impossible because we check for
1429         // ownership above and the recipient's balance can't realistically overflow.
1430         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1431         unchecked {
1432             _addressData[from].balance -= 1;
1433             _addressData[to].balance += 1;
1434 
1435             TokenOwnership storage currSlot = _ownerships[tokenId];
1436             currSlot.addr = to;
1437             currSlot.startTimestamp = uint64(block.timestamp);
1438 
1439             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1440             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1441             uint256 nextTokenId = tokenId + 1;
1442             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1443             if (nextSlot.addr == address(0)) {
1444                 // This will suffice for checking _exists(nextTokenId),
1445                 // as a burned slot cannot contain the zero address.
1446                 if (nextTokenId != _currentIndex) {
1447                     nextSlot.addr = from;
1448                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1449                 }
1450             }
1451         }
1452 
1453         emit Transfer(from, to, tokenId);
1454         _afterTokenTransfers(from, to, tokenId, 1);
1455     }
1456 
1457     /**
1458      * @dev This is equivalent to _burn(tokenId, false)
1459      */
1460     function _burn(uint256 tokenId) internal virtual {
1461         _burn(tokenId, false);
1462     }
1463 
1464     /**
1465      * @dev Destroys `tokenId`.
1466      * The approval is cleared when the token is burned.
1467      *
1468      * Requirements:
1469      *
1470      * - `tokenId` must exist.
1471      *
1472      * Emits a {Transfer} event.
1473      */
1474     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1475         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1476 
1477         address from = prevOwnership.addr;
1478 
1479         if (approvalCheck) {
1480             bool isApprovedOrOwner = (_msgSender() == from ||
1481                 isApprovedForAll(from, _msgSender()) ||
1482                 getApproved(tokenId) == _msgSender());
1483 
1484             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1485         }
1486 
1487         _beforeTokenTransfers(from, address(0), tokenId, 1);
1488 
1489         // Clear approvals from the previous owner
1490         _approve(address(0), tokenId, from);
1491 
1492         // Underflow of the sender's balance is impossible because we check for
1493         // ownership above and the recipient's balance can't realistically overflow.
1494         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1495         unchecked {
1496             AddressData storage addressData = _addressData[from];
1497             addressData.balance -= 1;
1498             addressData.numberBurned += 1;
1499 
1500             // Keep track of who burned the token, and the timestamp of burning.
1501             TokenOwnership storage currSlot = _ownerships[tokenId];
1502             currSlot.addr = from;
1503             currSlot.startTimestamp = uint64(block.timestamp);
1504             currSlot.burned = true;
1505 
1506             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1507             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1508             uint256 nextTokenId = tokenId + 1;
1509             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1510             if (nextSlot.addr == address(0)) {
1511                 // This will suffice for checking _exists(nextTokenId),
1512                 // as a burned slot cannot contain the zero address.
1513                 if (nextTokenId != _currentIndex) {
1514                     nextSlot.addr = from;
1515                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1516                 }
1517             }
1518         }
1519 
1520         emit Transfer(from, address(0), tokenId);
1521         _afterTokenTransfers(from, address(0), tokenId, 1);
1522 
1523         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1524         unchecked {
1525             _burnCounter++;
1526         }
1527     }
1528 
1529     /**
1530      * @dev Approve `to` to operate on `tokenId`
1531      *
1532      * Emits a {Approval} event.
1533      */
1534     function _approve(
1535         address to,
1536         uint256 tokenId,
1537         address owner
1538     ) private {
1539         _tokenApprovals[tokenId] = to;
1540         emit Approval(owner, to, tokenId);
1541     }
1542 
1543     /**
1544      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1545      *
1546      * @param from address representing the previous owner of the given token ID
1547      * @param to target address that will receive the tokens
1548      * @param tokenId uint256 ID of the token to be transferred
1549      * @param _data bytes optional data to send along with the call
1550      * @return bool whether the call correctly returned the expected magic value
1551      */
1552     function _checkContractOnERC721Received(
1553         address from,
1554         address to,
1555         uint256 tokenId,
1556         bytes memory _data
1557     ) private returns (bool) {
1558         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1559             return retval == IERC721Receiver(to).onERC721Received.selector;
1560         } catch (bytes memory reason) {
1561             if (reason.length == 0) {
1562                 revert TransferToNonERC721ReceiverImplementer();
1563             } else {
1564                 assembly {
1565                     revert(add(32, reason), mload(reason))
1566                 }
1567             }
1568         }
1569     }
1570 
1571     /**
1572      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1573      * And also called before burning one token.
1574      *
1575      * startTokenId - the first token id to be transferred
1576      * quantity - the amount to be transferred
1577      *
1578      * Calling conditions:
1579      *
1580      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1581      * transferred to `to`.
1582      * - When `from` is zero, `tokenId` will be minted for `to`.
1583      * - When `to` is zero, `tokenId` will be burned by `from`.
1584      * - `from` and `to` are never both zero.
1585      */
1586     function _beforeTokenTransfers(
1587         address from,
1588         address to,
1589         uint256 startTokenId,
1590         uint256 quantity
1591     ) internal virtual {}
1592 
1593     /**
1594      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1595      * minting.
1596      * And also called after one token has been burned.
1597      *
1598      * startTokenId - the first token id to be transferred
1599      * quantity - the amount to be transferred
1600      *
1601      * Calling conditions:
1602      *
1603      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1604      * transferred to `to`.
1605      * - When `from` is zero, `tokenId` has been minted for `to`.
1606      * - When `to` is zero, `tokenId` has been burned by `from`.
1607      * - `from` and `to` are never both zero.
1608      */
1609     function _afterTokenTransfers(
1610         address from,
1611         address to,
1612         uint256 startTokenId,
1613         uint256 quantity
1614     ) internal virtual {}
1615 }
1616 
1617 contract NFA is Initializable, ERC721A{
1618     using StringsUpgradeable for uint256;
1619     
1620     address private _owner;
1621     string  _mainURI;
1622     bool private _isMint;
1623     bool private _isPublic;
1624     bytes32 public _merkleRoot = "";
1625     uint private _wlCount;
1626     uint private _totalCount;
1627     string private _contractURI;
1628 
1629 
1630     mapping(address => uint256) public minted;
1631     
1632     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1633     
1634     constructor(string memory _name, string memory _symbol, string memory _mUri) ERC721A(_name, _symbol){
1635         _treasury = msg.sender;
1636         _royaltyFee = 1000; //10%
1637         _owner = msg.sender;
1638         _mainURI = _mUri;
1639     }
1640 
1641     function changeMintStatus(bool _status) external onlyOwner{
1642     	require(_status != _isMint,'Mint already in same status');
1643     	_isMint = _status;
1644     }
1645 
1646     function changePublicStatus(bool _status) external onlyOwner{
1647     	require(_status != _isPublic,'isPublic already in same status');
1648     	_isPublic = _status;
1649     }
1650 
1651     function rdata(address _royltyAddr, uint256 _per) external onlyOwner{
1652     	_treasury = _royltyAddr;
1653         _royaltyFee = _per;
1654     }
1655 
1656     function updateRoot(bytes32 _root) external onlyOwner{
1657     	_merkleRoot = _root;
1658     }
1659     
1660     modifier onlyOwner{
1661         require(msg.sender == _owner, 'Only Owner');
1662         _;
1663     }
1664     
1665     function transferOwnership(address newOwner) external virtual onlyOwner {
1666         require(newOwner != address(0), "00");
1667         emit OwnershipTransferred(_owner, newOwner);
1668         _owner = newOwner;
1669     }
1670 
1671     function updateMainURI(string memory _mainuri) external virtual onlyOwner {
1672         _mainURI = _mainuri;
1673     }
1674 
1675     function updateContractURI(string memory _curi) external virtual onlyOwner {
1676         _contractURI = _curi;
1677     }
1678     
1679     function whitelistMint(bytes32[] calldata _merkleProof, uint256 _quantity) external {
1680     	require(_isMint, "Currently Minting Is Off");
1681         require(!_isPublic,"Whitelist Ended");
1682         require(_totalCount+_quantity <= 5555,"END");
1683         require(minted[msg.sender]+_quantity <= 3,"END");
1684         require(_wlCount+_quantity < 3000, "Completed");
1685         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1686         require(MerkleProof.verify(_merkleProof,_merkleRoot, leaf),"Not WL");
1687         _safeMint(msg.sender, _quantity);
1688         _wlCount+= _quantity;
1689         minted[msg.sender] += _quantity;
1690         _totalCount += _quantity;
1691     }
1692 
1693     function publicMint(uint256 _quantity) external{
1694         require(_isMint, "mint off");
1695         require(_isPublic, "public not live");
1696         require(_totalCount+_quantity <= 5555,"END");
1697         require(minted[msg.sender]+_quantity <= 2, "Limit Exceed" );
1698         _safeMint(msg.sender, _quantity);
1699         minted[msg.sender] += _quantity;
1700         _totalCount += _quantity;
1701     }
1702 
1703     function bulkMint(uint256 _quantity) external onlyOwner{
1704         require(_isMint, "Currently Minting Is Off");
1705         require(_totalCount+_quantity <= 5555,"END");
1706         _safeMint(msg.sender, _quantity);
1707         _totalCount += _quantity;
1708     }
1709 
1710     function withdrawTreasury() external onlyOwner{
1711         (bool success, ) = _treasury.call{value: address(this).balance}("");
1712         require(success, "Failed Tx");
1713     }
1714     
1715     function bulkTransfer(address[] memory to, uint[] memory tokenIds) external virtual{
1716         require( to.length == tokenIds.length, "Lenght not matched, Invalid Format");
1717         require( to.length <= 400, "You can transfer max 400 tokens");
1718         for(uint i = 0; i < to.length; i++){
1719             safeTransferFrom(msg.sender, to[i], tokenIds[i]);
1720         }
1721     }
1722     
1723     function multiSendTokens(address to, uint[] memory tokenIds) external virtual{
1724         require( tokenIds.length <= 400, "You can transfer max 400 tokens");
1725         for(uint i = 0; i < tokenIds.length; i++){
1726             safeTransferFrom(msg.sender, to, tokenIds[i]);
1727         }
1728     }
1729 
1730     function baseURI() external view returns (string memory) {
1731         return _mainURI;
1732     }
1733 
1734     function contractURI() external view returns (string memory){
1735         return _contractURI;
1736     }
1737     
1738     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1739         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1740         return string(abi.encodePacked(_mainURI,tokenId.toString(),".json"));
1741     }
1742 }