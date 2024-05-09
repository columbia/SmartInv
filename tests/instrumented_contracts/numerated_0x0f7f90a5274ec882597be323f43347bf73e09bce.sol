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
229 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
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
246      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
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
318 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
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
357      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
358      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
359      *
360      * Requirements:
361      *
362      * - `from` cannot be the zero address.
363      * - `to` cannot be the zero address.
364      * - `tokenId` token must exist and be owned by `from`.
365      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
366      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
367      *
368      * Emits a {Transfer} event.
369      */
370     function safeTransferFrom(
371         address from,
372         address to,
373         uint256 tokenId
374     ) external;
375 
376     /**
377      * @dev Transfers `tokenId` token from `from` to `to`.
378      *
379      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
380      *
381      * Requirements:
382      *
383      * - `from` cannot be the zero address.
384      * - `to` cannot be the zero address.
385      * - `tokenId` token must be owned by `from`.
386      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
387      *
388      * Emits a {Transfer} event.
389      */
390     function transferFrom(
391         address from,
392         address to,
393         uint256 tokenId
394     ) external;
395 
396     /**
397      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
398      * The approval is cleared when the token is transferred.
399      *
400      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
401      *
402      * Requirements:
403      *
404      * - The caller must own the token or be an approved operator.
405      * - `tokenId` must exist.
406      *
407      * Emits an {Approval} event.
408      */
409     function approve(address to, uint256 tokenId) external;
410 
411     /**
412      * @dev Returns the account approved for `tokenId` token.
413      *
414      * Requirements:
415      *
416      * - `tokenId` must exist.
417      */
418     function getApproved(uint256 tokenId) external view returns (address operator);
419 
420     /**
421      * @dev Approve or remove `operator` as an operator for the caller.
422      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
423      *
424      * Requirements:
425      *
426      * - The `operator` cannot be the caller.
427      *
428      * Emits an {ApprovalForAll} event.
429      */
430     function setApprovalForAll(address operator, bool _approved) external;
431 
432     /**
433      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
434      *
435      * See {setApprovalForAll}
436      */
437     function isApprovedForAll(address owner, address operator) external view returns (bool);
438 
439     /**
440      * @dev Safely transfers `tokenId` token from `from` to `to`.
441      *
442      * Requirements:
443      *
444      * - `from` cannot be the zero address.
445      * - `to` cannot be the zero address.
446      * - `tokenId` token must exist and be owned by `from`.
447      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
448      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
449      *
450      * Emits a {Transfer} event.
451      */
452     function safeTransferFrom(
453         address from,
454         address to,
455         uint256 tokenId,
456         bytes calldata data
457     ) external;
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
489 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
490 
491 
492 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
493 
494 pragma solidity ^0.8.0;
495 
496 /**
497  * @dev These functions deal with verification of Merkle Trees proofs.
498  *
499  * The proofs can be generated using the JavaScript library
500  * https://github.com/miguelmota/merkletreejs[merkletreejs].
501  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
502  *
503  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
504  */
505 library MerkleProof {
506     /**
507      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
508      * defined by `root`. For this, a `proof` must be provided, containing
509      * sibling hashes on the branch from the leaf to the root of the tree. Each
510      * pair of leaves and each pair of pre-images are assumed to be sorted.
511      */
512     function verify(
513         bytes32[] memory proof,
514         bytes32 root,
515         bytes32 leaf
516     ) internal pure returns (bool) {
517         return processProof(proof, leaf) == root;
518     }
519 
520     /**
521      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
522      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
523      * hash matches the root of the tree. When processing the proof, the pairs
524      * of leafs & pre-images are assumed to be sorted.
525      *
526      * _Available since v4.4._
527      */
528     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
529         bytes32 computedHash = leaf;
530         for (uint256 i = 0; i < proof.length; i++) {
531             bytes32 proofElement = proof[i];
532             if (computedHash <= proofElement) {
533                 // Hash(current computed hash + current element of the proof)
534                 computedHash = _efficientHash(computedHash, proofElement);
535             } else {
536                 // Hash(current element of the proof + current computed hash)
537                 computedHash = _efficientHash(proofElement, computedHash);
538             }
539         }
540         return computedHash;
541     }
542 
543     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
544         assembly {
545             mstore(0x00, a)
546             mstore(0x20, b)
547             value := keccak256(0x00, 0x40)
548         }
549     }
550 }
551 
552 // File: @openzeppelin/contracts/utils/Strings.sol
553 
554 
555 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
556 
557 pragma solidity ^0.8.0;
558 
559 /**
560  * @dev String operations.
561  */
562 library Strings {
563     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
564 
565     /**
566      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
567      */
568     function toString(uint256 value) internal pure returns (string memory) {
569         // Inspired by OraclizeAPI's implementation - MIT licence
570         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
571 
572         if (value == 0) {
573             return "0";
574         }
575         uint256 temp = value;
576         uint256 digits;
577         while (temp != 0) {
578             digits++;
579             temp /= 10;
580         }
581         bytes memory buffer = new bytes(digits);
582         while (value != 0) {
583             digits -= 1;
584             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
585             value /= 10;
586         }
587         return string(buffer);
588     }
589 
590     /**
591      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
592      */
593     function toHexString(uint256 value) internal pure returns (string memory) {
594         if (value == 0) {
595             return "0x00";
596         }
597         uint256 temp = value;
598         uint256 length = 0;
599         while (temp != 0) {
600             length++;
601             temp >>= 8;
602         }
603         return toHexString(value, length);
604     }
605 
606     /**
607      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
608      */
609     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
610         bytes memory buffer = new bytes(2 * length + 2);
611         buffer[0] = "0";
612         buffer[1] = "x";
613         for (uint256 i = 2 * length + 1; i > 1; --i) {
614             buffer[i] = _HEX_SYMBOLS[value & 0xf];
615             value >>= 4;
616         }
617         require(value == 0, "Strings: hex length insufficient");
618         return string(buffer);
619     }
620 }
621 
622 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
623 
624 
625 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
626 
627 pragma solidity ^0.8.0;
628 
629 /**
630  * @dev Contract module that helps prevent reentrant calls to a function.
631  *
632  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
633  * available, which can be applied to functions to make sure there are no nested
634  * (reentrant) calls to them.
635  *
636  * Note that because there is a single `nonReentrant` guard, functions marked as
637  * `nonReentrant` may not call one another. This can be worked around by making
638  * those functions `private`, and then adding `external` `nonReentrant` entry
639  * points to them.
640  *
641  * TIP: If you would like to learn more about reentrancy and alternative ways
642  * to protect against it, check out our blog post
643  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
644  */
645 abstract contract ReentrancyGuard {
646     // Booleans are more expensive than uint256 or any type that takes up a full
647     // word because each write operation emits an extra SLOAD to first read the
648     // slot's contents, replace the bits taken up by the boolean, and then write
649     // back. This is the compiler's defense against contract upgrades and
650     // pointer aliasing, and it cannot be disabled.
651 
652     // The values being non-zero value makes deployment a bit more expensive,
653     // but in exchange the refund on every call to nonReentrant will be lower in
654     // amount. Since refunds are capped to a percentage of the total
655     // transaction's gas, it is best to keep them low in cases like this one, to
656     // increase the likelihood of the full refund coming into effect.
657     uint256 private constant _NOT_ENTERED = 1;
658     uint256 private constant _ENTERED = 2;
659 
660     uint256 private _status;
661 
662     constructor() {
663         _status = _NOT_ENTERED;
664     }
665 
666     /**
667      * @dev Prevents a contract from calling itself, directly or indirectly.
668      * Calling a `nonReentrant` function from another `nonReentrant`
669      * function is not supported. It is possible to prevent this from happening
670      * by making the `nonReentrant` function external, and making it call a
671      * `private` function that does the actual work.
672      */
673     modifier nonReentrant() {
674         // On the first call to nonReentrant, _notEntered will be true
675         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
676 
677         // Any calls to nonReentrant after this point will fail
678         _status = _ENTERED;
679 
680         _;
681 
682         // By storing the original value once again, a refund is triggered (see
683         // https://eips.ethereum.org/EIPS/eip-2200)
684         _status = _NOT_ENTERED;
685     }
686 }
687 
688 // File: @openzeppelin/contracts/utils/Context.sol
689 
690 
691 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
692 
693 pragma solidity ^0.8.0;
694 
695 /**
696  * @dev Provides information about the current execution context, including the
697  * sender of the transaction and its data. While these are generally available
698  * via msg.sender and msg.data, they should not be accessed in such a direct
699  * manner, since when dealing with meta-transactions the account sending and
700  * paying for execution may not be the actual sender (as far as an application
701  * is concerned).
702  *
703  * This contract is only required for intermediate, library-like contracts.
704  */
705 abstract contract Context {
706     function _msgSender() internal view virtual returns (address) {
707         return msg.sender;
708     }
709 
710     function _msgData() internal view virtual returns (bytes calldata) {
711         return msg.data;
712     }
713 }
714 
715 // File: erc721a/contracts/ERC721A.sol
716 
717 
718 // Creator: Chiru Labs
719 
720 pragma solidity ^0.8.4;
721 
722 
723 
724 
725 
726 
727 
728 
729 error ApprovalCallerNotOwnerNorApproved();
730 error ApprovalQueryForNonexistentToken();
731 error ApproveToCaller();
732 error ApprovalToCurrentOwner();
733 error BalanceQueryForZeroAddress();
734 error MintToZeroAddress();
735 error MintZeroQuantity();
736 error OwnerQueryForNonexistentToken();
737 error TransferCallerNotOwnerNorApproved();
738 error TransferFromIncorrectOwner();
739 error TransferToNonERC721ReceiverImplementer();
740 error TransferToZeroAddress();
741 error URIQueryForNonexistentToken();
742 
743 /**
744  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
745  * the Metadata extension. Built to optimize for lower gas during batch mints.
746  *
747  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
748  *
749  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
750  *
751  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
752  */
753 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
754     using Address for address;
755     using Strings for uint256;
756 
757     // Compiler will pack this into a single 256bit word.
758     struct TokenOwnership {
759         // The address of the owner.
760         address addr;
761         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
762         uint64 startTimestamp;
763         // Whether the token has been burned.
764         bool burned;
765     }
766 
767     // Compiler will pack this into a single 256bit word.
768     struct AddressData {
769         // Realistically, 2**64-1 is more than enough.
770         uint64 balance;
771         // Keeps track of mint count with minimal overhead for tokenomics.
772         uint64 numberMinted;
773         // Keeps track of burn count with minimal overhead for tokenomics.
774         uint64 numberBurned;
775         // For miscellaneous variable(s) pertaining to the address
776         // (e.g. number of whitelist mint slots used).
777         // If there are multiple variables, please pack them into a uint64.
778         uint64 aux;
779     }
780 
781     // The tokenId of the next token to be minted.
782     uint256 internal _currentIndex;
783 
784     // The number of tokens burned.
785     uint256 internal _burnCounter;
786 
787     // Token name
788     string private _name;
789 
790     // Token symbol
791     string private _symbol;
792 
793     // Mapping from token ID to ownership details
794     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
795     mapping(uint256 => TokenOwnership) internal _ownerships;
796 
797     // Mapping owner address to address data
798     mapping(address => AddressData) private _addressData;
799 
800     // Mapping from token ID to approved address
801     mapping(uint256 => address) private _tokenApprovals;
802 
803     // Mapping from owner to operator approvals
804     mapping(address => mapping(address => bool)) private _operatorApprovals;
805 
806     constructor(string memory name_, string memory symbol_) {
807         _name = name_;
808         _symbol = symbol_;
809         _currentIndex = _startTokenId();
810     }
811 
812     /**
813      * To change the starting tokenId, please override this function.
814      */
815     function _startTokenId() internal view virtual returns (uint256) {
816         return 0;
817     }
818 
819     /**
820      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
821      */
822     function totalSupply() public view returns (uint256) {
823         // Counter underflow is impossible as _burnCounter cannot be incremented
824         // more than _currentIndex - _startTokenId() times
825         unchecked {
826             return _currentIndex - _burnCounter - _startTokenId();
827         }
828     }
829 
830     /**
831      * Returns the total amount of tokens minted in the contract.
832      */
833     function _totalMinted() internal view returns (uint256) {
834         // Counter underflow is impossible as _currentIndex does not decrement,
835         // and it is initialized to _startTokenId()
836         unchecked {
837             return _currentIndex - _startTokenId();
838         }
839     }
840 
841     /**
842      * @dev See {IERC165-supportsInterface}.
843      */
844     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
845         return
846             interfaceId == type(IERC721).interfaceId ||
847             interfaceId == type(IERC721Metadata).interfaceId ||
848             super.supportsInterface(interfaceId);
849     }
850 
851     /**
852      * @dev See {IERC721-balanceOf}.
853      */
854     function balanceOf(address owner) public view override returns (uint256) {
855         if (owner == address(0)) revert BalanceQueryForZeroAddress();
856         return uint256(_addressData[owner].balance);
857     }
858 
859     /**
860      * Returns the number of tokens minted by `owner`.
861      */
862     function _numberMinted(address owner) internal view returns (uint256) {
863         return uint256(_addressData[owner].numberMinted);
864     }
865 
866     /**
867      * Returns the number of tokens burned by or on behalf of `owner`.
868      */
869     function _numberBurned(address owner) internal view returns (uint256) {
870         return uint256(_addressData[owner].numberBurned);
871     }
872 
873     /**
874      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
875      */
876     function _getAux(address owner) internal view returns (uint64) {
877         return _addressData[owner].aux;
878     }
879 
880     /**
881      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
882      * If there are multiple variables, please pack them into a uint64.
883      */
884     function _setAux(address owner, uint64 aux) internal {
885         _addressData[owner].aux = aux;
886     }
887 
888     /**
889      * Gas spent here starts off proportional to the maximum mint batch size.
890      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
891      */
892     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
893         uint256 curr = tokenId;
894 
895         unchecked {
896             if (_startTokenId() <= curr && curr < _currentIndex) {
897                 TokenOwnership memory ownership = _ownerships[curr];
898                 if (!ownership.burned) {
899                     if (ownership.addr != address(0)) {
900                         return ownership;
901                     }
902                     // Invariant:
903                     // There will always be an ownership that has an address and is not burned
904                     // before an ownership that does not have an address and is not burned.
905                     // Hence, curr will not underflow.
906                     while (true) {
907                         curr--;
908                         ownership = _ownerships[curr];
909                         if (ownership.addr != address(0)) {
910                             return ownership;
911                         }
912                     }
913                 }
914             }
915         }
916         revert OwnerQueryForNonexistentToken();
917     }
918 
919     /**
920      * @dev See {IERC721-ownerOf}.
921      */
922     function ownerOf(uint256 tokenId) public view override returns (address) {
923         return _ownershipOf(tokenId).addr;
924     }
925 
926     /**
927      * @dev See {IERC721Metadata-name}.
928      */
929     function name() public view virtual override returns (string memory) {
930         return _name;
931     }
932 
933     /**
934      * @dev See {IERC721Metadata-symbol}.
935      */
936     function symbol() public view virtual override returns (string memory) {
937         return _symbol;
938     }
939 
940     /**
941      * @dev See {IERC721Metadata-tokenURI}.
942      */
943     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
944         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
945 
946         string memory baseURI = _baseURI();
947         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
948     }
949 
950     /**
951      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
952      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
953      * by default, can be overriden in child contracts.
954      */
955     function _baseURI() internal view virtual returns (string memory) {
956         return '';
957     }
958 
959     /**
960      * @dev See {IERC721-approve}.
961      */
962     function approve(address to, uint256 tokenId) public override {
963         address owner = ERC721A.ownerOf(tokenId);
964         if (to == owner) revert ApprovalToCurrentOwner();
965 
966         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
967             revert ApprovalCallerNotOwnerNorApproved();
968         }
969 
970         _approve(to, tokenId, owner);
971     }
972 
973     /**
974      * @dev See {IERC721-getApproved}.
975      */
976     function getApproved(uint256 tokenId) public view override returns (address) {
977         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
978 
979         return _tokenApprovals[tokenId];
980     }
981 
982     /**
983      * @dev See {IERC721-setApprovalForAll}.
984      */
985     function setApprovalForAll(address operator, bool approved) public virtual override {
986         if (operator == _msgSender()) revert ApproveToCaller();
987 
988         _operatorApprovals[_msgSender()][operator] = approved;
989         emit ApprovalForAll(_msgSender(), operator, approved);
990     }
991 
992     /**
993      * @dev See {IERC721-isApprovedForAll}.
994      */
995     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
996         return _operatorApprovals[owner][operator];
997     }
998 
999     /**
1000      * @dev See {IERC721-transferFrom}.
1001      */
1002     function transferFrom(
1003         address from,
1004         address to,
1005         uint256 tokenId
1006     ) public virtual override {
1007         _transfer(from, to, tokenId);
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-safeTransferFrom}.
1012      */
1013     function safeTransferFrom(
1014         address from,
1015         address to,
1016         uint256 tokenId
1017     ) public virtual override {
1018         safeTransferFrom(from, to, tokenId, '');
1019     }
1020 
1021     /**
1022      * @dev See {IERC721-safeTransferFrom}.
1023      */
1024     function safeTransferFrom(
1025         address from,
1026         address to,
1027         uint256 tokenId,
1028         bytes memory _data
1029     ) public virtual override {
1030         _transfer(from, to, tokenId);
1031         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1032             revert TransferToNonERC721ReceiverImplementer();
1033         }
1034     }
1035 
1036     /**
1037      * @dev Returns whether `tokenId` exists.
1038      *
1039      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1040      *
1041      * Tokens start existing when they are minted (`_mint`),
1042      */
1043     function _exists(uint256 tokenId) internal view returns (bool) {
1044         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1045             !_ownerships[tokenId].burned;
1046     }
1047 
1048     function _safeMint(address to, uint256 quantity) internal {
1049         _safeMint(to, quantity, '');
1050     }
1051 
1052     /**
1053      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1054      *
1055      * Requirements:
1056      *
1057      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1058      * - `quantity` must be greater than 0.
1059      *
1060      * Emits a {Transfer} event.
1061      */
1062     function _safeMint(
1063         address to,
1064         uint256 quantity,
1065         bytes memory _data
1066     ) internal {
1067         _mint(to, quantity, _data, true);
1068     }
1069 
1070     /**
1071      * @dev Mints `quantity` tokens and transfers them to `to`.
1072      *
1073      * Requirements:
1074      *
1075      * - `to` cannot be the zero address.
1076      * - `quantity` must be greater than 0.
1077      *
1078      * Emits a {Transfer} event.
1079      */
1080     function _mint(
1081         address to,
1082         uint256 quantity,
1083         bytes memory _data,
1084         bool safe
1085     ) internal {
1086         uint256 startTokenId = _currentIndex;
1087         if (to == address(0)) revert MintToZeroAddress();
1088         if (quantity == 0) revert MintZeroQuantity();
1089 
1090         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1091 
1092         // Overflows are incredibly unrealistic.
1093         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1094         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1095         unchecked {
1096             _addressData[to].balance += uint64(quantity);
1097             _addressData[to].numberMinted += uint64(quantity);
1098 
1099             _ownerships[startTokenId].addr = to;
1100             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1101 
1102             uint256 updatedIndex = startTokenId;
1103             uint256 end = updatedIndex + quantity;
1104 
1105             if (safe && to.isContract()) {
1106                 do {
1107                     emit Transfer(address(0), to, updatedIndex);
1108                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1109                         revert TransferToNonERC721ReceiverImplementer();
1110                     }
1111                 } while (updatedIndex != end);
1112                 // Reentrancy protection
1113                 if (_currentIndex != startTokenId) revert();
1114             } else {
1115                 do {
1116                     emit Transfer(address(0), to, updatedIndex++);
1117                 } while (updatedIndex != end);
1118             }
1119             _currentIndex = updatedIndex;
1120         }
1121         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1122     }
1123 
1124     /**
1125      * @dev Transfers `tokenId` from `from` to `to`.
1126      *
1127      * Requirements:
1128      *
1129      * - `to` cannot be the zero address.
1130      * - `tokenId` token must be owned by `from`.
1131      *
1132      * Emits a {Transfer} event.
1133      */
1134     function _transfer(
1135         address from,
1136         address to,
1137         uint256 tokenId
1138     ) private {
1139         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1140 
1141         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1142 
1143         bool isApprovedOrOwner = (_msgSender() == from ||
1144             isApprovedForAll(from, _msgSender()) ||
1145             getApproved(tokenId) == _msgSender());
1146 
1147         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1148         if (to == address(0)) revert TransferToZeroAddress();
1149 
1150         _beforeTokenTransfers(from, to, tokenId, 1);
1151 
1152         // Clear approvals from the previous owner
1153         _approve(address(0), tokenId, from);
1154 
1155         // Underflow of the sender's balance is impossible because we check for
1156         // ownership above and the recipient's balance can't realistically overflow.
1157         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1158         unchecked {
1159             _addressData[from].balance -= 1;
1160             _addressData[to].balance += 1;
1161 
1162             TokenOwnership storage currSlot = _ownerships[tokenId];
1163             currSlot.addr = to;
1164             currSlot.startTimestamp = uint64(block.timestamp);
1165 
1166             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1167             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1168             uint256 nextTokenId = tokenId + 1;
1169             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1170             if (nextSlot.addr == address(0)) {
1171                 // This will suffice for checking _exists(nextTokenId),
1172                 // as a burned slot cannot contain the zero address.
1173                 if (nextTokenId != _currentIndex) {
1174                     nextSlot.addr = from;
1175                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1176                 }
1177             }
1178         }
1179 
1180         emit Transfer(from, to, tokenId);
1181         _afterTokenTransfers(from, to, tokenId, 1);
1182     }
1183 
1184     /**
1185      * @dev This is equivalent to _burn(tokenId, false)
1186      */
1187     function _burn(uint256 tokenId) internal virtual {
1188         _burn(tokenId, false);
1189     }
1190 
1191     /**
1192      * @dev Destroys `tokenId`.
1193      * The approval is cleared when the token is burned.
1194      *
1195      * Requirements:
1196      *
1197      * - `tokenId` must exist.
1198      *
1199      * Emits a {Transfer} event.
1200      */
1201     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1202         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1203 
1204         address from = prevOwnership.addr;
1205 
1206         if (approvalCheck) {
1207             bool isApprovedOrOwner = (_msgSender() == from ||
1208                 isApprovedForAll(from, _msgSender()) ||
1209                 getApproved(tokenId) == _msgSender());
1210 
1211             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1212         }
1213 
1214         _beforeTokenTransfers(from, address(0), tokenId, 1);
1215 
1216         // Clear approvals from the previous owner
1217         _approve(address(0), tokenId, from);
1218 
1219         // Underflow of the sender's balance is impossible because we check for
1220         // ownership above and the recipient's balance can't realistically overflow.
1221         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1222         unchecked {
1223             AddressData storage addressData = _addressData[from];
1224             addressData.balance -= 1;
1225             addressData.numberBurned += 1;
1226 
1227             // Keep track of who burned the token, and the timestamp of burning.
1228             TokenOwnership storage currSlot = _ownerships[tokenId];
1229             currSlot.addr = from;
1230             currSlot.startTimestamp = uint64(block.timestamp);
1231             currSlot.burned = true;
1232 
1233             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1234             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1235             uint256 nextTokenId = tokenId + 1;
1236             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1237             if (nextSlot.addr == address(0)) {
1238                 // This will suffice for checking _exists(nextTokenId),
1239                 // as a burned slot cannot contain the zero address.
1240                 if (nextTokenId != _currentIndex) {
1241                     nextSlot.addr = from;
1242                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1243                 }
1244             }
1245         }
1246 
1247         emit Transfer(from, address(0), tokenId);
1248         _afterTokenTransfers(from, address(0), tokenId, 1);
1249 
1250         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1251         unchecked {
1252             _burnCounter++;
1253         }
1254     }
1255 
1256     /**
1257      * @dev Approve `to` to operate on `tokenId`
1258      *
1259      * Emits a {Approval} event.
1260      */
1261     function _approve(
1262         address to,
1263         uint256 tokenId,
1264         address owner
1265     ) private {
1266         _tokenApprovals[tokenId] = to;
1267         emit Approval(owner, to, tokenId);
1268     }
1269 
1270     /**
1271      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1272      *
1273      * @param from address representing the previous owner of the given token ID
1274      * @param to target address that will receive the tokens
1275      * @param tokenId uint256 ID of the token to be transferred
1276      * @param _data bytes optional data to send along with the call
1277      * @return bool whether the call correctly returned the expected magic value
1278      */
1279     function _checkContractOnERC721Received(
1280         address from,
1281         address to,
1282         uint256 tokenId,
1283         bytes memory _data
1284     ) private returns (bool) {
1285         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1286             return retval == IERC721Receiver(to).onERC721Received.selector;
1287         } catch (bytes memory reason) {
1288             if (reason.length == 0) {
1289                 revert TransferToNonERC721ReceiverImplementer();
1290             } else {
1291                 assembly {
1292                     revert(add(32, reason), mload(reason))
1293                 }
1294             }
1295         }
1296     }
1297 
1298     /**
1299      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1300      * And also called before burning one token.
1301      *
1302      * startTokenId - the first token id to be transferred
1303      * quantity - the amount to be transferred
1304      *
1305      * Calling conditions:
1306      *
1307      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1308      * transferred to `to`.
1309      * - When `from` is zero, `tokenId` will be minted for `to`.
1310      * - When `to` is zero, `tokenId` will be burned by `from`.
1311      * - `from` and `to` are never both zero.
1312      */
1313     function _beforeTokenTransfers(
1314         address from,
1315         address to,
1316         uint256 startTokenId,
1317         uint256 quantity
1318     ) internal virtual {}
1319 
1320     /**
1321      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1322      * minting.
1323      * And also called after one token has been burned.
1324      *
1325      * startTokenId - the first token id to be transferred
1326      * quantity - the amount to be transferred
1327      *
1328      * Calling conditions:
1329      *
1330      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1331      * transferred to `to`.
1332      * - When `from` is zero, `tokenId` has been minted for `to`.
1333      * - When `to` is zero, `tokenId` has been burned by `from`.
1334      * - `from` and `to` are never both zero.
1335      */
1336     function _afterTokenTransfers(
1337         address from,
1338         address to,
1339         uint256 startTokenId,
1340         uint256 quantity
1341     ) internal virtual {}
1342 }
1343 
1344 // File: @openzeppelin/contracts/access/Ownable.sol
1345 
1346 
1347 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1348 
1349 pragma solidity ^0.8.0;
1350 
1351 
1352 /**
1353  * @dev Contract module which provides a basic access control mechanism, where
1354  * there is an account (an owner) that can be granted exclusive access to
1355  * specific functions.
1356  *
1357  * By default, the owner account will be the one that deploys the contract. This
1358  * can later be changed with {transferOwnership}.
1359  *
1360  * This module is used through inheritance. It will make available the modifier
1361  * `onlyOwner`, which can be applied to your functions to restrict their use to
1362  * the owner.
1363  */
1364 abstract contract Ownable is Context {
1365     address private _owner;
1366 
1367     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1368 
1369     /**
1370      * @dev Initializes the contract setting the deployer as the initial owner.
1371      */
1372     constructor() {
1373         _transferOwnership(_msgSender());
1374     }
1375 
1376     /**
1377      * @dev Returns the address of the current owner.
1378      */
1379     function owner() public view virtual returns (address) {
1380         return _owner;
1381     }
1382 
1383     /**
1384      * @dev Throws if called by any account other than the owner.
1385      */
1386     modifier onlyOwner() {
1387         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1388         _;
1389     }
1390 
1391     /**
1392      * @dev Leaves the contract without owner. It will not be possible to call
1393      * `onlyOwner` functions anymore. Can only be called by the current owner.
1394      *
1395      * NOTE: Renouncing ownership will leave the contract without an owner,
1396      * thereby removing any functionality that is only available to the owner.
1397      */
1398     function renounceOwnership() public virtual onlyOwner {
1399         _transferOwnership(address(0));
1400     }
1401 
1402     /**
1403      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1404      * Can only be called by the current owner.
1405      */
1406     function transferOwnership(address newOwner) public virtual onlyOwner {
1407         require(newOwner != address(0), "Ownable: new owner is the zero address");
1408         _transferOwnership(newOwner);
1409     }
1410 
1411     /**
1412      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1413      * Internal function without access restriction.
1414      */
1415     function _transferOwnership(address newOwner) internal virtual {
1416         address oldOwner = _owner;
1417         _owner = newOwner;
1418         emit OwnershipTransferred(oldOwner, newOwner);
1419     }
1420 }
1421 
1422 // File: contracts/jidori.sol
1423 
1424 
1425 /*
1426 ┌───────┐        ┌─┐                       ┌────────┐
1427 └──┐ ┌──┘        | |                       |      ○ | 
1428    | |           | |                       |        | 
1429    | |         __| |   ___    _  __        |        | 
1430    | |   ●   / __  |  / _ \  | |/ / ●      |  FIND  | 
1431 __ | |  ┌─┐ / /  | | | | | | |  /  ┌─┐     |  YOUR  |          
1432 \ \/ /  | | | \__| | | |_| | | |   | |     | SELFIE | 
1433  \__/   |_|  \_____|  \___/  |_|   |_|     └────────┘
1434 
1435 */
1436 pragma solidity ^0.8.4;
1437 
1438 
1439 
1440 
1441 
1442 
1443 contract Jidori is Ownable, ERC721A, ReentrancyGuard {
1444     mapping(address => uint256) public whitelistPurchased;
1445 
1446     struct JidoriConfig {
1447         bytes32 rootHash;
1448         bool paused;
1449         bool isPublicSale;
1450         bool isPreSale;
1451         uint256 preSaleMaxMint;
1452         uint256 publicSaleMaxMint;
1453         uint256 publicSalePrice;
1454         uint256 preSalePrice;
1455         uint256 maxSupply;
1456         uint256 devMintAmount;
1457         uint256 freeSlots;
1458     }
1459 
1460     JidoriConfig public jidoriConfig;
1461 
1462     constructor() ERC721A("Jidori", "JIDORI") {
1463         initConfig( 
1464         0x0000000000000000000000000000000000000000000000000000000000000000, 
1465         true, 
1466         false, 
1467         true, 
1468         2, 
1469         8,
1470         9000000000000000,
1471         0,
1472         4000,
1473         50,
1474         0
1475         );
1476     }
1477 
1478     function initConfig(
1479         bytes32 rootHash, 
1480         bool paused, 
1481         bool isPublicSale, 
1482         bool isPreSale, 
1483         uint256 preSaleMaxMint, 
1484         uint256 publicSaleMaxMint,
1485         uint256 publicSalePrice,
1486         uint256 preSalePrice,
1487         uint256 maxSupply,
1488         uint256 devMintAmount,
1489         uint256 freeSlots
1490     ) private onlyOwner {
1491         jidoriConfig.rootHash = rootHash;
1492         jidoriConfig.paused = paused;
1493         jidoriConfig.isPublicSale = isPublicSale;
1494         jidoriConfig.isPreSale = isPreSale;
1495         jidoriConfig.preSaleMaxMint = preSaleMaxMint;
1496         jidoriConfig.publicSaleMaxMint = publicSaleMaxMint;
1497         jidoriConfig.publicSalePrice = publicSalePrice;
1498         jidoriConfig.preSalePrice = preSalePrice;
1499         jidoriConfig.maxSupply = maxSupply;
1500         jidoriConfig.devMintAmount = devMintAmount;
1501         jidoriConfig.freeSlots = freeSlots;
1502     }
1503 
1504     function preSaleMint(uint256 quantity, bytes32[] calldata proof)
1505         external
1506         payable
1507     {
1508         JidoriConfig memory config = jidoriConfig;
1509 
1510         bytes32 rootHash = bytes32(config.rootHash);
1511         bool paused = bool(config.paused);
1512         bool isPreSale = bool(config.isPreSale);
1513         uint256 preSaleMaxMint = uint256(config.preSaleMaxMint);
1514         uint256 devMintAmount = uint256(config.devMintAmount);
1515         uint256 maxSupply = uint256(config.maxSupply);
1516 
1517         require(!paused, "Sale paused or not start.");
1518         require(isPreSale, "Pre-sale not yet started.");
1519 
1520         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1521         require(MerkleProof.verify(proof, rootHash, leaf), "Proof invalid.");
1522         require(
1523             whitelistPurchased[msg.sender] + quantity <= preSaleMaxMint,
1524             "Reached the maximum amount of whitelisted wallet."
1525         );
1526         require(
1527             totalSupply() + quantity + devMintAmount <= maxSupply,
1528             "Insufficient quantity left."
1529         );
1530         whitelistPurchased[msg.sender] += quantity;
1531         _safeMint(msg.sender, quantity);
1532     }
1533 
1534     function publicSaleMint(uint256 quantity) external payable {
1535 
1536         JidoriConfig memory config = jidoriConfig;
1537 
1538         bool paused = bool(config.paused);
1539         bool isPublicSale = bool(config.isPublicSale);
1540         uint256 publicSalePrice = uint256(config.publicSalePrice);
1541         uint256 publicSaleMaxMint = uint256(config.publicSaleMaxMint);
1542         uint256 preSaleMaxMint = uint256(config.preSaleMaxMint);
1543         uint256 devMintAmount = uint256(config.devMintAmount);
1544         uint256 maxSupply = uint256(config.maxSupply);
1545         uint256 freeSlots = uint256(config.freeSlots);
1546 
1547         require(!paused, "Sale paused or not start.");
1548         require(isPublicSale, "Public-sale not yet started.");
1549         require(
1550             totalSupply() + quantity + devMintAmount <= maxSupply,
1551             "Insufficient quantity left."
1552         );
1553 
1554         if (whitelistPurchased[msg.sender] == preSaleMaxMint) {
1555           require(
1556               addressMinted(msg.sender) + quantity <= publicSaleMaxMint + preSaleMaxMint,
1557               "Exceeds the maximum number per wallet."
1558           );
1559         } else {
1560           require(
1561               addressMinted(msg.sender) + quantity <= publicSaleMaxMint,
1562               "Exceeds the maximum number per wallet."
1563           );
1564         }
1565 
1566         if (totalSupply() + quantity <= freeSlots) {
1567             _safeMint(msg.sender, quantity);
1568         } else {
1569             require(
1570                 quantity * publicSalePrice <= msg.value,
1571                 "Insufficient balance."
1572             );
1573             _safeMint(msg.sender, quantity);
1574         }
1575 
1576     }
1577 
1578     function flipSaleStatus() public onlyOwner {
1579         jidoriConfig.isPreSale = !jidoriConfig.isPreSale;
1580         jidoriConfig.isPublicSale = !jidoriConfig.isPublicSale;
1581     }
1582 
1583     function setPaused(bool _state) public onlyOwner {
1584         jidoriConfig.paused = _state;
1585     }
1586 
1587     function setRootHash(bytes32 _hash) public onlyOwner {
1588         jidoriConfig.rootHash = _hash;
1589     }
1590 
1591     function setFreeSlots(uint256 _slots) public onlyOwner {
1592         jidoriConfig.freeSlots = _slots;
1593     }
1594     
1595     function addressMinted(address owner) public view returns (uint256) {
1596         return _numberMinted(owner);
1597     }
1598 
1599     function devMint(uint256 quantity) external onlyOwner {
1600         JidoriConfig memory config = jidoriConfig;
1601         uint256 maxSupply = uint256(config.maxSupply);
1602 
1603         require(totalSupply() + quantity <= maxSupply,
1604             "Insufficient quantity left."
1605         );
1606 
1607         uint256 numChunks = quantity / 5;
1608         for (uint256 i = 0; i < numChunks; i++) {
1609             _safeMint(msg.sender, 5);
1610         }
1611     }
1612 
1613     string private _baseTokenURI;
1614 
1615     function _baseURI() internal view virtual override returns (string memory) {
1616         return _baseTokenURI;
1617     }
1618 
1619     function setBaseURI(string calldata baseURI) external onlyOwner {
1620         _baseTokenURI = baseURI;
1621     }
1622 
1623     function withdraw() external onlyOwner nonReentrant {
1624         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1625         require(success, "Transfer failed.");
1626     }
1627 }