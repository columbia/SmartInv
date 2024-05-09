1 // File: @openzeppelin/contracts/utils/Strings.sol
2 // SPDX-License-Identifier: MIT
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Address.sol
72 
73 
74 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
75 
76 pragma solidity ^0.8.1;
77 
78 /**
79  * @dev Collection of functions related to the address type
80  */
81 library Address {
82     /**
83      * @dev Returns true if `account` is a contract.
84      *
85      * [IMPORTANT]
86      * ====
87      * It is unsafe to assume that an address for which this function returns
88      * false is an externally-owned account (EOA) and not a contract.
89      *
90      * Among others, `isContract` will return false for the following
91      * types of addresses:
92      *
93      *  - an externally-owned account
94      *  - a contract in construction
95      *  - an address where a contract will be created
96      *  - an address where a contract lived, but was destroyed
97      * ====
98      *
99      * [IMPORTANT]
100      * ====
101      * You shouldn't rely on `isContract` to protect against flash loan attacks!
102      *
103      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
104      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
105      * constructor.
106      * ====
107      */
108     function isContract(address account) internal view returns (bool) {
109         // This method relies on extcodesize/address.code.length, which returns 0
110         // for contracts in construction, since the code is only stored at the end
111         // of the constructor execution.
112 
113         return account.code.length > 0;
114     }
115 
116     /**
117      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
118      * `recipient`, forwarding all available gas and reverting on errors.
119      *
120      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
121      * of certain opcodes, possibly making contracts go over the 2300 gas limit
122      * imposed by `transfer`, making them unable to receive funds via
123      * `transfer`. {sendValue} removes this limitation.
124      *
125      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
126      *
127      * IMPORTANT: because control is transferred to `recipient`, care must be
128      * taken to not create reentrancy vulnerabilities. Consider using
129      * {ReentrancyGuard} or the
130      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
131      */
132     function sendValue(address payable recipient, uint256 amount) internal {
133         require(address(this).balance >= amount, "Address: insufficient balance");
134 
135         (bool success, ) = recipient.call{value: amount}("");
136         require(success, "Address: unable to send value, recipient may have reverted");
137     }
138 
139     /**
140      * @dev Performs a Solidity function call using a low level `call`. A
141      * plain `call` is an unsafe replacement for a function call: use this
142      * function instead.
143      *
144      * If `target` reverts with a revert reason, it is bubbled up by this
145      * function (like regular Solidity function calls).
146      *
147      * Returns the raw returned data. To convert to the expected return value,
148      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
149      *
150      * Requirements:
151      *
152      * - `target` must be a contract.
153      * - calling `target` with `data` must not revert.
154      *
155      * _Available since v3.1._
156      */
157     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
158         return functionCall(target, data, "Address: low-level call failed");
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
163      * `errorMessage` as a fallback revert reason when `target` reverts.
164      *
165      * _Available since v3.1._
166      */
167     function functionCall(
168         address target,
169         bytes memory data,
170         string memory errorMessage
171     ) internal returns (bytes memory) {
172         return functionCallWithValue(target, data, 0, errorMessage);
173     }
174 
175     /**
176      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
177      * but also transferring `value` wei to `target`.
178      *
179      * Requirements:
180      *
181      * - the calling contract must have an ETH balance of at least `value`.
182      * - the called Solidity function must be `payable`.
183      *
184      * _Available since v3.1._
185      */
186     function functionCallWithValue(
187         address target,
188         bytes memory data,
189         uint256 value
190     ) internal returns (bytes memory) {
191         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
192     }
193 
194     /**
195      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
196      * with `errorMessage` as a fallback revert reason when `target` reverts.
197      *
198      * _Available since v3.1._
199      */
200     function functionCallWithValue(
201         address target,
202         bytes memory data,
203         uint256 value,
204         string memory errorMessage
205     ) internal returns (bytes memory) {
206         require(address(this).balance >= value, "Address: insufficient balance for call");
207         require(isContract(target), "Address: call to non-contract");
208 
209         (bool success, bytes memory returndata) = target.call{value: value}(data);
210         return verifyCallResult(success, returndata, errorMessage);
211     }
212 
213     /**
214      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
215      * but performing a static call.
216      *
217      * _Available since v3.3._
218      */
219     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
220         return functionStaticCall(target, data, "Address: low-level static call failed");
221     }
222 
223     /**
224      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
225      * but performing a static call.
226      *
227      * _Available since v3.3._
228      */
229     function functionStaticCall(
230         address target,
231         bytes memory data,
232         string memory errorMessage
233     ) internal view returns (bytes memory) {
234         require(isContract(target), "Address: static call to non-contract");
235 
236         (bool success, bytes memory returndata) = target.staticcall(data);
237         return verifyCallResult(success, returndata, errorMessage);
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
242      * but performing a delegate call.
243      *
244      * _Available since v3.4._
245      */
246     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
247         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
252      * but performing a delegate call.
253      *
254      * _Available since v3.4._
255      */
256     function functionDelegateCall(
257         address target,
258         bytes memory data,
259         string memory errorMessage
260     ) internal returns (bytes memory) {
261         require(isContract(target), "Address: delegate call to non-contract");
262 
263         (bool success, bytes memory returndata) = target.delegatecall(data);
264         return verifyCallResult(success, returndata, errorMessage);
265     }
266 
267     /**
268      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
269      * revert reason using the provided one.
270      *
271      * _Available since v4.3._
272      */
273     function verifyCallResult(
274         bool success,
275         bytes memory returndata,
276         string memory errorMessage
277     ) internal pure returns (bytes memory) {
278         if (success) {
279             return returndata;
280         } else {
281             // Look for revert reason and bubble it up if present
282             if (returndata.length > 0) {
283                 // The easiest way to bubble the revert reason is using memory via assembly
284 
285                 assembly {
286                     let returndata_size := mload(returndata)
287                     revert(add(32, returndata), returndata_size)
288                 }
289             } else {
290                 revert(errorMessage);
291             }
292         }
293     }
294 }
295 
296 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
297 
298 
299 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
300 
301 pragma solidity ^0.8.0;
302 
303 /**
304  * @title ERC721 token receiver interface
305  * @dev Interface for any contract that wants to support safeTransfers
306  * from ERC721 asset contracts.
307  */
308 interface IERC721Receiver {
309     /**
310      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
311      * by `operator` from `from`, this function is called.
312      *
313      * It must return its Solidity selector to confirm the token transfer.
314      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
315      *
316      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
317      */
318     function onERC721Received(
319         address operator,
320         address from,
321         uint256 tokenId,
322         bytes calldata data
323     ) external returns (bytes4);
324 }
325 
326 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
327 
328 
329 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
330 
331 pragma solidity ^0.8.0;
332 
333 /**
334  * @dev Interface of the ERC165 standard, as defined in the
335  * https://eips.ethereum.org/EIPS/eip-165[EIP].
336  *
337  * Implementers can declare support of contract interfaces, which can then be
338  * queried by others ({ERC165Checker}).
339  *
340  * For an implementation, see {ERC165}.
341  */
342 interface IERC165 {
343     /**
344      * @dev Returns true if this contract implements the interface defined by
345      * `interfaceId`. See the corresponding
346      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
347      * to learn more about how these ids are created.
348      *
349      * This function call must use less than 30 000 gas.
350      */
351     function supportsInterface(bytes4 interfaceId) external view returns (bool);
352 }
353 
354 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
355 
356 
357 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
358 
359 pragma solidity ^0.8.0;
360 
361 
362 /**
363  * @dev Implementation of the {IERC165} interface.
364  *
365  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
366  * for the additional interface id that will be supported. For example:
367  *
368  * ```solidity
369  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
370  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
371  * }
372  * ```
373  *
374  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
375  */
376 abstract contract ERC165 is IERC165 {
377     /**
378      * @dev See {IERC165-supportsInterface}.
379      */
380     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
381         return interfaceId == type(IERC165).interfaceId;
382     }
383 }
384 
385 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
386 
387 
388 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
389 
390 pragma solidity ^0.8.0;
391 
392 
393 /**
394  * @dev Required interface of an ERC721 compliant contract.
395  */
396 interface IERC721 is IERC165 {
397     /**
398      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
399      */
400     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
401 
402     /**
403      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
404      */
405     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
406 
407     /**
408      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
409      */
410     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
411 
412     /**
413      * @dev Returns the number of tokens in ``owner``'s account.
414      */
415     function balanceOf(address owner) external view returns (uint256 balance);
416 
417     /**
418      * @dev Returns the owner of the `tokenId` token.
419      *
420      * Requirements:
421      *
422      * - `tokenId` must exist.
423      */
424     function ownerOf(uint256 tokenId) external view returns (address owner);
425 
426     /**
427      * @dev Safely transfers `tokenId` token from `from` to `to`.
428      *
429      * Requirements:
430      *
431      * - `from` cannot be the zero address.
432      * - `to` cannot be the zero address.
433      * - `tokenId` token must exist and be owned by `from`.
434      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
435      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
436      *
437      * Emits a {Transfer} event.
438      */
439     function safeTransferFrom(
440         address from,
441         address to,
442         uint256 tokenId,
443         bytes calldata data
444     ) external;
445 
446     /**
447      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
448      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
449      *
450      * Requirements:
451      *
452      * - `from` cannot be the zero address.
453      * - `to` cannot be the zero address.
454      * - `tokenId` token must exist and be owned by `from`.
455      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
456      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
457      *
458      * Emits a {Transfer} event.
459      */
460     function safeTransferFrom(
461         address from,
462         address to,
463         uint256 tokenId
464     ) external;
465 
466     /**
467      * @dev Transfers `tokenId` token from `from` to `to`.
468      *
469      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
470      *
471      * Requirements:
472      *
473      * - `from` cannot be the zero address.
474      * - `to` cannot be the zero address.
475      * - `tokenId` token must be owned by `from`.
476      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
477      *
478      * Emits a {Transfer} event.
479      */
480     function transferFrom(
481         address from,
482         address to,
483         uint256 tokenId
484     ) external;
485 
486     /**
487      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
488      * The approval is cleared when the token is transferred.
489      *
490      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
491      *
492      * Requirements:
493      *
494      * - The caller must own the token or be an approved operator.
495      * - `tokenId` must exist.
496      *
497      * Emits an {Approval} event.
498      */
499     function approve(address to, uint256 tokenId) external;
500 
501     /**
502      * @dev Approve or remove `operator` as an operator for the caller.
503      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
504      *
505      * Requirements:
506      *
507      * - The `operator` cannot be the caller.
508      *
509      * Emits an {ApprovalForAll} event.
510      */
511     function setApprovalForAll(address operator, bool _approved) external;
512 
513     /**
514      * @dev Returns the account approved for `tokenId` token.
515      *
516      * Requirements:
517      *
518      * - `tokenId` must exist.
519      */
520     function getApproved(uint256 tokenId) external view returns (address operator);
521 
522     /**
523      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
524      *
525      * See {setApprovalForAll}
526      */
527     function isApprovedForAll(address owner, address operator) external view returns (bool);
528 }
529 
530 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
531 
532 
533 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
534 
535 pragma solidity ^0.8.0;
536 
537 
538 /**
539  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
540  * @dev See https://eips.ethereum.org/EIPS/eip-721
541  */
542 interface IERC721Metadata is IERC721 {
543     /**
544      * @dev Returns the token collection name.
545      */
546     function name() external view returns (string memory);
547 
548     /**
549      * @dev Returns the token collection symbol.
550      */
551     function symbol() external view returns (string memory);
552 
553     /**
554      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
555      */
556     function tokenURI(uint256 tokenId) external view returns (string memory);
557 }
558 
559 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
560 
561 
562 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
563 
564 pragma solidity ^0.8.0;
565 
566 /**
567  * @dev These functions deal with verification of Merkle Trees proofs.
568  *
569  * The proofs can be generated using the JavaScript library
570  * https://github.com/miguelmota/merkletreejs[merkletreejs].
571  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
572  *
573  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
574  *
575  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
576  * hashing, or use a hash function other than keccak256 for hashing leaves.
577  * This is because the concatenation of a sorted pair of internal nodes in
578  * the merkle tree could be reinterpreted as a leaf value.
579  */
580 library MerkleProof {
581     /**
582      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
583      * defined by `root`. For this, a `proof` must be provided, containing
584      * sibling hashes on the branch from the leaf to the root of the tree. Each
585      * pair of leaves and each pair of pre-images are assumed to be sorted.
586      */
587     function verify(
588         bytes32[] memory proof,
589         bytes32 root,
590         bytes32 leaf
591     ) internal pure returns (bool) {
592         return processProof(proof, leaf) == root;
593     }
594 
595     /**
596      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
597      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
598      * hash matches the root of the tree. When processing the proof, the pairs
599      * of leafs & pre-images are assumed to be sorted.
600      *
601      * _Available since v4.4._
602      */
603     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
604         bytes32 computedHash = leaf;
605         for (uint256 i = 0; i < proof.length; i++) {
606             bytes32 proofElement = proof[i];
607             if (computedHash <= proofElement) {
608                 // Hash(current computed hash + current element of the proof)
609                 computedHash = _efficientHash(computedHash, proofElement);
610             } else {
611                 // Hash(current element of the proof + current computed hash)
612                 computedHash = _efficientHash(proofElement, computedHash);
613             }
614         }
615         return computedHash;
616     }
617 
618     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
619         assembly {
620             mstore(0x00, a)
621             mstore(0x20, b)
622             value := keccak256(0x00, 0x40)
623         }
624     }
625 }
626 
627 // File: @openzeppelin/contracts/utils/Context.sol
628 
629 
630 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
631 
632 pragma solidity ^0.8.0;
633 
634 /**
635  * @dev Provides information about the current execution context, including the
636  * sender of the transaction and its data. While these are generally available
637  * via msg.sender and msg.data, they should not be accessed in such a direct
638  * manner, since when dealing with meta-transactions the account sending and
639  * paying for execution may not be the actual sender (as far as an application
640  * is concerned).
641  *
642  * This contract is only required for intermediate, library-like contracts.
643  */
644 abstract contract Context {
645     function _msgSender() internal view virtual returns (address) {
646         return msg.sender;
647     }
648 
649     function _msgData() internal view virtual returns (bytes calldata) {
650         return msg.data;
651     }
652 }
653 
654 // File: ERC721A.sol
655 
656 
657 // Creator: Chiru Labs
658 
659 pragma solidity ^0.8.4;
660 
661 
662 
663 
664 
665 
666 
667 
668 error ApprovalCallerNotOwnerNorApproved();
669 error ApprovalQueryForNonexistentToken();
670 error ApproveToCaller();
671 error ApprovalToCurrentOwner();
672 error BalanceQueryForZeroAddress();
673 error MintToZeroAddress();
674 error MintZeroQuantity();
675 error OwnerQueryForNonexistentToken();
676 error TransferCallerNotOwnerNorApproved();
677 error TransferFromIncorrectOwner();
678 error TransferToNonERC721ReceiverImplementer();
679 error TransferToZeroAddress();
680 error URIQueryForNonexistentToken();
681 
682 /**
683  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
684  * the Metadata extension. Built to optimize for lower gas during batch mints.
685  *
686  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
687  *
688  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
689  *
690  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
691  */
692 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
693     using Address for address;
694     using Strings for uint256;
695 
696     // Compiler will pack this into a single 256bit word.
697     struct TokenOwnership {
698         // The address of the owner.
699         address addr;
700         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
701         uint64 startTimestamp;
702         // Whether the token has been burned.
703         bool burned;
704     }
705 
706     // Compiler will pack this into a single 256bit word.
707     struct AddressData {
708         // Realistically, 2**64-1 is more than enough.
709         uint64 balance;
710         // Keeps track of mint count with minimal overhead for tokenomics.
711         uint64 numberMinted;
712         // Keeps track of burn count with minimal overhead for tokenomics.
713         uint64 numberBurned;
714         // For miscellaneous variable(s) pertaining to the address
715         // (e.g. number of whitelist mint slots used).
716         // If there are multiple variables, please pack them into a uint64.
717         uint64 aux;
718     }
719 
720     // The tokenId of the next token to be minted.
721     uint256 internal _currentIndex;
722 
723     // The number of tokens burned.
724     uint256 internal _burnCounter;
725 
726     // Token name
727     string private _name;
728 
729     // Token symbol
730     string private _symbol;
731 
732     // Mapping from token ID to ownership details
733     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
734     mapping(uint256 => TokenOwnership) internal _ownerships;
735 
736     // Mapping owner address to address data
737     mapping(address => AddressData) private _addressData;
738 
739     // Mapping from token ID to approved address
740     mapping(uint256 => address) private _tokenApprovals;
741 
742     // Mapping from owner to operator approvals
743     mapping(address => mapping(address => bool)) private _operatorApprovals;
744 
745     constructor(string memory name_, string memory symbol_) {
746         _name = name_;
747         _symbol = symbol_;
748         _currentIndex = _startTokenId();
749     }
750 
751     /**
752      * To change the starting tokenId, please override this function.
753      */
754     function _startTokenId() internal view virtual returns (uint256) {
755         return 1;
756     }
757 
758     /**
759      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
760      */
761     function totalSupply() public view returns (uint256) {
762         // Counter underflow is impossible as _burnCounter cannot be incremented
763         // more than _currentIndex - _startTokenId() times
764         unchecked {
765             return _currentIndex - _burnCounter - _startTokenId();
766         }
767     }
768 
769     /**
770      * Returns the total amount of tokens minted in the contract.
771      */
772     function _totalMinted() internal view returns (uint256) {
773         // Counter underflow is impossible as _currentIndex does not decrement,
774         // and it is initialized to _startTokenId()
775         unchecked {
776             return _currentIndex - _startTokenId();
777         }
778     }
779 
780     /**
781      * @dev See {IERC165-supportsInterface}.
782      */
783     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
784         return
785             interfaceId == type(IERC721).interfaceId ||
786             interfaceId == type(IERC721Metadata).interfaceId ||
787             super.supportsInterface(interfaceId);
788     }
789 
790     /**
791      * @dev See {IERC721-balanceOf}.
792      */
793     function balanceOf(address owner) public view override returns (uint256) {
794         if (owner == address(0)) revert BalanceQueryForZeroAddress();
795         return uint256(_addressData[owner].balance);
796     }
797 
798     /**
799      * Returns the number of tokens minted by `owner`.
800      */
801     function _numberMinted(address owner) internal view returns (uint256) {
802         return uint256(_addressData[owner].numberMinted);
803     }
804 
805     /**
806      * Returns the number of tokens burned by or on behalf of `owner`.
807      */
808     function _numberBurned(address owner) internal view returns (uint256) {
809         return uint256(_addressData[owner].numberBurned);
810     }
811 
812     /**
813      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
814      */
815     function _getAux(address owner) internal view returns (uint64) {
816         return _addressData[owner].aux;
817     }
818 
819     /**
820      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
821      * If there are multiple variables, please pack them into a uint64.
822      */
823     function _setAux(address owner, uint64 aux) internal {
824         _addressData[owner].aux = aux;
825     }
826 
827     /**
828      * Gas spent here starts off proportional to the maximum mint batch size.
829      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
830      */
831     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
832         uint256 curr = tokenId;
833 
834         unchecked {
835             if (_startTokenId() <= curr && curr < _currentIndex) {
836                 TokenOwnership memory ownership = _ownerships[curr];
837                 if (!ownership.burned) {
838                     if (ownership.addr != address(0)) {
839                         return ownership;
840                     }
841                     // Invariant:
842                     // There will always be an ownership that has an address and is not burned
843                     // before an ownership that does not have an address and is not burned.
844                     // Hence, curr will not underflow.
845                     while (true) {
846                         curr--;
847                         ownership = _ownerships[curr];
848                         if (ownership.addr != address(0)) {
849                             return ownership;
850                         }
851                     }
852                 }
853             }
854         }
855         revert OwnerQueryForNonexistentToken();
856     }
857 
858     /**
859      * @dev See {IERC721-ownerOf}.
860      */
861     function ownerOf(uint256 tokenId) public view override returns (address) {
862         return _ownershipOf(tokenId).addr;
863     }
864 
865     /**
866      * @dev See {IERC721Metadata-name}.
867      */
868     function name() public view virtual override returns (string memory) {
869         return _name;
870     }
871 
872     /**
873      * @dev See {IERC721Metadata-symbol}.
874      */
875     function symbol() public view virtual override returns (string memory) {
876         return _symbol;
877     }
878 
879     /**
880      * @dev See {IERC721Metadata-tokenURI}.
881      */
882     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
883         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
884 
885         string memory baseURI = _baseURI();
886         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
887     }
888 
889     /**
890      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
891      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
892      * by default, can be overriden in child contracts.
893      */
894     function _baseURI() internal view virtual returns (string memory) {
895         return '';
896     }
897 
898     /**
899      * @dev See {IERC721-approve}.
900      */
901     function approve(address to, uint256 tokenId) public override {
902         address owner = ERC721A.ownerOf(tokenId);
903         if (to == owner) revert ApprovalToCurrentOwner();
904 
905         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
906             revert ApprovalCallerNotOwnerNorApproved();
907         }
908 
909         _approve(to, tokenId, owner);
910     }
911 
912     /**
913      * @dev See {IERC721-getApproved}.
914      */
915     function getApproved(uint256 tokenId) public view override returns (address) {
916         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
917 
918         return _tokenApprovals[tokenId];
919     }
920 
921     /**
922      * @dev See {IERC721-setApprovalForAll}.
923      */
924     function setApprovalForAll(address operator, bool approved) public virtual override {
925         if (operator == _msgSender()) revert ApproveToCaller();
926 
927         _operatorApprovals[_msgSender()][operator] = approved;
928         emit ApprovalForAll(_msgSender(), operator, approved);
929     }
930 
931     /**
932      * @dev See {IERC721-isApprovedForAll}.
933      */
934     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
935         return _operatorApprovals[owner][operator];
936     }
937 
938     /**
939      * @dev See {IERC721-transferFrom}.
940      */
941     function transferFrom(
942         address from,
943         address to,
944         uint256 tokenId
945     ) public virtual override {
946         _transfer(from, to, tokenId);
947     }
948 
949     /**
950      * @dev See {IERC721-safeTransferFrom}.
951      */
952     function safeTransferFrom(
953         address from,
954         address to,
955         uint256 tokenId
956     ) public virtual override {
957         safeTransferFrom(from, to, tokenId, '');
958     }
959 
960     /**
961      * @dev See {IERC721-safeTransferFrom}.
962      */
963     function safeTransferFrom(
964         address from,
965         address to,
966         uint256 tokenId,
967         bytes memory _data
968     ) public virtual override {
969         _transfer(from, to, tokenId);
970         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
971             revert TransferToNonERC721ReceiverImplementer();
972         }
973     }
974 
975     /**
976      * @dev Returns whether `tokenId` exists.
977      *
978      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
979      *
980      * Tokens start existing when they are minted (`_mint`),
981      */
982     function _exists(uint256 tokenId) internal view returns (bool) {
983         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
984     }
985 
986     /**
987      * @dev Equivalent to `_safeMint(to, quantity, '')`.
988      */
989     function _safeMint(address to, uint256 quantity) internal {
990         _safeMint(to, quantity, '');
991     }
992 
993     /**
994      * @dev Safely mints `quantity` tokens and transfers them to `to`.
995      *
996      * Requirements:
997      *
998      * - If `to` refers to a smart contract, it must implement 
999      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1000      * - `quantity` must be greater than 0.
1001      *
1002      * Emits a {Transfer} event.
1003      */
1004     function _safeMint(
1005         address to,
1006         uint256 quantity,
1007         bytes memory _data
1008     ) internal {
1009         uint256 startTokenId = _currentIndex;
1010         if (to == address(0)) revert MintToZeroAddress();
1011         if (quantity == 0) revert MintZeroQuantity();
1012 
1013         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1014 
1015         // Overflows are incredibly unrealistic.
1016         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1017         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1018         unchecked {
1019             _addressData[to].balance += uint64(quantity);
1020             _addressData[to].numberMinted += uint64(quantity);
1021 
1022             _ownerships[startTokenId].addr = to;
1023             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1024 
1025             uint256 updatedIndex = startTokenId;
1026             uint256 end = updatedIndex + quantity;
1027 
1028             if (to.isContract()) {
1029                 do {
1030                     emit Transfer(address(0), to, updatedIndex);
1031                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1032                         revert TransferToNonERC721ReceiverImplementer();
1033                     }
1034                 } while (updatedIndex != end);
1035                 // Reentrancy protection
1036                 if (_currentIndex != startTokenId) revert();
1037             } else {
1038                 do {
1039                     emit Transfer(address(0), to, updatedIndex++);
1040                 } while (updatedIndex != end);
1041             }
1042             _currentIndex = updatedIndex;
1043         }
1044         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1045     }
1046 
1047     /**
1048      * @dev Mints `quantity` tokens and transfers them to `to`.
1049      *
1050      * Requirements:
1051      *
1052      * - `to` cannot be the zero address.
1053      * - `quantity` must be greater than 0.
1054      *
1055      * Emits a {Transfer} event.
1056      */
1057     function _mint(address to, uint256 quantity) internal {
1058         uint256 startTokenId = _currentIndex;
1059         if (to == address(0)) revert MintToZeroAddress();
1060         if (quantity == 0) revert MintZeroQuantity();
1061 
1062         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1063 
1064         // Overflows are incredibly unrealistic.
1065         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1066         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1067         unchecked {
1068             _addressData[to].balance += uint64(quantity);
1069             _addressData[to].numberMinted += uint64(quantity);
1070 
1071             _ownerships[startTokenId].addr = to;
1072             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1073 
1074             uint256 updatedIndex = startTokenId;
1075             uint256 end = updatedIndex + quantity;
1076 
1077             do {
1078                 emit Transfer(address(0), to, updatedIndex++);
1079             } while (updatedIndex != end);
1080 
1081             _currentIndex = updatedIndex;
1082         }
1083         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1084     }
1085 
1086     /**
1087      * @dev Transfers `tokenId` from `from` to `to`.
1088      *
1089      * Requirements:
1090      *
1091      * - `to` cannot be the zero address.
1092      * - `tokenId` token must be owned by `from`.
1093      *
1094      * Emits a {Transfer} event.
1095      */
1096     function _transfer(
1097         address from,
1098         address to,
1099         uint256 tokenId
1100     ) private {
1101         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1102 
1103         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1104 
1105         bool isApprovedOrOwner = (_msgSender() == from ||
1106             isApprovedForAll(from, _msgSender()) ||
1107             getApproved(tokenId) == _msgSender());
1108 
1109         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1110         if (to == address(0)) revert TransferToZeroAddress();
1111 
1112         _beforeTokenTransfers(from, to, tokenId, 1);
1113 
1114         // Clear approvals from the previous owner
1115         _approve(address(0), tokenId, from);
1116 
1117         // Underflow of the sender's balance is impossible because we check for
1118         // ownership above and the recipient's balance can't realistically overflow.
1119         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1120         unchecked {
1121             _addressData[from].balance -= 1;
1122             _addressData[to].balance += 1;
1123 
1124             TokenOwnership storage currSlot = _ownerships[tokenId];
1125             currSlot.addr = to;
1126             currSlot.startTimestamp = uint64(block.timestamp);
1127 
1128             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1129             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1130             uint256 nextTokenId = tokenId + 1;
1131             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1132             if (nextSlot.addr == address(0)) {
1133                 // This will suffice for checking _exists(nextTokenId),
1134                 // as a burned slot cannot contain the zero address.
1135                 if (nextTokenId != _currentIndex) {
1136                     nextSlot.addr = from;
1137                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1138                 }
1139             }
1140         }
1141 
1142         emit Transfer(from, to, tokenId);
1143         _afterTokenTransfers(from, to, tokenId, 1);
1144     }
1145 
1146     /**
1147      * @dev Equivalent to `_burn(tokenId, false)`.
1148      */
1149     function _burn(uint256 tokenId) internal virtual {
1150         _burn(tokenId, false);
1151     }
1152 
1153     /**
1154      * @dev Destroys `tokenId`.
1155      * The approval is cleared when the token is burned.
1156      *
1157      * Requirements:
1158      *
1159      * - `tokenId` must exist.
1160      *
1161      * Emits a {Transfer} event.
1162      */
1163     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1164         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1165 
1166         address from = prevOwnership.addr;
1167 
1168         if (approvalCheck) {
1169             bool isApprovedOrOwner = (_msgSender() == from ||
1170                 isApprovedForAll(from, _msgSender()) ||
1171                 getApproved(tokenId) == _msgSender());
1172 
1173             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1174         }
1175 
1176         _beforeTokenTransfers(from, address(0), tokenId, 1);
1177 
1178         // Clear approvals from the previous owner
1179         _approve(address(0), tokenId, from);
1180 
1181         // Underflow of the sender's balance is impossible because we check for
1182         // ownership above and the recipient's balance can't realistically overflow.
1183         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1184         unchecked {
1185             AddressData storage addressData = _addressData[from];
1186             addressData.balance -= 1;
1187             addressData.numberBurned += 1;
1188 
1189             // Keep track of who burned the token, and the timestamp of burning.
1190             TokenOwnership storage currSlot = _ownerships[tokenId];
1191             currSlot.addr = from;
1192             currSlot.startTimestamp = uint64(block.timestamp);
1193             currSlot.burned = true;
1194 
1195             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1196             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1197             uint256 nextTokenId = tokenId + 1;
1198             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1199             if (nextSlot.addr == address(0)) {
1200                 // This will suffice for checking _exists(nextTokenId),
1201                 // as a burned slot cannot contain the zero address.
1202                 if (nextTokenId != _currentIndex) {
1203                     nextSlot.addr = from;
1204                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1205                 }
1206             }
1207         }
1208 
1209         emit Transfer(from, address(0), tokenId);
1210         _afterTokenTransfers(from, address(0), tokenId, 1);
1211 
1212         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1213         unchecked {
1214             _burnCounter++;
1215         }
1216     }
1217 
1218     /**
1219      * @dev Approve `to` to operate on `tokenId`
1220      *
1221      * Emits a {Approval} event.
1222      */
1223     function _approve(
1224         address to,
1225         uint256 tokenId,
1226         address owner
1227     ) private {
1228         _tokenApprovals[tokenId] = to;
1229         emit Approval(owner, to, tokenId);
1230     }
1231 
1232     /**
1233      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1234      *
1235      * @param from address representing the previous owner of the given token ID
1236      * @param to target address that will receive the tokens
1237      * @param tokenId uint256 ID of the token to be transferred
1238      * @param _data bytes optional data to send along with the call
1239      * @return bool whether the call correctly returned the expected magic value
1240      */
1241     function _checkContractOnERC721Received(
1242         address from,
1243         address to,
1244         uint256 tokenId,
1245         bytes memory _data
1246     ) private returns (bool) {
1247         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1248             return retval == IERC721Receiver(to).onERC721Received.selector;
1249         } catch (bytes memory reason) {
1250             if (reason.length == 0) {
1251                 revert TransferToNonERC721ReceiverImplementer();
1252             } else {
1253                 assembly {
1254                     revert(add(32, reason), mload(reason))
1255                 }
1256             }
1257         }
1258     }
1259 
1260     /**
1261      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1262      * And also called before burning one token.
1263      *
1264      * startTokenId - the first token id to be transferred
1265      * quantity - the amount to be transferred
1266      *
1267      * Calling conditions:
1268      *
1269      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1270      * transferred to `to`.
1271      * - When `from` is zero, `tokenId` will be minted for `to`.
1272      * - When `to` is zero, `tokenId` will be burned by `from`.
1273      * - `from` and `to` are never both zero.
1274      */
1275     function _beforeTokenTransfers(
1276         address from,
1277         address to,
1278         uint256 startTokenId,
1279         uint256 quantity
1280     ) internal virtual {}
1281 
1282     /**
1283      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1284      * minting.
1285      * And also called after one token has been burned.
1286      *
1287      * startTokenId - the first token id to be transferred
1288      * quantity - the amount to be transferred
1289      *
1290      * Calling conditions:
1291      *
1292      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1293      * transferred to `to`.
1294      * - When `from` is zero, `tokenId` has been minted for `to`.
1295      * - When `to` is zero, `tokenId` has been burned by `from`.
1296      * - `from` and `to` are never both zero.
1297      */
1298     function _afterTokenTransfers(
1299         address from,
1300         address to,
1301         uint256 startTokenId,
1302         uint256 quantity
1303     ) internal virtual {}
1304 }
1305 // File: @openzeppelin/contracts/access/Ownable.sol
1306 
1307 
1308 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1309 
1310 pragma solidity ^0.8.0;
1311 
1312 
1313 /**
1314  * @dev Contract module which provides a basic access control mechanism, where
1315  * there is an account (an owner) that can be granted exclusive access to
1316  * specific functions.
1317  *
1318  * By default, the owner account will be the one that deploys the contract. This
1319  * can later be changed with {transferOwnership}.
1320  *
1321  * This module is used through inheritance. It will make available the modifier
1322  * `onlyOwner`, which can be applied to your functions to restrict their use to
1323  * the owner.
1324  */
1325 abstract contract Ownable is Context {
1326     address private _owner;
1327 
1328     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1329 
1330     /**
1331      * @dev Initializes the contract setting the deployer as the initial owner.
1332      */
1333     constructor() {
1334         _transferOwnership(_msgSender());
1335     }
1336 
1337     /**
1338      * @dev Returns the address of the current owner.
1339      */
1340     function owner() public view virtual returns (address) {
1341         return _owner;
1342     }
1343 
1344     /**
1345      * @dev Throws if called by any account other than the owner.
1346      */
1347     modifier onlyOwner() {
1348         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1349         _;
1350     }
1351 
1352     /**
1353      * @dev Leaves the contract without owner. It will not be possible to call
1354      * `onlyOwner` functions anymore. Can only be called by the current owner.
1355      *
1356      * NOTE: Renouncing ownership will leave the contract without an owner,
1357      * thereby removing any functionality that is only available to the owner.
1358      */
1359     function renounceOwnership() public virtual onlyOwner {
1360         _transferOwnership(address(0));
1361     }
1362 
1363     /**
1364      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1365      * Can only be called by the current owner.
1366      */
1367     function transferOwnership(address newOwner) public virtual onlyOwner {
1368         require(newOwner != address(0), "Ownable: new owner is the zero address");
1369         _transferOwnership(newOwner);
1370     }
1371 
1372     /**
1373      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1374      * Internal function without access restriction.
1375      */
1376     function _transferOwnership(address newOwner) internal virtual {
1377         address oldOwner = _owner;
1378         _owner = newOwner;
1379         emit OwnershipTransferred(oldOwner, newOwner);
1380     }
1381 }
1382 
1383 // File: Mice.sol
1384 
1385 /**
1386  * @title Medicated Mice Contract
1387  * @author Trippy (Discord: Trippy#1937)
1388  * @collection Medicated Mice (https://discord.gg/medicatedmice)
1389  * @notice This contract handles minting and whitelisting for Medicated Mice with the implementation of ERC721a.
1390  */
1391 
1392 
1393 
1394 
1395 
1396 pragma solidity >=0.7.0 <0.9.0;
1397 
1398 
1399 contract Mice is ERC721A, Ownable {
1400 
1401   using Strings for uint256;
1402   using MerkleProof for bytes32[];
1403 
1404   // STRINGS
1405   string public uriPrefix = "ipfs://QmYb7Jdtvpmywb9uEhpPowbsFPVYsdYUk7CqA2oSUpfuip/";
1406   string public uriSuffix = ".json";
1407   string public hiddenMetadataUri;
1408   
1409   // INTEGERS
1410   uint256 public cost = 0.045 ether;
1411   uint256 public maxSupply = 1420;
1412   uint256 public maxMintAmountPerTx = 1420;
1413   uint256 public maxNFTPerAddress = 4;
1414 
1415   // BOOLEAN
1416   bool public paused = true;
1417   bool public revealed = false;
1418   bool public presale = true;
1419 
1420   // BYTES
1421   bytes32 public merkleRoot = 0x475be11e96826210727bb9a6582dc3e449c4673fd37cfa885245491f62188195;
1422 
1423   // MAPS
1424   mapping(address => uint256) public addressMintedBalance;
1425 
1426 
1427   constructor() ERC721A("Baby Medicated Mice", "BMICE") {
1428     setHiddenMetadataUri("ipfs://QmXoxUByEESqZicptzhp48fT9CwHi4jvBSD2wuKnf1ntU3/hidden.json");
1429   }
1430 
1431   modifier mintCompliance(uint256 _mintAmount) {
1432     uint256 holderMintedCount = addressMintedBalance[msg.sender];
1433 
1434     require(!paused, "Medicated Mice: The contract is paused!");
1435     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Medicated Mice: Invalid mint amount!");
1436     require(holderMintedCount + _mintAmount <= maxNFTPerAddress, "Medicated Mice: You have reached the MAX NFT per address limit!");
1437     require(_mintAmount <= maxMintAmountPerTx, "Medicated Mice: Max You have reached the max amount per transaction!");
1438     require(totalSupply() + _mintAmount <= maxSupply, "Medicated Mice: The Collection has sold out!");
1439     _;
1440   }
1441 
1442   function mint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable mintCompliance(_mintAmount) {
1443     require(msg.value >= cost * _mintAmount, "Medicated Mice: You do not have sufficient funds to purchase!");
1444 
1445         if (msg.sender != owner()) {
1446         if (presale == true && isWhitelisted(_merkleProof)) {
1447 
1448         }
1449       }
1450 
1451     addressMintedBalance[msg.sender]++;
1452      _safeMint(msg.sender, _mintAmount);
1453     
1454 
1455   }
1456   
1457   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1458     _safeMint(_receiver, _mintAmount);
1459   }
1460 
1461   function walletOfOwner(address _owner)
1462     public
1463     view
1464     returns (uint256[] memory)
1465   {
1466     uint256 ownerTokenCount = balanceOf(_owner);
1467     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1468     uint256 currentTokenId = 1;
1469     uint256 ownedTokenIndex = 0;
1470 
1471     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1472       address currentTokenOwner = ownerOf(currentTokenId);
1473 
1474       if (currentTokenOwner == _owner) {
1475         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1476 
1477         ownedTokenIndex++;
1478       }
1479 
1480       currentTokenId++;
1481     }
1482 
1483     return ownedTokenIds;
1484   }
1485 
1486   function tokenURI(uint256 _tokenId)
1487     public
1488     view
1489     virtual
1490     override
1491     returns (string memory)
1492   {
1493     require(
1494       _exists(_tokenId),
1495       "ERC721Metadata: URI query for nonexistent token"
1496     );
1497 
1498     if (revealed == false) {
1499       return hiddenMetadataUri;
1500     }
1501 
1502     string memory currentBaseURI = _baseURI();
1503     return bytes(currentBaseURI).length > 0
1504         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1505         : "";
1506   }
1507 
1508   function setRevealed(bool _state) public onlyOwner {
1509     revealed = _state;
1510   }
1511 
1512   function setCost(uint256 _cost) public onlyOwner {
1513     cost = _cost;
1514   }
1515 
1516   function setMaxNFTPerLimit(uint256 _limit) public onlyOwner {
1517     maxNFTPerAddress = _limit;
1518   }
1519 
1520   function setMaxSupply(uint256 _newSupply) public onlyOwner {
1521     maxSupply = _newSupply;
1522   }
1523 
1524   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1525     maxMintAmountPerTx = _maxMintAmountPerTx;
1526   }
1527 
1528   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1529     hiddenMetadataUri = _hiddenMetadataUri;
1530   }
1531 
1532   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1533     uriPrefix = _uriPrefix;
1534   }
1535 
1536   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1537     uriSuffix = _uriSuffix;
1538   }
1539 
1540   function setPaused(bool _state) public onlyOwner {
1541     paused = _state;
1542   }
1543 
1544   function setPresale(bool _state) public onlyOwner {
1545     presale = _state;
1546   }
1547 
1548   function setMerkleRoot(bytes32 _root) external onlyOwner {
1549     merkleRoot = _root;
1550   }
1551 
1552   function isValid(address _to, uint256 _tokenID, bytes32[] memory _proof) public view returns (bool) {
1553     bytes32 leaf = keccak256(abi.encodePacked(_to, _tokenID));
1554 
1555     return _proof.verify(merkleRoot, leaf);
1556   }
1557 
1558   function isWhitelisted(bytes32[] calldata _merkleProof) public view returns (bool) {
1559         require(
1560             MerkleProof.verify(
1561                 _merkleProof,
1562                 merkleRoot,
1563                 keccak256(abi.encodePacked(msg.sender))
1564             ),
1565             'Medicated Mice: Your Address is not whitelisted!'
1566         );
1567 
1568         return true;
1569     }
1570 
1571   function _baseURI() internal view virtual override returns (string memory) {
1572     return uriPrefix;
1573   }
1574 
1575   function withdraw() public onlyOwner {
1576     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1577     require(os);
1578   }
1579 
1580 }