1 // SPDX-License-Identifier: MIT
2 // .----------------.  .----------------.  .----------------.  .-----------------. .----------------.  .----------------.  .----------------.  .----------------.  .----------------. 
3 // | .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |
4 // | |  _________   | || |     ____     | || |     ____     | || | ____  _____  | || | ____   ____  | || |  _________   | || |  _______     | || |    _______   | || |  _________   | |
5 // | | |  _   _  |  | || |   .'    `.   | || |   .'    `.   | || ||_   \|_   _| | || ||_  _| |_  _| | || | |_   ___  |  | || | |_   __ \    | || |   /  ___  |  | || | |_   ___  |  | |
6 // | | |_/ | | \_|  | || |  /  .--.  \  | || |  /  .--.  \  | || |  |   \ | |   | || |  \ \   / /   | || |   | |_  \_|  | || |   | |__) |   | || |  |  (__ \_|  | || |   | |_  \_|  | |
7 // | |     | |      | || |  | |    | |  | || |  | |    | |  | || |  | |\ \| |   | || |   \ \ / /    | || |   |  _|  _   | || |   |  __ /    | || |   '.___`-.   | || |   |  _|  _   | |
8 // | |    _| |_     | || |  \  `--'  /  | || |  \  `--'  /  | || | _| |_\   |_  | || |    \ ' /     | || |  _| |___/ |  | || |  _| |  \ \_  | || |  |`\____) |  | || |  _| |___/ |  | |
9 // | |   |_____|    | || |   `.____.'   | || |   `.____.'   | || ||_____|\____| | || |     \_/      | || | |_________|  | || | |____| |___| | || |  |_______.'  | || | |_________|  | |
10 // | |              | || |              | || |              | || |              | || |              | || |              | || |              | || |              | || |              | |
11 // | '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |
12 //  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------' 
13 //2022 - © Toonverse - All Rights Reserved
14 //https://www.toonversestudios.com/
15 
16 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/MerkleProof.sol
17 
18 
19 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
20 
21 pragma solidity ^0.8.0;
22 
23 /**
24  * @dev These functions deal with verification of Merkle Tree proofs.
25  *
26  * The proofs can be generated using the JavaScript library
27  * https://github.com/miguelmota/merkletreejs[merkletreejs].
28  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
29  *
30  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
31  *
32  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
33  * hashing, or use a hash function other than keccak256 for hashing leaves.
34  * This is because the concatenation of a sorted pair of internal nodes in
35  * the merkle tree could be reinterpreted as a leaf value.
36  */
37 library MerkleProof {
38     /**
39      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
40      * defined by `root`. For this, a `proof` must be provided, containing
41      * sibling hashes on the branch from the leaf to the root of the tree. Each
42      * pair of leaves and each pair of pre-images are assumed to be sorted.
43      */
44     function verify(
45         bytes32[] memory proof,
46         bytes32 root,
47         bytes32 leaf
48     ) internal pure returns (bool) {
49         return processProof(proof, leaf) == root;
50     }
51 
52     /**
53      * @dev Calldata version of {verify}
54      *
55      * _Available since v4.7._
56      */
57     function verifyCalldata(
58         bytes32[] calldata proof,
59         bytes32 root,
60         bytes32 leaf
61     ) internal pure returns (bool) {
62         return processProofCalldata(proof, leaf) == root;
63     }
64 
65     /**
66      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
67      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
68      * hash matches the root of the tree. When processing the proof, the pairs
69      * of leafs & pre-images are assumed to be sorted.
70      *
71      * _Available since v4.4._
72      */
73     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
74         bytes32 computedHash = leaf;
75         for (uint256 i = 0; i < proof.length; i++) {
76             computedHash = _hashPair(computedHash, proof[i]);
77         }
78         return computedHash;
79     }
80 
81     /**
82      * @dev Calldata version of {processProof}
83      *
84      * _Available since v4.7._
85      */
86     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
87         bytes32 computedHash = leaf;
88         for (uint256 i = 0; i < proof.length; i++) {
89             computedHash = _hashPair(computedHash, proof[i]);
90         }
91         return computedHash;
92     }
93 
94     /**
95      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
96      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
97      *
98      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
99      *
100      * _Available since v4.7._
101      */
102     function multiProofVerify(
103         bytes32[] memory proof,
104         bool[] memory proofFlags,
105         bytes32 root,
106         bytes32[] memory leaves
107     ) internal pure returns (bool) {
108         return processMultiProof(proof, proofFlags, leaves) == root;
109     }
110 
111     /**
112      * @dev Calldata version of {multiProofVerify}
113      *
114      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
115      *
116      * _Available since v4.7._
117      */
118     function multiProofVerifyCalldata(
119         bytes32[] calldata proof,
120         bool[] calldata proofFlags,
121         bytes32 root,
122         bytes32[] memory leaves
123     ) internal pure returns (bool) {
124         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
125     }
126 
127     /**
128      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
129      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
130      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
131      * respectively.
132      *
133      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
134      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
135      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
136      *
137      * _Available since v4.7._
138      */
139     function processMultiProof(
140         bytes32[] memory proof,
141         bool[] memory proofFlags,
142         bytes32[] memory leaves
143     ) internal pure returns (bytes32 merkleRoot) {
144         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
145         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
146         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
147         // the merkle tree.
148         uint256 leavesLen = leaves.length;
149         uint256 totalHashes = proofFlags.length;
150 
151         // Check proof validity.
152         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
153 
154         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
155         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
156         bytes32[] memory hashes = new bytes32[](totalHashes);
157         uint256 leafPos = 0;
158         uint256 hashPos = 0;
159         uint256 proofPos = 0;
160         // At each step, we compute the next hash using two values:
161         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
162         //   get the next hash.
163         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
164         //   `proof` array.
165         for (uint256 i = 0; i < totalHashes; i++) {
166             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
167             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
168             hashes[i] = _hashPair(a, b);
169         }
170 
171         if (totalHashes > 0) {
172             return hashes[totalHashes - 1];
173         } else if (leavesLen > 0) {
174             return leaves[0];
175         } else {
176             return proof[0];
177         }
178     }
179 
180     /**
181      * @dev Calldata version of {processMultiProof}.
182      *
183      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
184      *
185      * _Available since v4.7._
186      */
187     function processMultiProofCalldata(
188         bytes32[] calldata proof,
189         bool[] calldata proofFlags,
190         bytes32[] memory leaves
191     ) internal pure returns (bytes32 merkleRoot) {
192         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
193         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
194         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
195         // the merkle tree.
196         uint256 leavesLen = leaves.length;
197         uint256 totalHashes = proofFlags.length;
198 
199         // Check proof validity.
200         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
201 
202         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
203         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
204         bytes32[] memory hashes = new bytes32[](totalHashes);
205         uint256 leafPos = 0;
206         uint256 hashPos = 0;
207         uint256 proofPos = 0;
208         // At each step, we compute the next hash using two values:
209         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
210         //   get the next hash.
211         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
212         //   `proof` array.
213         for (uint256 i = 0; i < totalHashes; i++) {
214             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
215             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
216             hashes[i] = _hashPair(a, b);
217         }
218 
219         if (totalHashes > 0) {
220             return hashes[totalHashes - 1];
221         } else if (leavesLen > 0) {
222             return leaves[0];
223         } else {
224             return proof[0];
225         }
226     }
227 
228     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
229         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
230     }
231 
232     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
233         /// @solidity memory-safe-assembly
234         assembly {
235             mstore(0x00, a)
236             mstore(0x20, b)
237             value := keccak256(0x00, 0x40)
238         }
239     }
240 }
241 
242 // File: @openzeppelin/contracts/utils/Strings.sol
243 
244 
245 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
246 
247 pragma solidity ^0.8.0;
248 
249 /**
250  * @dev String operations.
251  */
252 library Strings {
253     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
254     uint8 private constant _ADDRESS_LENGTH = 20;
255 
256     /**
257      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
258      */
259     function toString(uint256 value) internal pure returns (string memory) {
260         // Inspired by OraclizeAPI's implementation - MIT licence
261         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
262 
263         if (value == 0) {
264             return "0";
265         }
266         uint256 temp = value;
267         uint256 digits;
268         while (temp != 0) {
269             digits++;
270             temp /= 10;
271         }
272         bytes memory buffer = new bytes(digits);
273         while (value != 0) {
274             digits -= 1;
275             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
276             value /= 10;
277         }
278         return string(buffer);
279     }
280 
281     /**
282      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
283      */
284     function toHexString(uint256 value) internal pure returns (string memory) {
285         if (value == 0) {
286             return "0x00";
287         }
288         uint256 temp = value;
289         uint256 length = 0;
290         while (temp != 0) {
291             length++;
292             temp >>= 8;
293         }
294         return toHexString(value, length);
295     }
296 
297     /**
298      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
299      */
300     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
301         bytes memory buffer = new bytes(2 * length + 2);
302         buffer[0] = "0";
303         buffer[1] = "x";
304         for (uint256 i = 2 * length + 1; i > 1; --i) {
305             buffer[i] = _HEX_SYMBOLS[value & 0xf];
306             value >>= 4;
307         }
308         require(value == 0, "Strings: hex length insufficient");
309         return string(buffer);
310     }
311 
312     /**
313      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
314      */
315     function toHexString(address addr) internal pure returns (string memory) {
316         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
317     }
318 }
319 
320 // File: @openzeppelin/contracts/utils/Context.sol
321 
322 
323 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
324 
325 pragma solidity ^0.8.0;
326 
327 /**
328  * @dev Provides information about the current execution context, including the
329  * sender of the transaction and its data. While these are generally available
330  * via msg.sender and msg.data, they should not be accessed in such a direct
331  * manner, since when dealing with meta-transactions the account sending and
332  * paying for execution may not be the actual sender (as far as an application
333  * is concerned).
334  *
335  * This contract is only required for intermediate, library-like contracts.
336  */
337 abstract contract Context {
338     function _msgSender() internal view virtual returns (address) {
339         return msg.sender;
340     }
341 
342     function _msgData() internal view virtual returns (bytes calldata) {
343         return msg.data;
344     }
345 }
346 
347 // File: @openzeppelin/contracts/access/Ownable.sol
348 
349 
350 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
351 
352 pragma solidity ^0.8.0;
353 
354 
355 /**
356  * @dev Contract module which provides a basic access control mechanism, where
357  * there is an account (an owner) that can be granted exclusive access to
358  * specific functions.
359  *
360  * By default, the owner account will be the one that deploys the contract. This
361  * can later be changed with {transferOwnership}.
362  *
363  * This module is used through inheritance. It will make available the modifier
364  * `onlyOwner`, which can be applied to your functions to restrict their use to
365  * the owner.
366  */
367 abstract contract Ownable is Context {
368     address private _owner;
369 
370     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
371 
372     /**
373      * @dev Initializes the contract setting the deployer as the initial owner.
374      */
375     constructor() {
376         _transferOwnership(_msgSender());
377     }
378 
379     /**
380      * @dev Throws if called by any account other than the owner.
381      */
382     modifier onlyOwner() {
383         _checkOwner();
384         _;
385     }
386 
387     /**
388      * @dev Returns the address of the current owner.
389      */
390     function owner() public view virtual returns (address) {
391         return _owner;
392     }
393 
394     /**
395      * @dev Throws if the sender is not the owner.
396      */
397     function _checkOwner() internal view virtual {
398         require(owner() == _msgSender(), "Ownable: caller is not the owner");
399     }
400 
401     /**
402      * @dev Leaves the contract without owner. It will not be possible to call
403      * `onlyOwner` functions anymore. Can only be called by the current owner.
404      *
405      * NOTE: Renouncing ownership will leave the contract without an owner,
406      * thereby removing any functionality that is only available to the owner.
407      */
408     function renounceOwnership() public virtual onlyOwner {
409         _transferOwnership(address(0));
410     }
411 
412     /**
413      * @dev Transfers ownership of the contract to a new account (`newOwner`).
414      * Can only be called by the current owner.
415      */
416     function transferOwnership(address newOwner) public virtual onlyOwner {
417         require(newOwner != address(0), "Ownable: new owner is the zero address");
418         _transferOwnership(newOwner);
419     }
420 
421     /**
422      * @dev Transfers ownership of the contract to a new account (`newOwner`).
423      * Internal function without access restriction.
424      */
425     function _transferOwnership(address newOwner) internal virtual {
426         address oldOwner = _owner;
427         _owner = newOwner;
428         emit OwnershipTransferred(oldOwner, newOwner);
429     }
430 }
431 
432 // File: @openzeppelin/contracts/utils/Address.sol
433 
434 
435 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
436 
437 pragma solidity ^0.8.1;
438 
439 /**
440  * @dev Collection of functions related to the address type
441  */
442 library Address {
443     /**
444      * @dev Returns true if `account` is a contract.
445      *
446      * [IMPORTANT]
447      * ====
448      * It is unsafe to assume that an address for which this function returns
449      * false is an externally-owned account (EOA) and not a contract.
450      *
451      * Among others, `isContract` will return false for the following
452      * types of addresses:
453      *
454      *  - an externally-owned account
455      *  - a contract in construction
456      *  - an address where a contract will be created
457      *  - an address where a contract lived, but was destroyed
458      * ====
459      *
460      * [IMPORTANT]
461      * ====
462      * You shouldn't rely on `isContract` to protect against flash loan attacks!
463      *
464      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
465      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
466      * constructor.
467      * ====
468      */
469     function isContract(address account) internal view returns (bool) {
470         // This method relies on extcodesize/address.code.length, which returns 0
471         // for contracts in construction, since the code is only stored at the end
472         // of the constructor execution.
473 
474         return account.code.length > 0;
475     }
476 
477     /**
478      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
479      * `recipient`, forwarding all available gas and reverting on errors.
480      *
481      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
482      * of certain opcodes, possibly making contracts go over the 2300 gas limit
483      * imposed by `transfer`, making them unable to receive funds via
484      * `transfer`. {sendValue} removes this limitation.
485      *
486      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
487      *
488      * IMPORTANT: because control is transferred to `recipient`, care must be
489      * taken to not create reentrancy vulnerabilities. Consider using
490      * {ReentrancyGuard} or the
491      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
492      */
493     function sendValue(address payable recipient, uint256 amount) internal {
494         require(address(this).balance >= amount, "Address: insufficient balance");
495 
496         (bool success, ) = recipient.call{value: amount}("");
497         require(success, "Address: unable to send value, recipient may have reverted");
498     }
499 
500     /**
501      * @dev Performs a Solidity function call using a low level `call`. A
502      * plain `call` is an unsafe replacement for a function call: use this
503      * function instead.
504      *
505      * If `target` reverts with a revert reason, it is bubbled up by this
506      * function (like regular Solidity function calls).
507      *
508      * Returns the raw returned data. To convert to the expected return value,
509      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
510      *
511      * Requirements:
512      *
513      * - `target` must be a contract.
514      * - calling `target` with `data` must not revert.
515      *
516      * _Available since v3.1._
517      */
518     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
519         return functionCall(target, data, "Address: low-level call failed");
520     }
521 
522     /**
523      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
524      * `errorMessage` as a fallback revert reason when `target` reverts.
525      *
526      * _Available since v3.1._
527      */
528     function functionCall(
529         address target,
530         bytes memory data,
531         string memory errorMessage
532     ) internal returns (bytes memory) {
533         return functionCallWithValue(target, data, 0, errorMessage);
534     }
535 
536     /**
537      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
538      * but also transferring `value` wei to `target`.
539      *
540      * Requirements:
541      *
542      * - the calling contract must have an ETH balance of at least `value`.
543      * - the called Solidity function must be `payable`.
544      *
545      * _Available since v3.1._
546      */
547     function functionCallWithValue(
548         address target,
549         bytes memory data,
550         uint256 value
551     ) internal returns (bytes memory) {
552         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
553     }
554 
555     /**
556      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
557      * with `errorMessage` as a fallback revert reason when `target` reverts.
558      *
559      * _Available since v3.1._
560      */
561     function functionCallWithValue(
562         address target,
563         bytes memory data,
564         uint256 value,
565         string memory errorMessage
566     ) internal returns (bytes memory) {
567         require(address(this).balance >= value, "Address: insufficient balance for call");
568         require(isContract(target), "Address: call to non-contract");
569 
570         (bool success, bytes memory returndata) = target.call{value: value}(data);
571         return verifyCallResult(success, returndata, errorMessage);
572     }
573 
574     /**
575      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
576      * but performing a static call.
577      *
578      * _Available since v3.3._
579      */
580     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
581         return functionStaticCall(target, data, "Address: low-level static call failed");
582     }
583 
584     /**
585      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
586      * but performing a static call.
587      *
588      * _Available since v3.3._
589      */
590     function functionStaticCall(
591         address target,
592         bytes memory data,
593         string memory errorMessage
594     ) internal view returns (bytes memory) {
595         require(isContract(target), "Address: static call to non-contract");
596 
597         (bool success, bytes memory returndata) = target.staticcall(data);
598         return verifyCallResult(success, returndata, errorMessage);
599     }
600 
601     /**
602      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
603      * but performing a delegate call.
604      *
605      * _Available since v3.4._
606      */
607     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
608         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
609     }
610 
611     /**
612      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
613      * but performing a delegate call.
614      *
615      * _Available since v3.4._
616      */
617     function functionDelegateCall(
618         address target,
619         bytes memory data,
620         string memory errorMessage
621     ) internal returns (bytes memory) {
622         require(isContract(target), "Address: delegate call to non-contract");
623 
624         (bool success, bytes memory returndata) = target.delegatecall(data);
625         return verifyCallResult(success, returndata, errorMessage);
626     }
627 
628     /**
629      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
630      * revert reason using the provided one.
631      *
632      * _Available since v4.3._
633      */
634     function verifyCallResult(
635         bool success,
636         bytes memory returndata,
637         string memory errorMessage
638     ) internal pure returns (bytes memory) {
639         if (success) {
640             return returndata;
641         } else {
642             // Look for revert reason and bubble it up if present
643             if (returndata.length > 0) {
644                 // The easiest way to bubble the revert reason is using memory via assembly
645                 /// @solidity memory-safe-assembly
646                 assembly {
647                     let returndata_size := mload(returndata)
648                     revert(add(32, returndata), returndata_size)
649                 }
650             } else {
651                 revert(errorMessage);
652             }
653         }
654     }
655 }
656 
657 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
658 
659 
660 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
661 
662 pragma solidity ^0.8.0;
663 
664 /**
665  * @title ERC721 token receiver interface
666  * @dev Interface for any contract that wants to support safeTransfers
667  * from ERC721 asset contracts.
668  */
669 interface IERC721Receiver {
670     /**
671      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
672      * by `operator` from `from`, this function is called.
673      *
674      * It must return its Solidity selector to confirm the token transfer.
675      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
676      *
677      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
678      */
679     function onERC721Received(
680         address operator,
681         address from,
682         uint256 tokenId,
683         bytes calldata data
684     ) external returns (bytes4);
685 }
686 
687 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
688 
689 
690 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
691 
692 pragma solidity ^0.8.0;
693 
694 /**
695  * @dev Interface of the ERC165 standard, as defined in the
696  * https://eips.ethereum.org/EIPS/eip-165[EIP].
697  *
698  * Implementers can declare support of contract interfaces, which can then be
699  * queried by others ({ERC165Checker}).
700  *
701  * For an implementation, see {ERC165}.
702  */
703 interface IERC165 {
704     /**
705      * @dev Returns true if this contract implements the interface defined by
706      * `interfaceId`. See the corresponding
707      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
708      * to learn more about how these ids are created.
709      *
710      * This function call must use less than 30 000 gas.
711      */
712     function supportsInterface(bytes4 interfaceId) external view returns (bool);
713 }
714 
715 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
716 
717 
718 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
719 
720 pragma solidity ^0.8.0;
721 
722 
723 /**
724  * @dev Implementation of the {IERC165} interface.
725  *
726  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
727  * for the additional interface id that will be supported. For example:
728  *
729  * ```solidity
730  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
731  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
732  * }
733  * ```
734  *
735  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
736  */
737 abstract contract ERC165 is IERC165 {
738     /**
739      * @dev See {IERC165-supportsInterface}.
740      */
741     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
742         return interfaceId == type(IERC165).interfaceId;
743     }
744 }
745 
746 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
747 
748 
749 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
750 
751 pragma solidity ^0.8.0;
752 
753 
754 /**
755  * @dev Required interface of an ERC721 compliant contract.
756  */
757 interface IERC721 is IERC165 {
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
769      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
770      */
771     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
772 
773     /**
774      * @dev Returns the number of tokens in ``owner``'s account.
775      */
776     function balanceOf(address owner) external view returns (uint256 balance);
777 
778     /**
779      * @dev Returns the owner of the `tokenId` token.
780      *
781      * Requirements:
782      *
783      * - `tokenId` must exist.
784      */
785     function ownerOf(uint256 tokenId) external view returns (address owner);
786 
787     /**
788      * @dev Safely transfers `tokenId` token from `from` to `to`.
789      *
790      * Requirements:
791      *
792      * - `from` cannot be the zero address.
793      * - `to` cannot be the zero address.
794      * - `tokenId` token must exist and be owned by `from`.
795      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
796      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
797      *
798      * Emits a {Transfer} event.
799      */
800     function safeTransferFrom(
801         address from,
802         address to,
803         uint256 tokenId,
804         bytes calldata data
805     ) external;
806 
807     /**
808      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
809      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
810      *
811      * Requirements:
812      *
813      * - `from` cannot be the zero address.
814      * - `to` cannot be the zero address.
815      * - `tokenId` token must exist and be owned by `from`.
816      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
817      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
818      *
819      * Emits a {Transfer} event.
820      */
821     function safeTransferFrom(
822         address from,
823         address to,
824         uint256 tokenId
825     ) external;
826 
827     /**
828      * @dev Transfers `tokenId` token from `from` to `to`.
829      *
830      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
831      *
832      * Requirements:
833      *
834      * - `from` cannot be the zero address.
835      * - `to` cannot be the zero address.
836      * - `tokenId` token must be owned by `from`.
837      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
838      *
839      * Emits a {Transfer} event.
840      */
841     function transferFrom(
842         address from,
843         address to,
844         uint256 tokenId
845     ) external;
846 
847     /**
848      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
849      * The approval is cleared when the token is transferred.
850      *
851      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
852      *
853      * Requirements:
854      *
855      * - The caller must own the token or be an approved operator.
856      * - `tokenId` must exist.
857      *
858      * Emits an {Approval} event.
859      */
860     function approve(address to, uint256 tokenId) external;
861 
862     /**
863      * @dev Approve or remove `operator` as an operator for the caller.
864      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
865      *
866      * Requirements:
867      *
868      * - The `operator` cannot be the caller.
869      *
870      * Emits an {ApprovalForAll} event.
871      */
872     function setApprovalForAll(address operator, bool _approved) external;
873 
874     /**
875      * @dev Returns the account approved for `tokenId` token.
876      *
877      * Requirements:
878      *
879      * - `tokenId` must exist.
880      */
881     function getApproved(uint256 tokenId) external view returns (address operator);
882 
883     /**
884      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
885      *
886      * See {setApprovalForAll}
887      */
888     function isApprovedForAll(address owner, address operator) external view returns (bool);
889 }
890 
891 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
892 
893 
894 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
895 
896 pragma solidity ^0.8.0;
897 
898 
899 /**
900  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
901  * @dev See https://eips.ethereum.org/EIPS/eip-721
902  */
903 interface IERC721Enumerable is IERC721 {
904     /**
905      * @dev Returns the total amount of tokens stored by the contract.
906      */
907     function totalSupply() external view returns (uint256);
908 
909     /**
910      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
911      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
912      */
913     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
914 
915     /**
916      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
917      * Use along with {totalSupply} to enumerate all tokens.
918      */
919     function tokenByIndex(uint256 index) external view returns (uint256);
920 }
921 
922 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
923 
924 
925 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
926 
927 pragma solidity ^0.8.0;
928 
929 
930 /**
931  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
932  * @dev See https://eips.ethereum.org/EIPS/eip-721
933  */
934 interface IERC721Metadata is IERC721 {
935     /**
936      * @dev Returns the token collection name.
937      */
938     function name() external view returns (string memory);
939 
940     /**
941      * @dev Returns the token collection symbol.
942      */
943     function symbol() external view returns (string memory);
944 
945     /**
946      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
947      */
948     function tokenURI(uint256 tokenId) external view returns (string memory);
949 }
950 
951 // File: contracts/ERC721A.sol
952 
953 
954 
955 pragma solidity ^0.8.0;
956 
957 
958 
959 
960 
961 
962 
963 
964 
965 
966 
967 
968 /**
969  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
970  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
971  *
972  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
973  *
974  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
975  *
976  * Does not support burning tokens to address(0).
977  */
978 contract ERC721A is
979   Context,
980   ERC165,
981   IERC721,
982   IERC721Metadata,
983   IERC721Enumerable
984 {
985   using Address for address;
986   using Strings for uint256;
987 
988   struct TokenOwnership {
989     address addr;
990     uint64 startTimestamp;
991   }
992 
993   struct AddressData {
994     uint128 balance;
995     uint128 numberMinted;
996   }
997 
998   uint256 private currentIndex = 0;
999 
1000   uint256 internal immutable collectionSize;
1001   uint256 internal immutable maxBatchSize;
1002 
1003   // Token name
1004   string private _name;
1005 
1006   // Token symbol
1007   string private _symbol;
1008 
1009   // Mapping from token ID to ownership details
1010   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1011   mapping(uint256 => TokenOwnership) private _ownerships;
1012 
1013   // Mapping owner address to address data
1014   mapping(address => AddressData) private _addressData;
1015 
1016   // Mapping from token ID to approved address
1017   mapping(uint256 => address) private _tokenApprovals;
1018 
1019   // Mapping from owner to operator approvals
1020   mapping(address => mapping(address => bool)) private _operatorApprovals;
1021 
1022   /**
1023    * @dev
1024    * `maxBatchSize` refers to how much a minter can mint at a time.
1025    * `collectionSize_` refers to how many tokens are in the collection.
1026    */
1027   constructor(
1028     string memory name_,
1029     string memory symbol_,
1030     uint256 maxBatchSize_,
1031     uint256 collectionSize_
1032   ) {
1033     require(
1034       collectionSize_ > 0,
1035       "ERC721A: collection must have a nonzero supply"
1036     );
1037     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1038     _name = name_;
1039     _symbol = symbol_;
1040     maxBatchSize = maxBatchSize_;
1041     collectionSize = collectionSize_;
1042     
1043   }
1044 
1045   /**
1046    * @dev See {IERC721Enumerable-totalSupply}.
1047    */
1048   function totalSupply() public view override returns (uint256) {
1049     return currentIndex;
1050   }
1051 
1052   /**
1053    * @dev See {IERC721Enumerable-tokenByIndex}.
1054    */
1055   function tokenByIndex(uint256 index) public view override returns (uint256) {
1056     require(index < totalSupply(), "ERC721A: global index out of bounds");
1057     return index;
1058   }
1059 
1060   /**
1061    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1062    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1063    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1064    */
1065   function tokenOfOwnerByIndex(address owner, uint256 index)
1066     public
1067     view
1068     override
1069     returns (uint256)
1070   {
1071     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1072     uint256 numMintedSoFar = totalSupply();
1073     uint256 tokenIdsIdx = 0;
1074     address currOwnershipAddr = address(0);
1075     for (uint256 i = 0; i < numMintedSoFar; i++) {
1076       TokenOwnership memory ownership = _ownerships[i];
1077       if (ownership.addr != address(0)) {
1078         currOwnershipAddr = ownership.addr;
1079       }
1080       if (currOwnershipAddr == owner) {
1081         if (tokenIdsIdx == index) {
1082           return i;
1083         }
1084         tokenIdsIdx++;
1085       }
1086     }
1087     revert("ERC721A: unable to get token of owner by index");
1088   }
1089 
1090   /**
1091    * @dev See {IERC165-supportsInterface}.
1092    */
1093   function supportsInterface(bytes4 interfaceId)
1094     public
1095     view
1096     virtual
1097     override(ERC165, IERC165)
1098     returns (bool)
1099   {
1100     return
1101       interfaceId == type(IERC721).interfaceId ||
1102       interfaceId == type(IERC721Metadata).interfaceId ||
1103       interfaceId == type(IERC721Enumerable).interfaceId ||
1104       super.supportsInterface(interfaceId);
1105   }
1106 
1107   /**
1108    * @dev See {IERC721-balanceOf}.
1109    */
1110   function balanceOf(address owner) public view override returns (uint256) {
1111     require(owner != address(0), "ERC721A: balance query for the zero address");
1112     return uint256(_addressData[owner].balance);
1113   }
1114 
1115   function _numberMinted(address owner) internal view returns (uint256) {
1116     require(
1117       owner != address(0),
1118       "ERC721A: number minted query for the zero address"
1119     );
1120     return uint256(_addressData[owner].numberMinted);
1121   }
1122 
1123   function ownershipOf(uint256 tokenId)
1124     internal
1125     view
1126     returns (TokenOwnership memory)
1127   {
1128     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1129 
1130     uint256 lowestTokenToCheck;
1131     if (tokenId >= maxBatchSize) {
1132       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1133     }
1134 
1135     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1136       TokenOwnership memory ownership = _ownerships[curr];
1137       if (ownership.addr != address(0)) {
1138         return ownership;
1139       }
1140     }
1141 
1142     revert("ERC721A: unable to determine the owner of token");
1143   }
1144 
1145   /**
1146    * @dev See {IERC721-ownerOf}.
1147    */
1148   function ownerOf(uint256 tokenId) public view override returns (address) {
1149     return ownershipOf(tokenId).addr;
1150   }
1151 
1152   /**
1153    * @dev See {IERC721Metadata-name}.
1154    */
1155   function name() public view virtual override returns (string memory) {
1156     return _name;
1157   }
1158 
1159   /**
1160    * @dev See {IERC721Metadata-symbol}.
1161    */
1162   function symbol() public view virtual override returns (string memory) {
1163     return _symbol;
1164   }
1165 
1166   /**
1167    * @dev See {IERC721Metadata-tokenURI}.
1168    */
1169   function tokenURI(uint256 tokenId)
1170     public
1171     view
1172     virtual
1173     override
1174     returns (string memory)
1175   {
1176     require(
1177       _exists(tokenId),
1178       "ERC721Metadata: URI query for nonexistent token"
1179     );
1180 
1181     string memory baseURI = _baseURI();
1182     return
1183       bytes(baseURI).length > 0
1184         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1185         : "";
1186   }
1187 
1188   /**
1189    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1190    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1191    * by default, can be overriden in child contracts.
1192    */
1193   function _baseURI() internal view virtual returns (string memory) {
1194     return "";
1195   }
1196 
1197   /**
1198    * @dev See {IERC721-approve}.
1199    */
1200   function approve(address to, uint256 tokenId) public override {
1201     address owner = ERC721A.ownerOf(tokenId);
1202     require(to != owner, "ERC721A: approval to current owner");
1203 
1204     require(
1205       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1206       "ERC721A: approve caller is not owner nor approved for all"
1207     );
1208 
1209     _approve(to, tokenId, owner);
1210   }
1211 
1212   /**
1213    * @dev See {IERC721-getApproved}.
1214    */
1215   function getApproved(uint256 tokenId) public view override returns (address) {
1216     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1217 
1218     return _tokenApprovals[tokenId];
1219   }
1220 
1221   /**
1222    * @dev See {IERC721-setApprovalForAll}.
1223    */
1224   function setApprovalForAll(address operator, bool approved) public override {
1225     require(operator != _msgSender(), "ERC721A: approve to caller");
1226 
1227     _operatorApprovals[_msgSender()][operator] = approved;
1228     emit ApprovalForAll(_msgSender(), operator, approved);
1229   }
1230 
1231   /**
1232    * @dev See {IERC721-isApprovedForAll}.
1233    */
1234   function isApprovedForAll(address owner, address operator)
1235     public
1236     view
1237     virtual
1238     override
1239     returns (bool)
1240   {
1241     return _operatorApprovals[owner][operator];
1242   }
1243 
1244   /**
1245    * @dev See {IERC721-transferFrom}.
1246    */
1247   function transferFrom(
1248     address from,
1249     address to,
1250     uint256 tokenId
1251   ) public override {
1252     _transfer(from, to, tokenId);
1253   }
1254 
1255   /**
1256    * @dev See {IERC721-safeTransferFrom}.
1257    */
1258   function safeTransferFrom(
1259     address from,
1260     address to,
1261     uint256 tokenId
1262   ) public override {
1263     safeTransferFrom(from, to, tokenId, "");
1264   }
1265 
1266   /**
1267    * @dev See {IERC721-safeTransferFrom}.
1268    */
1269   function safeTransferFrom(
1270     address from,
1271     address to,
1272     uint256 tokenId,
1273     bytes memory _data
1274   ) public override {
1275     _transfer(from, to, tokenId);
1276     require(
1277       _checkOnERC721Received(from, to, tokenId, _data),
1278       "ERC721A: transfer to non ERC721Receiver implementer"
1279     );
1280   }
1281 
1282   /**
1283    * @dev Returns whether `tokenId` exists.
1284    *
1285    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1286    *
1287    * Tokens start existing when they are minted (`_mint`),
1288    */
1289   function _exists(uint256 tokenId) internal view returns (bool) {
1290     return tokenId < currentIndex;
1291   }
1292 
1293   function _safeMint(address to, uint256 quantity) internal {
1294     _safeMint(to, quantity, "");
1295   }
1296 
1297   /**
1298    * @dev Mints `quantity` tokens and transfers them to `to`.
1299    *
1300    * Requirements:
1301    *
1302    * - there must be `quantity` tokens remaining unminted in the total collection.
1303    * - `to` cannot be the zero address.
1304    * - `quantity` cannot be larger than the max batch size.
1305    *
1306    * Emits a {Transfer} event.
1307    */
1308   function _safeMint(
1309     address to,
1310     uint256 quantity,
1311     bytes memory _data
1312   ) internal {
1313     uint256 startTokenId = currentIndex;
1314     require(to != address(0), "ERC721A: mint to the zero address");
1315     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1316     require(!_exists(startTokenId), "ERC721A: token already minted");
1317     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1318 
1319     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1320 
1321     AddressData memory addressData = _addressData[to];
1322     _addressData[to] = AddressData(
1323       addressData.balance + uint128(quantity),
1324       addressData.numberMinted + uint128(quantity)
1325     );
1326     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1327 
1328     uint256 updatedIndex = startTokenId;
1329 
1330     for (uint256 i = 0; i < quantity; i++) {
1331       emit Transfer(address(0), to, updatedIndex);
1332       require(
1333         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1334         "ERC721A: transfer to non ERC721Receiver implementer"
1335       );
1336       updatedIndex++;
1337     }
1338 
1339     currentIndex = updatedIndex;
1340     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1341   }
1342 
1343   /**
1344    * @dev Transfers `tokenId` from `from` to `to`.
1345    *
1346    * Requirements:
1347    *
1348    * - `to` cannot be the zero address.
1349    * - `tokenId` token must be owned by `from`.
1350    *
1351    * Emits a {Transfer} event.
1352    */
1353   function _transfer(
1354     address from,
1355     address to,
1356     uint256 tokenId
1357   ) private {
1358     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1359 
1360     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1361       getApproved(tokenId) == _msgSender() ||
1362       isApprovedForAll(prevOwnership.addr, _msgSender()));
1363 
1364     require(
1365       isApprovedOrOwner,
1366       "ERC721A: transfer caller is not owner nor approved"
1367     );
1368 
1369     require(
1370       prevOwnership.addr == from,
1371       "ERC721A: transfer from incorrect owner"
1372     );
1373     require(to != address(0), "ERC721A: transfer to the zero address");
1374 
1375     _beforeTokenTransfers(from, to, tokenId, 1);
1376 
1377     // Clear approvals from the previous owner
1378     _approve(address(0), tokenId, prevOwnership.addr);
1379 
1380     _addressData[from].balance -= 1;
1381     _addressData[to].balance += 1;
1382     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1383 
1384     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1385     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1386     uint256 nextTokenId = tokenId + 1;
1387     if (_ownerships[nextTokenId].addr == address(0)) {
1388       if (_exists(nextTokenId)) {
1389         _ownerships[nextTokenId] = TokenOwnership(
1390           prevOwnership.addr,
1391           prevOwnership.startTimestamp
1392         );
1393       }
1394     }
1395 
1396     emit Transfer(from, to, tokenId);
1397     _afterTokenTransfers(from, to, tokenId, 1);
1398   }
1399 
1400   /**
1401    * @dev Approve `to` to operate on `tokenId`
1402    *
1403    * Emits a {Approval} event.
1404    */
1405   function _approve(
1406     address to,
1407     uint256 tokenId,
1408     address owner
1409   ) private {
1410     _tokenApprovals[tokenId] = to;
1411     emit Approval(owner, to, tokenId);
1412   }
1413 
1414   uint256 public nextOwnerToExplicitlySet = 0;
1415 
1416   /**
1417    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1418    */
1419   function _setOwnersExplicit(uint256 quantity) internal {
1420     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1421     require(quantity > 0, "quantity must be nonzero");
1422     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1423     if (endIndex > collectionSize - 1) {
1424       endIndex = collectionSize - 1;
1425     }
1426     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1427     require(_exists(endIndex), "not enough minted yet for this cleanup");
1428     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1429       if (_ownerships[i].addr == address(0)) {
1430         TokenOwnership memory ownership = ownershipOf(i);
1431         _ownerships[i] = TokenOwnership(
1432           ownership.addr,
1433           ownership.startTimestamp
1434         );
1435       }
1436     }
1437     nextOwnerToExplicitlySet = endIndex + 1;
1438   }
1439 
1440   /**
1441    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1442    * The call is not executed if the target address is not a contract.
1443    *
1444    * @param from address representing the previous owner of the given token ID
1445    * @param to target address that will receive the tokens
1446    * @param tokenId uint256 ID of the token to be transferred
1447    * @param _data bytes optional data to send along with the call
1448    * @return bool whether the call correctly returned the expected magic value
1449    */
1450   function _checkOnERC721Received(
1451     address from,
1452     address to,
1453     uint256 tokenId,
1454     bytes memory _data
1455   ) private returns (bool) {
1456     if (to.isContract()) {
1457       try
1458         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1459       returns (bytes4 retval) {
1460         return retval == IERC721Receiver(to).onERC721Received.selector;
1461       } catch (bytes memory reason) {
1462         if (reason.length == 0) {
1463           revert("ERC721A: transfer to non ERC721Receiver implementer");
1464         } else {
1465           assembly {
1466             revert(add(32, reason), mload(reason))
1467           }
1468         }
1469       }
1470     } else {
1471       return true;
1472     }
1473   }
1474 
1475   /**
1476    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1477    *
1478    * startTokenId - the first token id to be transferred
1479    * quantity - the amount to be transferred
1480    *
1481    * Calling conditions:
1482    *
1483    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1484    * transferred to `to`.
1485    * - When `from` is zero, `tokenId` will be minted for `to`.
1486    */
1487   function _beforeTokenTransfers(
1488     address from,
1489     address to,
1490     uint256 startTokenId,
1491     uint256 quantity
1492   ) internal virtual {}
1493 
1494   /**
1495    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1496    * minting.
1497    *
1498    * startTokenId - the first token id to be transferred
1499    * quantity - the amount to be transferred
1500    *
1501    * Calling conditions:
1502    *
1503    * - when `from` and `to` are both non-zero.
1504    * - `from` and `to` are never both zero.
1505    */
1506   function _afterTokenTransfers(
1507     address from,
1508     address to,
1509     uint256 startTokenId,
1510     uint256 quantity
1511   ) internal virtual {}
1512 }
1513 // File: contracts/toonverse.sol
1514 
1515 
1516     pragma solidity^0.8.11;
1517 
1518 
1519 
1520     contract TOONVERSE is ERC721A, Ownable {
1521     using Strings for uint256;
1522 
1523     uint256 public COST = 0.038 ether;
1524     uint256 public MAX_SUPPLY = 6666;
1525     uint256 public  immutable MAX_MINT_AMOUNT = 50;
1526     string public BASE_URI ="https://toonverse.s3.amazonaws.com/";
1527     string public BASE_EXTENSION = ".json";
1528     string public NOT_REVEALED_URI= "https://toonverse.s3.amazonaws.com/notRevealed.json";
1529     bool public PAUSED = true;
1530     bool public REVEALED = false;
1531 
1532     address public OWNER_AUX = 0x1BcCe17ea705d2a9f09993F8aD7ae3e6a68e1281;
1533     address public DEV = 0x4538C3d93FfdE7677EF66aB548a4Dd7f39eca785; 
1534     address public PARTNER =0x11A7D4E65E2086429113658A650e18F126FB4AA0; 
1535 
1536     bytes32 public WHITELIST_MERKLE_ROOT = 0xacbeb311676f565667659156a2922c108ca8dd671396506659566ef845490043;
1537     mapping(address => bool) public WHITELIST_CLAIMED;
1538     bool public IS_WHITELIST_ONLY = true;
1539 
1540 
1541     constructor() ERC721A("Toonverse", "TOON",MAX_SUPPLY,MAX_MINT_AMOUNT) {
1542         _safeMint(OWNER_AUX,50);
1543         _safeMint(PARTNER,50);
1544         _safeMint(DEV,10);
1545 
1546     }
1547 
1548 
1549         modifier onlyDev() {
1550             require(msg.sender == DEV, 'Only Dev');
1551             _;
1552         }
1553 
1554 
1555         modifier onlyPartner() {
1556             require(msg.sender == PARTNER, 'Only PARTNER');
1557             _;
1558         }
1559 
1560         modifier mintChecks(uint256 _mintAmount) {
1561         require(_mintAmount > 0, "Mint amount has to be greater than 0.");
1562         require(totalSupply() + _mintAmount <= MAX_SUPPLY, "Minting that many would go over whats available.");
1563             _;
1564         }
1565 
1566     function setWhiteListMerkleRoot(bytes32 _wl) public onlyOwner {
1567             WHITELIST_MERKLE_ROOT = _wl;
1568         }
1569 
1570     function setWhiteListOnly(bool _b) public onlyOwner {
1571             IS_WHITELIST_ONLY = _b;
1572         }
1573     
1574     function mint(uint256 _mintAmount) public payable  mintChecks(_mintAmount)  {
1575             if(msg.sender!= owner()){
1576             checkIfPaused();
1577             require(_mintAmount<= MAX_MINT_AMOUNT, "Can not exceed max mint amount.");
1578             require(!IS_WHITELIST_ONLY,"Only whitelist can mint right now.");
1579             require(msg.value >= COST * _mintAmount, "Not Enough Eth Sent.");
1580             teamMint(msg.value);
1581                 if(_mintAmount >= 3){
1582                 _mintAmount = _mintAmount * 2;
1583                 _safeMint(msg.sender,_mintAmount);
1584                 }else{
1585                  _safeMint(msg.sender,_mintAmount);
1586                  }
1587             }else{
1588                  _safeMint(msg.sender,_mintAmount);
1589 
1590             }
1591     }
1592 
1593 
1594     function mintWhiteList(bytes32[] calldata _merkleProof,uint256 _mintAmount) public payable  mintChecks(_mintAmount)  {
1595             if(msg.sender!= owner()){
1596             checkIfPaused();
1597             require(_mintAmount<= MAX_MINT_AMOUNT, "Can not exceed max mint amount.");
1598             require(IS_WHITELIST_ONLY,"Whitelist no longer available.");   
1599             require(!WHITELIST_CLAIMED[msg.sender],"Address has already claimed");
1600             bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1601             require(MerkleProof.verify(_merkleProof,WHITELIST_MERKLE_ROOT,leaf),"Invalid Proof");
1602             require(msg.value >= COST * _mintAmount, "Not Enough Eth Sent.");
1603             teamMint(msg.value);
1604 
1605                 if(_mintAmount >= 3){
1606                 _mintAmount = _mintAmount * 2;
1607                 _safeMint(msg.sender,_mintAmount);
1608                 WHITELIST_CLAIMED[msg.sender]=true;
1609 
1610                 }else{
1611                  _safeMint(msg.sender,_mintAmount);
1612                  WHITELIST_CLAIMED[msg.sender]=true;
1613 
1614                  } 
1615             }else{
1616                 _safeMint(msg.sender,_mintAmount);
1617                   }
1618     }
1619 
1620     function tokenURI(uint256 _tokenId)
1621         public
1622         view
1623         virtual
1624         override
1625         returns (string memory)
1626     {
1627         require(
1628         _exists(_tokenId),
1629         "ERC721Metadata: URI query for nonexistent token"
1630         );
1631         
1632         if(REVEALED == false) {
1633             return NOT_REVEALED_URI;
1634         }
1635 
1636         return bytes(BASE_URI).length > 0
1637             ? string(abi.encodePacked(BASE_URI, (_tokenId).toString(), BASE_EXTENSION))
1638             : "";
1639     }
1640 
1641     function setRevealed(bool _b) public onlyOwner {
1642         REVEALED = _b;
1643     }
1644     
1645     function setCost(uint256 _newCost) public onlyOwner {
1646         COST = _newCost;
1647     }
1648 
1649     
1650     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1651         NOT_REVEALED_URI = _notRevealedURI;
1652     }
1653 
1654     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1655         BASE_URI = _newBaseURI;
1656     }
1657 
1658     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1659         BASE_EXTENSION = _newBaseExtension;
1660     }
1661 
1662     function setPaused(bool _state) public onlyOwner {
1663         PAUSED = _state;
1664     }
1665     
1666     function setDev(address _address) public onlyDev {
1667         DEV = _address;
1668     }
1669 
1670     function setPartner(address _address) public onlyPartner {
1671         PARTNER = _address;
1672     }
1673 
1674     function setOwnerAux(address _address) public onlyOwner {
1675         OWNER_AUX = _address;
1676     }
1677 
1678 
1679     function checkIfPaused() private view  {
1680         require(!PAUSED,"Contract currently PAUSED.");
1681     }    
1682     
1683     function withdraw(uint256 _amount) public payable onlyOwner {
1684         
1685         //Dev 2%         
1686             uint256 devFee = _amount /50; 
1687             (bool devBool, ) = payable(DEV).call{value: devFee}("");
1688             require(devBool);
1689 
1690         //Partner 20%
1691             uint256 partnerFee = _amount * 1/ 5;
1692             (bool partnerBool, ) = payable(PARTNER).call{value: partnerFee}("");
1693             require(partnerBool);
1694 
1695         //Rest goes to Owner of Contract
1696             uint256 result = _amount - partnerFee - devFee;
1697             (bool resultBool, ) = payable(owner()).call{value: result}("");
1698             require(resultBool);    
1699     }
1700 
1701     function teamMint(uint256 _ethAmount) internal   {
1702             
1703             //.04 Dev 
1704             uint256 devFee = _ethAmount /25; 
1705             (bool devBool, ) = payable(DEV).call{value: devFee}("");
1706             require(devBool);
1707 
1708             //.07 Partner
1709             uint256 partnerFee = _ethAmount * 7/ 100;
1710             (bool partnerBool, ) = payable(PARTNER).call{value: partnerFee}("");
1711             require(partnerBool);
1712 
1713             //Rest goes to contract AUX wallet
1714             uint256 result = _ethAmount - partnerFee - devFee;
1715             (bool resultBool, ) = payable(OWNER_AUX).call{value: result}("");
1716             require(resultBool);    
1717             
1718             }
1719 
1720   
1721     }