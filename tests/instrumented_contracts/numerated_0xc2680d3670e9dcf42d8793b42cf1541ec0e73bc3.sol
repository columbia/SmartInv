1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Trees proofs.
10  *
11  * The proofs can be generated using the JavaScript library
12  * https://github.com/miguelmota/merkletreejs[merkletreejs].
13  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
14  *
15  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
16  */
17 library MerkleProof {
18     /**
19      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
20      * defined by `root`. For this, a `proof` must be provided, containing
21      * sibling hashes on the branch from the leaf to the root of the tree. Each
22      * pair of leaves and each pair of pre-images are assumed to be sorted.
23      */
24     function verify(
25         bytes32[] memory proof,
26         bytes32 root,
27         bytes32 leaf
28     ) internal pure returns (bool) {
29         return processProof(proof, leaf) == root;
30     }
31 
32     /**
33      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
34      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
35      * hash matches the root of the tree. When processing the proof, the pairs
36      * of leafs & pre-images are assumed to be sorted.
37      *
38      * _Available since v4.4._
39      */
40     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
41         bytes32 computedHash = leaf;
42         for (uint256 i = 0; i < proof.length; i++) {
43             bytes32 proofElement = proof[i];
44             if (computedHash <= proofElement) {
45                 // Hash(current computed hash + current element of the proof)
46                 computedHash = _efficientHash(computedHash, proofElement);
47             } else {
48                 // Hash(current element of the proof + current computed hash)
49                 computedHash = _efficientHash(proofElement, computedHash);
50             }
51         }
52         return computedHash;
53     }
54 
55     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
56         assembly {
57             mstore(0x00, a)
58             mstore(0x20, b)
59             value := keccak256(0x00, 0x40)
60         }
61     }
62 }
63 
64 // File: @openzeppelin/contracts/utils/Strings.sol
65 
66 
67 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
68 
69 pragma solidity ^0.8.0;
70 
71 /**
72  * @dev String operations.
73  */
74 library Strings {
75     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
76 
77     /**
78      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
79      */
80     function toString(uint256 value) internal pure returns (string memory) {
81         // Inspired by OraclizeAPI's implementation - MIT licence
82         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
83 
84         if (value == 0) {
85             return "0";
86         }
87         uint256 temp = value;
88         uint256 digits;
89         while (temp != 0) {
90             digits++;
91             temp /= 10;
92         }
93         bytes memory buffer = new bytes(digits);
94         while (value != 0) {
95             digits -= 1;
96             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
97             value /= 10;
98         }
99         return string(buffer);
100     }
101 
102     /**
103      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
104      */
105     function toHexString(uint256 value) internal pure returns (string memory) {
106         if (value == 0) {
107             return "0x00";
108         }
109         uint256 temp = value;
110         uint256 length = 0;
111         while (temp != 0) {
112             length++;
113             temp >>= 8;
114         }
115         return toHexString(value, length);
116     }
117 
118     /**
119      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
120      */
121     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
122         bytes memory buffer = new bytes(2 * length + 2);
123         buffer[0] = "0";
124         buffer[1] = "x";
125         for (uint256 i = 2 * length + 1; i > 1; --i) {
126             buffer[i] = _HEX_SYMBOLS[value & 0xf];
127             value >>= 4;
128         }
129         require(value == 0, "Strings: hex length insufficient");
130         return string(buffer);
131     }
132 }
133 
134 // File: @openzeppelin/contracts/utils/Address.sol
135 
136 
137 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
138 
139 pragma solidity ^0.8.1;
140 
141 /**
142  * @dev Collection of functions related to the address type
143  */
144 library Address {
145     /**
146      * @dev Returns true if `account` is a contract.
147      *
148      * [IMPORTANT]
149      * ====
150      * It is unsafe to assume that an address for which this function returns
151      * false is an externally-owned account (EOA) and not a contract.
152      *
153      * Among others, `isContract` will return false for the following
154      * types of addresses:
155      *
156      *  - an externally-owned account
157      *  - a contract in construction
158      *  - an address where a contract will be created
159      *  - an address where a contract lived, but was destroyed
160      * ====
161      *
162      * [IMPORTANT]
163      * ====
164      * You shouldn't rely on `isContract` to protect against flash loan attacks!
165      *
166      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
167      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
168      * constructor.
169      * ====
170      */
171     function isContract(address account) internal view returns (bool) {
172         // This method relies on extcodesize/address.code.length, which returns 0
173         // for contracts in construction, since the code is only stored at the end
174         // of the constructor execution.
175 
176         return account.code.length > 0;
177     }
178 
179     /**
180      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
181      * `recipient`, forwarding all available gas and reverting on errors.
182      *
183      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
184      * of certain opcodes, possibly making contracts go over the 2300 gas limit
185      * imposed by `transfer`, making them unable to receive funds via
186      * `transfer`. {sendValue} removes this limitation.
187      *
188      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
189      *
190      * IMPORTANT: because control is transferred to `recipient`, care must be
191      * taken to not create reentrancy vulnerabilities. Consider using
192      * {ReentrancyGuard} or the
193      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
194      */
195     function sendValue(address payable recipient, uint256 amount) internal {
196         require(address(this).balance >= amount, "Address: insufficient balance");
197 
198         (bool success, ) = recipient.call{value: amount}("");
199         require(success, "Address: unable to send value, recipient may have reverted");
200     }
201 
202     /**
203      * @dev Performs a Solidity function call using a low level `call`. A
204      * plain `call` is an unsafe replacement for a function call: use this
205      * function instead.
206      *
207      * If `target` reverts with a revert reason, it is bubbled up by this
208      * function (like regular Solidity function calls).
209      *
210      * Returns the raw returned data. To convert to the expected return value,
211      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
212      *
213      * Requirements:
214      *
215      * - `target` must be a contract.
216      * - calling `target` with `data` must not revert.
217      *
218      * _Available since v3.1._
219      */
220     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
221         return functionCall(target, data, "Address: low-level call failed");
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
226      * `errorMessage` as a fallback revert reason when `target` reverts.
227      *
228      * _Available since v3.1._
229      */
230     function functionCall(
231         address target,
232         bytes memory data,
233         string memory errorMessage
234     ) internal returns (bytes memory) {
235         return functionCallWithValue(target, data, 0, errorMessage);
236     }
237 
238     /**
239      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
240      * but also transferring `value` wei to `target`.
241      *
242      * Requirements:
243      *
244      * - the calling contract must have an ETH balance of at least `value`.
245      * - the called Solidity function must be `payable`.
246      *
247      * _Available since v3.1._
248      */
249     function functionCallWithValue(
250         address target,
251         bytes memory data,
252         uint256 value
253     ) internal returns (bytes memory) {
254         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
255     }
256 
257     /**
258      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
259      * with `errorMessage` as a fallback revert reason when `target` reverts.
260      *
261      * _Available since v3.1._
262      */
263     function functionCallWithValue(
264         address target,
265         bytes memory data,
266         uint256 value,
267         string memory errorMessage
268     ) internal returns (bytes memory) {
269         require(address(this).balance >= value, "Address: insufficient balance for call");
270         require(isContract(target), "Address: call to non-contract");
271 
272         (bool success, bytes memory returndata) = target.call{value: value}(data);
273         return verifyCallResult(success, returndata, errorMessage);
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
278      * but performing a static call.
279      *
280      * _Available since v3.3._
281      */
282     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
283         return functionStaticCall(target, data, "Address: low-level static call failed");
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
288      * but performing a static call.
289      *
290      * _Available since v3.3._
291      */
292     function functionStaticCall(
293         address target,
294         bytes memory data,
295         string memory errorMessage
296     ) internal view returns (bytes memory) {
297         require(isContract(target), "Address: static call to non-contract");
298 
299         (bool success, bytes memory returndata) = target.staticcall(data);
300         return verifyCallResult(success, returndata, errorMessage);
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
305      * but performing a delegate call.
306      *
307      * _Available since v3.4._
308      */
309     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
310         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
315      * but performing a delegate call.
316      *
317      * _Available since v3.4._
318      */
319     function functionDelegateCall(
320         address target,
321         bytes memory data,
322         string memory errorMessage
323     ) internal returns (bytes memory) {
324         require(isContract(target), "Address: delegate call to non-contract");
325 
326         (bool success, bytes memory returndata) = target.delegatecall(data);
327         return verifyCallResult(success, returndata, errorMessage);
328     }
329 
330     /**
331      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
332      * revert reason using the provided one.
333      *
334      * _Available since v4.3._
335      */
336     function verifyCallResult(
337         bool success,
338         bytes memory returndata,
339         string memory errorMessage
340     ) internal pure returns (bytes memory) {
341         if (success) {
342             return returndata;
343         } else {
344             // Look for revert reason and bubble it up if present
345             if (returndata.length > 0) {
346                 // The easiest way to bubble the revert reason is using memory via assembly
347 
348                 assembly {
349                     let returndata_size := mload(returndata)
350                     revert(add(32, returndata), returndata_size)
351                 }
352             } else {
353                 revert(errorMessage);
354             }
355         }
356     }
357 }
358 
359 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
360 
361 
362 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
363 
364 pragma solidity ^0.8.0;
365 
366 /**
367  * @title ERC721 token receiver interface
368  * @dev Interface for any contract that wants to support safeTransfers
369  * from ERC721 asset contracts.
370  */
371 interface IERC721Receiver {
372     /**
373      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
374      * by `operator` from `from`, this function is called.
375      *
376      * It must return its Solidity selector to confirm the token transfer.
377      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
378      *
379      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
380      */
381     function onERC721Received(
382         address operator,
383         address from,
384         uint256 tokenId,
385         bytes calldata data
386     ) external returns (bytes4);
387 }
388 
389 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
390 
391 
392 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
393 
394 pragma solidity ^0.8.0;
395 
396 /**
397  * @dev Interface of the ERC165 standard, as defined in the
398  * https://eips.ethereum.org/EIPS/eip-165[EIP].
399  *
400  * Implementers can declare support of contract interfaces, which can then be
401  * queried by others ({ERC165Checker}).
402  *
403  * For an implementation, see {ERC165}.
404  */
405 interface IERC165 {
406     /**
407      * @dev Returns true if this contract implements the interface defined by
408      * `interfaceId`. See the corresponding
409      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
410      * to learn more about how these ids are created.
411      *
412      * This function call must use less than 30 000 gas.
413      */
414     function supportsInterface(bytes4 interfaceId) external view returns (bool);
415 }
416 
417 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
418 
419 
420 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
421 
422 pragma solidity ^0.8.0;
423 
424 
425 /**
426  * @dev Implementation of the {IERC165} interface.
427  *
428  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
429  * for the additional interface id that will be supported. For example:
430  *
431  * ```solidity
432  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
433  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
434  * }
435  * ```
436  *
437  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
438  */
439 abstract contract ERC165 is IERC165 {
440     /**
441      * @dev See {IERC165-supportsInterface}.
442      */
443     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
444         return interfaceId == type(IERC165).interfaceId;
445     }
446 }
447 
448 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
449 
450 
451 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
452 
453 pragma solidity ^0.8.0;
454 
455 
456 /**
457  * @dev Required interface of an ERC721 compliant contract.
458  */
459 interface IERC721 is IERC165 {
460     /**
461      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
462      */
463     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
464 
465     /**
466      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
467      */
468     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
469 
470     /**
471      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
472      */
473     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
474 
475     /**
476      * @dev Returns the number of tokens in ``owner``'s account.
477      */
478     function balanceOf(address owner) external view returns (uint256 balance);
479 
480     /**
481      * @dev Returns the owner of the `tokenId` token.
482      *
483      * Requirements:
484      *
485      * - `tokenId` must exist.
486      */
487     function ownerOf(uint256 tokenId) external view returns (address owner);
488 
489     /**
490      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
491      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
492      *
493      * Requirements:
494      *
495      * - `from` cannot be the zero address.
496      * - `to` cannot be the zero address.
497      * - `tokenId` token must exist and be owned by `from`.
498      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
499      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
500      *
501      * Emits a {Transfer} event.
502      */
503     function safeTransferFrom(
504         address from,
505         address to,
506         uint256 tokenId
507     ) external;
508 
509     /**
510      * @dev Transfers `tokenId` token from `from` to `to`.
511      *
512      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
513      *
514      * Requirements:
515      *
516      * - `from` cannot be the zero address.
517      * - `to` cannot be the zero address.
518      * - `tokenId` token must be owned by `from`.
519      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
520      *
521      * Emits a {Transfer} event.
522      */
523     function transferFrom(
524         address from,
525         address to,
526         uint256 tokenId
527     ) external;
528 
529     /**
530      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
531      * The approval is cleared when the token is transferred.
532      *
533      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
534      *
535      * Requirements:
536      *
537      * - The caller must own the token or be an approved operator.
538      * - `tokenId` must exist.
539      *
540      * Emits an {Approval} event.
541      */
542     function approve(address to, uint256 tokenId) external;
543 
544     /**
545      * @dev Returns the account approved for `tokenId` token.
546      *
547      * Requirements:
548      *
549      * - `tokenId` must exist.
550      */
551     function getApproved(uint256 tokenId) external view returns (address operator);
552 
553     /**
554      * @dev Approve or remove `operator` as an operator for the caller.
555      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
556      *
557      * Requirements:
558      *
559      * - The `operator` cannot be the caller.
560      *
561      * Emits an {ApprovalForAll} event.
562      */
563     function setApprovalForAll(address operator, bool _approved) external;
564 
565     /**
566      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
567      *
568      * See {setApprovalForAll}
569      */
570     function isApprovedForAll(address owner, address operator) external view returns (bool);
571 
572     /**
573      * @dev Safely transfers `tokenId` token from `from` to `to`.
574      *
575      * Requirements:
576      *
577      * - `from` cannot be the zero address.
578      * - `to` cannot be the zero address.
579      * - `tokenId` token must exist and be owned by `from`.
580      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
581      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
582      *
583      * Emits a {Transfer} event.
584      */
585     function safeTransferFrom(
586         address from,
587         address to,
588         uint256 tokenId,
589         bytes calldata data
590     ) external;
591 }
592 
593 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
594 
595 
596 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
597 
598 pragma solidity ^0.8.0;
599 
600 
601 /**
602  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
603  * @dev See https://eips.ethereum.org/EIPS/eip-721
604  */
605 interface IERC721Metadata is IERC721 {
606     /**
607      * @dev Returns the token collection name.
608      */
609     function name() external view returns (string memory);
610 
611     /**
612      * @dev Returns the token collection symbol.
613      */
614     function symbol() external view returns (string memory);
615 
616     /**
617      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
618      */
619     function tokenURI(uint256 tokenId) external view returns (string memory);
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
715 // File: contracts/ERC721B.sol
716 
717 
718 /*  Creator: Chiru Labs. 
719     ===========================
720     Adapted by @digitalkemical. 
721     This is not intended to be a new standard. 
722     It is an adaptation of the ERC721A which adds a few features.
723 */
724 
725 pragma solidity ^0.8.4;
726 
727 
728 
729 
730 
731 
732 
733 
734 error ApprovalCallerNotOwnerNorApproved();
735 error ApprovalQueryForNonexistentToken();
736 error ApproveToCaller();
737 error ApprovalToCurrentOwner();
738 error BalanceQueryForZeroAddress();
739 error MintToZeroAddress();
740 error MintZeroQuantity();
741 error OwnerQueryForNonexistentToken();
742 error TransferCallerNotOwnerNorApproved();
743 error TransferFromIncorrectOwner();
744 error TransferToNonERC721ReceiverImplementer();
745 error TransferToZeroAddress();
746 error URIQueryForNonexistentToken();
747 
748 /**
749  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
750  * the Metadata extension. Built to optimize for lower gas during batch mints.
751  *
752  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
753  *
754  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
755  *
756  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
757  */
758 contract ERC721B is Context, ERC165, IERC721, IERC721Metadata {
759     using Address for address;
760     using Strings for uint256;
761 
762     // Compiler will pack this into a single 256bit word.
763     struct TokenOwnership {
764         // The address of the owner.
765         address addr;
766         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
767         uint64 startTimestamp;
768         // Whether the token has been burned.
769         bool burned;
770         
771     }
772 
773     // Compiler will pack this into a single 256bit word.
774     struct AddressData {
775         // Realistically, 2**64-1 is more than enough.
776         uint64 balance;
777         // Keeps track of mint count with minimal overhead for tokenomics.
778         uint64 numberMinted;
779         // Keeps track of burn count with minimal overhead for tokenomics.
780         uint64 numberBurned;
781         // For miscellaneous variable(s) pertaining to the address
782         // (e.g. number of whitelist mint slots used).
783         // If there are multiple variables, please pack them into a uint64.
784         uint64 aux;
785         //track ids owned by address
786         uint16[] tokenIds;
787     }
788 
789     // The tokenId of the next token to be minted.
790     uint256 internal _currentIndex;
791 
792     // The number of tokens burned.
793     uint256 internal _burnCounter;
794 
795     // Token name
796     string private _name;
797 
798     // Token symbol
799     string private _symbol;
800 
801     string public metadataPath;
802 
803     // Mapping from token ID to ownership details
804     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
805     mapping(uint256 => TokenOwnership) internal _ownerships;
806 
807     // Mapping owner address to address data
808     mapping(address => AddressData) internal _addressData;
809 
810     // Mapping from token ID to approved address
811     mapping(uint256 => address) private _tokenApprovals;
812 
813     // Mapping from owner to operator approvals
814     mapping(address => mapping(address => bool)) private _operatorApprovals;
815 
816     constructor(string memory name_, string memory symbol_) {
817         _name = name_;
818         _symbol = symbol_;
819         _currentIndex = _startTokenId();
820     }
821 
822     /**
823      * To change the starting tokenId, please override this function.
824      */
825     function _startTokenId() internal view virtual returns (uint256) {
826         return 0;
827     }
828 
829     /**
830      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
831      */
832     function totalSupply() public view returns (uint256) {
833         // Counter underflow is impossible as _burnCounter cannot be incremented
834         // more than _currentIndex - _startTokenId() times
835         unchecked {
836             return _currentIndex - _burnCounter - _startTokenId();
837         }
838     }
839 
840     /**
841      * Returns the total amount of tokens minted in the contract.
842      */
843     function _totalMinted() internal view returns (uint256) {
844         // Counter underflow is impossible as _currentIndex does not decrement,
845         // and it is initialized to _startTokenId()
846         unchecked {
847             return _currentIndex - _startTokenId();
848         }
849     }
850 
851     /**
852      * @dev See {IERC165-supportsInterface}.
853      */
854     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
855         return
856             interfaceId == type(IERC721).interfaceId ||
857             interfaceId == type(IERC721Metadata).interfaceId ||
858             super.supportsInterface(interfaceId);
859     }
860 
861     /**
862      * @dev See {IERC721-balanceOf}.
863      */
864     function balanceOf(address owner) public view override returns (uint256) {
865         if (owner == address(0)) revert BalanceQueryForZeroAddress();
866         return uint256(_addressData[owner].balance);
867     }
868 
869     /**
870      * Returns the number of tokens minted by `owner`.
871      */
872     function _numberMinted(address owner) internal view returns (uint256) {
873         return uint256(_addressData[owner].numberMinted);
874     }
875 
876     /**
877      * Returns the number of tokens burned by or on behalf of `owner`.
878      */
879     function _numberBurned(address owner) internal view returns (uint256) {
880         return uint256(_addressData[owner].numberBurned);
881     }
882 
883     /**
884      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
885      */
886     function _getAux(address owner) internal view returns (uint64) {
887         return _addressData[owner].aux;
888     }
889 
890     /**
891      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
892      * If there are multiple variables, please pack them into a uint64.
893      */
894     function _setAux(address owner, uint64 aux) internal {
895         _addressData[owner].aux = aux;
896     }
897 
898     /**
899      * Gas spent here starts off proportional to the maximum mint batch size.
900      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
901      */
902     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
903         uint256 curr = tokenId;
904 
905         unchecked {
906             if (_startTokenId() <= curr && curr < _currentIndex) {
907                 TokenOwnership memory ownership = _ownerships[curr];
908                 if (!ownership.burned) {
909                     if (ownership.addr != address(0)) {
910                         return ownership;
911                     }
912                     // Invariant:
913                     // There will always be an ownership that has an address and is not burned
914                     // before an ownership that does not have an address and is not burned.
915                     // Hence, curr will not underflow.
916                     while (true) {
917                         curr--;
918                         ownership = _ownerships[curr];
919                         if (ownership.addr != address(0)) {
920                             return ownership;
921                         }
922                     }
923                 }
924             }
925         }
926         revert OwnerQueryForNonexistentToken();
927     }
928 
929     /**
930      * @dev See {IERC721-ownerOf}.
931      */
932     function ownerOf(uint256 tokenId) public view override returns (address) {
933         return _ownershipOf(tokenId).addr;
934     }
935 
936     /**
937      * @dev See {IERC721Metadata-name}.
938      */
939     function name() public view virtual override returns (string memory) {
940         return _name;
941     }
942 
943     /**
944      * @dev See {IERC721Metadata-symbol}.
945      */
946     function symbol() public view virtual override returns (string memory) {
947         return _symbol;
948     }
949 
950     /**
951      * @dev See {IERC721Metadata-tokenURI}.
952      */
953     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
954         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
955 
956         string memory baseURI = _baseURI();
957         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(),'.json')) : '';
958     }
959 
960     /**
961      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
962      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
963      * by default, can be overriden in child contracts.
964      */
965     function _baseURI() internal view virtual returns (string memory) {
966         return metadataPath;
967     }
968 
969     /**
970      * @dev See {IERC721-approve}.
971      */
972     function approve(address to, uint256 tokenId) public override {
973         address owner = ERC721B.ownerOf(tokenId);
974         if (to == owner) revert ApprovalToCurrentOwner();
975 
976         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
977             revert ApprovalCallerNotOwnerNorApproved();
978         }
979 
980         _approve(to, tokenId, owner);
981     }
982 
983     /**
984      * @dev See {IERC721-getApproved}.
985      */
986     function getApproved(uint256 tokenId) public view override returns (address) {
987         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
988 
989         return _tokenApprovals[tokenId];
990     }
991 
992     /**
993      * @dev See {IERC721-setApprovalForAll}.
994      */
995     function setApprovalForAll(address operator, bool approved) public virtual override {
996         if (operator == _msgSender()) revert ApproveToCaller();
997 
998         _operatorApprovals[_msgSender()][operator] = approved;
999         emit ApprovalForAll(_msgSender(), operator, approved);
1000     }
1001 
1002     /**
1003      * @dev See {IERC721-isApprovedForAll}.
1004      */
1005     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1006         return _operatorApprovals[owner][operator];
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-transferFrom}.
1011      */
1012     function transferFrom(
1013         address from,
1014         address to,
1015         uint256 tokenId
1016     ) public virtual override {
1017         _transfer(from, to, tokenId);
1018     }
1019 
1020     /**
1021      * @dev See {IERC721-safeTransferFrom}.
1022      */
1023     function safeTransferFrom(
1024         address from,
1025         address to,
1026         uint256 tokenId
1027     ) public virtual override {
1028         safeTransferFrom(from, to, tokenId, '');
1029     }
1030 
1031     /**
1032      * @dev See {IERC721-safeTransferFrom}.
1033      */
1034     function safeTransferFrom(
1035         address from,
1036         address to,
1037         uint256 tokenId,
1038         bytes memory _data
1039     ) public virtual override {
1040         _transfer(from, to, tokenId);
1041         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1042             revert TransferToNonERC721ReceiverImplementer();
1043         }
1044     }
1045 
1046     /**
1047      * @dev Returns whether `tokenId` exists.
1048      *
1049      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1050      *
1051      * Tokens start existing when they are minted (`_mint`),
1052      */
1053     function _exists(uint256 tokenId) internal view returns (bool) {
1054         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1055     }
1056 
1057     function _safeMint(address to, uint256 quantity) internal {
1058         _safeMint(to, quantity, '');
1059     }
1060 
1061     /**
1062      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1063      *
1064      * Requirements:
1065      *
1066      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1067      * - `quantity` must be greater than 0.
1068      *
1069      * Emits a {Transfer} event.
1070      */
1071     function _safeMint(
1072         address to,
1073         uint256 quantity,
1074         bytes memory _data
1075     ) internal {
1076         _mint(to, quantity, _data, true);
1077     }
1078 
1079     /**
1080      * @dev Mints `quantity` tokens and transfers them to `to`.
1081      *
1082      * Requirements:
1083      *
1084      * - `to` cannot be the zero address.
1085      * - `quantity` must be greater than 0.
1086      *
1087      * Emits a {Transfer} event.
1088      */
1089     function _mint(
1090         address to,
1091         uint256 quantity,
1092         bytes memory _data,
1093         bool safe
1094     ) internal {
1095         uint256 startTokenId = _currentIndex;
1096         if (to == address(0)) revert MintToZeroAddress();
1097         if (quantity == 0) revert MintZeroQuantity();
1098 
1099         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1100 
1101         // Overflows are incredibly unrealistic.
1102         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1103         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1104         unchecked {
1105             _addressData[to].balance += uint64(quantity);
1106             _addressData[to].numberMinted += uint64(quantity);
1107 
1108             _ownerships[startTokenId].addr = to;
1109             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1110 
1111             //BLINKLESS ADDITION: TRACK OWNERSHIP
1112             uint i = 0;
1113             while(i < quantity){
1114                 uint tokenId = i + _currentIndex;
1115                 _addressData[to].tokenIds.push(uint16(tokenId));
1116                 i++;
1117             }
1118             //END BLINKLESS ADDITION: TRACK OWNERSHIP
1119 
1120             uint256 updatedIndex = startTokenId;
1121             uint256 end = updatedIndex + quantity;
1122 
1123             if (safe && to.isContract()) {
1124                 do {
1125                     emit Transfer(address(0), to, updatedIndex);
1126                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1127                         revert TransferToNonERC721ReceiverImplementer();
1128                     }
1129                 } while (updatedIndex != end);
1130                 // Reentrancy protection
1131                 if (_currentIndex != startTokenId) revert();
1132             } else {
1133                 do {
1134                     emit Transfer(address(0), to, updatedIndex++);
1135                 } while (updatedIndex != end);
1136             }
1137             _currentIndex = updatedIndex;
1138         }
1139         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1140     }
1141 
1142     /**
1143      * @dev Transfers `tokenId` from `from` to `to`.
1144      *
1145      * Requirements:
1146      *
1147      * - `to` cannot be the zero address.
1148      * - `tokenId` token must be owned by `from`.
1149      *
1150      * Emits a {Transfer} event.
1151      */
1152     function _transfer(
1153         address from,
1154         address to,
1155         uint256 tokenId
1156     ) private {
1157         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1158 
1159         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1160 
1161         bool isApprovedOrOwner = (_msgSender() == from ||
1162             isApprovedForAll(from, _msgSender()) ||
1163             getApproved(tokenId) == _msgSender());
1164 
1165         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1166         if (to == address(0)) revert TransferToZeroAddress();
1167 
1168         _beforeTokenTransfers(from, to, tokenId, 1);
1169 
1170         // Clear approvals from the previous owner
1171         _approve(address(0), tokenId, from);
1172 
1173 
1174         // Underflow of the sender's balance is impossible because we check for
1175         // ownership above and the recipient's balance can't realistically overflow.
1176         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1177         unchecked {
1178             _addressData[from].balance -= 1;
1179             _addressData[to].balance += 1;
1180 
1181             TokenOwnership storage currSlot = _ownerships[tokenId];
1182             currSlot.addr = to;
1183             currSlot.startTimestamp = uint64(block.timestamp);
1184 
1185             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1186             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1187             uint256 nextTokenId = tokenId + 1;
1188             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1189             if (nextSlot.addr == address(0)) {
1190                 // This will suffice for checking _exists(nextTokenId),
1191                 // as a burned slot cannot contain the zero address.
1192                 if (nextTokenId != _currentIndex) {
1193                     nextSlot.addr = from;
1194                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1195                 }
1196             }
1197         }
1198 
1199             //BLINKLESS ADDITION: TRACK OWNERSHIP
1200             _addressData[to].tokenIds.push(uint16(tokenId));
1201             for (uint i=0; i < _addressData[from].tokenIds.length; i++) {
1202                 if(_addressData[from].tokenIds[i] == tokenId){
1203                     //delete from array
1204                     _addressData[from].tokenIds[i] = _addressData[from].tokenIds[_addressData[from].tokenIds.length - 1];
1205                     _addressData[from].tokenIds.pop();
1206                 }
1207             }
1208             //END BLINKLESS ADDITION: TRACK OWNERSHIP
1209 
1210             //BLINKLESS ADDITION: PASSIVE VIRAL MINTING (PVM)
1211             if(totalSupply() < 5555){
1212                 //Passive viral minting - mint a new token to replace the old one
1213                 _safeMint(address(from), 1);
1214             }
1215             //END BLINKLESS ADDITION: TRACK OWNERSHIP
1216 
1217         emit Transfer(from, to, tokenId);
1218         _afterTokenTransfers(from, to, tokenId, 1);
1219     }
1220 
1221  
1222 
1223     /**
1224      * @dev This is equivalent to _burn(tokenId, false)
1225      */
1226     function _burn(uint256 tokenId) internal virtual {
1227         _burn(tokenId, false);
1228     }
1229 
1230     /**
1231      * @dev Destroys `tokenId`.
1232      * The approval is cleared when the token is burned.
1233      *
1234      * Requirements:
1235      *
1236      * - `tokenId` must exist.
1237      *
1238      * Emits a {Transfer} event.
1239      */
1240     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1241         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1242 
1243         address from = prevOwnership.addr;
1244 
1245         if (approvalCheck) {
1246             bool isApprovedOrOwner = (_msgSender() == from ||
1247                 isApprovedForAll(from, _msgSender()) ||
1248                 getApproved(tokenId) == _msgSender());
1249 
1250             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1251         }
1252 
1253         _beforeTokenTransfers(from, address(0), tokenId, 1);
1254 
1255         // Clear approvals from the previous owner
1256         _approve(address(0), tokenId, from);
1257 
1258         // Underflow of the sender's balance is impossible because we check for
1259         // ownership above and the recipient's balance can't realistically overflow.
1260         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1261         unchecked {
1262             AddressData storage addressData = _addressData[from];
1263             addressData.balance -= 1;
1264             addressData.numberBurned += 1;
1265 
1266             // Keep track of who burned the token, and the timestamp of burning.
1267             TokenOwnership storage currSlot = _ownerships[tokenId];
1268             currSlot.addr = from;
1269             currSlot.startTimestamp = uint64(block.timestamp);
1270             currSlot.burned = true;
1271 
1272             //BLINKLESS ADDITION: TRACK OWNERSHIP
1273             for (uint i=0; i < _addressData[from].tokenIds.length; i++) {
1274                 if(_addressData[from].tokenIds[i] == tokenId){
1275                     //delete from array
1276                     _addressData[from].tokenIds[i] = _addressData[from].tokenIds[_addressData[from].tokenIds.length - 1];
1277                     _addressData[from].tokenIds.pop();
1278                 }
1279             }
1280             //END BLINKLESS ADDITION: TRACK OWNERSHIP
1281 
1282             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1283             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1284             uint256 nextTokenId = tokenId + 1;
1285             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1286             if (nextSlot.addr == address(0)) {
1287                 // This will suffice for checking _exists(nextTokenId),
1288                 // as a burned slot cannot contain the zero address.
1289                 if (nextTokenId != _currentIndex) {
1290                     nextSlot.addr = from;
1291                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1292                 }
1293             }
1294         }
1295 
1296         emit Transfer(from, address(0), tokenId);
1297         _afterTokenTransfers(from, address(0), tokenId, 1);
1298 
1299         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1300         unchecked {
1301             _burnCounter++;
1302         }
1303     }
1304 
1305     /**
1306      * @dev Approve `to` to operate on `tokenId`
1307      *
1308      * Emits a {Approval} event.
1309      */
1310     function _approve(
1311         address to,
1312         uint256 tokenId,
1313         address owner
1314     ) private {
1315         _tokenApprovals[tokenId] = to;
1316         emit Approval(owner, to, tokenId);
1317     }
1318 
1319     /**
1320      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1321      *
1322      * @param from address representing the previous owner of the given token ID
1323      * @param to target address that will receive the tokens
1324      * @param tokenId uint256 ID of the token to be transferred
1325      * @param _data bytes optional data to send along with the call
1326      * @return bool whether the call correctly returned the expected magic value
1327      */
1328     function _checkContractOnERC721Received(
1329         address from,
1330         address to,
1331         uint256 tokenId,
1332         bytes memory _data
1333     ) private returns (bool) {
1334         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1335             return retval == IERC721Receiver(to).onERC721Received.selector;
1336         } catch (bytes memory reason) {
1337             if (reason.length == 0) {
1338                 revert TransferToNonERC721ReceiverImplementer();
1339             } else {
1340                 assembly {
1341                     revert(add(32, reason), mload(reason))
1342                 }
1343             }
1344         }
1345     }
1346 
1347     /**
1348      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1349      * And also called before burning one token.
1350      *
1351      * startTokenId - the first token id to be transferred
1352      * quantity - the amount to be transferred
1353      *
1354      * Calling conditions:
1355      *
1356      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1357      * transferred to `to`.
1358      * - When `from` is zero, `tokenId` will be minted for `to`.
1359      * - When `to` is zero, `tokenId` will be burned by `from`.
1360      * - `from` and `to` are never both zero.
1361      */
1362     function _beforeTokenTransfers(
1363         address from,
1364         address to,
1365         uint256 startTokenId,
1366         uint256 quantity
1367     ) internal virtual {}
1368 
1369     /**
1370      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1371      * minting.
1372      * And also called after one token has been burned.
1373      *
1374      * startTokenId - the first token id to be transferred
1375      * quantity - the amount to be transferred
1376      *
1377      * Calling conditions:
1378      *
1379      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1380      * transferred to `to`.
1381      * - When `from` is zero, `tokenId` has been minted for `to`.
1382      * - When `to` is zero, `tokenId` has been burned by `from`.
1383      * - `from` and `to` are never both zero.
1384      */
1385     function _afterTokenTransfers(
1386         address from,
1387         address to,
1388         uint256 startTokenId,
1389         uint256 quantity
1390     ) internal virtual {}
1391 }
1392 // File: @openzeppelin/contracts/access/Ownable.sol
1393 
1394 
1395 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1396 
1397 pragma solidity ^0.8.0;
1398 
1399 
1400 /**
1401  * @dev Contract module which provides a basic access control mechanism, where
1402  * there is an account (an owner) that can be granted exclusive access to
1403  * specific functions.
1404  *
1405  * By default, the owner account will be the one that deploys the contract. This
1406  * can later be changed with {transferOwnership}.
1407  *
1408  * This module is used through inheritance. It will make available the modifier
1409  * `onlyOwner`, which can be applied to your functions to restrict their use to
1410  * the owner.
1411  */
1412 abstract contract Ownable is Context {
1413     address private _owner;
1414 
1415     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1416 
1417     /**
1418      * @dev Initializes the contract setting the deployer as the initial owner.
1419      */
1420     constructor() {
1421         _transferOwnership(_msgSender());
1422     }
1423 
1424     /**
1425      * @dev Returns the address of the current owner.
1426      */
1427     function owner() public view virtual returns (address) {
1428         return _owner;
1429     }
1430 
1431     /**
1432      * @dev Throws if called by any account other than the owner.
1433      */
1434     modifier onlyOwner() {
1435         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1436         _;
1437     }
1438 
1439     /**
1440      * @dev Leaves the contract without owner. It will not be possible to call
1441      * `onlyOwner` functions anymore. Can only be called by the current owner.
1442      *
1443      * NOTE: Renouncing ownership will leave the contract without an owner,
1444      * thereby removing any functionality that is only available to the owner.
1445      */
1446     function renounceOwnership() public virtual onlyOwner {
1447         _transferOwnership(address(0));
1448     }
1449 
1450     /**
1451      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1452      * Can only be called by the current owner.
1453      */
1454     function transferOwnership(address newOwner) public virtual onlyOwner {
1455         require(newOwner != address(0), "Ownable: new owner is the zero address");
1456         _transferOwnership(newOwner);
1457     }
1458 
1459     /**
1460      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1461      * Internal function without access restriction.
1462      */
1463     function _transferOwnership(address newOwner) internal virtual {
1464         address oldOwner = _owner;
1465         _owner = newOwner;
1466         emit OwnershipTransferred(oldOwner, newOwner);
1467     }
1468 }
1469 
1470 // File: contracts/Blinkless.sol
1471 
1472 
1473 /*
1474      THE BLINKLESS NFT COLLECTION
1475      www.theblinkless.com
1476      Twitter: @theblinkless      
1477 
1478      This contract utilizes an adaptation of the ERC721A standard developed by Azuki for low-gas minting 
1479      but adds the ability to track which tokenIds are owned by a particular address and implements
1480      Passive Viral Minting (PVM) to mint tokens upon transfer until maxSupply is reached.
1481      Payouts are calculated, issued, and claimed using methodology inspired by the ERC721A.    
1482 
1483 */
1484 pragma solidity ^0.8.0;
1485 
1486 
1487 
1488 
1489 
1490 
1491 contract Blinkless is Ownable, ERC721B, ReentrancyGuard {
1492 
1493     mapping(address => bool) public hasMinted; //tracks whether wallet has already minted walletAddress => 1/0
1494     mapping(address => bool) public BLHasMinted; //tracks whether wallet has already minted walletAddress => 1/0
1495     mapping(uint16 => mapping(uint256 => uint256)) payoutsClaimed; //all payouts claimed by token id tokenID => payoutId => amount
1496     uint256[] payouts; //all payouts created by team payoutId => amount
1497     mapping(uint16 => uint256) lastPayoutClaimed; //the payoutID of the last payout claimed by a token tokenID => lastPayoutId
1498 
1499     uint256 public unclaimedPayouts = 0; //total amount of unclaimed payouts
1500     uint256 public mintMode = 0; //1 for Blinklist only, 2 for public, 0 to disable
1501     uint256 public maxSupply = 5555; //total number of tokens
1502     uint256 teamAndPromoSupply = 190; //number of tokens minted to team @ deploy
1503     uint256 modShare = 10; //number of mod tokens
1504 
1505     bytes32 public root; //blinklist merkle tree root
1506 
1507     //Declare ClaimPayout Event
1508     event ClaimPayout(address indexed _from, uint _value);
1509 
1510 
1511     constructor(bytes32 _root) ERC721B("The Blinkless", "BLNK") {
1512         //init payouts array - use up slot at zero index so we can start at 1
1513         payouts.push(0);
1514         //init blinklist root
1515         root = _root;
1516     }
1517 
1518     /**
1519     * Mint out for promos, giveaways and mod compensation
1520     */
1521     function teamAndPromoMint(address _modWallet) external onlyOwner{
1522         //lets ensure not already claimed
1523         require(teamAndPromoSupply > 0);
1524         require(modShare > 0);
1525         require(_modWallet != address(0), "Mod wallet not set!");
1526          //mint team tokens
1527         _safeMint(msg.sender, teamAndPromoSupply);
1528         //mint mod tokens
1529         _safeMint(address(_modWallet), modShare);
1530         //update allowances
1531         teamAndPromoSupply = 0;
1532         modShare = 0;
1533         
1534     }
1535 
1536 
1537 
1538     /**
1539     * Update the merkle tree root for the blinklist
1540     */
1541     function updateBlinklist(bytes32 _root) external onlyOwner{
1542          root = _root;
1543     }
1544 
1545     /**
1546     * Update the base URI for metadata
1547     */
1548     function updateBaseURI(string memory baseURI) external onlyOwner{
1549          metadataPath = baseURI;
1550     }
1551 
1552 
1553     /**
1554     * Set the current mintMode: 1 for Blinklist only, 2 for public
1555     */
1556     function setMintMode(uint256 _mode) external onlyOwner {
1557         mintMode = _mode;
1558     }
1559 
1560     /*
1561     * Ensures the caller is not a proxy contract or bot, but is an actual wallet.
1562     * If you're another contract, get the fuck outta here!
1563     */
1564     modifier callerIsUser() {
1565         //we only want to mint to real people - no stupid robots.
1566         require(tx.origin == msg.sender, "The caller is another contract");
1567         _;
1568     }
1569 
1570     /*
1571     * Public mint function - LFG!!!
1572     */
1573     function mint() external payable callerIsUser{
1574         require(mintMode == 2, "Public mint is not live");
1575         //limit supply
1576         require((totalSupply() + 2) < maxSupply, "We are sold out!");
1577         //you can only mint once
1578         require(hasMinted[msg.sender] != true, "You have already minted!");
1579         //track this wallet has minted
1580         hasMinted[msg.sender] = true;
1581         //do it!!!
1582         mintTokens();
1583         /* 
1584         Flip kill switch to disable public mint.
1585         Once this is engaged, minting will be PVM-only!
1586         */
1587         if(totalSupply() >= 2500){
1588             mintMode = 0;
1589         }
1590         
1591     }
1592 
1593     /*
1594     * Verifies the sender is on the Blinklist using Merkle Tree Proof
1595     * ** Real OGs ONLY!! LFG! **
1596     */
1597     function isBlinklisted(bytes32[] memory proof, bytes32 leaf) public view returns (bool){
1598         return MerkleProof.verify(proof,root,leaf);
1599     }
1600 
1601     /*
1602     * Blinklist early mint function (sender must be Blinklisted - IYKYK)
1603     */
1604     function blinklistMint(bytes32[] memory proof, bytes32 leaf) external payable callerIsUser{
1605         require(mintMode == 1, "Blinklist mint only!");
1606         //limit supply
1607         require((totalSupply() + 2) < maxSupply, "We are sold out!");
1608         //you can only mint once
1609         require(BLHasMinted[msg.sender] != true, "You have already minted!");
1610         //only Blinklisted addresses can mint
1611         require(isBlinklisted(proof,leaf),"Sorry! You are not on the Blinklist.");
1612          //track this wallet has minted
1613         BLHasMinted[msg.sender] = true;
1614         //do it!!!
1615         mintTokens();
1616        
1617     }
1618 
1619     /**
1620     * Gets the index of the last minted token
1621     */
1622     function getCurrentIndex() external view returns(uint256 currentIndex){
1623         return _currentIndex;
1624     }
1625 
1626     /**
1627     * Get an array of tokenIds for a given wallet
1628     */
1629     function getTokenIds(address wallet) public view returns (uint16[] memory tokenIds){
1630         return _addressData[wallet].tokenIds;
1631     }
1632 
1633 
1634     /**
1635     * Called from the above minting functions - actually mints the tokens
1636     */
1637     function mintTokens() private{
1638         //everyone mints exactly two tokens
1639         _safeMint(msg.sender, 2);
1640     }
1641 
1642     /*
1643     * Create payouts for holders to claim
1644     * Get that money, Blinks!!!!
1645     */
1646     function createPayout() external payable onlyOwner nonReentrant{
1647         //get contract balance
1648         uint256 contractBalance = getContractBalance();
1649 
1650         //make sure there's enough funds in the contract
1651         require(contractBalance > 1000000, "Not enough funds to distribute!!");
1652 
1653         //calc how much is available for distribution (new funds)
1654         uint256 availableForDistribution = contractBalance - unclaimedPayouts;
1655         
1656         //make there is at least 1wei per wallet to distribute
1657         require(availableForDistribution > 5555, "Not enough funds to distribute!");
1658 
1659         //calc split between project team and community
1660         /*
1661             Community gets 50%
1662             Project/Team gets 50%
1663             i.e.
1664             100% - 50% = 50%
1665             1ETH - 0.5ETH = 0.5ETH
1666             1ETH / 2 - 0.5ETH
1667             0.5ETH * 2 = 1ETH
1668         */
1669         uint256 communityShare = (availableForDistribution / 2);
1670         uint256 teamShare = availableForDistribution - communityShare;
1671 
1672         /*
1673          create payout record for community share
1674          Payout is entered as a whole into the system and the amount is added
1675          to unclaimedPayouts. unclaimedPayouts will be deducted from when
1676          a payout is claimed and represents the unclaimed sum of all the 
1677          payouts which have been issued.
1678         */
1679         payouts.push(communityShare);
1680         //add to unclaimed pool
1681         unclaimedPayouts += communityShare;
1682 
1683         //send project team share
1684         (bool success, ) =  payable(msg.sender).call{value: teamShare }("");
1685         require(success, "Transfer failed.");
1686         //emit event
1687         emit ClaimPayout(msg.sender, teamShare);
1688         
1689     }
1690 
1691     /**
1692     * Claim outstanding payouts - don't spend it all on weed!
1693     */
1694     function claimPayout() external payable nonReentrant {
1695         //get tokens owned by msg.sender
1696         uint16[] memory ownedTokenIds = getTokenIds(msg.sender);
1697 
1698         //payout balance
1699         uint256 totalPayout = 0;
1700 
1701         //iterate through owned tokens
1702         uint256 tokenIndex = 0;
1703         while(tokenIndex <= (ownedTokenIds.length - 1) ){
1704             //get the token id
1705             uint16 tokenId = ownedTokenIds[tokenIndex];
1706 
1707             //get the id of the last payout claimed by this token
1708             uint256 lastClaimedPayout = lastPayoutClaimed[tokenId];
1709 
1710             //get the total number of payouts issued (this is also the last payoutId)
1711             uint totalIssuedPayouts = payouts.length - 1; //-1 because we don't have a payout at zero index
1712 
1713             //loop through payouts, add to totalPayout if payoutId > lastClaimedPayout
1714             uint256 i = 1;
1715             while(i <= totalIssuedPayouts){
1716                 if(i > lastClaimedPayout){
1717                     //this payout hasn't been claimed, add to totalPayout
1718                     totalPayout += ( payouts[i] / maxSupply );
1719                 }
1720 
1721                 i++;
1722             }
1723 
1724             /*
1725                 Here we are tracking the last payout claimed for the token
1726                 we are evaluating. Any token can only be paid out for
1727                 payouts issued after the lastPayoutClaimed. This is how
1728                 we get around having to pay gas to issue thousands of 
1729                 payments across all the holders.
1730             */
1731             if(lastPayoutClaimed[tokenId] != totalIssuedPayouts){
1732                 //track last issued payout
1733                 lastPayoutClaimed[tokenId] = totalIssuedPayouts;
1734             }
1735 
1736             //ensure there is something to pay out
1737             if(totalPayout > 0){
1738                 //add payout to history
1739                 payoutsClaimed[tokenId][totalIssuedPayouts] = totalPayout;
1740             }
1741             tokenIndex++;
1742         }
1743 
1744         if(totalPayout > 0){
1745             //deduct from unclaimed pool
1746             unclaimedPayouts -= totalPayout;
1747             
1748             //transfer funds to token owner
1749             (bool success, ) = payable(msg.sender).call{ value: totalPayout }("");
1750             require(success, "Transfer failed.");
1751             //emit event
1752             emit ClaimPayout(msg.sender, totalPayout);
1753         }
1754     }
1755 
1756     /**
1757     * Gets total of unclaimed payouts across all tokens held in a wallet. Does not alter state!
1758     * Use claimPayout() to actually claim funds.
1759     */
1760     function estimatePayout(address wallet) public view returns(uint256 estimate){
1761 
1762         //get tokens owned by wallet
1763         uint16[] memory ownedTokenIds = getTokenIds(wallet);
1764         
1765         uint256 totalPayout = 0;
1766 
1767         //iterate through owned tokens
1768         uint256 tokenIndex = 0;
1769         while(tokenIndex <= (ownedTokenIds.length - 1) ){
1770             uint16 tokenId = ownedTokenIds[tokenIndex];
1771             
1772             //get the id of the last payout claimed by this token
1773             uint256 lastClaimedPayout = lastPayoutClaimed[tokenId];
1774             //get the total number of payouts issued (this is also the last payoutId)
1775             uint totalIssuedPayouts = payouts.length - 1; //-1 because we don't have a payout at zero index
1776 
1777             //loop through payouts, add to totalPayout if payoutId > lastClaimedPayout
1778             uint256 i = 1;
1779             while(i <= totalIssuedPayouts){
1780                 if(i > lastClaimedPayout){
1781                     //this payout hasn't been claimed, add to totalPayout
1782                     totalPayout += ( payouts[i] / maxSupply );
1783                 }
1784 
1785                 i++;
1786             }
1787 
1788             tokenIndex++;
1789         }
1790 
1791         return totalPayout;
1792     }
1793 
1794     /*
1795     * Fetch the total balance held in the contract in wei
1796     */
1797     function getContractBalance() public view returns(uint256 balance){
1798         return address(this).balance;
1799     }
1800 
1801     /*
1802     * Withdraw by owner: In place to facilitate potential migration to a new claiming contract in the future
1803     */
1804     function withdrawMoney() external onlyOwner nonReentrant {
1805         unclaimedPayouts = 0;
1806         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1807         require(success, "Transfer failed.");
1808     }
1809 
1810     /*
1811     * Deposit funds into the contract. Anyone can deposit.
1812     */
1813     function depositMoney() external payable nonReentrant {
1814 
1815     }
1816 
1817     /*
1818     * These are here to receive ETH sent to the contract address
1819     */
1820     receive() external payable {}
1821 
1822     fallback() external payable {}
1823 
1824 
1825 }