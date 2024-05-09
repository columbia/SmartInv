1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Address.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
7 
8 pragma solidity ^0.8.1;
9 
10 /**
11  * @dev Collection of functions related to the address type
12  */
13 library Address {
14     /**
15      * @dev Returns true if `account` is a contract.
16      *
17      * [IMPORTANT]
18      * ====
19      * It is unsafe to assume that an address for which this function returns
20      * false is an externally-owned account (EOA) and not a contract.
21      *
22      * Among others, `isContract` will return false for the following
23      * types of addresses:
24      *
25      *  - an externally-owned account
26      *  - a contract in construction
27      *  - an address where a contract will be created
28      *  - an address where a contract lived, but was destroyed
29      * ====
30      *
31      * [IMPORTANT]
32      * ====
33      * You shouldn't rely on `isContract` to protect against flash loan attacks!
34      *
35      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
36      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
37      * constructor.
38      * ====
39      */
40     function isContract(address account) internal view returns (bool) {
41         // This method relies on extcodesize/address.code.length, which returns 0
42         // for contracts in construction, since the code is only stored at the end
43         // of the constructor execution.
44 
45         return account.code.length > 0;
46     }
47 
48     /**
49      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
50      * `recipient`, forwarding all available gas and reverting on errors.
51      *
52      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
53      * of certain opcodes, possibly making contracts go over the 2300 gas limit
54      * imposed by `transfer`, making them unable to receive funds via
55      * `transfer`. {sendValue} removes this limitation.
56      *
57      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
58      *
59      * IMPORTANT: because control is transferred to `recipient`, care must be
60      * taken to not create reentrancy vulnerabilities. Consider using
61      * {ReentrancyGuard} or the
62      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
63      */
64     function sendValue(address payable recipient, uint256 amount) internal {
65         require(address(this).balance >= amount, "Address: insufficient balance");
66 
67         (bool success, ) = recipient.call{value: amount}("");
68         require(success, "Address: unable to send value, recipient may have reverted");
69     }
70 
71     /**
72      * @dev Performs a Solidity function call using a low level `call`. A
73      * plain `call` is an unsafe replacement for a function call: use this
74      * function instead.
75      *
76      * If `target` reverts with a revert reason, it is bubbled up by this
77      * function (like regular Solidity function calls).
78      *
79      * Returns the raw returned data. To convert to the expected return value,
80      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
81      *
82      * Requirements:
83      *
84      * - `target` must be a contract.
85      * - calling `target` with `data` must not revert.
86      *
87      * _Available since v3.1._
88      */
89     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
90         return functionCall(target, data, "Address: low-level call failed");
91     }
92 
93     /**
94      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
95      * `errorMessage` as a fallback revert reason when `target` reverts.
96      *
97      * _Available since v3.1._
98      */
99     function functionCall(
100         address target,
101         bytes memory data,
102         string memory errorMessage
103     ) internal returns (bytes memory) {
104         return functionCallWithValue(target, data, 0, errorMessage);
105     }
106 
107     /**
108      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
109      * but also transferring `value` wei to `target`.
110      *
111      * Requirements:
112      *
113      * - the calling contract must have an ETH balance of at least `value`.
114      * - the called Solidity function must be `payable`.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(
119         address target,
120         bytes memory data,
121         uint256 value
122     ) internal returns (bytes memory) {
123         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
124     }
125 
126     /**
127      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
128      * with `errorMessage` as a fallback revert reason when `target` reverts.
129      *
130      * _Available since v3.1._
131      */
132     function functionCallWithValue(
133         address target,
134         bytes memory data,
135         uint256 value,
136         string memory errorMessage
137     ) internal returns (bytes memory) {
138         require(address(this).balance >= value, "Address: insufficient balance for call");
139         require(isContract(target), "Address: call to non-contract");
140 
141         (bool success, bytes memory returndata) = target.call{value: value}(data);
142         return verifyCallResult(success, returndata, errorMessage);
143     }
144 
145     /**
146      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
147      * but performing a static call.
148      *
149      * _Available since v3.3._
150      */
151     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
152         return functionStaticCall(target, data, "Address: low-level static call failed");
153     }
154 
155     /**
156      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
157      * but performing a static call.
158      *
159      * _Available since v3.3._
160      */
161     function functionStaticCall(
162         address target,
163         bytes memory data,
164         string memory errorMessage
165     ) internal view returns (bytes memory) {
166         require(isContract(target), "Address: static call to non-contract");
167 
168         (bool success, bytes memory returndata) = target.staticcall(data);
169         return verifyCallResult(success, returndata, errorMessage);
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
174      * but performing a delegate call.
175      *
176      * _Available since v3.4._
177      */
178     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
179         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
184      * but performing a delegate call.
185      *
186      * _Available since v3.4._
187      */
188     function functionDelegateCall(
189         address target,
190         bytes memory data,
191         string memory errorMessage
192     ) internal returns (bytes memory) {
193         require(isContract(target), "Address: delegate call to non-contract");
194 
195         (bool success, bytes memory returndata) = target.delegatecall(data);
196         return verifyCallResult(success, returndata, errorMessage);
197     }
198 
199     /**
200      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
201      * revert reason using the provided one.
202      *
203      * _Available since v4.3._
204      */
205     function verifyCallResult(
206         bool success,
207         bytes memory returndata,
208         string memory errorMessage
209     ) internal pure returns (bytes memory) {
210         if (success) {
211             return returndata;
212         } else {
213             // Look for revert reason and bubble it up if present
214             if (returndata.length > 0) {
215                 // The easiest way to bubble the revert reason is using memory via assembly
216 
217                 assembly {
218                     let returndata_size := mload(returndata)
219                     revert(add(32, returndata), returndata_size)
220                 }
221             } else {
222                 revert(errorMessage);
223             }
224         }
225     }
226 }
227 
228 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
229 
230 
231 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
232 
233 pragma solidity ^0.8.0;
234 
235 /**
236  * @title ERC721 token receiver interface
237  * @dev Interface for any contract that wants to support safeTransfers
238  * from ERC721 asset contracts.
239  */
240 interface IERC721Receiver {
241     /**
242      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
243      * by `operator` from `from`, this function is called.
244      *
245      * It must return its Solidity selector to confirm the token transfer.
246      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
247      *
248      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
249      */
250     function onERC721Received(
251         address operator,
252         address from,
253         uint256 tokenId,
254         bytes calldata data
255     ) external returns (bytes4);
256 }
257 
258 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
259 
260 
261 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
262 
263 pragma solidity ^0.8.0;
264 
265 /**
266  * @dev Interface of the ERC165 standard, as defined in the
267  * https://eips.ethereum.org/EIPS/eip-165[EIP].
268  *
269  * Implementers can declare support of contract interfaces, which can then be
270  * queried by others ({ERC165Checker}).
271  *
272  * For an implementation, see {ERC165}.
273  */
274 interface IERC165 {
275     /**
276      * @dev Returns true if this contract implements the interface defined by
277      * `interfaceId`. See the corresponding
278      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
279      * to learn more about how these ids are created.
280      *
281      * This function call must use less than 30 000 gas.
282      */
283     function supportsInterface(bytes4 interfaceId) external view returns (bool);
284 }
285 
286 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
287 
288 
289 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
290 
291 pragma solidity ^0.8.0;
292 
293 
294 /**
295  * @dev Implementation of the {IERC165} interface.
296  *
297  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
298  * for the additional interface id that will be supported. For example:
299  *
300  * ```solidity
301  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
302  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
303  * }
304  * ```
305  *
306  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
307  */
308 abstract contract ERC165 is IERC165 {
309     /**
310      * @dev See {IERC165-supportsInterface}.
311      */
312     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
313         return interfaceId == type(IERC165).interfaceId;
314     }
315 }
316 
317 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
318 
319 
320 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
321 
322 pragma solidity ^0.8.0;
323 
324 
325 /**
326  * @dev Required interface of an ERC721 compliant contract.
327  */
328 interface IERC721 is IERC165 {
329     /**
330      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
331      */
332     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
333 
334     /**
335      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
336      */
337     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
338 
339     /**
340      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
341      */
342     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
343 
344     /**
345      * @dev Returns the number of tokens in ``owner``'s account.
346      */
347     function balanceOf(address owner) external view returns (uint256 balance);
348 
349     /**
350      * @dev Returns the owner of the `tokenId` token.
351      *
352      * Requirements:
353      *
354      * - `tokenId` must exist.
355      */
356     function ownerOf(uint256 tokenId) external view returns (address owner);
357 
358     /**
359      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
360      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
361      *
362      * Requirements:
363      *
364      * - `from` cannot be the zero address.
365      * - `to` cannot be the zero address.
366      * - `tokenId` token must exist and be owned by `from`.
367      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
368      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
369      *
370      * Emits a {Transfer} event.
371      */
372     function safeTransferFrom(
373         address from,
374         address to,
375         uint256 tokenId
376     ) external;
377 
378     /**
379      * @dev Transfers `tokenId` token from `from` to `to`.
380      *
381      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
382      *
383      * Requirements:
384      *
385      * - `from` cannot be the zero address.
386      * - `to` cannot be the zero address.
387      * - `tokenId` token must be owned by `from`.
388      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
389      *
390      * Emits a {Transfer} event.
391      */
392     function transferFrom(
393         address from,
394         address to,
395         uint256 tokenId
396     ) external;
397 
398     /**
399      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
400      * The approval is cleared when the token is transferred.
401      *
402      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
403      *
404      * Requirements:
405      *
406      * - The caller must own the token or be an approved operator.
407      * - `tokenId` must exist.
408      *
409      * Emits an {Approval} event.
410      */
411     function approve(address to, uint256 tokenId) external;
412 
413     /**
414      * @dev Returns the account approved for `tokenId` token.
415      *
416      * Requirements:
417      *
418      * - `tokenId` must exist.
419      */
420     function getApproved(uint256 tokenId) external view returns (address operator);
421 
422     /**
423      * @dev Approve or remove `operator` as an operator for the caller.
424      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
425      *
426      * Requirements:
427      *
428      * - The `operator` cannot be the caller.
429      *
430      * Emits an {ApprovalForAll} event.
431      */
432     function setApprovalForAll(address operator, bool _approved) external;
433 
434     /**
435      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
436      *
437      * See {setApprovalForAll}
438      */
439     function isApprovedForAll(address owner, address operator) external view returns (bool);
440 
441     /**
442      * @dev Safely transfers `tokenId` token from `from` to `to`.
443      *
444      * Requirements:
445      *
446      * - `from` cannot be the zero address.
447      * - `to` cannot be the zero address.
448      * - `tokenId` token must exist and be owned by `from`.
449      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
450      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
451      *
452      * Emits a {Transfer} event.
453      */
454     function safeTransferFrom(
455         address from,
456         address to,
457         uint256 tokenId,
458         bytes calldata data
459     ) external;
460 }
461 
462 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
463 
464 
465 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
466 
467 pragma solidity ^0.8.0;
468 
469 
470 /**
471  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
472  * @dev See https://eips.ethereum.org/EIPS/eip-721
473  */
474 interface IERC721Enumerable is IERC721 {
475     /**
476      * @dev Returns the total amount of tokens stored by the contract.
477      */
478     function totalSupply() external view returns (uint256);
479 
480     /**
481      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
482      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
483      */
484     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
485 
486     /**
487      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
488      * Use along with {totalSupply} to enumerate all tokens.
489      */
490     function tokenByIndex(uint256 index) external view returns (uint256);
491 }
492 
493 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
494 
495 
496 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
497 
498 pragma solidity ^0.8.0;
499 
500 
501 /**
502  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
503  * @dev See https://eips.ethereum.org/EIPS/eip-721
504  */
505 interface IERC721Metadata is IERC721 {
506     /**
507      * @dev Returns the token collection name.
508      */
509     function name() external view returns (string memory);
510 
511     /**
512      * @dev Returns the token collection symbol.
513      */
514     function symbol() external view returns (string memory);
515 
516     /**
517      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
518      */
519     function tokenURI(uint256 tokenId) external view returns (string memory);
520 }
521 
522 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
523 
524 
525 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
526 
527 pragma solidity ^0.8.0;
528 
529 /**
530  * @dev These functions deal with verification of Merkle Trees proofs.
531  *
532  * The proofs can be generated using the JavaScript library
533  * https://github.com/miguelmota/merkletreejs[merkletreejs].
534  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
535  *
536  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
537  */
538 library MerkleProof {
539     /**
540      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
541      * defined by `root`. For this, a `proof` must be provided, containing
542      * sibling hashes on the branch from the leaf to the root of the tree. Each
543      * pair of leaves and each pair of pre-images are assumed to be sorted.
544      */
545     function verify(
546         bytes32[] memory proof,
547         bytes32 root,
548         bytes32 leaf
549     ) internal pure returns (bool) {
550         return processProof(proof, leaf) == root;
551     }
552 
553     /**
554      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
555      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
556      * hash matches the root of the tree. When processing the proof, the pairs
557      * of leafs & pre-images are assumed to be sorted.
558      *
559      * _Available since v4.4._
560      */
561     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
562         bytes32 computedHash = leaf;
563         for (uint256 i = 0; i < proof.length; i++) {
564             bytes32 proofElement = proof[i];
565             if (computedHash <= proofElement) {
566                 // Hash(current computed hash + current element of the proof)
567                 computedHash = _efficientHash(computedHash, proofElement);
568             } else {
569                 // Hash(current element of the proof + current computed hash)
570                 computedHash = _efficientHash(proofElement, computedHash);
571             }
572         }
573         return computedHash;
574     }
575 
576     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
577         assembly {
578             mstore(0x00, a)
579             mstore(0x20, b)
580             value := keccak256(0x00, 0x40)
581         }
582     }
583 }
584 
585 // File: @openzeppelin/contracts/utils/Strings.sol
586 
587 
588 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
589 
590 pragma solidity ^0.8.0;
591 
592 /**
593  * @dev String operations.
594  */
595 library Strings {
596     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
597 
598     /**
599      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
600      */
601     function toString(uint256 value) internal pure returns (string memory) {
602         // Inspired by OraclizeAPI's implementation - MIT licence
603         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
604 
605         if (value == 0) {
606             return "0";
607         }
608         uint256 temp = value;
609         uint256 digits;
610         while (temp != 0) {
611             digits++;
612             temp /= 10;
613         }
614         bytes memory buffer = new bytes(digits);
615         while (value != 0) {
616             digits -= 1;
617             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
618             value /= 10;
619         }
620         return string(buffer);
621     }
622 
623     /**
624      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
625      */
626     function toHexString(uint256 value) internal pure returns (string memory) {
627         if (value == 0) {
628             return "0x00";
629         }
630         uint256 temp = value;
631         uint256 length = 0;
632         while (temp != 0) {
633             length++;
634             temp >>= 8;
635         }
636         return toHexString(value, length);
637     }
638 
639     /**
640      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
641      */
642     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
643         bytes memory buffer = new bytes(2 * length + 2);
644         buffer[0] = "0";
645         buffer[1] = "x";
646         for (uint256 i = 2 * length + 1; i > 1; --i) {
647             buffer[i] = _HEX_SYMBOLS[value & 0xf];
648             value >>= 4;
649         }
650         require(value == 0, "Strings: hex length insufficient");
651         return string(buffer);
652     }
653 }
654 
655 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
656 
657 
658 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
659 
660 pragma solidity ^0.8.0;
661 
662 /**
663  * @dev Contract module that helps prevent reentrant calls to a function.
664  *
665  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
666  * available, which can be applied to functions to make sure there are no nested
667  * (reentrant) calls to them.
668  *
669  * Note that because there is a single `nonReentrant` guard, functions marked as
670  * `nonReentrant` may not call one another. This can be worked around by making
671  * those functions `private`, and then adding `external` `nonReentrant` entry
672  * points to them.
673  *
674  * TIP: If you would like to learn more about reentrancy and alternative ways
675  * to protect against it, check out our blog post
676  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
677  */
678 abstract contract ReentrancyGuard {
679     // Booleans are more expensive than uint256 or any type that takes up a full
680     // word because each write operation emits an extra SLOAD to first read the
681     // slot's contents, replace the bits taken up by the boolean, and then write
682     // back. This is the compiler's defense against contract upgrades and
683     // pointer aliasing, and it cannot be disabled.
684 
685     // The values being non-zero value makes deployment a bit more expensive,
686     // but in exchange the refund on every call to nonReentrant will be lower in
687     // amount. Since refunds are capped to a percentage of the total
688     // transaction's gas, it is best to keep them low in cases like this one, to
689     // increase the likelihood of the full refund coming into effect.
690     uint256 private constant _NOT_ENTERED = 1;
691     uint256 private constant _ENTERED = 2;
692 
693     uint256 private _status;
694 
695     constructor() {
696         _status = _NOT_ENTERED;
697     }
698 
699     /**
700      * @dev Prevents a contract from calling itself, directly or indirectly.
701      * Calling a `nonReentrant` function from another `nonReentrant`
702      * function is not supported. It is possible to prevent this from happening
703      * by making the `nonReentrant` function external, and making it call a
704      * `private` function that does the actual work.
705      */
706     modifier nonReentrant() {
707         // On the first call to nonReentrant, _notEntered will be true
708         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
709 
710         // Any calls to nonReentrant after this point will fail
711         _status = _ENTERED;
712 
713         _;
714 
715         // By storing the original value once again, a refund is triggered (see
716         // https://eips.ethereum.org/EIPS/eip-2200)
717         _status = _NOT_ENTERED;
718     }
719 }
720 
721 // File: @openzeppelin/contracts/utils/Context.sol
722 
723 
724 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
725 
726 pragma solidity ^0.8.0;
727 
728 /**
729  * @dev Provides information about the current execution context, including the
730  * sender of the transaction and its data. While these are generally available
731  * via msg.sender and msg.data, they should not be accessed in such a direct
732  * manner, since when dealing with meta-transactions the account sending and
733  * paying for execution may not be the actual sender (as far as an application
734  * is concerned).
735  *
736  * This contract is only required for intermediate, library-like contracts.
737  */
738 abstract contract Context {
739     function _msgSender() internal view virtual returns (address) {
740         return msg.sender;
741     }
742 
743     function _msgData() internal view virtual returns (bytes calldata) {
744         return msg.data;
745     }
746 }
747 
748 // File: @openzeppelin/contracts/access/Ownable.sol
749 
750 
751 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
752 
753 pragma solidity ^0.8.0;
754 
755 
756 /**
757  * @dev Contract module which provides a basic access control mechanism, where
758  * there is an account (an owner) that can be granted exclusive access to
759  * specific functions.
760  *
761  * By default, the owner account will be the one that deploys the contract. This
762  * can later be changed with {transferOwnership}.
763  *
764  * This module is used through inheritance. It will make available the modifier
765  * `onlyOwner`, which can be applied to your functions to restrict their use to
766  * the owner.
767  */
768 abstract contract Ownable is Context {
769     address private _owner;
770 
771     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
772 
773     /**
774      * @dev Initializes the contract setting the deployer as the initial owner.
775      */
776     constructor() {
777         _transferOwnership(_msgSender());
778     }
779 
780     /**
781      * @dev Returns the address of the current owner.
782      */
783     function owner() public view virtual returns (address) {
784         return _owner;
785     }
786 
787     /**
788      * @dev Throws if called by any account other than the owner.
789      */
790     modifier onlyOwner() {
791         require(owner() == _msgSender(), "Ownable: caller is not the owner");
792         _;
793     }
794 
795     /**
796      * @dev Leaves the contract without owner. It will not be possible to call
797      * `onlyOwner` functions anymore. Can only be called by the current owner.
798      *
799      * NOTE: Renouncing ownership will leave the contract without an owner,
800      * thereby removing any functionality that is only available to the owner.
801      */
802     function renounceOwnership() public virtual onlyOwner {
803         _transferOwnership(address(0));
804     }
805 
806     /**
807      * @dev Transfers ownership of the contract to a new account (`newOwner`).
808      * Can only be called by the current owner.
809      */
810     function transferOwnership(address newOwner) public virtual onlyOwner {
811         require(newOwner != address(0), "Ownable: new owner is the zero address");
812         _transferOwnership(newOwner);
813     }
814 
815     /**
816      * @dev Transfers ownership of the contract to a new account (`newOwner`).
817      * Internal function without access restriction.
818      */
819     function _transferOwnership(address newOwner) internal virtual {
820         address oldOwner = _owner;
821         _owner = newOwner;
822         emit OwnershipTransferred(oldOwner, newOwner);
823     }
824 }
825 
826 // File: contracts/ERC721A.sol
827 
828 
829 
830 pragma solidity ^0.8.0;
831 
832 
833 
834 
835 
836 
837 
838 
839 
840 
841 /**
842  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
843  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
844  *
845  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
846  *
847  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
848  *
849  * Does not support burning tokens to address(0).
850  */
851 contract ERC721A is
852   Context,
853   ERC165,
854   IERC721,
855   IERC721Metadata,
856   IERC721Enumerable,
857   Ownable
858 {
859   using Address for address;
860   using Strings for uint256;
861 
862   struct TokenOwnership {
863     address addr;
864     uint64 startTimestamp;
865   }
866 
867   struct AddressData {
868     uint128 balance;
869     uint128 numberMinted;
870   }
871 
872   uint256 private currentIndex = 0;
873 
874   uint256 internal immutable collectionSize;
875   uint256 internal immutable maxBatchSize;
876 
877   // Token name
878   string private _name;
879 
880   // Token symbol
881   string private _symbol;
882 
883   // Mapping from token ID to ownership details
884   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
885   mapping(uint256 => TokenOwnership) private _ownerships;
886 
887   // Mapping owner address to address data
888   mapping(address => AddressData) private _addressData;
889 
890   // Mapping from token ID to approved address
891   mapping(uint256 => address) private _tokenApprovals;
892 
893   // Mapping from owner to operator approvals
894   mapping(address => mapping(address => bool)) private _operatorApprovals;
895 
896   // Revealed
897   bool private revealed;
898   string public notRevealedUri;
899 
900   /**
901    * @dev
902    * `maxBatchSize` refers to how much a minter can mint at a time.
903    * `collectionSize_` refers to how many tokens are in the collection.
904    */
905   constructor(
906     string memory name_,
907     string memory symbol_,
908     uint256 maxBatchSize_,
909     uint256 collectionSize_,
910     string memory notRevealedUri_
911   ) {
912     require(
913       collectionSize_ > 0,
914       "ERC721A: collection must have a nonzero supply"
915     );
916     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
917     _name = name_;
918     _symbol = symbol_;
919     maxBatchSize = maxBatchSize_;
920     collectionSize = collectionSize_;
921     revealed = false;
922     notRevealedUri = notRevealedUri_;
923   }
924 
925   /**
926    * @dev See {IERC721Enumerable-totalSupply}.
927    */
928   function totalSupply() public view override returns (uint256) {
929     return currentIndex;
930   }
931 
932   /**
933    * @dev See {IERC721Enumerable-tokenByIndex}.
934    */
935   function tokenByIndex(uint256 index) public view override returns (uint256) {
936     require(index < totalSupply(), "ERC721A: global index out of bounds");
937     return index;
938   }
939 
940   /**
941    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
942    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
943    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
944    */
945   function tokenOfOwnerByIndex(address owner, uint256 index)
946     public
947     view
948     override
949     returns (uint256)
950   {
951     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
952     uint256 numMintedSoFar = totalSupply();
953     uint256 tokenIdsIdx = 0;
954     address currOwnershipAddr = address(0);
955     for (uint256 i = 0; i < numMintedSoFar; i++) {
956       TokenOwnership memory ownership = _ownerships[i];
957       if (ownership.addr != address(0)) {
958         currOwnershipAddr = ownership.addr;
959       }
960       if (currOwnershipAddr == owner) {
961         if (tokenIdsIdx == index) {
962           return i;
963         }
964         tokenIdsIdx++;
965       }
966     }
967     revert("ERC721A: unable to get token of owner by index");
968   }
969 
970   /**
971    * @dev See {IERC165-supportsInterface}.
972    */
973   function supportsInterface(bytes4 interfaceId)
974     public
975     view
976     virtual
977     override(ERC165, IERC165)
978     returns (bool)
979   {
980     return
981       interfaceId == type(IERC721).interfaceId ||
982       interfaceId == type(IERC721Metadata).interfaceId ||
983       interfaceId == type(IERC721Enumerable).interfaceId ||
984       super.supportsInterface(interfaceId);
985   }
986 
987   /**
988    * @dev See {IERC721-balanceOf}.
989    */
990   function balanceOf(address owner) public view override returns (uint256) {
991     require(owner != address(0), "ERC721A: balance query for the zero address");
992     return uint256(_addressData[owner].balance);
993   }
994 
995   function _numberMinted(address owner) internal view returns (uint256) {
996     require(
997       owner != address(0),
998       "ERC721A: number minted query for the zero address"
999     );
1000     return uint256(_addressData[owner].numberMinted);
1001   }
1002 
1003   function ownershipOf(uint256 tokenId)
1004     internal
1005     view
1006     returns (TokenOwnership memory)
1007   {
1008     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1009 
1010     uint256 lowestTokenToCheck;
1011     if (tokenId >= maxBatchSize) {
1012       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1013     }
1014 
1015     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1016       TokenOwnership memory ownership = _ownerships[curr];
1017       if (ownership.addr != address(0)) {
1018         return ownership;
1019       }
1020     }
1021 
1022     revert("ERC721A: unable to determine the owner of token");
1023   }
1024 
1025   /**
1026    * @dev See {IERC721-ownerOf}.
1027    */
1028   function ownerOf(uint256 tokenId) public view override returns (address) {
1029     return ownershipOf(tokenId).addr;
1030   }
1031 
1032   /**
1033    * @dev See {IERC721Metadata-name}.
1034    */
1035   function name() public view virtual override returns (string memory) {
1036     return _name;
1037   }
1038 
1039   /**
1040    * @dev See {IERC721Metadata-symbol}.
1041    */
1042   function symbol() public view virtual override returns (string memory) {
1043     return _symbol;
1044   }
1045 
1046   /**
1047    * @dev See {IERC721Metadata-tokenURI}.
1048    */
1049   function tokenURI(uint256 tokenId)
1050     public
1051     view
1052     virtual
1053     override
1054     returns (string memory)
1055   {
1056     require(
1057       _exists(tokenId),
1058       "ERC721Metadata: URI query for nonexistent token"
1059     );
1060 
1061     if(revealed == false) return notRevealedUri;
1062 
1063     string memory baseURI = _baseURI();
1064     return
1065       bytes(baseURI).length > 0
1066         ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
1067         : "";
1068   }
1069 
1070   function reveal() public onlyOwner {
1071     revealed = true;
1072   }
1073 
1074   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1075     notRevealedUri = _notRevealedURI;
1076   }
1077 
1078 
1079   /**
1080    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1081    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1082    * by default, can be overriden in child contracts.
1083    */
1084   function _baseURI() internal view virtual returns (string memory) {
1085     return "";
1086   }
1087 
1088   /**
1089    * @dev See {IERC721-approve}.
1090    */
1091   function approve(address to, uint256 tokenId) public override {
1092     address owner = ERC721A.ownerOf(tokenId);
1093     require(to != owner, "ERC721A: approval to current owner");
1094 
1095     require(
1096       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1097       "ERC721A: approve caller is not owner nor approved for all"
1098     );
1099 
1100     _approve(to, tokenId, owner);
1101   }
1102 
1103   /**
1104    * @dev See {IERC721-getApproved}.
1105    */
1106   function getApproved(uint256 tokenId) public view override returns (address) {
1107     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1108 
1109     return _tokenApprovals[tokenId];
1110   }
1111 
1112   /**
1113    * @dev See {IERC721-setApprovalForAll}.
1114    */
1115   function setApprovalForAll(address operator, bool approved) public override {
1116     require(operator != _msgSender(), "ERC721A: approve to caller");
1117 
1118     _operatorApprovals[_msgSender()][operator] = approved;
1119     emit ApprovalForAll(_msgSender(), operator, approved);
1120   }
1121 
1122   /**
1123    * @dev See {IERC721-isApprovedForAll}.
1124    */
1125   function isApprovedForAll(address owner, address operator)
1126     public
1127     view
1128     virtual
1129     override
1130     returns (bool)
1131   {
1132     return _operatorApprovals[owner][operator];
1133   }
1134 
1135   /**
1136    * @dev See {IERC721-transferFrom}.
1137    */
1138   function transferFrom(
1139     address from,
1140     address to,
1141     uint256 tokenId
1142   ) public override {
1143     _transfer(from, to, tokenId);
1144   }
1145 
1146   /**
1147    * @dev See {IERC721-safeTransferFrom}.
1148    */
1149   function safeTransferFrom(
1150     address from,
1151     address to,
1152     uint256 tokenId
1153   ) public override {
1154     safeTransferFrom(from, to, tokenId, "");
1155   }
1156 
1157   /**
1158    * @dev See {IERC721-safeTransferFrom}.
1159    */
1160   function safeTransferFrom(
1161     address from,
1162     address to,
1163     uint256 tokenId,
1164     bytes memory _data
1165   ) public override {
1166     _transfer(from, to, tokenId);
1167     require(
1168       _checkOnERC721Received(from, to, tokenId, _data),
1169       "ERC721A: transfer to non ERC721Receiver implementer"
1170     );
1171   }
1172 
1173   /**
1174    * @dev Returns whether `tokenId` exists.
1175    *
1176    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1177    *
1178    * Tokens start existing when they are minted (`_mint`),
1179    */
1180   function _exists(uint256 tokenId) internal view returns (bool) {
1181     return tokenId < currentIndex;
1182   }
1183 
1184   function _safeMint(address to, uint256 quantity) internal {
1185     _safeMint(to, quantity, "");
1186   }
1187 
1188   /**
1189    * @dev Mints `quantity` tokens and transfers them to `to`.
1190    *
1191    * Requirements:
1192    *
1193    * - there must be `quantity` tokens remaining unminted in the total collection.
1194    * - `to` cannot be the zero address.
1195    * - `quantity` cannot be larger than the max batch size.
1196    *
1197    * Emits a {Transfer} event.
1198    */
1199   function _safeMint(
1200     address to,
1201     uint256 quantity,
1202     bytes memory _data
1203   ) internal {
1204     uint256 startTokenId = currentIndex;
1205     require(to != address(0), "ERC721A: mint to the zero address");
1206     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1207     require(!_exists(startTokenId), "ERC721A: token already minted");
1208     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1209 
1210     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1211 
1212     AddressData memory addressData = _addressData[to];
1213     _addressData[to] = AddressData(
1214       addressData.balance + uint128(quantity),
1215       addressData.numberMinted + uint128(quantity)
1216     );
1217     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1218 
1219     uint256 updatedIndex = startTokenId;
1220 
1221     for (uint256 i = 0; i < quantity; i++) {
1222       emit Transfer(address(0), to, updatedIndex);
1223       require(
1224         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1225         "ERC721A: transfer to non ERC721Receiver implementer"
1226       );
1227       updatedIndex++;
1228     }
1229 
1230     currentIndex = updatedIndex;
1231     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1232   }
1233 
1234   /**
1235    * @dev Transfers `tokenId` from `from` to `to`.
1236    *
1237    * Requirements:
1238    *
1239    * - `to` cannot be the zero address.
1240    * - `tokenId` token must be owned by `from`.
1241    *
1242    * Emits a {Transfer} event.
1243    */
1244   function _transfer(
1245     address from,
1246     address to,
1247     uint256 tokenId
1248   ) private {
1249     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1250 
1251     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1252       getApproved(tokenId) == _msgSender() ||
1253       isApprovedForAll(prevOwnership.addr, _msgSender()));
1254 
1255     require(
1256       isApprovedOrOwner,
1257       "ERC721A: transfer caller is not owner nor approved"
1258     );
1259 
1260     require(
1261       prevOwnership.addr == from,
1262       "ERC721A: transfer from incorrect owner"
1263     );
1264     require(to != address(0), "ERC721A: transfer to the zero address");
1265 
1266     _beforeTokenTransfers(from, to, tokenId, 1);
1267 
1268     // Clear approvals from the previous owner
1269     _approve(address(0), tokenId, prevOwnership.addr);
1270 
1271     _addressData[from].balance -= 1;
1272     _addressData[to].balance += 1;
1273     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1274 
1275     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1276     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1277     uint256 nextTokenId = tokenId + 1;
1278     if (_ownerships[nextTokenId].addr == address(0)) {
1279       if (_exists(nextTokenId)) {
1280         _ownerships[nextTokenId] = TokenOwnership(
1281           prevOwnership.addr,
1282           prevOwnership.startTimestamp
1283         );
1284       }
1285     }
1286 
1287     emit Transfer(from, to, tokenId);
1288     _afterTokenTransfers(from, to, tokenId, 1);
1289   }
1290 
1291   /**
1292    * @dev Approve `to` to operate on `tokenId`
1293    *
1294    * Emits a {Approval} event.
1295    */
1296   function _approve(
1297     address to,
1298     uint256 tokenId,
1299     address owner
1300   ) private {
1301     _tokenApprovals[tokenId] = to;
1302     emit Approval(owner, to, tokenId);
1303   }
1304 
1305   uint256 public nextOwnerToExplicitlySet = 0;
1306 
1307   /**
1308    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1309    */
1310   function _setOwnersExplicit(uint256 quantity) internal {
1311     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1312     require(quantity > 0, "quantity must be nonzero");
1313     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1314     if (endIndex > collectionSize - 1) {
1315       endIndex = collectionSize - 1;
1316     }
1317     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1318     require(_exists(endIndex), "not enough minted yet for this cleanup");
1319     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1320       if (_ownerships[i].addr == address(0)) {
1321         TokenOwnership memory ownership = ownershipOf(i);
1322         _ownerships[i] = TokenOwnership(
1323           ownership.addr,
1324           ownership.startTimestamp
1325         );
1326       }
1327     }
1328     nextOwnerToExplicitlySet = endIndex + 1;
1329   }
1330 
1331   /**
1332    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1333    * The call is not executed if the target address is not a contract.
1334    *
1335    * @param from address representing the previous owner of the given token ID
1336    * @param to target address that will receive the tokens
1337    * @param tokenId uint256 ID of the token to be transferred
1338    * @param _data bytes optional data to send along with the call
1339    * @return bool whether the call correctly returned the expected magic value
1340    */
1341   function _checkOnERC721Received(
1342     address from,
1343     address to,
1344     uint256 tokenId,
1345     bytes memory _data
1346   ) private returns (bool) {
1347     if (to.isContract()) {
1348       try
1349         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1350       returns (bytes4 retval) {
1351         return retval == IERC721Receiver(to).onERC721Received.selector;
1352       } catch (bytes memory reason) {
1353         if (reason.length == 0) {
1354           revert("ERC721A: transfer to non ERC721Receiver implementer");
1355         } else {
1356           assembly {
1357             revert(add(32, reason), mload(reason))
1358           }
1359         }
1360       }
1361     } else {
1362       return true;
1363     }
1364   }
1365 
1366   /**
1367    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1368    *
1369    * startTokenId - the first token id to be transferred
1370    * quantity - the amount to be transferred
1371    *
1372    * Calling conditions:
1373    *
1374    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1375    * transferred to `to`.
1376    * - When `from` is zero, `tokenId` will be minted for `to`.
1377    */
1378   function _beforeTokenTransfers(
1379     address from,
1380     address to,
1381     uint256 startTokenId,
1382     uint256 quantity
1383   ) internal virtual {}
1384 
1385   /**
1386    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1387    * minting.
1388    *
1389    * startTokenId - the first token id to be transferred
1390    * quantity - the amount to be transferred
1391    *
1392    * Calling conditions:
1393    *
1394    * - when `from` and `to` are both non-zero.
1395    * - `from` and `to` are never both zero.
1396    */
1397   function _afterTokenTransfers(
1398     address from,
1399     address to,
1400     uint256 startTokenId,
1401     uint256 quantity
1402   ) internal virtual {}
1403 }
1404 // File: contracts/Mutts.sol
1405 
1406 
1407 
1408 pragma solidity ^0.8.0;
1409 
1410 
1411 
1412 
1413 
1414 
1415 //   /$$$$$$ /$$$$$$$   /$$$$$$  /$$   /$$  /$$$$$$  /$$$$$$ /$$$$$$$  /$$$$$$$$
1416 //  |_  $$_/| $$__  $$ /$$__  $$| $$$ | $$ /$$__  $$|_  $$_/| $$__  $$| $$_____/
1417 //    | $$  | $$  \ $$| $$  \ $$| $$$$| $$| $$  \__/  | $$  | $$  \ $$| $$      
1418 //    | $$  | $$$$$$$/| $$  | $$| $$ $$ $$|  $$$$$$   | $$  | $$  | $$| $$$$$   
1419 //    | $$  | $$__  $$| $$  | $$| $$  $$$$ \____  $$  | $$  | $$  | $$| $$__/   
1420 //    | $$  | $$  \ $$| $$  | $$| $$\  $$$ /$$  \ $$  | $$  | $$  | $$| $$      
1421 //   /$$$$$$| $$  | $$|  $$$$$$/| $$ \  $$|  $$$$$$/ /$$$$$$| $$$$$$$/| $$$$$$$$
1422 //  |______/|__/  |__/ \______/ |__/  \__/ \______/ |______/|_______/ |________/
1423 
1424 contract Mutts is ERC721A, ReentrancyGuard {
1425   uint256 public reservedSpent;
1426   uint256 public immutable amountReserved;
1427   uint256 public immutable publicTxLimit;
1428 
1429   bytes32 public ogMerkleRoot;
1430   bytes32 public whitelistMerkleRoot;
1431 
1432   struct SaleConfigData {
1433     uint8  ogMintLimit;
1434     uint8  whitelistMintLimit;
1435     uint32 ogSaleStartTime;
1436     uint32 whitelistSaleStartTime;
1437     uint32 publicSaleStartTime;
1438     uint64 presalePrice;
1439     uint64 publicPrice;
1440   }
1441 
1442   SaleConfigData public saleConfig;
1443 
1444   constructor(
1445     uint256 maxBatchSize_, // max amount to mint in one transaction
1446     uint256 collectionSize_, 
1447     uint256 amountReserved_,
1448     bytes32 ogMerkleRoot_,
1449     bytes32 whitelistMerkleRoot_,
1450     string memory notRevealedUri_
1451   ) ERC721A("Mutts", "MUTT", maxBatchSize_, collectionSize_, notRevealedUri_) {
1452     reservedSpent = 0;
1453     amountReserved = amountReserved_;
1454     publicTxLimit = maxBatchSize_;
1455     saleConfig = SaleConfigData(
1456       3, // ogMintLimit
1457       2, // whitelistMintLimit
1458       1647360000, // ogSaleStartTime - March 15th @ 11am EST
1459       1647367200, // whitelistSaleStartTime - March 15th @ 1pm EST
1460       1647453600, // publicSaleStartTime - March 16th @ 1pm EST
1461       0.07 ether, // presalePrice
1462       0.1 ether   // publicPrice,
1463     );
1464 
1465     ogMerkleRoot = ogMerkleRoot_;
1466     whitelistMerkleRoot = whitelistMerkleRoot_;
1467   }
1468 
1469 
1470 
1471   // ~~~ Modifiers Start ~~~
1472   modifier callerIsUser() {
1473     require(tx.origin == msg.sender, "The caller is another contract");
1474     _;
1475   }
1476 
1477   modifier checkPrice(uint64 price, uint8 quantity) {
1478     require(
1479         msg.value >= price * quantity,
1480         "checkPrice: not enough ether for this amount"
1481     );
1482     _;
1483   }
1484 
1485   modifier checkAlreadyMinted(uint8 limit, uint8 quantity) {
1486     require(
1487       numberMinted(msg.sender) + quantity <= limit,
1488       "checkAlreadyMinted: cannot mint this many"
1489     );
1490     _;
1491   }
1492 
1493   modifier checkWhitelist(bytes32[] calldata merkleProof, bytes32 merkleRoot) {
1494     require(
1495       MerkleProof.verify(merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), 
1496       "checkWhitelist: You are not whitelisted"
1497     );
1498     _;
1499   }
1500   // ~~~ Modifiers End ~~~
1501 
1502 
1503 
1504 
1505   // ~~~ Mint Start ~~~
1506   function ogMint(uint8 quantity, bytes32[] calldata merkleProof) 
1507     external 
1508     payable 
1509     callerIsUser 
1510     checkWhitelist(merkleProof, ogMerkleRoot)
1511     checkPrice(saleConfig.presalePrice, quantity)
1512     checkAlreadyMinted(saleConfig.ogMintLimit, quantity)
1513   {
1514     require(
1515       block.timestamp >= saleConfig.ogSaleStartTime && block.timestamp <= saleConfig.publicSaleStartTime,
1516       "ogMint: sale has either ended or not started yet"
1517     );
1518     _safeMint(msg.sender, quantity);
1519     refundIfOver(saleConfig.presalePrice * quantity);
1520   }
1521 
1522   function whitelistMint(uint8 quantity, bytes32[] calldata merkleProof) 
1523     external 
1524     payable 
1525     callerIsUser 
1526     checkWhitelist(merkleProof, whitelistMerkleRoot)
1527     checkPrice(saleConfig.presalePrice, quantity)
1528     checkAlreadyMinted(saleConfig.whitelistMintLimit, quantity)
1529   {
1530     require(
1531       block.timestamp >= saleConfig.whitelistSaleStartTime && block.timestamp <= saleConfig.publicSaleStartTime,
1532       "whitelistMint: sale has either ended or not started yet"
1533     );
1534     _safeMint(msg.sender, quantity);
1535     refundIfOver(saleConfig.presalePrice);
1536   }
1537 
1538   function publicMint(uint8 quantity) 
1539     external 
1540     payable 
1541     callerIsUser 
1542     checkPrice(saleConfig.publicPrice, quantity)
1543   {
1544     require(
1545         saleConfig.publicSaleStartTime != 0 && block.timestamp >= saleConfig.publicSaleStartTime,
1546         "publicMint: public sale has not begun yet"
1547     );
1548     require(
1549         quantity <= publicTxLimit,
1550         "publicMint: can not mint this many in one transaction"
1551     );
1552     require(
1553         totalSupply() + quantity <= collectionSize, 
1554         "publicMint: reached max supply"
1555     );
1556     _safeMint(msg.sender, quantity);
1557     refundIfOver(saleConfig.publicPrice * quantity);
1558   }
1559 
1560   function reservedMint(uint256 quantity) external onlyOwner {
1561     require(
1562       totalSupply() + quantity <= collectionSize && reservedSpent + quantity <= amountReserved,
1563       "reservedMint: too many already minted"
1564     );
1565 
1566     uint256 numChunks = quantity / maxBatchSize;
1567     for (uint256 i = 0; i < numChunks; i++) {
1568       _safeMint(msg.sender, maxBatchSize);
1569     }
1570 
1571     uint256 remainder = quantity % maxBatchSize;
1572     _safeMint(msg.sender, remainder);
1573 
1574     reservedSpent += quantity;
1575   }
1576   // ~~~ Mint End ~~~
1577 
1578 
1579 
1580   // ~~~ Utils Start ~~~
1581   function refundIfOver(uint256 price) private {
1582     require(msg.value >= price, "Need to send more ETH.");
1583     if (msg.value > price) {
1584       payable(msg.sender).transfer(msg.value - price);
1585     }
1586   }
1587 
1588   function withdrawMoney() external onlyOwner nonReentrant {
1589     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1590     require(success, "withdrawMoney: Transfer failed.");
1591   }
1592 
1593   function numberMinted(address owner) public view returns (uint256) {
1594     return _numberMinted(owner);
1595   }
1596 
1597   function getOwnershipData(uint256 tokenId)
1598     external
1599     view
1600     returns (TokenOwnership memory)
1601   {
1602     return ownershipOf(tokenId);
1603   }
1604 
1605   // metadata URI
1606   string private _baseTokenURI;
1607 
1608   function _baseURI() internal view virtual override returns (string memory) {
1609     return _baseTokenURI;
1610   }
1611   // ~~~ Utils End ~~~
1612 
1613 
1614 
1615 
1616   // ~~~ Setters Start ~~~
1617   function setBaseURI(string calldata baseURI) external onlyOwner {
1618     _baseTokenURI = baseURI;
1619   }
1620 
1621   function setOgMerkleRoot(bytes32 ogMerkleRoot_) external onlyOwner {
1622     ogMerkleRoot = ogMerkleRoot_;
1623   }
1624 
1625   function setWhitelistMerkleRoot(bytes32 whitelistMerkleRoot_) external onlyOwner {
1626     whitelistMerkleRoot = whitelistMerkleRoot_;
1627   }
1628 
1629   function setOgMintLimit(uint8 ogMintLimit_) external onlyOwner {
1630     saleConfig.ogMintLimit = ogMintLimit_;
1631   }
1632 
1633   function setWhitelistMerkleRoot(uint8 whitelistMintLimit_) external onlyOwner {
1634     saleConfig.whitelistMintLimit = whitelistMintLimit_;
1635   }
1636 
1637   function setSaleTimes(uint32 ogSaleStartTime_, uint32 whitelistSaleStartTime_, uint32 publicSaleStartTime_) external onlyOwner{
1638     if (ogSaleStartTime_ != 0) {
1639         saleConfig.ogSaleStartTime = ogSaleStartTime_;
1640     }
1641     if (whitelistSaleStartTime_ != 0) {
1642         require(whitelistSaleStartTime_ > saleConfig.ogSaleStartTime, "setSaleTimes: whitelist sale start time cannot be before OG sale start time");
1643         saleConfig.whitelistSaleStartTime = whitelistSaleStartTime_;
1644     }
1645     if (publicSaleStartTime_ != 0) {
1646         require(publicSaleStartTime_ > saleConfig.whitelistSaleStartTime, "setSaleTimes: public sale start time cannot be before whitelist sale start time");
1647         saleConfig.publicSaleStartTime = publicSaleStartTime_;
1648     }
1649   }
1650   // ~~~ Setters End ~~~
1651 
1652 }