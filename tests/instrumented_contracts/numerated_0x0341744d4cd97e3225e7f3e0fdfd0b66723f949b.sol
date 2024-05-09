1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
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
299 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
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
316      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
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
388 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
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
427      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
428      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
429      *
430      * Requirements:
431      *
432      * - `from` cannot be the zero address.
433      * - `to` cannot be the zero address.
434      * - `tokenId` token must exist and be owned by `from`.
435      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
436      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
437      *
438      * Emits a {Transfer} event.
439      */
440     function safeTransferFrom(
441         address from,
442         address to,
443         uint256 tokenId
444     ) external;
445 
446     /**
447      * @dev Transfers `tokenId` token from `from` to `to`.
448      *
449      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
450      *
451      * Requirements:
452      *
453      * - `from` cannot be the zero address.
454      * - `to` cannot be the zero address.
455      * - `tokenId` token must be owned by `from`.
456      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
457      *
458      * Emits a {Transfer} event.
459      */
460     function transferFrom(
461         address from,
462         address to,
463         uint256 tokenId
464     ) external;
465 
466     /**
467      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
468      * The approval is cleared when the token is transferred.
469      *
470      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
471      *
472      * Requirements:
473      *
474      * - The caller must own the token or be an approved operator.
475      * - `tokenId` must exist.
476      *
477      * Emits an {Approval} event.
478      */
479     function approve(address to, uint256 tokenId) external;
480 
481     /**
482      * @dev Returns the account approved for `tokenId` token.
483      *
484      * Requirements:
485      *
486      * - `tokenId` must exist.
487      */
488     function getApproved(uint256 tokenId) external view returns (address operator);
489 
490     /**
491      * @dev Approve or remove `operator` as an operator for the caller.
492      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
493      *
494      * Requirements:
495      *
496      * - The `operator` cannot be the caller.
497      *
498      * Emits an {ApprovalForAll} event.
499      */
500     function setApprovalForAll(address operator, bool _approved) external;
501 
502     /**
503      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
504      *
505      * See {setApprovalForAll}
506      */
507     function isApprovedForAll(address owner, address operator) external view returns (bool);
508 
509     /**
510      * @dev Safely transfers `tokenId` token from `from` to `to`.
511      *
512      * Requirements:
513      *
514      * - `from` cannot be the zero address.
515      * - `to` cannot be the zero address.
516      * - `tokenId` token must exist and be owned by `from`.
517      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
518      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
519      *
520      * Emits a {Transfer} event.
521      */
522     function safeTransferFrom(
523         address from,
524         address to,
525         uint256 tokenId,
526         bytes calldata data
527     ) external;
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
562 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
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
574  */
575 library MerkleProof {
576     /**
577      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
578      * defined by `root`. For this, a `proof` must be provided, containing
579      * sibling hashes on the branch from the leaf to the root of the tree. Each
580      * pair of leaves and each pair of pre-images are assumed to be sorted.
581      */
582     function verify(
583         bytes32[] memory proof,
584         bytes32 root,
585         bytes32 leaf
586     ) internal pure returns (bool) {
587         return processProof(proof, leaf) == root;
588     }
589 
590     /**
591      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
592      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
593      * hash matches the root of the tree. When processing the proof, the pairs
594      * of leafs & pre-images are assumed to be sorted.
595      *
596      * _Available since v4.4._
597      */
598     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
599         bytes32 computedHash = leaf;
600         for (uint256 i = 0; i < proof.length; i++) {
601             bytes32 proofElement = proof[i];
602             if (computedHash <= proofElement) {
603                 // Hash(current computed hash + current element of the proof)
604                 computedHash = _efficientHash(computedHash, proofElement);
605             } else {
606                 // Hash(current element of the proof + current computed hash)
607                 computedHash = _efficientHash(proofElement, computedHash);
608             }
609         }
610         return computedHash;
611     }
612 
613     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
614         assembly {
615             mstore(0x00, a)
616             mstore(0x20, b)
617             value := keccak256(0x00, 0x40)
618         }
619     }
620 }
621 
622 // File: @openzeppelin/contracts/utils/Context.sol
623 
624 
625 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
626 
627 pragma solidity ^0.8.0;
628 
629 /**
630  * @dev Provides information about the current execution context, including the
631  * sender of the transaction and its data. While these are generally available
632  * via msg.sender and msg.data, they should not be accessed in such a direct
633  * manner, since when dealing with meta-transactions the account sending and
634  * paying for execution may not be the actual sender (as far as an application
635  * is concerned).
636  *
637  * This contract is only required for intermediate, library-like contracts.
638  */
639 abstract contract Context {
640     function _msgSender() internal view virtual returns (address) {
641         return msg.sender;
642     }
643 
644     function _msgData() internal view virtual returns (bytes calldata) {
645         return msg.data;
646     }
647 }
648 
649 // File: erc721a/contracts/ERC721A.sol
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
978         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
979     }
980 
981     function _safeMint(address to, uint256 quantity) internal {
982         _safeMint(to, quantity, '');
983     }
984 
985     /**
986      * @dev Safely mints `quantity` tokens and transfers them to `to`.
987      *
988      * Requirements:
989      *
990      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
991      * - `quantity` must be greater than 0.
992      *
993      * Emits a {Transfer} event.
994      */
995     function _safeMint(
996         address to,
997         uint256 quantity,
998         bytes memory _data
999     ) internal {
1000         _mint(to, quantity, _data, true);
1001     }
1002 
1003     /**
1004      * @dev Mints `quantity` tokens and transfers them to `to`.
1005      *
1006      * Requirements:
1007      *
1008      * - `to` cannot be the zero address.
1009      * - `quantity` must be greater than 0.
1010      *
1011      * Emits a {Transfer} event.
1012      */
1013     function _mint(
1014         address to,
1015         uint256 quantity,
1016         bytes memory _data,
1017         bool safe
1018     ) internal {
1019         uint256 startTokenId = _currentIndex;
1020         if (to == address(0)) revert MintToZeroAddress();
1021         if (quantity == 0) revert MintZeroQuantity();
1022 
1023         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1024 
1025         // Overflows are incredibly unrealistic.
1026         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1027         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1028         unchecked {
1029             _addressData[to].balance += uint64(quantity);
1030             _addressData[to].numberMinted += uint64(quantity);
1031 
1032             _ownerships[startTokenId].addr = to;
1033             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1034 
1035             uint256 updatedIndex = startTokenId;
1036             uint256 end = updatedIndex + quantity;
1037 
1038             if (safe && to.isContract()) {
1039                 do {
1040                     emit Transfer(address(0), to, updatedIndex);
1041                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1042                         revert TransferToNonERC721ReceiverImplementer();
1043                     }
1044                 } while (updatedIndex != end);
1045                 // Reentrancy protection
1046                 if (_currentIndex != startTokenId) revert();
1047             } else {
1048                 do {
1049                     emit Transfer(address(0), to, updatedIndex++);
1050                 } while (updatedIndex != end);
1051             }
1052             _currentIndex = updatedIndex;
1053         }
1054         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1055     }
1056 
1057     /**
1058      * @dev Transfers `tokenId` from `from` to `to`.
1059      *
1060      * Requirements:
1061      *
1062      * - `to` cannot be the zero address.
1063      * - `tokenId` token must be owned by `from`.
1064      *
1065      * Emits a {Transfer} event.
1066      */
1067     function _transfer(
1068         address from,
1069         address to,
1070         uint256 tokenId
1071     ) private {
1072         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1073 
1074         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1075 
1076         bool isApprovedOrOwner = (_msgSender() == from ||
1077             isApprovedForAll(from, _msgSender()) ||
1078             getApproved(tokenId) == _msgSender());
1079 
1080         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1081         if (to == address(0)) revert TransferToZeroAddress();
1082 
1083         _beforeTokenTransfers(from, to, tokenId, 1);
1084 
1085         // Clear approvals from the previous owner
1086         _approve(address(0), tokenId, from);
1087 
1088         // Underflow of the sender's balance is impossible because we check for
1089         // ownership above and the recipient's balance can't realistically overflow.
1090         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1091         unchecked {
1092             _addressData[from].balance -= 1;
1093             _addressData[to].balance += 1;
1094 
1095             TokenOwnership storage currSlot = _ownerships[tokenId];
1096             currSlot.addr = to;
1097             currSlot.startTimestamp = uint64(block.timestamp);
1098 
1099             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1100             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1101             uint256 nextTokenId = tokenId + 1;
1102             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1103             if (nextSlot.addr == address(0)) {
1104                 // This will suffice for checking _exists(nextTokenId),
1105                 // as a burned slot cannot contain the zero address.
1106                 if (nextTokenId != _currentIndex) {
1107                     nextSlot.addr = from;
1108                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1109                 }
1110             }
1111         }
1112 
1113         emit Transfer(from, to, tokenId);
1114         _afterTokenTransfers(from, to, tokenId, 1);
1115     }
1116 
1117     /**
1118      * @dev This is equivalent to _burn(tokenId, false)
1119      */
1120     function _burn(uint256 tokenId) internal virtual {
1121         _burn(tokenId, false);
1122     }
1123 
1124     /**
1125      * @dev Destroys `tokenId`.
1126      * The approval is cleared when the token is burned.
1127      *
1128      * Requirements:
1129      *
1130      * - `tokenId` must exist.
1131      *
1132      * Emits a {Transfer} event.
1133      */
1134     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1135         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1136 
1137         address from = prevOwnership.addr;
1138 
1139         if (approvalCheck) {
1140             bool isApprovedOrOwner = (_msgSender() == from ||
1141                 isApprovedForAll(from, _msgSender()) ||
1142                 getApproved(tokenId) == _msgSender());
1143 
1144             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1145         }
1146 
1147         _beforeTokenTransfers(from, address(0), tokenId, 1);
1148 
1149         // Clear approvals from the previous owner
1150         _approve(address(0), tokenId, from);
1151 
1152         // Underflow of the sender's balance is impossible because we check for
1153         // ownership above and the recipient's balance can't realistically overflow.
1154         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1155         unchecked {
1156             AddressData storage addressData = _addressData[from];
1157             addressData.balance -= 1;
1158             addressData.numberBurned += 1;
1159 
1160             // Keep track of who burned the token, and the timestamp of burning.
1161             TokenOwnership storage currSlot = _ownerships[tokenId];
1162             currSlot.addr = from;
1163             currSlot.startTimestamp = uint64(block.timestamp);
1164             currSlot.burned = true;
1165 
1166             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
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
1180         emit Transfer(from, address(0), tokenId);
1181         _afterTokenTransfers(from, address(0), tokenId, 1);
1182 
1183         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1184         unchecked {
1185             _burnCounter++;
1186         }
1187     }
1188 
1189     /**
1190      * @dev Approve `to` to operate on `tokenId`
1191      *
1192      * Emits a {Approval} event.
1193      */
1194     function _approve(
1195         address to,
1196         uint256 tokenId,
1197         address owner
1198     ) private {
1199         _tokenApprovals[tokenId] = to;
1200         emit Approval(owner, to, tokenId);
1201     }
1202 
1203     /**
1204      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1205      *
1206      * @param from address representing the previous owner of the given token ID
1207      * @param to target address that will receive the tokens
1208      * @param tokenId uint256 ID of the token to be transferred
1209      * @param _data bytes optional data to send along with the call
1210      * @return bool whether the call correctly returned the expected magic value
1211      */
1212     function _checkContractOnERC721Received(
1213         address from,
1214         address to,
1215         uint256 tokenId,
1216         bytes memory _data
1217     ) private returns (bool) {
1218         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1219             return retval == IERC721Receiver(to).onERC721Received.selector;
1220         } catch (bytes memory reason) {
1221             if (reason.length == 0) {
1222                 revert TransferToNonERC721ReceiverImplementer();
1223             } else {
1224                 assembly {
1225                     revert(add(32, reason), mload(reason))
1226                 }
1227             }
1228         }
1229     }
1230 
1231     /**
1232      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1233      * And also called before burning one token.
1234      *
1235      * startTokenId - the first token id to be transferred
1236      * quantity - the amount to be transferred
1237      *
1238      * Calling conditions:
1239      *
1240      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1241      * transferred to `to`.
1242      * - When `from` is zero, `tokenId` will be minted for `to`.
1243      * - When `to` is zero, `tokenId` will be burned by `from`.
1244      * - `from` and `to` are never both zero.
1245      */
1246     function _beforeTokenTransfers(
1247         address from,
1248         address to,
1249         uint256 startTokenId,
1250         uint256 quantity
1251     ) internal virtual {}
1252 
1253     /**
1254      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1255      * minting.
1256      * And also called after one token has been burned.
1257      *
1258      * startTokenId - the first token id to be transferred
1259      * quantity - the amount to be transferred
1260      *
1261      * Calling conditions:
1262      *
1263      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1264      * transferred to `to`.
1265      * - When `from` is zero, `tokenId` has been minted for `to`.
1266      * - When `to` is zero, `tokenId` has been burned by `from`.
1267      * - `from` and `to` are never both zero.
1268      */
1269     function _afterTokenTransfers(
1270         address from,
1271         address to,
1272         uint256 startTokenId,
1273         uint256 quantity
1274     ) internal virtual {}
1275 }
1276 
1277 // File: @openzeppelin/contracts/access/Ownable.sol
1278 
1279 
1280 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1281 
1282 pragma solidity ^0.8.0;
1283 
1284 
1285 /**
1286  * @dev Contract module which provides a basic access control mechanism, where
1287  * there is an account (an owner) that can be granted exclusive access to
1288  * specific functions.
1289  *
1290  * By default, the owner account will be the one that deploys the contract. This
1291  * can later be changed with {transferOwnership}.
1292  *
1293  * This module is used through inheritance. It will make available the modifier
1294  * `onlyOwner`, which can be applied to your functions to restrict their use to
1295  * the owner.
1296  */
1297 abstract contract Ownable is Context {
1298     address private _owner;
1299 
1300     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1301 
1302     /**
1303      * @dev Initializes the contract setting the deployer as the initial owner.
1304      */
1305     constructor() {
1306         _transferOwnership(_msgSender());
1307     }
1308 
1309     /**
1310      * @dev Returns the address of the current owner.
1311      */
1312     function owner() public view virtual returns (address) {
1313         return _owner;
1314     }
1315 
1316     /**
1317      * @dev Throws if called by any account other than the owner.
1318      */
1319     modifier onlyOwner() {
1320         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1321         _;
1322     }
1323 
1324     /**
1325      * @dev Leaves the contract without owner. It will not be possible to call
1326      * `onlyOwner` functions anymore. Can only be called by the current owner.
1327      *
1328      * NOTE: Renouncing ownership will leave the contract without an owner,
1329      * thereby removing any functionality that is only available to the owner.
1330      */
1331     function renounceOwnership() public virtual onlyOwner {
1332         _transferOwnership(address(0));
1333     }
1334 
1335     /**
1336      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1337      * Can only be called by the current owner.
1338      */
1339     function transferOwnership(address newOwner) public virtual onlyOwner {
1340         require(newOwner != address(0), "Ownable: new owner is the zero address");
1341         _transferOwnership(newOwner);
1342     }
1343 
1344     /**
1345      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1346      * Internal function without access restriction.
1347      */
1348     function _transferOwnership(address newOwner) internal virtual {
1349         address oldOwner = _owner;
1350         _owner = newOwner;
1351         emit OwnershipTransferred(oldOwner, newOwner);
1352     }
1353 }
1354 
1355 // File: LazerR.sol
1356 
1357 
1358 
1359 pragma solidity >=0.7.0 <0.9.0;
1360 
1361 
1362 
1363 
1364 struct PresaleConfig {
1365   uint32 startTime;
1366   uint32 endTime;
1367   uint256 whitelistMintPerWalletMax;
1368   uint256 whitelistPrice;
1369 }
1370 
1371 contract Lazer is ERC721A, Ownable {
1372   using Strings for uint256;
1373 
1374   bytes32 public merkleRoot;
1375 
1376   string public baseURI;
1377 
1378   uint32 public WHITELIST_MAX_PER_WALLET_LIMIT = 999;
1379   uint32 public MINT_PER_WALLET_MAX = 999;
1380   uint32 public MAX_TEAM_RESERVES = 50;
1381 
1382   uint256 public PRICE = 0.15 ether;
1383   uint256 public WHITELIST_PRICE = 0.15 ether;
1384   uint256 public SUPPLY_MAX = 10000;
1385   uint256 public SUPPLY_PRESALE = 5000;
1386   uint256 public teamReserves;
1387 
1388   bool public presalePaused;
1389   bool public publicSalePaused;
1390   bool public revealed;
1391 
1392   constructor(
1393     string memory _name,
1394     string memory _symbol,
1395     string memory _initBaseURI
1396   ) ERC721A(_name, _symbol) {
1397     _safeMint(address(this), 1);
1398     _burn(0);
1399     baseURI = _initBaseURI;
1400 }
1401 
1402   modifier mintCompliance(uint256 _mintAmount) {
1403     require(msg.sender == tx.origin, "Nope. Can't mint through another contract.");
1404     require((totalSupply() + _mintAmount) <= SUPPLY_MAX, "Max supply exceeded!");
1405     require((_numberMinted(msg.sender) + _mintAmount) <= MINT_PER_WALLET_MAX, "You can only mint 10 per wallet!");
1406     _;
1407   }
1408 
1409   function buyPresale(uint256 _mintAmount, bytes32[] calldata _merkleProof)
1410     external
1411     payable
1412     mintCompliance(_mintAmount) 
1413   {
1414     
1415     require(!presalePaused, "Presale has been paused.");
1416     require((_numberMinted(msg.sender) + _mintAmount) <= WHITELIST_MAX_PER_WALLET_LIMIT, "Exceeds whitelist max mint per wallet!"); 
1417     require(msg.value >= (WHITELIST_PRICE * _mintAmount), "Insufficient funds!");
1418     bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1419     require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Invalid Merkle Proof.");
1420 
1421     _safeMint(msg.sender, _mintAmount);
1422   }  
1423 
1424   function buyPublic(uint256 _mintAmount)
1425     external
1426     payable
1427     mintCompliance(_mintAmount)
1428   {
1429     require(!publicSalePaused, "Public minting is paused.");
1430     require(msg.value >= (PRICE * _mintAmount), "Insufficient funds!");
1431 
1432     _safeMint(msg.sender, _mintAmount);
1433   }
1434   
1435   function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner { // Reserves for the team and promos.
1436     require((_mintAmount + teamReserves) <= MAX_TEAM_RESERVES, "Max reserves exhausted.");
1437     teamReserves += _mintAmount;
1438     _safeMint(_receiver, _mintAmount);
1439   }
1440 
1441   function setRevealed() public onlyOwner {
1442     revealed = true;
1443   }
1444 
1445   function pausePublic(bool _state) public onlyOwner {
1446     publicSalePaused = _state;
1447   }
1448 
1449   function pausePresale(bool _state) public onlyOwner {
1450     presalePaused = _state;
1451   }
1452 
1453   function setMerkleRoot(bytes32 merkleRoot_) public onlyOwner {
1454     merkleRoot = merkleRoot_;
1455   }
1456 
1457   function setPublicPrice(uint256 _price) public onlyOwner {
1458     PRICE = _price;
1459   }
1460 
1461   function setWhitelistPrice(uint256 _price) public onlyOwner {
1462     WHITELIST_PRICE = _price;
1463   }
1464 
1465   function setMaxSupply(uint256 _supply) public onlyOwner {
1466     SUPPLY_MAX = _supply;
1467   }
1468 
1469   function withdraw() public onlyOwner {
1470     payable(owner()).transfer(address(this).balance);
1471   }
1472 
1473   function _baseURI() internal view virtual override returns (string memory) {
1474     return baseURI;
1475   }
1476 
1477   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1478       baseURI = _newBaseURI;
1479   }
1480 
1481   function tokenURI(uint256 _tokenId)
1482     public
1483     view
1484     virtual
1485     override
1486     returns (string memory)
1487   {
1488     require(
1489         _exists(_tokenId),
1490         "ERC721Metadata: URI query for nonexistent token"
1491     );
1492 
1493     if (!revealed) return _baseURI();
1494     return string(abi.encodePacked(_baseURI(), _tokenId.toString(), ".json"));
1495   }
1496 
1497 }