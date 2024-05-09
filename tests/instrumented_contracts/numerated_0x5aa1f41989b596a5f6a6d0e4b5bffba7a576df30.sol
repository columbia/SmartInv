1 //////////////////////////////////////////////////////////////
2 //                                                          //
3 //   Auditing, Website, and Deployment by @ViperwareLabs    //
4 //                                                          //
5 //////////////////////////////////////////////////////////////
6 
7 
8 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
9 
10 
11 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
12 
13 pragma solidity ^0.8.0;
14 
15 /**
16  * @dev These functions deal with verification of Merkle Tree proofs.
17  *
18  * The proofs can be generated using the JavaScript library
19  * https://github.com/miguelmota/merkletreejs[merkletreejs].
20  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
21  *
22  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
23  *
24  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
25  * hashing, or use a hash function other than keccak256 for hashing leaves.
26  * This is because the concatenation of a sorted pair of internal nodes in
27  * the merkle tree could be reinterpreted as a leaf value.
28  */
29 library MerkleProof {
30     /**
31      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
32      * defined by `root`. For this, a `proof` must be provided, containing
33      * sibling hashes on the branch from the leaf to the root of the tree. Each
34      * pair of leaves and each pair of pre-images are assumed to be sorted.
35      */
36     function verify(
37         bytes32[] memory proof,
38         bytes32 root,
39         bytes32 leaf
40     ) internal pure returns (bool) {
41         return processProof(proof, leaf) == root;
42     }
43 
44     /**
45      * @dev Calldata version of {verify}
46      *
47      * _Available since v4.7._
48      */
49     function verifyCalldata(
50         bytes32[] calldata proof,
51         bytes32 root,
52         bytes32 leaf
53     ) internal pure returns (bool) {
54         return processProofCalldata(proof, leaf) == root;
55     }
56 
57     /**
58      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
59      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
60      * hash matches the root of the tree. When processing the proof, the pairs
61      * of leafs & pre-images are assumed to be sorted.
62      *
63      * _Available since v4.4._
64      */
65     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
66         bytes32 computedHash = leaf;
67         for (uint256 i = 0; i < proof.length; i++) {
68             computedHash = _hashPair(computedHash, proof[i]);
69         }
70         return computedHash;
71     }
72 
73     /**
74      * @dev Calldata version of {processProof}
75      *
76      * _Available since v4.7._
77      */
78     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
79         bytes32 computedHash = leaf;
80         for (uint256 i = 0; i < proof.length; i++) {
81             computedHash = _hashPair(computedHash, proof[i]);
82         }
83         return computedHash;
84     }
85 
86     /**
87      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
88      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
89      *
90      * _Available since v4.7._
91      */
92     function multiProofVerify(
93         bytes32[] memory proof,
94         bool[] memory proofFlags,
95         bytes32 root,
96         bytes32[] memory leaves
97     ) internal pure returns (bool) {
98         return processMultiProof(proof, proofFlags, leaves) == root;
99     }
100 
101     /**
102      * @dev Calldata version of {multiProofVerify}
103      *
104      * _Available since v4.7._
105      */
106     function multiProofVerifyCalldata(
107         bytes32[] calldata proof,
108         bool[] calldata proofFlags,
109         bytes32 root,
110         bytes32[] memory leaves
111     ) internal pure returns (bool) {
112         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
113     }
114 
115     /**
116      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
117      * consuming from one or the other at each step according to the instructions given by
118      * `proofFlags`.
119      *
120      * _Available since v4.7._
121      */
122     function processMultiProof(
123         bytes32[] memory proof,
124         bool[] memory proofFlags,
125         bytes32[] memory leaves
126     ) internal pure returns (bytes32 merkleRoot) {
127         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
128         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
129         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
130         // the merkle tree.
131         uint256 leavesLen = leaves.length;
132         uint256 totalHashes = proofFlags.length;
133 
134         // Check proof validity.
135         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
136 
137         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
138         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
139         bytes32[] memory hashes = new bytes32[](totalHashes);
140         uint256 leafPos = 0;
141         uint256 hashPos = 0;
142         uint256 proofPos = 0;
143         // At each step, we compute the next hash using two values:
144         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
145         //   get the next hash.
146         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
147         //   `proof` array.
148         for (uint256 i = 0; i < totalHashes; i++) {
149             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
150             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
151             hashes[i] = _hashPair(a, b);
152         }
153 
154         if (totalHashes > 0) {
155             return hashes[totalHashes - 1];
156         } else if (leavesLen > 0) {
157             return leaves[0];
158         } else {
159             return proof[0];
160         }
161     }
162 
163     /**
164      * @dev Calldata version of {processMultiProof}
165      *
166      * _Available since v4.7._
167      */
168     function processMultiProofCalldata(
169         bytes32[] calldata proof,
170         bool[] calldata proofFlags,
171         bytes32[] memory leaves
172     ) internal pure returns (bytes32 merkleRoot) {
173         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
174         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
175         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
176         // the merkle tree.
177         uint256 leavesLen = leaves.length;
178         uint256 totalHashes = proofFlags.length;
179 
180         // Check proof validity.
181         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
182 
183         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
184         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
185         bytes32[] memory hashes = new bytes32[](totalHashes);
186         uint256 leafPos = 0;
187         uint256 hashPos = 0;
188         uint256 proofPos = 0;
189         // At each step, we compute the next hash using two values:
190         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
191         //   get the next hash.
192         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
193         //   `proof` array.
194         for (uint256 i = 0; i < totalHashes; i++) {
195             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
196             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
197             hashes[i] = _hashPair(a, b);
198         }
199 
200         if (totalHashes > 0) {
201             return hashes[totalHashes - 1];
202         } else if (leavesLen > 0) {
203             return leaves[0];
204         } else {
205             return proof[0];
206         }
207     }
208 
209     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
210         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
211     }
212 
213     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
214         /// @solidity memory-safe-assembly
215         assembly {
216             mstore(0x00, a)
217             mstore(0x20, b)
218             value := keccak256(0x00, 0x40)
219         }
220     }
221 }
222 
223 // File: @openzeppelin/contracts/utils/Context.sol
224 
225 
226 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
227 
228 pragma solidity ^0.8.0;
229 
230 /**
231  * @dev Provides information about the current execution context, including the
232  * sender of the transaction and its data. While these are generally available
233  * via msg.sender and msg.data, they should not be accessed in such a direct
234  * manner, since when dealing with meta-transactions the account sending and
235  * paying for execution may not be the actual sender (as far as an application
236  * is concerned).
237  *
238  * This contract is only required for intermediate, library-like contracts.
239  */
240 abstract contract Context {
241     function _msgSender() internal view virtual returns (address) {
242         return msg.sender;
243     }
244 
245     function _msgData() internal view virtual returns (bytes calldata) {
246         return msg.data;
247     }
248 }
249 
250 // File: @openzeppelin/contracts/access/Ownable.sol
251 
252 
253 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
254 
255 pragma solidity ^0.8.0;
256 
257 
258 /**
259  * @dev Contract module which provides a basic access control mechanism, where
260  * there is an account (an owner) that can be granted exclusive access to
261  * specific functions.
262  *
263  * By default, the owner account will be the one that deploys the contract. This
264  * can later be changed with {transferOwnership}.
265  *
266  * This module is used through inheritance. It will make available the modifier
267  * `onlyOwner`, which can be applied to your functions to restrict their use to
268  * the owner.
269  */
270 abstract contract Ownable is Context {
271     address private _owner;
272 
273     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
274 
275     /**
276      * @dev Initializes the contract setting the deployer as the initial owner.
277      */
278     constructor() {
279         _transferOwnership(_msgSender());
280     }
281 
282     /**
283      * @dev Throws if called by any account other than the owner.
284      */
285     modifier onlyOwner() {
286         _checkOwner();
287         _;
288     }
289 
290     /**
291      * @dev Returns the address of the current owner.
292      */
293     function owner() public view virtual returns (address) {
294         return _owner;
295     }
296 
297     /**
298      * @dev Throws if the sender is not the owner.
299      */
300     function _checkOwner() internal view virtual {
301         require(owner() == _msgSender(), "Ownable: caller is not the owner");
302     }
303 
304     /**
305      * @dev Leaves the contract without owner. It will not be possible to call
306      * `onlyOwner` functions anymore. Can only be called by the current owner.
307      *
308      * NOTE: Renouncing ownership will leave the contract without an owner,
309      * thereby removing any functionality that is only available to the owner.
310      */
311     function renounceOwnership() public virtual onlyOwner {
312         _transferOwnership(address(0));
313     }
314 
315     /**
316      * @dev Transfers ownership of the contract to a new account (`newOwner`).
317      * Can only be called by the current owner.
318      */
319     function transferOwnership(address newOwner) public virtual onlyOwner {
320         require(newOwner != address(0), "Ownable: new owner is the zero address");
321         _transferOwnership(newOwner);
322     }
323 
324     /**
325      * @dev Transfers ownership of the contract to a new account (`newOwner`).
326      * Internal function without access restriction.
327      */
328     function _transferOwnership(address newOwner) internal virtual {
329         address oldOwner = _owner;
330         _owner = newOwner;
331         emit OwnershipTransferred(oldOwner, newOwner);
332     }
333 }
334 
335 // File: @openzeppelin/contracts/utils/Address.sol
336 
337 
338 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
339 
340 pragma solidity ^0.8.1;
341 
342 /**
343  * @dev Collection of functions related to the address type
344  */
345 library Address {
346     /**
347      * @dev Returns true if `account` is a contract.
348      *
349      * [IMPORTANT]
350      * ====
351      * It is unsafe to assume that an address for which this function returns
352      * false is an externally-owned account (EOA) and not a contract.
353      *
354      * Among others, `isContract` will return false for the following
355      * types of addresses:
356      *
357      *  - an externally-owned account
358      *  - a contract in construction
359      *  - an address where a contract will be created
360      *  - an address where a contract lived, but was destroyed
361      * ====
362      *
363      * [IMPORTANT]
364      * ====
365      * You shouldn't rely on `isContract` to protect against flash loan attacks!
366      *
367      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
368      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
369      * constructor.
370      * ====
371      */
372     function isContract(address account) internal view returns (bool) {
373         // This method relies on extcodesize/address.code.length, which returns 0
374         // for contracts in construction, since the code is only stored at the end
375         // of the constructor execution.
376 
377         return account.code.length > 0;
378     }
379 
380     /**
381      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
382      * `recipient`, forwarding all available gas and reverting on errors.
383      *
384      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
385      * of certain opcodes, possibly making contracts go over the 2300 gas limit
386      * imposed by `transfer`, making them unable to receive funds via
387      * `transfer`. {sendValue} removes this limitation.
388      *
389      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
390      *
391      * IMPORTANT: because control is transferred to `recipient`, care must be
392      * taken to not create reentrancy vulnerabilities. Consider using
393      * {ReentrancyGuard} or the
394      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
395      */
396     function sendValue(address payable recipient, uint256 amount) internal {
397         require(address(this).balance >= amount, "Address: insufficient balance");
398 
399         (bool success, ) = recipient.call{value: amount}("");
400         require(success, "Address: unable to send value, recipient may have reverted");
401     }
402 
403     /**
404      * @dev Performs a Solidity function call using a low level `call`. A
405      * plain `call` is an unsafe replacement for a function call: use this
406      * function instead.
407      *
408      * If `target` reverts with a revert reason, it is bubbled up by this
409      * function (like regular Solidity function calls).
410      *
411      * Returns the raw returned data. To convert to the expected return value,
412      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
413      *
414      * Requirements:
415      *
416      * - `target` must be a contract.
417      * - calling `target` with `data` must not revert.
418      *
419      * _Available since v3.1._
420      */
421     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
422         return functionCall(target, data, "Address: low-level call failed");
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
427      * `errorMessage` as a fallback revert reason when `target` reverts.
428      *
429      * _Available since v3.1._
430      */
431     function functionCall(
432         address target,
433         bytes memory data,
434         string memory errorMessage
435     ) internal returns (bytes memory) {
436         return functionCallWithValue(target, data, 0, errorMessage);
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
441      * but also transferring `value` wei to `target`.
442      *
443      * Requirements:
444      *
445      * - the calling contract must have an ETH balance of at least `value`.
446      * - the called Solidity function must be `payable`.
447      *
448      * _Available since v3.1._
449      */
450     function functionCallWithValue(
451         address target,
452         bytes memory data,
453         uint256 value
454     ) internal returns (bytes memory) {
455         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
456     }
457 
458     /**
459      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
460      * with `errorMessage` as a fallback revert reason when `target` reverts.
461      *
462      * _Available since v3.1._
463      */
464     function functionCallWithValue(
465         address target,
466         bytes memory data,
467         uint256 value,
468         string memory errorMessage
469     ) internal returns (bytes memory) {
470         require(address(this).balance >= value, "Address: insufficient balance for call");
471         require(isContract(target), "Address: call to non-contract");
472 
473         (bool success, bytes memory returndata) = target.call{value: value}(data);
474         return verifyCallResult(success, returndata, errorMessage);
475     }
476 
477     /**
478      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
479      * but performing a static call.
480      *
481      * _Available since v3.3._
482      */
483     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
484         return functionStaticCall(target, data, "Address: low-level static call failed");
485     }
486 
487     /**
488      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
489      * but performing a static call.
490      *
491      * _Available since v3.3._
492      */
493     function functionStaticCall(
494         address target,
495         bytes memory data,
496         string memory errorMessage
497     ) internal view returns (bytes memory) {
498         require(isContract(target), "Address: static call to non-contract");
499 
500         (bool success, bytes memory returndata) = target.staticcall(data);
501         return verifyCallResult(success, returndata, errorMessage);
502     }
503 
504     /**
505      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
506      * but performing a delegate call.
507      *
508      * _Available since v3.4._
509      */
510     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
511         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
512     }
513 
514     /**
515      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
516      * but performing a delegate call.
517      *
518      * _Available since v3.4._
519      */
520     function functionDelegateCall(
521         address target,
522         bytes memory data,
523         string memory errorMessage
524     ) internal returns (bytes memory) {
525         require(isContract(target), "Address: delegate call to non-contract");
526 
527         (bool success, bytes memory returndata) = target.delegatecall(data);
528         return verifyCallResult(success, returndata, errorMessage);
529     }
530 
531     /**
532      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
533      * revert reason using the provided one.
534      *
535      * _Available since v4.3._
536      */
537     function verifyCallResult(
538         bool success,
539         bytes memory returndata,
540         string memory errorMessage
541     ) internal pure returns (bytes memory) {
542         if (success) {
543             return returndata;
544         } else {
545             // Look for revert reason and bubble it up if present
546             if (returndata.length > 0) {
547                 // The easiest way to bubble the revert reason is using memory via assembly
548                 /// @solidity memory-safe-assembly
549                 assembly {
550                     let returndata_size := mload(returndata)
551                     revert(add(32, returndata), returndata_size)
552                 }
553             } else {
554                 revert(errorMessage);
555             }
556         }
557     }
558 }
559 
560 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
561 
562 
563 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
564 
565 pragma solidity ^0.8.0;
566 
567 /**
568  * @dev Interface of the ERC165 standard, as defined in the
569  * https://eips.ethereum.org/EIPS/eip-165[EIP].
570  *
571  * Implementers can declare support of contract interfaces, which can then be
572  * queried by others ({ERC165Checker}).
573  *
574  * For an implementation, see {ERC165}.
575  */
576 interface IERC165 {
577     /**
578      * @dev Returns true if this contract implements the interface defined by
579      * `interfaceId`. See the corresponding
580      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
581      * to learn more about how these ids are created.
582      *
583      * This function call must use less than 30 000 gas.
584      */
585     function supportsInterface(bytes4 interfaceId) external view returns (bool);
586 }
587 
588 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
589 
590 
591 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
592 
593 pragma solidity ^0.8.0;
594 
595 
596 /**
597  * @dev Implementation of the {IERC165} interface.
598  *
599  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
600  * for the additional interface id that will be supported. For example:
601  *
602  * ```solidity
603  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
604  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
605  * }
606  * ```
607  *
608  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
609  */
610 abstract contract ERC165 is IERC165 {
611     /**
612      * @dev See {IERC165-supportsInterface}.
613      */
614     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
615         return interfaceId == type(IERC165).interfaceId;
616     }
617 }
618 
619 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
620 
621 
622 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
623 
624 pragma solidity ^0.8.0;
625 
626 
627 /**
628  * @dev _Available since v3.1._
629  */
630 interface IERC1155Receiver is IERC165 {
631     /**
632      * @dev Handles the receipt of a single ERC1155 token type. This function is
633      * called at the end of a `safeTransferFrom` after the balance has been updated.
634      *
635      * NOTE: To accept the transfer, this must return
636      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
637      * (i.e. 0xf23a6e61, or its own function selector).
638      *
639      * @param operator The address which initiated the transfer (i.e. msg.sender)
640      * @param from The address which previously owned the token
641      * @param id The ID of the token being transferred
642      * @param value The amount of tokens being transferred
643      * @param data Additional data with no specified format
644      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
645      */
646     function onERC1155Received(
647         address operator,
648         address from,
649         uint256 id,
650         uint256 value,
651         bytes calldata data
652     ) external returns (bytes4);
653 
654     /**
655      * @dev Handles the receipt of a multiple ERC1155 token types. This function
656      * is called at the end of a `safeBatchTransferFrom` after the balances have
657      * been updated.
658      *
659      * NOTE: To accept the transfer(s), this must return
660      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
661      * (i.e. 0xbc197c81, or its own function selector).
662      *
663      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
664      * @param from The address which previously owned the token
665      * @param ids An array containing ids of each token being transferred (order and length must match values array)
666      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
667      * @param data Additional data with no specified format
668      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
669      */
670     function onERC1155BatchReceived(
671         address operator,
672         address from,
673         uint256[] calldata ids,
674         uint256[] calldata values,
675         bytes calldata data
676     ) external returns (bytes4);
677 }
678 
679 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
680 
681 
682 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
683 
684 pragma solidity ^0.8.0;
685 
686 
687 /**
688  * @dev Required interface of an ERC1155 compliant contract, as defined in the
689  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
690  *
691  * _Available since v3.1._
692  */
693 interface IERC1155 is IERC165 {
694     /**
695      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
696      */
697     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
698 
699     /**
700      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
701      * transfers.
702      */
703     event TransferBatch(
704         address indexed operator,
705         address indexed from,
706         address indexed to,
707         uint256[] ids,
708         uint256[] values
709     );
710 
711     /**
712      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
713      * `approved`.
714      */
715     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
716 
717     /**
718      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
719      *
720      * If an {URI} event was emitted for `id`, the standard
721      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
722      * returned by {IERC1155MetadataURI-uri}.
723      */
724     event URI(string value, uint256 indexed id);
725 
726     /**
727      * @dev Returns the amount of tokens of token type `id` owned by `account`.
728      *
729      * Requirements:
730      *
731      * - `account` cannot be the zero address.
732      */
733     function balanceOf(address account, uint256 id) external view returns (uint256);
734 
735     /**
736      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
737      *
738      * Requirements:
739      *
740      * - `accounts` and `ids` must have the same length.
741      */
742     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
743         external
744         view
745         returns (uint256[] memory);
746 
747     /**
748      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
749      *
750      * Emits an {ApprovalForAll} event.
751      *
752      * Requirements:
753      *
754      * - `operator` cannot be the caller.
755      */
756     function setApprovalForAll(address operator, bool approved) external;
757 
758     /**
759      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
760      *
761      * See {setApprovalForAll}.
762      */
763     function isApprovedForAll(address account, address operator) external view returns (bool);
764 
765     /**
766      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
767      *
768      * Emits a {TransferSingle} event.
769      *
770      * Requirements:
771      *
772      * - `to` cannot be the zero address.
773      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
774      * - `from` must have a balance of tokens of type `id` of at least `amount`.
775      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
776      * acceptance magic value.
777      */
778     function safeTransferFrom(
779         address from,
780         address to,
781         uint256 id,
782         uint256 amount,
783         bytes calldata data
784     ) external;
785 
786     /**
787      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
788      *
789      * Emits a {TransferBatch} event.
790      *
791      * Requirements:
792      *
793      * - `ids` and `amounts` must have the same length.
794      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
795      * acceptance magic value.
796      */
797     function safeBatchTransferFrom(
798         address from,
799         address to,
800         uint256[] calldata ids,
801         uint256[] calldata amounts,
802         bytes calldata data
803     ) external;
804 }
805 
806 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
807 
808 
809 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
810 
811 pragma solidity ^0.8.0;
812 
813 
814 /**
815  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
816  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
817  *
818  * _Available since v3.1._
819  */
820 interface IERC1155MetadataURI is IERC1155 {
821     /**
822      * @dev Returns the URI for token type `id`.
823      *
824      * If the `\{id\}` substring is present in the URI, it must be replaced by
825      * clients with the actual token type ID.
826      */
827     function uri(uint256 id) external view returns (string memory);
828 }
829 
830 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
831 
832 
833 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)
834 
835 pragma solidity ^0.8.0;
836 
837 
838 
839 
840 
841 
842 
843 /**
844  * @dev Implementation of the basic standard multi-token.
845  * See https://eips.ethereum.org/EIPS/eip-1155
846  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
847  *
848  * _Available since v3.1._
849  */
850 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
851     using Address for address;
852 
853     // Mapping from token ID to account balances
854     mapping(uint256 => mapping(address => uint256)) private _balances;
855 
856     // Mapping from account to operator approvals
857     mapping(address => mapping(address => bool)) private _operatorApprovals;
858 
859     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
860     string private _uri;
861 
862     /**
863      * @dev See {_setURI}.
864      */
865     constructor(string memory uri_) {
866         _setURI(uri_);
867     }
868 
869     /**
870      * @dev See {IERC165-supportsInterface}.
871      */
872     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
873         return
874             interfaceId == type(IERC1155).interfaceId ||
875             interfaceId == type(IERC1155MetadataURI).interfaceId ||
876             super.supportsInterface(interfaceId);
877     }
878 
879     /**
880      * @dev See {IERC1155MetadataURI-uri}.
881      *
882      * This implementation returns the same URI for *all* token types. It relies
883      * on the token type ID substitution mechanism
884      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
885      *
886      * Clients calling this function must replace the `\{id\}` substring with the
887      * actual token type ID.
888      */
889     function uri(uint256) public view virtual override returns (string memory) {
890         return _uri;
891     }
892 
893     /**
894      * @dev See {IERC1155-balanceOf}.
895      *
896      * Requirements:
897      *
898      * - `account` cannot be the zero address.
899      */
900     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
901         require(account != address(0), "ERC1155: address zero is not a valid owner");
902         return _balances[id][account];
903     }
904 
905     /**
906      * @dev See {IERC1155-balanceOfBatch}.
907      *
908      * Requirements:
909      *
910      * - `accounts` and `ids` must have the same length.
911      */
912     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
913         public
914         view
915         virtual
916         override
917         returns (uint256[] memory)
918     {
919         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
920 
921         uint256[] memory batchBalances = new uint256[](accounts.length);
922 
923         for (uint256 i = 0; i < accounts.length; ++i) {
924             batchBalances[i] = balanceOf(accounts[i], ids[i]);
925         }
926 
927         return batchBalances;
928     }
929 
930     /**
931      * @dev See {IERC1155-setApprovalForAll}.
932      */
933     function setApprovalForAll(address operator, bool approved) public virtual override {
934         _setApprovalForAll(_msgSender(), operator, approved);
935     }
936 
937     /**
938      * @dev See {IERC1155-isApprovedForAll}.
939      */
940     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
941         return _operatorApprovals[account][operator];
942     }
943 
944     /**
945      * @dev See {IERC1155-safeTransferFrom}.
946      */
947     function safeTransferFrom(
948         address from,
949         address to,
950         uint256 id,
951         uint256 amount,
952         bytes memory data
953     ) public virtual override {
954         require(
955             from == _msgSender() || isApprovedForAll(from, _msgSender()),
956             "ERC1155: caller is not token owner nor approved"
957         );
958         _safeTransferFrom(from, to, id, amount, data);
959     }
960 
961     /**
962      * @dev See {IERC1155-safeBatchTransferFrom}.
963      */
964     function safeBatchTransferFrom(
965         address from,
966         address to,
967         uint256[] memory ids,
968         uint256[] memory amounts,
969         bytes memory data
970     ) public virtual override {
971         require(
972             from == _msgSender() || isApprovedForAll(from, _msgSender()),
973             "ERC1155: caller is not token owner nor approved"
974         );
975         _safeBatchTransferFrom(from, to, ids, amounts, data);
976     }
977 
978     /**
979      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
980      *
981      * Emits a {TransferSingle} event.
982      *
983      * Requirements:
984      *
985      * - `to` cannot be the zero address.
986      * - `from` must have a balance of tokens of type `id` of at least `amount`.
987      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
988      * acceptance magic value.
989      */
990     function _safeTransferFrom(
991         address from,
992         address to,
993         uint256 id,
994         uint256 amount,
995         bytes memory data
996     ) internal virtual {
997         require(to != address(0), "ERC1155: transfer to the zero address");
998 
999         address operator = _msgSender();
1000         uint256[] memory ids = _asSingletonArray(id);
1001         uint256[] memory amounts = _asSingletonArray(amount);
1002 
1003         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1004 
1005         uint256 fromBalance = _balances[id][from];
1006         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1007         unchecked {
1008             _balances[id][from] = fromBalance - amount;
1009         }
1010         _balances[id][to] += amount;
1011 
1012         emit TransferSingle(operator, from, to, id, amount);
1013 
1014         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1015 
1016         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1017     }
1018 
1019     /**
1020      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1021      *
1022      * Emits a {TransferBatch} event.
1023      *
1024      * Requirements:
1025      *
1026      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1027      * acceptance magic value.
1028      */
1029     function _safeBatchTransferFrom(
1030         address from,
1031         address to,
1032         uint256[] memory ids,
1033         uint256[] memory amounts,
1034         bytes memory data
1035     ) internal virtual {
1036         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1037         require(to != address(0), "ERC1155: transfer to the zero address");
1038 
1039         address operator = _msgSender();
1040 
1041         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1042 
1043         for (uint256 i = 0; i < ids.length; ++i) {
1044             uint256 id = ids[i];
1045             uint256 amount = amounts[i];
1046 
1047             uint256 fromBalance = _balances[id][from];
1048             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1049             unchecked {
1050                 _balances[id][from] = fromBalance - amount;
1051             }
1052             _balances[id][to] += amount;
1053         }
1054 
1055         emit TransferBatch(operator, from, to, ids, amounts);
1056 
1057         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1058 
1059         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1060     }
1061 
1062     /**
1063      * @dev Sets a new URI for all token types, by relying on the token type ID
1064      * substitution mechanism
1065      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1066      *
1067      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1068      * URI or any of the amounts in the JSON file at said URI will be replaced by
1069      * clients with the token type ID.
1070      *
1071      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1072      * interpreted by clients as
1073      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1074      * for token type ID 0x4cce0.
1075      *
1076      * See {uri}.
1077      *
1078      * Because these URIs cannot be meaningfully represented by the {URI} event,
1079      * this function emits no events.
1080      */
1081     function _setURI(string memory newuri) internal virtual {
1082         _uri = newuri;
1083     }
1084 
1085     /**
1086      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1087      *
1088      * Emits a {TransferSingle} event.
1089      *
1090      * Requirements:
1091      *
1092      * - `to` cannot be the zero address.
1093      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1094      * acceptance magic value.
1095      */
1096     function _mint(
1097         address to,
1098         uint256 id,
1099         uint256 amount,
1100         bytes memory data
1101     ) internal virtual {
1102         require(to != address(0), "ERC1155: mint to the zero address");
1103 
1104         address operator = _msgSender();
1105         uint256[] memory ids = _asSingletonArray(id);
1106         uint256[] memory amounts = _asSingletonArray(amount);
1107 
1108         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1109 
1110         _balances[id][to] += amount;
1111         emit TransferSingle(operator, address(0), to, id, amount);
1112 
1113         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1114 
1115         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1116     }
1117 
1118     /**
1119      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1120      *
1121      * Emits a {TransferBatch} event.
1122      *
1123      * Requirements:
1124      *
1125      * - `ids` and `amounts` must have the same length.
1126      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1127      * acceptance magic value.
1128      */
1129     function _mintBatch(
1130         address to,
1131         uint256[] memory ids,
1132         uint256[] memory amounts,
1133         bytes memory data
1134     ) internal virtual {
1135         require(to != address(0), "ERC1155: mint to the zero address");
1136         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1137 
1138         address operator = _msgSender();
1139 
1140         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1141 
1142         for (uint256 i = 0; i < ids.length; i++) {
1143             _balances[ids[i]][to] += amounts[i];
1144         }
1145 
1146         emit TransferBatch(operator, address(0), to, ids, amounts);
1147 
1148         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1149 
1150         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1151     }
1152 
1153     /**
1154      * @dev Destroys `amount` tokens of token type `id` from `from`
1155      *
1156      * Emits a {TransferSingle} event.
1157      *
1158      * Requirements:
1159      *
1160      * - `from` cannot be the zero address.
1161      * - `from` must have at least `amount` tokens of token type `id`.
1162      */
1163     function _burn(
1164         address from,
1165         uint256 id,
1166         uint256 amount
1167     ) internal virtual {
1168         require(from != address(0), "ERC1155: burn from the zero address");
1169 
1170         address operator = _msgSender();
1171         uint256[] memory ids = _asSingletonArray(id);
1172         uint256[] memory amounts = _asSingletonArray(amount);
1173 
1174         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1175 
1176         uint256 fromBalance = _balances[id][from];
1177         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1178         unchecked {
1179             _balances[id][from] = fromBalance - amount;
1180         }
1181 
1182         emit TransferSingle(operator, from, address(0), id, amount);
1183 
1184         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1185     }
1186 
1187     /**
1188      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1189      *
1190      * Emits a {TransferBatch} event.
1191      *
1192      * Requirements:
1193      *
1194      * - `ids` and `amounts` must have the same length.
1195      */
1196     function _burnBatch(
1197         address from,
1198         uint256[] memory ids,
1199         uint256[] memory amounts
1200     ) internal virtual {
1201         require(from != address(0), "ERC1155: burn from the zero address");
1202         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1203 
1204         address operator = _msgSender();
1205 
1206         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1207 
1208         for (uint256 i = 0; i < ids.length; i++) {
1209             uint256 id = ids[i];
1210             uint256 amount = amounts[i];
1211 
1212             uint256 fromBalance = _balances[id][from];
1213             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1214             unchecked {
1215                 _balances[id][from] = fromBalance - amount;
1216             }
1217         }
1218 
1219         emit TransferBatch(operator, from, address(0), ids, amounts);
1220 
1221         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1222     }
1223 
1224     /**
1225      * @dev Approve `operator` to operate on all of `owner` tokens
1226      *
1227      * Emits an {ApprovalForAll} event.
1228      */
1229     function _setApprovalForAll(
1230         address owner,
1231         address operator,
1232         bool approved
1233     ) internal virtual {
1234         require(owner != operator, "ERC1155: setting approval status for self");
1235         _operatorApprovals[owner][operator] = approved;
1236         emit ApprovalForAll(owner, operator, approved);
1237     }
1238 
1239     /**
1240      * @dev Hook that is called before any token transfer. This includes minting
1241      * and burning, as well as batched variants.
1242      *
1243      * The same hook is called on both single and batched variants. For single
1244      * transfers, the length of the `ids` and `amounts` arrays will be 1.
1245      *
1246      * Calling conditions (for each `id` and `amount` pair):
1247      *
1248      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1249      * of token type `id` will be  transferred to `to`.
1250      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1251      * for `to`.
1252      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1253      * will be burned.
1254      * - `from` and `to` are never both zero.
1255      * - `ids` and `amounts` have the same, non-zero length.
1256      *
1257      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1258      */
1259     function _beforeTokenTransfer(
1260         address operator,
1261         address from,
1262         address to,
1263         uint256[] memory ids,
1264         uint256[] memory amounts,
1265         bytes memory data
1266     ) internal virtual {}
1267 
1268     /**
1269      * @dev Hook that is called after any token transfer. This includes minting
1270      * and burning, as well as batched variants.
1271      *
1272      * The same hook is called on both single and batched variants. For single
1273      * transfers, the length of the `id` and `amount` arrays will be 1.
1274      *
1275      * Calling conditions (for each `id` and `amount` pair):
1276      *
1277      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1278      * of token type `id` will be  transferred to `to`.
1279      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1280      * for `to`.
1281      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1282      * will be burned.
1283      * - `from` and `to` are never both zero.
1284      * - `ids` and `amounts` have the same, non-zero length.
1285      *
1286      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1287      */
1288     function _afterTokenTransfer(
1289         address operator,
1290         address from,
1291         address to,
1292         uint256[] memory ids,
1293         uint256[] memory amounts,
1294         bytes memory data
1295     ) internal virtual {}
1296 
1297     function _doSafeTransferAcceptanceCheck(
1298         address operator,
1299         address from,
1300         address to,
1301         uint256 id,
1302         uint256 amount,
1303         bytes memory data
1304     ) private {
1305         if (to.isContract()) {
1306             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1307                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1308                     revert("ERC1155: ERC1155Receiver rejected tokens");
1309                 }
1310             } catch Error(string memory reason) {
1311                 revert(reason);
1312             } catch {
1313                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1314             }
1315         }
1316     }
1317 
1318     function _doSafeBatchTransferAcceptanceCheck(
1319         address operator,
1320         address from,
1321         address to,
1322         uint256[] memory ids,
1323         uint256[] memory amounts,
1324         bytes memory data
1325     ) private {
1326         if (to.isContract()) {
1327             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1328                 bytes4 response
1329             ) {
1330                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1331                     revert("ERC1155: ERC1155Receiver rejected tokens");
1332                 }
1333             } catch Error(string memory reason) {
1334                 revert(reason);
1335             } catch {
1336                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1337             }
1338         }
1339     }
1340 
1341     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1342         uint256[] memory array = new uint256[](1);
1343         array[0] = element;
1344 
1345         return array;
1346     }
1347 }
1348 
1349 // File: betacalls.sol
1350 
1351 
1352 
1353 // Contract by @UnchainedAgency
1354 
1355 pragma solidity ^0.8.4;
1356 
1357 
1358 
1359 
1360 contract BetaCalls is ERC1155, Ownable {
1361 
1362     event Mint(address indexed to, uint256[] indexed tokenId);
1363     event Revoke(address indexed to, uint256[] indexed tokenId);
1364 
1365     string public name = "Beta Calls Pass";
1366 
1367     string private tokenURI = "ipfs://bafybeibmwdlkysyjixyxdua5bi4bkq7lnrj5r5pn3trrtunuz42vgitnlm/0.json";
1368     bytes32 public whitelistMerkleRoot;
1369 
1370 
1371     constructor() ERC1155("Beta Calls") { }
1372 
1373     function claim(bytes32[] calldata _merkleProof) public {
1374 
1375         require(balanceOf(msg.sender, 0) == 0, "Already Holding Beta Calls Pass");
1376 
1377         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1378         require(MerkleProof.verify(_merkleProof, whitelistMerkleRoot, leaf), "Invalid Merkle Proof");
1379 
1380 
1381 
1382         _mint(msg.sender, 0, 1, "");
1383 
1384     }
1385 
1386     function mint(address to) public onlyOwner {
1387 
1388         require(balanceOf(to, 0) == 0, "Already Holding Beta Calls Pass");
1389 
1390         _mint(to, 0, 1, "");
1391     }
1392 
1393     function massMint(address[] calldata to) public onlyOwner {
1394 
1395         for (uint i = 0; i < to.length; i++) {
1396 
1397             require(balanceOf(to[i], 0) == 0, "Already Holding Beta Calls Pass");
1398 
1399             _mint(to[i], 0, 1, "");
1400 
1401         }
1402 
1403     }
1404 
1405     function revoke(address wallet) external onlyOwner {
1406         _burn(wallet, 0, balanceOf(wallet, 0));
1407     }
1408 
1409     function _beforeTokenTransfer(
1410         address operator,
1411         address from,
1412         address to,
1413         uint256[] memory ids,
1414         uint256[] memory amounts,
1415         bytes memory data
1416     ) internal override virtual {
1417 
1418     require(from == address(0) || to == address(0), "Not allowed to transfer token");
1419 
1420     }
1421 
1422     function _afterTokenTransfer(
1423         address operator,
1424         address from,
1425         address to,
1426         uint256[] memory ids,
1427         uint256[] memory amounts,
1428         bytes memory data
1429     ) internal override virtual {
1430 
1431         if (from == address(0)) {
1432             emit Mint(to, ids);
1433         } else if (to == address(0)) {
1434             emit Revoke(to, ids);
1435         }
1436 
1437     }
1438 
1439     function uri(uint256 _id) override public view returns (string memory) {
1440         return(tokenURI);
1441     }
1442 
1443     function setTokenURI(string memory _uri) public onlyOwner {
1444 
1445         tokenURI = _uri;
1446 
1447     }
1448 
1449     function setWhitelistMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1450 
1451         whitelistMerkleRoot = _merkleRoot;
1452 
1453     }
1454 
1455 
1456 }