1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Context.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 // File: @openzeppelin/contracts/access/Ownable.sol
30 
31 
32 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor() {
58         _transferOwnership(_msgSender());
59     }
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         _checkOwner();
66         _;
67     }
68 
69     /**
70      * @dev Returns the address of the current owner.
71      */
72     function owner() public view virtual returns (address) {
73         return _owner;
74     }
75 
76     /**
77      * @dev Throws if the sender is not the owner.
78      */
79     function _checkOwner() internal view virtual {
80         require(owner() == _msgSender(), "Ownable: caller is not the owner");
81     }
82 
83     /**
84      * @dev Leaves the contract without owner. It will not be possible to call
85      * `onlyOwner` functions anymore. Can only be called by the current owner.
86      *
87      * NOTE: Renouncing ownership will leave the contract without an owner,
88      * thereby removing any functionality that is only available to the owner.
89      */
90     function renounceOwnership() public virtual onlyOwner {
91         _transferOwnership(address(0));
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Can only be called by the current owner.
97      */
98     function transferOwnership(address newOwner) public virtual onlyOwner {
99         require(newOwner != address(0), "Ownable: new owner is the zero address");
100         _transferOwnership(newOwner);
101     }
102 
103     /**
104      * @dev Transfers ownership of the contract to a new account (`newOwner`).
105      * Internal function without access restriction.
106      */
107     function _transferOwnership(address newOwner) internal virtual {
108         address oldOwner = _owner;
109         _owner = newOwner;
110         emit OwnershipTransferred(oldOwner, newOwner);
111     }
112 }
113 
114 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
115 
116 
117 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 /**
122  * @dev These functions deal with verification of Merkle Tree proofs.
123  *
124  * The proofs can be generated using the JavaScript library
125  * https://github.com/miguelmota/merkletreejs[merkletreejs].
126  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
127  *
128  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
129  *
130  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
131  * hashing, or use a hash function other than keccak256 for hashing leaves.
132  * This is because the concatenation of a sorted pair of internal nodes in
133  * the merkle tree could be reinterpreted as a leaf value.
134  */
135 library MerkleProof {
136     /**
137      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
138      * defined by `root`. For this, a `proof` must be provided, containing
139      * sibling hashes on the branch from the leaf to the root of the tree. Each
140      * pair of leaves and each pair of pre-images are assumed to be sorted.
141      */
142     function verify(
143         bytes32[] memory proof,
144         bytes32 root,
145         bytes32 leaf
146     ) internal pure returns (bool) {
147         return processProof(proof, leaf) == root;
148     }
149 
150     /**
151      * @dev Calldata version of {verify}
152      *
153      * _Available since v4.7._
154      */
155     function verifyCalldata(
156         bytes32[] calldata proof,
157         bytes32 root,
158         bytes32 leaf
159     ) internal pure returns (bool) {
160         return processProofCalldata(proof, leaf) == root;
161     }
162 
163     /**
164      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
165      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
166      * hash matches the root of the tree. When processing the proof, the pairs
167      * of leafs & pre-images are assumed to be sorted.
168      *
169      * _Available since v4.4._
170      */
171     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
172         bytes32 computedHash = leaf;
173         for (uint256 i = 0; i < proof.length; i++) {
174             computedHash = _hashPair(computedHash, proof[i]);
175         }
176         return computedHash;
177     }
178 
179     /**
180      * @dev Calldata version of {processProof}
181      *
182      * _Available since v4.7._
183      */
184     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
185         bytes32 computedHash = leaf;
186         for (uint256 i = 0; i < proof.length; i++) {
187             computedHash = _hashPair(computedHash, proof[i]);
188         }
189         return computedHash;
190     }
191 
192     /**
193      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
194      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
195      *
196      * _Available since v4.7._
197      */
198     function multiProofVerify(
199         bytes32[] memory proof,
200         bool[] memory proofFlags,
201         bytes32 root,
202         bytes32[] memory leaves
203     ) internal pure returns (bool) {
204         return processMultiProof(proof, proofFlags, leaves) == root;
205     }
206 
207     /**
208      * @dev Calldata version of {multiProofVerify}
209      *
210      * _Available since v4.7._
211      */
212     function multiProofVerifyCalldata(
213         bytes32[] calldata proof,
214         bool[] calldata proofFlags,
215         bytes32 root,
216         bytes32[] memory leaves
217     ) internal pure returns (bool) {
218         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
219     }
220 
221     /**
222      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
223      * consuming from one or the other at each step according to the instructions given by
224      * `proofFlags`.
225      *
226      * _Available since v4.7._
227      */
228     function processMultiProof(
229         bytes32[] memory proof,
230         bool[] memory proofFlags,
231         bytes32[] memory leaves
232     ) internal pure returns (bytes32 merkleRoot) {
233         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
234         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
235         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
236         // the merkle tree.
237         uint256 leavesLen = leaves.length;
238         uint256 totalHashes = proofFlags.length;
239 
240         // Check proof validity.
241         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
242 
243         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
244         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
245         bytes32[] memory hashes = new bytes32[](totalHashes);
246         uint256 leafPos = 0;
247         uint256 hashPos = 0;
248         uint256 proofPos = 0;
249         // At each step, we compute the next hash using two values:
250         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
251         //   get the next hash.
252         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
253         //   `proof` array.
254         for (uint256 i = 0; i < totalHashes; i++) {
255             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
256             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
257             hashes[i] = _hashPair(a, b);
258         }
259 
260         if (totalHashes > 0) {
261             return hashes[totalHashes - 1];
262         } else if (leavesLen > 0) {
263             return leaves[0];
264         } else {
265             return proof[0];
266         }
267     }
268 
269     /**
270      * @dev Calldata version of {processMultiProof}
271      *
272      * _Available since v4.7._
273      */
274     function processMultiProofCalldata(
275         bytes32[] calldata proof,
276         bool[] calldata proofFlags,
277         bytes32[] memory leaves
278     ) internal pure returns (bytes32 merkleRoot) {
279         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
280         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
281         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
282         // the merkle tree.
283         uint256 leavesLen = leaves.length;
284         uint256 totalHashes = proofFlags.length;
285 
286         // Check proof validity.
287         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
288 
289         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
290         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
291         bytes32[] memory hashes = new bytes32[](totalHashes);
292         uint256 leafPos = 0;
293         uint256 hashPos = 0;
294         uint256 proofPos = 0;
295         // At each step, we compute the next hash using two values:
296         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
297         //   get the next hash.
298         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
299         //   `proof` array.
300         for (uint256 i = 0; i < totalHashes; i++) {
301             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
302             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
303             hashes[i] = _hashPair(a, b);
304         }
305 
306         if (totalHashes > 0) {
307             return hashes[totalHashes - 1];
308         } else if (leavesLen > 0) {
309             return leaves[0];
310         } else {
311             return proof[0];
312         }
313     }
314 
315     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
316         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
317     }
318 
319     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
320         /// @solidity memory-safe-assembly
321         assembly {
322             mstore(0x00, a)
323             mstore(0x20, b)
324             value := keccak256(0x00, 0x40)
325         }
326     }
327 }
328 
329 // File: contracts/NortKoreanNFT.sol
330 
331 
332 
333 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
334 pragma solidity ^0.8.0;
335 
336 
337 
338 library Address {
339 
340     function isContract(address account) internal view returns (bool) {
341 
342         uint256 size;
343         assembly {
344             size := extcodesize(account)
345         }
346         return size > 0;
347     }
348 
349     function sendValue(address payable recipient, uint256 amount) internal {
350         require(address(this).balance >= amount, "Address: insufficient balance");
351 
352         (bool success, ) = recipient.call{value: amount}("");
353         require(success, "Address: unable to send value, recipient may have reverted");
354     }
355 
356     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
357         return functionCall(target, data, "Address: low-level call failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
362      * `errorMessage` as a fallback revert reason when `target` reverts.
363      *
364      * _Available since v3.1._
365      */
366     function functionCall(
367         address target,
368         bytes memory data,
369         string memory errorMessage
370     ) internal returns (bytes memory) {
371         return functionCallWithValue(target, data, 0, errorMessage);
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
376      * but also transferring `value` wei to `target`.
377      *
378      * Requirements:
379      *
380      * - the calling contract must have an ETH balance of at least `value`.
381      * - the called Solidity function must be `payable`.
382      *
383      * _Available since v3.1._
384      */
385     function functionCallWithValue(
386         address target,
387         bytes memory data,
388         uint256 value
389     ) internal returns (bytes memory) {
390         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
395      * with `errorMessage` as a fallback revert reason when `target` reverts.
396      *
397      * _Available since v3.1._
398      */
399     function functionCallWithValue(
400         address target,
401         bytes memory data,
402         uint256 value,
403         string memory errorMessage
404     ) internal returns (bytes memory) {
405         require(address(this).balance >= value, "Address: insufficient balance for call");
406         require(isContract(target), "Address: call to non-contract");
407 
408         (bool success, bytes memory returndata) = target.call{value: value}(data);
409         return verifyCallResult(success, returndata, errorMessage);
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
414      * but performing a static call.
415      *
416      * _Available since v3.3._
417      */
418     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
419         return functionStaticCall(target, data, "Address: low-level static call failed");
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
424      * but performing a static call.
425      *
426      * _Available since v3.3._
427      */
428     function functionStaticCall(
429         address target,
430         bytes memory data,
431         string memory errorMessage
432     ) internal view returns (bytes memory) {
433         require(isContract(target), "Address: static call to non-contract");
434 
435         (bool success, bytes memory returndata) = target.staticcall(data);
436         return verifyCallResult(success, returndata, errorMessage);
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
441      * but performing a delegate call.
442      *
443      * _Available since v3.4._
444      */
445     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
446         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
451      * but performing a delegate call.
452      *
453      * _Available since v3.4._
454      */
455     function functionDelegateCall(
456         address target,
457         bytes memory data,
458         string memory errorMessage
459     ) internal returns (bytes memory) {
460         require(isContract(target), "Address: delegate call to non-contract");
461 
462         (bool success, bytes memory returndata) = target.delegatecall(data);
463         return verifyCallResult(success, returndata, errorMessage);
464     }
465 
466     /**
467      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
468      * revert reason using the provided one.
469      *
470      * _Available since v4.3._
471      */
472     function verifyCallResult(
473         bool success,
474         bytes memory returndata,
475         string memory errorMessage
476     ) internal pure returns (bytes memory) {
477         if (success) {
478             return returndata;
479         } else {
480             // Look for revert reason and bubble it up if present
481             if (returndata.length > 0) {
482                 // The easiest way to bubble the revert reason is using memory via assembly
483 
484                 assembly {
485                     let returndata_size := mload(returndata)
486                     revert(add(32, returndata), returndata_size)
487                 }
488             } else {
489                 revert(errorMessage);
490             }
491         }
492     }
493 }
494 
495 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.2
496 pragma solidity ^0.8.0;
497 
498 /**
499  * @dev String operations.
500  */
501 library Strings {
502     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
503 
504     /**
505      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
506      */
507     function toString(uint256 value) internal pure returns (string memory) {
508         // Inspired by OraclizeAPI's implementation - MIT licence
509         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
510 
511         if (value == 0) {
512             return "0";
513         }
514         uint256 temp = value;
515         uint256 digits;
516         while (temp != 0) {
517             digits++;
518             temp /= 10;
519         }
520         bytes memory buffer = new bytes(digits);
521         while (value != 0) {
522             digits -= 1;
523             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
524             value /= 10;
525         }
526         return string(buffer);
527     }
528 
529     /**
530      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
531      */
532     function toHexString(uint256 value) internal pure returns (string memory) {
533         if (value == 0) {
534             return "0x00";
535         }
536         uint256 temp = value;
537         uint256 length = 0;
538         while (temp != 0) {
539             length++;
540             temp >>= 8;
541         }
542         return toHexString(value, length);
543     }
544 
545     /**
546      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
547      */
548     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
549         bytes memory buffer = new bytes(2 * length + 2);
550         buffer[0] = "0";
551         buffer[1] = "x";
552         for (uint256 i = 2 * length + 1; i > 1; --i) {
553             buffer[i] = _HEX_SYMBOLS[value & 0xf];
554             value >>= 4;
555         }
556         require(value == 0, "Strings: hex length insufficient");
557         return string(buffer);
558     }
559 }
560 
561 
562 // File @openzeppelin/contracts/utils/Counters.sol@v4.3.2
563 pragma solidity ^0.8.0;
564 
565 /**
566  * @title Counters
567  * @author Matt Condon (@shrugs)
568  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
569  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
570  *
571  * Include with `using Counters for Counters.Counter;`
572  */
573 library Counters {
574     struct Counter {
575         // This variable should never be directly accessed by users of the library: interactions must be restricted to
576         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
577         // this feature: see https://github.com/ethereum/solidity/issues/4637
578         uint256 _value; // default: 0
579     }
580 
581     function current(Counter storage counter) internal view returns (uint256) {
582         return counter._value;
583     }
584 
585     function increment(Counter storage counter) internal {
586         unchecked {
587             counter._value += 1;
588         }
589     }
590 
591     function decrement(Counter storage counter) internal {
592         uint256 value = counter._value;
593         require(value > 0, "Counter: decrement overflow");
594         unchecked {
595             counter._value = value - 1;
596         }
597     }
598 
599     function reset(Counter storage counter) internal {
600         counter._value = 0;
601     }
602 }
603 
604 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.2
605 pragma solidity ^0.8.0;
606 
607 /**
608  * @dev Interface of the ERC165 standard, as defined in the
609  * https://eips.ethereum.org/EIPS/eip-165[EIP].
610  *
611  * Implementers can declare support of contract interfaces, which can then be
612  * queried by others ({ERC165Checker}).
613  *
614  * For an implementation, see {ERC165}.
615  */
616 interface IERC165 {
617     /**
618      * @dev Returns true if this contract implements the interface defined by
619      * `interfaceId`. See the corresponding
620      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
621      * to learn more about how these ids are created.
622      *
623      * This function call must use less than 30 000 gas.
624      */
625     function supportsInterface(bytes4 interfaceId) external view returns (bool);
626 }
627 
628 
629 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.2
630 pragma solidity ^0.8.0;
631 
632 /**
633  * @dev Required interface of an ERC721 compliant contract.
634  */
635 interface IERC721 is IERC165 {
636     /**
637      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
638      */
639     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
640 
641     /**
642      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
643      */
644     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
645 
646     /**
647      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
648      */
649     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
650 
651     /**
652      * @dev Returns the number of tokens in ``owner``'s account.
653      */
654     function balanceOf(address owner) external view returns (uint256 balance);
655 
656     /**
657      * @dev Returns the owner of the `tokenId` token.
658      *
659      * Requirements:
660      *
661      * - `tokenId` must exist.
662      */
663     function ownerOf(uint256 tokenId) external view returns (address owner);
664 
665     /**
666      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
667      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
668      *
669      * Requirements:
670      *
671      * - `from` cannot be the zero address.
672      * - `to` cannot be the zero address.
673      * - `tokenId` token must exist and be owned by `from`.
674      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
675      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
676      *
677      * Emits a {Transfer} event.
678      */
679     function safeTransferFrom(
680         address from,
681         address to,
682         uint256 tokenId
683     ) external;
684 
685     /**
686      * @dev Transfers `tokenId` token from `from` to `to`.
687      *
688      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
689      *
690      * Requirements:
691      *
692      * - `from` cannot be the zero address.
693      * - `to` cannot be the zero address.
694      * - `tokenId` token must be owned by `from`.
695      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
696      *
697      * Emits a {Transfer} event.
698      */
699     function transferFrom(
700         address from,
701         address to,
702         uint256 tokenId
703     ) external;
704 
705     /**
706      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
707      * The approval is cleared when the token is transferred.
708      *
709      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
710      *
711      * Requirements:
712      *
713      * - The caller must own the token or be an approved operator.
714      * - `tokenId` must exist.
715      *
716      * Emits an {Approval} event.
717      */
718     function approve(address to, uint256 tokenId) external;
719 
720     /**
721      * @dev Returns the account approved for `tokenId` token.
722      *
723      * Requirements:
724      *
725      * - `tokenId` must exist.
726      */
727     function getApproved(uint256 tokenId) external view returns (address operator);
728 
729     /**
730      * @dev Approve or remove `operator` as an operator for the caller.
731      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
732      *
733      * Requirements:
734      *
735      * - The `operator` cannot be the caller.
736      *
737      * Emits an {ApprovalForAll} event.
738      */
739     function setApprovalForAll(address operator, bool _approved) external;
740 
741     /**
742      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
743      *
744      * See {setApprovalForAll}
745      */
746     function isApprovedForAll(address owner, address operator) external view returns (bool);
747 
748     /**
749      * @dev Safely transfers `tokenId` token from `from` to `to`.
750      *
751      * Requirements:
752      *
753      * - `from` cannot be the zero address.
754      * - `to` cannot be the zero address.
755      * - `tokenId` token must exist and be owned by `from`.
756      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
757      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
758      *
759      * Emits a {Transfer} event.
760      */
761     function safeTransferFrom(
762         address from,
763         address to,
764         uint256 tokenId,
765         bytes calldata data
766     ) external;
767 }
768 
769 
770 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.2
771 pragma solidity ^0.8.0;
772 
773 /**
774  * @title ERC721 token receiver interface
775  * @dev Interface for any contract that wants to support safeTransfers
776  * from ERC721 asset contracts.
777  */
778 interface IERC721Receiver {
779     /**
780      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
781      * by `operator` from `from`, this function is called.
782      *
783      * It must return its Solidity selector to confirm the token transfer.
784      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
785      *
786      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
787      */
788     function onERC721Received(
789         address operator,
790         address from,
791         uint256 tokenId,
792         bytes calldata data
793     ) external returns (bytes4);
794 }
795 
796 
797 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.2
798 pragma solidity ^0.8.0;
799 
800 /**
801  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
802  * @dev See https://eips.ethereum.org/EIPS/eip-721
803  */
804 interface IERC721Metadata is IERC721 {
805     /**
806      * @dev Returns the token collection name.
807      */
808     function name() external view returns (string memory);
809 
810     /**
811      * @dev Returns the token collection symbol.
812      */
813     function symbol() external view returns (string memory);
814 
815     /**
816      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
817      */
818     function tokenURI(uint256 tokenId) external view returns (string memory);
819 }
820 
821 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
822 pragma solidity ^0.8.0;
823 
824 /**
825  * @dev Implementation of the {IERC165} interface.
826  *
827  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
828  * for the additional interface id that will be supported. For example:
829  *
830  * ```solidity
831  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
832  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
833  * }
834  * ```
835  *
836  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
837  */
838 abstract contract ERC165 is IERC165 {
839     /**
840      * @dev See {IERC165-supportsInterface}.
841      */
842     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
843         return interfaceId == type(IERC165).interfaceId;
844     }
845 }
846 
847 
848 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.2
849 pragma solidity ^0.8.0;
850 
851 /**
852  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
853  * the Metadata extension, but not including the Enumerable extension, which is available separately as
854  * {ERC721Enumerable}.
855  */
856 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
857     using Address for address;
858     using Strings for uint256;
859 
860     // Token name
861     string private _name;
862 
863     // Token symbol
864     string private _symbol;
865 
866     // Mapping from token ID to owner address
867     mapping(uint256 => address) private _owners;
868 
869     // Mapping owner address to token count
870     mapping(address => uint256) private _balances;
871 
872     // Mapping from token ID to approved address
873     mapping(uint256 => address) private _tokenApprovals;
874 
875     // Mapping from owner to operator approvals
876     mapping(address => mapping(address => bool)) private _operatorApprovals;
877 
878     /**
879      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
880      */
881     constructor(string memory name_, string memory symbol_) {
882         _name = name_;
883         _symbol = symbol_;
884     }
885 
886     /**
887      * @dev See {IERC165-supportsInterface}.
888      */
889     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
890         return
891             interfaceId == type(IERC721).interfaceId ||
892             interfaceId == type(IERC721Metadata).interfaceId ||
893             super.supportsInterface(interfaceId);
894     }
895 
896     /**
897      * @dev See {IERC721-balanceOf}.
898      */
899     function balanceOf(address owner) public view virtual override returns (uint256) {
900         require(owner != address(0), "ERC721: balance query for the zero address");
901         return _balances[owner];
902     }
903 
904     /**
905      * @dev See {IERC721-ownerOf}.
906      */
907     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
908         address owner = _owners[tokenId];
909         require(owner != address(0), "ERC721: owner query for nonexistent token");
910         return owner;
911     }
912 
913     /**
914      * @dev See {IERC721Metadata-name}.
915      */
916     function name() public view virtual override returns (string memory) {
917         return _name;
918     }
919 
920     /**
921      * @dev See {IERC721Metadata-symbol}.
922      */
923     function symbol() public view virtual override returns (string memory) {
924         return _symbol;
925     }
926 
927     /**
928      * @dev See {IERC721Metadata-tokenURI}.
929      */
930     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
931         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
932 
933         string memory baseURI = _baseURI();
934         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
935     }
936 
937     /**
938      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
939      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
940      * by default, can be overriden in child contracts.
941      */
942     function _baseURI() internal view virtual returns (string memory) {
943         return "";
944     }
945 
946     /**
947      * @dev See {IERC721-approve}.
948      */
949     function approve(address to, uint256 tokenId) public virtual override {
950         address owner = ERC721.ownerOf(tokenId);
951         require(to != owner, "ERC721: approval to current owner");
952 
953         require(
954             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
955             "ERC721: approve caller is not owner nor approved for all"
956         );
957 
958         _approve(to, tokenId);
959     }
960 
961     /**
962      * @dev See {IERC721-getApproved}.
963      */
964     function getApproved(uint256 tokenId) public view virtual override returns (address) {
965         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
966 
967         return _tokenApprovals[tokenId];
968     }
969 
970     /**
971      * @dev See {IERC721-setApprovalForAll}.
972      */
973     function setApprovalForAll(address operator, bool approved) public virtual override {
974         require(operator != _msgSender(), "ERC721: approve to caller");
975 
976         _operatorApprovals[_msgSender()][operator] = approved;
977         emit ApprovalForAll(_msgSender(), operator, approved);
978     }
979 
980     /**
981      * @dev See {IERC721-isApprovedForAll}.
982      */
983     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
984         return _operatorApprovals[owner][operator];
985     }
986 
987     /**
988      * @dev See {IERC721-transferFrom}.
989      */
990     function transferFrom(
991         address from,
992         address to,
993         uint256 tokenId
994     ) public virtual override {
995         //solhint-disable-next-line max-line-length
996         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
997 
998         _transfer(from, to, tokenId);
999     }
1000 
1001     /**
1002      * @dev See {IERC721-safeTransferFrom}.
1003      */
1004     function safeTransferFrom(
1005         address from,
1006         address to,
1007         uint256 tokenId
1008     ) public virtual override {
1009         safeTransferFrom(from, to, tokenId, "");
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-safeTransferFrom}.
1014      */
1015     function safeTransferFrom(
1016         address from,
1017         address to,
1018         uint256 tokenId,
1019         bytes memory _data
1020     ) public virtual override {
1021         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1022         _safeTransfer(from, to, tokenId, _data);
1023     }
1024 
1025     /**
1026      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1027      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1028      *
1029      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1030      *
1031      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1032      * implement alternative mechanisms to perform token transfer, such as signature-based.
1033      *
1034      * Requirements:
1035      *
1036      * - `from` cannot be the zero address.
1037      * - `to` cannot be the zero address.
1038      * - `tokenId` token must exist and be owned by `from`.
1039      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1040      *
1041      * Emits a {Transfer} event.
1042      */
1043     function _safeTransfer(
1044         address from,
1045         address to,
1046         uint256 tokenId,
1047         bytes memory _data
1048     ) internal virtual {
1049         _transfer(from, to, tokenId);
1050         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1051     }
1052 
1053     /**
1054      * @dev Returns whether `tokenId` exists.
1055      *
1056      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1057      *
1058      * Tokens start existing when they are minted (`_mint`),
1059      * and stop existing when they are burned (`_burn`).
1060      */
1061     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1062         return _owners[tokenId] != address(0);
1063     }
1064 
1065     /**
1066      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1067      *
1068      * Requirements:
1069      *
1070      * - `tokenId` must exist.
1071      */
1072     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1073         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1074         address owner = ERC721.ownerOf(tokenId);
1075         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1076     }
1077 
1078     /**
1079      * @dev Safely mints `tokenId` and transfers it to `to`.
1080      *
1081      * Requirements:
1082      *
1083      * - `tokenId` must not exist.
1084      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1085      *
1086      * Emits a {Transfer} event.
1087      */
1088     function _safeMint(address to, uint256 tokenId) internal virtual {
1089         _safeMint(to, tokenId, "");
1090     }
1091 
1092     /**
1093      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1094      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1095      */
1096     function _safeMint(
1097         address to,
1098         uint256 tokenId,
1099         bytes memory _data
1100     ) internal virtual {
1101         _mint(to, tokenId);
1102         require(
1103             _checkOnERC721Received(address(0), to, tokenId, _data),
1104             "ERC721: transfer to non ERC721Receiver implementer"
1105         );
1106     }
1107 
1108     /**
1109      * @dev Mints `tokenId` and transfers it to `to`.
1110      *
1111      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1112      *
1113      * Requirements:
1114      *
1115      * - `tokenId` must not exist.
1116      * - `to` cannot be the zero address.
1117      *
1118      * Emits a {Transfer} event.
1119      */
1120     function _mint(address to, uint256 tokenId) internal virtual {
1121         require(to != address(0), "ERC721: mint to the zero address");
1122         require(!_exists(tokenId), "ERC721: token already minted");
1123 
1124         _beforeTokenTransfer(address(0), to, tokenId);
1125 
1126         _balances[to] += 1;
1127         _owners[tokenId] = to;
1128 
1129         emit Transfer(address(0), to, tokenId);
1130     }
1131 
1132     /**
1133      * @dev Destroys `tokenId`.
1134      * The approval is cleared when the token is burned.
1135      *
1136      * Requirements:
1137      *
1138      * - `tokenId` must exist.
1139      *
1140      * Emits a {Transfer} event.
1141      */
1142     function _burn(uint256 tokenId) internal virtual {
1143         address owner = ERC721.ownerOf(tokenId);
1144 
1145         _beforeTokenTransfer(owner, address(0), tokenId);
1146 
1147         // Clear approvals
1148         _approve(address(0), tokenId);
1149 
1150         _balances[owner] -= 1;
1151         delete _owners[tokenId];
1152 
1153         emit Transfer(owner, address(0), tokenId);
1154     }
1155 
1156     /**
1157      * @dev Transfers `tokenId` from `from` to `to`.
1158      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1159      *
1160      * Requirements:
1161      *
1162      * - `to` cannot be the zero address.
1163      * - `tokenId` token must be owned by `from`.
1164      *
1165      * Emits a {Transfer} event.
1166      */
1167     function _transfer(
1168         address from,
1169         address to,
1170         uint256 tokenId
1171     ) internal virtual {
1172         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1173         require(to != address(0), "ERC721: transfer to the zero address");
1174 
1175         _beforeTokenTransfer(from, to, tokenId);
1176 
1177         // Clear approvals from the previous owner
1178         _approve(address(0), tokenId);
1179 
1180         _balances[from] -= 1;
1181         _balances[to] += 1;
1182         _owners[tokenId] = to;
1183 
1184         emit Transfer(from, to, tokenId);
1185     }
1186 
1187     /**
1188      * @dev Approve `to` to operate on `tokenId`
1189      *
1190      * Emits a {Approval} event.
1191      */
1192     function _approve(address to, uint256 tokenId) internal virtual {
1193         _tokenApprovals[tokenId] = to;
1194         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1195     }
1196 
1197     /**
1198      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1199      * The call is not executed if the target address is not a contract.
1200      *
1201      * @param from address representing the previous owner of the given token ID
1202      * @param to target address that will receive the tokens
1203      * @param tokenId uint256 ID of the token to be transferred
1204      * @param _data bytes optional data to send along with the call
1205      * @return bool whether the call correctly returned the expected magic value
1206      */
1207     function _checkOnERC721Received(
1208         address from,
1209         address to,
1210         uint256 tokenId,
1211         bytes memory _data
1212     ) private returns (bool) {
1213         if (to.isContract()) {
1214             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1215                 return retval == IERC721Receiver.onERC721Received.selector;
1216             } catch (bytes memory reason) {
1217                 if (reason.length == 0) {
1218                     revert("ERC721: transfer to non ERC721Receiver implementer");
1219                 } else {
1220                     assembly {
1221                         revert(add(32, reason), mload(reason))
1222                     }
1223                 }
1224             }
1225         } else {
1226             return true;
1227         }
1228     }
1229 
1230     /**
1231      * @dev Hook that is called before any token transfer. This includes minting
1232      * and burning.
1233      *
1234      * Calling conditions:
1235      *
1236      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1237      * transferred to `to`.
1238      * - When `from` is zero, `tokenId` will be minted for `to`.
1239      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1240      * - `from` and `to` are never both zero.
1241      *
1242      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1243      */
1244     function _beforeTokenTransfer(
1245         address from,
1246         address to,
1247         uint256 tokenId
1248     ) internal virtual {}
1249 }
1250 
1251 
1252 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.2
1253 
1254 
1255 pragma solidity ^0.8.0;
1256 
1257 /**
1258  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1259  * @dev See https://eips.ethereum.org/EIPS/eip-721
1260  */
1261 interface IERC721Enumerable is IERC721 {
1262     /**
1263      * @dev Returns the total amount of tokens stored by the contract.
1264      */
1265     function totalSupply() external view returns (uint256);
1266 
1267     /**
1268      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1269      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1270      */
1271     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1272 
1273     /**
1274      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1275      * Use along with {totalSupply} to enumerate all tokens.
1276      */
1277     function tokenByIndex(uint256 index) external view returns (uint256);
1278 }
1279 
1280 
1281 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.2
1282 
1283 
1284 pragma solidity ^0.8.0;
1285 
1286 
1287 /**
1288  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1289  * enumerability of all the token ids in the contract as well as all token ids owned by each
1290  * account.
1291  */
1292 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1293     // Mapping from owner to list of owned token IDs
1294     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1295 
1296     // Mapping from token ID to index of the owner tokens list
1297     mapping(uint256 => uint256) private _ownedTokensIndex;
1298 
1299     // Array with all token ids, used for enumeration
1300     uint256[] private _allTokens;
1301 
1302     // Mapping from token id to position in the allTokens array
1303     mapping(uint256 => uint256) private _allTokensIndex;
1304 
1305     /**
1306      * @dev See {IERC165-supportsInterface}.
1307      */
1308     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1309         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1310     }
1311 
1312     /**
1313      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1314      */
1315     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1316         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1317         return _ownedTokens[owner][index];
1318     }
1319 
1320     /**
1321      * @dev See {IERC721Enumerable-totalSupply}.
1322      */
1323     function totalSupply() public view virtual override returns (uint256) {
1324         return _allTokens.length;
1325     }
1326 
1327     /**
1328      * @dev See {IERC721Enumerable-tokenByIndex}.
1329      */
1330     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1331         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1332         return _allTokens[index];
1333     }
1334 
1335     /**
1336      * @dev Hook that is called before any token transfer. This includes minting
1337      * and burning.
1338      *
1339      * Calling conditions:
1340      *
1341      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1342      * transferred to `to`.
1343      * - When `from` is zero, `tokenId` will be minted for `to`.
1344      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1345      * - `from` cannot be the zero address.
1346      * - `to` cannot be the zero address.
1347      *
1348      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1349      */
1350     function _beforeTokenTransfer(
1351         address from,
1352         address to,
1353         uint256 tokenId
1354     ) internal virtual override {
1355         super._beforeTokenTransfer(from, to, tokenId);
1356 
1357         if (from == address(0)) {
1358             _addTokenToAllTokensEnumeration(tokenId);
1359         } else if (from != to) {
1360             _removeTokenFromOwnerEnumeration(from, tokenId);
1361         }
1362         if (to == address(0)) {
1363             _removeTokenFromAllTokensEnumeration(tokenId);
1364         } else if (to != from) {
1365             _addTokenToOwnerEnumeration(to, tokenId);
1366         }
1367     }
1368 
1369     /**
1370      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1371      * @param to address representing the new owner of the given token ID
1372      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1373      */
1374     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1375         uint256 length = ERC721.balanceOf(to);
1376         _ownedTokens[to][length] = tokenId;
1377         _ownedTokensIndex[tokenId] = length;
1378     }
1379 
1380     /**
1381      * @dev Private function to add a token to this extension's token tracking data structures.
1382      * @param tokenId uint256 ID of the token to be added to the tokens list
1383      */
1384     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1385         _allTokensIndex[tokenId] = _allTokens.length;
1386         _allTokens.push(tokenId);
1387     }
1388 
1389     /**
1390      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1391      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1392      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1393      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1394      * @param from address representing the previous owner of the given token ID
1395      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1396      */
1397     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1398         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1399         // then delete the last slot (swap and pop).
1400 
1401         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1402         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1403 
1404         // When the token to delete is the last token, the swap operation is unnecessary
1405         if (tokenIndex != lastTokenIndex) {
1406             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1407 
1408             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1409             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1410         }
1411 
1412         // This also deletes the contents at the last position of the array
1413         delete _ownedTokensIndex[tokenId];
1414         delete _ownedTokens[from][lastTokenIndex];
1415     }
1416 
1417     /**
1418      * @dev Private function to remove a token from this extension's token tracking data structures.
1419      * This has O(1) time complexity, but alters the order of the _allTokens array.
1420      * @param tokenId uint256 ID of the token to be removed from the tokens list
1421      */
1422     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1423         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1424         // then delete the last slot (swap and pop).
1425 
1426         uint256 lastTokenIndex = _allTokens.length - 1;
1427         uint256 tokenIndex = _allTokensIndex[tokenId];
1428 
1429         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1430         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1431         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1432         uint256 lastTokenId = _allTokens[lastTokenIndex];
1433 
1434         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1435         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1436 
1437         // This also deletes the contents at the last position of the array
1438         delete _allTokensIndex[tokenId];
1439         _allTokens.pop();
1440     }
1441 }
1442 
1443 /**
1444  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1445  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1446  *
1447  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1448  *
1449  * Does not support burning tokens to address(0).
1450  */
1451 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1452     using Address for address;
1453     using Strings for uint256;
1454 
1455     struct TokenOwnership {
1456         address addr;
1457         uint64 startTimestamp;
1458     }
1459 
1460     struct AddressData {
1461         uint128 balance;
1462         uint128 numberMinted;
1463     }
1464 
1465     uint256 private currentIndex = 0;
1466 
1467      uint256 internal immutable maxBatchSize;
1468 
1469     // Token name
1470     string private _name;
1471 
1472     // Token symbol
1473     string private _symbol;
1474 
1475     // Mapping from token ID to ownership details
1476     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1477     mapping(uint256 => TokenOwnership) private _ownerships;
1478 
1479     // Mapping owner address to address data
1480     mapping(address => AddressData) private _addressData;
1481 
1482     // Mapping from token ID to approved address
1483     mapping(uint256 => address) private _tokenApprovals;
1484 
1485     // Mapping from owner to operator approvals
1486     mapping(address => mapping(address => bool)) private _operatorApprovals;
1487 
1488     /**
1489      * @dev
1490      * `maxBatchSize` refers to how much a minter can mint at a time.
1491      */
1492     constructor(
1493         string memory name_,
1494         string memory symbol_,
1495         uint256 maxBatchSize_
1496     ) {
1497         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1498         _name = name_;
1499         _symbol = symbol_;
1500         maxBatchSize = maxBatchSize_;
1501     }
1502 
1503     /**
1504      * @dev See {IERC721Enumerable-totalSupply}.
1505      */
1506     function totalSupply() public view override returns (uint256) {
1507         return currentIndex;
1508     }
1509 
1510     /**
1511      * @dev See {IERC721Enumerable-tokenByIndex}.
1512      */
1513     function tokenByIndex(uint256 index) public view override returns (uint256) {
1514         require(index < totalSupply(), "ERC721A: global index out of bounds");
1515         return index;
1516     }
1517 
1518     /**
1519      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1520      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1521      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1522      */
1523     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1524         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1525         uint256 numMintedSoFar = totalSupply();
1526         uint256 tokenIdsIdx = 0;
1527         address currOwnershipAddr = address(0);
1528         for (uint256 i = 0; i < numMintedSoFar; i++) {
1529             TokenOwnership memory ownership = _ownerships[i];
1530             if (ownership.addr != address(0)) {
1531                 currOwnershipAddr = ownership.addr;
1532             }
1533             if (currOwnershipAddr == owner) {
1534                 if (tokenIdsIdx == index) {
1535                     return i;
1536                 }
1537                 tokenIdsIdx++;
1538             }
1539         }
1540         revert("ERC721A: unable to get token of owner by index");
1541     }
1542 
1543     /**
1544      * @dev See {IERC165-supportsInterface}.
1545      */
1546     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1547         return
1548             interfaceId == type(IERC721).interfaceId ||
1549             interfaceId == type(IERC721Metadata).interfaceId ||
1550             interfaceId == type(IERC721Enumerable).interfaceId ||
1551             super.supportsInterface(interfaceId);
1552     }
1553 
1554     /**
1555      * @dev See {IERC721-balanceOf}.
1556      */
1557     function balanceOf(address owner) public view override returns (uint256) {
1558         require(owner != address(0), "ERC721A: balance query for the zero address");
1559         return uint256(_addressData[owner].balance);
1560     }
1561 
1562     function _numberMinted(address owner) internal view returns (uint256) {
1563         require(owner != address(0), "ERC721A: number minted query for the zero address");
1564         return uint256(_addressData[owner].numberMinted);
1565     }
1566 
1567     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1568         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1569 
1570         uint256 lowestTokenToCheck;
1571         if (tokenId >= maxBatchSize) {
1572             lowestTokenToCheck = tokenId - maxBatchSize + 1;
1573         }
1574 
1575         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1576             TokenOwnership memory ownership = _ownerships[curr];
1577             if (ownership.addr != address(0)) {
1578                 return ownership;
1579             }
1580         }
1581 
1582         revert("ERC721A: unable to determine the owner of token");
1583     }
1584 
1585     /**
1586      * @dev See {IERC721-ownerOf}.
1587      */
1588     function ownerOf(uint256 tokenId) public view override returns (address) {
1589         return ownershipOf(tokenId).addr;
1590     }
1591 
1592     /**
1593      * @dev See {IERC721Metadata-name}.
1594      */
1595     function name() public view virtual override returns (string memory) {
1596         return _name;
1597     }
1598 
1599     /**
1600      * @dev See {IERC721Metadata-symbol}.
1601      */
1602     function symbol() public view virtual override returns (string memory) {
1603         return _symbol;
1604     }
1605 
1606     /**
1607      * @dev See {IERC721Metadata-tokenURI}.
1608      */
1609     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1610         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1611 
1612         string memory baseURI = _baseURI();
1613         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1614     }
1615 
1616     /**
1617      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1618      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1619      * by default, can be overriden in child contracts.
1620      */
1621     function _baseURI() internal view virtual returns (string memory) {
1622         return "";
1623     }
1624 
1625     /**
1626      * @dev See {IERC721-approve}.
1627      */
1628     function approve(address to, uint256 tokenId) public override {
1629         address owner = ERC721A.ownerOf(tokenId);
1630         require(to != owner, "ERC721A: approval to current owner");
1631 
1632         require(
1633             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1634             "ERC721A: approve caller is not owner nor approved for all"
1635         );
1636 
1637         _approve(to, tokenId, owner);
1638     }
1639 
1640     /**
1641      * @dev See {IERC721-getApproved}.
1642      */
1643     function getApproved(uint256 tokenId) public view override returns (address) {
1644         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1645 
1646         return _tokenApprovals[tokenId];
1647     }
1648 
1649     /**
1650      * @dev See {IERC721-setApprovalForAll}.
1651      */
1652     function setApprovalForAll(address operator, bool approved) public override {
1653         require(operator != _msgSender(), "ERC721A: approve to caller");
1654 
1655         _operatorApprovals[_msgSender()][operator] = approved;
1656         emit ApprovalForAll(_msgSender(), operator, approved);
1657     }
1658 
1659     /**
1660      * @dev See {IERC721-isApprovedForAll}.
1661      */
1662     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1663         return _operatorApprovals[owner][operator];
1664     }
1665 
1666     /**
1667      * @dev See {IERC721-transferFrom}.
1668      */
1669     function transferFrom(
1670         address from,
1671         address to,
1672         uint256 tokenId
1673     ) public override {
1674         _transfer(from, to, tokenId);
1675     }
1676 
1677     /**
1678      * @dev See {IERC721-safeTransferFrom}.
1679      */
1680     function safeTransferFrom(
1681         address from,
1682         address to,
1683         uint256 tokenId
1684     ) public override {
1685         safeTransferFrom(from, to, tokenId, "");
1686     }
1687 
1688     /**
1689      * @dev See {IERC721-safeTransferFrom}.
1690      */
1691     function safeTransferFrom(
1692         address from,
1693         address to,
1694         uint256 tokenId,
1695         bytes memory _data
1696     ) public override {
1697         _transfer(from, to, tokenId);
1698         require(
1699             _checkOnERC721Received(from, to, tokenId, _data),
1700             "ERC721A: transfer to non ERC721Receiver implementer"
1701         );
1702     }
1703 
1704     /**
1705      * @dev Returns whether `tokenId` exists.
1706      *
1707      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1708      *
1709      * Tokens start existing when they are minted (`_mint`),
1710      */
1711     function _exists(uint256 tokenId) internal view returns (bool) {
1712         return tokenId < currentIndex;
1713     }
1714 
1715     function _safeMint(address to, uint256 quantity) internal {
1716         _safeMint(to, quantity, "");
1717     }
1718 
1719     /**
1720      * @dev Mints `quantity` tokens and transfers them to `to`.
1721      *
1722      * Requirements:
1723      *
1724      * - `to` cannot be the zero address.
1725      * - `quantity` cannot be larger than the max batch size.
1726      *
1727      * Emits a {Transfer} event.
1728      */
1729     function _safeMint(
1730         address to,
1731         uint256 quantity,
1732         bytes memory _data
1733     ) internal {
1734         uint256 startTokenId = currentIndex;
1735         require(to != address(0), "ERC721A: mint to the zero address");
1736         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1737         require(!_exists(startTokenId), "ERC721A: token already minted");
1738         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1739 
1740         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1741 
1742         AddressData memory addressData = _addressData[to];
1743         _addressData[to] = AddressData(
1744             addressData.balance + uint128(quantity),
1745             addressData.numberMinted + uint128(quantity)
1746         );
1747         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1748 
1749         uint256 updatedIndex = startTokenId;
1750 
1751         for (uint256 i = 0; i < quantity; i++) {
1752             emit Transfer(address(0), to, updatedIndex);
1753             require(
1754                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1755                 "ERC721A: transfer to non ERC721Receiver implementer"
1756             );
1757             updatedIndex++;
1758         }
1759 
1760         currentIndex = updatedIndex;
1761         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1762     }
1763 
1764     /**
1765      * @dev Transfers `tokenId` from `from` to `to`.
1766      *
1767      * Requirements:
1768      *
1769      * - `to` cannot be the zero address.
1770      * - `tokenId` token must be owned by `from`.
1771      *
1772      * Emits a {Transfer} event.
1773      */
1774     function _transfer(
1775         address from,
1776         address to,
1777         uint256 tokenId
1778     ) private {
1779         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1780 
1781         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1782             getApproved(tokenId) == _msgSender() ||
1783             isApprovedForAll(prevOwnership.addr, _msgSender()));
1784 
1785         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1786 
1787         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1788         require(to != address(0), "ERC721A: transfer to the zero address");
1789 
1790         _beforeTokenTransfers(from, to, tokenId, 1);
1791 
1792         // Clear approvals from the previous owner
1793         _approve(address(0), tokenId, prevOwnership.addr);
1794 
1795         _addressData[from].balance -= 1;
1796         _addressData[to].balance += 1;
1797         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1798 
1799         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1800         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1801         uint256 nextTokenId = tokenId + 1;
1802         if (_ownerships[nextTokenId].addr == address(0)) {
1803             if (_exists(nextTokenId)) {
1804                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1805             }
1806         }
1807 
1808         emit Transfer(from, to, tokenId);
1809         _afterTokenTransfers(from, to, tokenId, 1);
1810     }
1811 
1812     /**
1813      * @dev Approve `to` to operate on `tokenId`
1814      *
1815      * Emits a {Approval} event.
1816      */
1817     function _approve(
1818         address to,
1819         uint256 tokenId,
1820         address owner
1821     ) private {
1822         _tokenApprovals[tokenId] = to;
1823         emit Approval(owner, to, tokenId);
1824     }
1825 
1826     uint256 public nextOwnerToExplicitlySet = 0;
1827 
1828     /**
1829      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1830      */
1831     function _setOwnersExplicit(uint256 quantity) internal {
1832         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1833         require(quantity > 0, "quantity must be nonzero");
1834         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1835         if (endIndex > currentIndex - 1) {
1836             endIndex = currentIndex - 1;
1837         }
1838         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1839         require(_exists(endIndex), "not enough minted yet for this cleanup");
1840         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1841             if (_ownerships[i].addr == address(0)) {
1842                 TokenOwnership memory ownership = ownershipOf(i);
1843                 _ownerships[i] = TokenOwnership(ownership.addr, ownership.startTimestamp);
1844             }
1845         }
1846         nextOwnerToExplicitlySet = endIndex + 1;
1847     }
1848 
1849     /**
1850      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1851      * The call is not executed if the target address is not a contract.
1852      *
1853      * @param from address representing the previous owner of the given token ID
1854      * @param to target address that will receive the tokens
1855      * @param tokenId uint256 ID of the token to be transferred
1856      * @param _data bytes optional data to send along with the call
1857      * @return bool whether the call correctly returned the expected magic value
1858      */
1859     function _checkOnERC721Received(
1860         address from,
1861         address to,
1862         uint256 tokenId,
1863         bytes memory _data
1864     ) private returns (bool) {
1865         if (to.isContract()) {
1866             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1867                 return retval == IERC721Receiver(to).onERC721Received.selector;
1868             } catch (bytes memory reason) {
1869                 if (reason.length == 0) {
1870                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1871                 } else {
1872                     assembly {
1873                         revert(add(32, reason), mload(reason))
1874                     }
1875                 }
1876             }
1877         } else {
1878             return true;
1879         }
1880     }
1881 
1882     /**
1883      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1884      *
1885      * startTokenId - the first token id to be transferred
1886      * quantity - the amount to be transferred
1887      *
1888      * Calling conditions:
1889      *
1890      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1891      * transferred to `to`.
1892      * - When `from` is zero, `tokenId` will be minted for `to`.
1893      */
1894     function _beforeTokenTransfers(
1895         address from,
1896         address to,
1897         uint256 startTokenId,
1898         uint256 quantity
1899     ) internal virtual {}
1900 
1901     /**
1902      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1903      * minting.
1904      *
1905      * startTokenId - the first token id to be transferred
1906      * quantity - the amount to be transferred
1907      *
1908      * Calling conditions:
1909      *
1910      * - when `from` and `to` are both non-zero.
1911      * - `from` and `to` are never both zero.
1912      */
1913     function _afterTokenTransfers(
1914         address from,
1915         address to,
1916         uint256 startTokenId,
1917         uint256 quantity
1918     ) internal virtual {}
1919 }
1920 
1921 pragma solidity ^0.8.0;
1922 
1923 contract NorthKoreanNFT is ERC721A, Ownable
1924 {
1925     using Strings for uint256;
1926     address public withdrawl_address = 0x6896504e8a6cD20f49D25Ff3C2C6f7352C42990a;
1927     string public baseURI;
1928     string public unrevealedURI;
1929     uint256 public tier1_limit;
1930     uint256 public tier1_price;
1931     uint256 public tier2_price;
1932     uint256 public maxSupply;
1933     uint256 public maxMintAmount = 2;
1934     uint256 public maxMintPerTransaction = 2;
1935     uint256 public ownerReserved;
1936    
1937     bool public saleOpen = true;
1938     bool public revealed = true;
1939     bool public whitelistOnly = false;
1940 
1941     bytes32 MerkleRoot;
1942 
1943     mapping(address => uint256) private mintCount;
1944 
1945     modifier mintIsLive() {
1946         require(saleOpen, "mint not live");
1947         _;
1948     }
1949 
1950     constructor() ERC721A("The North Korean NFT", "TNK", maxMintAmount) {
1951         maxSupply = 6666;
1952         ownerReserved = 666;
1953         tier1_limit = 2000;
1954         tier1_price = 0.25 ether;
1955         tier2_price;
1956     }
1957 
1958     function mintedByAddressCount(address _address) public view returns (uint256){
1959         return mintCount[_address];
1960     }
1961 
1962     function setWhitelistOnly(bool _whitelistStatus) external onlyOwner{
1963         whitelistOnly = _whitelistStatus;
1964     }
1965 
1966     function setTier1Limit(uint256 _tier1_limit) public onlyOwner {
1967         tier1_limit = _tier1_limit;
1968     }
1969 
1970     function setTier1Price(uint256 _tier1_price) public onlyOwner {
1971         tier1_price = _tier1_price;
1972     }
1973 
1974     function setTier2Price(uint256 _tier2_price) public onlyOwner {
1975         tier2_price = _tier2_price;
1976     }
1977 
1978     function getCost() public view returns(uint256){
1979          if(totalSupply() <= tier1_limit){
1980             return tier1_price;
1981         } else {
1982             return tier2_price;
1983         }
1984     }
1985 
1986     // Minting functions
1987     function mint(uint256 _mintAmount) external payable mintIsLive {
1988         require(whitelistOnly == false,"Whitelisted only allowed");
1989         address _to = msg.sender;
1990         uint256 minted = mintCount[_to];
1991         require(minted + _mintAmount <= maxMintAmount, "mint over max");
1992         require(_mintAmount <= maxMintPerTransaction, "amount must < max");
1993         require(totalSupply() + _mintAmount <= (maxSupply - ownerReserved), "mint over supply");
1994 
1995         uint256 price = getCost();
1996 
1997         require(msg.value >= price * _mintAmount, "insufficient funds");
1998 
1999         mintCount[_to] = minted + _mintAmount;
2000         _safeMint(msg.sender, _mintAmount);
2001     }
2002 
2003     // Minting functions
2004     function whitelistMint(uint256 _mintAmount, bytes32[] calldata _merkleProof) external payable mintIsLive {
2005         require(whitelistOnly == true,"Whitelisted only allowed");
2006 
2007         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2008         require(MerkleProof.verify(_merkleProof, MerkleRoot, leaf), "Incorrect proof");
2009 
2010         address _to = msg.sender;
2011         uint256 minted = mintCount[_to];
2012         require(minted + _mintAmount <= maxMintAmount, "mint over max");
2013         require(_mintAmount <= maxMintPerTransaction, "amount must < max");
2014         require(totalSupply() + _mintAmount <= (maxSupply - ownerReserved), "mint over supply");
2015 
2016         uint256 price = getCost();
2017 
2018         require(msg.value >= price * _mintAmount, "insufficient funds");
2019 
2020         mintCount[_to] = minted + _mintAmount;
2021         _safeMint(msg.sender, _mintAmount);
2022     }
2023     
2024     function setMerkleRoot(bytes32 _MerkleRoot) external onlyOwner {
2025         MerkleRoot = _MerkleRoot;
2026     }
2027 
2028     // Only Owner executable functions
2029     function claimReserved(address _to, uint256 _mintAmount) external onlyOwner {
2030         require((ownerReserved - _mintAmount) > 0, "over owner reserved supply");
2031         require(totalSupply() + _mintAmount <= maxSupply, "mint over supply");
2032         if (_mintAmount <= maxBatchSize) {
2033             _safeMint(_to, _mintAmount);
2034             return;
2035         }
2036         
2037         uint256 leftToMint = _mintAmount;
2038         while (leftToMint > 0) {
2039             if (leftToMint <= maxBatchSize) {
2040                 _safeMint(_to, leftToMint);
2041                 return;
2042             }
2043             _safeMint(_to, maxBatchSize);
2044             leftToMint = leftToMint - maxBatchSize;
2045             ownerReserved-- ;
2046         }
2047     }
2048 
2049     // Only Owner executable functions
2050     function airdropByAccount(address _to, uint256 _mintAmount) external onlyOwner {
2051         require(totalSupply() + _mintAmount <= maxSupply, "mint over supply");
2052         if (_mintAmount <= maxBatchSize) {
2053             _safeMint(_to, _mintAmount);
2054             return;
2055         }
2056         
2057         uint256 leftToMint = _mintAmount;
2058         while (leftToMint > 0) {
2059             if (leftToMint <= maxBatchSize) {
2060                 _safeMint(_to, leftToMint);
2061                 return;
2062             }
2063             _safeMint(_to, maxBatchSize);
2064             leftToMint = leftToMint - maxBatchSize;
2065         }
2066     }
2067 
2068     function airdropToBulkAccounts(address[] calldata _recipients) external onlyOwner {
2069         require(
2070             totalSupply() + _recipients.length <= (maxSupply - ownerReserved),
2071             "Airdrop minting will exceed maximum supply"
2072         );
2073         require(_recipients.length != 0, "Address not found for minting");
2074         for (uint256 i = 0; i < _recipients.length; i++) {
2075             require(_recipients[i] != address(0), "Minting to Null address");
2076              _safeMint(msg.sender, 1);
2077         }
2078     }
2079 
2080     function toggleMintLive() external onlyOwner {
2081         if (saleOpen) {
2082             saleOpen = false;
2083             return;
2084         }
2085         
2086         saleOpen = true;
2087     }
2088 
2089     function toggleReveal() external onlyOwner {
2090         if (revealed) {
2091             revealed = false;
2092             return;
2093         }
2094         revealed = true;
2095     }
2096 
2097     function setBaseURI(string memory _newURI) external onlyOwner {
2098         baseURI = _newURI;
2099     }
2100 
2101     function setUnrevealedURI(string memory _newUnrevealedURI) external onlyOwner {
2102         unrevealedURI = _newUnrevealedURI;
2103     }
2104 
2105     function withdraw() external onlyOwner {
2106         (bool success, ) = withdrawl_address.call{value: address(this).balance}("");
2107         require(success, "Transfer failed");
2108     }
2109 
2110     function setOwnersExplicit(uint256 quantity) external onlyOwner {
2111         _setOwnersExplicit(quantity);
2112     }
2113 
2114     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2115         require(_exists(_tokenId), "URI query for nonexistent token");
2116         if(revealed == false) {
2117             return unrevealedURI;
2118         }
2119         string memory baseTokenURI = _baseURI();
2120         string memory json = ".json";
2121         return bytes(baseTokenURI).length > 0
2122             ? string(abi.encodePacked(baseTokenURI, _tokenId.toString(), json))
2123             : '';
2124     }
2125 
2126     function _baseURI() internal view virtual override returns (string memory) {
2127         return baseURI;
2128     }
2129 
2130     fallback() external payable { }
2131 
2132     receive() external payable { }
2133 }