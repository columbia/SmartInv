1 // SPDX-License-Identifier: GPL-3.0
2 // File: AceMiners/MerkleProof.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev These functions deal with verification of Merkle Trees proofs.
11  *
12  * The proofs can be generated using the JavaScript library
13  * https://github.com/miguelmota/merkletreejs[merkletreejs].
14  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
15  *
16  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
17  */
18 library MerkleProof {
19     /**
20      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
21      * defined by `root`. For this, a `proof` must be provided, containing
22      * sibling hashes on the branch from the leaf to the root of the tree. Each
23      * pair of leaves and each pair of pre-images are assumed to be sorted.
24      */
25     function verify(
26         bytes32[] memory proof,
27         bytes32 root,
28         bytes32 leaf
29     ) internal pure returns (bool) {
30         return processProof(proof, leaf) == root;
31     }
32 
33     /**
34      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
35      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
36      * hash matches the root of the tree. When processing the proof, the pairs
37      * of leafs & pre-images are assumed to be sorted.
38      *
39      * _Available since v4.4._
40      */
41     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
42         bytes32 computedHash = leaf;
43         for (uint256 i = 0; i < proof.length; i++) {
44             bytes32 proofElement = proof[i];
45             if (computedHash <= proofElement) {
46                 // Hash(current computed hash + current element of the proof)
47                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
48             } else {
49                 // Hash(current element of the proof + current computed hash)
50                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
51             }
52         }
53         return computedHash;
54     }
55 }
56 // File: @openzeppelin/contracts/utils/Strings.sol
57 
58 
59 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
60 
61 pragma solidity ^0.8.0;
62 
63 /**
64  * @dev String operations.
65  */
66 library Strings {
67     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
68 
69     /**
70      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
71      */
72     function toString(uint256 value) internal pure returns (string memory) {
73         // Inspired by OraclizeAPI's implementation - MIT licence
74         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
75 
76         if (value == 0) {
77             return "0";
78         }
79         uint256 temp = value;
80         uint256 digits;
81         while (temp != 0) {
82             digits++;
83             temp /= 10;
84         }
85         bytes memory buffer = new bytes(digits);
86         while (value != 0) {
87             digits -= 1;
88             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
89             value /= 10;
90         }
91         return string(buffer);
92     }
93 
94     /**
95      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
96      */
97     function toHexString(uint256 value) internal pure returns (string memory) {
98         if (value == 0) {
99             return "0x00";
100         }
101         uint256 temp = value;
102         uint256 length = 0;
103         while (temp != 0) {
104             length++;
105             temp >>= 8;
106         }
107         return toHexString(value, length);
108     }
109 
110     /**
111      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
112      */
113     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
114         bytes memory buffer = new bytes(2 * length + 2);
115         buffer[0] = "0";
116         buffer[1] = "x";
117         for (uint256 i = 2 * length + 1; i > 1; --i) {
118             buffer[i] = _HEX_SYMBOLS[value & 0xf];
119             value >>= 4;
120         }
121         require(value == 0, "Strings: hex length insufficient");
122         return string(buffer);
123     }
124 }
125 
126 // File: @openzeppelin/contracts/utils/Context.sol
127 
128 
129 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
130 
131 pragma solidity ^0.8.0;
132 
133 /**
134  * @dev Provides information about the current execution context, including the
135  * sender of the transaction and its data. While these are generally available
136  * via msg.sender and msg.data, they should not be accessed in such a direct
137  * manner, since when dealing with meta-transactions the account sending and
138  * paying for execution may not be the actual sender (as far as an application
139  * is concerned).
140  *
141  * This contract is only required for intermediate, library-like contracts.
142  */
143 abstract contract Context {
144     function _msgSender() internal view virtual returns (address) {
145         return msg.sender;
146     }
147 
148     function _msgData() internal view virtual returns (bytes calldata) {
149         return msg.data;
150     }
151 }
152 
153 // File: @openzeppelin/contracts/utils/Address.sol
154 
155 
156 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
157 
158 pragma solidity ^0.8.1;
159 
160 /**
161  * @dev Collection of functions related to the address type
162  */
163 library Address {
164     /**
165      * @dev Returns true if `account` is a contract.
166      *
167      * [IMPORTANT]
168      * ====
169      * It is unsafe to assume that an address for which this function returns
170      * false is an externally-owned account (EOA) and not a contract.
171      *
172      * Among others, `isContract` will return false for the following
173      * types of addresses:
174      *
175      *  - an externally-owned account
176      *  - a contract in construction
177      *  - an address where a contract will be created
178      *  - an address where a contract lived, but was destroyed
179      * ====
180      *
181      * [IMPORTANT]
182      * ====
183      * You shouldn't rely on `isContract` to protect against flash loan attacks!
184      *
185      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
186      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
187      * constructor.
188      * ====
189      */
190     function isContract(address account) internal view returns (bool) {
191         // This method relies on extcodesize/address.code.length, which returns 0
192         // for contracts in construction, since the code is only stored at the end
193         // of the constructor execution.
194 
195         return account.code.length > 0;
196     }
197 
198     /**
199      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
200      * `recipient`, forwarding all available gas and reverting on errors.
201      *
202      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
203      * of certain opcodes, possibly making contracts go over the 2300 gas limit
204      * imposed by `transfer`, making them unable to receive funds via
205      * `transfer`. {sendValue} removes this limitation.
206      *
207      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
208      *
209      * IMPORTANT: because control is transferred to `recipient`, care must be
210      * taken to not create reentrancy vulnerabilities. Consider using
211      * {ReentrancyGuard} or the
212      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
213      */
214     function sendValue(address payable recipient, uint256 amount) internal {
215         require(address(this).balance >= amount, "Address: insufficient balance");
216 
217         (bool success, ) = recipient.call{value: amount}("");
218         require(success, "Address: unable to send value, recipient may have reverted");
219     }
220 
221     /**
222      * @dev Performs a Solidity function call using a low level `call`. A
223      * plain `call` is an unsafe replacement for a function call: use this
224      * function instead.
225      *
226      * If `target` reverts with a revert reason, it is bubbled up by this
227      * function (like regular Solidity function calls).
228      *
229      * Returns the raw returned data. To convert to the expected return value,
230      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
231      *
232      * Requirements:
233      *
234      * - `target` must be a contract.
235      * - calling `target` with `data` must not revert.
236      *
237      * _Available since v3.1._
238      */
239     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
240         return functionCall(target, data, "Address: low-level call failed");
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
245      * `errorMessage` as a fallback revert reason when `target` reverts.
246      *
247      * _Available since v3.1._
248      */
249     function functionCall(
250         address target,
251         bytes memory data,
252         string memory errorMessage
253     ) internal returns (bytes memory) {
254         return functionCallWithValue(target, data, 0, errorMessage);
255     }
256 
257     /**
258      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
259      * but also transferring `value` wei to `target`.
260      *
261      * Requirements:
262      *
263      * - the calling contract must have an ETH balance of at least `value`.
264      * - the called Solidity function must be `payable`.
265      *
266      * _Available since v3.1._
267      */
268     function functionCallWithValue(
269         address target,
270         bytes memory data,
271         uint256 value
272     ) internal returns (bytes memory) {
273         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
278      * with `errorMessage` as a fallback revert reason when `target` reverts.
279      *
280      * _Available since v3.1._
281      */
282     function functionCallWithValue(
283         address target,
284         bytes memory data,
285         uint256 value,
286         string memory errorMessage
287     ) internal returns (bytes memory) {
288         require(address(this).balance >= value, "Address: insufficient balance for call");
289         require(isContract(target), "Address: call to non-contract");
290 
291         (bool success, bytes memory returndata) = target.call{value: value}(data);
292         return verifyCallResult(success, returndata, errorMessage);
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
297      * but performing a static call.
298      *
299      * _Available since v3.3._
300      */
301     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
302         return functionStaticCall(target, data, "Address: low-level static call failed");
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
307      * but performing a static call.
308      *
309      * _Available since v3.3._
310      */
311     function functionStaticCall(
312         address target,
313         bytes memory data,
314         string memory errorMessage
315     ) internal view returns (bytes memory) {
316         require(isContract(target), "Address: static call to non-contract");
317 
318         (bool success, bytes memory returndata) = target.staticcall(data);
319         return verifyCallResult(success, returndata, errorMessage);
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
324      * but performing a delegate call.
325      *
326      * _Available since v3.4._
327      */
328     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
329         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
334      * but performing a delegate call.
335      *
336      * _Available since v3.4._
337      */
338     function functionDelegateCall(
339         address target,
340         bytes memory data,
341         string memory errorMessage
342     ) internal returns (bytes memory) {
343         require(isContract(target), "Address: delegate call to non-contract");
344 
345         (bool success, bytes memory returndata) = target.delegatecall(data);
346         return verifyCallResult(success, returndata, errorMessage);
347     }
348 
349     /**
350      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
351      * revert reason using the provided one.
352      *
353      * _Available since v4.3._
354      */
355     function verifyCallResult(
356         bool success,
357         bytes memory returndata,
358         string memory errorMessage
359     ) internal pure returns (bytes memory) {
360         if (success) {
361             return returndata;
362         } else {
363             // Look for revert reason and bubble it up if present
364             if (returndata.length > 0) {
365                 // The easiest way to bubble the revert reason is using memory via assembly
366 
367                 assembly {
368                     let returndata_size := mload(returndata)
369                     revert(add(32, returndata), returndata_size)
370                 }
371             } else {
372                 revert(errorMessage);
373             }
374         }
375     }
376 }
377 
378 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
379 
380 
381 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
382 
383 pragma solidity ^0.8.0;
384 
385 /**
386  * @title ERC721 token receiver interface
387  * @dev Interface for any contract that wants to support safeTransfers
388  * from ERC721 asset contracts.
389  */
390 interface IERC721Receiver {
391     /**
392      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
393      * by `operator` from `from`, this function is called.
394      *
395      * It must return its Solidity selector to confirm the token transfer.
396      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
397      *
398      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
399      */
400     function onERC721Received(
401         address operator,
402         address from,
403         uint256 tokenId,
404         bytes calldata data
405     ) external returns (bytes4);
406 }
407 
408 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
409 
410 
411 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
412 
413 pragma solidity ^0.8.0;
414 
415 /**
416  * @dev Interface of the ERC165 standard, as defined in the
417  * https://eips.ethereum.org/EIPS/eip-165[EIP].
418  *
419  * Implementers can declare support of contract interfaces, which can then be
420  * queried by others ({ERC165Checker}).
421  *
422  * For an implementation, see {ERC165}.
423  */
424 interface IERC165 {
425     /**
426      * @dev Returns true if this contract implements the interface defined by
427      * `interfaceId`. See the corresponding
428      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
429      * to learn more about how these ids are created.
430      *
431      * This function call must use less than 30 000 gas.
432      */
433     function supportsInterface(bytes4 interfaceId) external view returns (bool);
434 }
435 
436 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
437 
438 
439 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
440 
441 pragma solidity ^0.8.0;
442 
443 
444 /**
445  * @dev Implementation of the {IERC165} interface.
446  *
447  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
448  * for the additional interface id that will be supported. For example:
449  *
450  * ```solidity
451  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
452  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
453  * }
454  * ```
455  *
456  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
457  */
458 abstract contract ERC165 is IERC165 {
459     /**
460      * @dev See {IERC165-supportsInterface}.
461      */
462     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
463         return interfaceId == type(IERC165).interfaceId;
464     }
465 }
466 
467 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
468 
469 
470 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
471 
472 pragma solidity ^0.8.0;
473 
474 
475 /**
476  * @dev Required interface of an ERC721 compliant contract.
477  */
478 interface IERC721 is IERC165 {
479     /**
480      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
481      */
482     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
483 
484     /**
485      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
486      */
487     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
488 
489     /**
490      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
491      */
492     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
493 
494     /**
495      * @dev Returns the number of tokens in ``owner``'s account.
496      */
497     function balanceOf(address owner) external view returns (uint256 balance);
498 
499     /**
500      * @dev Returns the owner of the `tokenId` token.
501      *
502      * Requirements:
503      *
504      * - `tokenId` must exist.
505      */
506     function ownerOf(uint256 tokenId) external view returns (address owner);
507 
508     /**
509      * @dev Safely transfers `tokenId` token from `from` to `to`.
510      *
511      * Requirements:
512      *
513      * - `from` cannot be the zero address.
514      * - `to` cannot be the zero address.
515      * - `tokenId` token must exist and be owned by `from`.
516      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
517      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
518      *
519      * Emits a {Transfer} event.
520      */
521     function safeTransferFrom(
522         address from,
523         address to,
524         uint256 tokenId,
525         bytes calldata data
526     ) external;
527 
528     /**
529      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
530      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
531      *
532      * Requirements:
533      *
534      * - `from` cannot be the zero address.
535      * - `to` cannot be the zero address.
536      * - `tokenId` token must exist and be owned by `from`.
537      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
538      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
539      *
540      * Emits a {Transfer} event.
541      */
542     function safeTransferFrom(
543         address from,
544         address to,
545         uint256 tokenId
546     ) external;
547 
548     /**
549      * @dev Transfers `tokenId` token from `from` to `to`.
550      *
551      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
552      *
553      * Requirements:
554      *
555      * - `from` cannot be the zero address.
556      * - `to` cannot be the zero address.
557      * - `tokenId` token must be owned by `from`.
558      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
559      *
560      * Emits a {Transfer} event.
561      */
562     function transferFrom(
563         address from,
564         address to,
565         uint256 tokenId
566     ) external;
567 
568     /**
569      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
570      * The approval is cleared when the token is transferred.
571      *
572      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
573      *
574      * Requirements:
575      *
576      * - The caller must own the token or be an approved operator.
577      * - `tokenId` must exist.
578      *
579      * Emits an {Approval} event.
580      */
581     function approve(address to, uint256 tokenId) external;
582 
583     /**
584      * @dev Approve or remove `operator` as an operator for the caller.
585      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
586      *
587      * Requirements:
588      *
589      * - The `operator` cannot be the caller.
590      *
591      * Emits an {ApprovalForAll} event.
592      */
593     function setApprovalForAll(address operator, bool _approved) external;
594 
595     /**
596      * @dev Returns the account approved for `tokenId` token.
597      *
598      * Requirements:
599      *
600      * - `tokenId` must exist.
601      */
602     function getApproved(uint256 tokenId) external view returns (address operator);
603 
604     /**
605      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
606      *
607      * See {setApprovalForAll}
608      */
609     function isApprovedForAll(address owner, address operator) external view returns (bool);
610 }
611 
612 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
613 
614 
615 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
616 
617 pragma solidity ^0.8.0;
618 
619 
620 /**
621  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
622  * @dev See https://eips.ethereum.org/EIPS/eip-721
623  */
624 interface IERC721Metadata is IERC721 {
625     /**
626      * @dev Returns the token collection name.
627      */
628     function name() external view returns (string memory);
629 
630     /**
631      * @dev Returns the token collection symbol.
632      */
633     function symbol() external view returns (string memory);
634 
635     /**
636      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
637      */
638     function tokenURI(uint256 tokenId) external view returns (string memory);
639 }
640 
641 // File: AceMiners/ERC721A.sol
642 
643 
644 // Creator: Chiru Labs
645 
646 pragma solidity ^0.8.4;
647 
648 
649 
650 
651 
652 
653 
654 
655 error ApprovalCallerNotOwnerNorApproved();
656 error ApprovalQueryForNonexistentToken();
657 error ApproveToCaller();
658 error ApprovalToCurrentOwner();
659 error BalanceQueryForZeroAddress();
660 error MintToZeroAddress();
661 error MintZeroQuantity();
662 error OwnerQueryForNonexistentToken();
663 error TransferCallerNotOwnerNorApproved();
664 error TransferFromIncorrectOwner();
665 error TransferToNonERC721ReceiverImplementer();
666 error TransferToZeroAddress();
667 error URIQueryForNonexistentToken();
668 
669 /**
670  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
671  * the Metadata extension. Built to optimize for lower gas during batch mints.
672  *
673  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
674  *
675  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
676  *
677  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
678  */
679 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
680     using Address for address;
681     using Strings for uint256;
682 
683     // Compiler will pack this into a single 256bit word.
684     struct TokenOwnership {
685         // The address of the owner.
686         address addr;
687         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
688         uint64 startTimestamp;
689         // Whether the token has been burned.
690         bool burned;
691     }
692 
693     // Compiler will pack this into a single 256bit word.
694     struct AddressData {
695         // Realistically, 2**64-1 is more than enough.
696         uint64 balance;
697         // Keeps track of mint count with minimal overhead for tokenomics.
698         uint64 numberMinted;
699         // Keeps track of burn count with minimal overhead for tokenomics.
700         uint64 numberBurned;
701         // For miscellaneous variable(s) pertaining to the address
702         // (e.g. number of whitelist mint slots used).
703         // If there are multiple variables, please pack them into a uint64.
704         uint64 aux;
705     }
706 
707     // The tokenId of the next token to be minted.
708     uint256 internal _currentIndex;
709 
710     // The number of tokens burned.
711     uint256 internal _burnCounter;
712 
713     // Token name
714     string private _name;
715 
716     // Token symbol
717     string private _symbol;
718 
719     // Mapping from token ID to ownership details
720     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
721     mapping(uint256 => TokenOwnership) internal _ownerships;
722 
723     // Mapping owner address to address data
724     mapping(address => AddressData) private _addressData;
725 
726     // Mapping from token ID to approved address
727     mapping(uint256 => address) private _tokenApprovals;
728 
729     // Mapping from owner to operator approvals
730     mapping(address => mapping(address => bool)) private _operatorApprovals;
731 
732     constructor(string memory name_, string memory symbol_) {
733         _name = name_;
734         _symbol = symbol_;
735         _currentIndex = _startTokenId();
736     }
737 
738     /**
739      * To change the starting tokenId, please override this function.
740      */
741     function _startTokenId() internal view virtual returns (uint256) {
742         return 0;
743     }
744 
745     /**
746      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
747      */
748     function totalSupply() public view returns (uint256) {
749         // Counter underflow is impossible as _burnCounter cannot be incremented
750         // more than _currentIndex - _startTokenId() times
751         unchecked {
752             return _currentIndex - _burnCounter - _startTokenId();
753         }
754     }
755 
756     /**
757      * Returns the total amount of tokens minted in the contract.
758      */
759     function _totalMinted() internal view returns (uint256) {
760         // Counter underflow is impossible as _currentIndex does not decrement,
761         // and it is initialized to _startTokenId()
762         unchecked {
763             return _currentIndex - _startTokenId();
764         }
765     }
766 
767     /**
768      * @dev See {IERC165-supportsInterface}.
769      */
770     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
771         return
772             interfaceId == type(IERC721).interfaceId ||
773             interfaceId == type(IERC721Metadata).interfaceId ||
774             super.supportsInterface(interfaceId);
775     }
776 
777     /**
778      * @dev See {IERC721-balanceOf}.
779      */
780     function balanceOf(address owner) public view override returns (uint256) {
781         if (owner == address(0)) revert BalanceQueryForZeroAddress();
782         return uint256(_addressData[owner].balance);
783     }
784 
785     /**
786      * Returns the number of tokens minted by `owner`.
787      */
788     function _numberMinted(address owner) internal view returns (uint256) {
789         return uint256(_addressData[owner].numberMinted);
790     }
791 
792     /**
793      * Returns the number of tokens burned by or on behalf of `owner`.
794      */
795     function _numberBurned(address owner) internal view returns (uint256) {
796         return uint256(_addressData[owner].numberBurned);
797     }
798 
799     /**
800      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
801      */
802     function _getAux(address owner) internal view returns (uint64) {
803         return _addressData[owner].aux;
804     }
805 
806     /**
807      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
808      * If there are multiple variables, please pack them into a uint64.
809      */
810     function _setAux(address owner, uint64 aux) internal {
811         _addressData[owner].aux = aux;
812     }
813 
814     /**
815      * Gas spent here starts off proportional to the maximum mint batch size.
816      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
817      */
818     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
819         uint256 curr = tokenId;
820 
821         unchecked {
822             if (_startTokenId() <= curr && curr < _currentIndex) {
823                 TokenOwnership memory ownership = _ownerships[curr];
824                 if (!ownership.burned) {
825                     if (ownership.addr != address(0)) {
826                         return ownership;
827                     }
828                     // Invariant:
829                     // There will always be an ownership that has an address and is not burned
830                     // before an ownership that does not have an address and is not burned.
831                     // Hence, curr will not underflow.
832                     while (true) {
833                         curr--;
834                         ownership = _ownerships[curr];
835                         if (ownership.addr != address(0)) {
836                             return ownership;
837                         }
838                     }
839                 }
840             }
841         }
842         revert OwnerQueryForNonexistentToken();
843     }
844 
845     /**
846      * @dev See {IERC721-ownerOf}.
847      */
848     function ownerOf(uint256 tokenId) public view override returns (address) {
849         return _ownershipOf(tokenId).addr;
850     }
851 
852     /**
853      * @dev See {IERC721Metadata-name}.
854      */
855     function name() public view virtual override returns (string memory) {
856         return _name;
857     }
858 
859     /**
860      * @dev See {IERC721Metadata-symbol}.
861      */
862     function symbol() public view virtual override returns (string memory) {
863         return _symbol;
864     }
865 
866     /**
867      * @dev See {IERC721Metadata-tokenURI}.
868      */
869     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
870         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
871 
872         string memory baseURI = _baseURI();
873         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
874     }
875 
876     /**
877      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
878      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
879      * by default, can be overriden in child contracts.
880      */
881     function _baseURI() internal view virtual returns (string memory) {
882         return '';
883     }
884 
885     /**
886      * @dev See {IERC721-approve}.
887      */
888     function approve(address to, uint256 tokenId) public override {
889         address owner = ERC721A.ownerOf(tokenId);
890         if (to == owner) revert ApprovalToCurrentOwner();
891 
892         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
893             revert ApprovalCallerNotOwnerNorApproved();
894         }
895 
896         _approve(to, tokenId, owner);
897     }
898 
899     /**
900      * @dev See {IERC721-getApproved}.
901      */
902     function getApproved(uint256 tokenId) public view override returns (address) {
903         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
904 
905         return _tokenApprovals[tokenId];
906     }
907 
908     /**
909      * @dev See {IERC721-setApprovalForAll}.
910      */
911     function setApprovalForAll(address operator, bool approved) public virtual override {
912         if (operator == _msgSender()) revert ApproveToCaller();
913 
914         _operatorApprovals[_msgSender()][operator] = approved;
915         emit ApprovalForAll(_msgSender(), operator, approved);
916     }
917 
918     /**
919      * @dev See {IERC721-isApprovedForAll}.
920      */
921     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
922         return _operatorApprovals[owner][operator];
923     }
924 
925     /**
926      * @dev See {IERC721-transferFrom}.
927      */
928     function transferFrom(
929         address from,
930         address to,
931         uint256 tokenId
932     ) public virtual override {
933         _transfer(from, to, tokenId);
934     }
935 
936     /**
937      * @dev See {IERC721-safeTransferFrom}.
938      */
939     function safeTransferFrom(
940         address from,
941         address to,
942         uint256 tokenId
943     ) public virtual override {
944         safeTransferFrom(from, to, tokenId, '');
945     }
946 
947     /**
948      * @dev See {IERC721-safeTransferFrom}.
949      */
950     function safeTransferFrom(
951         address from,
952         address to,
953         uint256 tokenId,
954         bytes memory _data
955     ) public virtual override {
956         _transfer(from, to, tokenId);
957         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
958             revert TransferToNonERC721ReceiverImplementer();
959         }
960     }
961 
962     /**
963      * @dev Returns whether `tokenId` exists.
964      *
965      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
966      *
967      * Tokens start existing when they are minted (`_mint`),
968      */
969     function _exists(uint256 tokenId) internal view returns (bool) {
970         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
971             !_ownerships[tokenId].burned;
972     }
973 
974     function _safeMint(address to, uint256 quantity) internal {
975         _safeMint(to, quantity, '');
976     }
977 
978     /**
979      * @dev Safely mints `quantity` tokens and transfers them to `to`.
980      *
981      * Requirements:
982      *
983      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
984      * - `quantity` must be greater than 0.
985      *
986      * Emits a {Transfer} event.
987      */
988     function _safeMint(
989         address to,
990         uint256 quantity,
991         bytes memory _data
992     ) internal {
993         _mint(to, quantity, _data, true);
994     }
995 
996     /**
997      * @dev Mints `quantity` tokens and transfers them to `to`.
998      *
999      * Requirements:
1000      *
1001      * - `to` cannot be the zero address.
1002      * - `quantity` must be greater than 0.
1003      *
1004      * Emits a {Transfer} event.
1005      */
1006     function _mint(
1007         address to,
1008         uint256 quantity,
1009         bytes memory _data,
1010         bool safe
1011     ) internal {
1012         uint256 startTokenId = _currentIndex;
1013         if (to == address(0)) revert MintToZeroAddress();
1014         if (quantity == 0) revert MintZeroQuantity();
1015 
1016         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1017 
1018         // Overflows are incredibly unrealistic.
1019         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1020         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1021         unchecked {
1022             _addressData[to].balance += uint64(quantity);
1023             _addressData[to].numberMinted += uint64(quantity);
1024 
1025             _ownerships[startTokenId].addr = to;
1026             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1027 
1028             uint256 updatedIndex = startTokenId;
1029             uint256 end = updatedIndex + quantity;
1030 
1031             if (safe && to.isContract()) {
1032                 do {
1033                     emit Transfer(address(0), to, updatedIndex);
1034                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1035                         revert TransferToNonERC721ReceiverImplementer();
1036                     }
1037                 } while (updatedIndex != end);
1038                 // Reentrancy protection
1039                 if (_currentIndex != startTokenId) revert();
1040             } else {
1041                 do {
1042                     emit Transfer(address(0), to, updatedIndex++);
1043                 } while (updatedIndex != end);
1044             }
1045             _currentIndex = updatedIndex;
1046         }
1047         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1048     }
1049 
1050     /**
1051      * @dev Transfers `tokenId` from `from` to `to`.
1052      *
1053      * Requirements:
1054      *
1055      * - `to` cannot be the zero address.
1056      * - `tokenId` token must be owned by `from`.
1057      *
1058      * Emits a {Transfer} event.
1059      */
1060     function _transfer(
1061         address from,
1062         address to,
1063         uint256 tokenId
1064     ) private {
1065         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1066 
1067         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1068 
1069         bool isApprovedOrOwner = (_msgSender() == from ||
1070             isApprovedForAll(from, _msgSender()) ||
1071             getApproved(tokenId) == _msgSender());
1072 
1073         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1074         if (to == address(0)) revert TransferToZeroAddress();
1075 
1076         _beforeTokenTransfers(from, to, tokenId, 1);
1077 
1078         // Clear approvals from the previous owner
1079         _approve(address(0), tokenId, from);
1080 
1081         // Underflow of the sender's balance is impossible because we check for
1082         // ownership above and the recipient's balance can't realistically overflow.
1083         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1084         unchecked {
1085             _addressData[from].balance -= 1;
1086             _addressData[to].balance += 1;
1087 
1088             TokenOwnership storage currSlot = _ownerships[tokenId];
1089             currSlot.addr = to;
1090             currSlot.startTimestamp = uint64(block.timestamp);
1091 
1092             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1093             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1094             uint256 nextTokenId = tokenId + 1;
1095             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1096             if (nextSlot.addr == address(0)) {
1097                 // This will suffice for checking _exists(nextTokenId),
1098                 // as a burned slot cannot contain the zero address.
1099                 if (nextTokenId != _currentIndex) {
1100                     nextSlot.addr = from;
1101                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1102                 }
1103             }
1104         }
1105 
1106         emit Transfer(from, to, tokenId);
1107         _afterTokenTransfers(from, to, tokenId, 1);
1108     }
1109 
1110     /**
1111      * @dev This is equivalent to _burn(tokenId, false)
1112      */
1113     function _burn(uint256 tokenId) internal virtual {
1114         _burn(tokenId, false);
1115     }
1116 
1117     /**
1118      * @dev Destroys `tokenId`.
1119      * The approval is cleared when the token is burned.
1120      *
1121      * Requirements:
1122      *
1123      * - `tokenId` must exist.
1124      *
1125      * Emits a {Transfer} event.
1126      */
1127     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1128         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1129 
1130         address from = prevOwnership.addr;
1131 
1132         if (approvalCheck) {
1133             bool isApprovedOrOwner = (_msgSender() == from ||
1134                 isApprovedForAll(from, _msgSender()) ||
1135                 getApproved(tokenId) == _msgSender());
1136 
1137             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1138         }
1139 
1140         _beforeTokenTransfers(from, address(0), tokenId, 1);
1141 
1142         // Clear approvals from the previous owner
1143         _approve(address(0), tokenId, from);
1144 
1145         // Underflow of the sender's balance is impossible because we check for
1146         // ownership above and the recipient's balance can't realistically overflow.
1147         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1148         unchecked {
1149             AddressData storage addressData = _addressData[from];
1150             addressData.balance -= 1;
1151             addressData.numberBurned += 1;
1152 
1153             // Keep track of who burned the token, and the timestamp of burning.
1154             TokenOwnership storage currSlot = _ownerships[tokenId];
1155             currSlot.addr = from;
1156             currSlot.startTimestamp = uint64(block.timestamp);
1157             currSlot.burned = true;
1158 
1159             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1160             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1161             uint256 nextTokenId = tokenId + 1;
1162             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1163             if (nextSlot.addr == address(0)) {
1164                 // This will suffice for checking _exists(nextTokenId),
1165                 // as a burned slot cannot contain the zero address.
1166                 if (nextTokenId != _currentIndex) {
1167                     nextSlot.addr = from;
1168                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1169                 }
1170             }
1171         }
1172 
1173         emit Transfer(from, address(0), tokenId);
1174         _afterTokenTransfers(from, address(0), tokenId, 1);
1175 
1176         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1177         unchecked {
1178             _burnCounter++;
1179         }
1180     }
1181 
1182     /**
1183      * @dev Approve `to` to operate on `tokenId`
1184      *
1185      * Emits a {Approval} event.
1186      */
1187     function _approve(
1188         address to,
1189         uint256 tokenId,
1190         address owner
1191     ) private {
1192         _tokenApprovals[tokenId] = to;
1193         emit Approval(owner, to, tokenId);
1194     }
1195 
1196     /**
1197      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1198      *
1199      * @param from address representing the previous owner of the given token ID
1200      * @param to target address that will receive the tokens
1201      * @param tokenId uint256 ID of the token to be transferred
1202      * @param _data bytes optional data to send along with the call
1203      * @return bool whether the call correctly returned the expected magic value
1204      */
1205     function _checkContractOnERC721Received(
1206         address from,
1207         address to,
1208         uint256 tokenId,
1209         bytes memory _data
1210     ) private returns (bool) {
1211         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1212             return retval == IERC721Receiver(to).onERC721Received.selector;
1213         } catch (bytes memory reason) {
1214             if (reason.length == 0) {
1215                 revert TransferToNonERC721ReceiverImplementer();
1216             } else {
1217                 assembly {
1218                     revert(add(32, reason), mload(reason))
1219                 }
1220             }
1221         }
1222     }
1223 
1224     /**
1225      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1226      * And also called before burning one token.
1227      *
1228      * startTokenId - the first token id to be transferred
1229      * quantity - the amount to be transferred
1230      *
1231      * Calling conditions:
1232      *
1233      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1234      * transferred to `to`.
1235      * - When `from` is zero, `tokenId` will be minted for `to`.
1236      * - When `to` is zero, `tokenId` will be burned by `from`.
1237      * - `from` and `to` are never both zero.
1238      */
1239     function _beforeTokenTransfers(
1240         address from,
1241         address to,
1242         uint256 startTokenId,
1243         uint256 quantity
1244     ) internal virtual {}
1245 
1246     /**
1247      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1248      * minting.
1249      * And also called after one token has been burned.
1250      *
1251      * startTokenId - the first token id to be transferred
1252      * quantity - the amount to be transferred
1253      *
1254      * Calling conditions:
1255      *
1256      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1257      * transferred to `to`.
1258      * - When `from` is zero, `tokenId` has been minted for `to`.
1259      * - When `to` is zero, `tokenId` has been burned by `from`.
1260      * - `from` and `to` are never both zero.
1261      */
1262     function _afterTokenTransfers(
1263         address from,
1264         address to,
1265         uint256 startTokenId,
1266         uint256 quantity
1267     ) internal virtual {}
1268 }
1269 
1270 // File: AceMiners/AceMiners.sol
1271 
1272 
1273 
1274 pragma solidity >=0.7.0 <0.9.0;
1275 
1276 
1277 
1278 /**
1279  * @dev Contract module which provides a basic access control mechanism, where
1280  * there is an account (an owner) that can be granted exclusive access to
1281  * specific functions.
1282  *
1283  * By default, the owner account will be the one that deploys the contract. This
1284  * can later be changed with {transferOwnership}.
1285  *
1286  * This module is used through inheritance. It will make available the modifier
1287  * `onlyOwner`, which can be applied to your functions to restrict their use to
1288  * the owner.
1289  */
1290 abstract contract Ownable is Context {
1291     address private _owner;
1292 
1293     event OwnershipTransferred(
1294         address indexed previousOwner,
1295         address indexed newOwner
1296     );
1297 
1298     /**
1299      * @dev Initializes the contract setting the deployer as the initial owner.
1300      */
1301     constructor() {
1302         _transferOwnership(_msgSender());
1303     }
1304 
1305     /**
1306      * @dev Returns the address of the current owner.
1307      */
1308     function owner() public view virtual returns (address) {
1309         return _owner;
1310     }
1311 
1312     /**
1313      * @dev Throws if called by any account other than the owner.
1314      */
1315     modifier onlyOwner() {
1316         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1317         _;
1318     }
1319 
1320     /**
1321      * @dev Leaves the contract without owner. It will not be possible to call
1322      * `onlyOwner` functions anymore. Can only be called by the current owner.
1323      *
1324      * NOTE: Renouncing ownership will leave the contract without an owner,
1325      * thereby removing any functionality that is only available to the owner.
1326      */
1327     function renounceOwnership() public virtual onlyOwner {
1328         _transferOwnership(address(0));
1329     }
1330 
1331     /**
1332      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1333      * Can only be called by the current owner.
1334      */
1335     function transferOwnership(address newOwner) public virtual onlyOwner {
1336         require(
1337             newOwner != address(0),
1338             "Ownable: new owner is the zero address"
1339         );
1340         _transferOwnership(newOwner);
1341     }
1342 
1343     /**
1344      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1345      * Internal function without access restriction.
1346      */
1347     function _transferOwnership(address newOwner) internal virtual {
1348         address oldOwner = _owner;
1349         _owner = newOwner;
1350         emit OwnershipTransferred(oldOwner, newOwner);
1351     }
1352 }
1353 
1354 contract AceMinersP2 is ERC721A, Ownable {
1355     using Strings for uint256;
1356 
1357     string public baseURI;
1358     string public baseExtension = ".json";
1359     string public notRevealedUri;
1360     uint256 public costWL = 0.26 ether;
1361     uint256 public cost = 0.36 ether;
1362     uint256 public maxSupply = 1500;
1363     uint256 public maxMintAmountWL = 2;
1364     uint256 public maxMintAmountEarlyAccess = 2;
1365     uint256 public maxMintAmountPublic = 10;
1366     uint256 public nftPerAddressLimitWL = 7;
1367 
1368     bool public revealed = false;
1369     mapping(address => uint256) public addressMintedBalanceWL;
1370     mapping(address => uint256) public addressMintedBalance;
1371 
1372     uint256 public currentState = 0;
1373 
1374     mapping(address => bool) public whitelistedAddresses;
1375 
1376     bytes32 public merkleRootWhitelist =
1377         0xc117da44cd8e89da7f09c9c2110a9e74054f2a2de428605e8103ff2c1560c4df;
1378 
1379     constructor() ERC721A("AceMiners P2", "ACE2") {}
1380 
1381     // internal
1382     function _baseURI() internal view virtual override returns (string memory) {
1383         return baseURI;
1384     }
1385 
1386     function mint(uint256 _mintAmount, bytes32[] calldata _merkleProof)
1387         public
1388         payable
1389     {
1390         uint256 supply = totalSupply();
1391         require(_mintAmount > 0, "need to mint at least 1 NFT");
1392         require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1393         if (msg.sender != owner()) {
1394             require(currentState > 0, "the contract is paused");
1395             if (currentState == 1) {
1396                 uint256 ownerMintedCount = addressMintedBalanceWL[msg.sender];
1397                 require(
1398                     isWhitelisted(msg.sender, _merkleProof),
1399                     "user is not whitelisted"
1400                 );
1401                 require(
1402                     _mintAmount <= maxMintAmountWL,
1403                     "max mint amount per session exceeded"
1404                 );
1405                 require(
1406                     ownerMintedCount + _mintAmount <= maxMintAmountWL,
1407                     "max NFT per address exceeded"
1408                 );
1409                 require(
1410                     msg.value >= costWL * _mintAmount,
1411                     "insufficient funds"
1412                 );
1413             } else if (currentState == 3) {
1414                 uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1415                 require(
1416                     _mintAmount <= maxMintAmountPublic,
1417                     "max mint amount per session exceeded"
1418                 );
1419                 require(
1420                     ownerMintedCount + _mintAmount <= maxMintAmountPublic,
1421                     "max NFT per address exceeded"
1422                 );
1423                 require(msg.value >= cost * _mintAmount, "insufficient funds");
1424             }
1425         }
1426 
1427         _safeMint(msg.sender, _mintAmount);
1428         if (currentState == 1) {
1429             addressMintedBalanceWL[msg.sender] += _mintAmount;
1430         } else if (currentState == 3) {
1431             addressMintedBalance[msg.sender] += _mintAmount;
1432         }
1433     }
1434 
1435     function isWhitelisted(address _user, bytes32[] calldata _merkleProof)
1436         public
1437         view
1438         returns (bool)
1439     {
1440         bytes32 leaf = keccak256(abi.encodePacked(_user));
1441         return MerkleProof.verify(_merkleProof, merkleRootWhitelist, leaf);
1442     }
1443 
1444     function mintableAmountForUser(address _user) public view returns (uint256) {
1445         if (currentState == 1) {
1446             return maxMintAmountWL - addressMintedBalanceWL[_user];
1447         } else if (currentState == 3) {
1448             return maxMintAmountPublic - addressMintedBalance[_user];
1449         }
1450         return 0;
1451     }
1452 
1453     function tokenURI(uint256 tokenId)
1454         public
1455         view
1456         virtual
1457         override
1458         returns (string memory)
1459     {
1460         require(
1461             _exists(tokenId),
1462             "ERC721Metadata: URI query for nonexistent token"
1463         );
1464 
1465         if (revealed == false) {
1466             return notRevealedUri;
1467         }
1468 
1469         string memory currentBaseURI = _baseURI();
1470         return
1471             bytes(currentBaseURI).length > 0
1472                 ? string(
1473                     abi.encodePacked(
1474                         currentBaseURI,
1475                         tokenId.toString(),
1476                         baseExtension
1477                     )
1478                 )
1479                 : "";
1480     }
1481 
1482     //only owner
1483     function reveal() public onlyOwner {
1484         revealed = true;
1485     }
1486 
1487     function setNftPerAddressLimitWL(uint256 _limit) public onlyOwner {
1488         nftPerAddressLimitWL = _limit;
1489     }
1490 
1491     function setmaxMintAmountPublic(uint256 _newmaxMintAmount)
1492         public
1493         onlyOwner
1494     {
1495         maxMintAmountPublic = _newmaxMintAmount;
1496     }
1497 
1498     function setmaxMintAmountWL(uint256 _newmaxMintAmount) public onlyOwner {
1499         maxMintAmountWL = _newmaxMintAmount;
1500     }
1501 
1502     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1503         baseURI = _newBaseURI;
1504     }
1505 
1506     function setBaseExtension(string memory _newBaseExtension)
1507         public
1508         onlyOwner
1509     {
1510         baseExtension = _newBaseExtension;
1511     }
1512 
1513     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1514         notRevealedUri = _notRevealedURI;
1515     }
1516 
1517     function pause() public onlyOwner {
1518         currentState = 0;
1519     }
1520 
1521     function setOnlyWhitelisted() public onlyOwner {
1522         currentState = 1;
1523     }
1524 
1525     function setPublic() public onlyOwner {
1526         currentState = 3;
1527     }
1528 
1529     function setWhitelistMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1530         merkleRootWhitelist = _merkleRoot;
1531     }
1532 
1533     function setPublicCost(uint256 _price) public onlyOwner {
1534         cost = _price;
1535     }
1536 
1537     function setWLCost(uint256 _price) public onlyOwner {
1538         costWL = _price;
1539     }
1540 
1541     function withdraw() public payable onlyOwner {
1542         // This will payout the owner the contract balance.
1543         // Do not remove this otherwise you will not be able to withdraw the funds.
1544         // =============================================================================
1545         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1546         require(os);
1547         // =============================================================================
1548     }
1549 }