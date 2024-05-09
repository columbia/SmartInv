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
216 // File: @openzeppelin/contracts/utils/Address.sol
217 
218 
219 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
220 
221 pragma solidity ^0.8.1;
222 
223 /**
224  * @dev Collection of functions related to the address type
225  */
226 library Address {
227     /**
228      * @dev Returns true if `account` is a contract.
229      *
230      * [IMPORTANT]
231      * ====
232      * It is unsafe to assume that an address for which this function returns
233      * false is an externally-owned account (EOA) and not a contract.
234      *
235      * Among others, `isContract` will return false for the following
236      * types of addresses:
237      *
238      *  - an externally-owned account
239      *  - a contract in construction
240      *  - an address where a contract will be created
241      *  - an address where a contract lived, but was destroyed
242      * ====
243      *
244      * [IMPORTANT]
245      * ====
246      * You shouldn't rely on `isContract` to protect against flash loan attacks!
247      *
248      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
249      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
250      * constructor.
251      * ====
252      */
253     function isContract(address account) internal view returns (bool) {
254         // This method relies on extcodesize/address.code.length, which returns 0
255         // for contracts in construction, since the code is only stored at the end
256         // of the constructor execution.
257 
258         return account.code.length > 0;
259     }
260 
261     /**
262      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
263      * `recipient`, forwarding all available gas and reverting on errors.
264      *
265      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
266      * of certain opcodes, possibly making contracts go over the 2300 gas limit
267      * imposed by `transfer`, making them unable to receive funds via
268      * `transfer`. {sendValue} removes this limitation.
269      *
270      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
271      *
272      * IMPORTANT: because control is transferred to `recipient`, care must be
273      * taken to not create reentrancy vulnerabilities. Consider using
274      * {ReentrancyGuard} or the
275      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
276      */
277     function sendValue(address payable recipient, uint256 amount) internal {
278         require(address(this).balance >= amount, "Address: insufficient balance");
279 
280         (bool success, ) = recipient.call{value: amount}("");
281         require(success, "Address: unable to send value, recipient may have reverted");
282     }
283 
284     /**
285      * @dev Performs a Solidity function call using a low level `call`. A
286      * plain `call` is an unsafe replacement for a function call: use this
287      * function instead.
288      *
289      * If `target` reverts with a revert reason, it is bubbled up by this
290      * function (like regular Solidity function calls).
291      *
292      * Returns the raw returned data. To convert to the expected return value,
293      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
294      *
295      * Requirements:
296      *
297      * - `target` must be a contract.
298      * - calling `target` with `data` must not revert.
299      *
300      * _Available since v3.1._
301      */
302     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
303         return functionCall(target, data, "Address: low-level call failed");
304     }
305 
306     /**
307      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
308      * `errorMessage` as a fallback revert reason when `target` reverts.
309      *
310      * _Available since v3.1._
311      */
312     function functionCall(
313         address target,
314         bytes memory data,
315         string memory errorMessage
316     ) internal returns (bytes memory) {
317         return functionCallWithValue(target, data, 0, errorMessage);
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
322      * but also transferring `value` wei to `target`.
323      *
324      * Requirements:
325      *
326      * - the calling contract must have an ETH balance of at least `value`.
327      * - the called Solidity function must be `payable`.
328      *
329      * _Available since v3.1._
330      */
331     function functionCallWithValue(
332         address target,
333         bytes memory data,
334         uint256 value
335     ) internal returns (bytes memory) {
336         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
341      * with `errorMessage` as a fallback revert reason when `target` reverts.
342      *
343      * _Available since v3.1._
344      */
345     function functionCallWithValue(
346         address target,
347         bytes memory data,
348         uint256 value,
349         string memory errorMessage
350     ) internal returns (bytes memory) {
351         require(address(this).balance >= value, "Address: insufficient balance for call");
352         require(isContract(target), "Address: call to non-contract");
353 
354         (bool success, bytes memory returndata) = target.call{value: value}(data);
355         return verifyCallResult(success, returndata, errorMessage);
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
360      * but performing a static call.
361      *
362      * _Available since v3.3._
363      */
364     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
365         return functionStaticCall(target, data, "Address: low-level static call failed");
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
370      * but performing a static call.
371      *
372      * _Available since v3.3._
373      */
374     function functionStaticCall(
375         address target,
376         bytes memory data,
377         string memory errorMessage
378     ) internal view returns (bytes memory) {
379         require(isContract(target), "Address: static call to non-contract");
380 
381         (bool success, bytes memory returndata) = target.staticcall(data);
382         return verifyCallResult(success, returndata, errorMessage);
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
387      * but performing a delegate call.
388      *
389      * _Available since v3.4._
390      */
391     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
392         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
397      * but performing a delegate call.
398      *
399      * _Available since v3.4._
400      */
401     function functionDelegateCall(
402         address target,
403         bytes memory data,
404         string memory errorMessage
405     ) internal returns (bytes memory) {
406         require(isContract(target), "Address: delegate call to non-contract");
407 
408         (bool success, bytes memory returndata) = target.delegatecall(data);
409         return verifyCallResult(success, returndata, errorMessage);
410     }
411 
412     /**
413      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
414      * revert reason using the provided one.
415      *
416      * _Available since v4.3._
417      */
418     function verifyCallResult(
419         bool success,
420         bytes memory returndata,
421         string memory errorMessage
422     ) internal pure returns (bytes memory) {
423         if (success) {
424             return returndata;
425         } else {
426             // Look for revert reason and bubble it up if present
427             if (returndata.length > 0) {
428                 // The easiest way to bubble the revert reason is using memory via assembly
429                 /// @solidity memory-safe-assembly
430                 assembly {
431                     let returndata_size := mload(returndata)
432                     revert(add(32, returndata), returndata_size)
433                 }
434             } else {
435                 revert(errorMessage);
436             }
437         }
438     }
439 }
440 
441 // File: @openzeppelin/contracts/utils/Strings.sol
442 
443 
444 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
445 
446 pragma solidity ^0.8.0;
447 
448 /**
449  * @dev String operations.
450  */
451 library Strings {
452     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
453     uint8 private constant _ADDRESS_LENGTH = 20;
454 
455     /**
456      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
457      */
458     function toString(uint256 value) internal pure returns (string memory) {
459         // Inspired by OraclizeAPI's implementation - MIT licence
460         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
461 
462         if (value == 0) {
463             return "0";
464         }
465         uint256 temp = value;
466         uint256 digits;
467         while (temp != 0) {
468             digits++;
469             temp /= 10;
470         }
471         bytes memory buffer = new bytes(digits);
472         while (value != 0) {
473             digits -= 1;
474             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
475             value /= 10;
476         }
477         return string(buffer);
478     }
479 
480     /**
481      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
482      */
483     function toHexString(uint256 value) internal pure returns (string memory) {
484         if (value == 0) {
485             return "0x00";
486         }
487         uint256 temp = value;
488         uint256 length = 0;
489         while (temp != 0) {
490             length++;
491             temp >>= 8;
492         }
493         return toHexString(value, length);
494     }
495 
496     /**
497      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
498      */
499     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
500         bytes memory buffer = new bytes(2 * length + 2);
501         buffer[0] = "0";
502         buffer[1] = "x";
503         for (uint256 i = 2 * length + 1; i > 1; --i) {
504             buffer[i] = _HEX_SYMBOLS[value & 0xf];
505             value >>= 4;
506         }
507         require(value == 0, "Strings: hex length insufficient");
508         return string(buffer);
509     }
510 
511     /**
512      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
513      */
514     function toHexString(address addr) internal pure returns (string memory) {
515         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
516     }
517 }
518 
519 // File: erc721a/contracts/IERC721A.sol
520 
521 
522 // ERC721A Contracts v4.1.0
523 // Creator: Chiru Labs
524 
525 pragma solidity ^0.8.4;
526 
527 /**
528  * @dev Interface of an ERC721A compliant contract.
529  */
530 interface IERC721A {
531     /**
532      * The caller must own the token or be an approved operator.
533      */
534     error ApprovalCallerNotOwnerNorApproved();
535 
536     /**
537      * The token does not exist.
538      */
539     error ApprovalQueryForNonexistentToken();
540 
541     /**
542      * The caller cannot approve to their own address.
543      */
544     error ApproveToCaller();
545 
546     /**
547      * Cannot query the balance for the zero address.
548      */
549     error BalanceQueryForZeroAddress();
550 
551     /**
552      * Cannot mint to the zero address.
553      */
554     error MintToZeroAddress();
555 
556     /**
557      * The quantity of tokens minted must be more than zero.
558      */
559     error MintZeroQuantity();
560 
561     /**
562      * The token does not exist.
563      */
564     error OwnerQueryForNonexistentToken();
565 
566     /**
567      * The caller must own the token or be an approved operator.
568      */
569     error TransferCallerNotOwnerNorApproved();
570 
571     /**
572      * The token must be owned by `from`.
573      */
574     error TransferFromIncorrectOwner();
575 
576     /**
577      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
578      */
579     error TransferToNonERC721ReceiverImplementer();
580 
581     /**
582      * Cannot transfer to the zero address.
583      */
584     error TransferToZeroAddress();
585 
586     /**
587      * The token does not exist.
588      */
589     error URIQueryForNonexistentToken();
590 
591     /**
592      * The `quantity` minted with ERC2309 exceeds the safety limit.
593      */
594     error MintERC2309QuantityExceedsLimit();
595 
596     /**
597      * The `extraData` cannot be set on an unintialized ownership slot.
598      */
599     error OwnershipNotInitializedForExtraData();
600 
601     struct TokenOwnership {
602         // The address of the owner.
603         address addr;
604         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
605         uint64 startTimestamp;
606         // Whether the token has been burned.
607         bool burned;
608         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
609         uint24 extraData;
610     }
611 
612     /**
613      * @dev Returns the total amount of tokens stored by the contract.
614      *
615      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
616      */
617     function totalSupply() external view returns (uint256);
618 
619     // ==============================
620     //            IERC165
621     // ==============================
622 
623     /**
624      * @dev Returns true if this contract implements the interface defined by
625      * `interfaceId`. See the corresponding
626      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
627      * to learn more about how these ids are created.
628      *
629      * This function call must use less than 30 000 gas.
630      */
631     function supportsInterface(bytes4 interfaceId) external view returns (bool);
632 
633     // ==============================
634     //            IERC721
635     // ==============================
636 
637     /**
638      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
639      */
640     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
641 
642     /**
643      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
644      */
645     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
646 
647     /**
648      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
649      */
650     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
651 
652     /**
653      * @dev Returns the number of tokens in ``owner``'s account.
654      */
655     function balanceOf(address owner) external view returns (uint256 balance);
656 
657     /**
658      * @dev Returns the owner of the `tokenId` token.
659      *
660      * Requirements:
661      *
662      * - `tokenId` must exist.
663      */
664     function ownerOf(uint256 tokenId) external view returns (address owner);
665 
666     /**
667      * @dev Safely transfers `tokenId` token from `from` to `to`.
668      *
669      * Requirements:
670      *
671      * - `from` cannot be the zero address.
672      * - `to` cannot be the zero address.
673      * - `tokenId` token must exist and be owned by `from`.
674      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
675      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
676      *
677      * Emits a {Transfer} event.
678      */
679     function safeTransferFrom(
680         address from,
681         address to,
682         uint256 tokenId,
683         bytes calldata data
684     ) external;
685 
686     /**
687      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
688      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
689      *
690      * Requirements:
691      *
692      * - `from` cannot be the zero address.
693      * - `to` cannot be the zero address.
694      * - `tokenId` token must exist and be owned by `from`.
695      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
696      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
697      *
698      * Emits a {Transfer} event.
699      */
700     function safeTransferFrom(
701         address from,
702         address to,
703         uint256 tokenId
704     ) external;
705 
706     /**
707      * @dev Transfers `tokenId` token from `from` to `to`.
708      *
709      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
710      *
711      * Requirements:
712      *
713      * - `from` cannot be the zero address.
714      * - `to` cannot be the zero address.
715      * - `tokenId` token must be owned by `from`.
716      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
717      *
718      * Emits a {Transfer} event.
719      */
720     function transferFrom(
721         address from,
722         address to,
723         uint256 tokenId
724     ) external;
725 
726     /**
727      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
728      * The approval is cleared when the token is transferred.
729      *
730      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
731      *
732      * Requirements:
733      *
734      * - The caller must own the token or be an approved operator.
735      * - `tokenId` must exist.
736      *
737      * Emits an {Approval} event.
738      */
739     function approve(address to, uint256 tokenId) external;
740 
741     /**
742      * @dev Approve or remove `operator` as an operator for the caller.
743      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
744      *
745      * Requirements:
746      *
747      * - The `operator` cannot be the caller.
748      *
749      * Emits an {ApprovalForAll} event.
750      */
751     function setApprovalForAll(address operator, bool _approved) external;
752 
753     /**
754      * @dev Returns the account approved for `tokenId` token.
755      *
756      * Requirements:
757      *
758      * - `tokenId` must exist.
759      */
760     function getApproved(uint256 tokenId) external view returns (address operator);
761 
762     /**
763      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
764      *
765      * See {setApprovalForAll}
766      */
767     function isApprovedForAll(address owner, address operator) external view returns (bool);
768 
769     // ==============================
770     //        IERC721Metadata
771     // ==============================
772 
773     /**
774      * @dev Returns the token collection name.
775      */
776     function name() external view returns (string memory);
777 
778     /**
779      * @dev Returns the token collection symbol.
780      */
781     function symbol() external view returns (string memory);
782 
783     /**
784      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
785      */
786     function tokenURI(uint256 tokenId) external view returns (string memory);
787 
788     // ==============================
789     //            IERC2309
790     // ==============================
791 
792     /**
793      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
794      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
795      */
796     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
797 }
798 
799 // File: erc721a/contracts/ERC721A.sol
800 
801 
802 // ERC721A Contracts v4.1.0
803 // Creator: Chiru Labs
804 
805 pragma solidity ^0.8.4;
806 
807 
808 /**
809  * @dev ERC721 token receiver interface.
810  */
811 interface ERC721A__IERC721Receiver {
812     function onERC721Received(
813         address operator,
814         address from,
815         uint256 tokenId,
816         bytes calldata data
817     ) external returns (bytes4);
818 }
819 
820 /**
821  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
822  * including the Metadata extension. Built to optimize for lower gas during batch mints.
823  *
824  * Assumes serials are sequentially minted starting at `_startTokenId()`
825  * (defaults to 0, e.g. 0, 1, 2, 3..).
826  *
827  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
828  *
829  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
830  */
831 contract ERC721A is IERC721A {
832     // Mask of an entry in packed address data.
833     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
834 
835     // The bit position of `numberMinted` in packed address data.
836     uint256 private constant BITPOS_NUMBER_MINTED = 64;
837 
838     // The bit position of `numberBurned` in packed address data.
839     uint256 private constant BITPOS_NUMBER_BURNED = 128;
840 
841     // The bit position of `aux` in packed address data.
842     uint256 private constant BITPOS_AUX = 192;
843 
844     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
845     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
846 
847     // The bit position of `startTimestamp` in packed ownership.
848     uint256 private constant BITPOS_START_TIMESTAMP = 160;
849 
850     // The bit mask of the `burned` bit in packed ownership.
851     uint256 private constant BITMASK_BURNED = 1 << 224;
852 
853     // The bit position of the `nextInitialized` bit in packed ownership.
854     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
855 
856     // The bit mask of the `nextInitialized` bit in packed ownership.
857     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
858 
859     // The bit position of `extraData` in packed ownership.
860     uint256 private constant BITPOS_EXTRA_DATA = 232;
861 
862     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
863     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
864 
865     // The mask of the lower 160 bits for addresses.
866     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
867 
868     // The maximum `quantity` that can be minted with `_mintERC2309`.
869     // This limit is to prevent overflows on the address data entries.
870     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
871     // is required to cause an overflow, which is unrealistic.
872     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
873 
874     // The tokenId of the next token to be minted.
875     uint256 private _currentIndex;
876 
877     // The number of tokens burned.
878     uint256 private _burnCounter;
879 
880     // Token name
881     string private _name;
882 
883     // Token symbol
884     string private _symbol;
885 
886     // Mapping from token ID to ownership details
887     // An empty struct value does not necessarily mean the token is unowned.
888     // See `_packedOwnershipOf` implementation for details.
889     //
890     // Bits Layout:
891     // - [0..159]   `addr`
892     // - [160..223] `startTimestamp`
893     // - [224]      `burned`
894     // - [225]      `nextInitialized`
895     // - [232..255] `extraData`
896     mapping(uint256 => uint256) private _packedOwnerships;
897 
898     // Mapping owner address to address data.
899     //
900     // Bits Layout:
901     // - [0..63]    `balance`
902     // - [64..127]  `numberMinted`
903     // - [128..191] `numberBurned`
904     // - [192..255] `aux`
905     mapping(address => uint256) private _packedAddressData;
906 
907     // Mapping from token ID to approved address.
908     mapping(uint256 => address) private _tokenApprovals;
909 
910     // Mapping from owner to operator approvals
911     mapping(address => mapping(address => bool)) private _operatorApprovals;
912 
913     constructor(string memory name_, string memory symbol_) {
914         _name = name_;
915         _symbol = symbol_;
916         _currentIndex = _startTokenId();
917     }
918 
919     /**
920      * @dev Returns the starting token ID.
921      * To change the starting token ID, please override this function.
922      */
923     function _startTokenId() internal view virtual returns (uint256) {
924         return 0;
925     }
926 
927     /**
928      * @dev Returns the next token ID to be minted.
929      */
930     function _nextTokenId() internal view returns (uint256) {
931         return _currentIndex;
932     }
933 
934     /**
935      * @dev Returns the total number of tokens in existence.
936      * Burned tokens will reduce the count.
937      * To get the total number of tokens minted, please see `_totalMinted`.
938      */
939     function totalSupply() public view override returns (uint256) {
940         // Counter underflow is impossible as _burnCounter cannot be incremented
941         // more than `_currentIndex - _startTokenId()` times.
942         unchecked {
943             return _currentIndex - _burnCounter - _startTokenId();
944         }
945     }
946 
947     /**
948      * @dev Returns the total amount of tokens minted in the contract.
949      */
950     function _totalMinted() internal view returns (uint256) {
951         // Counter underflow is impossible as _currentIndex does not decrement,
952         // and it is initialized to `_startTokenId()`
953         unchecked {
954             return _currentIndex - _startTokenId();
955         }
956     }
957 
958     /**
959      * @dev Returns the total number of tokens burned.
960      */
961     function _totalBurned() internal view returns (uint256) {
962         return _burnCounter;
963     }
964 
965     /**
966      * @dev See {IERC165-supportsInterface}.
967      */
968     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
969         // The interface IDs are constants representing the first 4 bytes of the XOR of
970         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
971         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
972         return
973             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
974             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
975             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
976     }
977 
978     /**
979      * @dev See {IERC721-balanceOf}.
980      */
981     function balanceOf(address owner) public view override returns (uint256) {
982         if (owner == address(0)) revert BalanceQueryForZeroAddress();
983         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
984     }
985 
986     /**
987      * Returns the number of tokens minted by `owner`.
988      */
989     function _numberMinted(address owner) internal view returns (uint256) {
990         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
991     }
992 
993     /**
994      * Returns the number of tokens burned by or on behalf of `owner`.
995      */
996     function _numberBurned(address owner) internal view returns (uint256) {
997         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
998     }
999 
1000     /**
1001      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1002      */
1003     function _getAux(address owner) internal view returns (uint64) {
1004         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
1005     }
1006 
1007     /**
1008      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1009      * If there are multiple variables, please pack them into a uint64.
1010      */
1011     function _setAux(address owner, uint64 aux) internal {
1012         uint256 packed = _packedAddressData[owner];
1013         uint256 auxCasted;
1014         // Cast `aux` with assembly to avoid redundant masking.
1015         assembly {
1016             auxCasted := aux
1017         }
1018         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
1019         _packedAddressData[owner] = packed;
1020     }
1021 
1022     /**
1023      * Returns the packed ownership data of `tokenId`.
1024      */
1025     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1026         uint256 curr = tokenId;
1027 
1028         unchecked {
1029             if (_startTokenId() <= curr)
1030                 if (curr < _currentIndex) {
1031                     uint256 packed = _packedOwnerships[curr];
1032                     // If not burned.
1033                     if (packed & BITMASK_BURNED == 0) {
1034                         // Invariant:
1035                         // There will always be an ownership that has an address and is not burned
1036                         // before an ownership that does not have an address and is not burned.
1037                         // Hence, curr will not underflow.
1038                         //
1039                         // We can directly compare the packed value.
1040                         // If the address is zero, packed is zero.
1041                         while (packed == 0) {
1042                             packed = _packedOwnerships[--curr];
1043                         }
1044                         return packed;
1045                     }
1046                 }
1047         }
1048         revert OwnerQueryForNonexistentToken();
1049     }
1050 
1051     /**
1052      * Returns the unpacked `TokenOwnership` struct from `packed`.
1053      */
1054     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1055         ownership.addr = address(uint160(packed));
1056         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1057         ownership.burned = packed & BITMASK_BURNED != 0;
1058         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
1059     }
1060 
1061     /**
1062      * Returns the unpacked `TokenOwnership` struct at `index`.
1063      */
1064     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1065         return _unpackedOwnership(_packedOwnerships[index]);
1066     }
1067 
1068     /**
1069      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1070      */
1071     function _initializeOwnershipAt(uint256 index) internal {
1072         if (_packedOwnerships[index] == 0) {
1073             _packedOwnerships[index] = _packedOwnershipOf(index);
1074         }
1075     }
1076 
1077     /**
1078      * Gas spent here starts off proportional to the maximum mint batch size.
1079      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1080      */
1081     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1082         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1083     }
1084 
1085     /**
1086      * @dev Packs ownership data into a single uint256.
1087      */
1088     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1089         assembly {
1090             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1091             owner := and(owner, BITMASK_ADDRESS)
1092             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
1093             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
1094         }
1095     }
1096 
1097     /**
1098      * @dev See {IERC721-ownerOf}.
1099      */
1100     function ownerOf(uint256 tokenId) public view override returns (address) {
1101         return address(uint160(_packedOwnershipOf(tokenId)));
1102     }
1103 
1104     /**
1105      * @dev See {IERC721Metadata-name}.
1106      */
1107     function name() public view virtual override returns (string memory) {
1108         return _name;
1109     }
1110 
1111     /**
1112      * @dev See {IERC721Metadata-symbol}.
1113      */
1114     function symbol() public view virtual override returns (string memory) {
1115         return _symbol;
1116     }
1117 
1118     /**
1119      * @dev See {IERC721Metadata-tokenURI}.
1120      */
1121     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1122         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1123 
1124         string memory baseURI = _baseURI();
1125         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1126     }
1127 
1128     /**
1129      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1130      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1131      * by default, it can be overridden in child contracts.
1132      */
1133     function _baseURI() internal view virtual returns (string memory) {
1134         return '';
1135     }
1136 
1137     /**
1138      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1139      */
1140     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1141         // For branchless setting of the `nextInitialized` flag.
1142         assembly {
1143             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
1144             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1145         }
1146     }
1147 
1148     /**
1149      * @dev See {IERC721-approve}.
1150      */
1151     function approve(address to, uint256 tokenId) public override {
1152         address owner = ownerOf(tokenId);
1153 
1154         if (_msgSenderERC721A() != owner)
1155             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1156                 revert ApprovalCallerNotOwnerNorApproved();
1157             }
1158 
1159         _tokenApprovals[tokenId] = to;
1160         emit Approval(owner, to, tokenId);
1161     }
1162 
1163     /**
1164      * @dev See {IERC721-getApproved}.
1165      */
1166     function getApproved(uint256 tokenId) public view override returns (address) {
1167         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1168 
1169         return _tokenApprovals[tokenId];
1170     }
1171 
1172     /**
1173      * @dev See {IERC721-setApprovalForAll}.
1174      */
1175     function setApprovalForAll(address operator, bool approved) public virtual override {
1176         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1177 
1178         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1179         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1180     }
1181 
1182     /**
1183      * @dev See {IERC721-isApprovedForAll}.
1184      */
1185     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1186         return _operatorApprovals[owner][operator];
1187     }
1188 
1189     /**
1190      * @dev See {IERC721-safeTransferFrom}.
1191      */
1192     function safeTransferFrom(
1193         address from,
1194         address to,
1195         uint256 tokenId
1196     ) public virtual override {
1197         safeTransferFrom(from, to, tokenId, '');
1198     }
1199 
1200     /**
1201      * @dev See {IERC721-safeTransferFrom}.
1202      */
1203     function safeTransferFrom(
1204         address from,
1205         address to,
1206         uint256 tokenId,
1207         bytes memory _data
1208     ) public virtual override {
1209         transferFrom(from, to, tokenId);
1210         if (to.code.length != 0)
1211             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1212                 revert TransferToNonERC721ReceiverImplementer();
1213             }
1214     }
1215 
1216     /**
1217      * @dev Returns whether `tokenId` exists.
1218      *
1219      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1220      *
1221      * Tokens start existing when they are minted (`_mint`),
1222      */
1223     function _exists(uint256 tokenId) internal view returns (bool) {
1224         return
1225             _startTokenId() <= tokenId &&
1226             tokenId < _currentIndex && // If within bounds,
1227             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1228     }
1229 
1230     /**
1231      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1232      */
1233     function _safeMint(address to, uint256 quantity) internal {
1234         _safeMint(to, quantity, '');
1235     }
1236 
1237     /**
1238      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1239      *
1240      * Requirements:
1241      *
1242      * - If `to` refers to a smart contract, it must implement
1243      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1244      * - `quantity` must be greater than 0.
1245      *
1246      * See {_mint}.
1247      *
1248      * Emits a {Transfer} event for each mint.
1249      */
1250     function _safeMint(
1251         address to,
1252         uint256 quantity,
1253         bytes memory _data
1254     ) internal {
1255         _mint(to, quantity);
1256 
1257         unchecked {
1258             if (to.code.length != 0) {
1259                 uint256 end = _currentIndex;
1260                 uint256 index = end - quantity;
1261                 do {
1262                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1263                         revert TransferToNonERC721ReceiverImplementer();
1264                     }
1265                 } while (index < end);
1266                 // Reentrancy protection.
1267                 if (_currentIndex != end) revert();
1268             }
1269         }
1270     }
1271 
1272     /**
1273      * @dev Mints `quantity` tokens and transfers them to `to`.
1274      *
1275      * Requirements:
1276      *
1277      * - `to` cannot be the zero address.
1278      * - `quantity` must be greater than 0.
1279      *
1280      * Emits a {Transfer} event for each mint.
1281      */
1282     function _mint(address to, uint256 quantity) internal {
1283         uint256 startTokenId = _currentIndex;
1284         if (to == address(0)) revert MintToZeroAddress();
1285         if (quantity == 0) revert MintZeroQuantity();
1286 
1287         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1288 
1289         // Overflows are incredibly unrealistic.
1290         // `balance` and `numberMinted` have a maximum limit of 2**64.
1291         // `tokenId` has a maximum limit of 2**256.
1292         unchecked {
1293             // Updates:
1294             // - `balance += quantity`.
1295             // - `numberMinted += quantity`.
1296             //
1297             // We can directly add to the `balance` and `numberMinted`.
1298             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1299 
1300             // Updates:
1301             // - `address` to the owner.
1302             // - `startTimestamp` to the timestamp of minting.
1303             // - `burned` to `false`.
1304             // - `nextInitialized` to `quantity == 1`.
1305             _packedOwnerships[startTokenId] = _packOwnershipData(
1306                 to,
1307                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1308             );
1309 
1310             uint256 tokenId = startTokenId;
1311             uint256 end = startTokenId + quantity;
1312             do {
1313                 emit Transfer(address(0), to, tokenId++);
1314             } while (tokenId < end);
1315 
1316             _currentIndex = end;
1317         }
1318         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1319     }
1320 
1321     /**
1322      * @dev Mints `quantity` tokens and transfers them to `to`.
1323      *
1324      * This function is intended for efficient minting only during contract creation.
1325      *
1326      * It emits only one {ConsecutiveTransfer} as defined in
1327      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1328      * instead of a sequence of {Transfer} event(s).
1329      *
1330      * Calling this function outside of contract creation WILL make your contract
1331      * non-compliant with the ERC721 standard.
1332      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1333      * {ConsecutiveTransfer} event is only permissible during contract creation.
1334      *
1335      * Requirements:
1336      *
1337      * - `to` cannot be the zero address.
1338      * - `quantity` must be greater than 0.
1339      *
1340      * Emits a {ConsecutiveTransfer} event.
1341      */
1342     function _mintERC2309(address to, uint256 quantity) internal {
1343         uint256 startTokenId = _currentIndex;
1344         if (to == address(0)) revert MintToZeroAddress();
1345         if (quantity == 0) revert MintZeroQuantity();
1346         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1347 
1348         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1349 
1350         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1351         unchecked {
1352             // Updates:
1353             // - `balance += quantity`.
1354             // - `numberMinted += quantity`.
1355             //
1356             // We can directly add to the `balance` and `numberMinted`.
1357             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1358 
1359             // Updates:
1360             // - `address` to the owner.
1361             // - `startTimestamp` to the timestamp of minting.
1362             // - `burned` to `false`.
1363             // - `nextInitialized` to `quantity == 1`.
1364             _packedOwnerships[startTokenId] = _packOwnershipData(
1365                 to,
1366                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1367             );
1368 
1369             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1370 
1371             _currentIndex = startTokenId + quantity;
1372         }
1373         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1374     }
1375 
1376     /**
1377      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1378      */
1379     function _getApprovedAddress(uint256 tokenId)
1380         private
1381         view
1382         returns (uint256 approvedAddressSlot, address approvedAddress)
1383     {
1384         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1385         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1386         assembly {
1387             // Compute the slot.
1388             mstore(0x00, tokenId)
1389             mstore(0x20, tokenApprovalsPtr.slot)
1390             approvedAddressSlot := keccak256(0x00, 0x40)
1391             // Load the slot's value from storage.
1392             approvedAddress := sload(approvedAddressSlot)
1393         }
1394     }
1395 
1396     /**
1397      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1398      */
1399     function _isOwnerOrApproved(
1400         address approvedAddress,
1401         address from,
1402         address msgSender
1403     ) private pure returns (bool result) {
1404         assembly {
1405             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1406             from := and(from, BITMASK_ADDRESS)
1407             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1408             msgSender := and(msgSender, BITMASK_ADDRESS)
1409             // `msgSender == from || msgSender == approvedAddress`.
1410             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1411         }
1412     }
1413 
1414     /**
1415      * @dev Transfers `tokenId` from `from` to `to`.
1416      *
1417      * Requirements:
1418      *
1419      * - `to` cannot be the zero address.
1420      * - `tokenId` token must be owned by `from`.
1421      *
1422      * Emits a {Transfer} event.
1423      */
1424     function transferFrom(
1425         address from,
1426         address to,
1427         uint256 tokenId
1428     ) public virtual override {
1429         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1430 
1431         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1432 
1433         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1434 
1435         // The nested ifs save around 20+ gas over a compound boolean condition.
1436         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1437             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1438 
1439         if (to == address(0)) revert TransferToZeroAddress();
1440 
1441         _beforeTokenTransfers(from, to, tokenId, 1);
1442 
1443         // Clear approvals from the previous owner.
1444         assembly {
1445             if approvedAddress {
1446                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1447                 sstore(approvedAddressSlot, 0)
1448             }
1449         }
1450 
1451         // Underflow of the sender's balance is impossible because we check for
1452         // ownership above and the recipient's balance can't realistically overflow.
1453         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1454         unchecked {
1455             // We can directly increment and decrement the balances.
1456             --_packedAddressData[from]; // Updates: `balance -= 1`.
1457             ++_packedAddressData[to]; // Updates: `balance += 1`.
1458 
1459             // Updates:
1460             // - `address` to the next owner.
1461             // - `startTimestamp` to the timestamp of transfering.
1462             // - `burned` to `false`.
1463             // - `nextInitialized` to `true`.
1464             _packedOwnerships[tokenId] = _packOwnershipData(
1465                 to,
1466                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1467             );
1468 
1469             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1470             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1471                 uint256 nextTokenId = tokenId + 1;
1472                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1473                 if (_packedOwnerships[nextTokenId] == 0) {
1474                     // If the next slot is within bounds.
1475                     if (nextTokenId != _currentIndex) {
1476                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1477                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1478                     }
1479                 }
1480             }
1481         }
1482 
1483         emit Transfer(from, to, tokenId);
1484         _afterTokenTransfers(from, to, tokenId, 1);
1485     }
1486 
1487     /**
1488      * @dev Equivalent to `_burn(tokenId, false)`.
1489      */
1490     function _burn(uint256 tokenId) internal virtual {
1491         _burn(tokenId, false);
1492     }
1493 
1494     /**
1495      * @dev Destroys `tokenId`.
1496      * The approval is cleared when the token is burned.
1497      *
1498      * Requirements:
1499      *
1500      * - `tokenId` must exist.
1501      *
1502      * Emits a {Transfer} event.
1503      */
1504     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1505         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1506 
1507         address from = address(uint160(prevOwnershipPacked));
1508 
1509         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1510 
1511         if (approvalCheck) {
1512             // The nested ifs save around 20+ gas over a compound boolean condition.
1513             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1514                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1515         }
1516 
1517         _beforeTokenTransfers(from, address(0), tokenId, 1);
1518 
1519         // Clear approvals from the previous owner.
1520         assembly {
1521             if approvedAddress {
1522                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1523                 sstore(approvedAddressSlot, 0)
1524             }
1525         }
1526 
1527         // Underflow of the sender's balance is impossible because we check for
1528         // ownership above and the recipient's balance can't realistically overflow.
1529         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1530         unchecked {
1531             // Updates:
1532             // - `balance -= 1`.
1533             // - `numberBurned += 1`.
1534             //
1535             // We can directly decrement the balance, and increment the number burned.
1536             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1537             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1538 
1539             // Updates:
1540             // - `address` to the last owner.
1541             // - `startTimestamp` to the timestamp of burning.
1542             // - `burned` to `true`.
1543             // - `nextInitialized` to `true`.
1544             _packedOwnerships[tokenId] = _packOwnershipData(
1545                 from,
1546                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1547             );
1548 
1549             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1550             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1551                 uint256 nextTokenId = tokenId + 1;
1552                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1553                 if (_packedOwnerships[nextTokenId] == 0) {
1554                     // If the next slot is within bounds.
1555                     if (nextTokenId != _currentIndex) {
1556                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1557                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1558                     }
1559                 }
1560             }
1561         }
1562 
1563         emit Transfer(from, address(0), tokenId);
1564         _afterTokenTransfers(from, address(0), tokenId, 1);
1565 
1566         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1567         unchecked {
1568             _burnCounter++;
1569         }
1570     }
1571 
1572     /**
1573      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1574      *
1575      * @param from address representing the previous owner of the given token ID
1576      * @param to target address that will receive the tokens
1577      * @param tokenId uint256 ID of the token to be transferred
1578      * @param _data bytes optional data to send along with the call
1579      * @return bool whether the call correctly returned the expected magic value
1580      */
1581     function _checkContractOnERC721Received(
1582         address from,
1583         address to,
1584         uint256 tokenId,
1585         bytes memory _data
1586     ) private returns (bool) {
1587         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1588             bytes4 retval
1589         ) {
1590             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1591         } catch (bytes memory reason) {
1592             if (reason.length == 0) {
1593                 revert TransferToNonERC721ReceiverImplementer();
1594             } else {
1595                 assembly {
1596                     revert(add(32, reason), mload(reason))
1597                 }
1598             }
1599         }
1600     }
1601 
1602     /**
1603      * @dev Directly sets the extra data for the ownership data `index`.
1604      */
1605     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1606         uint256 packed = _packedOwnerships[index];
1607         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1608         uint256 extraDataCasted;
1609         // Cast `extraData` with assembly to avoid redundant masking.
1610         assembly {
1611             extraDataCasted := extraData
1612         }
1613         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1614         _packedOwnerships[index] = packed;
1615     }
1616 
1617     /**
1618      * @dev Returns the next extra data for the packed ownership data.
1619      * The returned result is shifted into position.
1620      */
1621     function _nextExtraData(
1622         address from,
1623         address to,
1624         uint256 prevOwnershipPacked
1625     ) private view returns (uint256) {
1626         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1627         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1628     }
1629 
1630     /**
1631      * @dev Called during each token transfer to set the 24bit `extraData` field.
1632      * Intended to be overridden by the cosumer contract.
1633      *
1634      * `previousExtraData` - the value of `extraData` before transfer.
1635      *
1636      * Calling conditions:
1637      *
1638      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1639      * transferred to `to`.
1640      * - When `from` is zero, `tokenId` will be minted for `to`.
1641      * - When `to` is zero, `tokenId` will be burned by `from`.
1642      * - `from` and `to` are never both zero.
1643      */
1644     function _extraData(
1645         address from,
1646         address to,
1647         uint24 previousExtraData
1648     ) internal view virtual returns (uint24) {}
1649 
1650     /**
1651      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1652      * This includes minting.
1653      * And also called before burning one token.
1654      *
1655      * startTokenId - the first token id to be transferred
1656      * quantity - the amount to be transferred
1657      *
1658      * Calling conditions:
1659      *
1660      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1661      * transferred to `to`.
1662      * - When `from` is zero, `tokenId` will be minted for `to`.
1663      * - When `to` is zero, `tokenId` will be burned by `from`.
1664      * - `from` and `to` are never both zero.
1665      */
1666     function _beforeTokenTransfers(
1667         address from,
1668         address to,
1669         uint256 startTokenId,
1670         uint256 quantity
1671     ) internal virtual {}
1672 
1673     /**
1674      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1675      * This includes minting.
1676      * And also called after one token has been burned.
1677      *
1678      * startTokenId - the first token id to be transferred
1679      * quantity - the amount to be transferred
1680      *
1681      * Calling conditions:
1682      *
1683      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1684      * transferred to `to`.
1685      * - When `from` is zero, `tokenId` has been minted for `to`.
1686      * - When `to` is zero, `tokenId` has been burned by `from`.
1687      * - `from` and `to` are never both zero.
1688      */
1689     function _afterTokenTransfers(
1690         address from,
1691         address to,
1692         uint256 startTokenId,
1693         uint256 quantity
1694     ) internal virtual {}
1695 
1696     /**
1697      * @dev Returns the message sender (defaults to `msg.sender`).
1698      *
1699      * If you are writing GSN compatible contracts, you need to override this function.
1700      */
1701     function _msgSenderERC721A() internal view virtual returns (address) {
1702         return msg.sender;
1703     }
1704 
1705     /**
1706      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1707      */
1708     function _toString(uint256 value) internal pure returns (string memory ptr) {
1709         assembly {
1710             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1711             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1712             // We will need 1 32-byte word to store the length,
1713             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1714             ptr := add(mload(0x40), 128)
1715             // Update the free memory pointer to allocate.
1716             mstore(0x40, ptr)
1717 
1718             // Cache the end of the memory to calculate the length later.
1719             let end := ptr
1720 
1721             // We write the string from the rightmost digit to the leftmost digit.
1722             // The following is essentially a do-while loop that also handles the zero case.
1723             // Costs a bit more than early returning for the zero case,
1724             // but cheaper in terms of deployment and overall runtime costs.
1725             for {
1726                 // Initialize and perform the first pass without check.
1727                 let temp := value
1728                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1729                 ptr := sub(ptr, 1)
1730                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1731                 mstore8(ptr, add(48, mod(temp, 10)))
1732                 temp := div(temp, 10)
1733             } temp {
1734                 // Keep dividing `temp` until zero.
1735                 temp := div(temp, 10)
1736             } {
1737                 // Body of the for loop.
1738                 ptr := sub(ptr, 1)
1739                 mstore8(ptr, add(48, mod(temp, 10)))
1740             }
1741 
1742             let length := sub(end, ptr)
1743             // Move the pointer 32 bytes leftwards to make room for the length.
1744             ptr := sub(ptr, 32)
1745             // Store the length.
1746             mstore(ptr, length)
1747         }
1748     }
1749 }
1750 
1751 // File: @openzeppelin/contracts/utils/Context.sol
1752 
1753 
1754 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1755 
1756 pragma solidity ^0.8.0;
1757 
1758 /**
1759  * @dev Provides information about the current execution context, including the
1760  * sender of the transaction and its data. While these are generally available
1761  * via msg.sender and msg.data, they should not be accessed in such a direct
1762  * manner, since when dealing with meta-transactions the account sending and
1763  * paying for execution may not be the actual sender (as far as an application
1764  * is concerned).
1765  *
1766  * This contract is only required for intermediate, library-like contracts.
1767  */
1768 abstract contract Context {
1769     function _msgSender() internal view virtual returns (address) {
1770         return msg.sender;
1771     }
1772 
1773     function _msgData() internal view virtual returns (bytes calldata) {
1774         return msg.data;
1775     }
1776 }
1777 
1778 // File: @openzeppelin/contracts/security/Pausable.sol
1779 
1780 
1781 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
1782 
1783 pragma solidity ^0.8.0;
1784 
1785 
1786 /**
1787  * @dev Contract module which allows children to implement an emergency stop
1788  * mechanism that can be triggered by an authorized account.
1789  *
1790  * This module is used through inheritance. It will make available the
1791  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1792  * the functions of your contract. Note that they will not be pausable by
1793  * simply including this module, only once the modifiers are put in place.
1794  */
1795 abstract contract Pausable is Context {
1796     /**
1797      * @dev Emitted when the pause is triggered by `account`.
1798      */
1799     event Paused(address account);
1800 
1801     /**
1802      * @dev Emitted when the pause is lifted by `account`.
1803      */
1804     event Unpaused(address account);
1805 
1806     bool private _paused;
1807 
1808     /**
1809      * @dev Initializes the contract in unpaused state.
1810      */
1811     constructor() {
1812         _paused = false;
1813     }
1814 
1815     /**
1816      * @dev Modifier to make a function callable only when the contract is not paused.
1817      *
1818      * Requirements:
1819      *
1820      * - The contract must not be paused.
1821      */
1822     modifier whenNotPaused() {
1823         _requireNotPaused();
1824         _;
1825     }
1826 
1827     /**
1828      * @dev Modifier to make a function callable only when the contract is paused.
1829      *
1830      * Requirements:
1831      *
1832      * - The contract must be paused.
1833      */
1834     modifier whenPaused() {
1835         _requirePaused();
1836         _;
1837     }
1838 
1839     /**
1840      * @dev Returns true if the contract is paused, and false otherwise.
1841      */
1842     function paused() public view virtual returns (bool) {
1843         return _paused;
1844     }
1845 
1846     /**
1847      * @dev Throws if the contract is paused.
1848      */
1849     function _requireNotPaused() internal view virtual {
1850         require(!paused(), "Pausable: paused");
1851     }
1852 
1853     /**
1854      * @dev Throws if the contract is not paused.
1855      */
1856     function _requirePaused() internal view virtual {
1857         require(paused(), "Pausable: not paused");
1858     }
1859 
1860     /**
1861      * @dev Triggers stopped state.
1862      *
1863      * Requirements:
1864      *
1865      * - The contract must not be paused.
1866      */
1867     function _pause() internal virtual whenNotPaused {
1868         _paused = true;
1869         emit Paused(_msgSender());
1870     }
1871 
1872     /**
1873      * @dev Returns to normal state.
1874      *
1875      * Requirements:
1876      *
1877      * - The contract must be paused.
1878      */
1879     function _unpause() internal virtual whenPaused {
1880         _paused = false;
1881         emit Unpaused(_msgSender());
1882     }
1883 }
1884 
1885 // File: @openzeppelin/contracts/access/Ownable.sol
1886 
1887 
1888 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1889 
1890 pragma solidity ^0.8.0;
1891 
1892 
1893 /**
1894  * @dev Contract module which provides a basic access control mechanism, where
1895  * there is an account (an owner) that can be granted exclusive access to
1896  * specific functions.
1897  *
1898  * By default, the owner account will be the one that deploys the contract. This
1899  * can later be changed with {transferOwnership}.
1900  *
1901  * This module is used through inheritance. It will make available the modifier
1902  * `onlyOwner`, which can be applied to your functions to restrict their use to
1903  * the owner.
1904  */
1905 abstract contract Ownable is Context {
1906     address private _owner;
1907 
1908     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1909 
1910     /**
1911      * @dev Initializes the contract setting the deployer as the initial owner.
1912      */
1913     constructor() {
1914         _transferOwnership(_msgSender());
1915     }
1916 
1917     /**
1918      * @dev Throws if called by any account other than the owner.
1919      */
1920     modifier onlyOwner() {
1921         _checkOwner();
1922         _;
1923     }
1924 
1925     /**
1926      * @dev Returns the address of the current owner.
1927      */
1928     function owner() public view virtual returns (address) {
1929         return _owner;
1930     }
1931 
1932     /**
1933      * @dev Throws if the sender is not the owner.
1934      */
1935     function _checkOwner() internal view virtual {
1936         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1937     }
1938 
1939     /**
1940      * @dev Leaves the contract without owner. It will not be possible to call
1941      * `onlyOwner` functions anymore. Can only be called by the current owner.
1942      *
1943      * NOTE: Renouncing ownership will leave the contract without an owner,
1944      * thereby removing any functionality that is only available to the owner.
1945      */
1946     function renounceOwnership() public virtual onlyOwner {
1947         _transferOwnership(address(0));
1948     }
1949 
1950     /**
1951      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1952      * Can only be called by the current owner.
1953      */
1954     function transferOwnership(address newOwner) public virtual onlyOwner {
1955         require(newOwner != address(0), "Ownable: new owner is the zero address");
1956         _transferOwnership(newOwner);
1957     }
1958 
1959     /**
1960      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1961      * Internal function without access restriction.
1962      */
1963     function _transferOwnership(address newOwner) internal virtual {
1964         address oldOwner = _owner;
1965         _owner = newOwner;
1966         emit OwnershipTransferred(oldOwner, newOwner);
1967     }
1968 }
1969 
1970 // File: contracts/barnabe.sol
1971 
1972 
1973 // @dev:Vadim Chilinciuc
1974 /*
1975 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1976 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1977 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1978 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1979 @@@@@@@@@@@@@@%%%%%%%%%%%%%%#((((((((((((((((@@@@@@@@@@@@@@@
1980 @@@@@@@@@@@@@@%%(###((%%%%%%%%%%%%%%%%%%%(((###@@@@@@@@@@@@@
1981 @@@@@@@@@@@@@@%%##((%%%%%%%%%#%%%%%%%%%%#%%((##@@@@@@@@@@@@@
1982 @@@@@@@@@@@@@@%%%#(% % %* % %% %%#%  %%    %((#@@@@@@@@@@@@@
1983 @@@@@@@@@@@@@@(%%(%% % %* / (% %%(    %  % %%((@@@@@@@@@@@@@
1984 @@@@@@@@@@@@@@(%%(%%%%%%%((((((((((((((%%%%%%%(@@@@@@@@@@@@@
1985 @@@@@@@@@@@@@@(%%(%%%%%%(((((((%%%#(((((%%%%%%(@@@@@@@@@@@@@
1986 @@@@@@@@@@@@@@(%%(%%%%%((((((%%%%%%%((((#%%%%%(@@@@@@@@@@@@@
1987 @@@@@@@@@@@@@@(%%(%%%%%(((((%%%%%%%%%(((%%%%%%(@@@@@@@@@@@@@
1988 @@@@@@@@@@@@@@(%%(%%%%#(((((%%%%%%%%((((%%%%%%(@@@@@@@@@@@@@
1989 @@@@@@@@@@@@@@%%%(%%%%#(((((/#%%%%#((((%%%%%%%(@@@@@@@@@@@@@
1990 @@@@@@@@@@@@@@%%%#%%%%%(((/(%%%%%%%%%%%%%%%%%((@@@@@@@@@@@@@
1991 @@@@@@@@@@@@@@%%(#%%%%%((((((%%%%%%%%%%%%%%%((#@@@@@@@@@@@@@
1992 @@@@@@@@@@@@@@%(((%%%%%%(((((((%%%%%%%%%%%(((##@@@@@@@@@@@@@
1993 @@@@@@@@@@@@@@((#(%%%%%%%(((((((((#%%%(((((##((@@@@@@@@@@@@@
1994 @@@@@@@@@@@@@@((((%%%%%%%%(((((((((((((((##((((@@@@@@@@@@@@@
1995 @@@@@@@@@@@@@@@@(#%%%%%%%%%%(((((((((((((((((%%@@@@@@@@@@@@@
1996 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1997 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1998 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1999 */
2000 pragma solidity >=0.7.0 <0.9.0;
2001 
2002 
2003 
2004 
2005 
2006 
2007 
2008 contract Break is ERC721A, Ownable, Pausable {
2009     using Address for address;
2010     using Strings for uint256;
2011     mapping(address => uint256) public totalWhitelistMint;
2012     mapping(address => uint256) public totalPublicMint;
2013 
2014 
2015     // Mint Configuration
2016     uint public constant MAX_SUPPLY = 1000;
2017     uint public constant MAX_MINT = 1;
2018 
2019     bool private isRevealed=false;
2020 
2021     // merkeroot for Whitelist Phase 1 & 2
2022     bytes32 public merkleRootWhiteListPhase1=0x7f52ab8fb23f6cb44a3ae0d7c6afcf47d4339a4baa2d238abb3e8bb29c9d0802;
2023     bytes32 public merkleRootWhiteListPhase2=0x7f52ab8fb23f6cb44a3ae0d7c6afcf47d4339a4baa2d238abb3e8bb29c9d0802;
2024 
2025     // Mint Dates  
2026     bool public publicSale;
2027     bool public whiteListPhase1;
2028     bool public whiteListPhase2;
2029 
2030     // Not Revealed & Base URI
2031     string private notRevealUrl="https://gateway.pinata.cloud/ipfs/QmfFAYG1zU9tRtSJYsNBgDJAQhB9Tui4cxp8vWGodmVHyF";
2032     string public _contractBaseURI="https://gateway.pinata.cloud/ipfs/Qma4KwNNqsSgcdYBQ73tqWfCp7pRo7cHXHHAeaZrHkjofR/";
2033 
2034     constructor() ERC721A("Break", "BRK") {
2035          publicSale=false;
2036          whiteListPhase1=false;
2037          whiteListPhase2=false;
2038          transferOwnership(0x0313BC404242886578D9BB5a29a8F1a075785818); 
2039          }
2040 
2041     // opensea recomandation
2042     function contractURI() public view returns (string memory) {
2043         return "https://gateway.pinata.cloud/ipfs/QmfFAYG1zU9tRtSJYsNBgDJAQhB9Tui4cxp8vWGodmVHyF";
2044     }
2045     
2046     function whitelistMint(bytes32[] memory _merkleProof, uint256 _quantity) external {
2047         require(_quantity > 0, "Quantity cannot be zero");
2048      if(whiteListPhase1 == true && whiteListPhase2 == false && publicSale ==false){
2049         require((totalSupply() + _quantity) <= MAX_SUPPLY, "Cannot mint beyond max supply");
2050         require((totalWhitelistMint[msg.sender] + _quantity)  <= MAX_MINT, " Cannot mint beyond whitelist max mint!");
2051         bytes32 sender = keccak256(abi.encodePacked(msg.sender));
2052         require(MerkleProof.verify(_merkleProof, merkleRootWhiteListPhase1, sender), " You are not whitelisted");
2053         totalWhitelistMint[msg.sender] += _quantity;
2054         _safeMint(msg.sender, _quantity);
2055 
2056      }else if (whiteListPhase1 == true && whiteListPhase2 == true && publicSale ==false){
2057         require((totalSupply() + _quantity) <= MAX_SUPPLY, " Cannot mint beyond max supply");
2058         require((totalWhitelistMint[msg.sender] + _quantity)  <= MAX_MINT, " Cannot mint beyond whitelist max mint!");
2059         bytes32 sender = keccak256(abi.encodePacked(msg.sender));
2060         require(MerkleProof.verify(_merkleProof, merkleRootWhiteListPhase2, sender), "You are not whitelisted");
2061         totalWhitelistMint[msg.sender] += _quantity;
2062         _safeMint(msg.sender, _quantity);
2063         
2064      }else if(publicSale == true){
2065         uint totalMinted = totalSupply();
2066         require((totalPublicMint[msg.sender] + _quantity)  <= MAX_MINT, " Cannot mint beyond whitelist max mint!");
2067         require(totalMinted+_quantity < MAX_SUPPLY, "Not enough NFTs left to mint");
2068         totalPublicMint[msg.sender] += _quantity;
2069         _safeMint(msg.sender, _quantity);
2070      }else{
2071         revert("We are not ready yet !");
2072         }
2073     }
2074 
2075   function mint(uint256 quantity) external whenNotPaused {
2076         require(publicSale == true, " We are not in public mint yet .");
2077         require(quantity > 0, "Quantity cannot be zero");
2078         uint totalMinted = totalSupply();
2079         require(totalMinted+quantity < MAX_SUPPLY, "Not enough NFTs left to mint");
2080         require((totalPublicMint[msg.sender] + quantity)  <= MAX_MINT, " Cannot mint beyond whitelist max mint!");
2081         totalPublicMint[msg.sender] += quantity;
2082         _safeMint(msg.sender, quantity);
2083     }
2084 
2085     function burn(uint256 _tokenId) external whenNotPaused {
2086         require(balanceOf(msg.sender)  >= 1,"You dont have NFTs");
2087         safeTransferFrom(msg.sender,0xb06bab4FB68420377B96AFb4EE3455AdC700F746,_tokenId);
2088         _safeMint(msg.sender, 1);
2089 
2090     }     
2091 
2092         // reserve MAX_RESERVE_SUPPLY for promotional purposes
2093     function reserveNFTs(address to, uint256 quantity) external onlyOwner  {
2094         require(quantity > 0, "Quantity cannot be zero");
2095         uint totalMinted = totalSupply();
2096         _safeMint(to, quantity);
2097     }
2098 
2099     function setPublicSale()public onlyOwner{
2100         publicSale=!publicSale;
2101     }
2102 
2103     function setWhitelistPhase1() public onlyOwner{
2104         whiteListPhase1=!whiteListPhase1;
2105     }
2106 
2107     function setWhitelistPhase2() public onlyOwner{
2108         whiteListPhase2=!whiteListPhase2;
2109     }
2110 
2111     function setTokenUri(string memory newBaseTokenURI) public  onlyOwner {
2112         _contractBaseURI=newBaseTokenURI;
2113     }
2114 
2115     function setNotRevealUri(string memory newNotRevealedURI)public onlyOwner {
2116         notRevealUrl=newNotRevealedURI;
2117     }
2118     
2119     function setMerkleRootPhase1(bytes32 _merkleRoot) external onlyOwner{
2120         require(publicSale == false,"Error !");
2121         merkleRootWhiteListPhase1 = _merkleRoot;
2122     }
2123 
2124     function setMerkleRootPhase2(bytes32 _merkleRoot) external onlyOwner{
2125         require(publicSale == false,"Error !");
2126         merkleRootWhiteListPhase2 = _merkleRoot;
2127     }
2128 
2129     function revealCollection() public  onlyOwner  {
2130         isRevealed=true;
2131     }
2132 
2133     function pause() public onlyOwner {
2134         _pause();
2135     }
2136 
2137     function unpause() public onlyOwner {
2138         _unpause();
2139     }
2140 
2141     function _baseURI() internal view override returns (string memory) {
2142         return _contractBaseURI;
2143     }
2144 
2145     //return uri for certain token
2146     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2147         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2148         if(!isRevealed){
2149             return notRevealUrl;
2150         }
2151         string memory baseURI = _baseURI();
2152         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
2153     }
2154     
2155     function withdraw() public onlyOwner  {
2156         uint balance = address(this).balance;
2157         payable(msg.sender).transfer(balance);
2158     }
2159 
2160 }