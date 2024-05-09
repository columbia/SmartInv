1 // File: @openzeppelin/contracts/utils/Address.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
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
214 
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
318 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
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
385      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
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
460 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
461 
462 
463 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
464 
465 pragma solidity ^0.8.0;
466 
467 
468 /**
469  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
470  * @dev See https://eips.ethereum.org/EIPS/eip-721
471  */
472 interface IERC721Metadata is IERC721 {
473     /**
474      * @dev Returns the token collection name.
475      */
476     function name() external view returns (string memory);
477 
478     /**
479      * @dev Returns the token collection symbol.
480      */
481     function symbol() external view returns (string memory);
482 
483     /**
484      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
485      */
486     function tokenURI(uint256 tokenId) external view returns (string memory);
487 }
488 
489 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
490 
491 
492 // Creator: Chiru Labs
493 
494 pragma solidity ^0.8.4;
495 
496 
497 
498 /**
499  * @dev Interface of an ERC721A compliant contract.
500  */
501 interface IERC721A is IERC721, IERC721Metadata {
502     /**
503      * The caller must own the token or be an approved operator.
504      */
505     error ApprovalCallerNotOwnerNorApproved();
506 
507     /**
508      * The token does not exist.
509      */
510     error ApprovalQueryForNonexistentToken();
511 
512     /**
513      * The caller cannot approve to their own address.
514      */
515     error ApproveToCaller();
516 
517     /**
518      * The caller cannot approve to the current owner.
519      */
520     error ApprovalToCurrentOwner();
521 
522     /**
523      * Cannot query the balance for the zero address.
524      */
525     error BalanceQueryForZeroAddress();
526 
527     /**
528      * Cannot mint to the zero address.
529      */
530     error MintToZeroAddress();
531 
532     /**
533      * The quantity of tokens minted must be more than zero.
534      */
535     error MintZeroQuantity();
536 
537     /**
538      * The token does not exist.
539      */
540     error OwnerQueryForNonexistentToken();
541 
542     /**
543      * The caller must own the token or be an approved operator.
544      */
545     error TransferCallerNotOwnerNorApproved();
546 
547     /**
548      * The token must be owned by `from`.
549      */
550     error TransferFromIncorrectOwner();
551 
552     /**
553      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
554      */
555     error TransferToNonERC721ReceiverImplementer();
556 
557     /**
558      * Cannot transfer to the zero address.
559      */
560     error TransferToZeroAddress();
561 
562     /**
563      * The token does not exist.
564      */
565     error URIQueryForNonexistentToken();
566 
567     // Compiler will pack this into a single 256bit word.
568     struct TokenOwnership {
569         // The address of the owner.
570         address addr;
571         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
572         uint64 startTimestamp;
573         // Whether the token has been burned.
574         bool burned;
575     }
576 
577     // Compiler will pack this into a single 256bit word.
578     struct AddressData {
579         // Realistically, 2**64-1 is more than enough.
580         uint64 balance;
581         // Keeps track of mint count with minimal overhead for tokenomics.
582         uint64 numberMinted;
583         // Keeps track of burn count with minimal overhead for tokenomics.
584         uint64 numberBurned;
585         // For miscellaneous variable(s) pertaining to the address
586         // (e.g. number of whitelist mint slots used).
587         // If there are multiple variables, please pack them into a uint64.
588         uint64 aux;
589     }
590 
591     /**
592      * @dev Returns the total amount of tokens stored by the contract.
593      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
594      */
595     function totalSupply() external view returns (uint256);
596 }
597 
598 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/extensions/IERC721AQueryable.sol
599 
600 
601 // Creator: Chiru Labs
602 
603 pragma solidity ^0.8.4;
604 
605 
606 /**
607  * @dev Interface of an ERC721AQueryable compliant contract.
608  */
609 interface IERC721AQueryable is IERC721A {
610     /**
611      * Invalid query range (`start` >= `stop`).
612      */
613     error InvalidQueryRange();
614 
615     /**
616      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
617      *
618      * If the `tokenId` is out of bounds:
619      *   - `addr` = `address(0)`
620      *   - `startTimestamp` = `0`
621      *   - `burned` = `false`
622      *
623      * If the `tokenId` is burned:
624      *   - `addr` = `<Address of owner before token was burned>`
625      *   - `startTimestamp` = `<Timestamp when token was burned>`
626      *   - `burned = `true`
627      *
628      * Otherwise:
629      *   - `addr` = `<Address of owner>`
630      *   - `startTimestamp` = `<Timestamp of start of ownership>`
631      *   - `burned = `false`
632      */
633     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
634 
635     /**
636      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
637      * See {ERC721AQueryable-explicitOwnershipOf}
638      */
639     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
640 
641     /**
642      * @dev Returns an array of token IDs owned by `owner`,
643      * in the range [`start`, `stop`)
644      * (i.e. `start <= tokenId < stop`).
645      *
646      * This function allows for tokens to be queried if the collection
647      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
648      *
649      * Requirements:
650      *
651      * - `start` < `stop`
652      */
653     function tokensOfOwnerIn(
654         address owner,
655         uint256 start,
656         uint256 stop
657     ) external view returns (uint256[] memory);
658 
659     /**
660      * @dev Returns an array of token IDs owned by `owner`.
661      *
662      * This function scans the ownership mapping and is O(totalSupply) in complexity.
663      * It is meant to be called off-chain.
664      *
665      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
666      * multiple smaller scans if the collection is large enough to cause
667      * an out-of-gas error (10K pfp collections should be fine).
668      */
669     function tokensOfOwner(address owner) external view returns (uint256[] memory);
670 }
671 
672 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
673 
674 
675 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
676 
677 pragma solidity ^0.8.0;
678 
679 /**
680  * @dev These functions deal with verification of Merkle Trees proofs.
681  *
682  * The proofs can be generated using the JavaScript library
683  * https://github.com/miguelmota/merkletreejs[merkletreejs].
684  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
685  *
686  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
687  *
688  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
689  * hashing, or use a hash function other than keccak256 for hashing leaves.
690  * This is because the concatenation of a sorted pair of internal nodes in
691  * the merkle tree could be reinterpreted as a leaf value.
692  */
693 library MerkleProof {
694     /**
695      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
696      * defined by `root`. For this, a `proof` must be provided, containing
697      * sibling hashes on the branch from the leaf to the root of the tree. Each
698      * pair of leaves and each pair of pre-images are assumed to be sorted.
699      */
700     function verify(
701         bytes32[] memory proof,
702         bytes32 root,
703         bytes32 leaf
704     ) internal pure returns (bool) {
705         return processProof(proof, leaf) == root;
706     }
707 
708     /**
709      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
710      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
711      * hash matches the root of the tree. When processing the proof, the pairs
712      * of leafs & pre-images are assumed to be sorted.
713      *
714      * _Available since v4.4._
715      */
716     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
717         bytes32 computedHash = leaf;
718         for (uint256 i = 0; i < proof.length; i++) {
719             bytes32 proofElement = proof[i];
720             if (computedHash <= proofElement) {
721                 // Hash(current computed hash + current element of the proof)
722                 computedHash = _efficientHash(computedHash, proofElement);
723             } else {
724                 // Hash(current element of the proof + current computed hash)
725                 computedHash = _efficientHash(proofElement, computedHash);
726             }
727         }
728         return computedHash;
729     }
730 
731     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
732         assembly {
733             mstore(0x00, a)
734             mstore(0x20, b)
735             value := keccak256(0x00, 0x40)
736         }
737     }
738 }
739 
740 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
741 
742 
743 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
744 
745 pragma solidity ^0.8.0;
746 
747 /**
748  * @dev Contract module that helps prevent reentrant calls to a function.
749  *
750  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
751  * available, which can be applied to functions to make sure there are no nested
752  * (reentrant) calls to them.
753  *
754  * Note that because there is a single `nonReentrant` guard, functions marked as
755  * `nonReentrant` may not call one another. This can be worked around by making
756  * those functions `private`, and then adding `external` `nonReentrant` entry
757  * points to them.
758  *
759  * TIP: If you would like to learn more about reentrancy and alternative ways
760  * to protect against it, check out our blog post
761  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
762  */
763 abstract contract ReentrancyGuard {
764     // Booleans are more expensive than uint256 or any type that takes up a full
765     // word because each write operation emits an extra SLOAD to first read the
766     // slot's contents, replace the bits taken up by the boolean, and then write
767     // back. This is the compiler's defense against contract upgrades and
768     // pointer aliasing, and it cannot be disabled.
769 
770     // The values being non-zero value makes deployment a bit more expensive,
771     // but in exchange the refund on every call to nonReentrant will be lower in
772     // amount. Since refunds are capped to a percentage of the total
773     // transaction's gas, it is best to keep them low in cases like this one, to
774     // increase the likelihood of the full refund coming into effect.
775     uint256 private constant _NOT_ENTERED = 1;
776     uint256 private constant _ENTERED = 2;
777 
778     uint256 private _status;
779 
780     constructor() {
781         _status = _NOT_ENTERED;
782     }
783 
784     /**
785      * @dev Prevents a contract from calling itself, directly or indirectly.
786      * Calling a `nonReentrant` function from another `nonReentrant`
787      * function is not supported. It is possible to prevent this from happening
788      * by making the `nonReentrant` function external, and making it call a
789      * `private` function that does the actual work.
790      */
791     modifier nonReentrant() {
792         // On the first call to nonReentrant, _notEntered will be true
793         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
794 
795         // Any calls to nonReentrant after this point will fail
796         _status = _ENTERED;
797 
798         _;
799 
800         // By storing the original value once again, a refund is triggered (see
801         // https://eips.ethereum.org/EIPS/eip-2200)
802         _status = _NOT_ENTERED;
803     }
804 }
805 
806 // File: @openzeppelin/contracts/utils/Strings.sol
807 
808 
809 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
810 
811 pragma solidity ^0.8.0;
812 
813 /**
814  * @dev String operations.
815  */
816 library Strings {
817     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
818 
819     /**
820      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
821      */
822     function toString(uint256 value) internal pure returns (string memory) {
823         // Inspired by OraclizeAPI's implementation - MIT licence
824         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
825 
826         if (value == 0) {
827             return "0";
828         }
829         uint256 temp = value;
830         uint256 digits;
831         while (temp != 0) {
832             digits++;
833             temp /= 10;
834         }
835         bytes memory buffer = new bytes(digits);
836         while (value != 0) {
837             digits -= 1;
838             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
839             value /= 10;
840         }
841         return string(buffer);
842     }
843 
844     /**
845      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
846      */
847     function toHexString(uint256 value) internal pure returns (string memory) {
848         if (value == 0) {
849             return "0x00";
850         }
851         uint256 temp = value;
852         uint256 length = 0;
853         while (temp != 0) {
854             length++;
855             temp >>= 8;
856         }
857         return toHexString(value, length);
858     }
859 
860     /**
861      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
862      */
863     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
864         bytes memory buffer = new bytes(2 * length + 2);
865         buffer[0] = "0";
866         buffer[1] = "x";
867         for (uint256 i = 2 * length + 1; i > 1; --i) {
868             buffer[i] = _HEX_SYMBOLS[value & 0xf];
869             value >>= 4;
870         }
871         require(value == 0, "Strings: hex length insufficient");
872         return string(buffer);
873     }
874 }
875 
876 // File: @openzeppelin/contracts/utils/Context.sol
877 
878 
879 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
880 
881 pragma solidity ^0.8.0;
882 
883 /**
884  * @dev Provides information about the current execution context, including the
885  * sender of the transaction and its data. While these are generally available
886  * via msg.sender and msg.data, they should not be accessed in such a direct
887  * manner, since when dealing with meta-transactions the account sending and
888  * paying for execution may not be the actual sender (as far as an application
889  * is concerned).
890  *
891  * This contract is only required for intermediate, library-like contracts.
892  */
893 abstract contract Context {
894     function _msgSender() internal view virtual returns (address) {
895         return msg.sender;
896     }
897 
898     function _msgData() internal view virtual returns (bytes calldata) {
899         return msg.data;
900     }
901 }
902 
903 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
904 
905 
906 // Creator: Chiru Labs
907 
908 pragma solidity ^0.8.4;
909 
910 
911 
912 
913 
914 
915 
916 /**
917  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
918  * the Metadata extension. Built to optimize for lower gas during batch mints.
919  *
920  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
921  *
922  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
923  *
924  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
925  */
926 contract ERC721A is Context, ERC165, IERC721A {
927     using Address for address;
928     using Strings for uint256;
929 
930     // The tokenId of the next token to be minted.
931     uint256 internal _currentIndex;
932 
933     // The number of tokens burned.
934     uint256 internal _burnCounter;
935 
936     // Token name
937     string private _name;
938 
939     // Token symbol
940     string private _symbol;
941 
942     // Mapping from token ID to ownership details
943     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
944     mapping(uint256 => TokenOwnership) internal _ownerships;
945 
946     // Mapping owner address to address data
947     mapping(address => AddressData) private _addressData;
948 
949     // Mapping from token ID to approved address
950     mapping(uint256 => address) private _tokenApprovals;
951 
952     // Mapping from owner to operator approvals
953     mapping(address => mapping(address => bool)) private _operatorApprovals;
954 
955     constructor(string memory name_, string memory symbol_) {
956         _name = name_;
957         _symbol = symbol_;
958         _currentIndex = _startTokenId();
959     }
960 
961     /**
962      * To change the starting tokenId, please override this function.
963      */
964     function _startTokenId() internal view virtual returns (uint256) {
965         return 0;
966     }
967 
968     /**
969      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
970      */
971     function totalSupply() public view override returns (uint256) {
972         // Counter underflow is impossible as _burnCounter cannot be incremented
973         // more than _currentIndex - _startTokenId() times
974         unchecked {
975             return _currentIndex - _burnCounter - _startTokenId();
976         }
977     }
978 
979     /**
980      * Returns the total amount of tokens minted in the contract.
981      */
982     function _totalMinted() internal view returns (uint256) {
983         // Counter underflow is impossible as _currentIndex does not decrement,
984         // and it is initialized to _startTokenId()
985         unchecked {
986             return _currentIndex - _startTokenId();
987         }
988     }
989 
990     /**
991      * @dev See {IERC165-supportsInterface}.
992      */
993     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
994         return
995             interfaceId == type(IERC721).interfaceId ||
996             interfaceId == type(IERC721Metadata).interfaceId ||
997             super.supportsInterface(interfaceId);
998     }
999 
1000     /**
1001      * @dev See {IERC721-balanceOf}.
1002      */
1003     function balanceOf(address owner) public view override returns (uint256) {
1004         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1005         return uint256(_addressData[owner].balance);
1006     }
1007 
1008     /**
1009      * Returns the number of tokens minted by `owner`.
1010      */
1011     function _numberMinted(address owner) internal view returns (uint256) {
1012         return uint256(_addressData[owner].numberMinted);
1013     }
1014 
1015     /**
1016      * Returns the number of tokens burned by or on behalf of `owner`.
1017      */
1018     function _numberBurned(address owner) internal view returns (uint256) {
1019         return uint256(_addressData[owner].numberBurned);
1020     }
1021 
1022     /**
1023      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1024      */
1025     function _getAux(address owner) internal view returns (uint64) {
1026         return _addressData[owner].aux;
1027     }
1028 
1029     /**
1030      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1031      * If there are multiple variables, please pack them into a uint64.
1032      */
1033     function _setAux(address owner, uint64 aux) internal {
1034         _addressData[owner].aux = aux;
1035     }
1036 
1037     /**
1038      * Gas spent here starts off proportional to the maximum mint batch size.
1039      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1040      */
1041     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1042         uint256 curr = tokenId;
1043 
1044         unchecked {
1045             if (_startTokenId() <= curr && curr < _currentIndex) {
1046                 TokenOwnership memory ownership = _ownerships[curr];
1047                 if (!ownership.burned) {
1048                     if (ownership.addr != address(0)) {
1049                         return ownership;
1050                     }
1051                     // Invariant:
1052                     // There will always be an ownership that has an address and is not burned
1053                     // before an ownership that does not have an address and is not burned.
1054                     // Hence, curr will not underflow.
1055                     while (true) {
1056                         curr--;
1057                         ownership = _ownerships[curr];
1058                         if (ownership.addr != address(0)) {
1059                             return ownership;
1060                         }
1061                     }
1062                 }
1063             }
1064         }
1065         revert OwnerQueryForNonexistentToken();
1066     }
1067 
1068     /**
1069      * @dev See {IERC721-ownerOf}.
1070      */
1071     function ownerOf(uint256 tokenId) public view override returns (address) {
1072         return _ownershipOf(tokenId).addr;
1073     }
1074 
1075     /**
1076      * @dev See {IERC721Metadata-name}.
1077      */
1078     function name() public view virtual override returns (string memory) {
1079         return _name;
1080     }
1081 
1082     /**
1083      * @dev See {IERC721Metadata-symbol}.
1084      */
1085     function symbol() public view virtual override returns (string memory) {
1086         return _symbol;
1087     }
1088 
1089     /**
1090      * @dev See {IERC721Metadata-tokenURI}.
1091      */
1092     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1093         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1094 
1095         string memory baseURI = _baseURI();
1096         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1097     }
1098 
1099     /**
1100      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1101      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1102      * by default, can be overriden in child contracts.
1103      */
1104     function _baseURI() internal view virtual returns (string memory) {
1105         return '';
1106     }
1107 
1108     /**
1109      * @dev See {IERC721-approve}.
1110      */
1111     function approve(address to, uint256 tokenId) public override {
1112         address owner = ERC721A.ownerOf(tokenId);
1113         if (to == owner) revert ApprovalToCurrentOwner();
1114 
1115         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1116             revert ApprovalCallerNotOwnerNorApproved();
1117         }
1118 
1119         _approve(to, tokenId, owner);
1120     }
1121 
1122     /**
1123      * @dev See {IERC721-getApproved}.
1124      */
1125     function getApproved(uint256 tokenId) public view override returns (address) {
1126         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1127 
1128         return _tokenApprovals[tokenId];
1129     }
1130 
1131     /**
1132      * @dev See {IERC721-setApprovalForAll}.
1133      */
1134     function setApprovalForAll(address operator, bool approved) public virtual override {
1135         if (operator == _msgSender()) revert ApproveToCaller();
1136 
1137         _operatorApprovals[_msgSender()][operator] = approved;
1138         emit ApprovalForAll(_msgSender(), operator, approved);
1139     }
1140 
1141     /**
1142      * @dev See {IERC721-isApprovedForAll}.
1143      */
1144     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1145         return _operatorApprovals[owner][operator];
1146     }
1147 
1148     /**
1149      * @dev See {IERC721-transferFrom}.
1150      */
1151     function transferFrom(
1152         address from,
1153         address to,
1154         uint256 tokenId
1155     ) public virtual override {
1156         _transfer(from, to, tokenId);
1157     }
1158 
1159     /**
1160      * @dev See {IERC721-safeTransferFrom}.
1161      */
1162     function safeTransferFrom(
1163         address from,
1164         address to,
1165         uint256 tokenId
1166     ) public virtual override {
1167         safeTransferFrom(from, to, tokenId, '');
1168     }
1169 
1170     /**
1171      * @dev See {IERC721-safeTransferFrom}.
1172      */
1173     function safeTransferFrom(
1174         address from,
1175         address to,
1176         uint256 tokenId,
1177         bytes memory _data
1178     ) public virtual override {
1179         _transfer(from, to, tokenId);
1180         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1181             revert TransferToNonERC721ReceiverImplementer();
1182         }
1183     }
1184 
1185     /**
1186      * @dev Returns whether `tokenId` exists.
1187      *
1188      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1189      *
1190      * Tokens start existing when they are minted (`_mint`),
1191      */
1192     function _exists(uint256 tokenId) internal view returns (bool) {
1193         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1194     }
1195 
1196     /**
1197      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1198      */
1199     function _safeMint(address to, uint256 quantity) internal {
1200         _safeMint(to, quantity, '');
1201     }
1202 
1203     /**
1204      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1205      *
1206      * Requirements:
1207      *
1208      * - If `to` refers to a smart contract, it must implement
1209      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1210      * - `quantity` must be greater than 0.
1211      *
1212      * Emits a {Transfer} event.
1213      */
1214     function _safeMint(
1215         address to,
1216         uint256 quantity,
1217         bytes memory _data
1218     ) internal {
1219         uint256 startTokenId = _currentIndex;
1220         if (to == address(0)) revert MintToZeroAddress();
1221         if (quantity == 0) revert MintZeroQuantity();
1222 
1223         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1224 
1225         // Overflows are incredibly unrealistic.
1226         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1227         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1228         unchecked {
1229             _addressData[to].balance += uint64(quantity);
1230             _addressData[to].numberMinted += uint64(quantity);
1231 
1232             _ownerships[startTokenId].addr = to;
1233             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1234 
1235             uint256 updatedIndex = startTokenId;
1236             uint256 end = updatedIndex + quantity;
1237 
1238             if (to.isContract()) {
1239                 do {
1240                     emit Transfer(address(0), to, updatedIndex);
1241                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1242                         revert TransferToNonERC721ReceiverImplementer();
1243                     }
1244                 } while (updatedIndex < end);
1245                 // Reentrancy protection
1246                 if (_currentIndex != startTokenId) revert();
1247             } else {
1248                 do {
1249                     emit Transfer(address(0), to, updatedIndex++);
1250                 } while (updatedIndex < end);
1251             }
1252             _currentIndex = updatedIndex;
1253         }
1254         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1255     }
1256 
1257     /**
1258      * @dev Mints `quantity` tokens and transfers them to `to`.
1259      *
1260      * Requirements:
1261      *
1262      * - `to` cannot be the zero address.
1263      * - `quantity` must be greater than 0.
1264      *
1265      * Emits a {Transfer} event.
1266      */
1267     function _mint(address to, uint256 quantity) internal {
1268         uint256 startTokenId = _currentIndex;
1269         if (to == address(0)) revert MintToZeroAddress();
1270         if (quantity == 0) revert MintZeroQuantity();
1271 
1272         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1273 
1274         // Overflows are incredibly unrealistic.
1275         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1276         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1277         unchecked {
1278             _addressData[to].balance += uint64(quantity);
1279             _addressData[to].numberMinted += uint64(quantity);
1280 
1281             _ownerships[startTokenId].addr = to;
1282             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1283 
1284             uint256 updatedIndex = startTokenId;
1285             uint256 end = updatedIndex + quantity;
1286 
1287             do {
1288                 emit Transfer(address(0), to, updatedIndex++);
1289             } while (updatedIndex < end);
1290 
1291             _currentIndex = updatedIndex;
1292         }
1293         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1294     }
1295 
1296     /**
1297      * @dev Transfers `tokenId` from `from` to `to`.
1298      *
1299      * Requirements:
1300      *
1301      * - `to` cannot be the zero address.
1302      * - `tokenId` token must be owned by `from`.
1303      *
1304      * Emits a {Transfer} event.
1305      */
1306     function _transfer(
1307         address from,
1308         address to,
1309         uint256 tokenId
1310     ) private {
1311         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1312 
1313         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1314 
1315         bool isApprovedOrOwner = (_msgSender() == from ||
1316             isApprovedForAll(from, _msgSender()) ||
1317             getApproved(tokenId) == _msgSender());
1318 
1319         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1320         if (to == address(0)) revert TransferToZeroAddress();
1321 
1322         _beforeTokenTransfers(from, to, tokenId, 1);
1323 
1324         // Clear approvals from the previous owner
1325         _approve(address(0), tokenId, from);
1326 
1327         // Underflow of the sender's balance is impossible because we check for
1328         // ownership above and the recipient's balance can't realistically overflow.
1329         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1330         unchecked {
1331             _addressData[from].balance -= 1;
1332             _addressData[to].balance += 1;
1333 
1334             TokenOwnership storage currSlot = _ownerships[tokenId];
1335             currSlot.addr = to;
1336             currSlot.startTimestamp = uint64(block.timestamp);
1337 
1338             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1339             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1340             uint256 nextTokenId = tokenId + 1;
1341             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1342             if (nextSlot.addr == address(0)) {
1343                 // This will suffice for checking _exists(nextTokenId),
1344                 // as a burned slot cannot contain the zero address.
1345                 if (nextTokenId != _currentIndex) {
1346                     nextSlot.addr = from;
1347                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1348                 }
1349             }
1350         }
1351 
1352         emit Transfer(from, to, tokenId);
1353         _afterTokenTransfers(from, to, tokenId, 1);
1354     }
1355 
1356     /**
1357      * @dev Equivalent to `_burn(tokenId, false)`.
1358      */
1359     function _burn(uint256 tokenId) internal virtual {
1360         _burn(tokenId, false);
1361     }
1362 
1363     /**
1364      * @dev Destroys `tokenId`.
1365      * The approval is cleared when the token is burned.
1366      *
1367      * Requirements:
1368      *
1369      * - `tokenId` must exist.
1370      *
1371      * Emits a {Transfer} event.
1372      */
1373     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1374         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1375 
1376         address from = prevOwnership.addr;
1377 
1378         if (approvalCheck) {
1379             bool isApprovedOrOwner = (_msgSender() == from ||
1380                 isApprovedForAll(from, _msgSender()) ||
1381                 getApproved(tokenId) == _msgSender());
1382 
1383             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1384         }
1385 
1386         _beforeTokenTransfers(from, address(0), tokenId, 1);
1387 
1388         // Clear approvals from the previous owner
1389         _approve(address(0), tokenId, from);
1390 
1391         // Underflow of the sender's balance is impossible because we check for
1392         // ownership above and the recipient's balance can't realistically overflow.
1393         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1394         unchecked {
1395             AddressData storage addressData = _addressData[from];
1396             addressData.balance -= 1;
1397             addressData.numberBurned += 1;
1398 
1399             // Keep track of who burned the token, and the timestamp of burning.
1400             TokenOwnership storage currSlot = _ownerships[tokenId];
1401             currSlot.addr = from;
1402             currSlot.startTimestamp = uint64(block.timestamp);
1403             currSlot.burned = true;
1404 
1405             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1406             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1407             uint256 nextTokenId = tokenId + 1;
1408             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1409             if (nextSlot.addr == address(0)) {
1410                 // This will suffice for checking _exists(nextTokenId),
1411                 // as a burned slot cannot contain the zero address.
1412                 if (nextTokenId != _currentIndex) {
1413                     nextSlot.addr = from;
1414                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1415                 }
1416             }
1417         }
1418 
1419         emit Transfer(from, address(0), tokenId);
1420         _afterTokenTransfers(from, address(0), tokenId, 1);
1421 
1422         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1423         unchecked {
1424             _burnCounter++;
1425         }
1426     }
1427 
1428     /**
1429      * @dev Approve `to` to operate on `tokenId`
1430      *
1431      * Emits a {Approval} event.
1432      */
1433     function _approve(
1434         address to,
1435         uint256 tokenId,
1436         address owner
1437     ) private {
1438         _tokenApprovals[tokenId] = to;
1439         emit Approval(owner, to, tokenId);
1440     }
1441 
1442     /**
1443      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1444      *
1445      * @param from address representing the previous owner of the given token ID
1446      * @param to target address that will receive the tokens
1447      * @param tokenId uint256 ID of the token to be transferred
1448      * @param _data bytes optional data to send along with the call
1449      * @return bool whether the call correctly returned the expected magic value
1450      */
1451     function _checkContractOnERC721Received(
1452         address from,
1453         address to,
1454         uint256 tokenId,
1455         bytes memory _data
1456     ) private returns (bool) {
1457         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1458             return retval == IERC721Receiver(to).onERC721Received.selector;
1459         } catch (bytes memory reason) {
1460             if (reason.length == 0) {
1461                 revert TransferToNonERC721ReceiverImplementer();
1462             } else {
1463                 assembly {
1464                     revert(add(32, reason), mload(reason))
1465                 }
1466             }
1467         }
1468     }
1469 
1470     /**
1471      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1472      * And also called before burning one token.
1473      *
1474      * startTokenId - the first token id to be transferred
1475      * quantity - the amount to be transferred
1476      *
1477      * Calling conditions:
1478      *
1479      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1480      * transferred to `to`.
1481      * - When `from` is zero, `tokenId` will be minted for `to`.
1482      * - When `to` is zero, `tokenId` will be burned by `from`.
1483      * - `from` and `to` are never both zero.
1484      */
1485     function _beforeTokenTransfers(
1486         address from,
1487         address to,
1488         uint256 startTokenId,
1489         uint256 quantity
1490     ) internal virtual {}
1491 
1492     /**
1493      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1494      * minting.
1495      * And also called after one token has been burned.
1496      *
1497      * startTokenId - the first token id to be transferred
1498      * quantity - the amount to be transferred
1499      *
1500      * Calling conditions:
1501      *
1502      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1503      * transferred to `to`.
1504      * - When `from` is zero, `tokenId` has been minted for `to`.
1505      * - When `to` is zero, `tokenId` has been burned by `from`.
1506      * - `from` and `to` are never both zero.
1507      */
1508     function _afterTokenTransfers(
1509         address from,
1510         address to,
1511         uint256 startTokenId,
1512         uint256 quantity
1513     ) internal virtual {}
1514 }
1515 
1516 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/extensions/ERC721AQueryable.sol
1517 
1518 
1519 // Creator: Chiru Labs
1520 
1521 pragma solidity ^0.8.4;
1522 
1523 
1524 
1525 /**
1526  * @title ERC721A Queryable
1527  * @dev ERC721A subclass with convenience query functions.
1528  */
1529 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1530     /**
1531      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1532      *
1533      * If the `tokenId` is out of bounds:
1534      *   - `addr` = `address(0)`
1535      *   - `startTimestamp` = `0`
1536      *   - `burned` = `false`
1537      *
1538      * If the `tokenId` is burned:
1539      *   - `addr` = `<Address of owner before token was burned>`
1540      *   - `startTimestamp` = `<Timestamp when token was burned>`
1541      *   - `burned = `true`
1542      *
1543      * Otherwise:
1544      *   - `addr` = `<Address of owner>`
1545      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1546      *   - `burned = `false`
1547      */
1548     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1549         TokenOwnership memory ownership;
1550         if (tokenId < _startTokenId() || tokenId >= _currentIndex) {
1551             return ownership;
1552         }
1553         ownership = _ownerships[tokenId];
1554         if (ownership.burned) {
1555             return ownership;
1556         }
1557         return _ownershipOf(tokenId);
1558     }
1559 
1560     /**
1561      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1562      * See {ERC721AQueryable-explicitOwnershipOf}
1563      */
1564     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1565         unchecked {
1566             uint256 tokenIdsLength = tokenIds.length;
1567             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1568             for (uint256 i; i != tokenIdsLength; ++i) {
1569                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1570             }
1571             return ownerships;
1572         }
1573     }
1574 
1575     /**
1576      * @dev Returns an array of token IDs owned by `owner`,
1577      * in the range [`start`, `stop`)
1578      * (i.e. `start <= tokenId < stop`).
1579      *
1580      * This function allows for tokens to be queried if the collection
1581      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1582      *
1583      * Requirements:
1584      *
1585      * - `start` < `stop`
1586      */
1587     function tokensOfOwnerIn(
1588         address owner,
1589         uint256 start,
1590         uint256 stop
1591     ) external view override returns (uint256[] memory) {
1592         unchecked {
1593             if (start >= stop) revert InvalidQueryRange();
1594             uint256 tokenIdsIdx;
1595             uint256 stopLimit = _currentIndex;
1596             // Set `start = max(start, _startTokenId())`.
1597             if (start < _startTokenId()) {
1598                 start = _startTokenId();
1599             }
1600             // Set `stop = min(stop, _currentIndex)`.
1601             if (stop > stopLimit) {
1602                 stop = stopLimit;
1603             }
1604             uint256 tokenIdsMaxLength = balanceOf(owner);
1605             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1606             // to cater for cases where `balanceOf(owner)` is too big.
1607             if (start < stop) {
1608                 uint256 rangeLength = stop - start;
1609                 if (rangeLength < tokenIdsMaxLength) {
1610                     tokenIdsMaxLength = rangeLength;
1611                 }
1612             } else {
1613                 tokenIdsMaxLength = 0;
1614             }
1615             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1616             if (tokenIdsMaxLength == 0) {
1617                 return tokenIds;
1618             }
1619             // We need to call `explicitOwnershipOf(start)`,
1620             // because the slot at `start` may not be initialized.
1621             TokenOwnership memory ownership = explicitOwnershipOf(start);
1622             address currOwnershipAddr;
1623             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1624             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1625             if (!ownership.burned) {
1626                 currOwnershipAddr = ownership.addr;
1627             }
1628             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1629                 ownership = _ownerships[i];
1630                 if (ownership.burned) {
1631                     continue;
1632                 }
1633                 if (ownership.addr != address(0)) {
1634                     currOwnershipAddr = ownership.addr;
1635                 }
1636                 if (currOwnershipAddr == owner) {
1637                     tokenIds[tokenIdsIdx++] = i;
1638                 }
1639             }
1640             // Downsize the array to fit.
1641             assembly {
1642                 mstore(tokenIds, tokenIdsIdx)
1643             }
1644             return tokenIds;
1645         }
1646     }
1647 
1648     /**
1649      * @dev Returns an array of token IDs owned by `owner`.
1650      *
1651      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1652      * It is meant to be called off-chain.
1653      *
1654      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1655      * multiple smaller scans if the collection is large enough to cause
1656      * an out-of-gas error (10K pfp collections should be fine).
1657      */
1658     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1659         unchecked {
1660             uint256 tokenIdsIdx;
1661             address currOwnershipAddr;
1662             uint256 tokenIdsLength = balanceOf(owner);
1663             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1664             TokenOwnership memory ownership;
1665             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1666                 ownership = _ownerships[i];
1667                 if (ownership.burned) {
1668                     continue;
1669                 }
1670                 if (ownership.addr != address(0)) {
1671                     currOwnershipAddr = ownership.addr;
1672                 }
1673                 if (currOwnershipAddr == owner) {
1674                     tokenIds[tokenIdsIdx++] = i;
1675                 }
1676             }
1677             return tokenIds;
1678         }
1679     }
1680 }
1681 
1682 // File: @openzeppelin/contracts/access/Ownable.sol
1683 
1684 
1685 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1686 
1687 pragma solidity ^0.8.0;
1688 
1689 
1690 /**
1691  * @dev Contract module which provides a basic access control mechanism, where
1692  * there is an account (an owner) that can be granted exclusive access to
1693  * specific functions.
1694  *
1695  * By default, the owner account will be the one that deploys the contract. This
1696  * can later be changed with {transferOwnership}.
1697  *
1698  * This module is used through inheritance. It will make available the modifier
1699  * `onlyOwner`, which can be applied to your functions to restrict their use to
1700  * the owner.
1701  */
1702 abstract contract Ownable is Context {
1703     address private _owner;
1704 
1705     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1706 
1707     /**
1708      * @dev Initializes the contract setting the deployer as the initial owner.
1709      */
1710     constructor() {
1711         _transferOwnership(_msgSender());
1712     }
1713 
1714     /**
1715      * @dev Returns the address of the current owner.
1716      */
1717     function owner() public view virtual returns (address) {
1718         return _owner;
1719     }
1720 
1721     /**
1722      * @dev Throws if called by any account other than the owner.
1723      */
1724     modifier onlyOwner() {
1725         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1726         _;
1727     }
1728 
1729     /**
1730      * @dev Leaves the contract without owner. It will not be possible to call
1731      * `onlyOwner` functions anymore. Can only be called by the current owner.
1732      *
1733      * NOTE: Renouncing ownership will leave the contract without an owner,
1734      * thereby removing any functionality that is only available to the owner.
1735      */
1736     function renounceOwnership() public virtual onlyOwner {
1737         _transferOwnership(address(0));
1738     }
1739 
1740     /**
1741      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1742      * Can only be called by the current owner.
1743      */
1744     function transferOwnership(address newOwner) public virtual onlyOwner {
1745         require(newOwner != address(0), "Ownable: new owner is the zero address");
1746         _transferOwnership(newOwner);
1747     }
1748 
1749     /**
1750      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1751      * Internal function without access restriction.
1752      */
1753     function _transferOwnership(address newOwner) internal virtual {
1754         address oldOwner = _owner;
1755         _owner = newOwner;
1756         emit OwnershipTransferred(oldOwner, newOwner);
1757     }
1758 }
1759 
1760 // File: Boneheadz.sol
1761 
1762 
1763 pragma solidity 0.8.13;
1764 
1765 
1766 
1767 
1768 
1769 
1770 
1771 
1772 interface ITombRaid {
1773     function isLocked(uint256 id) external view returns (bool);
1774 
1775     function tokenTiers(uint256 id) external view returns (uint256);
1776 }
1777 
1778 contract Boneheadz is ERC721A, ERC721AQueryable, Ownable, ReentrancyGuard {
1779     using Strings for uint256;
1780 
1781     ITombRaid public tombRaid;
1782 
1783     string internal _baseTokenURI;
1784     string internal _unrevealedURI;
1785     string internal _lockedURI;
1786 
1787     uint256 internal _reserved;
1788 
1789     bool public revealed;
1790     bool public whitelistMintActive;
1791     bool public publicMintActive;
1792 
1793     mapping(address => uint256) public numMinted;
1794 
1795     bytes32 public merkleRoot;
1796 
1797     uint256 public constant MAX_AMOUNT_PER_WALLET = 2;
1798     uint256 public constant MAX_RESERVED_AMOUNT = 100;
1799     uint256 public constant MAX_TOTAL_SUPPLY = 5_000;
1800 
1801     constructor(
1802         string memory unrevealedURI,
1803         string memory lockedURI,
1804         bytes32 root
1805     ) ERC721A("Boneheadz", "BONEHEADZ") {
1806         _unrevealedURI = unrevealedURI;
1807         _lockedURI = lockedURI;
1808         merkleRoot = root;
1809     }
1810 
1811     // URI FUNCTIONS
1812 
1813     function _baseURI() internal view virtual override returns (string memory) {
1814         return _baseTokenURI;
1815     }
1816 
1817     function tokenURI(uint256 tokenId) public view virtual override(ERC721A, IERC721Metadata) returns (string memory) {
1818         if (!revealed || address(tombRaid) == address(0x0)) {
1819             return _unrevealedURI;
1820         }
1821 
1822         if (tombRaid.isLocked(tokenId)) {
1823             return _lockedURI;
1824         }
1825 
1826         string memory baseURI = _baseURI();
1827         uint256 level = tombRaid.tokenTiers(tokenId);
1828         return string(abi.encodePacked(baseURI, tokenId.toString(), "-", level.toString()));
1829     }
1830 
1831     // OWNER FUNCTIONS
1832 
1833     function setBaseURI(string calldata baseURI) external onlyOwner {
1834         _baseTokenURI = baseURI;
1835     }
1836 
1837     function setUnrevealedURI(string calldata unrevealedURI) external onlyOwner {
1838         _unrevealedURI = unrevealedURI;
1839     }
1840 
1841     function setLockedURI(string calldata lockedURI) external onlyOwner {
1842         _lockedURI = lockedURI;
1843     }
1844 
1845     function setMerkleRoot(bytes32 root) external onlyOwner {
1846         merkleRoot = root;
1847     }
1848 
1849     function setTombRaid(address _tombRaid) external onlyOwner {
1850         tombRaid = ITombRaid(_tombRaid);
1851     }
1852 
1853     function flipWhitelistMintStatus() public onlyOwner {
1854         whitelistMintActive = !whitelistMintActive;
1855     }
1856 
1857     function flipPublicMintStatus() public onlyOwner {
1858         publicMintActive = !publicMintActive;
1859     }
1860 
1861     function flipReveal() public onlyOwner {
1862         revealed = !revealed;
1863     }
1864 
1865     function withdraw() external onlyOwner nonReentrant {
1866         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1867         require(success, "Withdraw failed");
1868     }
1869 
1870     // MINTING FUNCTIONS
1871 
1872     function verify(
1873         bytes32 root,
1874         bytes32 leaf,
1875         bytes32[] memory proof
1876     ) public pure returns (bool) {
1877         return MerkleProof.verify(proof, root, leaf);
1878     }
1879 
1880     function presaleMint(
1881         uint256 amount,
1882         bytes32 leaf,
1883         bytes32[] memory proof
1884     ) external payable {
1885         require(whitelistMintActive, "Whitelist mint not active");
1886 
1887         // verify that msg.sender corresponds to Merkle leaf
1888         require(keccak256(abi.encodePacked(msg.sender)) == leaf, "Sender doesn't match Merkle leaf");
1889 
1890         // verify that (leaf, proof) matches the Merkle root
1891         require(verify(merkleRoot, leaf, proof), "Not a valid leaf in the Merkle tree");
1892 
1893         require(numMinted[msg.sender] + amount <= MAX_AMOUNT_PER_WALLET, "Minting too many per wallet");
1894         require(amount + totalSupply() <= MAX_TOTAL_SUPPLY, "Would exceed max supply");
1895 
1896         numMinted[msg.sender] += amount;
1897         _mint(msg.sender, amount);
1898     }
1899 
1900     function mint(uint256 amount) external payable {
1901         require(publicMintActive, "Public mint not active");
1902         require(numMinted[msg.sender] + amount <= MAX_AMOUNT_PER_WALLET, "Minting too many per wallet");
1903         require(amount + totalSupply() <= MAX_TOTAL_SUPPLY, "Would exceed max supply");
1904 
1905         numMinted[msg.sender] += amount;
1906         _mint(msg.sender, amount);
1907     }
1908 
1909     // reserves 'amount' NFTs minted direct to a specified wallet
1910     function reserve(address to, uint256 amount) external onlyOwner {
1911         require(_reserved + amount <= MAX_RESERVED_AMOUNT, "Would exceed max reserved amount");
1912         require(amount + totalSupply() <= MAX_TOTAL_SUPPLY, "Would exceed max supply");
1913 
1914         _reserved += amount;
1915         _mint(to, amount);
1916     }
1917 }