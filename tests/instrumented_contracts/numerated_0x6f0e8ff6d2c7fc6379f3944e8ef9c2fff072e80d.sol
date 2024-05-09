1 // SPDX-License-Identifier: GPL-3.0
2 // File: 8OD/MerkleProof.sol
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
59 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
60 
61 pragma solidity ^0.8.0;
62 
63 /**
64  * @dev String operations.
65  */
66 library Strings {
67     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
68     uint8 private constant _ADDRESS_LENGTH = 20;
69 
70     /**
71      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
72      */
73     function toString(uint256 value) internal pure returns (string memory) {
74         // Inspired by OraclizeAPI's implementation - MIT licence
75         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
76 
77         if (value == 0) {
78             return "0";
79         }
80         uint256 temp = value;
81         uint256 digits;
82         while (temp != 0) {
83             digits++;
84             temp /= 10;
85         }
86         bytes memory buffer = new bytes(digits);
87         while (value != 0) {
88             digits -= 1;
89             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
90             value /= 10;
91         }
92         return string(buffer);
93     }
94 
95     /**
96      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
97      */
98     function toHexString(uint256 value) internal pure returns (string memory) {
99         if (value == 0) {
100             return "0x00";
101         }
102         uint256 temp = value;
103         uint256 length = 0;
104         while (temp != 0) {
105             length++;
106             temp >>= 8;
107         }
108         return toHexString(value, length);
109     }
110 
111     /**
112      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
113      */
114     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
115         bytes memory buffer = new bytes(2 * length + 2);
116         buffer[0] = "0";
117         buffer[1] = "x";
118         for (uint256 i = 2 * length + 1; i > 1; --i) {
119             buffer[i] = _HEX_SYMBOLS[value & 0xf];
120             value >>= 4;
121         }
122         require(value == 0, "Strings: hex length insufficient");
123         return string(buffer);
124     }
125 
126     /**
127      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
128      */
129     function toHexString(address addr) internal pure returns (string memory) {
130         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
131     }
132 }
133 
134 // File: @openzeppelin/contracts/utils/Context.sol
135 
136 
137 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
138 
139 pragma solidity ^0.8.0;
140 
141 /**
142  * @dev Provides information about the current execution context, including the
143  * sender of the transaction and its data. While these are generally available
144  * via msg.sender and msg.data, they should not be accessed in such a direct
145  * manner, since when dealing with meta-transactions the account sending and
146  * paying for execution may not be the actual sender (as far as an application
147  * is concerned).
148  *
149  * This contract is only required for intermediate, library-like contracts.
150  */
151 abstract contract Context {
152     function _msgSender() internal view virtual returns (address) {
153         return msg.sender;
154     }
155 
156     function _msgData() internal view virtual returns (bytes calldata) {
157         return msg.data;
158     }
159 }
160 
161 // File: @openzeppelin/contracts/utils/Address.sol
162 
163 
164 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
165 
166 pragma solidity ^0.8.1;
167 
168 /**
169  * @dev Collection of functions related to the address type
170  */
171 library Address {
172     /**
173      * @dev Returns true if `account` is a contract.
174      *
175      * [IMPORTANT]
176      * ====
177      * It is unsafe to assume that an address for which this function returns
178      * false is an externally-owned account (EOA) and not a contract.
179      *
180      * Among others, `isContract` will return false for the following
181      * types of addresses:
182      *
183      *  - an externally-owned account
184      *  - a contract in construction
185      *  - an address where a contract will be created
186      *  - an address where a contract lived, but was destroyed
187      * ====
188      *
189      * [IMPORTANT]
190      * ====
191      * You shouldn't rely on `isContract` to protect against flash loan attacks!
192      *
193      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
194      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
195      * constructor.
196      * ====
197      */
198     function isContract(address account) internal view returns (bool) {
199         // This method relies on extcodesize/address.code.length, which returns 0
200         // for contracts in construction, since the code is only stored at the end
201         // of the constructor execution.
202 
203         return account.code.length > 0;
204     }
205 
206     /**
207      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
208      * `recipient`, forwarding all available gas and reverting on errors.
209      *
210      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
211      * of certain opcodes, possibly making contracts go over the 2300 gas limit
212      * imposed by `transfer`, making them unable to receive funds via
213      * `transfer`. {sendValue} removes this limitation.
214      *
215      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
216      *
217      * IMPORTANT: because control is transferred to `recipient`, care must be
218      * taken to not create reentrancy vulnerabilities. Consider using
219      * {ReentrancyGuard} or the
220      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
221      */
222     function sendValue(address payable recipient, uint256 amount) internal {
223         require(address(this).balance >= amount, "Address: insufficient balance");
224 
225         (bool success, ) = recipient.call{value: amount}("");
226         require(success, "Address: unable to send value, recipient may have reverted");
227     }
228 
229     /**
230      * @dev Performs a Solidity function call using a low level `call`. A
231      * plain `call` is an unsafe replacement for a function call: use this
232      * function instead.
233      *
234      * If `target` reverts with a revert reason, it is bubbled up by this
235      * function (like regular Solidity function calls).
236      *
237      * Returns the raw returned data. To convert to the expected return value,
238      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
239      *
240      * Requirements:
241      *
242      * - `target` must be a contract.
243      * - calling `target` with `data` must not revert.
244      *
245      * _Available since v3.1._
246      */
247     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
248         return functionCall(target, data, "Address: low-level call failed");
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
253      * `errorMessage` as a fallback revert reason when `target` reverts.
254      *
255      * _Available since v3.1._
256      */
257     function functionCall(
258         address target,
259         bytes memory data,
260         string memory errorMessage
261     ) internal returns (bytes memory) {
262         return functionCallWithValue(target, data, 0, errorMessage);
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
267      * but also transferring `value` wei to `target`.
268      *
269      * Requirements:
270      *
271      * - the calling contract must have an ETH balance of at least `value`.
272      * - the called Solidity function must be `payable`.
273      *
274      * _Available since v3.1._
275      */
276     function functionCallWithValue(
277         address target,
278         bytes memory data,
279         uint256 value
280     ) internal returns (bytes memory) {
281         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
282     }
283 
284     /**
285      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
286      * with `errorMessage` as a fallback revert reason when `target` reverts.
287      *
288      * _Available since v3.1._
289      */
290     function functionCallWithValue(
291         address target,
292         bytes memory data,
293         uint256 value,
294         string memory errorMessage
295     ) internal returns (bytes memory) {
296         require(address(this).balance >= value, "Address: insufficient balance for call");
297         require(isContract(target), "Address: call to non-contract");
298 
299         (bool success, bytes memory returndata) = target.call{value: value}(data);
300         return verifyCallResult(success, returndata, errorMessage);
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
305      * but performing a static call.
306      *
307      * _Available since v3.3._
308      */
309     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
310         return functionStaticCall(target, data, "Address: low-level static call failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
315      * but performing a static call.
316      *
317      * _Available since v3.3._
318      */
319     function functionStaticCall(
320         address target,
321         bytes memory data,
322         string memory errorMessage
323     ) internal view returns (bytes memory) {
324         require(isContract(target), "Address: static call to non-contract");
325 
326         (bool success, bytes memory returndata) = target.staticcall(data);
327         return verifyCallResult(success, returndata, errorMessage);
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
332      * but performing a delegate call.
333      *
334      * _Available since v3.4._
335      */
336     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
337         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
342      * but performing a delegate call.
343      *
344      * _Available since v3.4._
345      */
346     function functionDelegateCall(
347         address target,
348         bytes memory data,
349         string memory errorMessage
350     ) internal returns (bytes memory) {
351         require(isContract(target), "Address: delegate call to non-contract");
352 
353         (bool success, bytes memory returndata) = target.delegatecall(data);
354         return verifyCallResult(success, returndata, errorMessage);
355     }
356 
357     /**
358      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
359      * revert reason using the provided one.
360      *
361      * _Available since v4.3._
362      */
363     function verifyCallResult(
364         bool success,
365         bytes memory returndata,
366         string memory errorMessage
367     ) internal pure returns (bytes memory) {
368         if (success) {
369             return returndata;
370         } else {
371             // Look for revert reason and bubble it up if present
372             if (returndata.length > 0) {
373                 // The easiest way to bubble the revert reason is using memory via assembly
374                 /// @solidity memory-safe-assembly
375                 assembly {
376                     let returndata_size := mload(returndata)
377                     revert(add(32, returndata), returndata_size)
378                 }
379             } else {
380                 revert(errorMessage);
381             }
382         }
383     }
384 }
385 
386 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
387 
388 
389 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
390 
391 pragma solidity ^0.8.0;
392 
393 /**
394  * @title ERC721 token receiver interface
395  * @dev Interface for any contract that wants to support safeTransfers
396  * from ERC721 asset contracts.
397  */
398 interface IERC721Receiver {
399     /**
400      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
401      * by `operator` from `from`, this function is called.
402      *
403      * It must return its Solidity selector to confirm the token transfer.
404      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
405      *
406      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
407      */
408     function onERC721Received(
409         address operator,
410         address from,
411         uint256 tokenId,
412         bytes calldata data
413     ) external returns (bytes4);
414 }
415 
416 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
417 
418 
419 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
420 
421 pragma solidity ^0.8.0;
422 
423 /**
424  * @dev Interface of the ERC165 standard, as defined in the
425  * https://eips.ethereum.org/EIPS/eip-165[EIP].
426  *
427  * Implementers can declare support of contract interfaces, which can then be
428  * queried by others ({ERC165Checker}).
429  *
430  * For an implementation, see {ERC165}.
431  */
432 interface IERC165 {
433     /**
434      * @dev Returns true if this contract implements the interface defined by
435      * `interfaceId`. See the corresponding
436      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
437      * to learn more about how these ids are created.
438      *
439      * This function call must use less than 30 000 gas.
440      */
441     function supportsInterface(bytes4 interfaceId) external view returns (bool);
442 }
443 
444 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
445 
446 
447 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
448 
449 pragma solidity ^0.8.0;
450 
451 
452 /**
453  * @dev Implementation of the {IERC165} interface.
454  *
455  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
456  * for the additional interface id that will be supported. For example:
457  *
458  * ```solidity
459  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
460  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
461  * }
462  * ```
463  *
464  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
465  */
466 abstract contract ERC165 is IERC165 {
467     /**
468      * @dev See {IERC165-supportsInterface}.
469      */
470     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
471         return interfaceId == type(IERC165).interfaceId;
472     }
473 }
474 
475 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
476 
477 
478 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
479 
480 pragma solidity ^0.8.0;
481 
482 
483 /**
484  * @dev Required interface of an ERC721 compliant contract.
485  */
486 interface IERC721 is IERC165 {
487     /**
488      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
489      */
490     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
491 
492     /**
493      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
494      */
495     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
496 
497     /**
498      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
499      */
500     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
501 
502     /**
503      * @dev Returns the number of tokens in ``owner``'s account.
504      */
505     function balanceOf(address owner) external view returns (uint256 balance);
506 
507     /**
508      * @dev Returns the owner of the `tokenId` token.
509      *
510      * Requirements:
511      *
512      * - `tokenId` must exist.
513      */
514     function ownerOf(uint256 tokenId) external view returns (address owner);
515 
516     /**
517      * @dev Safely transfers `tokenId` token from `from` to `to`.
518      *
519      * Requirements:
520      *
521      * - `from` cannot be the zero address.
522      * - `to` cannot be the zero address.
523      * - `tokenId` token must exist and be owned by `from`.
524      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
525      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
526      *
527      * Emits a {Transfer} event.
528      */
529     function safeTransferFrom(
530         address from,
531         address to,
532         uint256 tokenId,
533         bytes calldata data
534     ) external;
535 
536     /**
537      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
538      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
539      *
540      * Requirements:
541      *
542      * - `from` cannot be the zero address.
543      * - `to` cannot be the zero address.
544      * - `tokenId` token must exist and be owned by `from`.
545      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
546      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
547      *
548      * Emits a {Transfer} event.
549      */
550     function safeTransferFrom(
551         address from,
552         address to,
553         uint256 tokenId
554     ) external;
555 
556     /**
557      * @dev Transfers `tokenId` token from `from` to `to`.
558      *
559      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
560      *
561      * Requirements:
562      *
563      * - `from` cannot be the zero address.
564      * - `to` cannot be the zero address.
565      * - `tokenId` token must be owned by `from`.
566      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
567      *
568      * Emits a {Transfer} event.
569      */
570     function transferFrom(
571         address from,
572         address to,
573         uint256 tokenId
574     ) external;
575 
576     /**
577      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
578      * The approval is cleared when the token is transferred.
579      *
580      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
581      *
582      * Requirements:
583      *
584      * - The caller must own the token or be an approved operator.
585      * - `tokenId` must exist.
586      *
587      * Emits an {Approval} event.
588      */
589     function approve(address to, uint256 tokenId) external;
590 
591     /**
592      * @dev Approve or remove `operator` as an operator for the caller.
593      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
594      *
595      * Requirements:
596      *
597      * - The `operator` cannot be the caller.
598      *
599      * Emits an {ApprovalForAll} event.
600      */
601     function setApprovalForAll(address operator, bool _approved) external;
602 
603     /**
604      * @dev Returns the account approved for `tokenId` token.
605      *
606      * Requirements:
607      *
608      * - `tokenId` must exist.
609      */
610     function getApproved(uint256 tokenId) external view returns (address operator);
611 
612     /**
613      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
614      *
615      * See {setApprovalForAll}
616      */
617     function isApprovedForAll(address owner, address operator) external view returns (bool);
618 }
619 
620 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
621 
622 
623 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
624 
625 pragma solidity ^0.8.0;
626 
627 
628 /**
629  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
630  * @dev See https://eips.ethereum.org/EIPS/eip-721
631  */
632 interface IERC721Metadata is IERC721 {
633     /**
634      * @dev Returns the token collection name.
635      */
636     function name() external view returns (string memory);
637 
638     /**
639      * @dev Returns the token collection symbol.
640      */
641     function symbol() external view returns (string memory);
642 
643     /**
644      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
645      */
646     function tokenURI(uint256 tokenId) external view returns (string memory);
647 }
648 
649 // File: 8OD/ERC721A.sol
650 
651 
652 // Creator: Chiru Labs
653 
654 pragma solidity ^0.8.4;
655 
656 
657 
658 
659 
660 
661 
662 
663 error ApprovalCallerNotOwnerNorApproved();
664 error ApprovalQueryForNonexistentToken();
665 error ApproveToCaller();
666 error ApprovalToCurrentOwner();
667 error BalanceQueryForZeroAddress();
668 error MintToZeroAddress();
669 error MintZeroQuantity();
670 error OwnerQueryForNonexistentToken();
671 error TransferCallerNotOwnerNorApproved();
672 error TransferFromIncorrectOwner();
673 error TransferToNonERC721ReceiverImplementer();
674 error TransferToZeroAddress();
675 error URIQueryForNonexistentToken();
676 
677 /**
678  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
679  * the Metadata extension. Built to optimize for lower gas during batch mints.
680  *
681  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
682  *
683  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
684  *
685  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
686  */
687 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
688     using Address for address;
689     using Strings for uint256;
690 
691     // Compiler will pack this into a single 256bit word.
692     struct TokenOwnership {
693         // The address of the owner.
694         address addr;
695         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
696         uint64 startTimestamp;
697         // Whether the token has been burned.
698         bool burned;
699     }
700 
701     // Compiler will pack this into a single 256bit word.
702     struct AddressData {
703         // Realistically, 2**64-1 is more than enough.
704         uint64 balance;
705         // Keeps track of mint count with minimal overhead for tokenomics.
706         uint64 numberMinted;
707         // Keeps track of burn count with minimal overhead for tokenomics.
708         uint64 numberBurned;
709         // For miscellaneous variable(s) pertaining to the address
710         // (e.g. number of whitelist mint slots used).
711         // If there are multiple variables, please pack them into a uint64.
712         uint64 aux;
713     }
714 
715     // The tokenId of the next token to be minted.
716     uint256 internal _currentIndex;
717 
718     // The number of tokens burned.
719     uint256 internal _burnCounter;
720 
721     // Token name
722     string private _name;
723 
724     // Token symbol
725     string private _symbol;
726 
727     // Mapping from token ID to ownership details
728     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
729     mapping(uint256 => TokenOwnership) internal _ownerships;
730 
731     // Mapping owner address to address data
732     mapping(address => AddressData) private _addressData;
733 
734     // Mapping from token ID to approved address
735     mapping(uint256 => address) private _tokenApprovals;
736 
737     // Mapping from owner to operator approvals
738     mapping(address => mapping(address => bool)) private _operatorApprovals;
739 
740     constructor(string memory name_, string memory symbol_) {
741         _name = name_;
742         _symbol = symbol_;
743         _currentIndex = _startTokenId();
744     }
745 
746     /**
747      * To change the starting tokenId, please override this function.
748      */
749     function _startTokenId() internal view virtual returns (uint256) {
750         return 0;
751     }
752 
753     /**
754      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
755      */
756     function totalSupply() public view returns (uint256) {
757         // Counter underflow is impossible as _burnCounter cannot be incremented
758         // more than _currentIndex - _startTokenId() times
759         unchecked {
760             return _currentIndex - _burnCounter - _startTokenId();
761         }
762     }
763 
764     /**
765      * Returns the total amount of tokens minted in the contract.
766      */
767     function _totalMinted() internal view returns (uint256) {
768         // Counter underflow is impossible as _currentIndex does not decrement,
769         // and it is initialized to _startTokenId()
770         unchecked {
771             return _currentIndex - _startTokenId();
772         }
773     }
774 
775     /**
776      * @dev See {IERC165-supportsInterface}.
777      */
778     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
779         return
780             interfaceId == type(IERC721).interfaceId ||
781             interfaceId == type(IERC721Metadata).interfaceId ||
782             super.supportsInterface(interfaceId);
783     }
784 
785     /**
786      * @dev See {IERC721-balanceOf}.
787      */
788     function balanceOf(address owner) public view override returns (uint256) {
789         if (owner == address(0)) revert BalanceQueryForZeroAddress();
790         return uint256(_addressData[owner].balance);
791     }
792 
793     /**
794      * Returns the number of tokens minted by `owner`.
795      */
796     function _numberMinted(address owner) internal view returns (uint256) {
797         return uint256(_addressData[owner].numberMinted);
798     }
799 
800     /**
801      * Returns the number of tokens burned by or on behalf of `owner`.
802      */
803     function _numberBurned(address owner) internal view returns (uint256) {
804         return uint256(_addressData[owner].numberBurned);
805     }
806 
807     /**
808      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
809      */
810     function _getAux(address owner) internal view returns (uint64) {
811         return _addressData[owner].aux;
812     }
813 
814     /**
815      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
816      * If there are multiple variables, please pack them into a uint64.
817      */
818     function _setAux(address owner, uint64 aux) internal {
819         _addressData[owner].aux = aux;
820     }
821 
822     /**
823      * Gas spent here starts off proportional to the maximum mint batch size.
824      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
825      */
826     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
827         uint256 curr = tokenId;
828 
829         unchecked {
830             if (_startTokenId() <= curr && curr < _currentIndex) {
831                 TokenOwnership memory ownership = _ownerships[curr];
832                 if (!ownership.burned) {
833                     if (ownership.addr != address(0)) {
834                         return ownership;
835                     }
836                     // Invariant:
837                     // There will always be an ownership that has an address and is not burned
838                     // before an ownership that does not have an address and is not burned.
839                     // Hence, curr will not underflow.
840                     while (true) {
841                         curr--;
842                         ownership = _ownerships[curr];
843                         if (ownership.addr != address(0)) {
844                             return ownership;
845                         }
846                     }
847                 }
848             }
849         }
850         revert OwnerQueryForNonexistentToken();
851     }
852 
853     /**
854      * @dev See {IERC721-ownerOf}.
855      */
856     function ownerOf(uint256 tokenId) public view override returns (address) {
857         return _ownershipOf(tokenId).addr;
858     }
859 
860     /**
861      * @dev See {IERC721Metadata-name}.
862      */
863     function name() public view virtual override returns (string memory) {
864         return _name;
865     }
866 
867     /**
868      * @dev See {IERC721Metadata-symbol}.
869      */
870     function symbol() public view virtual override returns (string memory) {
871         return _symbol;
872     }
873 
874     /**
875      * @dev See {IERC721Metadata-tokenURI}.
876      */
877     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
878         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
879 
880         string memory baseURI = _baseURI();
881         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
882     }
883 
884     /**
885      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
886      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
887      * by default, can be overriden in child contracts.
888      */
889     function _baseURI() internal view virtual returns (string memory) {
890         return '';
891     }
892 
893     /**
894      * @dev See {IERC721-approve}.
895      */
896     function approve(address to, uint256 tokenId) public override {
897         address owner = ERC721A.ownerOf(tokenId);
898         if (to == owner) revert ApprovalToCurrentOwner();
899 
900         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
901             revert ApprovalCallerNotOwnerNorApproved();
902         }
903 
904         _approve(to, tokenId, owner);
905     }
906 
907     /**
908      * @dev See {IERC721-getApproved}.
909      */
910     function getApproved(uint256 tokenId) public view override returns (address) {
911         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
912 
913         return _tokenApprovals[tokenId];
914     }
915 
916     /**
917      * @dev See {IERC721-setApprovalForAll}.
918      */
919     function setApprovalForAll(address operator, bool approved) public virtual override {
920         if (operator == _msgSender()) revert ApproveToCaller();
921 
922         _operatorApprovals[_msgSender()][operator] = approved;
923         emit ApprovalForAll(_msgSender(), operator, approved);
924     }
925 
926     /**
927      * @dev See {IERC721-isApprovedForAll}.
928      */
929     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
930         return _operatorApprovals[owner][operator];
931     }
932 
933     /**
934      * @dev See {IERC721-transferFrom}.
935      */
936     function transferFrom(
937         address from,
938         address to,
939         uint256 tokenId
940     ) public virtual override {
941         _transfer(from, to, tokenId);
942     }
943 
944     /**
945      * @dev See {IERC721-safeTransferFrom}.
946      */
947     function safeTransferFrom(
948         address from,
949         address to,
950         uint256 tokenId
951     ) public virtual override {
952         safeTransferFrom(from, to, tokenId, '');
953     }
954 
955     /**
956      * @dev See {IERC721-safeTransferFrom}.
957      */
958     function safeTransferFrom(
959         address from,
960         address to,
961         uint256 tokenId,
962         bytes memory _data
963     ) public virtual override {
964         _transfer(from, to, tokenId);
965         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
966             revert TransferToNonERC721ReceiverImplementer();
967         }
968     }
969 
970     /**
971      * @dev Returns whether `tokenId` exists.
972      *
973      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
974      *
975      * Tokens start existing when they are minted (`_mint`),
976      */
977     function _exists(uint256 tokenId) internal view returns (bool) {
978         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
979             !_ownerships[tokenId].burned;
980     }
981 
982     function _safeMint(address to, uint256 quantity) internal {
983         _safeMint(to, quantity, '');
984     }
985 
986     /**
987      * @dev Safely mints `quantity` tokens and transfers them to `to`.
988      *
989      * Requirements:
990      *
991      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
992      * - `quantity` must be greater than 0.
993      *
994      * Emits a {Transfer} event.
995      */
996     function _safeMint(
997         address to,
998         uint256 quantity,
999         bytes memory _data
1000     ) internal {
1001         _mint(to, quantity, _data, true);
1002     }
1003 
1004     /**
1005      * @dev Mints `quantity` tokens and transfers them to `to`.
1006      *
1007      * Requirements:
1008      *
1009      * - `to` cannot be the zero address.
1010      * - `quantity` must be greater than 0.
1011      *
1012      * Emits a {Transfer} event.
1013      */
1014     function _mint(
1015         address to,
1016         uint256 quantity,
1017         bytes memory _data,
1018         bool safe
1019     ) internal {
1020         uint256 startTokenId = _currentIndex;
1021         if (to == address(0)) revert MintToZeroAddress();
1022         if (quantity == 0) revert MintZeroQuantity();
1023 
1024         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1025 
1026         // Overflows are incredibly unrealistic.
1027         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1028         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1029         unchecked {
1030             _addressData[to].balance += uint64(quantity);
1031             _addressData[to].numberMinted += uint64(quantity);
1032 
1033             _ownerships[startTokenId].addr = to;
1034             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1035 
1036             uint256 updatedIndex = startTokenId;
1037             uint256 end = updatedIndex + quantity;
1038 
1039             if (safe && to.isContract()) {
1040                 do {
1041                     emit Transfer(address(0), to, updatedIndex);
1042                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1043                         revert TransferToNonERC721ReceiverImplementer();
1044                     }
1045                 } while (updatedIndex != end);
1046                 // Reentrancy protection
1047                 if (_currentIndex != startTokenId) revert();
1048             } else {
1049                 do {
1050                     emit Transfer(address(0), to, updatedIndex++);
1051                 } while (updatedIndex != end);
1052             }
1053             _currentIndex = updatedIndex;
1054         }
1055         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1056     }
1057 
1058     /**
1059      * @dev Transfers `tokenId` from `from` to `to`.
1060      *
1061      * Requirements:
1062      *
1063      * - `to` cannot be the zero address.
1064      * - `tokenId` token must be owned by `from`.
1065      *
1066      * Emits a {Transfer} event.
1067      */
1068     function _transfer(
1069         address from,
1070         address to,
1071         uint256 tokenId
1072     ) private {
1073         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1074 
1075         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1076 
1077         bool isApprovedOrOwner = (_msgSender() == from ||
1078             isApprovedForAll(from, _msgSender()) ||
1079             getApproved(tokenId) == _msgSender());
1080 
1081         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1082         if (to == address(0)) revert TransferToZeroAddress();
1083 
1084         _beforeTokenTransfers(from, to, tokenId, 1);
1085 
1086         // Clear approvals from the previous owner
1087         _approve(address(0), tokenId, from);
1088 
1089         // Underflow of the sender's balance is impossible because we check for
1090         // ownership above and the recipient's balance can't realistically overflow.
1091         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1092         unchecked {
1093             _addressData[from].balance -= 1;
1094             _addressData[to].balance += 1;
1095 
1096             TokenOwnership storage currSlot = _ownerships[tokenId];
1097             currSlot.addr = to;
1098             currSlot.startTimestamp = uint64(block.timestamp);
1099 
1100             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1101             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1102             uint256 nextTokenId = tokenId + 1;
1103             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1104             if (nextSlot.addr == address(0)) {
1105                 // This will suffice for checking _exists(nextTokenId),
1106                 // as a burned slot cannot contain the zero address.
1107                 if (nextTokenId != _currentIndex) {
1108                     nextSlot.addr = from;
1109                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1110                 }
1111             }
1112         }
1113 
1114         emit Transfer(from, to, tokenId);
1115         _afterTokenTransfers(from, to, tokenId, 1);
1116     }
1117 
1118     /**
1119      * @dev This is equivalent to _burn(tokenId, false)
1120      */
1121     function _burn(uint256 tokenId) internal virtual {
1122         _burn(tokenId, false);
1123     }
1124 
1125     /**
1126      * @dev Destroys `tokenId`.
1127      * The approval is cleared when the token is burned.
1128      *
1129      * Requirements:
1130      *
1131      * - `tokenId` must exist.
1132      *
1133      * Emits a {Transfer} event.
1134      */
1135     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1136         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1137 
1138         address from = prevOwnership.addr;
1139 
1140         if (approvalCheck) {
1141             bool isApprovedOrOwner = (_msgSender() == from ||
1142                 isApprovedForAll(from, _msgSender()) ||
1143                 getApproved(tokenId) == _msgSender());
1144 
1145             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1146         }
1147 
1148         _beforeTokenTransfers(from, address(0), tokenId, 1);
1149 
1150         // Clear approvals from the previous owner
1151         _approve(address(0), tokenId, from);
1152 
1153         // Underflow of the sender's balance is impossible because we check for
1154         // ownership above and the recipient's balance can't realistically overflow.
1155         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1156         unchecked {
1157             AddressData storage addressData = _addressData[from];
1158             addressData.balance -= 1;
1159             addressData.numberBurned += 1;
1160 
1161             // Keep track of who burned the token, and the timestamp of burning.
1162             TokenOwnership storage currSlot = _ownerships[tokenId];
1163             currSlot.addr = from;
1164             currSlot.startTimestamp = uint64(block.timestamp);
1165             currSlot.burned = true;
1166 
1167             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1168             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1169             uint256 nextTokenId = tokenId + 1;
1170             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1171             if (nextSlot.addr == address(0)) {
1172                 // This will suffice for checking _exists(nextTokenId),
1173                 // as a burned slot cannot contain the zero address.
1174                 if (nextTokenId != _currentIndex) {
1175                     nextSlot.addr = from;
1176                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1177                 }
1178             }
1179         }
1180 
1181         emit Transfer(from, address(0), tokenId);
1182         _afterTokenTransfers(from, address(0), tokenId, 1);
1183 
1184         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1185         unchecked {
1186             _burnCounter++;
1187         }
1188     }
1189 
1190     /**
1191      * @dev Approve `to` to operate on `tokenId`
1192      *
1193      * Emits a {Approval} event.
1194      */
1195     function _approve(
1196         address to,
1197         uint256 tokenId,
1198         address owner
1199     ) private {
1200         _tokenApprovals[tokenId] = to;
1201         emit Approval(owner, to, tokenId);
1202     }
1203 
1204     /**
1205      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1206      *
1207      * @param from address representing the previous owner of the given token ID
1208      * @param to target address that will receive the tokens
1209      * @param tokenId uint256 ID of the token to be transferred
1210      * @param _data bytes optional data to send along with the call
1211      * @return bool whether the call correctly returned the expected magic value
1212      */
1213     function _checkContractOnERC721Received(
1214         address from,
1215         address to,
1216         uint256 tokenId,
1217         bytes memory _data
1218     ) private returns (bool) {
1219         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1220             return retval == IERC721Receiver(to).onERC721Received.selector;
1221         } catch (bytes memory reason) {
1222             if (reason.length == 0) {
1223                 revert TransferToNonERC721ReceiverImplementer();
1224             } else {
1225                 assembly {
1226                     revert(add(32, reason), mload(reason))
1227                 }
1228             }
1229         }
1230     }
1231 
1232     /**
1233      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1234      * And also called before burning one token.
1235      *
1236      * startTokenId - the first token id to be transferred
1237      * quantity - the amount to be transferred
1238      *
1239      * Calling conditions:
1240      *
1241      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1242      * transferred to `to`.
1243      * - When `from` is zero, `tokenId` will be minted for `to`.
1244      * - When `to` is zero, `tokenId` will be burned by `from`.
1245      * - `from` and `to` are never both zero.
1246      */
1247     function _beforeTokenTransfers(
1248         address from,
1249         address to,
1250         uint256 startTokenId,
1251         uint256 quantity
1252     ) internal virtual {}
1253 
1254     /**
1255      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1256      * minting.
1257      * And also called after one token has been burned.
1258      *
1259      * startTokenId - the first token id to be transferred
1260      * quantity - the amount to be transferred
1261      *
1262      * Calling conditions:
1263      *
1264      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1265      * transferred to `to`.
1266      * - When `from` is zero, `tokenId` has been minted for `to`.
1267      * - When `to` is zero, `tokenId` has been burned by `from`.
1268      * - `from` and `to` are never both zero.
1269      */
1270     function _afterTokenTransfers(
1271         address from,
1272         address to,
1273         uint256 startTokenId,
1274         uint256 quantity
1275     ) internal virtual {}
1276 }
1277 
1278 // File: 8OD/EightyD.sol
1279 
1280 
1281 
1282 pragma solidity >=0.7.0 <0.9.0;
1283 
1284 
1285 
1286 
1287 /**
1288  * @dev Contract module which provides a basic access control mechanism, where
1289  * there is an account (an owner) that can be granted exclusive access to
1290  * specific functions.
1291  *
1292  * By default, the owner account will be the one that deploys the contract. This
1293  * can later be changed with {transferOwnership}.
1294  *
1295  * This module is used through inheritance. It will make available the modifier
1296  * `onlyOwner`, which can be applied to your functions to restrict their use to
1297  * the owner.
1298  */
1299 abstract contract Ownable is Context {
1300     address private _owner;
1301 
1302     event OwnershipTransferred(
1303         address indexed previousOwner,
1304         address indexed newOwner
1305     );
1306 
1307     /**
1308      * @dev Initializes the contract setting the deployer as the initial owner.
1309      */
1310     constructor() {
1311         _transferOwnership(_msgSender());
1312     }
1313 
1314     /**
1315      * @dev Returns the address of the current owner.
1316      */
1317     function owner() public view virtual returns (address) {
1318         return _owner;
1319     }
1320 
1321     /**
1322      * @dev Throws if called by any account other than the owner.
1323      */
1324     modifier onlyOwner() {
1325         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1326         _;
1327     }
1328 
1329     /**
1330      * @dev Leaves the contract without owner. It will not be possible to call
1331      * `onlyOwner` functions anymore. Can only be called by the current owner.
1332      *
1333      * NOTE: Renouncing ownership will leave the contract without an owner,
1334      * thereby removing any functionality that is only available to the owner.
1335      */
1336     function renounceOwnership() public virtual onlyOwner {
1337         _transferOwnership(address(0));
1338     }
1339 
1340     /**
1341      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1342      * Can only be called by the current owner.
1343      */
1344     function transferOwnership(address newOwner) public virtual onlyOwner {
1345         require(
1346             newOwner != address(0),
1347             "Ownable: new owner is the zero address"
1348         );
1349         _transferOwnership(newOwner);
1350     }
1351 
1352     /**
1353      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1354      * Internal function without access restriction.
1355      */
1356     function _transferOwnership(address newOwner) internal virtual {
1357         address oldOwner = _owner;
1358         _owner = newOwner;
1359         emit OwnershipTransferred(oldOwner, newOwner);
1360     }
1361 }
1362 
1363 contract _8OD is ERC721A, Ownable {
1364     using Strings for uint256;
1365 
1366     string public baseURI;
1367     string public baseExtension = ".json";
1368     string public notRevealedUri;
1369 
1370     // NFT Prices
1371     uint256 public costWL = 0.55 ether;
1372     uint256 public costFreeMint = 0.00 ether;
1373     uint256 public cost = 0.77 ether;
1374 
1375     // Total NFTS
1376     uint256 public maxSupply = 1000;
1377 
1378     // NFTs Per Wallet For Team
1379     uint256 public maxMintAmountTeam = 100;
1380 
1381     // NFTS Max for Master Hunter
1382     uint256 public maxMintAmountMasterHunter = 10;
1383 
1384     // NFTS Max for Star Hunter
1385     uint256 public maxMintAmountStarHunter = 6;
1386 
1387     // NFTS Max for Hunter
1388     uint256 public maxMintAmountHunter = 3;
1389 
1390     // NFTS Max for Public Sale
1391     uint256 public maxMintAmountPublic = 25;
1392 
1393     // NFTS per Wallet Max Master Hunter
1394     uint256 public nftPerAddressMasterHunter = 10;
1395 
1396     // NFTS per Wallet Max Star Hunter
1397     uint256 public nftPerAddressStarHunter = 6;
1398 
1399     // NFTS per Wallet Max Hunter
1400     uint256 public nftPerAddressHunter = 3;
1401 
1402     // NFTS per Wallet Max
1403     uint256 public nftPerAddressPublic = 25;
1404 
1405     bool public revealed = false;
1406 
1407 
1408     mapping(address => uint256) public addressMintedBalanceTeam;
1409     mapping(address => uint256) public addressMintedBalanceMasterHunter;
1410     mapping(address => uint256) public addressMintedBalanceStarHunter;
1411     mapping(address => uint256) public addressMintedBalanceHunter;
1412     mapping(address => uint256) public addressMintedBalance;
1413 
1414     uint256 public currentState = 0;
1415 
1416 
1417     bytes32 public merkleRootMasterHunter =
1418         0xc117da44cd8e89da7f09c9c2110a9e74054f2a2de428605e8103ff2c1560c4df;
1419 
1420     bytes32 public merkleRootStarHunter =
1421         0xc117da44cd8e89da7f09c9c2110a9e74054f2a2de428605e8103ff2c1560c4df;
1422 
1423     bytes32 public merkleRootHunter =
1424         0xc117da44cd8e89da7f09c9c2110a9e74054f2a2de428605e8103ff2c1560c4df;
1425 
1426     constructor() ERC721A("8OD", "8OD-C1") {}
1427 
1428     // internal
1429     function _baseURI() internal view virtual override returns (string memory) {
1430         return baseURI;
1431     }
1432 
1433     function burn(uint256 tokenId) external {
1434         super._burn(tokenId);
1435     }
1436 
1437     function mint(uint256 _mintAmount, bytes32[] calldata _merkleProof)
1438         public
1439         payable
1440     {
1441         uint256 supply = totalSupply();
1442         require(_mintAmount > 0, "need to mint at least 1 NFT");
1443         require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1444         if (msg.sender != owner()) {
1445             require(currentState > 0, "the contract is paused");
1446             if (currentState == 1) {
1447                 uint256 ownerMintedCount = addressMintedBalanceTeam[msg.sender];
1448                 require(
1449                     _mintAmount <= maxMintAmountTeam,
1450                     "max mint amount per session exceeded"
1451                 );
1452                 require(
1453                     ownerMintedCount + _mintAmount <= maxMintAmountTeam,
1454                     "max NFT per address exceeded"
1455                 );
1456                 require(msg.value >= cost * _mintAmount, "insufficient funds");
1457             }
1458             else if (currentState == 2) {
1459                 uint256 ownerMintedCount = addressMintedBalanceMasterHunter[msg.sender];
1460                 require(
1461                     isMasterHunter(msg.sender, _merkleProof),
1462                     "user is not Master Hunter"
1463                 );
1464                 require(
1465                     _mintAmount <= maxMintAmountMasterHunter,
1466                     "max mint amount per session exceeded"
1467                 );
1468                 require(
1469                     ownerMintedCount + _mintAmount <= maxMintAmountMasterHunter,
1470                     "max NFT per address exceeded"
1471                 );
1472                 require(
1473                     msg.value >= costWL * _mintAmount,
1474                     "insufficient funds"
1475                 );
1476             } else if (currentState == 3) {
1477                 uint256 ownerMintedCount = addressMintedBalanceStarHunter[msg.sender];
1478                 require(
1479                     isStarHunter(msg.sender, _merkleProof),
1480                     "user is not Star Hunter"
1481                 );
1482                 require(
1483                     _mintAmount <= maxMintAmountStarHunter,
1484                     "max mint amount per session exceeded"
1485                 );
1486                 require(
1487                     ownerMintedCount + _mintAmount <= maxMintAmountStarHunter,
1488                     "max NFT per address exceeded"
1489                 );
1490                 require(
1491                     msg.value >= costWL * _mintAmount,
1492                     "insufficient funds"
1493                 );
1494             } else if (currentState == 4) {
1495                 uint256 ownerMintedCount = addressMintedBalanceHunter[msg.sender];
1496                 require(
1497                     isHunter(msg.sender, _merkleProof),
1498                     "user is not Hunter"
1499                 );
1500                 require(
1501                     _mintAmount <= maxMintAmountHunter,
1502                     "max mint amount per session exceeded"
1503                 );
1504                 require(
1505                     ownerMintedCount + _mintAmount <= maxMintAmountHunter,
1506                     "max NFT per address exceeded"
1507                 );
1508                 require(
1509                     msg.value >= costWL * _mintAmount,
1510                     "insufficient funds"
1511                 );
1512             } else if (currentState == 5) {
1513                 uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1514                 require(
1515                     _mintAmount <= maxMintAmountPublic,
1516                     "max mint amount per session exceeded"
1517                 );
1518                 require(
1519                     ownerMintedCount + _mintAmount <= maxMintAmountPublic,
1520                     "max NFT per address exceeded"
1521                 );
1522                 require(msg.value >= cost * _mintAmount, "insufficient funds");
1523             }
1524         }
1525 
1526         _safeMint(msg.sender, _mintAmount);
1527         if (currentState == 1) {
1528             addressMintedBalanceTeam[msg.sender] += _mintAmount;
1529         } else if (currentState == 2) {
1530             addressMintedBalanceMasterHunter[msg.sender] += _mintAmount;
1531         } else if (currentState == 3) {
1532             addressMintedBalanceStarHunter[msg.sender] += _mintAmount;
1533         } else if (currentState == 4) {
1534             addressMintedBalanceHunter[msg.sender] += _mintAmount;
1535         } else if (currentState == 5) {
1536             addressMintedBalance[msg.sender] += _mintAmount;
1537         }
1538     }
1539 
1540 
1541     function isMasterHunter(address _user, bytes32[] calldata _merkleProof)
1542         public
1543         view
1544         returns (bool)
1545     {
1546         bytes32 leaf = keccak256(abi.encodePacked(_user));
1547         return MerkleProof.verify(_merkleProof, merkleRootMasterHunter, leaf);
1548     }
1549 
1550     function isStarHunter(address _user, bytes32[] calldata _merkleProof)
1551         public
1552         view
1553         returns (bool)
1554     {
1555         bytes32 leaf = keccak256(abi.encodePacked(_user));
1556         return MerkleProof.verify(_merkleProof, merkleRootStarHunter, leaf);
1557     }
1558 
1559     function isHunter(address _user, bytes32[] calldata _merkleProof)
1560     public
1561     view
1562     returns (bool)
1563     {
1564         bytes32 leaf = keccak256(abi.encodePacked(_user));
1565         return MerkleProof.verify(_merkleProof, merkleRootHunter, leaf);
1566     }
1567 
1568     function mintableAmountForUser(address _user) public view returns (uint256) {
1569         if (currentState == 1) {
1570             return maxMintAmountTeam - addressMintedBalanceTeam[_user];
1571         } else if (currentState == 2) {
1572             return maxMintAmountMasterHunter - addressMintedBalanceMasterHunter[_user];
1573         } else if (currentState == 3) {
1574             return maxMintAmountStarHunter - addressMintedBalanceStarHunter[_user];
1575         } else if (currentState == 4) {
1576             return maxMintAmountHunter - addressMintedBalanceHunter[_user];
1577         } else if (currentState == 5) {
1578             return maxMintAmountPublic - addressMintedBalance[_user];
1579         }
1580         return 0;
1581     }
1582 
1583     function tokenURI(uint256 tokenId)
1584         public
1585         view
1586         virtual
1587         override
1588         returns (string memory)
1589     {
1590         require(
1591             _exists(tokenId),
1592             "ERC721Metadata: URI query for nonexistent token"
1593         );
1594 
1595         if (revealed == false) {
1596             return notRevealedUri;
1597         }
1598 
1599         string memory currentBaseURI = _baseURI();
1600         return
1601             bytes(currentBaseURI).length > 0
1602                 ? string(
1603                     abi.encodePacked(
1604                         currentBaseURI,
1605                         tokenId.toString(),
1606                         baseExtension
1607                     )
1608                 )
1609                 : "";
1610     }
1611 
1612     //only owner
1613     function reveal() public onlyOwner {
1614         revealed = true;
1615     }
1616 
1617     function setNftPerAddressLimitMasterHunter(uint256 _limit) public onlyOwner {
1618         nftPerAddressMasterHunter = _limit;
1619     }
1620 
1621     function setNftPerAddressLimitStarHunter(uint256 _limit) public onlyOwner {
1622         nftPerAddressStarHunter = _limit;
1623     }
1624 
1625 
1626     function setNftPerAddressLimitHunter(uint256 _limit) public onlyOwner {
1627         nftPerAddressHunter = _limit;
1628     }
1629 
1630     function setNftPerAddressLimitPublic(uint256 _limit) public onlyOwner {
1631         nftPerAddressPublic = _limit;
1632     }
1633 
1634     function setmaxMintAmountMasterHunter(uint256 _newmaxMintAmount) public onlyOwner {
1635         maxMintAmountMasterHunter = _newmaxMintAmount;
1636     }
1637 
1638     function setmaxMintAmountStarHunter(uint256 _newmaxMintAmount) public onlyOwner {
1639         maxMintAmountStarHunter = _newmaxMintAmount;
1640     }
1641 
1642     function setmaxMintAmountHunter(uint256 _newmaxMintAmount) public onlyOwner {
1643         maxMintAmountHunter = _newmaxMintAmount;
1644     }
1645 
1646     function setmaxMintAmountPublic(uint256 _newmaxMintAmount)
1647         public
1648         onlyOwner
1649     {
1650         maxMintAmountPublic = _newmaxMintAmount;
1651     }
1652 
1653     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1654         baseURI = _newBaseURI;
1655     }
1656 
1657     function setBaseExtension(string memory _newBaseExtension)
1658         public
1659         onlyOwner
1660     {
1661         baseExtension = _newBaseExtension;
1662     }
1663 
1664     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1665         notRevealedUri = _notRevealedURI;
1666     }
1667 
1668     function pause() public onlyOwner {
1669         currentState = 0;
1670     }
1671 
1672     function setOnlyForTeam() public onlyOwner {
1673         currentState = 1;
1674     }
1675 
1676     function setOnlyMasterHunter() public onlyOwner {
1677         currentState = 2;
1678     }
1679 
1680     function setOnlyStarHunter() public onlyOwner {
1681         currentState = 3;
1682     }
1683 
1684     function setOnlyHunter() public onlyOwner {
1685         currentState = 4;
1686     }
1687 
1688     function setPublic() public onlyOwner {
1689         currentState = 5;
1690     }
1691 
1692     function setMasterHunterMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1693         merkleRootMasterHunter = _merkleRoot;
1694     }
1695 
1696     function setStarHunterMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1697         merkleRootStarHunter = _merkleRoot;
1698     }
1699 
1700     function setHunterMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1701         merkleRootHunter = _merkleRoot;
1702     }
1703 
1704     function setPublicCost(uint256 _price) public onlyOwner {
1705         cost = _price;
1706     }
1707 
1708     function setWLCost(uint256 _price) public onlyOwner {
1709         costWL = _price;
1710     }
1711 
1712     function withdraw() public payable onlyOwner {
1713         // This will payout the owner the contract balance.
1714         // Do not remove this otherwise you will not be able to withdraw the funds.
1715         // =============================================================================
1716         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1717         require(os);
1718         // =============================================================================
1719     }
1720 }