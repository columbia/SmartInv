1 /**
2  *Submitted for verification at Etherscan.io on 2022-04-01
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/MerkleProof.sol
8 
9 
10 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev These functions deal with verification of Merkle Trees proofs.
16  *
17  * The proofs can be generated using the JavaScript library
18  * https://github.com/miguelmota/merkletreejs[merkletreejs].
19  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
20  *
21  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
22  *
23  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
24  * hashing, or use a hash function other than keccak256 for hashing leaves.
25  * This is because the concatenation of a sorted pair of internal nodes in
26  * the merkle tree could be reinterpreted as a leaf value.
27  */
28 library MerkleProof {
29     /**
30      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
31      * defined by `root`. For this, a `proof` must be provided, containing
32      * sibling hashes on the branch from the leaf to the root of the tree. Each
33      * pair of leaves and each pair of pre-images are assumed to be sorted.
34      */
35     function verify(
36         bytes32[] memory proof,
37         bytes32 root,
38         bytes32 leaf
39     ) internal pure returns (bool) {
40         return processProof(proof, leaf) == root;
41     }
42 
43     /**
44      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
45      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
46      * hash matches the root of the tree. When processing the proof, the pairs
47      * of leafs & pre-images are assumed to be sorted.
48      *
49      * _Available since v4.4._
50      */
51     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
52         bytes32 computedHash = leaf;
53         for (uint256 i = 0; i < proof.length; i++) {
54             bytes32 proofElement = proof[i];
55             if (computedHash <= proofElement) {
56                 // Hash(current computed hash + current element of the proof)
57                 computedHash = _efficientHash(computedHash, proofElement);
58             } else {
59                 // Hash(current element of the proof + current computed hash)
60                 computedHash = _efficientHash(proofElement, computedHash);
61             }
62         }
63         return computedHash;
64     }
65 
66     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
67         assembly {
68             mstore(0x00, a)
69             mstore(0x20, b)
70             value := keccak256(0x00, 0x40)
71         }
72     }
73 }
74 
75 // File: @openzeppelin/contracts/utils/Strings.sol
76 
77 
78 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
79 
80 pragma solidity ^0.8.0;
81 
82 /**
83  * @dev String operations.
84  */
85 library Strings {
86     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
87 
88     /**
89      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
90      */
91     function toString(uint256 value) internal pure returns (string memory) {
92         // Inspired by OraclizeAPI's implementation - MIT licence
93         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
94 
95         if (value == 0) {
96             return "0";
97         }
98         uint256 temp = value;
99         uint256 digits;
100         while (temp != 0) {
101             digits++;
102             temp /= 10;
103         }
104         bytes memory buffer = new bytes(digits);
105         while (value != 0) {
106             digits -= 1;
107             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
108             value /= 10;
109         }
110         return string(buffer);
111     }
112 
113     /**
114      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
115      */
116     function toHexString(uint256 value) internal pure returns (string memory) {
117         if (value == 0) {
118             return "0x00";
119         }
120         uint256 temp = value;
121         uint256 length = 0;
122         while (temp != 0) {
123             length++;
124             temp >>= 8;
125         }
126         return toHexString(value, length);
127     }
128 
129     /**
130      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
131      */
132     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
133         bytes memory buffer = new bytes(2 * length + 2);
134         buffer[0] = "0";
135         buffer[1] = "x";
136         for (uint256 i = 2 * length + 1; i > 1; --i) {
137             buffer[i] = _HEX_SYMBOLS[value & 0xf];
138             value >>= 4;
139         }
140         require(value == 0, "Strings: hex length insufficient");
141         return string(buffer);
142     }
143 }
144 
145 // File: @openzeppelin/contracts/utils/Address.sol
146 
147 
148 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
149 
150 pragma solidity ^0.8.1;
151 
152 /**
153  * @dev Collection of functions related to the address type
154  */
155 library Address {
156     /**
157      * @dev Returns true if `account` is a contract.
158      *
159      * [IMPORTANT]
160      * ====
161      * It is unsafe to assume that an address for which this function returns
162      * false is an externally-owned account (EOA) and not a contract.
163      *
164      * Among others, `isContract` will return false for the following
165      * types of addresses:
166      *
167      *  - an externally-owned account
168      *  - a contract in construction
169      *  - an address where a contract will be created
170      *  - an address where a contract lived, but was destroyed
171      * ====
172      *
173      * [IMPORTANT]
174      * ====
175      * You shouldn't rely on `isContract` to protect against flash loan attacks!
176      *
177      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
178      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
179      * constructor.
180      * ====
181      */
182     function isContract(address account) internal view returns (bool) {
183         // This method relies on extcodesize/address.code.length, which returns 0
184         // for contracts in construction, since the code is only stored at the end
185         // of the constructor execution.
186 
187         return account.code.length > 0;
188     }
189 
190     /**
191      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
192      * `recipient`, forwarding all available gas and reverting on errors.
193      *
194      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
195      * of certain opcodes, possibly making contracts go over the 2300 gas limit
196      * imposed by `transfer`, making them unable to receive funds via
197      * `transfer`. {sendValue} removes this limitation.
198      *
199      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
200      *
201      * IMPORTANT: because control is transferred to `recipient`, care must be
202      * taken to not create reentrancy vulnerabilities. Consider using
203      * {ReentrancyGuard} or the
204      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
205      */
206     function sendValue(address payable recipient, uint256 amount) internal {
207         require(address(this).balance >= amount, "Address: insufficient balance");
208 
209         (bool success, ) = recipient.call{value: amount}("");
210         require(success, "Address: unable to send value, recipient may have reverted");
211     }
212 
213     /**
214      * @dev Performs a Solidity function call using a low level `call`. A
215      * plain `call` is an unsafe replacement for a function call: use this
216      * function instead.
217      *
218      * If `target` reverts with a revert reason, it is bubbled up by this
219      * function (like regular Solidity function calls).
220      *
221      * Returns the raw returned data. To convert to the expected return value,
222      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
223      *
224      * Requirements:
225      *
226      * - `target` must be a contract.
227      * - calling `target` with `data` must not revert.
228      *
229      * _Available since v3.1._
230      */
231     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
232         return functionCall(target, data, "Address: low-level call failed");
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
237      * `errorMessage` as a fallback revert reason when `target` reverts.
238      *
239      * _Available since v3.1._
240      */
241     function functionCall(
242         address target,
243         bytes memory data,
244         string memory errorMessage
245     ) internal returns (bytes memory) {
246         return functionCallWithValue(target, data, 0, errorMessage);
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
251      * but also transferring `value` wei to `target`.
252      *
253      * Requirements:
254      *
255      * - the calling contract must have an ETH balance of at least `value`.
256      * - the called Solidity function must be `payable`.
257      *
258      * _Available since v3.1._
259      */
260     function functionCallWithValue(
261         address target,
262         bytes memory data,
263         uint256 value
264     ) internal returns (bytes memory) {
265         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
270      * with `errorMessage` as a fallback revert reason when `target` reverts.
271      *
272      * _Available since v3.1._
273      */
274     function functionCallWithValue(
275         address target,
276         bytes memory data,
277         uint256 value,
278         string memory errorMessage
279     ) internal returns (bytes memory) {
280         require(address(this).balance >= value, "Address: insufficient balance for call");
281         require(isContract(target), "Address: call to non-contract");
282 
283         (bool success, bytes memory returndata) = target.call{value: value}(data);
284         return verifyCallResult(success, returndata, errorMessage);
285     }
286 
287     /**
288      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
289      * but performing a static call.
290      *
291      * _Available since v3.3._
292      */
293     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
294         return functionStaticCall(target, data, "Address: low-level static call failed");
295     }
296 
297     /**
298      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
299      * but performing a static call.
300      *
301      * _Available since v3.3._
302      */
303     function functionStaticCall(
304         address target,
305         bytes memory data,
306         string memory errorMessage
307     ) internal view returns (bytes memory) {
308         require(isContract(target), "Address: static call to non-contract");
309 
310         (bool success, bytes memory returndata) = target.staticcall(data);
311         return verifyCallResult(success, returndata, errorMessage);
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
316      * but performing a delegate call.
317      *
318      * _Available since v3.4._
319      */
320     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
321         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
326      * but performing a delegate call.
327      *
328      * _Available since v3.4._
329      */
330     function functionDelegateCall(
331         address target,
332         bytes memory data,
333         string memory errorMessage
334     ) internal returns (bytes memory) {
335         require(isContract(target), "Address: delegate call to non-contract");
336 
337         (bool success, bytes memory returndata) = target.delegatecall(data);
338         return verifyCallResult(success, returndata, errorMessage);
339     }
340 
341     /**
342      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
343      * revert reason using the provided one.
344      *
345      * _Available since v4.3._
346      */
347     function verifyCallResult(
348         bool success,
349         bytes memory returndata,
350         string memory errorMessage
351     ) internal pure returns (bytes memory) {
352         if (success) {
353             return returndata;
354         } else {
355             // Look for revert reason and bubble it up if present
356             if (returndata.length > 0) {
357                 // The easiest way to bubble the revert reason is using memory via assembly
358 
359                 assembly {
360                     let returndata_size := mload(returndata)
361                     revert(add(32, returndata), returndata_size)
362                 }
363             } else {
364                 revert(errorMessage);
365             }
366         }
367     }
368 }
369 
370 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
371 
372 
373 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
374 
375 pragma solidity ^0.8.0;
376 
377 /**
378  * @title ERC721 token receiver interface
379  * @dev Interface for any contract that wants to support safeTransfers
380  * from ERC721 asset contracts.
381  */
382 interface IERC721Receiver {
383     /**
384      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
385      * by `operator` from `from`, this function is called.
386      *
387      * It must return its Solidity selector to confirm the token transfer.
388      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
389      *
390      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
391      */
392     function onERC721Received(
393         address operator,
394         address from,
395         uint256 tokenId,
396         bytes calldata data
397     ) external returns (bytes4);
398 }
399 
400 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
401 
402 
403 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
404 
405 pragma solidity ^0.8.0;
406 
407 /**
408  * @dev Interface of the ERC165 standard, as defined in the
409  * https://eips.ethereum.org/EIPS/eip-165[EIP].
410  *
411  * Implementers can declare support of contract interfaces, which can then be
412  * queried by others ({ERC165Checker}).
413  *
414  * For an implementation, see {ERC165}.
415  */
416 interface IERC165 {
417     /**
418      * @dev Returns true if this contract implements the interface defined by
419      * `interfaceId`. See the corresponding
420      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
421      * to learn more about how these ids are created.
422      *
423      * This function call must use less than 30 000 gas.
424      */
425     function supportsInterface(bytes4 interfaceId) external view returns (bool);
426 }
427 
428 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
429 
430 
431 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
432 
433 pragma solidity ^0.8.0;
434 
435 
436 /**
437  * @dev Implementation of the {IERC165} interface.
438  *
439  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
440  * for the additional interface id that will be supported. For example:
441  *
442  * ```solidity
443  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
444  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
445  * }
446  * ```
447  *
448  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
449  */
450 abstract contract ERC165 is IERC165 {
451     /**
452      * @dev See {IERC165-supportsInterface}.
453      */
454     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
455         return interfaceId == type(IERC165).interfaceId;
456     }
457 }
458 
459 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
460 
461 
462 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
463 
464 pragma solidity ^0.8.0;
465 
466 
467 /**
468  * @dev Required interface of an ERC721 compliant contract.
469  */
470 interface IERC721 is IERC165 {
471     /**
472      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
473      */
474     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
475 
476     /**
477      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
478      */
479     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
480 
481     /**
482      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
483      */
484     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
485 
486     /**
487      * @dev Returns the number of tokens in ``owner``'s account.
488      */
489     function balanceOf(address owner) external view returns (uint256 balance);
490 
491     /**
492      * @dev Returns the owner of the `tokenId` token.
493      *
494      * Requirements:
495      *
496      * - `tokenId` must exist.
497      */
498     function ownerOf(uint256 tokenId) external view returns (address owner);
499 
500     /**
501      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
502      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
503      *
504      * Requirements:
505      *
506      * - `from` cannot be the zero address.
507      * - `to` cannot be the zero address.
508      * - `tokenId` token must exist and be owned by `from`.
509      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
510      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
511      *
512      * Emits a {Transfer} event.
513      */
514     function safeTransferFrom(
515         address from,
516         address to,
517         uint256 tokenId
518     ) external;
519 
520     /**
521      * @dev Transfers `tokenId` token from `from` to `to`.
522      *
523      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
524      *
525      * Requirements:
526      *
527      * - `from` cannot be the zero address.
528      * - `to` cannot be the zero address.
529      * - `tokenId` token must be owned by `from`.
530      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
531      *
532      * Emits a {Transfer} event.
533      */
534     function transferFrom(
535         address from,
536         address to,
537         uint256 tokenId
538     ) external;
539 
540     /**
541      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
542      * The approval is cleared when the token is transferred.
543      *
544      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
545      *
546      * Requirements:
547      *
548      * - The caller must own the token or be an approved operator.
549      * - `tokenId` must exist.
550      *
551      * Emits an {Approval} event.
552      */
553     function approve(address to, uint256 tokenId) external;
554 
555     /**
556      * @dev Returns the account approved for `tokenId` token.
557      *
558      * Requirements:
559      *
560      * - `tokenId` must exist.
561      */
562     function getApproved(uint256 tokenId) external view returns (address operator);
563 
564     /**
565      * @dev Approve or remove `operator` as an operator for the caller.
566      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
567      *
568      * Requirements:
569      *
570      * - The `operator` cannot be the caller.
571      *
572      * Emits an {ApprovalForAll} event.
573      */
574     function setApprovalForAll(address operator, bool _approved) external;
575 
576     /**
577      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
578      *
579      * See {setApprovalForAll}
580      */
581     function isApprovedForAll(address owner, address operator) external view returns (bool);
582 
583     /**
584      * @dev Safely transfers `tokenId` token from `from` to `to`.
585      *
586      * Requirements:
587      *
588      * - `from` cannot be the zero address.
589      * - `to` cannot be the zero address.
590      * - `tokenId` token must exist and be owned by `from`.
591      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
592      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
593      *
594      * Emits a {Transfer} event.
595      */
596     function safeTransferFrom(
597         address from,
598         address to,
599         uint256 tokenId,
600         bytes calldata data
601     ) external;
602 }
603 
604 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
605 
606 
607 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
608 
609 pragma solidity ^0.8.0;
610 
611 
612 /**
613  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
614  * @dev See https://eips.ethereum.org/EIPS/eip-721
615  */
616 interface IERC721Metadata is IERC721 {
617     /**
618      * @dev Returns the token collection name.
619      */
620     function name() external view returns (string memory);
621 
622     /**
623      * @dev Returns the token collection symbol.
624      */
625     function symbol() external view returns (string memory);
626 
627     /**
628      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
629      */
630     function tokenURI(uint256 tokenId) external view returns (string memory);
631 }
632 
633 // File: @openzeppelin/contracts/utils/Context.sol
634 
635 
636 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
637 
638 pragma solidity ^0.8.0;
639 
640 /**
641  * @dev Provides information about the current execution context, including the
642  * sender of the transaction and its data. While these are generally available
643  * via msg.sender and msg.data, they should not be accessed in such a direct
644  * manner, since when dealing with meta-transactions the account sending and
645  * paying for execution may not be the actual sender (as far as an application
646  * is concerned).
647  *
648  * This contract is only required for intermediate, library-like contracts.
649  */
650 abstract contract Context {
651     function _msgSender() internal view virtual returns (address) {
652         return msg.sender;
653     }
654 
655     function _msgData() internal view virtual returns (bytes calldata) {
656         return msg.data;
657     }
658 }
659 
660 // File: contracts/erc721a.sol
661 
662 
663 
664 // Creator: Chiru Labs
665 
666 
667 
668 pragma solidity ^0.8.4;
669 
670 
671 
672 
673 
674 
675 
676 
677 
678 
679 error ApprovalCallerNotOwnerNorApproved();
680 
681 error ApprovalQueryForNonexistentToken();
682 
683 error ApproveToCaller();
684 
685 error ApprovalToCurrentOwner();
686 
687 error BalanceQueryForZeroAddress();
688 
689 error MintToZeroAddress();
690 
691 error MintZeroQuantity();
692 
693 error OwnerQueryForNonexistentToken();
694 
695 error TransferCallerNotOwnerNorApproved();
696 
697 error TransferFromIncorrectOwner();
698 
699 error TransferToNonERC721ReceiverImplementer();
700 
701 error TransferToZeroAddress();
702 
703 error URIQueryForNonexistentToken();
704 
705 
706 
707 /**
708 
709  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
710 
711  * the Metadata extension. Built to optimize for lower gas during batch mints.
712 
713  *
714 
715  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
716 
717  *
718 
719  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
720 
721  *
722 
723  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
724 
725  */
726 
727 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
728 
729     using Address for address;
730 
731     using Strings for uint256;
732 
733 
734 
735     // Compiler will pack this into a single 256bit word.
736 
737     struct TokenOwnership {
738 
739         // The address of the owner.
740 
741         address addr;
742 
743         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
744 
745         uint64 startTimestamp;
746 
747         // Whether the token has been burned.
748 
749         bool burned;
750 
751     }
752 
753 
754 
755     // Compiler will pack this into a single 256bit word.
756 
757     struct AddressData {
758 
759         // Realistically, 2**64-1 is more than enough.
760 
761         uint64 balance;
762 
763         // Keeps track of mint count with minimal overhead for tokenomics.
764 
765         uint64 numberMinted;
766 
767         // Keeps track of burn count with minimal overhead for tokenomics.
768 
769         uint64 numberBurned;
770 
771         // For miscellaneous variable(s) pertaining to the address
772 
773         // (e.g. number of whitelist mint slots used).
774 
775         // If there are multiple variables, please pack them into a uint64.
776 
777         uint64 aux;
778 
779     }
780 
781 
782 
783     // The tokenId of the next token to be minted.
784 
785     uint256 internal _currentIndex;
786 
787 
788 
789     // The number of tokens burned.
790 
791     uint256 internal _burnCounter;
792 
793 
794 
795     // Token name
796 
797     string private _name;
798 
799 
800 
801     // Token symbol
802 
803     string private _symbol;
804 
805 
806 
807     // Mapping from token ID to ownership details
808 
809     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
810 
811     mapping(uint256 => TokenOwnership) internal _ownerships;
812 
813 
814 
815     // Mapping owner address to address data
816 
817     mapping(address => AddressData) private _addressData;
818 
819 
820 
821     // Mapping from token ID to approved address
822 
823     mapping(uint256 => address) private _tokenApprovals;
824 
825 
826 
827     // Mapping from owner to operator approvals
828 
829     mapping(address => mapping(address => bool)) private _operatorApprovals;
830 
831 
832 
833     constructor(string memory name_, string memory symbol_) {
834 
835         _name = name_;
836 
837         _symbol = symbol_;
838 
839         _currentIndex = _startTokenId();
840 
841     }
842 
843 
844 
845     /**
846 
847      * To change the starting tokenId, please override this function.
848 
849      */
850 
851     function _startTokenId() internal view virtual returns (uint256) {
852 
853         return 1;
854 
855     }
856 
857 
858 
859     /**
860 
861      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
862 
863      */
864 
865     function totalSupply() public view returns (uint256) {
866 
867         // Counter underflow is impossible as _burnCounter cannot be incremented
868 
869         // more than _currentIndex - _startTokenId() times
870 
871         unchecked {
872 
873             return _currentIndex - _burnCounter - _startTokenId();
874 
875         }
876 
877     }
878 
879 
880 
881     /**
882 
883      * Returns the total amount of tokens minted in the contract.
884 
885      */
886 
887     function _totalMinted() internal view returns (uint256) {
888 
889         // Counter underflow is impossible as _currentIndex does not decrement,
890 
891         // and it is initialized to _startTokenId()
892 
893         unchecked {
894 
895             return _currentIndex - _startTokenId();
896 
897         }
898 
899     }
900 
901 
902 
903     /**
904 
905      * @dev See {IERC165-supportsInterface}.
906 
907      */
908 
909     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
910 
911         return
912 
913             interfaceId == type(IERC721).interfaceId ||
914 
915             interfaceId == type(IERC721Metadata).interfaceId ||
916 
917             super.supportsInterface(interfaceId);
918 
919     }
920 
921 
922 
923     /**
924 
925      * @dev See {IERC721-balanceOf}.
926 
927      */
928 
929     function balanceOf(address owner) public view override returns (uint256) {
930 
931         if (owner == address(0)) revert BalanceQueryForZeroAddress();
932 
933         return uint256(_addressData[owner].balance);
934 
935     }
936 
937 
938 
939     /**
940 
941      * Returns the number of tokens minted by `owner`.
942 
943      */
944 
945     function _numberMinted(address owner) internal view returns (uint256) {
946 
947         return uint256(_addressData[owner].numberMinted);
948 
949     }
950 
951 
952 
953     /**
954 
955      * Returns the number of tokens burned by or on behalf of `owner`.
956 
957      */
958 
959     function _numberBurned(address owner) internal view returns (uint256) {
960 
961         return uint256(_addressData[owner].numberBurned);
962 
963     }
964 
965 
966 
967     /**
968 
969      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
970 
971      */
972 
973     function _getAux(address owner) internal view returns (uint64) {
974 
975         return _addressData[owner].aux;
976 
977     }
978 
979 
980 
981     /**
982 
983      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
984 
985      * If there are multiple variables, please pack them into a uint64.
986 
987      */
988 
989     function _setAux(address owner, uint64 aux) internal {
990 
991         _addressData[owner].aux = aux;
992 
993     }
994 
995 
996 
997     /**
998 
999      * Gas spent here starts off proportional to the maximum mint batch size.
1000 
1001      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1002 
1003      */
1004 
1005     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1006 
1007         uint256 curr = tokenId;
1008 
1009 
1010 
1011         unchecked {
1012 
1013             if (_startTokenId() <= curr && curr < _currentIndex) {
1014 
1015                 TokenOwnership memory ownership = _ownerships[curr];
1016 
1017                 if (!ownership.burned) {
1018 
1019                     if (ownership.addr != address(0)) {
1020 
1021                         return ownership;
1022 
1023                     }
1024 
1025                     // Invariant:
1026 
1027                     // There will always be an ownership that has an address and is not burned
1028 
1029                     // before an ownership that does not have an address and is not burned.
1030 
1031                     // Hence, curr will not underflow.
1032 
1033                     while (true) {
1034 
1035                         curr--;
1036 
1037                         ownership = _ownerships[curr];
1038 
1039                         if (ownership.addr != address(0)) {
1040 
1041                             return ownership;
1042 
1043                         }
1044 
1045                     }
1046 
1047                 }
1048 
1049             }
1050 
1051         }
1052 
1053         revert OwnerQueryForNonexistentToken();
1054 
1055     }
1056 
1057 
1058 
1059     /**
1060 
1061      * @dev See {IERC721-ownerOf}.
1062 
1063      */
1064 
1065     function ownerOf(uint256 tokenId) public view override returns (address) {
1066 
1067         return _ownershipOf(tokenId).addr;
1068 
1069     }
1070 
1071 
1072 
1073     /**
1074 
1075      * @dev See {IERC721Metadata-name}.
1076 
1077      */
1078 
1079     function name() public view virtual override returns (string memory) {
1080 
1081         return _name;
1082 
1083     }
1084 
1085 
1086 
1087     /**
1088 
1089      * @dev See {IERC721Metadata-symbol}.
1090 
1091      */
1092 
1093     function symbol() public view virtual override returns (string memory) {
1094 
1095         return _symbol;
1096 
1097     }
1098 
1099 
1100 
1101     /**
1102 
1103      * @dev See {IERC721Metadata-tokenURI}.
1104 
1105      */
1106 
1107     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1108 
1109         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1110 
1111 
1112 
1113         string memory baseURI = _baseURI();
1114 
1115         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1116 
1117     }
1118 
1119 
1120 
1121     /**
1122 
1123      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1124 
1125      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1126 
1127      * by default, can be overriden in child contracts.
1128 
1129      */
1130 
1131     function _baseURI() internal view virtual returns (string memory) {
1132 
1133         return '';
1134 
1135     }
1136 
1137 
1138 
1139     /**
1140 
1141      * @dev See {IERC721-approve}.
1142 
1143      */
1144 
1145     function approve(address to, uint256 tokenId) public override {
1146 
1147         address owner = ERC721A.ownerOf(tokenId);
1148 
1149         if (to == owner) revert ApprovalToCurrentOwner();
1150 
1151 
1152 
1153         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1154 
1155             revert ApprovalCallerNotOwnerNorApproved();
1156 
1157         }
1158 
1159 
1160 
1161         _approve(to, tokenId, owner);
1162 
1163     }
1164 
1165 
1166 
1167     /**
1168 
1169      * @dev See {IERC721-getApproved}.
1170 
1171      */
1172 
1173     function getApproved(uint256 tokenId) public view override returns (address) {
1174 
1175         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1176 
1177 
1178 
1179         return _tokenApprovals[tokenId];
1180 
1181     }
1182 
1183 
1184 
1185     /**
1186 
1187      * @dev See {IERC721-setApprovalForAll}.
1188 
1189      */
1190 
1191     function setApprovalForAll(address operator, bool approved) public virtual override {
1192 
1193         if (operator == _msgSender()) revert ApproveToCaller();
1194 
1195 
1196 
1197         _operatorApprovals[_msgSender()][operator] = approved;
1198 
1199         emit ApprovalForAll(_msgSender(), operator, approved);
1200 
1201     }
1202 
1203 
1204 
1205     /**
1206 
1207      * @dev See {IERC721-isApprovedForAll}.
1208 
1209      */
1210 
1211     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1212 
1213         return _operatorApprovals[owner][operator];
1214 
1215     }
1216 
1217 
1218 
1219     /**
1220 
1221      * @dev See {IERC721-transferFrom}.
1222 
1223      */
1224 
1225     function transferFrom(
1226 
1227         address from,
1228 
1229         address to,
1230 
1231         uint256 tokenId
1232 
1233     ) public virtual override {
1234 
1235         _transfer(from, to, tokenId);
1236 
1237     }
1238 
1239 
1240 
1241     /**
1242 
1243      * @dev See {IERC721-safeTransferFrom}.
1244 
1245      */
1246 
1247     function safeTransferFrom(
1248 
1249         address from,
1250 
1251         address to,
1252 
1253         uint256 tokenId
1254 
1255     ) public virtual override {
1256 
1257         safeTransferFrom(from, to, tokenId, '');
1258 
1259     }
1260 
1261 
1262 
1263     /**
1264 
1265      * @dev See {IERC721-safeTransferFrom}.
1266 
1267      */
1268 
1269     function safeTransferFrom(
1270 
1271         address from,
1272 
1273         address to,
1274 
1275         uint256 tokenId,
1276 
1277         bytes memory _data
1278 
1279     ) public virtual override {
1280 
1281         _transfer(from, to, tokenId);
1282 
1283         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1284 
1285             revert TransferToNonERC721ReceiverImplementer();
1286 
1287         }
1288 
1289     }
1290 
1291 
1292 
1293     /**
1294 
1295      * @dev Returns whether `tokenId` exists.
1296 
1297      *
1298 
1299      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1300 
1301      *
1302 
1303      * Tokens start existing when they are minted (`_mint`),
1304 
1305      */
1306 
1307     function _exists(uint256 tokenId) internal view returns (bool) {
1308 
1309         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1310 
1311             !_ownerships[tokenId].burned;
1312 
1313     }
1314 
1315 
1316 
1317     function _safeMint(address to, uint256 quantity) internal {
1318 
1319         _safeMint(to, quantity, '');
1320 
1321     }
1322 
1323 
1324 
1325     /**
1326 
1327      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1328 
1329      *
1330 
1331      * Requirements:
1332 
1333      *
1334 
1335      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1336 
1337      * - `quantity` must be greater than 0.
1338 
1339      *
1340 
1341      * Emits a {Transfer} event.
1342 
1343      */
1344 
1345     function _safeMint(
1346 
1347         address to,
1348 
1349         uint256 quantity,
1350 
1351         bytes memory _data
1352 
1353     ) internal {
1354 
1355         _mint(to, quantity, _data, true);
1356 
1357     }
1358 
1359 
1360 
1361     /**
1362 
1363      * @dev Mints `quantity` tokens and transfers them to `to`.
1364 
1365      *
1366 
1367      * Requirements:
1368 
1369      *
1370 
1371      * - `to` cannot be the zero address.
1372 
1373      * - `quantity` must be greater than 0.
1374 
1375      *
1376 
1377      * Emits a {Transfer} event.
1378 
1379      */
1380 
1381     function _mint(
1382 
1383         address to,
1384 
1385         uint256 quantity,
1386 
1387         bytes memory _data,
1388 
1389         bool safe
1390 
1391     ) internal {
1392 
1393         uint256 startTokenId = _currentIndex;
1394 
1395         if (to == address(0)) revert MintToZeroAddress();
1396 
1397         if (quantity == 0) revert MintZeroQuantity();
1398 
1399 
1400 
1401         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1402 
1403 
1404 
1405         // Overflows are incredibly unrealistic.
1406 
1407         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1408 
1409         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1410 
1411         unchecked {
1412 
1413             _addressData[to].balance += uint64(quantity);
1414 
1415             _addressData[to].numberMinted += uint64(quantity);
1416 
1417 
1418 
1419             _ownerships[startTokenId].addr = to;
1420 
1421             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1422 
1423 
1424 
1425             uint256 updatedIndex = startTokenId;
1426 
1427             uint256 end = updatedIndex + quantity;
1428 
1429 
1430 
1431             if (safe && to.isContract()) {
1432 
1433                 do {
1434 
1435                     emit Transfer(address(0), to, updatedIndex);
1436 
1437                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1438 
1439                         revert TransferToNonERC721ReceiverImplementer();
1440 
1441                     }
1442 
1443                 } while (updatedIndex != end);
1444 
1445                 // Reentrancy protection
1446 
1447                 if (_currentIndex != startTokenId) revert();
1448 
1449             } else {
1450 
1451                 do {
1452 
1453                     emit Transfer(address(0), to, updatedIndex++);
1454 
1455                 } while (updatedIndex != end);
1456 
1457             }
1458 
1459             _currentIndex = updatedIndex;
1460 
1461         }
1462 
1463         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1464 
1465     }
1466 
1467 
1468 
1469     /**
1470 
1471      * @dev Transfers `tokenId` from `from` to `to`.
1472 
1473      *
1474 
1475      * Requirements:
1476 
1477      *
1478 
1479      * - `to` cannot be the zero address.
1480 
1481      * - `tokenId` token must be owned by `from`.
1482 
1483      *
1484 
1485      * Emits a {Transfer} event.
1486 
1487      */
1488 
1489     function _transfer(
1490 
1491         address from,
1492 
1493         address to,
1494 
1495         uint256 tokenId
1496 
1497     ) private {
1498 
1499         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1500 
1501 
1502 
1503         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1504 
1505 
1506 
1507         bool isApprovedOrOwner = (_msgSender() == from ||
1508 
1509             isApprovedForAll(from, _msgSender()) ||
1510 
1511             getApproved(tokenId) == _msgSender());
1512 
1513 
1514 
1515         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1516 
1517         if (to == address(0)) revert TransferToZeroAddress();
1518 
1519 
1520 
1521         _beforeTokenTransfers(from, to, tokenId, 1);
1522 
1523 
1524 
1525         // Clear approvals from the previous owner
1526 
1527         _approve(address(0), tokenId, from);
1528 
1529 
1530 
1531         // Underflow of the sender's balance is impossible because we check for
1532 
1533         // ownership above and the recipient's balance can't realistically overflow.
1534 
1535         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1536 
1537         unchecked {
1538 
1539             _addressData[from].balance -= 1;
1540 
1541             _addressData[to].balance += 1;
1542 
1543 
1544 
1545             TokenOwnership storage currSlot = _ownerships[tokenId];
1546 
1547             currSlot.addr = to;
1548 
1549             currSlot.startTimestamp = uint64(block.timestamp);
1550 
1551 
1552 
1553             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1554 
1555             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1556 
1557             uint256 nextTokenId = tokenId + 1;
1558 
1559             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1560 
1561             if (nextSlot.addr == address(0)) {
1562 
1563                 // This will suffice for checking _exists(nextTokenId),
1564 
1565                 // as a burned slot cannot contain the zero address.
1566 
1567                 if (nextTokenId != _currentIndex) {
1568 
1569                     nextSlot.addr = from;
1570 
1571                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1572 
1573                 }
1574 
1575             }
1576 
1577         }
1578 
1579 
1580 
1581         emit Transfer(from, to, tokenId);
1582 
1583         _afterTokenTransfers(from, to, tokenId, 1);
1584 
1585     }
1586 
1587 
1588 
1589     /**
1590 
1591      * @dev This is equivalent to _burn(tokenId, false)
1592 
1593      */
1594 
1595     function _burn(uint256 tokenId) internal virtual {
1596 
1597         _burn(tokenId, false);
1598 
1599     }
1600 
1601 
1602 
1603     /**
1604 
1605      * @dev Destroys `tokenId`.
1606 
1607      * The approval is cleared when the token is burned.
1608 
1609      *
1610 
1611      * Requirements:
1612 
1613      *
1614 
1615      * - `tokenId` must exist.
1616 
1617      *
1618 
1619      * Emits a {Transfer} event.
1620 
1621      */
1622 
1623     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1624 
1625         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1626 
1627 
1628 
1629         address from = prevOwnership.addr;
1630 
1631 
1632 
1633         if (approvalCheck) {
1634 
1635             bool isApprovedOrOwner = (_msgSender() == from ||
1636 
1637                 isApprovedForAll(from, _msgSender()) ||
1638 
1639                 getApproved(tokenId) == _msgSender());
1640 
1641 
1642 
1643             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1644 
1645         }
1646 
1647 
1648 
1649         _beforeTokenTransfers(from, address(0), tokenId, 1);
1650 
1651 
1652 
1653         // Clear approvals from the previous owner
1654 
1655         _approve(address(0), tokenId, from);
1656 
1657 
1658 
1659         // Underflow of the sender's balance is impossible because we check for
1660 
1661         // ownership above and the recipient's balance can't realistically overflow.
1662 
1663         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1664 
1665         unchecked {
1666 
1667             AddressData storage addressData = _addressData[from];
1668 
1669             addressData.balance -= 1;
1670 
1671             addressData.numberBurned += 1;
1672 
1673 
1674 
1675             // Keep track of who burned the token, and the timestamp of burning.
1676 
1677             TokenOwnership storage currSlot = _ownerships[tokenId];
1678 
1679             currSlot.addr = from;
1680 
1681             currSlot.startTimestamp = uint64(block.timestamp);
1682 
1683             currSlot.burned = true;
1684 
1685 
1686 
1687             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1688 
1689             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1690 
1691             uint256 nextTokenId = tokenId + 1;
1692 
1693             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1694 
1695             if (nextSlot.addr == address(0)) {
1696 
1697                 // This will suffice for checking _exists(nextTokenId),
1698 
1699                 // as a burned slot cannot contain the zero address.
1700 
1701                 if (nextTokenId != _currentIndex) {
1702 
1703                     nextSlot.addr = from;
1704 
1705                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1706 
1707                 }
1708 
1709             }
1710 
1711         }
1712 
1713 
1714 
1715         emit Transfer(from, address(0), tokenId);
1716 
1717         _afterTokenTransfers(from, address(0), tokenId, 1);
1718 
1719 
1720 
1721         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1722 
1723         unchecked {
1724 
1725             _burnCounter++;
1726 
1727         }
1728 
1729     }
1730 
1731 
1732 
1733     /**
1734 
1735      * @dev Approve `to` to operate on `tokenId`
1736 
1737      *
1738 
1739      * Emits a {Approval} event.
1740 
1741      */
1742 
1743     function _approve(
1744 
1745         address to,
1746 
1747         uint256 tokenId,
1748 
1749         address owner
1750 
1751     ) private {
1752 
1753         _tokenApprovals[tokenId] = to;
1754 
1755         emit Approval(owner, to, tokenId);
1756 
1757     }
1758 
1759 
1760 
1761     /**
1762 
1763      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1764 
1765      *
1766 
1767      * @param from address representing the previous owner of the given token ID
1768 
1769      * @param to target address that will receive the tokens
1770 
1771      * @param tokenId uint256 ID of the token to be transferred
1772 
1773      * @param _data bytes optional data to send along with the call
1774 
1775      * @return bool whether the call correctly returned the expected magic value
1776 
1777      */
1778 
1779     function _checkContractOnERC721Received(
1780 
1781         address from,
1782 
1783         address to,
1784 
1785         uint256 tokenId,
1786 
1787         bytes memory _data
1788 
1789     ) private returns (bool) {
1790 
1791         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1792 
1793             return retval == IERC721Receiver(to).onERC721Received.selector;
1794 
1795         } catch (bytes memory reason) {
1796 
1797             if (reason.length == 0) {
1798 
1799                 revert TransferToNonERC721ReceiverImplementer();
1800 
1801             } else {
1802 
1803                 assembly {
1804 
1805                     revert(add(32, reason), mload(reason))
1806 
1807                 }
1808 
1809             }
1810 
1811         }
1812 
1813     }
1814 
1815 
1816 
1817     /**
1818 
1819      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1820 
1821      * And also called before burning one token.
1822 
1823      *
1824 
1825      * startTokenId - the first token id to be transferred
1826 
1827      * quantity - the amount to be transferred
1828 
1829      *
1830 
1831      * Calling conditions:
1832 
1833      *
1834 
1835      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1836 
1837      * transferred to `to`.
1838 
1839      * - When `from` is zero, `tokenId` will be minted for `to`.
1840 
1841      * - When `to` is zero, `tokenId` will be burned by `from`.
1842 
1843      * - `from` and `to` are never both zero.
1844 
1845      */
1846 
1847     function _beforeTokenTransfers(
1848 
1849         address from,
1850 
1851         address to,
1852 
1853         uint256 startTokenId,
1854 
1855         uint256 quantity
1856 
1857     ) internal virtual {}
1858 
1859 
1860 
1861     /**
1862 
1863      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1864 
1865      * minting.
1866 
1867      * And also called after one token has been burned.
1868 
1869      *
1870 
1871      * startTokenId - the first token id to be transferred
1872 
1873      * quantity - the amount to be transferred
1874 
1875      *
1876 
1877      * Calling conditions:
1878 
1879      *
1880 
1881      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1882 
1883      * transferred to `to`.
1884 
1885      * - When `from` is zero, `tokenId` has been minted for `to`.
1886 
1887      * - When `to` is zero, `tokenId` has been burned by `from`.
1888 
1889      * - `from` and `to` are never both zero.
1890 
1891      */
1892 
1893     function _afterTokenTransfers(
1894 
1895         address from,
1896 
1897         address to,
1898 
1899         uint256 startTokenId,
1900 
1901         uint256 quantity
1902 
1903     ) internal virtual {}
1904 
1905 }
1906 // File: @openzeppelin/contracts/access/Ownable.sol
1907 
1908 
1909 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1910 
1911 pragma solidity ^0.8.0;
1912 
1913 
1914 /**
1915  * @dev Contract module which provides a basic access control mechanism, where
1916  * there is an account (an owner) that can be granted exclusive access to
1917  * specific functions.
1918  *
1919  * By default, the owner account will be the one that deploys the contract. This
1920  * can later be changed with {transferOwnership}.
1921  *
1922  * This module is used through inheritance. It will make available the modifier
1923  * `onlyOwner`, which can be applied to your functions to restrict their use to
1924  * the owner.
1925  */
1926 abstract contract Ownable is Context {
1927     address private _owner;
1928 
1929     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1930 
1931     /**
1932      * @dev Initializes the contract setting the deployer as the initial owner.
1933      */
1934     constructor() {
1935         _transferOwnership(_msgSender());
1936     }
1937 
1938     /**
1939      * @dev Returns the address of the current owner.
1940      */
1941     function owner() public view virtual returns (address) {
1942         return _owner;
1943     }
1944 
1945     /**
1946      * @dev Throws if called by any account other than the owner.
1947      */
1948     modifier onlyOwner() {
1949         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1950         _;
1951     }
1952 
1953     /**
1954      * @dev Leaves the contract without owner. It will not be possible to call
1955      * `onlyOwner` functions anymore. Can only be called by the current owner.
1956      *
1957      * NOTE: Renouncing ownership will leave the contract without an owner,
1958      * thereby removing any functionality that is only available to the owner.
1959      */
1960     function renounceOwnership() public virtual onlyOwner {
1961         _transferOwnership(address(0));
1962     }
1963 
1964     /**
1965      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1966      * Can only be called by the current owner.
1967      */
1968     function transferOwnership(address newOwner) public virtual onlyOwner {
1969         require(newOwner != address(0), "Ownable: new owner is the zero address");
1970         _transferOwnership(newOwner);
1971     }
1972 
1973     /**
1974      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1975      * Internal function without access restriction.
1976      */
1977     function _transferOwnership(address newOwner) internal virtual {
1978         address oldOwner = _owner;
1979         _owner = newOwner;
1980         emit OwnershipTransferred(oldOwner, newOwner);
1981     }
1982 }
1983 
1984 
1985 
1986 pragma solidity ^0.8.4;
1987 
1988 
1989 
1990 contract Basquimfers is Ownable, ERC721A  {
1991 
1992   using Strings for uint256;
1993 
1994   string private _baseTokenURI;
1995 
1996   address public mfersOwnerAddress;
1997 
1998   uint256 public presaleCost = 0.015 ether;
1999   uint256 public publicSaleCost = 0.02 ether;
2000   uint256 public maxSupply = 3456;
2001   uint256 public mfersFreeMintsRemaining = 123;
2002   uint256 public maxMintAmountPerTransaction = 20;
2003   uint256 public maxMintAmountPerPresaleAccount = 2;
2004   uint256 public maxMintAmountPerFreeAccount = 1;
2005 
2006 
2007   bool public paused = true;
2008   bool public freeMintActive = true;
2009   bool public presaleActive = false;
2010   bool public publicSaleActive = false;
2011 
2012   bytes32 public merkleRoot = 0x0de6c9f4b501d88b442db96c4f3653e394ef2ce0c67fc9d33527d625663f633c;
2013 
2014 
2015   constructor() ERC721A("Basquimfers", "Basquimfers") {
2016   }
2017 
2018   modifier mintCompliance(uint256 _mintAmount) {
2019       require(_mintAmount > 0 , "Invalid mint amount!");
2020       require(totalMinted() + _mintAmount <= maxSupply, "Max supply exceeded!");
2021       _;
2022   }
2023 
2024   function freeMint(bytes32[] calldata _merkleProof, uint64 _mintAmount) public payable mintCompliance(_mintAmount) {
2025     require(!paused, "The contract is paused!");
2026     if(freeMintActive==true){
2027       if(ownsMfer(msg.sender) == true){
2028         require(mfersFreeMintsRemaining > 0, "Mfers free mint supply exceeded!");
2029         mfersFreeMintsRemaining -=1;
2030       }
2031       else if(ownsMfer(msg.sender) == false){
2032         //verify the provided _merkleProof
2033         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2034         require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Not part of the Free Mint whitelist.");
2035       }
2036       require(numberMinted(msg.sender) + _mintAmount <= maxMintAmountPerFreeAccount, "Mint limit exceeded." );
2037       _safeMint(msg.sender, _mintAmount);
2038     }
2039   }
2040 
2041   function mint(bytes32[] calldata _merkleProof, uint64 _mintAmount) public payable mintCompliance(_mintAmount) {
2042     require(!paused, "The contract is paused!");
2043     
2044     if(presaleActive==true){
2045       uint64 amountMinted = getPresaleAmountMinted(msg.sender);
2046       require(msg.value >= presaleCost * _mintAmount, "Insufficient funds!");
2047       require(amountMinted + _mintAmount <= maxMintAmountPerPresaleAccount, "Mint limit exceeded." );
2048       //verify the provided _merkleProof
2049       bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2050       require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Not part of the Presale whitelist.");
2051       setPresaleAmountMinted(msg.sender,amountMinted + _mintAmount);
2052     }
2053     else{
2054       require(msg.value >= publicSaleCost * _mintAmount, "Insufficient funds!");
2055       require(_mintAmount <= maxMintAmountPerTransaction, "Mint limit exceeded." );
2056     }
2057     _safeMint(msg.sender, _mintAmount);
2058   }
2059 
2060   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
2061     _safeMint(_receiver, _mintAmount);
2062   }
2063 
2064   function walletOfOwner(address _owner)
2065     public
2066     view
2067     returns (uint256[] memory)
2068   {
2069     uint256 ownerTokenCount = balanceOf(_owner);
2070     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
2071     uint256 currentTokenId = 1;
2072     uint256 ownedTokenIndex = 0;
2073 
2074     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
2075     address currentTokenOwner = ownerOf(currentTokenId);
2076 
2077     if (currentTokenOwner == _owner) {
2078         ownedTokenIds[ownedTokenIndex] = currentTokenId;
2079         ownedTokenIndex++;
2080     }
2081 
2082     currentTokenId++;
2083     }
2084 
2085     return ownedTokenIds;
2086   }
2087 
2088   function tokenURI(uint256 _tokenId)
2089 
2090     public
2091     view
2092     virtual
2093     override
2094     returns (string memory)
2095 
2096   {
2097 
2098     require(
2099     _exists(_tokenId),
2100     "ERC721Metadata: URI query for nonexistent token"
2101     );
2102 
2103     string memory currentBaseURI = _baseURI();
2104 
2105     return bytes(currentBaseURI).length > 0
2106 
2107         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json"))
2108 
2109         : "";
2110   }
2111 
2112   function getPresaleAmountMinted(address owner) public view returns (uint64) {
2113     return _getAux(owner);
2114   }
2115 
2116   function setPresaleAmountMinted(address owner, uint64 aux) public {
2117     _setAux(owner, aux);
2118   }
2119 
2120   function numberMinted(address owner) public view returns (uint256) {
2121     return _numberMinted(owner);
2122   }
2123 
2124   function totalMinted() public view returns (uint256) {
2125     return _totalMinted();
2126   }
2127 
2128   function exists(uint256 tokenId) public view returns (bool) {
2129     return _exists(tokenId);
2130   }
2131 
2132   function burn(uint256 tokenId, bool approvalCheck) public {
2133     _burn(tokenId, approvalCheck);
2134   }
2135 
2136   function _baseURI() internal view virtual override returns (string memory) {
2137     return _baseTokenURI;
2138   }
2139 
2140   function setBaseURI(string calldata baseURI) external onlyOwner {
2141     _baseTokenURI = baseURI;
2142   }
2143 
2144   function setMfersOwnerAddress(address _state) public onlyOwner{
2145     mfersOwnerAddress = _state;
2146   }
2147 
2148   function setPaused(bool _state) public onlyOwner {
2149     paused = _state;
2150   }
2151 
2152   function setPublicSaleCost(uint256 _publicSaleCost) public onlyOwner {
2153     publicSaleCost = _publicSaleCost;
2154   }
2155 
2156   function setPresaleCost(uint256 _presaleCost) public onlyOwner {
2157     presaleCost = _presaleCost;
2158   }
2159 
2160   function setMaxMintPerPresaleAccount(uint256 _maxMintPerPresaleAccount) public onlyOwner {
2161     maxMintAmountPerPresaleAccount = _maxMintPerPresaleAccount;
2162   }
2163   
2164   function setMaxMintPerFreeAccount(uint256 _maxMintAmountPerFreeAccount) public onlyOwner {
2165     maxMintAmountPerFreeAccount = _maxMintAmountPerFreeAccount;
2166   }
2167 
2168   function setMaxMintPerTransaction(uint256 _maxMintAmountPerTransaction) public onlyOwner {
2169     maxMintAmountPerTransaction = _maxMintAmountPerTransaction;
2170   }
2171 
2172   function endFreeMint() public onlyOwner {
2173     freeMintActive = false;
2174     presaleActive = true;
2175     paused = true;
2176   }
2177 
2178   function endPresale() public onlyOwner {
2179     require(freeMintActive == false);
2180     presaleActive = false;
2181     publicSaleActive = true;
2182     paused = true;
2183   }
2184 
2185   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
2186     merkleRoot = _merkleRoot;
2187   }
2188   
2189   function ownsMfer(address _user) public view returns (bool) {
2190     IERC721 token = IERC721(mfersOwnerAddress);
2191     uint256 ownerAmount = token.balanceOf(_user);
2192    
2193     if(ownerAmount >= 1){
2194       return true;
2195     }
2196 
2197     return false;
2198   }
2199 
2200   function withdraw() public onlyOwner {
2201     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
2202     require(os);
2203   }
2204 
2205 }