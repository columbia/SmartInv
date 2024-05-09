1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
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
71 
72 /**
73  * @dev String operations.
74  */
75 library Strings {
76     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
77 
78     /**
79      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
80      */
81     function toString(uint256 value) internal pure returns (string memory) {
82         // Inspired by OraclizeAPI's implementation - MIT licence
83         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
84 
85         if (value == 0) {
86             return "0";
87         }
88         uint256 temp = value;
89         uint256 digits;
90         while (temp != 0) {
91             digits++;
92             temp /= 10;
93         }
94         bytes memory buffer = new bytes(digits);
95         while (value != 0) {
96             digits -= 1;
97             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
98             value /= 10;
99         }
100         return string(buffer);
101     }
102 
103     /**
104      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
105      */
106     function toHexString(uint256 value) internal pure returns (string memory) {
107         if (value == 0) {
108             return "0x00";
109         }
110         uint256 temp = value;
111         uint256 length = 0;
112         while (temp != 0) {
113             length++;
114             temp >>= 8;
115         }
116         return toHexString(value, length);
117     }
118 
119     /**
120      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
121      */
122     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
123         bytes memory buffer = new bytes(2 * length + 2);
124         buffer[0] = "0";
125         buffer[1] = "x";
126         for (uint256 i = 2 * length + 1; i > 1; --i) {
127             buffer[i] = _HEX_SYMBOLS[value & 0xf];
128             value >>= 4;
129         }
130         require(value == 0, "Strings: hex length insufficient");
131         return string(buffer);
132     }
133 }
134 
135 // File: @openzeppelin/contracts/utils/Address.sol
136 
137 
138 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
139 
140 pragma solidity ^0.8.1;
141 
142 /**
143  * @dev Collection of functions related to the address type
144  */
145 library Address {
146     /**
147      * @dev Returns true if `account` is a contract.
148      *
149      * [IMPORTANT]
150      * ====
151      * It is unsafe to assume that an address for which this function returns
152      * false is an externally-owned account (EOA) and not a contract.
153      *
154      * Among others, `isContract` will return false for the following
155      * types of addresses:
156      *
157      *  - an externally-owned account
158      *  - a contract in construction
159      *  - an address where a contract will be created
160      *  - an address where a contract lived, but was destroyed
161      * ====
162      *
163      * [IMPORTANT]
164      * ====
165      * You shouldn't rely on `isContract` to protect against flash loan attacks!
166      *
167      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
168      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
169      * constructor.
170      * ====
171      */
172     function isContract(address account) internal view returns (bool) {
173         // This method relies on extcodesize/address.code.length, which returns 0
174         // for contracts in construction, since the code is only stored at the end
175         // of the constructor execution.
176 
177         return account.code.length > 0;
178     }
179 
180     /**
181      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
182      * `recipient`, forwarding all available gas and reverting on errors.
183      *
184      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
185      * of certain opcodes, possibly making contracts go over the 2300 gas limit
186      * imposed by `transfer`, making them unable to receive funds via
187      * `transfer`. {sendValue} removes this limitation.
188      *
189      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
190      *
191      * IMPORTANT: because control is transferred to `recipient`, care must be
192      * taken to not create reentrancy vulnerabilities. Consider using
193      * {ReentrancyGuard} or the
194      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
195      */
196     function sendValue(address payable recipient, uint256 amount) internal {
197         require(address(this).balance >= amount, "Address: insufficient balance");
198 
199         (bool success, ) = recipient.call{value: amount}("");
200         require(success, "Address: unable to send value, recipient may have reverted");
201     }
202 
203     /**
204      * @dev Performs a Solidity function call using a low level `call`. A
205      * plain `call` is an unsafe replacement for a function call: use this
206      * function instead.
207      *
208      * If `target` reverts with a revert reason, it is bubbled up by this
209      * function (like regular Solidity function calls).
210      *
211      * Returns the raw returned data. To convert to the expected return value,
212      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
213      *
214      * Requirements:
215      *
216      * - `target` must be a contract.
217      * - calling `target` with `data` must not revert.
218      *
219      * _Available since v3.1._
220      */
221     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
222         return functionCall(target, data, "Address: low-level call failed");
223     }
224 
225     /**
226      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
227      * `errorMessage` as a fallback revert reason when `target` reverts.
228      *
229      * _Available since v3.1._
230      */
231     function functionCall(
232         address target,
233         bytes memory data,
234         string memory errorMessage
235     ) internal returns (bytes memory) {
236         return functionCallWithValue(target, data, 0, errorMessage);
237     }
238 
239     /**
240      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
241      * but also transferring `value` wei to `target`.
242      *
243      * Requirements:
244      *
245      * - the calling contract must have an ETH balance of at least `value`.
246      * - the called Solidity function must be `payable`.
247      *
248      * _Available since v3.1._
249      */
250     function functionCallWithValue(
251         address target,
252         bytes memory data,
253         uint256 value
254     ) internal returns (bytes memory) {
255         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
260      * with `errorMessage` as a fallback revert reason when `target` reverts.
261      *
262      * _Available since v3.1._
263      */
264     function functionCallWithValue(
265         address target,
266         bytes memory data,
267         uint256 value,
268         string memory errorMessage
269     ) internal returns (bytes memory) {
270         require(address(this).balance >= value, "Address: insufficient balance for call");
271         require(isContract(target), "Address: call to non-contract");
272 
273         (bool success, bytes memory returndata) = target.call{value: value}(data);
274         return verifyCallResult(success, returndata, errorMessage);
275     }
276 
277     /**
278      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
279      * but performing a static call.
280      *
281      * _Available since v3.3._
282      */
283     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
284         return functionStaticCall(target, data, "Address: low-level static call failed");
285     }
286 
287     /**
288      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
289      * but performing a static call.
290      *
291      * _Available since v3.3._
292      */
293     function functionStaticCall(
294         address target,
295         bytes memory data,
296         string memory errorMessage
297     ) internal view returns (bytes memory) {
298         require(isContract(target), "Address: static call to non-contract");
299 
300         (bool success, bytes memory returndata) = target.staticcall(data);
301         return verifyCallResult(success, returndata, errorMessage);
302     }
303 
304     /**
305      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
306      * but performing a delegate call.
307      *
308      * _Available since v3.4._
309      */
310     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
311         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
316      * but performing a delegate call.
317      *
318      * _Available since v3.4._
319      */
320     function functionDelegateCall(
321         address target,
322         bytes memory data,
323         string memory errorMessage
324     ) internal returns (bytes memory) {
325         require(isContract(target), "Address: delegate call to non-contract");
326 
327         (bool success, bytes memory returndata) = target.delegatecall(data);
328         return verifyCallResult(success, returndata, errorMessage);
329     }
330 
331     /**
332      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
333      * revert reason using the provided one.
334      *
335      * _Available since v4.3._
336      */
337     function verifyCallResult(
338         bool success,
339         bytes memory returndata,
340         string memory errorMessage
341     ) internal pure returns (bytes memory) {
342         if (success) {
343             return returndata;
344         } else {
345             // Look for revert reason and bubble it up if present
346             if (returndata.length > 0) {
347                 // The easiest way to bubble the revert reason is using memory via assembly
348 
349                 assembly {
350                     let returndata_size := mload(returndata)
351                     revert(add(32, returndata), returndata_size)
352                 }
353             } else {
354                 revert(errorMessage);
355             }
356         }
357     }
358 }
359 
360 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
361 
362 
363 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
364 
365 pragma solidity ^0.8.0;
366 
367 /**
368  * @title ERC721 token receiver interface
369  * @dev Interface for any contract that wants to support safeTransfers
370  * from ERC721 asset contracts.
371  */
372 interface IERC721Receiver {
373     /**
374      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
375      * by `operator` from `from`, this function is called.
376      *
377      * It must return its Solidity selector to confirm the token transfer.
378      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
379      *
380      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
381      */
382     function onERC721Received(
383         address operator,
384         address from,
385         uint256 tokenId,
386         bytes calldata data
387     ) external returns (bytes4);
388 }
389 
390 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
391 
392 
393 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
394 
395 pragma solidity ^0.8.0;
396 
397 /**
398  * @dev Interface of the ERC165 standard, as defined in the
399  * https://eips.ethereum.org/EIPS/eip-165[EIP].
400  *
401  * Implementers can declare support of contract interfaces, which can then be
402  * queried by others ({ERC165Checker}).
403  *
404  * For an implementation, see {ERC165}.
405  */
406 interface IERC165 {
407     /**
408      * @dev Returns true if this contract implements the interface defined by
409      * `interfaceId`. See the corresponding
410      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
411      * to learn more about how these ids are created.
412      *
413      * This function call must use less than 30 000 gas.
414      */
415     function supportsInterface(bytes4 interfaceId) external view returns (bool);
416 }
417 
418 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
419 
420 
421 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
422 
423 pragma solidity ^0.8.0;
424 
425 
426 /**
427  * @dev Implementation of the {IERC165} interface.
428  *
429  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
430  * for the additional interface id that will be supported. For example:
431  *
432  * ```solidity
433  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
434  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
435  * }
436  * ```
437  *
438  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
439  */
440 abstract contract ERC165 is IERC165 {
441     /**
442      * @dev See {IERC165-supportsInterface}.
443      */
444     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
445         return interfaceId == type(IERC165).interfaceId;
446     }
447 }
448 
449 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
450 
451 
452 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
453 
454 pragma solidity ^0.8.0;
455 
456 
457 /**
458  * @dev Required interface of an ERC721 compliant contract.
459  */
460 interface IERC721 is IERC165 {
461     /**
462      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
463      */
464     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
465 
466     /**
467      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
468      */
469     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
470 
471     /**
472      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
473      */
474     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
475 
476     /**
477      * @dev Returns the number of tokens in ``owner``'s account.
478      */
479     function balanceOf(address owner) external view returns (uint256 balance);
480 
481     /**
482      * @dev Returns the owner of the `tokenId` token.
483      *
484      * Requirements:
485      *
486      * - `tokenId` must exist.
487      */
488     function ownerOf(uint256 tokenId) external view returns (address owner);
489 
490     /**
491      * @dev Safely transfers `tokenId` token from `from` to `to`.
492      *
493      * Requirements:
494      *
495      * - `from` cannot be the zero address.
496      * - `to` cannot be the zero address.
497      * - `tokenId` token must exist and be owned by `from`.
498      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
499      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
500      *
501      * Emits a {Transfer} event.
502      */
503     function safeTransferFrom(
504         address from,
505         address to,
506         uint256 tokenId,
507         bytes calldata data
508     ) external;
509 
510     /**
511      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
512      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
513      *
514      * Requirements:
515      *
516      * - `from` cannot be the zero address.
517      * - `to` cannot be the zero address.
518      * - `tokenId` token must exist and be owned by `from`.
519      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
520      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
521      *
522      * Emits a {Transfer} event.
523      */
524     function safeTransferFrom(
525         address from,
526         address to,
527         uint256 tokenId
528     ) external;
529 
530     /**
531      * @dev Transfers `tokenId` token from `from` to `to`.
532      *
533      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
534      *
535      * Requirements:
536      *
537      * - `from` cannot be the zero address.
538      * - `to` cannot be the zero address.
539      * - `tokenId` token must be owned by `from`.
540      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
541      *
542      * Emits a {Transfer} event.
543      */
544     function transferFrom(
545         address from,
546         address to,
547         uint256 tokenId
548     ) external;
549 
550     /**
551      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
552      * The approval is cleared when the token is transferred.
553      *
554      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
555      *
556      * Requirements:
557      *
558      * - The caller must own the token or be an approved operator.
559      * - `tokenId` must exist.
560      *
561      * Emits an {Approval} event.
562      */
563     function approve(address to, uint256 tokenId) external;
564 
565     /**
566      * @dev Approve or remove `operator` as an operator for the caller.
567      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
568      *
569      * Requirements:
570      *
571      * - The `operator` cannot be the caller.
572      *
573      * Emits an {ApprovalForAll} event.
574      */
575     function setApprovalForAll(address operator, bool _approved) external;
576 
577     /**
578      * @dev Returns the account approved for `tokenId` token.
579      *
580      * Requirements:
581      *
582      * - `tokenId` must exist.
583      */
584     function getApproved(uint256 tokenId) external view returns (address operator);
585 
586     /**
587      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
588      *
589      * See {setApprovalForAll}
590      */
591     function isApprovedForAll(address owner, address operator) external view returns (bool);
592 }
593 
594 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
595 
596 
597 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
598 
599 pragma solidity ^0.8.0;
600 
601 
602 /**
603  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
604  * @dev See https://eips.ethereum.org/EIPS/eip-721
605  */
606 interface IERC721Metadata is IERC721 {
607     /**
608      * @dev Returns the token collection name.
609      */
610     function name() external view returns (string memory);
611 
612     /**
613      * @dev Returns the token collection symbol.
614      */
615     function symbol() external view returns (string memory);
616 
617     /**
618      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
619      */
620     function tokenURI(uint256 tokenId) external view returns (string memory);
621 }
622 
623 // File: erc721a/contracts/IERC721A.sol
624 
625 
626 // ERC721A Contracts v3.3.0
627 // Creator: Chiru Labs
628 
629 pragma solidity ^0.8.4;
630 
631 
632 
633 /**
634  * @dev Interface of an ERC721A compliant contract.
635  */
636 interface IERC721A is IERC721, IERC721Metadata {
637     /**
638      * The caller must own the token or be an approved operator.
639      */
640     error ApprovalCallerNotOwnerNorApproved();
641 
642     /**
643      * The token does not exist.
644      */
645     error ApprovalQueryForNonexistentToken();
646 
647     /**
648      * The caller cannot approve to their own address.
649      */
650     error ApproveToCaller();
651 
652     /**
653      * The caller cannot approve to the current owner.
654      */
655     error ApprovalToCurrentOwner();
656 
657     /**
658      * Cannot query the balance for the zero address.
659      */
660     error BalanceQueryForZeroAddress();
661 
662     /**
663      * Cannot mint to the zero address.
664      */
665     error MintToZeroAddress();
666 
667     /**
668      * The quantity of tokens minted must be more than zero.
669      */
670     error MintZeroQuantity();
671 
672     /**
673      * The token does not exist.
674      */
675     error OwnerQueryForNonexistentToken();
676 
677     /**
678      * The caller must own the token or be an approved operator.
679      */
680     error TransferCallerNotOwnerNorApproved();
681 
682     /**
683      * The token must be owned by `from`.
684      */
685     error TransferFromIncorrectOwner();
686 
687     /**
688      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
689      */
690     error TransferToNonERC721ReceiverImplementer();
691 
692     /**
693      * Cannot transfer to the zero address.
694      */
695     error TransferToZeroAddress();
696 
697     /**
698      * The token does not exist.
699      */
700     error URIQueryForNonexistentToken();
701 
702     // Compiler will pack this into a single 256bit word.
703     struct TokenOwnership {
704         // The address of the owner.
705         address addr;
706         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
707         uint64 startTimestamp;
708         // Whether the token has been burned.
709         bool burned;
710     }
711 
712     // Compiler will pack this into a single 256bit word.
713     struct AddressData {
714         // Realistically, 2**64-1 is more than enough.
715         uint64 balance;
716         // Keeps track of mint count with minimal overhead for tokenomics.
717         uint64 numberMinted;
718         // Keeps track of burn count with minimal overhead for tokenomics.
719         uint64 numberBurned;
720         // For miscellaneous variable(s) pertaining to the address
721         // (e.g. number of whitelist mint slots used).
722         // If there are multiple variables, please pack them into a uint64.
723         uint64 aux;
724     }
725 
726     /**
727      * @dev Returns the total amount of tokens stored by the contract.
728      * 
729      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
730      */
731     function totalSupply() external view returns (uint256);
732 }
733 
734 // File: @openzeppelin/contracts/utils/Context.sol
735 
736 
737 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
738 
739 pragma solidity ^0.8.0;
740 
741 /**
742  * @dev Provides information about the current execution context, including the
743  * sender of the transaction and its data. While these are generally available
744  * via msg.sender and msg.data, they should not be accessed in such a direct
745  * manner, since when dealing with meta-transactions the account sending and
746  * paying for execution may not be the actual sender (as far as an application
747  * is concerned).
748  *
749  * This contract is only required for intermediate, library-like contracts.
750  */
751 abstract contract Context {
752     function _msgSender() internal view virtual returns (address) {
753         return msg.sender;
754     }
755 
756     function _msgData() internal view virtual returns (bytes calldata) {
757         return msg.data;
758     }
759 }
760 
761 // File: erc721a/contracts/ERC721A.sol
762 
763 
764 // ERC721A Contracts v3.3.0
765 // Creator: Chiru Labs
766 
767 pragma solidity ^0.8.4;
768 
769 
770 
771 
772 
773 
774 
775 /**
776  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
777  * the Metadata extension. Built to optimize for lower gas during batch mints.
778  *
779  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
780  *
781  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
782  *
783  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
784  */
785 contract ERC721A is Context, ERC165, IERC721A {
786     using Address for address;
787     using Strings for uint256;
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
801     // Mapping from token ID to ownership details
802     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
803     mapping(uint256 => TokenOwnership) internal _ownerships;
804 
805     // Mapping owner address to address data
806     mapping(address => AddressData) private _addressData;
807 
808     // Mapping from token ID to approved address
809     mapping(uint256 => address) private _tokenApprovals;
810 
811     // Mapping from owner to operator approvals
812     mapping(address => mapping(address => bool)) private _operatorApprovals;
813 
814     constructor(string memory name_, string memory symbol_) {
815         _name = name_;
816         _symbol = symbol_;
817         _currentIndex = _startTokenId();
818     }
819 
820     /**
821      * To change the starting tokenId, please override this function.
822      */
823     function _startTokenId() internal view virtual returns (uint256) {
824         return 0;
825     }
826 
827     /**
828      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
829      */
830     function totalSupply() public view override returns (uint256) {
831         // Counter underflow is impossible as _burnCounter cannot be incremented
832         // more than _currentIndex - _startTokenId() times
833         unchecked {
834             return _currentIndex - _burnCounter - _startTokenId();
835         }
836     }
837 
838     /**
839      * Returns the total amount of tokens minted in the contract.
840      */
841     function _totalMinted() internal view returns (uint256) {
842         // Counter underflow is impossible as _currentIndex does not decrement,
843         // and it is initialized to _startTokenId()
844         unchecked {
845             return _currentIndex - _startTokenId();
846         }
847     }
848 
849     /**
850      * @dev See {IERC165-supportsInterface}.
851      */
852     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
853         return
854             interfaceId == type(IERC721).interfaceId ||
855             interfaceId == type(IERC721Metadata).interfaceId ||
856             super.supportsInterface(interfaceId);
857     }
858 
859     /**
860      * @dev See {IERC721-balanceOf}.
861      */
862     function balanceOf(address owner) public view override returns (uint256) {
863         if (owner == address(0)) revert BalanceQueryForZeroAddress();
864         return uint256(_addressData[owner].balance);
865     }
866 
867     /**
868      * Returns the number of tokens minted by `owner`.
869      */
870     function _numberMinted(address owner) internal view returns (uint256) {
871         return uint256(_addressData[owner].numberMinted);
872     }
873 
874     /**
875      * Returns the number of tokens burned by or on behalf of `owner`.
876      */
877     function _numberBurned(address owner) internal view returns (uint256) {
878         return uint256(_addressData[owner].numberBurned);
879     }
880 
881     /**
882      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
883      */
884     function _getAux(address owner) internal view returns (uint64) {
885         return _addressData[owner].aux;
886     }
887 
888     /**
889      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
890      * If there are multiple variables, please pack them into a uint64.
891      */
892     function _setAux(address owner, uint64 aux) internal {
893         _addressData[owner].aux = aux;
894     }
895 
896     /**
897      * Gas spent here starts off proportional to the maximum mint batch size.
898      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
899      */
900     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
901         uint256 curr = tokenId;
902 
903         unchecked {
904             if (_startTokenId() <= curr) if (curr < _currentIndex) {
905                 TokenOwnership memory ownership = _ownerships[curr];
906                 if (!ownership.burned) {
907                     if (ownership.addr != address(0)) {
908                         return ownership;
909                     }
910                     // Invariant:
911                     // There will always be an ownership that has an address and is not burned
912                     // before an ownership that does not have an address and is not burned.
913                     // Hence, curr will not underflow.
914                     while (true) {
915                         curr--;
916                         ownership = _ownerships[curr];
917                         if (ownership.addr != address(0)) {
918                             return ownership;
919                         }
920                     }
921                 }
922             }
923         }
924         revert OwnerQueryForNonexistentToken();
925     }
926 
927     /**
928      * @dev See {IERC721-ownerOf}.
929      */
930     function ownerOf(uint256 tokenId) public view override returns (address) {
931         return _ownershipOf(tokenId).addr;
932     }
933 
934     /**
935      * @dev See {IERC721Metadata-name}.
936      */
937     function name() public view virtual override returns (string memory) {
938         return _name;
939     }
940 
941     /**
942      * @dev See {IERC721Metadata-symbol}.
943      */
944     function symbol() public view virtual override returns (string memory) {
945         return _symbol;
946     }
947 
948     /**
949      * @dev See {IERC721Metadata-tokenURI}.
950      */
951     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
952         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
953 
954         string memory baseURI = _baseURI();
955         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
956     }
957 
958     /**
959      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
960      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
961      * by default, can be overriden in child contracts.
962      */
963     function _baseURI() internal view virtual returns (string memory) {
964         return '';
965     }
966 
967     /**
968      * @dev See {IERC721-approve}.
969      */
970     function approve(address to, uint256 tokenId) public override {
971         address owner = ERC721A.ownerOf(tokenId);
972         if (to == owner) revert ApprovalToCurrentOwner();
973 
974         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
975             revert ApprovalCallerNotOwnerNorApproved();
976         }
977 
978         _approve(to, tokenId, owner);
979     }
980 
981     /**
982      * @dev See {IERC721-getApproved}.
983      */
984     function getApproved(uint256 tokenId) public view override returns (address) {
985         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
986 
987         return _tokenApprovals[tokenId];
988     }
989 
990     /**
991      * @dev See {IERC721-setApprovalForAll}.
992      */
993     function setApprovalForAll(address operator, bool approved) public virtual override {
994         if (operator == _msgSender()) revert ApproveToCaller();
995 
996         _operatorApprovals[_msgSender()][operator] = approved;
997         emit ApprovalForAll(_msgSender(), operator, approved);
998     }
999 
1000     /**
1001      * @dev See {IERC721-isApprovedForAll}.
1002      */
1003     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1004         return _operatorApprovals[owner][operator];
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-transferFrom}.
1009      */
1010     function transferFrom(
1011         address from,
1012         address to,
1013         uint256 tokenId
1014     ) public virtual override {
1015         _transfer(from, to, tokenId);
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-safeTransferFrom}.
1020      */
1021     function safeTransferFrom(
1022         address from,
1023         address to,
1024         uint256 tokenId
1025     ) public virtual override {
1026         safeTransferFrom(from, to, tokenId, '');
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-safeTransferFrom}.
1031      */
1032     function safeTransferFrom(
1033         address from,
1034         address to,
1035         uint256 tokenId,
1036         bytes memory _data
1037     ) public virtual override {
1038         _transfer(from, to, tokenId);
1039         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1040             revert TransferToNonERC721ReceiverImplementer();
1041         }
1042     }
1043 
1044     /**
1045      * @dev Returns whether `tokenId` exists.
1046      *
1047      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1048      *
1049      * Tokens start existing when they are minted (`_mint`),
1050      */
1051     function _exists(uint256 tokenId) internal view returns (bool) {
1052         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1053     }
1054 
1055     /**
1056      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1057      */
1058     function _safeMint(address to, uint256 quantity) internal {
1059         _safeMint(to, quantity, '');
1060     }
1061 
1062     /**
1063      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1064      *
1065      * Requirements:
1066      *
1067      * - If `to` refers to a smart contract, it must implement
1068      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1069      * - `quantity` must be greater than 0.
1070      *
1071      * Emits a {Transfer} event.
1072      */
1073     function _safeMint(
1074         address to,
1075         uint256 quantity,
1076         bytes memory _data
1077     ) internal {
1078         uint256 startTokenId = _currentIndex;
1079         if (to == address(0)) revert MintToZeroAddress();
1080         if (quantity == 0) revert MintZeroQuantity();
1081 
1082         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1083 
1084         // Overflows are incredibly unrealistic.
1085         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1086         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1087         unchecked {
1088             _addressData[to].balance += uint64(quantity);
1089             _addressData[to].numberMinted += uint64(quantity);
1090 
1091             _ownerships[startTokenId].addr = to;
1092             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1093 
1094             uint256 updatedIndex = startTokenId;
1095             uint256 end = updatedIndex + quantity;
1096 
1097             if (to.isContract()) {
1098                 do {
1099                     emit Transfer(address(0), to, updatedIndex);
1100                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1101                         revert TransferToNonERC721ReceiverImplementer();
1102                     }
1103                 } while (updatedIndex < end);
1104                 // Reentrancy protection
1105                 if (_currentIndex != startTokenId) revert();
1106             } else {
1107                 do {
1108                     emit Transfer(address(0), to, updatedIndex++);
1109                 } while (updatedIndex < end);
1110             }
1111             _currentIndex = updatedIndex;
1112         }
1113         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1114     }
1115 
1116     /**
1117      * @dev Mints `quantity` tokens and transfers them to `to`.
1118      *
1119      * Requirements:
1120      *
1121      * - `to` cannot be the zero address.
1122      * - `quantity` must be greater than 0.
1123      *
1124      * Emits a {Transfer} event.
1125      */
1126     function _mint(address to, uint256 quantity) internal {
1127         uint256 startTokenId = _currentIndex;
1128         if (to == address(0)) revert MintToZeroAddress();
1129         if (quantity == 0) revert MintZeroQuantity();
1130 
1131         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1132 
1133         // Overflows are incredibly unrealistic.
1134         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1135         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1136         unchecked {
1137             _addressData[to].balance += uint64(quantity);
1138             _addressData[to].numberMinted += uint64(quantity);
1139 
1140             _ownerships[startTokenId].addr = to;
1141             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1142 
1143             uint256 updatedIndex = startTokenId;
1144             uint256 end = updatedIndex + quantity;
1145 
1146             do {
1147                 emit Transfer(address(0), to, updatedIndex++);
1148             } while (updatedIndex < end);
1149 
1150             _currentIndex = updatedIndex;
1151         }
1152         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1153     }
1154 
1155     /**
1156      * @dev Transfers `tokenId` from `from` to `to`.
1157      *
1158      * Requirements:
1159      *
1160      * - `to` cannot be the zero address.
1161      * - `tokenId` token must be owned by `from`.
1162      *
1163      * Emits a {Transfer} event.
1164      */
1165     function _transfer(
1166         address from,
1167         address to,
1168         uint256 tokenId
1169     ) private {
1170         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1171 
1172         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1173 
1174         bool isApprovedOrOwner = (_msgSender() == from ||
1175             isApprovedForAll(from, _msgSender()) ||
1176             getApproved(tokenId) == _msgSender());
1177 
1178         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1179         if (to == address(0)) revert TransferToZeroAddress();
1180 
1181         _beforeTokenTransfers(from, to, tokenId, 1);
1182 
1183         // Clear approvals from the previous owner
1184         _approve(address(0), tokenId, from);
1185 
1186         // Underflow of the sender's balance is impossible because we check for
1187         // ownership above and the recipient's balance can't realistically overflow.
1188         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1189         unchecked {
1190             _addressData[from].balance -= 1;
1191             _addressData[to].balance += 1;
1192 
1193             TokenOwnership storage currSlot = _ownerships[tokenId];
1194             currSlot.addr = to;
1195             currSlot.startTimestamp = uint64(block.timestamp);
1196 
1197             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1198             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1199             uint256 nextTokenId = tokenId + 1;
1200             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1201             if (nextSlot.addr == address(0)) {
1202                 // This will suffice for checking _exists(nextTokenId),
1203                 // as a burned slot cannot contain the zero address.
1204                 if (nextTokenId != _currentIndex) {
1205                     nextSlot.addr = from;
1206                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1207                 }
1208             }
1209         }
1210 
1211         emit Transfer(from, to, tokenId);
1212         _afterTokenTransfers(from, to, tokenId, 1);
1213     }
1214 
1215     /**
1216      * @dev Equivalent to `_burn(tokenId, false)`.
1217      */
1218     function _burn(uint256 tokenId) internal virtual {
1219         _burn(tokenId, false);
1220     }
1221 
1222     /**
1223      * @dev Destroys `tokenId`.
1224      * The approval is cleared when the token is burned.
1225      *
1226      * Requirements:
1227      *
1228      * - `tokenId` must exist.
1229      *
1230      * Emits a {Transfer} event.
1231      */
1232     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1233         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1234 
1235         address from = prevOwnership.addr;
1236 
1237         if (approvalCheck) {
1238             bool isApprovedOrOwner = (_msgSender() == from ||
1239                 isApprovedForAll(from, _msgSender()) ||
1240                 getApproved(tokenId) == _msgSender());
1241 
1242             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1243         }
1244 
1245         _beforeTokenTransfers(from, address(0), tokenId, 1);
1246 
1247         // Clear approvals from the previous owner
1248         _approve(address(0), tokenId, from);
1249 
1250         // Underflow of the sender's balance is impossible because we check for
1251         // ownership above and the recipient's balance can't realistically overflow.
1252         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1253         unchecked {
1254             AddressData storage addressData = _addressData[from];
1255             addressData.balance -= 1;
1256             addressData.numberBurned += 1;
1257 
1258             // Keep track of who burned the token, and the timestamp of burning.
1259             TokenOwnership storage currSlot = _ownerships[tokenId];
1260             currSlot.addr = from;
1261             currSlot.startTimestamp = uint64(block.timestamp);
1262             currSlot.burned = true;
1263 
1264             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1265             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1266             uint256 nextTokenId = tokenId + 1;
1267             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1268             if (nextSlot.addr == address(0)) {
1269                 // This will suffice for checking _exists(nextTokenId),
1270                 // as a burned slot cannot contain the zero address.
1271                 if (nextTokenId != _currentIndex) {
1272                     nextSlot.addr = from;
1273                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1274                 }
1275             }
1276         }
1277 
1278         emit Transfer(from, address(0), tokenId);
1279         _afterTokenTransfers(from, address(0), tokenId, 1);
1280 
1281         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1282         unchecked {
1283             _burnCounter++;
1284         }
1285     }
1286 
1287     /**
1288      * @dev Approve `to` to operate on `tokenId`
1289      *
1290      * Emits a {Approval} event.
1291      */
1292     function _approve(
1293         address to,
1294         uint256 tokenId,
1295         address owner
1296     ) private {
1297         _tokenApprovals[tokenId] = to;
1298         emit Approval(owner, to, tokenId);
1299     }
1300 
1301     /**
1302      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1303      *
1304      * @param from address representing the previous owner of the given token ID
1305      * @param to target address that will receive the tokens
1306      * @param tokenId uint256 ID of the token to be transferred
1307      * @param _data bytes optional data to send along with the call
1308      * @return bool whether the call correctly returned the expected magic value
1309      */
1310     function _checkContractOnERC721Received(
1311         address from,
1312         address to,
1313         uint256 tokenId,
1314         bytes memory _data
1315     ) private returns (bool) {
1316         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1317             return retval == IERC721Receiver(to).onERC721Received.selector;
1318         } catch (bytes memory reason) {
1319             if (reason.length == 0) {
1320                 revert TransferToNonERC721ReceiverImplementer();
1321             } else {
1322                 assembly {
1323                     revert(add(32, reason), mload(reason))
1324                 }
1325             }
1326         }
1327     }
1328 
1329     /**
1330      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1331      * And also called before burning one token.
1332      *
1333      * startTokenId - the first token id to be transferred
1334      * quantity - the amount to be transferred
1335      *
1336      * Calling conditions:
1337      *
1338      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1339      * transferred to `to`.
1340      * - When `from` is zero, `tokenId` will be minted for `to`.
1341      * - When `to` is zero, `tokenId` will be burned by `from`.
1342      * - `from` and `to` are never both zero.
1343      */
1344     function _beforeTokenTransfers(
1345         address from,
1346         address to,
1347         uint256 startTokenId,
1348         uint256 quantity
1349     ) internal virtual {}
1350 
1351     /**
1352      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1353      * minting.
1354      * And also called after one token has been burned.
1355      *
1356      * startTokenId - the first token id to be transferred
1357      * quantity - the amount to be transferred
1358      *
1359      * Calling conditions:
1360      *
1361      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1362      * transferred to `to`.
1363      * - When `from` is zero, `tokenId` has been minted for `to`.
1364      * - When `to` is zero, `tokenId` has been burned by `from`.
1365      * - `from` and `to` are never both zero.
1366      */
1367     function _afterTokenTransfers(
1368         address from,
1369         address to,
1370         uint256 startTokenId,
1371         uint256 quantity
1372     ) internal virtual {}
1373 }
1374 
1375 // File: @openzeppelin/contracts/access/Ownable.sol
1376 
1377 
1378 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1379 
1380 pragma solidity ^0.8.0;
1381 
1382 
1383 /**
1384  * @dev Contract module which provides a basic access control mechanism, where
1385  * there is an account (an owner) that can be granted exclusive access to
1386  * specific functions.
1387  *
1388  * By default, the owner account will be the one that deploys the contract. This
1389  * can later be changed with {transferOwnership}.
1390  *
1391  * This module is used through inheritance. It will make available the modifier
1392  * `onlyOwner`, which can be applied to your functions to restrict their use to
1393  * the owner.
1394  */
1395 abstract contract Ownable is Context {
1396     address private _owner;
1397 
1398     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1399 
1400     /**
1401      * @dev Initializes the contract setting the deployer as the initial owner.
1402      */
1403     constructor() {
1404         _transferOwnership(_msgSender());
1405     }
1406 
1407     /**
1408      * @dev Returns the address of the current owner.
1409      */
1410     function owner() public view virtual returns (address) {
1411         return _owner;
1412     }
1413 
1414     /**
1415      * @dev Throws if called by any account other than the owner.
1416      */
1417     modifier onlyOwner() {
1418         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1419         _;
1420     }
1421 
1422     /**
1423      * @dev Leaves the contract without owner. It will not be possible to call
1424      * `onlyOwner` functions anymore. Can only be called by the current owner.
1425      *
1426      * NOTE: Renouncing ownership will leave the contract without an owner,
1427      * thereby removing any functionality that is only available to the owner.
1428      */
1429     function renounceOwnership() public virtual onlyOwner {
1430         _transferOwnership(address(0));
1431     }
1432 
1433     /**
1434      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1435      * Can only be called by the current owner.
1436      */
1437     function transferOwnership(address newOwner) public virtual onlyOwner {
1438         require(newOwner != address(0), "Ownable: new owner is the zero address");
1439         _transferOwnership(newOwner);
1440     }
1441 
1442     /**
1443      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1444      * Internal function without access restriction.
1445      */
1446     function _transferOwnership(address newOwner) internal virtual {
1447         address oldOwner = _owner;
1448         _owner = newOwner;
1449         emit OwnershipTransferred(oldOwner, newOwner);
1450     }
1451 }
1452 
1453 
1454 
1455 pragma solidity ^0.8.0;
1456 
1457 error NotWhitelisted();
1458 
1459 contract Zombified is ERC721A, Ownable {
1460     bytes32 public root;
1461 	using Strings for uint;
1462 
1463 	uint public WL_MINT_PRICE = 0.009 ether;
1464 	uint public MAX_NFT_PER_TRAN = 1;
1465     uint public MAX_PER_WALLET = 1;
1466 	uint public maxSupply = 444;
1467 
1468     string public cpuPhase = "Unreleased";
1469 
1470     bool public isWhitelistMint = false;
1471     bool public isMetadataFinal;
1472     string public _baseURL = "ipfs://bafybeifietfaeutoxzjesncc3wpflfqos247zwyzkfzvivo5kb4qkil6ra/";
1473 	string public prerevealURL = "";
1474 	mapping(address => uint) private _walletMintedCount;
1475 
1476     // Name
1477 	constructor()
1478 	ERC721A('Zombified', 'ZOMBIFIED') {
1479     }
1480 
1481     function advancePhase(string calldata newPhase) external onlyOwner {
1482 		cpuPhase = newPhase;
1483 	}
1484 
1485 	function _baseURI() internal view override returns (string memory) {
1486 		return _baseURL;
1487 	}
1488 
1489 	function _startTokenId() internal pure override returns (uint) {
1490 		return 1;
1491 	}
1492 
1493 	function contractURI() public pure returns (string memory) {
1494 		return "";
1495 	}
1496 
1497     function finalizeMetadata() external onlyOwner {
1498         isMetadataFinal = true;
1499     }
1500 
1501 	function reveal(string memory url) external onlyOwner {
1502         require(!isMetadataFinal, "Metadata is finalized");
1503 		_baseURL = url;
1504 	}
1505 
1506     function setPrereveal(string memory url) external onlyOwner {
1507 		prerevealURL = url;
1508 	}
1509 
1510     function mintedCount(address owner) external view returns (uint) {
1511         return _walletMintedCount[owner];
1512     }
1513 
1514     function setRoot(bytes32 _root) external onlyOwner {
1515 		root = _root;
1516 	}
1517 
1518 	function setPrice(uint newPrice) external onlyOwner {
1519 		WL_MINT_PRICE = newPrice;
1520 	}
1521 
1522     function setWhitelistState(bool value) external onlyOwner {
1523 		isWhitelistMint = value;
1524 	}
1525 
1526 
1527     // Splitter
1528     
1529     function withdraw() public onlyOwner {
1530         uint256 balance = address(this).balance;
1531 
1532         //Dev Wallet
1533         address _wallet1 = 0xd6e67ce446dC04dcF3F3556B8150F370D4c52A62;
1534         uint _payable1 = balance * 30 / 100; // 30%
1535         payable(_wallet1).transfer(_payable1);
1536 
1537         //Founder Wallet
1538         address _wallet2 = 0x54d2B7Ee2A0A5F27C41d4dC36349de82D57CFa69;
1539         uint _payable2 = balance * 70 / 100; // 70%
1540         payable(_wallet2).transfer(_payable2);
1541     }
1542 
1543     // function withdraw() public onlyOwner {
1544     //     uint256 balance = address(this).balance;
1545     //     payable(msg.sender).transfer(balance);
1546     // }
1547 
1548 	function reserveMint(address to, uint count) external onlyOwner {
1549 		require(
1550 			_totalMinted() + count <= maxSupply,
1551 			'Exceeds max supply'
1552 		);
1553 		_safeMint(to, count);
1554 	}
1555 
1556 	function reduceSupply(uint newMaxSupply) external onlyOwner {
1557 		maxSupply = newMaxSupply;
1558 	}
1559 
1560     function setMaxMints(uint newMaxMints) external onlyOwner {
1561 		MAX_PER_WALLET = newMaxMints;
1562 	}
1563 
1564 	function tokenURI(uint tokenId)
1565 		public
1566 		view
1567 		override
1568 		returns (string memory)
1569 	{
1570         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1571 
1572         return bytes(_baseURI()).length > 0 
1573             ? string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"))
1574             : prerevealURL;
1575 	}
1576 
1577 	function isValid(bytes32[] memory proof, bytes32 leaf) public view returns (bool) {
1578         return MerkleProof.verify(proof, root, leaf);
1579     }
1580 
1581     function zombifyHuman(bytes32[] memory proof) external payable {
1582         uint count = 1;
1583         
1584         //require(isValid(proof, keccak256(abi.encodePacked(msg.sender))), "You are not on the allowlist");
1585         if (!( isValid( proof, keccak256(abi.encodePacked(msg.sender)) ) )) {
1586             revert NotWhitelisted();
1587         }
1588 
1589 		require(isWhitelistMint, "Whitelist mint has not started");
1590 		require(count <= MAX_NFT_PER_TRAN,'Exceeds NFT per transaction limit');
1591 		require(_totalMinted() + count <= maxSupply,'Exceeds max supply');
1592         require(_walletMintedCount[msg.sender] + count <= MAX_PER_WALLET,'Exceeds max per wallet');
1593 
1594 		require(
1595 			msg.value >= count * WL_MINT_PRICE,
1596 			'Ether value sent is not sufficient'
1597 		);
1598 
1599 		_walletMintedCount[msg.sender] += count;
1600 		_safeMint(msg.sender, count);
1601 	}
1602 }