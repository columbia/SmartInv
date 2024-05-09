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
256 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
257 
258 
259 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
260 
261 pragma solidity ^0.8.0;
262 
263 /**
264  * @dev Interface of the ERC165 standard, as defined in the
265  * https://eips.ethereum.org/EIPS/eip-165[EIP].
266  *
267  * Implementers can declare support of contract interfaces, which can then be
268  * queried by others ({ERC165Checker}).
269  *
270  * For an implementation, see {ERC165}.
271  */
272 interface IERC165 {
273     /**
274      * @dev Returns true if this contract implements the interface defined by
275      * `interfaceId`. See the corresponding
276      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
277      * to learn more about how these ids are created.
278      *
279      * This function call must use less than 30 000 gas.
280      */
281     function supportsInterface(bytes4 interfaceId) external view returns (bool);
282 }
283 
284 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
285 
286 
287 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
288 
289 pragma solidity ^0.8.0;
290 
291 
292 /**
293  * @dev Implementation of the {IERC165} interface.
294  *
295  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
296  * for the additional interface id that will be supported. For example:
297  *
298  * ```solidity
299  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
300  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
301  * }
302  * ```
303  *
304  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
305  */
306 abstract contract ERC165 is IERC165 {
307     /**
308      * @dev See {IERC165-supportsInterface}.
309      */
310     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
311         return interfaceId == type(IERC165).interfaceId;
312     }
313 }
314 
315 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
316 
317 
318 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
319 
320 pragma solidity ^0.8.0;
321 
322 
323 /**
324  * @dev Required interface of an ERC721 compliant contract.
325  */
326 interface IERC721 is IERC165 {
327     /**
328      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
329      */
330     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
331 
332     /**
333      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
334      */
335     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
336 
337     /**
338      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
339      */
340     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
341 
342     /**
343      * @dev Returns the number of tokens in ``owner``'s account.
344      */
345     function balanceOf(address owner) external view returns (uint256 balance);
346 
347     /**
348      * @dev Returns the owner of the `tokenId` token.
349      *
350      * Requirements:
351      *
352      * - `tokenId` must exist.
353      */
354     function ownerOf(uint256 tokenId) external view returns (address owner);
355 
356     /**
357      * @dev Safely transfers `tokenId` token from `from` to `to`.
358      *
359      * Requirements:
360      *
361      * - `from` cannot be the zero address.
362      * - `to` cannot be the zero address.
363      * - `tokenId` token must exist and be owned by `from`.
364      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
365      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
366      *
367      * Emits a {Transfer} event.
368      */
369     function safeTransferFrom(
370         address from,
371         address to,
372         uint256 tokenId,
373         bytes calldata data
374     ) external;
375 
376     /**
377      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
378      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
379      *
380      * Requirements:
381      *
382      * - `from` cannot be the zero address.
383      * - `to` cannot be the zero address.
384      * - `tokenId` token must exist and be owned by `from`.
385      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
386      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
387      *
388      * Emits a {Transfer} event.
389      */
390     function safeTransferFrom(
391         address from,
392         address to,
393         uint256 tokenId
394     ) external;
395 
396     /**
397      * @dev Transfers `tokenId` token from `from` to `to`.
398      *
399      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
400      *
401      * Requirements:
402      *
403      * - `from` cannot be the zero address.
404      * - `to` cannot be the zero address.
405      * - `tokenId` token must be owned by `from`.
406      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
407      *
408      * Emits a {Transfer} event.
409      */
410     function transferFrom(
411         address from,
412         address to,
413         uint256 tokenId
414     ) external;
415 
416     /**
417      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
418      * The approval is cleared when the token is transferred.
419      *
420      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
421      *
422      * Requirements:
423      *
424      * - The caller must own the token or be an approved operator.
425      * - `tokenId` must exist.
426      *
427      * Emits an {Approval} event.
428      */
429     function approve(address to, uint256 tokenId) external;
430 
431     /**
432      * @dev Approve or remove `operator` as an operator for the caller.
433      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
434      *
435      * Requirements:
436      *
437      * - The `operator` cannot be the caller.
438      *
439      * Emits an {ApprovalForAll} event.
440      */
441     function setApprovalForAll(address operator, bool _approved) external;
442 
443     /**
444      * @dev Returns the account approved for `tokenId` token.
445      *
446      * Requirements:
447      *
448      * - `tokenId` must exist.
449      */
450     function getApproved(uint256 tokenId) external view returns (address operator);
451 
452     /**
453      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
454      *
455      * See {setApprovalForAll}
456      */
457     function isApprovedForAll(address owner, address operator) external view returns (bool);
458 }
459 
460 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
461 
462 
463 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
464 
465 pragma solidity ^0.8.0;
466 
467 
468 /**
469  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
470  * @dev See https://eips.ethereum.org/EIPS/eip-721
471  */
472 interface IERC721Enumerable is IERC721 {
473     /**
474      * @dev Returns the total amount of tokens stored by the contract.
475      */
476     function totalSupply() external view returns (uint256);
477 
478     /**
479      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
480      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
481      */
482     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
483 
484     /**
485      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
486      * Use along with {totalSupply} to enumerate all tokens.
487      */
488     function tokenByIndex(uint256 index) external view returns (uint256);
489 }
490 
491 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
492 
493 
494 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
495 
496 pragma solidity ^0.8.0;
497 
498 
499 /**
500  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
501  * @dev See https://eips.ethereum.org/EIPS/eip-721
502  */
503 interface IERC721Metadata is IERC721 {
504     /**
505      * @dev Returns the token collection name.
506      */
507     function name() external view returns (string memory);
508 
509     /**
510      * @dev Returns the token collection symbol.
511      */
512     function symbol() external view returns (string memory);
513 
514     /**
515      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
516      */
517     function tokenURI(uint256 tokenId) external view returns (string memory);
518 }
519 
520 // File: @openzeppelin/contracts/utils/Strings.sol
521 
522 
523 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
524 
525 pragma solidity ^0.8.0;
526 
527 /**
528  * @dev String operations.
529  */
530 library Strings {
531     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
532     uint8 private constant _ADDRESS_LENGTH = 20;
533 
534     /**
535      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
536      */
537     function toString(uint256 value) internal pure returns (string memory) {
538         // Inspired by OraclizeAPI's implementation - MIT licence
539         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
540 
541         if (value == 0) {
542             return "0";
543         }
544         uint256 temp = value;
545         uint256 digits;
546         while (temp != 0) {
547             digits++;
548             temp /= 10;
549         }
550         bytes memory buffer = new bytes(digits);
551         while (value != 0) {
552             digits -= 1;
553             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
554             value /= 10;
555         }
556         return string(buffer);
557     }
558 
559     /**
560      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
561      */
562     function toHexString(uint256 value) internal pure returns (string memory) {
563         if (value == 0) {
564             return "0x00";
565         }
566         uint256 temp = value;
567         uint256 length = 0;
568         while (temp != 0) {
569             length++;
570             temp >>= 8;
571         }
572         return toHexString(value, length);
573     }
574 
575     /**
576      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
577      */
578     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
579         bytes memory buffer = new bytes(2 * length + 2);
580         buffer[0] = "0";
581         buffer[1] = "x";
582         for (uint256 i = 2 * length + 1; i > 1; --i) {
583             buffer[i] = _HEX_SYMBOLS[value & 0xf];
584             value >>= 4;
585         }
586         require(value == 0, "Strings: hex length insufficient");
587         return string(buffer);
588     }
589 
590     /**
591      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
592      */
593     function toHexString(address addr) internal pure returns (string memory) {
594         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
595     }
596 }
597 
598 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
599 
600 
601 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
602 
603 pragma solidity ^0.8.0;
604 
605 /**
606  * @dev These functions deal with verification of Merkle Tree proofs.
607  *
608  * The proofs can be generated using the JavaScript library
609  * https://github.com/miguelmota/merkletreejs[merkletreejs].
610  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
611  *
612  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
613  *
614  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
615  * hashing, or use a hash function other than keccak256 for hashing leaves.
616  * This is because the concatenation of a sorted pair of internal nodes in
617  * the merkle tree could be reinterpreted as a leaf value.
618  */
619 library MerkleProof {
620     /**
621      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
622      * defined by `root`. For this, a `proof` must be provided, containing
623      * sibling hashes on the branch from the leaf to the root of the tree. Each
624      * pair of leaves and each pair of pre-images are assumed to be sorted.
625      */
626     function verify(
627         bytes32[] memory proof,
628         bytes32 root,
629         bytes32 leaf
630     ) internal pure returns (bool) {
631         return processProof(proof, leaf) == root;
632     }
633 
634     /**
635      * @dev Calldata version of {verify}
636      *
637      * _Available since v4.7._
638      */
639     function verifyCalldata(
640         bytes32[] calldata proof,
641         bytes32 root,
642         bytes32 leaf
643     ) internal pure returns (bool) {
644         return processProofCalldata(proof, leaf) == root;
645     }
646 
647     /**
648      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
649      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
650      * hash matches the root of the tree. When processing the proof, the pairs
651      * of leafs & pre-images are assumed to be sorted.
652      *
653      * _Available since v4.4._
654      */
655     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
656         bytes32 computedHash = leaf;
657         for (uint256 i = 0; i < proof.length; i++) {
658             computedHash = _hashPair(computedHash, proof[i]);
659         }
660         return computedHash;
661     }
662 
663     /**
664      * @dev Calldata version of {processProof}
665      *
666      * _Available since v4.7._
667      */
668     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
669         bytes32 computedHash = leaf;
670         for (uint256 i = 0; i < proof.length; i++) {
671             computedHash = _hashPair(computedHash, proof[i]);
672         }
673         return computedHash;
674     }
675 
676     /**
677      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
678      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
679      *
680      * _Available since v4.7._
681      */
682     function multiProofVerify(
683         bytes32[] memory proof,
684         bool[] memory proofFlags,
685         bytes32 root,
686         bytes32[] memory leaves
687     ) internal pure returns (bool) {
688         return processMultiProof(proof, proofFlags, leaves) == root;
689     }
690 
691     /**
692      * @dev Calldata version of {multiProofVerify}
693      *
694      * _Available since v4.7._
695      */
696     function multiProofVerifyCalldata(
697         bytes32[] calldata proof,
698         bool[] calldata proofFlags,
699         bytes32 root,
700         bytes32[] memory leaves
701     ) internal pure returns (bool) {
702         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
703     }
704 
705     /**
706      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
707      * consuming from one or the other at each step according to the instructions given by
708      * `proofFlags`.
709      *
710      * _Available since v4.7._
711      */
712     function processMultiProof(
713         bytes32[] memory proof,
714         bool[] memory proofFlags,
715         bytes32[] memory leaves
716     ) internal pure returns (bytes32 merkleRoot) {
717         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
718         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
719         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
720         // the merkle tree.
721         uint256 leavesLen = leaves.length;
722         uint256 totalHashes = proofFlags.length;
723 
724         // Check proof validity.
725         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
726 
727         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
728         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
729         bytes32[] memory hashes = new bytes32[](totalHashes);
730         uint256 leafPos = 0;
731         uint256 hashPos = 0;
732         uint256 proofPos = 0;
733         // At each step, we compute the next hash using two values:
734         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
735         //   get the next hash.
736         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
737         //   `proof` array.
738         for (uint256 i = 0; i < totalHashes; i++) {
739             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
740             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
741             hashes[i] = _hashPair(a, b);
742         }
743 
744         if (totalHashes > 0) {
745             return hashes[totalHashes - 1];
746         } else if (leavesLen > 0) {
747             return leaves[0];
748         } else {
749             return proof[0];
750         }
751     }
752 
753     /**
754      * @dev Calldata version of {processMultiProof}
755      *
756      * _Available since v4.7._
757      */
758     function processMultiProofCalldata(
759         bytes32[] calldata proof,
760         bool[] calldata proofFlags,
761         bytes32[] memory leaves
762     ) internal pure returns (bytes32 merkleRoot) {
763         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
764         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
765         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
766         // the merkle tree.
767         uint256 leavesLen = leaves.length;
768         uint256 totalHashes = proofFlags.length;
769 
770         // Check proof validity.
771         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
772 
773         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
774         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
775         bytes32[] memory hashes = new bytes32[](totalHashes);
776         uint256 leafPos = 0;
777         uint256 hashPos = 0;
778         uint256 proofPos = 0;
779         // At each step, we compute the next hash using two values:
780         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
781         //   get the next hash.
782         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
783         //   `proof` array.
784         for (uint256 i = 0; i < totalHashes; i++) {
785             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
786             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
787             hashes[i] = _hashPair(a, b);
788         }
789 
790         if (totalHashes > 0) {
791             return hashes[totalHashes - 1];
792         } else if (leavesLen > 0) {
793             return leaves[0];
794         } else {
795             return proof[0];
796         }
797     }
798 
799     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
800         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
801     }
802 
803     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
804         /// @solidity memory-safe-assembly
805         assembly {
806             mstore(0x00, a)
807             mstore(0x20, b)
808             value := keccak256(0x00, 0x40)
809         }
810     }
811 }
812 
813 // File: @openzeppelin/contracts/utils/Context.sol
814 
815 
816 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
817 
818 pragma solidity ^0.8.0;
819 
820 /**
821  * @dev Provides information about the current execution context, including the
822  * sender of the transaction and its data. While these are generally available
823  * via msg.sender and msg.data, they should not be accessed in such a direct
824  * manner, since when dealing with meta-transactions the account sending and
825  * paying for execution may not be the actual sender (as far as an application
826  * is concerned).
827  *
828  * This contract is only required for intermediate, library-like contracts.
829  */
830 abstract contract Context {
831     function _msgSender() internal view virtual returns (address) {
832         return msg.sender;
833     }
834 
835     function _msgData() internal view virtual returns (bytes calldata) {
836         return msg.data;
837     }
838 }
839 
840 // File: ERC721A.sol
841 
842 
843 
844 pragma solidity ^0.8.0;
845 
846 
847 
848 
849 
850 
851 
852 
853 
854 /**
855  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
856  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
857  *
858  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
859  *
860  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
861  *
862  * Does not support burning tokens to address(0).
863  */
864 contract ERC721A is
865   Context,
866   ERC165,
867   IERC721,
868   IERC721Metadata,
869   IERC721Enumerable
870 {
871   using Address for address;
872   using Strings for uint256;
873 
874   struct TokenOwnership {
875     address addr;
876     uint64 startTimestamp;
877   }
878 
879   struct AddressData {
880     uint128 balance;
881     uint128 numberMinted;
882   }
883 
884   uint256 private currentIndex = 0;
885 
886   uint256 internal immutable collectionSize;
887   uint256 internal immutable maxBatchSize;
888 
889   // Token name
890   string private _name;
891 
892   // Token symbol
893   string private _symbol;
894 
895   // Mapping from token ID to ownership details
896   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
897   mapping(uint256 => TokenOwnership) private _ownerships;
898 
899   // Mapping owner address to address data
900   mapping(address => AddressData) private _addressData;
901 
902   // Mapping from token ID to approved address
903   mapping(uint256 => address) private _tokenApprovals;
904 
905   // Mapping from owner to operator approvals
906   mapping(address => mapping(address => bool)) private _operatorApprovals;
907 
908   /**
909    * @dev
910    * `maxBatchSize` refers to how much a minter can mint at a time.
911    * `collectionSize_` refers to how many tokens are in the collection.
912    */
913   constructor(
914     string memory name_,
915     string memory symbol_,
916     uint256 maxBatchSize_,
917     uint256 collectionSize_
918   ) {
919     require(
920       collectionSize_ > 0,
921       "ERC721A: collection must have a nonzero supply"
922     );
923     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
924     _name = name_;
925     _symbol = symbol_;
926     maxBatchSize = maxBatchSize_;
927     collectionSize = collectionSize_;
928   }
929 
930   /**
931    * @dev See {IERC721Enumerable-totalSupply}.
932    */
933   function totalSupply() public view override returns (uint256) {
934     return currentIndex;
935   }
936 
937   /**
938    * @dev See {IERC721Enumerable-tokenByIndex}.
939    */
940   function tokenByIndex(uint256 index) public view override returns (uint256) {
941     require(index < totalSupply(), "ERC721A: global index out of bounds");
942     return index;
943   }
944 
945   /**
946    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
947    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
948    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
949    */
950   function tokenOfOwnerByIndex(address owner, uint256 index)
951     public
952     view
953     override
954     returns (uint256)
955   {
956     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
957     uint256 numMintedSoFar = totalSupply();
958     uint256 tokenIdsIdx = 0;
959     address currOwnershipAddr = address(0);
960     for (uint256 i = 0; i < numMintedSoFar; i++) {
961       TokenOwnership memory ownership = _ownerships[i];
962       if (ownership.addr != address(0)) {
963         currOwnershipAddr = ownership.addr;
964       }
965       if (currOwnershipAddr == owner) {
966         if (tokenIdsIdx == index) {
967           return i;
968         }
969         tokenIdsIdx++;
970       }
971     }
972     revert("ERC721A: unable to get token of owner by index");
973   }
974 
975   /**
976    * @dev See {IERC165-supportsInterface}.
977    */
978   function supportsInterface(bytes4 interfaceId)
979     public
980     view
981     virtual
982     override(ERC165, IERC165)
983     returns (bool)
984   {
985     return
986       interfaceId == type(IERC721).interfaceId ||
987       interfaceId == type(IERC721Metadata).interfaceId ||
988       interfaceId == type(IERC721Enumerable).interfaceId ||
989       super.supportsInterface(interfaceId);
990   }
991 
992   /**
993    * @dev See {IERC721-balanceOf}.
994    */
995   function balanceOf(address owner) public view override returns (uint256) {
996     require(owner != address(0), "ERC721A: balance query for the zero address");
997     return uint256(_addressData[owner].balance);
998   }
999 
1000   function _numberMinted(address owner) internal view returns (uint256) {
1001     require(
1002       owner != address(0),
1003       "ERC721A: number minted query for the zero address"
1004     );
1005     return uint256(_addressData[owner].numberMinted);
1006   }
1007 
1008   function ownershipOf(uint256 tokenId)
1009     internal
1010     view
1011     returns (TokenOwnership memory)
1012   {
1013     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1014 
1015     uint256 lowestTokenToCheck;
1016     if (tokenId >= maxBatchSize) {
1017       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1018     }
1019 
1020     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1021       TokenOwnership memory ownership = _ownerships[curr];
1022       if (ownership.addr != address(0)) {
1023         return ownership;
1024       }
1025     }
1026 
1027     revert("ERC721A: unable to determine the owner of token");
1028   }
1029 
1030   /**
1031    * @dev See {IERC721-ownerOf}.
1032    */
1033   function ownerOf(uint256 tokenId) public view override returns (address) {
1034     return ownershipOf(tokenId).addr;
1035   }
1036 
1037   /**
1038    * @dev See {IERC721Metadata-name}.
1039    */
1040   function name() public view virtual override returns (string memory) {
1041     return _name;
1042   }
1043 
1044   /**
1045    * @dev See {IERC721Metadata-symbol}.
1046    */
1047   function symbol() public view virtual override returns (string memory) {
1048     return _symbol;
1049   }
1050 
1051   /**
1052    * @dev See {IERC721Metadata-tokenURI}.
1053    */
1054   function tokenURI(uint256 tokenId)
1055     public
1056     view
1057     virtual
1058     override
1059     returns (string memory)
1060   {
1061     require(
1062       _exists(tokenId),
1063       "ERC721Metadata: URI query for nonexistent token"
1064     );
1065 
1066     string memory baseURI = _baseURI();
1067     return
1068       bytes(baseURI).length > 0
1069         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1070         : "";
1071   }
1072 
1073   /**
1074    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1075    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1076    * by default, can be overriden in child contracts.
1077    */
1078   function _baseURI() internal view virtual returns (string memory) {
1079     return "";
1080   }
1081 
1082   /**
1083    * @dev See {IERC721-approve}.
1084    */
1085   function approve(address to, uint256 tokenId) public override {
1086     address owner = ERC721A.ownerOf(tokenId);
1087     require(to != owner, "ERC721A: approval to current owner");
1088 
1089     require(
1090       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1091       "ERC721A: approve caller is not owner nor approved for all"
1092     );
1093 
1094     _approve(to, tokenId, owner);
1095   }
1096 
1097   /**
1098    * @dev See {IERC721-getApproved}.
1099    */
1100   function getApproved(uint256 tokenId) public view override returns (address) {
1101     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1102 
1103     return _tokenApprovals[tokenId];
1104   }
1105 
1106   /**
1107    * @dev See {IERC721-setApprovalForAll}.
1108    */
1109   function setApprovalForAll(address operator, bool approved) public override {
1110     require(operator != _msgSender(), "ERC721A: approve to caller");
1111 
1112     _operatorApprovals[_msgSender()][operator] = approved;
1113     emit ApprovalForAll(_msgSender(), operator, approved);
1114   }
1115 
1116   /**
1117    * @dev See {IERC721-isApprovedForAll}.
1118    */
1119   function isApprovedForAll(address owner, address operator)
1120     public
1121     view
1122     virtual
1123     override
1124     returns (bool)
1125   {
1126     return _operatorApprovals[owner][operator];
1127   }
1128 
1129   /**
1130    * @dev See {IERC721-transferFrom}.
1131    */
1132   function transferFrom(
1133     address from,
1134     address to,
1135     uint256 tokenId
1136   ) public override {
1137     _transfer(from, to, tokenId);
1138   }
1139 
1140   /**
1141    * @dev See {IERC721-safeTransferFrom}.
1142    */
1143   function safeTransferFrom(
1144     address from,
1145     address to,
1146     uint256 tokenId
1147   ) public override {
1148     safeTransferFrom(from, to, tokenId, "");
1149   }
1150 
1151   /**
1152    * @dev See {IERC721-safeTransferFrom}.
1153    */
1154   function safeTransferFrom(
1155     address from,
1156     address to,
1157     uint256 tokenId,
1158     bytes memory _data
1159   ) public override {
1160     _transfer(from, to, tokenId);
1161     require(
1162       _checkOnERC721Received(from, to, tokenId, _data),
1163       "ERC721A: transfer to non ERC721Receiver implementer"
1164     );
1165   }
1166 
1167   /**
1168    * @dev Returns whether `tokenId` exists.
1169    *
1170    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1171    *
1172    * Tokens start existing when they are minted (`_mint`),
1173    */
1174   function _exists(uint256 tokenId) internal view returns (bool) {
1175     return tokenId < currentIndex;
1176   }
1177 
1178   function _safeMint(address to, uint256 quantity) internal {
1179     _safeMint(to, quantity, "");
1180   }
1181 
1182   /**
1183    * @dev Mints `quantity` tokens and transfers them to `to`.
1184    *
1185    * Requirements:
1186    *
1187    * - there must be `quantity` tokens remaining unminted in the total collection.
1188    * - `to` cannot be the zero address.
1189    * - `quantity` cannot be larger than the max batch size.
1190    *
1191    * Emits a {Transfer} event.
1192    */
1193   function _safeMint(
1194     address to,
1195     uint256 quantity,
1196     bytes memory _data
1197   ) internal {
1198     uint256 startTokenId = currentIndex;
1199     require(to != address(0), "ERC721A: mint to the zero address");
1200     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1201     require(!_exists(startTokenId), "ERC721A: token already minted");
1202     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1203 
1204     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1205 
1206     AddressData memory addressData = _addressData[to];
1207     _addressData[to] = AddressData(
1208       addressData.balance + uint128(quantity),
1209       addressData.numberMinted + uint128(quantity)
1210     );
1211     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1212 
1213     uint256 updatedIndex = startTokenId;
1214 
1215     for (uint256 i = 0; i < quantity; i++) {
1216       emit Transfer(address(0), to, updatedIndex);
1217       require(
1218         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1219         "ERC721A: transfer to non ERC721Receiver implementer"
1220       );
1221       updatedIndex++;
1222     }
1223 
1224     currentIndex = updatedIndex;
1225     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1226   }
1227 
1228   /**
1229    * @dev Transfers `tokenId` from `from` to `to`.
1230    *
1231    * Requirements:
1232    *
1233    * - `to` cannot be the zero address.
1234    * - `tokenId` token must be owned by `from`.
1235    *
1236    * Emits a {Transfer} event.
1237    */
1238   function _transfer(
1239     address from,
1240     address to,
1241     uint256 tokenId
1242   ) private {
1243     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1244 
1245     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1246       getApproved(tokenId) == _msgSender() ||
1247       isApprovedForAll(prevOwnership.addr, _msgSender()));
1248 
1249     require(
1250       isApprovedOrOwner,
1251       "ERC721A: transfer caller is not owner nor approved"
1252     );
1253 
1254     require(
1255       prevOwnership.addr == from,
1256       "ERC721A: transfer from incorrect owner"
1257     );
1258     require(to != address(0), "ERC721A: transfer to the zero address");
1259 
1260     _beforeTokenTransfers(from, to, tokenId, 1);
1261 
1262     // Clear approvals from the previous owner
1263     _approve(address(0), tokenId, prevOwnership.addr);
1264 
1265     _addressData[from].balance -= 1;
1266     _addressData[to].balance += 1;
1267     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1268 
1269     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1270     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1271     uint256 nextTokenId = tokenId + 1;
1272     if (_ownerships[nextTokenId].addr == address(0)) {
1273       if (_exists(nextTokenId)) {
1274         _ownerships[nextTokenId] = TokenOwnership(
1275           prevOwnership.addr,
1276           prevOwnership.startTimestamp
1277         );
1278       }
1279     }
1280 
1281     emit Transfer(from, to, tokenId);
1282     _afterTokenTransfers(from, to, tokenId, 1);
1283   }
1284 
1285   /**
1286    * @dev Approve `to` to operate on `tokenId`
1287    *
1288    * Emits a {Approval} event.
1289    */
1290   function _approve(
1291     address to,
1292     uint256 tokenId,
1293     address owner
1294   ) private {
1295     _tokenApprovals[tokenId] = to;
1296     emit Approval(owner, to, tokenId);
1297   }
1298 
1299   uint256 public nextOwnerToExplicitlySet = 0;
1300 
1301   /**
1302    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1303    */
1304   function _setOwnersExplicit(uint256 quantity) internal {
1305     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1306     require(quantity > 0, "quantity must be nonzero");
1307     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1308     if (endIndex > collectionSize - 1) {
1309       endIndex = collectionSize - 1;
1310     }
1311     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1312     require(_exists(endIndex), "not enough minted yet for this cleanup");
1313     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1314       if (_ownerships[i].addr == address(0)) {
1315         TokenOwnership memory ownership = ownershipOf(i);
1316         _ownerships[i] = TokenOwnership(
1317           ownership.addr,
1318           ownership.startTimestamp
1319         );
1320       }
1321     }
1322     nextOwnerToExplicitlySet = endIndex + 1;
1323   }
1324 
1325   /**
1326    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1327    * The call is not executed if the target address is not a contract.
1328    *
1329    * @param from address representing the previous owner of the given token ID
1330    * @param to target address that will receive the tokens
1331    * @param tokenId uint256 ID of the token to be transferred
1332    * @param _data bytes optional data to send along with the call
1333    * @return bool whether the call correctly returned the expected magic value
1334    */
1335   function _checkOnERC721Received(
1336     address from,
1337     address to,
1338     uint256 tokenId,
1339     bytes memory _data
1340   ) private returns (bool) {
1341     if (to.isContract()) {
1342       try
1343         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1344       returns (bytes4 retval) {
1345         return retval == IERC721Receiver(to).onERC721Received.selector;
1346       } catch (bytes memory reason) {
1347         if (reason.length == 0) {
1348           revert("ERC721A: transfer to non ERC721Receiver implementer");
1349         } else {
1350           assembly {
1351             revert(add(32, reason), mload(reason))
1352           }
1353         }
1354       }
1355     } else {
1356       return true;
1357     }
1358   }
1359 
1360   /**
1361    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1362    *
1363    * startTokenId - the first token id to be transferred
1364    * quantity - the amount to be transferred
1365    *
1366    * Calling conditions:
1367    *
1368    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1369    * transferred to `to`.
1370    * - When `from` is zero, `tokenId` will be minted for `to`.
1371    */
1372   function _beforeTokenTransfers(
1373     address from,
1374     address to,
1375     uint256 startTokenId,
1376     uint256 quantity
1377   ) internal virtual {}
1378 
1379   /**
1380    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1381    * minting.
1382    *
1383    * startTokenId - the first token id to be transferred
1384    * quantity - the amount to be transferred
1385    *
1386    * Calling conditions:
1387    *
1388    * - when `from` and `to` are both non-zero.
1389    * - `from` and `to` are never both zero.
1390    */
1391   function _afterTokenTransfers(
1392     address from,
1393     address to,
1394     uint256 startTokenId,
1395     uint256 quantity
1396   ) internal virtual {}
1397 }
1398 
1399 // File: @openzeppelin/contracts/access/Ownable.sol
1400 
1401 
1402 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1403 
1404 pragma solidity ^0.8.0;
1405 
1406 
1407 /**
1408  * @dev Contract module which provides a basic access control mechanism, where
1409  * there is an account (an owner) that can be granted exclusive access to
1410  * specific functions.
1411  *
1412  * By default, the owner account will be the one that deploys the contract. This
1413  * can later be changed with {transferOwnership}.
1414  *
1415  * This module is used through inheritance. It will make available the modifier
1416  * `onlyOwner`, which can be applied to your functions to restrict their use to
1417  * the owner.
1418  */
1419 abstract contract Ownable is Context {
1420     address private _owner;
1421 
1422     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1423 
1424     /**
1425      * @dev Initializes the contract setting the deployer as the initial owner.
1426      */
1427     constructor() {
1428         _transferOwnership(_msgSender());
1429     }
1430 
1431     /**
1432      * @dev Throws if called by any account other than the owner.
1433      */
1434     modifier onlyOwner() {
1435         _checkOwner();
1436         _;
1437     }
1438 
1439     /**
1440      * @dev Returns the address of the current owner.
1441      */
1442     function owner() public view virtual returns (address) {
1443         return _owner;
1444     }
1445 
1446     /**
1447      * @dev Throws if the sender is not the owner.
1448      */
1449     function _checkOwner() internal view virtual {
1450         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1451     }
1452 
1453     /**
1454      * @dev Leaves the contract without owner. It will not be possible to call
1455      * `onlyOwner` functions anymore. Can only be called by the current owner.
1456      *
1457      * NOTE: Renouncing ownership will leave the contract without an owner,
1458      * thereby removing any functionality that is only available to the owner.
1459      */
1460     function renounceOwnership() public virtual onlyOwner {
1461         _transferOwnership(address(0));
1462     }
1463 
1464     /**
1465      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1466      * Can only be called by the current owner.
1467      */
1468     function transferOwnership(address newOwner) public virtual onlyOwner {
1469         require(newOwner != address(0), "Ownable: new owner is the zero address");
1470         _transferOwnership(newOwner);
1471     }
1472 
1473     /**
1474      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1475      * Internal function without access restriction.
1476      */
1477     function _transferOwnership(address newOwner) internal virtual {
1478         address oldOwner = _owner;
1479         _owner = newOwner;
1480         emit OwnershipTransferred(oldOwner, newOwner);
1481     }
1482 }
1483 
1484 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1485 
1486 
1487 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1488 
1489 pragma solidity ^0.8.0;
1490 
1491 /**
1492  * @dev Contract module that helps prevent reentrant calls to a function.
1493  *
1494  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1495  * available, which can be applied to functions to make sure there are no nested
1496  * (reentrant) calls to them.
1497  *
1498  * Note that because there is a single `nonReentrant` guard, functions marked as
1499  * `nonReentrant` may not call one another. This can be worked around by making
1500  * those functions `private`, and then adding `external` `nonReentrant` entry
1501  * points to them.
1502  *
1503  * TIP: If you would like to learn more about reentrancy and alternative ways
1504  * to protect against it, check out our blog post
1505  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1506  */
1507 abstract contract ReentrancyGuard {
1508     // Booleans are more expensive than uint256 or any type that takes up a full
1509     // word because each write operation emits an extra SLOAD to first read the
1510     // slot's contents, replace the bits taken up by the boolean, and then write
1511     // back. This is the compiler's defense against contract upgrades and
1512     // pointer aliasing, and it cannot be disabled.
1513 
1514     // The values being non-zero value makes deployment a bit more expensive,
1515     // but in exchange the refund on every call to nonReentrant will be lower in
1516     // amount. Since refunds are capped to a percentage of the total
1517     // transaction's gas, it is best to keep them low in cases like this one, to
1518     // increase the likelihood of the full refund coming into effect.
1519     uint256 private constant _NOT_ENTERED = 1;
1520     uint256 private constant _ENTERED = 2;
1521 
1522     uint256 private _status;
1523 
1524     constructor() {
1525         _status = _NOT_ENTERED;
1526     }
1527 
1528     /**
1529      * @dev Prevents a contract from calling itself, directly or indirectly.
1530      * Calling a `nonReentrant` function from another `nonReentrant`
1531      * function is not supported. It is possible to prevent this from happening
1532      * by making the `nonReentrant` function external, and making it call a
1533      * `private` function that does the actual work.
1534      */
1535     modifier nonReentrant() {
1536         // On the first call to nonReentrant, _notEntered will be true
1537         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1538 
1539         // Any calls to nonReentrant after this point will fail
1540         _status = _ENTERED;
1541 
1542         _;
1543 
1544         // By storing the original value once again, a refund is triggered (see
1545         // https://eips.ethereum.org/EIPS/eip-2200)
1546         _status = _NOT_ENTERED;
1547     }
1548 }
1549 
1550 // File: 2dnft.sol
1551 
1552 
1553 pragma solidity ^0.8.4;
1554 
1555 
1556 
1557 
1558 
1559 
1560 
1561 contract TLCGIF is ERC721A, ReentrancyGuard, Ownable {
1562 
1563     using Strings for uint256;
1564 
1565     struct whitelist_config {
1566         uint256 WHITELIST_START_TIME; 
1567         uint256 WHITELIST_END_TIME;  
1568         uint256 WHITELIST_CURVE_LENGTH;
1569         uint256 WHITELIST_TOTALSUPPLY;
1570         uint256 FREEMINT_END_TIME;
1571     }
1572 
1573     whitelist_config public whitelistConfig;
1574 
1575     mapping (address => uint256) public maxPerAddressDuringMint;
1576 
1577     bytes32 public root;
1578 
1579     uint256 public FreeAlreadyMint;
1580 
1581     uint256 public DevAlreadyMint;
1582 
1583     mapping (address => uint256) public AddressAlreadyMint;
1584 
1585     uint256 public constant _totalSupply = 10000;
1586 
1587     mapping (address => bool) public userFreeMint;
1588 
1589     string private UriPrefix = "https://bafybeia7axgj5v5lhlzp4owbld3bazueml6yhp5kktc62sqd5z4nnb6jpa.ipfs.nftstorage.link/character_";
1590 
1591     string private UriSuffix = ".json";
1592 
1593     uint256 public allowListSales;
1594 
1595     receive() external payable {}
1596 
1597   constructor( ) ERC721A("TwiLifeClub Image Collection Campaign", "TLC GIF", 200, 10000) {
1598 
1599        
1600   }
1601 
1602     function setTime(uint256 _whitelistStartTIme, uint256 _whitelistEndTIme, uint256 _freemintEndTime) external onlyOwner  {
1603         whitelistConfig.WHITELIST_START_TIME = _whitelistStartTIme;
1604         whitelistConfig.WHITELIST_END_TIME = _whitelistEndTIme;
1605         whitelistConfig.FREEMINT_END_TIME = _freemintEndTime;
1606     }
1607 
1608     function setRoot(bytes32 _root) external onlyOwner {
1609         root = _root;
1610     }
1611 
1612     function _baseURI(uint256 tokenId) internal view returns (string memory) {
1613 
1614         return getBaseUri(tokenId);
1615 
1616     }
1617 
1618     function setBaseURI(string memory _UriPrefix, string memory _UriSuffix) external onlyOwner {
1619         
1620         UriPrefix = _UriPrefix;
1621         UriSuffix = _UriSuffix;
1622 
1623     }
1624 
1625     function getBaseUri(uint256 tokenId) internal view returns(string memory) {
1626         
1627         string memory baseURI;
1628 
1629         
1630          baseURI = string(abi.encodePacked(UriPrefix, tokenId.toString(), UriSuffix));
1631      
1632         
1633         return baseURI;
1634 
1635     }
1636 
1637     function supportsInterface(bytes4 interfaceId)
1638         public
1639         view
1640         override(ERC721A)
1641         returns (bool)
1642     {
1643         return super.supportsInterface(interfaceId);
1644     }
1645 
1646     modifier callerIsUser() {
1647         require(tx.origin == msg.sender, "The caller is another contract");
1648         _;
1649     } 
1650 
1651     //freemint
1652     function freeMint() external nonReentrant callerIsUser{
1653 
1654         require(block.timestamp >= whitelistConfig.WHITELIST_END_TIME, "freemint has not started ye");
1655 
1656         require(block.timestamp < whitelistConfig.FREEMINT_END_TIME, "freemint expired");
1657 
1658         require(!userFreeMint[msg.sender], "This user has Mint");
1659 
1660         require(totalSupply() + 1 <= _totalSupply, "sold out");
1661 
1662         userFreeMint[msg.sender] = true;
1663 
1664         FreeAlreadyMint += 1;
1665 
1666         _safeMint(msg.sender,1);
1667 
1668     }
1669 
1670     function allowlistMint(bytes32[] calldata _proofs, uint256 proofQuantity,uint256 quantity) external nonReentrant callerIsUser{
1671 
1672         require(block.timestamp >= whitelistConfig.WHITELIST_START_TIME,"whitelist has not started ye");
1673 
1674         require(block.timestamp < whitelistConfig.WHITELIST_END_TIME, "whitelist expired");
1675    
1676         require(AddressAlreadyMint[msg.sender] + quantity  <= proofQuantity,"The quantity has exceeded the limit");
1677 
1678         require(quantity > 0, "Quantity must be greater than 0");
1679 
1680         require(totalSupply() + quantity <= _totalSupply, "sold out");
1681 
1682         bytes32 _leaf = keccak256(abi.encodePacked(msg.sender,uint256(proofQuantity)));
1683 
1684         (bool res) = MerkleProof.verify(_proofs, root, _leaf);
1685 
1686         require(res,"verify false");
1687 
1688         allowListSales += quantity;
1689 
1690         AddressAlreadyMint[msg.sender] += quantity;
1691 
1692         _safeMint(msg.sender,quantity);
1693     }
1694   
1695     function tokenURI(uint256 tokenId) public view override(ERC721A) returns(string memory){
1696 
1697         return _baseURI(tokenId);
1698  
1699     }
1700 
1701     function _afterTokenTransfers(
1702         address from,
1703         address to,
1704         uint256 startTokenId,
1705         uint256 quantity
1706     ) internal override {
1707 
1708          super._afterTokenTransfers(from,to,startTokenId,quantity);
1709     }
1710 
1711 }