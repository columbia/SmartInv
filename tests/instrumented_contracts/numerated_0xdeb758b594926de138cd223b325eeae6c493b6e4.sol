1 // SPDX-License-Identifier: MIT
2 
3 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/MerkleProof.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev These functions deal with verification of Merkle Trees proofs.
12  *
13  * The proofs can be generated using the JavaScript library
14  * https://github.com/miguelmota/merkletreejs[merkletreejs].
15  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
16  *
17  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
18  *
19  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
20  * hashing, or use a hash function other than keccak256 for hashing leaves.
21  * This is because the concatenation of a sorted pair of internal nodes in
22  * the merkle tree could be reinterpreted as a leaf value.
23  */
24 library MerkleProof {
25     /**
26      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
27      * defined by `root`. For this, a `proof` must be provided, containing
28      * sibling hashes on the branch from the leaf to the root of the tree. Each
29      * pair of leaves and each pair of pre-images are assumed to be sorted.
30      */
31     function verify(
32         bytes32[] memory proof,
33         bytes32 root,
34         bytes32 leaf
35     ) internal pure returns (bool) {
36         return processProof(proof, leaf) == root;
37     }
38 
39     /**
40      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
41      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
42      * hash matches the root of the tree. When processing the proof, the pairs
43      * of leafs & pre-images are assumed to be sorted.
44      *
45      * _Available since v4.4._
46      */
47     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
48         bytes32 computedHash = leaf;
49         for (uint256 i = 0; i < proof.length; i++) {
50             bytes32 proofElement = proof[i];
51             if (computedHash <= proofElement) {
52                 // Hash(current computed hash + current element of the proof)
53                 computedHash = _efficientHash(computedHash, proofElement);
54             } else {
55                 // Hash(current element of the proof + current computed hash)
56                 computedHash = _efficientHash(proofElement, computedHash);
57             }
58         }
59         return computedHash;
60     }
61 
62     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
63         assembly {
64             mstore(0x00, a)
65             mstore(0x20, b)
66             value := keccak256(0x00, 0x40)
67         }
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Strings.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev String operations.
80  */
81 library Strings {
82     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
83 
84     /**
85      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
86      */
87     function toString(uint256 value) internal pure returns (string memory) {
88         // Inspired by OraclizeAPI's implementation - MIT licence
89         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
90 
91         if (value == 0) {
92             return "0";
93         }
94         uint256 temp = value;
95         uint256 digits;
96         while (temp != 0) {
97             digits++;
98             temp /= 10;
99         }
100         bytes memory buffer = new bytes(digits);
101         while (value != 0) {
102             digits -= 1;
103             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
104             value /= 10;
105         }
106         return string(buffer);
107     }
108 
109     /**
110      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
111      */
112     function toHexString(uint256 value) internal pure returns (string memory) {
113         if (value == 0) {
114             return "0x00";
115         }
116         uint256 temp = value;
117         uint256 length = 0;
118         while (temp != 0) {
119             length++;
120             temp >>= 8;
121         }
122         return toHexString(value, length);
123     }
124 
125     /**
126      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
127      */
128     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
129         bytes memory buffer = new bytes(2 * length + 2);
130         buffer[0] = "0";
131         buffer[1] = "x";
132         for (uint256 i = 2 * length + 1; i > 1; --i) {
133             buffer[i] = _HEX_SYMBOLS[value & 0xf];
134             value >>= 4;
135         }
136         require(value == 0, "Strings: hex length insufficient");
137         return string(buffer);
138     }
139 }
140 
141 // File: @openzeppelin/contracts/utils/Address.sol
142 
143 
144 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
145 
146 pragma solidity ^0.8.1;
147 
148 /**
149  * @dev Collection of functions related to the address type
150  */
151 library Address {
152     /**
153      * @dev Returns true if `account` is a contract.
154      *
155      * [IMPORTANT]
156      * ====
157      * It is unsafe to assume that an address for which this function returns
158      * false is an externally-owned account (EOA) and not a contract.
159      *
160      * Among others, `isContract` will return false for the following
161      * types of addresses:
162      *
163      *  - an externally-owned account
164      *  - a contract in construction
165      *  - an address where a contract will be created
166      *  - an address where a contract lived, but was destroyed
167      * ====
168      *
169      * [IMPORTANT]
170      * ====
171      * You shouldn't rely on `isContract` to protect against flash loan attacks!
172      *
173      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
174      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
175      * constructor.
176      * ====
177      */
178     function isContract(address account) internal view returns (bool) {
179         // This method relies on extcodesize/address.code.length, which returns 0
180         // for contracts in construction, since the code is only stored at the end
181         // of the constructor execution.
182 
183         return account.code.length > 0;
184     }
185 
186     /**
187      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
188      * `recipient`, forwarding all available gas and reverting on errors.
189      *
190      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
191      * of certain opcodes, possibly making contracts go over the 2300 gas limit
192      * imposed by `transfer`, making them unable to receive funds via
193      * `transfer`. {sendValue} removes this limitation.
194      *
195      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
196      *
197      * IMPORTANT: because control is transferred to `recipient`, care must be
198      * taken to not create reentrancy vulnerabilities. Consider using
199      * {ReentrancyGuard} or the
200      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
201      */
202     function sendValue(address payable recipient, uint256 amount) internal {
203         require(address(this).balance >= amount, "Address: insufficient balance");
204 
205         (bool success, ) = recipient.call{value: amount}("");
206         require(success, "Address: unable to send value, recipient may have reverted");
207     }
208 
209     /**
210      * @dev Performs a Solidity function call using a low level `call`. A
211      * plain `call` is an unsafe replacement for a function call: use this
212      * function instead.
213      *
214      * If `target` reverts with a revert reason, it is bubbled up by this
215      * function (like regular Solidity function calls).
216      *
217      * Returns the raw returned data. To convert to the expected return value,
218      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
219      *
220      * Requirements:
221      *
222      * - `target` must be a contract.
223      * - calling `target` with `data` must not revert.
224      *
225      * _Available since v3.1._
226      */
227     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
228         return functionCall(target, data, "Address: low-level call failed");
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
233      * `errorMessage` as a fallback revert reason when `target` reverts.
234      *
235      * _Available since v3.1._
236      */
237     function functionCall(
238         address target,
239         bytes memory data,
240         string memory errorMessage
241     ) internal returns (bytes memory) {
242         return functionCallWithValue(target, data, 0, errorMessage);
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
247      * but also transferring `value` wei to `target`.
248      *
249      * Requirements:
250      *
251      * - the calling contract must have an ETH balance of at least `value`.
252      * - the called Solidity function must be `payable`.
253      *
254      * _Available since v3.1._
255      */
256     function functionCallWithValue(
257         address target,
258         bytes memory data,
259         uint256 value
260     ) internal returns (bytes memory) {
261         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
262     }
263 
264     /**
265      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
266      * with `errorMessage` as a fallback revert reason when `target` reverts.
267      *
268      * _Available since v3.1._
269      */
270     function functionCallWithValue(
271         address target,
272         bytes memory data,
273         uint256 value,
274         string memory errorMessage
275     ) internal returns (bytes memory) {
276         require(address(this).balance >= value, "Address: insufficient balance for call");
277         require(isContract(target), "Address: call to non-contract");
278 
279         (bool success, bytes memory returndata) = target.call{value: value}(data);
280         return verifyCallResult(success, returndata, errorMessage);
281     }
282 
283     /**
284      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
285      * but performing a static call.
286      *
287      * _Available since v3.3._
288      */
289     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
290         return functionStaticCall(target, data, "Address: low-level static call failed");
291     }
292 
293     /**
294      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
295      * but performing a static call.
296      *
297      * _Available since v3.3._
298      */
299     function functionStaticCall(
300         address target,
301         bytes memory data,
302         string memory errorMessage
303     ) internal view returns (bytes memory) {
304         require(isContract(target), "Address: static call to non-contract");
305 
306         (bool success, bytes memory returndata) = target.staticcall(data);
307         return verifyCallResult(success, returndata, errorMessage);
308     }
309 
310     /**
311      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
312      * but performing a delegate call.
313      *
314      * _Available since v3.4._
315      */
316     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
317         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
322      * but performing a delegate call.
323      *
324      * _Available since v3.4._
325      */
326     function functionDelegateCall(
327         address target,
328         bytes memory data,
329         string memory errorMessage
330     ) internal returns (bytes memory) {
331         require(isContract(target), "Address: delegate call to non-contract");
332 
333         (bool success, bytes memory returndata) = target.delegatecall(data);
334         return verifyCallResult(success, returndata, errorMessage);
335     }
336 
337     /**
338      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
339      * revert reason using the provided one.
340      *
341      * _Available since v4.3._
342      */
343     function verifyCallResult(
344         bool success,
345         bytes memory returndata,
346         string memory errorMessage
347     ) internal pure returns (bytes memory) {
348         if (success) {
349             return returndata;
350         } else {
351             // Look for revert reason and bubble it up if present
352             if (returndata.length > 0) {
353                 // The easiest way to bubble the revert reason is using memory via assembly
354 
355                 assembly {
356                     let returndata_size := mload(returndata)
357                     revert(add(32, returndata), returndata_size)
358                 }
359             } else {
360                 revert(errorMessage);
361             }
362         }
363     }
364 }
365 
366 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
367 
368 
369 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
370 
371 pragma solidity ^0.8.0;
372 
373 /**
374  * @title ERC721 token receiver interface
375  * @dev Interface for any contract that wants to support safeTransfers
376  * from ERC721 asset contracts.
377  */
378 interface IERC721Receiver {
379     /**
380      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
381      * by `operator` from `from`, this function is called.
382      *
383      * It must return its Solidity selector to confirm the token transfer.
384      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
385      *
386      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
387      */
388     function onERC721Received(
389         address operator,
390         address from,
391         uint256 tokenId,
392         bytes calldata data
393     ) external returns (bytes4);
394 }
395 
396 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
397 
398 
399 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
400 
401 pragma solidity ^0.8.0;
402 
403 /**
404  * @dev Interface of the ERC165 standard, as defined in the
405  * https://eips.ethereum.org/EIPS/eip-165[EIP].
406  *
407  * Implementers can declare support of contract interfaces, which can then be
408  * queried by others ({ERC165Checker}).
409  *
410  * For an implementation, see {ERC165}.
411  */
412 interface IERC165 {
413     /**
414      * @dev Returns true if this contract implements the interface defined by
415      * `interfaceId`. See the corresponding
416      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
417      * to learn more about how these ids are created.
418      *
419      * This function call must use less than 30 000 gas.
420      */
421     function supportsInterface(bytes4 interfaceId) external view returns (bool);
422 }
423 
424 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
425 
426 
427 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
428 
429 pragma solidity ^0.8.0;
430 
431 
432 /**
433  * @dev Implementation of the {IERC165} interface.
434  *
435  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
436  * for the additional interface id that will be supported. For example:
437  *
438  * ```solidity
439  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
440  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
441  * }
442  * ```
443  *
444  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
445  */
446 abstract contract ERC165 is IERC165 {
447     /**
448      * @dev See {IERC165-supportsInterface}.
449      */
450     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
451         return interfaceId == type(IERC165).interfaceId;
452     }
453 }
454 
455 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
456 
457 
458 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
459 
460 pragma solidity ^0.8.0;
461 
462 
463 /**
464  * @dev Required interface of an ERC721 compliant contract.
465  */
466 interface IERC721 is IERC165 {
467     /**
468      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
469      */
470     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
471 
472     /**
473      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
474      */
475     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
476 
477     /**
478      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
479      */
480     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
481 
482     /**
483      * @dev Returns the number of tokens in ``owner``'s account.
484      */
485     function balanceOf(address owner) external view returns (uint256 balance);
486 
487     /**
488      * @dev Returns the owner of the `tokenId` token.
489      *
490      * Requirements:
491      *
492      * - `tokenId` must exist.
493      */
494     function ownerOf(uint256 tokenId) external view returns (address owner);
495 
496     /**
497      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
498      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
499      *
500      * Requirements:
501      *
502      * - `from` cannot be the zero address.
503      * - `to` cannot be the zero address.
504      * - `tokenId` token must exist and be owned by `from`.
505      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
506      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
507      *
508      * Emits a {Transfer} event.
509      */
510     function safeTransferFrom(
511         address from,
512         address to,
513         uint256 tokenId
514     ) external;
515 
516     /**
517      * @dev Transfers `tokenId` token from `from` to `to`.
518      *
519      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
520      *
521      * Requirements:
522      *
523      * - `from` cannot be the zero address.
524      * - `to` cannot be the zero address.
525      * - `tokenId` token must be owned by `from`.
526      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
527      *
528      * Emits a {Transfer} event.
529      */
530     function transferFrom(
531         address from,
532         address to,
533         uint256 tokenId
534     ) external;
535 
536     /**
537      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
538      * The approval is cleared when the token is transferred.
539      *
540      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
541      *
542      * Requirements:
543      *
544      * - The caller must own the token or be an approved operator.
545      * - `tokenId` must exist.
546      *
547      * Emits an {Approval} event.
548      */
549     function approve(address to, uint256 tokenId) external;
550 
551     /**
552      * @dev Returns the account approved for `tokenId` token.
553      *
554      * Requirements:
555      *
556      * - `tokenId` must exist.
557      */
558     function getApproved(uint256 tokenId) external view returns (address operator);
559 
560     /**
561      * @dev Approve or remove `operator` as an operator for the caller.
562      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
563      *
564      * Requirements:
565      *
566      * - The `operator` cannot be the caller.
567      *
568      * Emits an {ApprovalForAll} event.
569      */
570     function setApprovalForAll(address operator, bool _approved) external;
571 
572     /**
573      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
574      *
575      * See {setApprovalForAll}
576      */
577     function isApprovedForAll(address owner, address operator) external view returns (bool);
578 
579     /**
580      * @dev Safely transfers `tokenId` token from `from` to `to`.
581      *
582      * Requirements:
583      *
584      * - `from` cannot be the zero address.
585      * - `to` cannot be the zero address.
586      * - `tokenId` token must exist and be owned by `from`.
587      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
588      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
589      *
590      * Emits a {Transfer} event.
591      */
592     function safeTransferFrom(
593         address from,
594         address to,
595         uint256 tokenId,
596         bytes calldata data
597     ) external;
598 }
599 
600 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
601 
602 
603 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
604 
605 pragma solidity ^0.8.0;
606 
607 
608 /**
609  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
610  * @dev See https://eips.ethereum.org/EIPS/eip-721
611  */
612 interface IERC721Metadata is IERC721 {
613     /**
614      * @dev Returns the token collection name.
615      */
616     function name() external view returns (string memory);
617 
618     /**
619      * @dev Returns the token collection symbol.
620      */
621     function symbol() external view returns (string memory);
622 
623     /**
624      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
625      */
626     function tokenURI(uint256 tokenId) external view returns (string memory);
627 }
628 
629 // File: @openzeppelin/contracts/utils/Context.sol
630 
631 
632 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
633 
634 pragma solidity ^0.8.0;
635 
636 /**
637  * @dev Provides information about the current execution context, including the
638  * sender of the transaction and its data. While these are generally available
639  * via msg.sender and msg.data, they should not be accessed in such a direct
640  * manner, since when dealing with meta-transactions the account sending and
641  * paying for execution may not be the actual sender (as far as an application
642  * is concerned).
643  *
644  * This contract is only required for intermediate, library-like contracts.
645  */
646 abstract contract Context {
647     function _msgSender() internal view virtual returns (address) {
648         return msg.sender;
649     }
650 
651     function _msgData() internal view virtual returns (bytes calldata) {
652         return msg.data;
653     }
654 }
655 
656 // File: contracts/erc721a.sol
657 
658 
659 
660 // Creator: Chiru Labs
661 
662 
663 
664 pragma solidity ^0.8.4;
665 
666 
667 
668 
669 
670 
671 
672 
673 
674 
675 error ApprovalCallerNotOwnerNorApproved();
676 
677 error ApprovalQueryForNonexistentToken();
678 
679 error ApproveToCaller();
680 
681 error ApprovalToCurrentOwner();
682 
683 error BalanceQueryForZeroAddress();
684 
685 error MintToZeroAddress();
686 
687 error MintZeroQuantity();
688 
689 error OwnerQueryForNonexistentToken();
690 
691 error TransferCallerNotOwnerNorApproved();
692 
693 error TransferFromIncorrectOwner();
694 
695 error TransferToNonERC721ReceiverImplementer();
696 
697 error TransferToZeroAddress();
698 
699 error URIQueryForNonexistentToken();
700 
701 
702 
703 /**
704 
705  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
706 
707  * the Metadata extension. Built to optimize for lower gas during batch mints.
708 
709  *
710 
711  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
712 
713  *
714 
715  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
716 
717  *
718 
719  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
720 
721  */
722 
723 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
724 
725     using Address for address;
726 
727     using Strings for uint256;
728 
729 
730 
731     // Compiler will pack this into a single 256bit word.
732 
733     struct TokenOwnership {
734 
735         // The address of the owner.
736 
737         address addr;
738 
739         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
740 
741         uint64 startTimestamp;
742 
743         // Whether the token has been burned.
744 
745         bool burned;
746 
747     }
748 
749 
750 
751     // Compiler will pack this into a single 256bit word.
752 
753     struct AddressData {
754 
755         // Realistically, 2**64-1 is more than enough.
756 
757         uint64 balance;
758 
759         // Keeps track of mint count with minimal overhead for tokenomics.
760 
761         uint64 numberMinted;
762 
763         // Keeps track of burn count with minimal overhead for tokenomics.
764 
765         uint64 numberBurned;
766 
767         // For miscellaneous variable(s) pertaining to the address
768 
769         // (e.g. number of whitelist mint slots used).
770 
771         // If there are multiple variables, please pack them into a uint64.
772 
773         uint64 aux;
774 
775     }
776 
777 
778 
779     // The tokenId of the next token to be minted.
780 
781     uint256 internal _currentIndex;
782 
783 
784 
785     // The number of tokens burned.
786 
787     uint256 internal _burnCounter;
788 
789 
790 
791     // Token name
792 
793     string private _name;
794 
795 
796 
797     // Token symbol
798 
799     string private _symbol;
800 
801 
802 
803     // Mapping from token ID to ownership details
804 
805     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
806 
807     mapping(uint256 => TokenOwnership) internal _ownerships;
808 
809 
810 
811     // Mapping owner address to address data
812 
813     mapping(address => AddressData) private _addressData;
814 
815 
816 
817     // Mapping from token ID to approved address
818 
819     mapping(uint256 => address) private _tokenApprovals;
820 
821 
822 
823     // Mapping from owner to operator approvals
824 
825     mapping(address => mapping(address => bool)) private _operatorApprovals;
826 
827 
828 
829     constructor(string memory name_, string memory symbol_) {
830 
831         _name = name_;
832 
833         _symbol = symbol_;
834 
835         _currentIndex = _startTokenId();
836 
837     }
838 
839 
840 
841     /**
842 
843      * To change the starting tokenId, please override this function.
844 
845      */
846 
847     function _startTokenId() internal view virtual returns (uint256) {
848 
849         return 1;
850 
851     }
852 
853 
854 
855     /**
856 
857      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
858 
859      */
860 
861     function totalSupply() public view returns (uint256) {
862 
863         // Counter underflow is impossible as _burnCounter cannot be incremented
864 
865         // more than _currentIndex - _startTokenId() times
866 
867         unchecked {
868 
869             return _currentIndex - _burnCounter - _startTokenId();
870 
871         }
872 
873     }
874 
875 
876 
877     /**
878 
879      * Returns the total amount of tokens minted in the contract.
880 
881      */
882 
883     function _totalMinted() internal view returns (uint256) {
884 
885         // Counter underflow is impossible as _currentIndex does not decrement,
886 
887         // and it is initialized to _startTokenId()
888 
889         unchecked {
890 
891             return _currentIndex - _startTokenId();
892 
893         }
894 
895     }
896 
897 
898 
899     /**
900 
901      * @dev See {IERC165-supportsInterface}.
902 
903      */
904 
905     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
906 
907         return
908 
909             interfaceId == type(IERC721).interfaceId ||
910 
911             interfaceId == type(IERC721Metadata).interfaceId ||
912 
913             super.supportsInterface(interfaceId);
914 
915     }
916 
917 
918 
919     /**
920 
921      * @dev See {IERC721-balanceOf}.
922 
923      */
924 
925     function balanceOf(address owner) public view override returns (uint256) {
926 
927         if (owner == address(0)) revert BalanceQueryForZeroAddress();
928 
929         return uint256(_addressData[owner].balance);
930 
931     }
932 
933 
934 
935     /**
936 
937      * Returns the number of tokens minted by `owner`.
938 
939      */
940 
941     function _numberMinted(address owner) internal view returns (uint256) {
942 
943         return uint256(_addressData[owner].numberMinted);
944 
945     }
946 
947 
948 
949     /**
950 
951      * Returns the number of tokens burned by or on behalf of `owner`.
952 
953      */
954 
955     function _numberBurned(address owner) internal view returns (uint256) {
956 
957         return uint256(_addressData[owner].numberBurned);
958 
959     }
960 
961 
962 
963     /**
964 
965      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
966 
967      */
968 
969     function _getAux(address owner) internal view returns (uint64) {
970 
971         return _addressData[owner].aux;
972 
973     }
974 
975 
976 
977     /**
978 
979      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
980 
981      * If there are multiple variables, please pack them into a uint64.
982 
983      */
984 
985     function _setAux(address owner, uint64 aux) internal {
986 
987         _addressData[owner].aux = aux;
988 
989     }
990 
991 
992 
993     /**
994 
995      * Gas spent here starts off proportional to the maximum mint batch size.
996 
997      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
998 
999      */
1000 
1001     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1002 
1003         uint256 curr = tokenId;
1004 
1005 
1006 
1007         unchecked {
1008 
1009             if (_startTokenId() <= curr && curr < _currentIndex) {
1010 
1011                 TokenOwnership memory ownership = _ownerships[curr];
1012 
1013                 if (!ownership.burned) {
1014 
1015                     if (ownership.addr != address(0)) {
1016 
1017                         return ownership;
1018 
1019                     }
1020 
1021                     // Invariant:
1022 
1023                     // There will always be an ownership that has an address and is not burned
1024 
1025                     // before an ownership that does not have an address and is not burned.
1026 
1027                     // Hence, curr will not underflow.
1028 
1029                     while (true) {
1030 
1031                         curr--;
1032 
1033                         ownership = _ownerships[curr];
1034 
1035                         if (ownership.addr != address(0)) {
1036 
1037                             return ownership;
1038 
1039                         }
1040 
1041                     }
1042 
1043                 }
1044 
1045             }
1046 
1047         }
1048 
1049         revert OwnerQueryForNonexistentToken();
1050 
1051     }
1052 
1053 
1054 
1055     /**
1056 
1057      * @dev See {IERC721-ownerOf}.
1058 
1059      */
1060 
1061     function ownerOf(uint256 tokenId) public view override returns (address) {
1062 
1063         return _ownershipOf(tokenId).addr;
1064 
1065     }
1066 
1067 
1068 
1069     /**
1070 
1071      * @dev See {IERC721Metadata-name}.
1072 
1073      */
1074 
1075     function name() public view virtual override returns (string memory) {
1076 
1077         return _name;
1078 
1079     }
1080 
1081 
1082 
1083     /**
1084 
1085      * @dev See {IERC721Metadata-symbol}.
1086 
1087      */
1088 
1089     function symbol() public view virtual override returns (string memory) {
1090 
1091         return _symbol;
1092 
1093     }
1094 
1095 
1096 
1097     /**
1098 
1099      * @dev See {IERC721Metadata-tokenURI}.
1100 
1101      */
1102 
1103     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1104 
1105         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1106 
1107 
1108 
1109         string memory baseURI = _baseURI();
1110 
1111         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1112 
1113     }
1114 
1115 
1116 
1117     /**
1118 
1119      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1120 
1121      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1122 
1123      * by default, can be overriden in child contracts.
1124 
1125      */
1126 
1127     function _baseURI() internal view virtual returns (string memory) {
1128 
1129         return '';
1130 
1131     }
1132 
1133 
1134 
1135     /**
1136 
1137      * @dev See {IERC721-approve}.
1138 
1139      */
1140 
1141     function approve(address to, uint256 tokenId) public override {
1142 
1143         address owner = ERC721A.ownerOf(tokenId);
1144 
1145         if (to == owner) revert ApprovalToCurrentOwner();
1146 
1147 
1148 
1149         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1150 
1151             revert ApprovalCallerNotOwnerNorApproved();
1152 
1153         }
1154 
1155 
1156 
1157         _approve(to, tokenId, owner);
1158 
1159     }
1160 
1161 
1162 
1163     /**
1164 
1165      * @dev See {IERC721-getApproved}.
1166 
1167      */
1168 
1169     function getApproved(uint256 tokenId) public view override returns (address) {
1170 
1171         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1172 
1173 
1174 
1175         return _tokenApprovals[tokenId];
1176 
1177     }
1178 
1179 
1180 
1181     /**
1182 
1183      * @dev See {IERC721-setApprovalForAll}.
1184 
1185      */
1186 
1187     function setApprovalForAll(address operator, bool approved) public virtual override {
1188 
1189         if (operator == _msgSender()) revert ApproveToCaller();
1190 
1191 
1192 
1193         _operatorApprovals[_msgSender()][operator] = approved;
1194 
1195         emit ApprovalForAll(_msgSender(), operator, approved);
1196 
1197     }
1198 
1199 
1200 
1201     /**
1202 
1203      * @dev See {IERC721-isApprovedForAll}.
1204 
1205      */
1206 
1207     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1208 
1209         return _operatorApprovals[owner][operator];
1210 
1211     }
1212 
1213 
1214 
1215     /**
1216 
1217      * @dev See {IERC721-transferFrom}.
1218 
1219      */
1220 
1221     function transferFrom(
1222 
1223         address from,
1224 
1225         address to,
1226 
1227         uint256 tokenId
1228 
1229     ) public virtual override {
1230 
1231         _transfer(from, to, tokenId);
1232 
1233     }
1234 
1235 
1236 
1237     /**
1238 
1239      * @dev See {IERC721-safeTransferFrom}.
1240 
1241      */
1242 
1243     function safeTransferFrom(
1244 
1245         address from,
1246 
1247         address to,
1248 
1249         uint256 tokenId
1250 
1251     ) public virtual override {
1252 
1253         safeTransferFrom(from, to, tokenId, '');
1254 
1255     }
1256 
1257 
1258 
1259     /**
1260 
1261      * @dev See {IERC721-safeTransferFrom}.
1262 
1263      */
1264 
1265     function safeTransferFrom(
1266 
1267         address from,
1268 
1269         address to,
1270 
1271         uint256 tokenId,
1272 
1273         bytes memory _data
1274 
1275     ) public virtual override {
1276 
1277         _transfer(from, to, tokenId);
1278 
1279         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1280 
1281             revert TransferToNonERC721ReceiverImplementer();
1282 
1283         }
1284 
1285     }
1286 
1287 
1288 
1289     /**
1290 
1291      * @dev Returns whether `tokenId` exists.
1292 
1293      *
1294 
1295      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1296 
1297      *
1298 
1299      * Tokens start existing when they are minted (`_mint`),
1300 
1301      */
1302 
1303     function _exists(uint256 tokenId) internal view returns (bool) {
1304 
1305         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1306 
1307             !_ownerships[tokenId].burned;
1308 
1309     }
1310 
1311 
1312 
1313     function _safeMint(address to, uint256 quantity) internal {
1314 
1315         _safeMint(to, quantity, '');
1316 
1317     }
1318 
1319 
1320 
1321     /**
1322 
1323      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1324 
1325      *
1326 
1327      * Requirements:
1328 
1329      *
1330 
1331      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1332 
1333      * - `quantity` must be greater than 0.
1334 
1335      *
1336 
1337      * Emits a {Transfer} event.
1338 
1339      */
1340 
1341     function _safeMint(
1342 
1343         address to,
1344 
1345         uint256 quantity,
1346 
1347         bytes memory _data
1348 
1349     ) internal {
1350 
1351         _mint(to, quantity, _data, true);
1352 
1353     }
1354 
1355 
1356 
1357     /**
1358 
1359      * @dev Mints `quantity` tokens and transfers them to `to`.
1360 
1361      *
1362 
1363      * Requirements:
1364 
1365      *
1366 
1367      * - `to` cannot be the zero address.
1368 
1369      * - `quantity` must be greater than 0.
1370 
1371      *
1372 
1373      * Emits a {Transfer} event.
1374 
1375      */
1376 
1377     function _mint(
1378 
1379         address to,
1380 
1381         uint256 quantity,
1382 
1383         bytes memory _data,
1384 
1385         bool safe
1386 
1387     ) internal {
1388 
1389         uint256 startTokenId = _currentIndex;
1390 
1391         if (to == address(0)) revert MintToZeroAddress();
1392 
1393         if (quantity == 0) revert MintZeroQuantity();
1394 
1395 
1396 
1397         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1398 
1399 
1400 
1401         // Overflows are incredibly unrealistic.
1402 
1403         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1404 
1405         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1406 
1407         unchecked {
1408 
1409             _addressData[to].balance += uint64(quantity);
1410 
1411             _addressData[to].numberMinted += uint64(quantity);
1412 
1413 
1414 
1415             _ownerships[startTokenId].addr = to;
1416 
1417             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1418 
1419 
1420 
1421             uint256 updatedIndex = startTokenId;
1422 
1423             uint256 end = updatedIndex + quantity;
1424 
1425 
1426 
1427             if (safe && to.isContract()) {
1428 
1429                 do {
1430 
1431                     emit Transfer(address(0), to, updatedIndex);
1432 
1433                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1434 
1435                         revert TransferToNonERC721ReceiverImplementer();
1436 
1437                     }
1438 
1439                 } while (updatedIndex != end);
1440 
1441                 // Reentrancy protection
1442 
1443                 if (_currentIndex != startTokenId) revert();
1444 
1445             } else {
1446 
1447                 do {
1448 
1449                     emit Transfer(address(0), to, updatedIndex++);
1450 
1451                 } while (updatedIndex != end);
1452 
1453             }
1454 
1455             _currentIndex = updatedIndex;
1456 
1457         }
1458 
1459         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1460 
1461     }
1462 
1463 
1464 
1465     /**
1466 
1467      * @dev Transfers `tokenId` from `from` to `to`.
1468 
1469      *
1470 
1471      * Requirements:
1472 
1473      *
1474 
1475      * - `to` cannot be the zero address.
1476 
1477      * - `tokenId` token must be owned by `from`.
1478 
1479      *
1480 
1481      * Emits a {Transfer} event.
1482 
1483      */
1484 
1485     function _transfer(
1486 
1487         address from,
1488 
1489         address to,
1490 
1491         uint256 tokenId
1492 
1493     ) private {
1494 
1495         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1496 
1497 
1498 
1499         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1500 
1501 
1502 
1503         bool isApprovedOrOwner = (_msgSender() == from ||
1504 
1505             isApprovedForAll(from, _msgSender()) ||
1506 
1507             getApproved(tokenId) == _msgSender());
1508 
1509 
1510 
1511         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1512 
1513         if (to == address(0)) revert TransferToZeroAddress();
1514 
1515 
1516 
1517         _beforeTokenTransfers(from, to, tokenId, 1);
1518 
1519 
1520 
1521         // Clear approvals from the previous owner
1522 
1523         _approve(address(0), tokenId, from);
1524 
1525 
1526 
1527         // Underflow of the sender's balance is impossible because we check for
1528 
1529         // ownership above and the recipient's balance can't realistically overflow.
1530 
1531         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1532 
1533         unchecked {
1534 
1535             _addressData[from].balance -= 1;
1536 
1537             _addressData[to].balance += 1;
1538 
1539 
1540 
1541             TokenOwnership storage currSlot = _ownerships[tokenId];
1542 
1543             currSlot.addr = to;
1544 
1545             currSlot.startTimestamp = uint64(block.timestamp);
1546 
1547 
1548 
1549             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1550 
1551             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1552 
1553             uint256 nextTokenId = tokenId + 1;
1554 
1555             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1556 
1557             if (nextSlot.addr == address(0)) {
1558 
1559                 // This will suffice for checking _exists(nextTokenId),
1560 
1561                 // as a burned slot cannot contain the zero address.
1562 
1563                 if (nextTokenId != _currentIndex) {
1564 
1565                     nextSlot.addr = from;
1566 
1567                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1568 
1569                 }
1570 
1571             }
1572 
1573         }
1574 
1575 
1576 
1577         emit Transfer(from, to, tokenId);
1578 
1579         _afterTokenTransfers(from, to, tokenId, 1);
1580 
1581     }
1582 
1583 
1584 
1585     /**
1586 
1587      * @dev This is equivalent to _burn(tokenId, false)
1588 
1589      */
1590 
1591     function _burn(uint256 tokenId) internal virtual {
1592 
1593         _burn(tokenId, false);
1594 
1595     }
1596 
1597 
1598 
1599     /**
1600 
1601      * @dev Destroys `tokenId`.
1602 
1603      * The approval is cleared when the token is burned.
1604 
1605      *
1606 
1607      * Requirements:
1608 
1609      *
1610 
1611      * - `tokenId` must exist.
1612 
1613      *
1614 
1615      * Emits a {Transfer} event.
1616 
1617      */
1618 
1619     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1620 
1621         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1622 
1623 
1624 
1625         address from = prevOwnership.addr;
1626 
1627 
1628 
1629         if (approvalCheck) {
1630 
1631             bool isApprovedOrOwner = (_msgSender() == from ||
1632 
1633                 isApprovedForAll(from, _msgSender()) ||
1634 
1635                 getApproved(tokenId) == _msgSender());
1636 
1637 
1638 
1639             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1640 
1641         }
1642 
1643 
1644 
1645         _beforeTokenTransfers(from, address(0), tokenId, 1);
1646 
1647 
1648 
1649         // Clear approvals from the previous owner
1650 
1651         _approve(address(0), tokenId, from);
1652 
1653 
1654 
1655         // Underflow of the sender's balance is impossible because we check for
1656 
1657         // ownership above and the recipient's balance can't realistically overflow.
1658 
1659         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1660 
1661         unchecked {
1662 
1663             AddressData storage addressData = _addressData[from];
1664 
1665             addressData.balance -= 1;
1666 
1667             addressData.numberBurned += 1;
1668 
1669 
1670 
1671             // Keep track of who burned the token, and the timestamp of burning.
1672 
1673             TokenOwnership storage currSlot = _ownerships[tokenId];
1674 
1675             currSlot.addr = from;
1676 
1677             currSlot.startTimestamp = uint64(block.timestamp);
1678 
1679             currSlot.burned = true;
1680 
1681 
1682 
1683             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1684 
1685             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1686 
1687             uint256 nextTokenId = tokenId + 1;
1688 
1689             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1690 
1691             if (nextSlot.addr == address(0)) {
1692 
1693                 // This will suffice for checking _exists(nextTokenId),
1694 
1695                 // as a burned slot cannot contain the zero address.
1696 
1697                 if (nextTokenId != _currentIndex) {
1698 
1699                     nextSlot.addr = from;
1700 
1701                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1702 
1703                 }
1704 
1705             }
1706 
1707         }
1708 
1709 
1710 
1711         emit Transfer(from, address(0), tokenId);
1712 
1713         _afterTokenTransfers(from, address(0), tokenId, 1);
1714 
1715 
1716 
1717         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1718 
1719         unchecked {
1720 
1721             _burnCounter++;
1722 
1723         }
1724 
1725     }
1726 
1727 
1728 
1729     /**
1730 
1731      * @dev Approve `to` to operate on `tokenId`
1732 
1733      *
1734 
1735      * Emits a {Approval} event.
1736 
1737      */
1738 
1739     function _approve(
1740 
1741         address to,
1742 
1743         uint256 tokenId,
1744 
1745         address owner
1746 
1747     ) private {
1748 
1749         _tokenApprovals[tokenId] = to;
1750 
1751         emit Approval(owner, to, tokenId);
1752 
1753     }
1754 
1755 
1756 
1757     /**
1758 
1759      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1760 
1761      *
1762 
1763      * @param from address representing the previous owner of the given token ID
1764 
1765      * @param to target address that will receive the tokens
1766 
1767      * @param tokenId uint256 ID of the token to be transferred
1768 
1769      * @param _data bytes optional data to send along with the call
1770 
1771      * @return bool whether the call correctly returned the expected magic value
1772 
1773      */
1774 
1775     function _checkContractOnERC721Received(
1776 
1777         address from,
1778 
1779         address to,
1780 
1781         uint256 tokenId,
1782 
1783         bytes memory _data
1784 
1785     ) private returns (bool) {
1786 
1787         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1788 
1789             return retval == IERC721Receiver(to).onERC721Received.selector;
1790 
1791         } catch (bytes memory reason) {
1792 
1793             if (reason.length == 0) {
1794 
1795                 revert TransferToNonERC721ReceiverImplementer();
1796 
1797             } else {
1798 
1799                 assembly {
1800 
1801                     revert(add(32, reason), mload(reason))
1802 
1803                 }
1804 
1805             }
1806 
1807         }
1808 
1809     }
1810 
1811 
1812 
1813     /**
1814 
1815      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1816 
1817      * And also called before burning one token.
1818 
1819      *
1820 
1821      * startTokenId - the first token id to be transferred
1822 
1823      * quantity - the amount to be transferred
1824 
1825      *
1826 
1827      * Calling conditions:
1828 
1829      *
1830 
1831      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1832 
1833      * transferred to `to`.
1834 
1835      * - When `from` is zero, `tokenId` will be minted for `to`.
1836 
1837      * - When `to` is zero, `tokenId` will be burned by `from`.
1838 
1839      * - `from` and `to` are never both zero.
1840 
1841      */
1842 
1843     function _beforeTokenTransfers(
1844 
1845         address from,
1846 
1847         address to,
1848 
1849         uint256 startTokenId,
1850 
1851         uint256 quantity
1852 
1853     ) internal virtual {}
1854 
1855 
1856 
1857     /**
1858 
1859      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1860 
1861      * minting.
1862 
1863      * And also called after one token has been burned.
1864 
1865      *
1866 
1867      * startTokenId - the first token id to be transferred
1868 
1869      * quantity - the amount to be transferred
1870 
1871      *
1872 
1873      * Calling conditions:
1874 
1875      *
1876 
1877      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1878 
1879      * transferred to `to`.
1880 
1881      * - When `from` is zero, `tokenId` has been minted for `to`.
1882 
1883      * - When `to` is zero, `tokenId` has been burned by `from`.
1884 
1885      * - `from` and `to` are never both zero.
1886 
1887      */
1888 
1889     function _afterTokenTransfers(
1890 
1891         address from,
1892 
1893         address to,
1894 
1895         uint256 startTokenId,
1896 
1897         uint256 quantity
1898 
1899     ) internal virtual {}
1900 
1901 }
1902 // File: @openzeppelin/contracts/access/Ownable.sol
1903 
1904 
1905 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1906 
1907 pragma solidity ^0.8.0;
1908 
1909 
1910 /**
1911  * @dev Contract module which provides a basic access control mechanism, where
1912  * there is an account (an owner) that can be granted exclusive access to
1913  * specific functions.
1914  *
1915  * By default, the owner account will be the one that deploys the contract. This
1916  * can later be changed with {transferOwnership}.
1917  *
1918  * This module is used through inheritance. It will make available the modifier
1919  * `onlyOwner`, which can be applied to your functions to restrict their use to
1920  * the owner.
1921  */
1922 abstract contract Ownable is Context {
1923     address private _owner;
1924 
1925     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1926 
1927     /**
1928      * @dev Initializes the contract setting the deployer as the initial owner.
1929      */
1930     constructor() {
1931         _transferOwnership(_msgSender());
1932     }
1933 
1934     /**
1935      * @dev Returns the address of the current owner.
1936      */
1937     function owner() public view virtual returns (address) {
1938         return _owner;
1939     }
1940 
1941     /**
1942      * @dev Throws if called by any account other than the owner.
1943      */
1944     modifier onlyOwner() {
1945         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1946         _;
1947     }
1948 
1949     /**
1950      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1951      * Can only be called by the current owner.
1952      */
1953     function transferOwnership(address newOwner) public virtual onlyOwner {
1954         require(newOwner != address(0), "Ownable: new owner is the zero address");
1955         _transferOwnership(newOwner);
1956     }
1957 
1958     /**
1959      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1960      * Internal function without access restriction.
1961      */
1962     function _transferOwnership(address newOwner) internal virtual {
1963         address oldOwner = _owner;
1964         _owner = newOwner;
1965         emit OwnershipTransferred(oldOwner, newOwner);
1966     }
1967 }
1968 
1969 // File: contracts/contract.sol
1970 
1971 
1972 pragma solidity ^0.8.4;
1973 
1974 
1975 contract Wolfboss is Ownable, ERC721A  {
1976 
1977     using Strings for uint256;
1978 
1979     string private baseTokenURI;
1980 
1981     uint256 public ogCost = 0.2 ether;
1982     uint256 public wlCost = 0.22 ether;
1983     uint256 public publicSaleCost = 0.15 ether;
1984 
1985     uint128 public maxSupply = 4500;
1986 
1987     uint64 public maxMintAmountPerOgAccount = 3;
1988     uint64 public maxMintAmountPerWlAccount = 3;
1989     uint64 public maxMintAmountPerPublicAccount = 4;
1990 
1991     bool public presaleActive = false;
1992     bool public publicSaleActive =false;
1993 
1994     bytes32 public ogMerkleRoot;
1995     bytes32 public wlMerkleRoot;
1996 
1997     constructor() ERC721A("WOLFBOSS", "WOLFBOSS") {}
1998 
1999 
2000     modifier mintCompliance(uint256 _mintAmount) {
2001         require(_mintAmount > 0 , "Invalid mint amount!");
2002         require(totalMinted() + _mintAmount <= maxSupply, "Max supply exceeded!");
2003         _;
2004     }
2005 
2006     ///Mints NFTs for OG whitelist members during the presale
2007     function ogMint(bytes32[] calldata _merkleProof, uint64 _mintAmount) public payable mintCompliance(_mintAmount) {
2008         require(presaleActive, "Presale is not Active");
2009 
2010         require(msg.value == ogCost * _mintAmount, "Insufficient funds!");
2011         require(numberMinted(msg.sender) + _mintAmount <= maxMintAmountPerOgAccount, "Mint limit exceeded." );
2012         
2013         ///verify the provided _merkleProof
2014         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2015         require(MerkleProof.verify(_merkleProof, ogMerkleRoot, leaf), "Not part of the Presale whitelist.");
2016         
2017         _safeMint(msg.sender, _mintAmount);
2018     }
2019 
2020     ///Mints NFTs for WL whitelist addresses during the presale
2021     function wlMint(bytes32[] calldata _merkleProof, uint64 _mintAmount) public payable mintCompliance(_mintAmount) {
2022         require(presaleActive, "Presale is not Active");
2023 
2024         require(msg.value == wlCost * _mintAmount, "Insufficient funds!");
2025         require(numberMinted(msg.sender) + _mintAmount <= maxMintAmountPerWlAccount, "Mint limit exceeded." );
2026         
2027         ///verify the provided _merkleProof
2028         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2029         require(MerkleProof.verify(_merkleProof, wlMerkleRoot, leaf), "Not part of the Presale whitelist.");
2030         
2031         _safeMint(msg.sender, _mintAmount);
2032     }
2033 
2034     ///Allows any address to mint when the public sale is open
2035     function publicMint(uint64 _mintAmount) public payable mintCompliance(_mintAmount) {
2036         require(publicSaleActive, "Public is not Active");
2037 
2038         uint64 publicAmountMinted = getPublicAmountMinted(msg.sender);
2039         require(publicAmountMinted + _mintAmount <= maxMintAmountPerPublicAccount, "Mint limit exceeded." );
2040         require(msg.value == publicSaleCost * _mintAmount, "Insufficient funds!");
2041 
2042         setPublicAmountMinted(msg.sender,publicAmountMinted + _mintAmount);
2043         
2044         _safeMint(msg.sender, _mintAmount);
2045     }
2046 
2047     ///Allows owner of the collection to airdrop a token to any address
2048     function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
2049         _safeMint(_receiver, _mintAmount);
2050     }
2051 
2052     //@return token ids owned by an address in the collection
2053     function walletOfOwner(address _owner)
2054         external
2055         view
2056         returns (uint256[] memory)
2057     {
2058         uint256 ownerTokenCount = balanceOf(_owner);
2059         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
2060         uint256 currentTokenId = 1;
2061         uint256 ownedTokenIndex = 0;
2062 
2063         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
2064             if(exists(currentTokenId) == true) {
2065                 address currentTokenOwner = ownerOf(currentTokenId);
2066 
2067                 if (currentTokenOwner == _owner) {
2068                     ownedTokenIds[ownedTokenIndex] = currentTokenId;
2069                     ownedTokenIndex++;
2070                 }
2071             }
2072             currentTokenId++;
2073         }
2074 
2075         return ownedTokenIds;
2076     }
2077 
2078     //@return full url for passed in token id 
2079     function tokenURI(uint256 _tokenId)
2080 
2081         public
2082         view
2083         virtual
2084         override
2085         returns (string memory)
2086 
2087     {
2088 
2089         require(
2090         _exists(_tokenId),
2091         "ERC721Metadata: URI query for nonexistent token"
2092         );
2093 
2094         string memory currentBaseURI = _baseURI();
2095 
2096         return bytes(currentBaseURI).length > 0
2097 
2098             ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json"))
2099 
2100             : "";
2101     }
2102 
2103     //@return amount an address has minted during the public sale
2104     function getPublicAmountMinted(address _owner) public view returns (uint64) {
2105         return _getAux(_owner);
2106     }
2107 
2108     function setPublicAmountMinted(address _owner, uint64 _aux) internal {
2109         _setAux(_owner, _aux);
2110     }
2111 
2112     //@return amount an address has minted during all sales
2113     function numberMinted(address _owner) public view returns (uint256) {
2114         return _numberMinted(_owner);
2115     }
2116 
2117     //@return all NFT's minted including burned tokens
2118     function totalMinted() public view returns (uint256) {
2119         return _totalMinted();
2120     }
2121 
2122     function exists(uint256 _tokenId) public view returns (bool) {
2123         return _exists(_tokenId);
2124     }
2125 
2126     function burn(uint256 _tokenId) public {
2127         require(exists(_tokenId), "Token does not exist");
2128         require(msg.sender == ownerOf(_tokenId), "Not the owner of the token");
2129         _burn(_tokenId, false);
2130     }
2131 
2132     //@return url for the nft metadata
2133     function _baseURI() internal view virtual override returns (string memory) {
2134         return baseTokenURI;
2135     }
2136 
2137     function setBaseURI(string calldata _URI) external onlyOwner {
2138         baseTokenURI = _URI;
2139     }
2140 
2141     function setPublicSaleCost(uint256 _publicSaleCost) public onlyOwner {
2142         publicSaleCost = _publicSaleCost;
2143     }
2144 
2145     function setOgCost(uint256 _ogCost) public onlyOwner {
2146         ogCost = _ogCost;
2147     }
2148 
2149     function setWlCost(uint256 _wlCost) public onlyOwner {
2150         wlCost = _wlCost;
2151     }
2152 
2153     function setMaxMintPerOgAccount(uint64 _maxMintPerOgAccount) public onlyOwner {
2154         maxMintAmountPerOgAccount = _maxMintPerOgAccount;
2155     }
2156 
2157     function setMaxMintPerWlAccount(uint64 _maxMintPerWlAccount) public onlyOwner {
2158         maxMintAmountPerWlAccount = _maxMintPerWlAccount;
2159     }
2160    
2161     function setMaxMintPerPublicAccount(uint64 _maxMintAmountPerPublicAccount) public onlyOwner {
2162         maxMintAmountPerPublicAccount = _maxMintAmountPerPublicAccount;
2163     }
2164     
2165     function setPresaleActive(bool _state) public onlyOwner {
2166         presaleActive = _state;
2167     }
2168 
2169     function setPublicActive(bool _state) public onlyOwner {
2170         require(presaleActive == false);
2171         publicSaleActive = _state;
2172     }
2173 
2174     ///sets merkle tree root which determines the OG whitelisted addresses
2175     function setOgMerkleRoot(bytes32 _ogMerkleRoot) public onlyOwner {
2176         ogMerkleRoot = _ogMerkleRoot;
2177     }
2178 
2179     ///sets merkle tree root which determines the WL whitelisted addresses
2180     function setWLMerkleRoot(bytes32 _wlMerkleRoot) public onlyOwner {
2181         wlMerkleRoot = _wlMerkleRoot;
2182     }
2183 
2184     function setMaxSupply(uint128 _maxSupply) public onlyOwner {
2185         maxSupply = _maxSupply;
2186     }
2187 
2188     ///sends a percentage to each address
2189     function withdraw() public onlyOwner {
2190         ///original balance before percent is deducted
2191         uint256 initialBalance = address(this).balance;
2192 
2193         (bool t1, ) = payable(0x5FCa6B3Ec00cbF468f37a9BD6A96422c7ea122b5).call{value: initialBalance * 1 / 100}("");
2194         require(t1);
2195         
2196         (bool t2, ) = payable(0xE7d8724498c961c6296c3E0Ed6a192F24d23Bdea).call{value: initialBalance * 18 / 100}("");
2197         require(t2);
2198 
2199         (bool t3, ) = payable(0x6F74dd347B660f07ccc0749A1f19eFAa3244BceE).call{value: initialBalance * 5 / 100}("");
2200         require(t3);
2201         
2202         (bool t4, ) = payable(0x2B2411c4C28d1028646486c2A6089FE3a3521ef5).call{value: initialBalance * 39 / 100}("");
2203         require(t4);
2204 
2205         (bool t5, ) = payable(0x284496E2Af8703A39b536361a715f857c7D891F4).call{value: initialBalance * 37 / 100}("");
2206         require(t5);
2207     }
2208 
2209     /// Fallbacks 
2210     receive() external payable { }
2211     fallback() external payable { }
2212 }