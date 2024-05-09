1 /*
2 
3 Developed by https://twitter.com/ViperwareLabs
4 
5 */
6 
7 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev These functions deal with verification of Merkle Trees proofs.
13  *
14  * The proofs can be generated using the JavaScript library
15  * https://github.com/miguelmota/merkletreejs[merkletreejs].
16  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
17  *
18  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
19  */
20 library MerkleProof {
21     /**
22      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
23      * defined by `root`. For this, a `proof` must be provided, containing
24      * sibling hashes on the branch from the leaf to the root of the tree. Each
25      * pair of leaves and each pair of pre-images are assumed to be sorted.
26      */
27     function verify(
28         bytes32[] memory proof,
29         bytes32 root,
30         bytes32 leaf
31     ) internal pure returns (bool) {
32         return processProof(proof, leaf) == root;
33     }
34 
35     /**
36      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
37      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
38      * hash matches the root of the tree. When processing the proof, the pairs
39      * of leafs & pre-images are assumed to be sorted.
40      *
41      * _Available since v4.4._
42      */
43     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
44         bytes32 computedHash = leaf;
45         for (uint256 i = 0; i < proof.length; i++) {
46             bytes32 proofElement = proof[i];
47             if (computedHash <= proofElement) {
48                 // Hash(current computed hash + current element of the proof)
49                 computedHash = _efficientHash(computedHash, proofElement);
50             } else {
51                 // Hash(current element of the proof + current computed hash)
52                 computedHash = _efficientHash(proofElement, computedHash);
53             }
54         }
55         return computedHash;
56     }
57 
58     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
59         assembly {
60             mstore(0x00, a)
61             mstore(0x20, b)
62             value := keccak256(0x00, 0x40)
63         }
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/Strings.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 
75 /**
76  * @dev String operations.
77  */
78 library Strings {
79     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
80 
81     /**
82      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
83      */
84     function toString(uint256 value) internal pure returns (string memory) {
85         // Inspired by OraclizeAPI's implementation - MIT licence
86         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
87 
88         if (value == 0) {
89             return "0";
90         }
91         uint256 temp = value;
92         uint256 digits;
93         while (temp != 0) {
94             digits++;
95             temp /= 10;
96         }
97         bytes memory buffer = new bytes(digits);
98         while (value != 0) {
99             digits -= 1;
100             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
101             value /= 10;
102         }
103         return string(buffer);
104     }
105 
106     /**
107      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
108      */
109     function toHexString(uint256 value) internal pure returns (string memory) {
110         if (value == 0) {
111             return "0x00";
112         }
113         uint256 temp = value;
114         uint256 length = 0;
115         while (temp != 0) {
116             length++;
117             temp >>= 8;
118         }
119         return toHexString(value, length);
120     }
121 
122     /**
123      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
124      */
125     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
126         bytes memory buffer = new bytes(2 * length + 2);
127         buffer[0] = "0";
128         buffer[1] = "x";
129         for (uint256 i = 2 * length + 1; i > 1; --i) {
130             buffer[i] = _HEX_SYMBOLS[value & 0xf];
131             value >>= 4;
132         }
133         require(value == 0, "Strings: hex length insufficient");
134         return string(buffer);
135     }
136 }
137 
138 // File: @openzeppelin/contracts/utils/Address.sol
139 
140 
141 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
142 
143 pragma solidity ^0.8.1;
144 
145 /**
146  * @dev Collection of functions related to the address type
147  */
148 library Address {
149     /**
150      * @dev Returns true if `account` is a contract.
151      *
152      * [IMPORTANT]
153      * ====
154      * It is unsafe to assume that an address for which this function returns
155      * false is an externally-owned account (EOA) and not a contract.
156      *
157      * Among others, `isContract` will return false for the following
158      * types of addresses:
159      *
160      *  - an externally-owned account
161      *  - a contract in construction
162      *  - an address where a contract will be created
163      *  - an address where a contract lived, but was destroyed
164      * ====
165      *
166      * [IMPORTANT]
167      * ====
168      * You shouldn't rely on `isContract` to protect against flash loan attacks!
169      *
170      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
171      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
172      * constructor.
173      * ====
174      */
175     function isContract(address account) internal view returns (bool) {
176         // This method relies on extcodesize/address.code.length, which returns 0
177         // for contracts in construction, since the code is only stored at the end
178         // of the constructor execution.
179 
180         return account.code.length > 0;
181     }
182 
183     /**
184      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
185      * `recipient`, forwarding all available gas and reverting on errors.
186      *
187      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
188      * of certain opcodes, possibly making contracts go over the 2300 gas limit
189      * imposed by `transfer`, making them unable to receive funds via
190      * `transfer`. {sendValue} removes this limitation.
191      *
192      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
193      *
194      * IMPORTANT: because control is transferred to `recipient`, care must be
195      * taken to not create reentrancy vulnerabilities. Consider using
196      * {ReentrancyGuard} or the
197      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
198      */
199     function sendValue(address payable recipient, uint256 amount) internal {
200         require(address(this).balance >= amount, "Address: insufficient balance");
201 
202         (bool success, ) = recipient.call{value: amount}("");
203         require(success, "Address: unable to send value, recipient may have reverted");
204     }
205 
206     /**
207      * @dev Performs a Solidity function call using a low level `call`. A
208      * plain `call` is an unsafe replacement for a function call: use this
209      * function instead.
210      *
211      * If `target` reverts with a revert reason, it is bubbled up by this
212      * function (like regular Solidity function calls).
213      *
214      * Returns the raw returned data. To convert to the expected return value,
215      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
216      *
217      * Requirements:
218      *
219      * - `target` must be a contract.
220      * - calling `target` with `data` must not revert.
221      *
222      * _Available since v3.1._
223      */
224     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
225         return functionCall(target, data, "Address: low-level call failed");
226     }
227 
228     /**
229      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
230      * `errorMessage` as a fallback revert reason when `target` reverts.
231      *
232      * _Available since v3.1._
233      */
234     function functionCall(
235         address target,
236         bytes memory data,
237         string memory errorMessage
238     ) internal returns (bytes memory) {
239         return functionCallWithValue(target, data, 0, errorMessage);
240     }
241 
242     /**
243      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
244      * but also transferring `value` wei to `target`.
245      *
246      * Requirements:
247      *
248      * - the calling contract must have an ETH balance of at least `value`.
249      * - the called Solidity function must be `payable`.
250      *
251      * _Available since v3.1._
252      */
253     function functionCallWithValue(
254         address target,
255         bytes memory data,
256         uint256 value
257     ) internal returns (bytes memory) {
258         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
263      * with `errorMessage` as a fallback revert reason when `target` reverts.
264      *
265      * _Available since v3.1._
266      */
267     function functionCallWithValue(
268         address target,
269         bytes memory data,
270         uint256 value,
271         string memory errorMessage
272     ) internal returns (bytes memory) {
273         require(address(this).balance >= value, "Address: insufficient balance for call");
274         require(isContract(target), "Address: call to non-contract");
275 
276         (bool success, bytes memory returndata) = target.call{value: value}(data);
277         return verifyCallResult(success, returndata, errorMessage);
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
282      * but performing a static call.
283      *
284      * _Available since v3.3._
285      */
286     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
287         return functionStaticCall(target, data, "Address: low-level static call failed");
288     }
289 
290     /**
291      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
292      * but performing a static call.
293      *
294      * _Available since v3.3._
295      */
296     function functionStaticCall(
297         address target,
298         bytes memory data,
299         string memory errorMessage
300     ) internal view returns (bytes memory) {
301         require(isContract(target), "Address: static call to non-contract");
302 
303         (bool success, bytes memory returndata) = target.staticcall(data);
304         return verifyCallResult(success, returndata, errorMessage);
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
309      * but performing a delegate call.
310      *
311      * _Available since v3.4._
312      */
313     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
314         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
319      * but performing a delegate call.
320      *
321      * _Available since v3.4._
322      */
323     function functionDelegateCall(
324         address target,
325         bytes memory data,
326         string memory errorMessage
327     ) internal returns (bytes memory) {
328         require(isContract(target), "Address: delegate call to non-contract");
329 
330         (bool success, bytes memory returndata) = target.delegatecall(data);
331         return verifyCallResult(success, returndata, errorMessage);
332     }
333 
334     /**
335      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
336      * revert reason using the provided one.
337      *
338      * _Available since v4.3._
339      */
340     function verifyCallResult(
341         bool success,
342         bytes memory returndata,
343         string memory errorMessage
344     ) internal pure returns (bytes memory) {
345         if (success) {
346             return returndata;
347         } else {
348             // Look for revert reason and bubble it up if present
349             if (returndata.length > 0) {
350                 // The easiest way to bubble the revert reason is using memory via assembly
351 
352                 assembly {
353                     let returndata_size := mload(returndata)
354                     revert(add(32, returndata), returndata_size)
355                 }
356             } else {
357                 revert(errorMessage);
358             }
359         }
360     }
361 }
362 
363 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
364 
365 
366 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
367 
368 pragma solidity ^0.8.0;
369 
370 /**
371  * @title ERC721 token receiver interface
372  * @dev Interface for any contract that wants to support safeTransfers
373  * from ERC721 asset contracts.
374  */
375 interface IERC721Receiver {
376     /**
377      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
378      * by `operator` from `from`, this function is called.
379      *
380      * It must return its Solidity selector to confirm the token transfer.
381      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
382      *
383      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
384      */
385     function onERC721Received(
386         address operator,
387         address from,
388         uint256 tokenId,
389         bytes calldata data
390     ) external returns (bytes4);
391 }
392 
393 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
394 
395 
396 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
397 
398 pragma solidity ^0.8.0;
399 
400 /**
401  * @dev Interface of the ERC165 standard, as defined in the
402  * https://eips.ethereum.org/EIPS/eip-165[EIP].
403  *
404  * Implementers can declare support of contract interfaces, which can then be
405  * queried by others ({ERC165Checker}).
406  *
407  * For an implementation, see {ERC165}.
408  */
409 interface IERC165 {
410     /**
411      * @dev Returns true if this contract implements the interface defined by
412      * `interfaceId`. See the corresponding
413      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
414      * to learn more about how these ids are created.
415      *
416      * This function call must use less than 30 000 gas.
417      */
418     function supportsInterface(bytes4 interfaceId) external view returns (bool);
419 }
420 
421 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
422 
423 
424 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
425 
426 pragma solidity ^0.8.0;
427 
428 
429 /**
430  * @dev Implementation of the {IERC165} interface.
431  *
432  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
433  * for the additional interface id that will be supported. For example:
434  *
435  * ```solidity
436  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
437  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
438  * }
439  * ```
440  *
441  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
442  */
443 abstract contract ERC165 is IERC165 {
444     /**
445      * @dev See {IERC165-supportsInterface}.
446      */
447     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
448         return interfaceId == type(IERC165).interfaceId;
449     }
450 }
451 
452 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
453 
454 
455 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
456 
457 pragma solidity ^0.8.0;
458 
459 
460 /**
461  * @dev Required interface of an ERC721 compliant contract.
462  */
463 interface IERC721 is IERC165 {
464     /**
465      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
466      */
467     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
468 
469     /**
470      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
471      */
472     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
473 
474     /**
475      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
476      */
477     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
478 
479     /**
480      * @dev Returns the number of tokens in ``owner``'s account.
481      */
482     function balanceOf(address owner) external view returns (uint256 balance);
483 
484     /**
485      * @dev Returns the owner of the `tokenId` token.
486      *
487      * Requirements:
488      *
489      * - `tokenId` must exist.
490      */
491     function ownerOf(uint256 tokenId) external view returns (address owner);
492 
493     /**
494      * @dev Safely transfers `tokenId` token from `from` to `to`.
495      *
496      * Requirements:
497      *
498      * - `from` cannot be the zero address.
499      * - `to` cannot be the zero address.
500      * - `tokenId` token must exist and be owned by `from`.
501      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
502      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
503      *
504      * Emits a {Transfer} event.
505      */
506     function safeTransferFrom(
507         address from,
508         address to,
509         uint256 tokenId,
510         bytes calldata data
511     ) external;
512 
513     /**
514      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
515      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
516      *
517      * Requirements:
518      *
519      * - `from` cannot be the zero address.
520      * - `to` cannot be the zero address.
521      * - `tokenId` token must exist and be owned by `from`.
522      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
523      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
524      *
525      * Emits a {Transfer} event.
526      */
527     function safeTransferFrom(
528         address from,
529         address to,
530         uint256 tokenId
531     ) external;
532 
533     /**
534      * @dev Transfers `tokenId` token from `from` to `to`.
535      *
536      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
537      *
538      * Requirements:
539      *
540      * - `from` cannot be the zero address.
541      * - `to` cannot be the zero address.
542      * - `tokenId` token must be owned by `from`.
543      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
544      *
545      * Emits a {Transfer} event.
546      */
547     function transferFrom(
548         address from,
549         address to,
550         uint256 tokenId
551     ) external;
552 
553     /**
554      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
555      * The approval is cleared when the token is transferred.
556      *
557      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
558      *
559      * Requirements:
560      *
561      * - The caller must own the token or be an approved operator.
562      * - `tokenId` must exist.
563      *
564      * Emits an {Approval} event.
565      */
566     function approve(address to, uint256 tokenId) external;
567 
568     /**
569      * @dev Approve or remove `operator` as an operator for the caller.
570      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
571      *
572      * Requirements:
573      *
574      * - The `operator` cannot be the caller.
575      *
576      * Emits an {ApprovalForAll} event.
577      */
578     function setApprovalForAll(address operator, bool _approved) external;
579 
580     /**
581      * @dev Returns the account approved for `tokenId` token.
582      *
583      * Requirements:
584      *
585      * - `tokenId` must exist.
586      */
587     function getApproved(uint256 tokenId) external view returns (address operator);
588 
589     /**
590      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
591      *
592      * See {setApprovalForAll}
593      */
594     function isApprovedForAll(address owner, address operator) external view returns (bool);
595 }
596 
597 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
598 
599 
600 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
601 
602 pragma solidity ^0.8.0;
603 
604 
605 /**
606  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
607  * @dev See https://eips.ethereum.org/EIPS/eip-721
608  */
609 interface IERC721Metadata is IERC721 {
610     /**
611      * @dev Returns the token collection name.
612      */
613     function name() external view returns (string memory);
614 
615     /**
616      * @dev Returns the token collection symbol.
617      */
618     function symbol() external view returns (string memory);
619 
620     /**
621      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
622      */
623     function tokenURI(uint256 tokenId) external view returns (string memory);
624 }
625 
626 // File: erc721a/contracts/IERC721A.sol
627 
628 
629 // ERC721A Contracts v3.3.0
630 // Creator: Chiru Labs
631 
632 pragma solidity ^0.8.4;
633 
634 
635 
636 /**
637  * @dev Interface of an ERC721A compliant contract.
638  */
639 interface IERC721A is IERC721, IERC721Metadata {
640     /**
641      * The caller must own the token or be an approved operator.
642      */
643     error ApprovalCallerNotOwnerNorApproved();
644 
645     /**
646      * The token does not exist.
647      */
648     error ApprovalQueryForNonexistentToken();
649 
650     /**
651      * The caller cannot approve to their own address.
652      */
653     error ApproveToCaller();
654 
655     /**
656      * The caller cannot approve to the current owner.
657      */
658     error ApprovalToCurrentOwner();
659 
660     /**
661      * Cannot query the balance for the zero address.
662      */
663     error BalanceQueryForZeroAddress();
664 
665     /**
666      * Cannot mint to the zero address.
667      */
668     error MintToZeroAddress();
669 
670     /**
671      * The quantity of tokens minted must be more than zero.
672      */
673     error MintZeroQuantity();
674 
675     /**
676      * The token does not exist.
677      */
678     error OwnerQueryForNonexistentToken();
679 
680     /**
681      * The caller must own the token or be an approved operator.
682      */
683     error TransferCallerNotOwnerNorApproved();
684 
685     /**
686      * The token must be owned by `from`.
687      */
688     error TransferFromIncorrectOwner();
689 
690     /**
691      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
692      */
693     error TransferToNonERC721ReceiverImplementer();
694 
695     /**
696      * Cannot transfer to the zero address.
697      */
698     error TransferToZeroAddress();
699 
700     /**
701      * The token does not exist.
702      */
703     error URIQueryForNonexistentToken();
704 
705     // Compiler will pack this into a single 256bit word.
706     struct TokenOwnership {
707         // The address of the owner.
708         address addr;
709         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
710         uint64 startTimestamp;
711         // Whether the token has been burned.
712         bool burned;
713     }
714 
715     // Compiler will pack this into a single 256bit word.
716     struct AddressData {
717         // Realistically, 2**64-1 is more than enough.
718         uint64 balance;
719         // Keeps track of mint count with minimal overhead for tokenomics.
720         uint64 numberMinted;
721         // Keeps track of burn count with minimal overhead for tokenomics.
722         uint64 numberBurned;
723         // For miscellaneous variable(s) pertaining to the address
724         // (e.g. number of whitelist mint slots used).
725         // If there are multiple variables, please pack them into a uint64.
726         uint64 aux;
727     }
728 
729     /**
730      * @dev Returns the total amount of tokens stored by the contract.
731      * 
732      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
733      */
734     function totalSupply() external view returns (uint256);
735 }
736 
737 // File: @openzeppelin/contracts/utils/Context.sol
738 
739 
740 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
741 
742 pragma solidity ^0.8.0;
743 
744 /**
745  * @dev Provides information about the current execution context, including the
746  * sender of the transaction and its data. While these are generally available
747  * via msg.sender and msg.data, they should not be accessed in such a direct
748  * manner, since when dealing with meta-transactions the account sending and
749  * paying for execution may not be the actual sender (as far as an application
750  * is concerned).
751  *
752  * This contract is only required for intermediate, library-like contracts.
753  */
754 abstract contract Context {
755     function _msgSender() internal view virtual returns (address) {
756         return msg.sender;
757     }
758 
759     function _msgData() internal view virtual returns (bytes calldata) {
760         return msg.data;
761     }
762 }
763 
764 // File: erc721a/contracts/ERC721A.sol
765 
766 
767 // ERC721A Contracts v3.3.0
768 // Creator: Chiru Labs
769 
770 pragma solidity ^0.8.4;
771 
772 
773 
774 
775 
776 
777 
778 /**
779  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
780  * the Metadata extension. Built to optimize for lower gas during batch mints.
781  *
782  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
783  *
784  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
785  *
786  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
787  */
788 contract ERC721A is Context, ERC165, IERC721A {
789     using Address for address;
790     using Strings for uint256;
791 
792     // The tokenId of the next token to be minted.
793     uint256 internal _currentIndex;
794 
795     // The number of tokens burned.
796     uint256 internal _burnCounter;
797 
798     // Token name
799     string private _name;
800 
801     // Token symbol
802     string private _symbol;
803 
804     // Mapping from token ID to ownership details
805     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
806     mapping(uint256 => TokenOwnership) internal _ownerships;
807 
808     // Mapping owner address to address data
809     mapping(address => AddressData) private _addressData;
810 
811     // Mapping from token ID to approved address
812     mapping(uint256 => address) private _tokenApprovals;
813 
814     // Mapping from owner to operator approvals
815     mapping(address => mapping(address => bool)) private _operatorApprovals;
816 
817     constructor(string memory name_, string memory symbol_) {
818         _name = name_;
819         _symbol = symbol_;
820         _currentIndex = _startTokenId();
821     }
822 
823     /**
824      * To change the starting tokenId, please override this function.
825      */
826     function _startTokenId() internal view virtual returns (uint256) {
827         return 0;
828     }
829 
830     /**
831      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
832      */
833     function totalSupply() public view override returns (uint256) {
834         // Counter underflow is impossible as _burnCounter cannot be incremented
835         // more than _currentIndex - _startTokenId() times
836         unchecked {
837             return _currentIndex - _burnCounter - _startTokenId();
838         }
839     }
840 
841     /**
842      * Returns the total amount of tokens minted in the contract.
843      */
844     function _totalMinted() internal view returns (uint256) {
845         // Counter underflow is impossible as _currentIndex does not decrement,
846         // and it is initialized to _startTokenId()
847         unchecked {
848             return _currentIndex - _startTokenId();
849         }
850     }
851 
852     /**
853      * @dev See {IERC165-supportsInterface}.
854      */
855     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
856         return
857             interfaceId == type(IERC721).interfaceId ||
858             interfaceId == type(IERC721Metadata).interfaceId ||
859             super.supportsInterface(interfaceId);
860     }
861 
862     /**
863      * @dev See {IERC721-balanceOf}.
864      */
865     function balanceOf(address owner) public view override returns (uint256) {
866         if (owner == address(0)) revert BalanceQueryForZeroAddress();
867         return uint256(_addressData[owner].balance);
868     }
869 
870     /**
871      * Returns the number of tokens minted by `owner`.
872      */
873     function _numberMinted(address owner) internal view returns (uint256) {
874         return uint256(_addressData[owner].numberMinted);
875     }
876 
877     /**
878      * Returns the number of tokens burned by or on behalf of `owner`.
879      */
880     function _numberBurned(address owner) internal view returns (uint256) {
881         return uint256(_addressData[owner].numberBurned);
882     }
883 
884     /**
885      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
886      */
887     function _getAux(address owner) internal view returns (uint64) {
888         return _addressData[owner].aux;
889     }
890 
891     /**
892      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
893      * If there are multiple variables, please pack them into a uint64.
894      */
895     function _setAux(address owner, uint64 aux) internal {
896         _addressData[owner].aux = aux;
897     }
898 
899     /**
900      * Gas spent here starts off proportional to the maximum mint batch size.
901      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
902      */
903     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
904         uint256 curr = tokenId;
905 
906         unchecked {
907             if (_startTokenId() <= curr) if (curr < _currentIndex) {
908                 TokenOwnership memory ownership = _ownerships[curr];
909                 if (!ownership.burned) {
910                     if (ownership.addr != address(0)) {
911                         return ownership;
912                     }
913                     // Invariant:
914                     // There will always be an ownership that has an address and is not burned
915                     // before an ownership that does not have an address and is not burned.
916                     // Hence, curr will not underflow.
917                     while (true) {
918                         curr--;
919                         ownership = _ownerships[curr];
920                         if (ownership.addr != address(0)) {
921                             return ownership;
922                         }
923                     }
924                 }
925             }
926         }
927         revert OwnerQueryForNonexistentToken();
928     }
929 
930     /**
931      * @dev See {IERC721-ownerOf}.
932      */
933     function ownerOf(uint256 tokenId) public view override returns (address) {
934         return _ownershipOf(tokenId).addr;
935     }
936 
937     /**
938      * @dev See {IERC721Metadata-name}.
939      */
940     function name() public view virtual override returns (string memory) {
941         return _name;
942     }
943 
944     /**
945      * @dev See {IERC721Metadata-symbol}.
946      */
947     function symbol() public view virtual override returns (string memory) {
948         return _symbol;
949     }
950 
951     /**
952      * @dev See {IERC721Metadata-tokenURI}.
953      */
954     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
955         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
956 
957         string memory baseURI = _baseURI();
958         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
959     }
960 
961     /**
962      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
963      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
964      * by default, can be overriden in child contracts.
965      */
966     function _baseURI() internal view virtual returns (string memory) {
967         return '';
968     }
969 
970     /**
971      * @dev See {IERC721-approve}.
972      */
973     function approve(address to, uint256 tokenId) public override {
974         address owner = ERC721A.ownerOf(tokenId);
975         if (to == owner) revert ApprovalToCurrentOwner();
976 
977         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
978             revert ApprovalCallerNotOwnerNorApproved();
979         }
980 
981         _approve(to, tokenId, owner);
982     }
983 
984     /**
985      * @dev See {IERC721-getApproved}.
986      */
987     function getApproved(uint256 tokenId) public view override returns (address) {
988         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
989 
990         return _tokenApprovals[tokenId];
991     }
992 
993     /**
994      * @dev See {IERC721-setApprovalForAll}.
995      */
996     function setApprovalForAll(address operator, bool approved) public virtual override {
997         if (operator == _msgSender()) revert ApproveToCaller();
998 
999         _operatorApprovals[_msgSender()][operator] = approved;
1000         emit ApprovalForAll(_msgSender(), operator, approved);
1001     }
1002 
1003     /**
1004      * @dev See {IERC721-isApprovedForAll}.
1005      */
1006     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1007         return _operatorApprovals[owner][operator];
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-transferFrom}.
1012      */
1013     function transferFrom(
1014         address from,
1015         address to,
1016         uint256 tokenId
1017     ) public virtual override {
1018         _transfer(from, to, tokenId);
1019     }
1020 
1021     /**
1022      * @dev See {IERC721-safeTransferFrom}.
1023      */
1024     function safeTransferFrom(
1025         address from,
1026         address to,
1027         uint256 tokenId
1028     ) public virtual override {
1029         safeTransferFrom(from, to, tokenId, '');
1030     }
1031 
1032     /**
1033      * @dev See {IERC721-safeTransferFrom}.
1034      */
1035     function safeTransferFrom(
1036         address from,
1037         address to,
1038         uint256 tokenId,
1039         bytes memory _data
1040     ) public virtual override {
1041         _transfer(from, to, tokenId);
1042         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1043             revert TransferToNonERC721ReceiverImplementer();
1044         }
1045     }
1046 
1047     /**
1048      * @dev Returns whether `tokenId` exists.
1049      *
1050      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1051      *
1052      * Tokens start existing when they are minted (`_mint`),
1053      */
1054     function _exists(uint256 tokenId) internal view returns (bool) {
1055         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1056     }
1057 
1058     /**
1059      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1060      */
1061     function _safeMint(address to, uint256 quantity) internal {
1062         _safeMint(to, quantity, '');
1063     }
1064 
1065     /**
1066      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1067      *
1068      * Requirements:
1069      *
1070      * - If `to` refers to a smart contract, it must implement
1071      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1072      * - `quantity` must be greater than 0.
1073      *
1074      * Emits a {Transfer} event.
1075      */
1076     function _safeMint(
1077         address to,
1078         uint256 quantity,
1079         bytes memory _data
1080     ) internal {
1081         uint256 startTokenId = _currentIndex;
1082         if (to == address(0)) revert MintToZeroAddress();
1083         if (quantity == 0) revert MintZeroQuantity();
1084 
1085         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1086 
1087         // Overflows are incredibly unrealistic.
1088         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1089         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1090         unchecked {
1091             _addressData[to].balance += uint64(quantity);
1092             _addressData[to].numberMinted += uint64(quantity);
1093 
1094             _ownerships[startTokenId].addr = to;
1095             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1096 
1097             uint256 updatedIndex = startTokenId;
1098             uint256 end = updatedIndex + quantity;
1099 
1100             if (to.isContract()) {
1101                 do {
1102                     emit Transfer(address(0), to, updatedIndex);
1103                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1104                         revert TransferToNonERC721ReceiverImplementer();
1105                     }
1106                 } while (updatedIndex < end);
1107                 // Reentrancy protection
1108                 if (_currentIndex != startTokenId) revert();
1109             } else {
1110                 do {
1111                     emit Transfer(address(0), to, updatedIndex++);
1112                 } while (updatedIndex < end);
1113             }
1114             _currentIndex = updatedIndex;
1115         }
1116         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1117     }
1118 
1119     /**
1120      * @dev Mints `quantity` tokens and transfers them to `to`.
1121      *
1122      * Requirements:
1123      *
1124      * - `to` cannot be the zero address.
1125      * - `quantity` must be greater than 0.
1126      *
1127      * Emits a {Transfer} event.
1128      */
1129     function _mint(address to, uint256 quantity) internal {
1130         uint256 startTokenId = _currentIndex;
1131         if (to == address(0)) revert MintToZeroAddress();
1132         if (quantity == 0) revert MintZeroQuantity();
1133 
1134         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1135 
1136         // Overflows are incredibly unrealistic.
1137         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1138         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1139         unchecked {
1140             _addressData[to].balance += uint64(quantity);
1141             _addressData[to].numberMinted += uint64(quantity);
1142 
1143             _ownerships[startTokenId].addr = to;
1144             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1145 
1146             uint256 updatedIndex = startTokenId;
1147             uint256 end = updatedIndex + quantity;
1148 
1149             do {
1150                 emit Transfer(address(0), to, updatedIndex++);
1151             } while (updatedIndex < end);
1152 
1153             _currentIndex = updatedIndex;
1154         }
1155         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1156     }
1157 
1158     /**
1159      * @dev Transfers `tokenId` from `from` to `to`.
1160      *
1161      * Requirements:
1162      *
1163      * - `to` cannot be the zero address.
1164      * - `tokenId` token must be owned by `from`.
1165      *
1166      * Emits a {Transfer} event.
1167      */
1168     function _transfer(
1169         address from,
1170         address to,
1171         uint256 tokenId
1172     ) private {
1173         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1174 
1175         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1176 
1177         bool isApprovedOrOwner = (_msgSender() == from ||
1178             isApprovedForAll(from, _msgSender()) ||
1179             getApproved(tokenId) == _msgSender());
1180 
1181         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1182         if (to == address(0)) revert TransferToZeroAddress();
1183 
1184         _beforeTokenTransfers(from, to, tokenId, 1);
1185 
1186         // Clear approvals from the previous owner
1187         _approve(address(0), tokenId, from);
1188 
1189         // Underflow of the sender's balance is impossible because we check for
1190         // ownership above and the recipient's balance can't realistically overflow.
1191         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1192         unchecked {
1193             _addressData[from].balance -= 1;
1194             _addressData[to].balance += 1;
1195 
1196             TokenOwnership storage currSlot = _ownerships[tokenId];
1197             currSlot.addr = to;
1198             currSlot.startTimestamp = uint64(block.timestamp);
1199 
1200             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1201             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1202             uint256 nextTokenId = tokenId + 1;
1203             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1204             if (nextSlot.addr == address(0)) {
1205                 // This will suffice for checking _exists(nextTokenId),
1206                 // as a burned slot cannot contain the zero address.
1207                 if (nextTokenId != _currentIndex) {
1208                     nextSlot.addr = from;
1209                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1210                 }
1211             }
1212         }
1213 
1214         emit Transfer(from, to, tokenId);
1215         _afterTokenTransfers(from, to, tokenId, 1);
1216     }
1217 
1218     /**
1219      * @dev Equivalent to `_burn(tokenId, false)`.
1220      */
1221     function _burn(uint256 tokenId) internal virtual {
1222         _burn(tokenId, false);
1223     }
1224 
1225     /**
1226      * @dev Destroys `tokenId`.
1227      * The approval is cleared when the token is burned.
1228      *
1229      * Requirements:
1230      *
1231      * - `tokenId` must exist.
1232      *
1233      * Emits a {Transfer} event.
1234      */
1235     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1236         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1237 
1238         address from = prevOwnership.addr;
1239 
1240         if (approvalCheck) {
1241             bool isApprovedOrOwner = (_msgSender() == from ||
1242                 isApprovedForAll(from, _msgSender()) ||
1243                 getApproved(tokenId) == _msgSender());
1244 
1245             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1246         }
1247 
1248         _beforeTokenTransfers(from, address(0), tokenId, 1);
1249 
1250         // Clear approvals from the previous owner
1251         _approve(address(0), tokenId, from);
1252 
1253         // Underflow of the sender's balance is impossible because we check for
1254         // ownership above and the recipient's balance can't realistically overflow.
1255         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1256         unchecked {
1257             AddressData storage addressData = _addressData[from];
1258             addressData.balance -= 1;
1259             addressData.numberBurned += 1;
1260 
1261             // Keep track of who burned the token, and the timestamp of burning.
1262             TokenOwnership storage currSlot = _ownerships[tokenId];
1263             currSlot.addr = from;
1264             currSlot.startTimestamp = uint64(block.timestamp);
1265             currSlot.burned = true;
1266 
1267             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1268             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1269             uint256 nextTokenId = tokenId + 1;
1270             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1271             if (nextSlot.addr == address(0)) {
1272                 // This will suffice for checking _exists(nextTokenId),
1273                 // as a burned slot cannot contain the zero address.
1274                 if (nextTokenId != _currentIndex) {
1275                     nextSlot.addr = from;
1276                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1277                 }
1278             }
1279         }
1280 
1281         emit Transfer(from, address(0), tokenId);
1282         _afterTokenTransfers(from, address(0), tokenId, 1);
1283 
1284         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1285         unchecked {
1286             _burnCounter++;
1287         }
1288     }
1289 
1290     /**
1291      * @dev Approve `to` to operate on `tokenId`
1292      *
1293      * Emits a {Approval} event.
1294      */
1295     function _approve(
1296         address to,
1297         uint256 tokenId,
1298         address owner
1299     ) private {
1300         _tokenApprovals[tokenId] = to;
1301         emit Approval(owner, to, tokenId);
1302     }
1303 
1304     /**
1305      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1306      *
1307      * @param from address representing the previous owner of the given token ID
1308      * @param to target address that will receive the tokens
1309      * @param tokenId uint256 ID of the token to be transferred
1310      * @param _data bytes optional data to send along with the call
1311      * @return bool whether the call correctly returned the expected magic value
1312      */
1313     function _checkContractOnERC721Received(
1314         address from,
1315         address to,
1316         uint256 tokenId,
1317         bytes memory _data
1318     ) private returns (bool) {
1319         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1320             return retval == IERC721Receiver(to).onERC721Received.selector;
1321         } catch (bytes memory reason) {
1322             if (reason.length == 0) {
1323                 revert TransferToNonERC721ReceiverImplementer();
1324             } else {
1325                 assembly {
1326                     revert(add(32, reason), mload(reason))
1327                 }
1328             }
1329         }
1330     }
1331 
1332     /**
1333      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1334      * And also called before burning one token.
1335      *
1336      * startTokenId - the first token id to be transferred
1337      * quantity - the amount to be transferred
1338      *
1339      * Calling conditions:
1340      *
1341      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1342      * transferred to `to`.
1343      * - When `from` is zero, `tokenId` will be minted for `to`.
1344      * - When `to` is zero, `tokenId` will be burned by `from`.
1345      * - `from` and `to` are never both zero.
1346      */
1347     function _beforeTokenTransfers(
1348         address from,
1349         address to,
1350         uint256 startTokenId,
1351         uint256 quantity
1352     ) internal virtual {}
1353 
1354     /**
1355      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1356      * minting.
1357      * And also called after one token has been burned.
1358      *
1359      * startTokenId - the first token id to be transferred
1360      * quantity - the amount to be transferred
1361      *
1362      * Calling conditions:
1363      *
1364      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1365      * transferred to `to`.
1366      * - When `from` is zero, `tokenId` has been minted for `to`.
1367      * - When `to` is zero, `tokenId` has been burned by `from`.
1368      * - `from` and `to` are never both zero.
1369      */
1370     function _afterTokenTransfers(
1371         address from,
1372         address to,
1373         uint256 startTokenId,
1374         uint256 quantity
1375     ) internal virtual {}
1376 }
1377 
1378 // File: @openzeppelin/contracts/access/Ownable.sol
1379 
1380 
1381 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1382 
1383 pragma solidity ^0.8.0;
1384 
1385 
1386 /**
1387  * @dev Contract module which provides a basic access control mechanism, where
1388  * there is an account (an owner) that can be granted exclusive access to
1389  * specific functions.
1390  *
1391  * By default, the owner account will be the one that deploys the contract. This
1392  * can later be changed with {transferOwnership}.
1393  *
1394  * This module is used through inheritance. It will make available the modifier
1395  * `onlyOwner`, which can be applied to your functions to restrict their use to
1396  * the owner.
1397  */
1398 abstract contract Ownable is Context {
1399     address private _owner;
1400 
1401     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1402 
1403     /**
1404      * @dev Initializes the contract setting the deployer as the initial owner.
1405      */
1406     constructor() {
1407         _transferOwnership(_msgSender());
1408     }
1409 
1410     /**
1411      * @dev Returns the address of the current owner.
1412      */
1413     function owner() public view virtual returns (address) {
1414         return _owner;
1415     }
1416 
1417     /**
1418      * @dev Throws if called by any account other than the owner.
1419      */
1420     modifier onlyOwner() {
1421         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1422         _;
1423     }
1424 
1425     /**
1426      * @dev Leaves the contract without owner. It will not be possible to call
1427      * `onlyOwner` functions anymore. Can only be called by the current owner.
1428      *
1429      * NOTE: Renouncing ownership will leave the contract without an owner,
1430      * thereby removing any functionality that is only available to the owner.
1431      */
1432     function renounceOwnership() public virtual onlyOwner {
1433         _transferOwnership(address(0));
1434     }
1435 
1436     /**
1437      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1438      * Can only be called by the current owner.
1439      */
1440     function transferOwnership(address newOwner) public virtual onlyOwner {
1441         require(newOwner != address(0), "Ownable: new owner is the zero address");
1442         _transferOwnership(newOwner);
1443     }
1444 
1445     /**
1446      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1447      * Internal function without access restriction.
1448      */
1449     function _transferOwnership(address newOwner) internal virtual {
1450         address oldOwner = _owner;
1451         _owner = newOwner;
1452         emit OwnershipTransferred(oldOwner, newOwner);
1453     }
1454 }
1455 
1456 
1457 
1458 pragma solidity ^0.8.0;
1459 
1460 
1461 
1462 contract $8x8pes is ERC721A, Ownable {
1463     bytes32 public root;
1464 	using Strings for uint;
1465 
1466 	uint public constant MINT_PRICE = 0 ether;
1467 	uint public constant MAX_NFT_PER_TRAN = 1;
1468     uint public constant MAX_PER_WALLET = 1;
1469     uint public MAX_FREE_MINT = 1;
1470 	uint public maxSupply = 888;
1471 
1472 	bool public isPublicMint = false;
1473     bool public isWhitelistMint = false;
1474     bool public isMetadataFinal;
1475     string private _baseURL;
1476 	string public prerevealURL = '';
1477 	mapping(address => uint) private _walletMintedCount;
1478 
1479     // Name
1480 	constructor()
1481 	ERC721A('8x8pes', '8X8PE') {
1482     }
1483 
1484 	function _baseURI() internal view override returns (string memory) {
1485 		return _baseURL;
1486 	}
1487 
1488 	function _startTokenId() internal pure override returns (uint) {
1489 		return 1;
1490 	}
1491 
1492 	function contractURI() public pure returns (string memory) {
1493 		return "";
1494 	}
1495 
1496     function finalizeMetadata() external onlyOwner {
1497         isMetadataFinal = true;
1498     }
1499 
1500 	function reveal(string memory url) external onlyOwner {
1501         require(!isMetadataFinal, "Metadata is finalized");
1502 		_baseURL = url;
1503 	}
1504 
1505     function mintedCount(address owner) external view returns (uint) {
1506         return _walletMintedCount[owner];
1507     }
1508 
1509     function setRoot(bytes32 _root) external onlyOwner {
1510 		root = _root;
1511 	}
1512 
1513 	function setPublicState(bool value) external onlyOwner {
1514 		isPublicMint = value;
1515 	}
1516 
1517     function setWhitelistState(bool value) external onlyOwner {
1518 		isWhitelistMint = value;
1519 	}
1520 
1521     /*
1522     // Splitter
1523     
1524     function withdraw() public onlyOwner {
1525         uint256 balance = address(this).balance;
1526 
1527         address _wallet1 = 0x130752003Cc8a51C34247794580C07b8862B5d3C;
1528         uint _payable1 = balance * 50 / 100;
1529         payable(_wallet1).transfer(_payable1);
1530 
1531         address _wallet2 = 0x130752003Cc8a51C34247794580C07b8862B5d3C;
1532         uint _payable2 = balance * 25 / 100;
1533         payable(_wallet2).transfer(_payable2);
1534 
1535         address _wallet3 = 0x130752003Cc8a51C34247794580C07b8862B5d3C;
1536         uint _payable3 = balance * 25 / 100;
1537         payable(_wallet3).transfer(_payable3);
1538     }*/
1539 
1540     function withdraw() public onlyOwner {
1541         uint256 balance = address(this).balance;
1542         payable(msg.sender).transfer(balance);
1543     }
1544 
1545 	function reserveMint(address to, uint count) external onlyOwner {
1546 		require(
1547 			_totalMinted() + count <= maxSupply,
1548 			'Exceeds max supply'
1549 		);
1550 		_safeMint(to, count);
1551 	}
1552 
1553 	function reduceSupply(uint newMaxSupply) external onlyOwner {
1554 		maxSupply = newMaxSupply;
1555 	}
1556 
1557     function setNumFreeMints(uint newFreeMints) external onlyOwner {
1558 		MAX_FREE_MINT = newFreeMints;
1559 	}
1560 
1561 	function tokenURI(uint tokenId)
1562 		public
1563 		view
1564 		override
1565 		returns (string memory)
1566 	{
1567         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1568 
1569         return bytes(_baseURI()).length > 0 
1570             ? string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"))
1571             : prerevealURL;
1572 	}
1573 
1574 	function isValid(bytes32[] memory proof, bytes32 leaf) public view returns (bool) {
1575         return MerkleProof.verify(proof, root, leaf);
1576     }
1577     
1578     function freeMint(uint count) external payable {
1579 		require(isPublicMint, "Public mint has not started");
1580 		require(count <= MAX_NFT_PER_TRAN,'Exceeds NFT per transaction limit');
1581 		require(_totalMinted() + count <= maxSupply,'Exceeds max supply');
1582         require(_walletMintedCount[msg.sender] + count <= MAX_PER_WALLET,'Exceeds max per wallet');
1583 
1584         uint payForCount = count;
1585         uint mintedSoFar = _walletMintedCount[msg.sender];
1586         
1587         //1 Free Mints Default
1588         uint maxFree = MAX_FREE_MINT;
1589 
1590         if(mintedSoFar < maxFree) {
1591             uint remainingFreeMints = maxFree - mintedSoFar;
1592             if(count > remainingFreeMints) {
1593                 payForCount = count - remainingFreeMints;
1594             }
1595             else {
1596                 payForCount = 0;
1597             }
1598         }
1599 
1600 		require(
1601 			msg.value >= payForCount * MINT_PRICE,
1602 			'Ether value sent is not sufficient'
1603 		);
1604 
1605 		_walletMintedCount[msg.sender] += count;
1606 		_safeMint(msg.sender, count);
1607 	}
1608 }