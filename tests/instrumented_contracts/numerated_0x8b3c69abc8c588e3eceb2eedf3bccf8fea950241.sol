1 // SPDX-License-Identifier: GPL-3.0
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev String operations.
12  */
13 library Strings {
14     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
15 
16     /**
17      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
18      */
19     function toString(uint256 value) internal pure returns (string memory) {
20         // Inspired by OraclizeAPI's implementation - MIT licence
21         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
22 
23         if (value == 0) {
24             return "0";
25         }
26         uint256 temp = value;
27         uint256 digits;
28         while (temp != 0) {
29             digits++;
30             temp /= 10;
31         }
32         bytes memory buffer = new bytes(digits);
33         while (value != 0) {
34             digits -= 1;
35             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
36             value /= 10;
37         }
38         return string(buffer);
39     }
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
43      */
44     function toHexString(uint256 value) internal pure returns (string memory) {
45         if (value == 0) {
46             return "0x00";
47         }
48         uint256 temp = value;
49         uint256 length = 0;
50         while (temp != 0) {
51             length++;
52             temp >>= 8;
53         }
54         return toHexString(value, length);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
59      */
60     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
61         bytes memory buffer = new bytes(2 * length + 2);
62         buffer[0] = "0";
63         buffer[1] = "x";
64         for (uint256 i = 2 * length + 1; i > 1; --i) {
65             buffer[i] = _HEX_SYMBOLS[value & 0xf];
66             value >>= 4;
67         }
68         require(value == 0, "Strings: hex length insufficient");
69         return string(buffer);
70     }
71 }
72 
73 // File: @openzeppelin/contracts/utils/Address.sol
74 
75 
76 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
77 
78 pragma solidity ^0.8.1;
79 
80 /**
81  * @dev Collection of functions related to the address type
82  */
83 library Address {
84     /**
85      * @dev Returns true if `account` is a contract.
86      *
87      * [IMPORTANT]
88      * ====
89      * It is unsafe to assume that an address for which this function returns
90      * false is an externally-owned account (EOA) and not a contract.
91      *
92      * Among others, `isContract` will return false for the following
93      * types of addresses:
94      *
95      *  - an externally-owned account
96      *  - a contract in construction
97      *  - an address where a contract will be created
98      *  - an address where a contract lived, but was destroyed
99      * ====
100      *
101      * [IMPORTANT]
102      * ====
103      * You shouldn't rely on `isContract` to protect against flash loan attacks!
104      *
105      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
106      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
107      * constructor.
108      * ====
109      */
110     function isContract(address account) internal view returns (bool) {
111         // This method relies on extcodesize/address.code.length, which returns 0
112         // for contracts in construction, since the code is only stored at the end
113         // of the constructor execution.
114 
115         return account.code.length > 0;
116     }
117 
118     /**
119      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
120      * `recipient`, forwarding all available gas and reverting on errors.
121      *
122      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
123      * of certain opcodes, possibly making contracts go over the 2300 gas limit
124      * imposed by `transfer`, making them unable to receive funds via
125      * `transfer`. {sendValue} removes this limitation.
126      *
127      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
128      *
129      * IMPORTANT: because control is transferred to `recipient`, care must be
130      * taken to not create reentrancy vulnerabilities. Consider using
131      * {ReentrancyGuard} or the
132      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
133      */
134     function sendValue(address payable recipient, uint256 amount) internal {
135         require(address(this).balance >= amount, "Address: insufficient balance");
136 
137         (bool success, ) = recipient.call{value: amount}("");
138         require(success, "Address: unable to send value, recipient may have reverted");
139     }
140 
141     /**
142      * @dev Performs a Solidity function call using a low level `call`. A
143      * plain `call` is an unsafe replacement for a function call: use this
144      * function instead.
145      *
146      * If `target` reverts with a revert reason, it is bubbled up by this
147      * function (like regular Solidity function calls).
148      *
149      * Returns the raw returned data. To convert to the expected return value,
150      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
151      *
152      * Requirements:
153      *
154      * - `target` must be a contract.
155      * - calling `target` with `data` must not revert.
156      *
157      * _Available since v3.1._
158      */
159     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
160         return functionCall(target, data, "Address: low-level call failed");
161     }
162 
163     /**
164      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
165      * `errorMessage` as a fallback revert reason when `target` reverts.
166      *
167      * _Available since v3.1._
168      */
169     function functionCall(
170         address target,
171         bytes memory data,
172         string memory errorMessage
173     ) internal returns (bytes memory) {
174         return functionCallWithValue(target, data, 0, errorMessage);
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
179      * but also transferring `value` wei to `target`.
180      *
181      * Requirements:
182      *
183      * - the calling contract must have an ETH balance of at least `value`.
184      * - the called Solidity function must be `payable`.
185      *
186      * _Available since v3.1._
187      */
188     function functionCallWithValue(
189         address target,
190         bytes memory data,
191         uint256 value
192     ) internal returns (bytes memory) {
193         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
194     }
195 
196     /**
197      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
198      * with `errorMessage` as a fallback revert reason when `target` reverts.
199      *
200      * _Available since v3.1._
201      */
202     function functionCallWithValue(
203         address target,
204         bytes memory data,
205         uint256 value,
206         string memory errorMessage
207     ) internal returns (bytes memory) {
208         require(address(this).balance >= value, "Address: insufficient balance for call");
209         require(isContract(target), "Address: call to non-contract");
210 
211         (bool success, bytes memory returndata) = target.call{value: value}(data);
212         return verifyCallResult(success, returndata, errorMessage);
213     }
214 
215     /**
216      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
217      * but performing a static call.
218      *
219      * _Available since v3.3._
220      */
221     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
222         return functionStaticCall(target, data, "Address: low-level static call failed");
223     }
224 
225     /**
226      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
227      * but performing a static call.
228      *
229      * _Available since v3.3._
230      */
231     function functionStaticCall(
232         address target,
233         bytes memory data,
234         string memory errorMessage
235     ) internal view returns (bytes memory) {
236         require(isContract(target), "Address: static call to non-contract");
237 
238         (bool success, bytes memory returndata) = target.staticcall(data);
239         return verifyCallResult(success, returndata, errorMessage);
240     }
241 
242     /**
243      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
244      * but performing a delegate call.
245      *
246      * _Available since v3.4._
247      */
248     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
249         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
250     }
251 
252     /**
253      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
254      * but performing a delegate call.
255      *
256      * _Available since v3.4._
257      */
258     function functionDelegateCall(
259         address target,
260         bytes memory data,
261         string memory errorMessage
262     ) internal returns (bytes memory) {
263         require(isContract(target), "Address: delegate call to non-contract");
264 
265         (bool success, bytes memory returndata) = target.delegatecall(data);
266         return verifyCallResult(success, returndata, errorMessage);
267     }
268 
269     /**
270      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
271      * revert reason using the provided one.
272      *
273      * _Available since v4.3._
274      */
275     function verifyCallResult(
276         bool success,
277         bytes memory returndata,
278         string memory errorMessage
279     ) internal pure returns (bytes memory) {
280         if (success) {
281             return returndata;
282         } else {
283             // Look for revert reason and bubble it up if present
284             if (returndata.length > 0) {
285                 // The easiest way to bubble the revert reason is using memory via assembly
286 
287                 assembly {
288                     let returndata_size := mload(returndata)
289                     revert(add(32, returndata), returndata_size)
290                 }
291             } else {
292                 revert(errorMessage);
293             }
294         }
295     }
296 }
297 
298 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
299 
300 
301 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
302 
303 pragma solidity ^0.8.0;
304 
305 /**
306  * @title ERC721 token receiver interface
307  * @dev Interface for any contract that wants to support safeTransfers
308  * from ERC721 asset contracts.
309  */
310 interface IERC721Receiver {
311     /**
312      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
313      * by `operator` from `from`, this function is called.
314      *
315      * It must return its Solidity selector to confirm the token transfer.
316      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
317      *
318      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
319      */
320     function onERC721Received(
321         address operator,
322         address from,
323         uint256 tokenId,
324         bytes calldata data
325     ) external returns (bytes4);
326 }
327 
328 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
329 
330 
331 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
332 
333 pragma solidity ^0.8.0;
334 
335 /**
336  * @dev Interface of the ERC165 standard, as defined in the
337  * https://eips.ethereum.org/EIPS/eip-165[EIP].
338  *
339  * Implementers can declare support of contract interfaces, which can then be
340  * queried by others ({ERC165Checker}).
341  *
342  * For an implementation, see {ERC165}.
343  */
344 interface IERC165 {
345     /**
346      * @dev Returns true if this contract implements the interface defined by
347      * `interfaceId`. See the corresponding
348      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
349      * to learn more about how these ids are created.
350      *
351      * This function call must use less than 30 000 gas.
352      */
353     function supportsInterface(bytes4 interfaceId) external view returns (bool);
354 }
355 
356 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
357 
358 
359 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
360 
361 pragma solidity ^0.8.0;
362 
363 
364 /**
365  * @dev Implementation of the {IERC165} interface.
366  *
367  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
368  * for the additional interface id that will be supported. For example:
369  *
370  * ```solidity
371  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
372  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
373  * }
374  * ```
375  *
376  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
377  */
378 abstract contract ERC165 is IERC165 {
379     /**
380      * @dev See {IERC165-supportsInterface}.
381      */
382     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
383         return interfaceId == type(IERC165).interfaceId;
384     }
385 }
386 
387 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
388 
389 
390 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
391 
392 pragma solidity ^0.8.0;
393 
394 
395 /**
396  * @dev Required interface of an ERC721 compliant contract.
397  */
398 interface IERC721 is IERC165 {
399     /**
400      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
401      */
402     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
403 
404     /**
405      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
406      */
407     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
408 
409     /**
410      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
411      */
412     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
413 
414     /**
415      * @dev Returns the number of tokens in ``owner``'s account.
416      */
417     function balanceOf(address owner) external view returns (uint256 balance);
418 
419     /**
420      * @dev Returns the owner of the `tokenId` token.
421      *
422      * Requirements:
423      *
424      * - `tokenId` must exist.
425      */
426     function ownerOf(uint256 tokenId) external view returns (address owner);
427 
428     /**
429      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
430      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
431      *
432      * Requirements:
433      *
434      * - `from` cannot be the zero address.
435      * - `to` cannot be the zero address.
436      * - `tokenId` token must exist and be owned by `from`.
437      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
438      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
439      *
440      * Emits a {Transfer} event.
441      */
442     function safeTransferFrom(
443         address from,
444         address to,
445         uint256 tokenId
446     ) external;
447 
448     /**
449      * @dev Transfers `tokenId` token from `from` to `to`.
450      *
451      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
452      *
453      * Requirements:
454      *
455      * - `from` cannot be the zero address.
456      * - `to` cannot be the zero address.
457      * - `tokenId` token must be owned by `from`.
458      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
459      *
460      * Emits a {Transfer} event.
461      */
462     function transferFrom(
463         address from,
464         address to,
465         uint256 tokenId
466     ) external;
467 
468     /**
469      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
470      * The approval is cleared when the token is transferred.
471      *
472      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
473      *
474      * Requirements:
475      *
476      * - The caller must own the token or be an approved operator.
477      * - `tokenId` must exist.
478      *
479      * Emits an {Approval} event.
480      */
481     function approve(address to, uint256 tokenId) external;
482 
483     /**
484      * @dev Returns the account approved for `tokenId` token.
485      *
486      * Requirements:
487      *
488      * - `tokenId` must exist.
489      */
490     function getApproved(uint256 tokenId) external view returns (address operator);
491 
492     /**
493      * @dev Approve or remove `operator` as an operator for the caller.
494      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
495      *
496      * Requirements:
497      *
498      * - The `operator` cannot be the caller.
499      *
500      * Emits an {ApprovalForAll} event.
501      */
502     function setApprovalForAll(address operator, bool _approved) external;
503 
504     /**
505      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
506      *
507      * See {setApprovalForAll}
508      */
509     function isApprovedForAll(address owner, address operator) external view returns (bool);
510 
511     /**
512      * @dev Safely transfers `tokenId` token from `from` to `to`.
513      *
514      * Requirements:
515      *
516      * - `from` cannot be the zero address.
517      * - `to` cannot be the zero address.
518      * - `tokenId` token must exist and be owned by `from`.
519      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
520      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
521      *
522      * Emits a {Transfer} event.
523      */
524     function safeTransferFrom(
525         address from,
526         address to,
527         uint256 tokenId,
528         bytes calldata data
529     ) external;
530 }
531 
532 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
533 
534 
535 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
536 
537 pragma solidity ^0.8.0;
538 
539 
540 /**
541  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
542  * @dev See https://eips.ethereum.org/EIPS/eip-721
543  */
544 interface IERC721Enumerable is IERC721 {
545     /**
546      * @dev Returns the total amount of tokens stored by the contract.
547      */
548     function totalSupply() external view returns (uint256);
549 
550     /**
551      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
552      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
553      */
554     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
555 
556     /**
557      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
558      * Use along with {totalSupply} to enumerate all tokens.
559      */
560     function tokenByIndex(uint256 index) external view returns (uint256);
561 }
562 
563 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
564 
565 
566 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
567 
568 pragma solidity ^0.8.0;
569 
570 
571 /**
572  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
573  * @dev See https://eips.ethereum.org/EIPS/eip-721
574  */
575 interface IERC721Metadata is IERC721 {
576     /**
577      * @dev Returns the token collection name.
578      */
579     function name() external view returns (string memory);
580 
581     /**
582      * @dev Returns the token collection symbol.
583      */
584     function symbol() external view returns (string memory);
585 
586     /**
587      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
588      */
589     function tokenURI(uint256 tokenId) external view returns (string memory);
590 }
591 
592 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
593 
594 
595 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
596 
597 pragma solidity ^0.8.0;
598 
599 /**
600  * @dev These functions deal with verification of Merkle Trees proofs.
601  *
602  * The proofs can be generated using the JavaScript library
603  * https://github.com/miguelmota/merkletreejs[merkletreejs].
604  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
605  *
606  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
607  */
608 library MerkleProof {
609     /**
610      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
611      * defined by `root`. For this, a `proof` must be provided, containing
612      * sibling hashes on the branch from the leaf to the root of the tree. Each
613      * pair of leaves and each pair of pre-images are assumed to be sorted.
614      */
615     function verify(
616         bytes32[] memory proof,
617         bytes32 root,
618         bytes32 leaf
619     ) internal pure returns (bool) {
620         return processProof(proof, leaf) == root;
621     }
622 
623     /**
624      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
625      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
626      * hash matches the root of the tree. When processing the proof, the pairs
627      * of leafs & pre-images are assumed to be sorted.
628      *
629      * _Available since v4.4._
630      */
631     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
632         bytes32 computedHash = leaf;
633         for (uint256 i = 0; i < proof.length; i++) {
634             bytes32 proofElement = proof[i];
635             if (computedHash <= proofElement) {
636                 // Hash(current computed hash + current element of the proof)
637                 computedHash = _efficientHash(computedHash, proofElement);
638             } else {
639                 // Hash(current element of the proof + current computed hash)
640                 computedHash = _efficientHash(proofElement, computedHash);
641             }
642         }
643         return computedHash;
644     }
645 
646     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
647         assembly {
648             mstore(0x00, a)
649             mstore(0x20, b)
650             value := keccak256(0x00, 0x40)
651         }
652     }
653 }
654 
655 // File: @openzeppelin/contracts/utils/Context.sol
656 
657 
658 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
659 
660 pragma solidity ^0.8.0;
661 
662 /**
663  * @dev Provides information about the current execution context, including the
664  * sender of the transaction and its data. While these are generally available
665  * via msg.sender and msg.data, they should not be accessed in such a direct
666  * manner, since when dealing with meta-transactions the account sending and
667  * paying for execution may not be the actual sender (as far as an application
668  * is concerned).
669  *
670  * This contract is only required for intermediate, library-like contracts.
671  */
672 abstract contract Context {
673     function _msgSender() internal view virtual returns (address) {
674         return msg.sender;
675     }
676 
677     function _msgData() internal view virtual returns (bytes calldata) {
678         return msg.data;
679     }
680 }
681 
682 // File: contracts/ERC721A.sol
683 
684 
685 
686 pragma solidity ^0.8.0;
687 
688 
689 
690 
691 
692 
693 
694 
695 
696 /**
697  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
698  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
699  *
700  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
701  *
702  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
703  *
704  * Does not support burning tokens to address(0).
705  */
706 contract ERC721A is
707   Context,
708   ERC165,
709   IERC721,
710   IERC721Metadata,
711   IERC721Enumerable
712 {
713   using Address for address;
714   using Strings for uint256;
715 
716   struct TokenOwnership {
717     address addr;
718     uint64 startTimestamp;
719   }
720 
721   struct AddressData {
722     uint128 balance;
723     uint128 numberMinted;
724   }
725 
726   uint256 private currentIndex = 1;
727 
728   uint256 internal immutable collectionSize;
729   uint256 internal immutable maxBatchSize;
730 
731   // Token name
732   string private _name;
733 
734   // Token symbol
735   string private _symbol;
736 
737   // Mapping from token ID to ownership details
738   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
739   mapping(uint256 => TokenOwnership) private _ownerships;
740 
741   // Mapping owner address to address data
742   mapping(address => AddressData) private _addressData;
743 
744   // Mapping from token ID to approved address
745   mapping(uint256 => address) private _tokenApprovals;
746 
747   // Mapping from owner to operator approvals
748   mapping(address => mapping(address => bool)) private _operatorApprovals;
749 
750   /**
751    * @dev
752    * `maxBatchSize` refers to how much a minter can mint at a time.
753    * `collectionSize_` refers to how many tokens are in the collection.
754    */
755   constructor(
756     string memory name_,
757     string memory symbol_,
758     uint256 maxBatchSize_,
759     uint256 collectionSize_
760   ) {
761     require(
762       collectionSize_ > 0,
763       "ERC721A: collection must have a nonzero supply"
764     );
765     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
766     _name = name_;
767     _symbol = symbol_;
768     maxBatchSize = maxBatchSize_;
769     collectionSize = collectionSize_;
770   }
771 
772   /**
773    * @dev See {IERC721Enumerable-totalSupply}.
774    */
775   function totalSupply() public view override returns (uint256) {
776     return currentIndex;
777   }
778 
779   /**
780    * @dev See {IERC721Enumerable-tokenByIndex}.
781    */
782   function tokenByIndex(uint256 index) public view override returns (uint256) {
783     require(index < totalSupply(), "ERC721A: global index out of bounds");
784     return index;
785   }
786 
787   /**
788    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
789    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
790    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
791    */
792   function tokenOfOwnerByIndex(address owner, uint256 index)
793     public
794     view
795     override
796     returns (uint256)
797   {
798     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
799     uint256 numMintedSoFar = totalSupply();
800     uint256 tokenIdsIdx = 0;
801     address currOwnershipAddr = address(0);
802     for (uint256 i = 0; i < numMintedSoFar; i++) {
803       TokenOwnership memory ownership = _ownerships[i];
804       if (ownership.addr != address(0)) {
805         currOwnershipAddr = ownership.addr;
806       }
807       if (currOwnershipAddr == owner) {
808         if (tokenIdsIdx == index) {
809           return i;
810         }
811         tokenIdsIdx++;
812       }
813     }
814     revert("ERC721A: unable to get token of owner by index");
815   }
816 
817   /**
818    * @dev See {IERC165-supportsInterface}.
819    */
820   function supportsInterface(bytes4 interfaceId)
821     public
822     view
823     virtual
824     override(ERC165, IERC165)
825     returns (bool)
826   {
827     return
828       interfaceId == type(IERC721).interfaceId ||
829       interfaceId == type(IERC721Metadata).interfaceId ||
830       interfaceId == type(IERC721Enumerable).interfaceId ||
831       super.supportsInterface(interfaceId);
832   }
833 
834   /**
835    * @dev See {IERC721-balanceOf}.
836    */
837   function balanceOf(address owner) public view override returns (uint256) {
838     require(owner != address(0), "ERC721A: balance query for the zero address");
839     return uint256(_addressData[owner].balance);
840   }
841 
842   function _numberMinted(address owner) internal view returns (uint256) {
843     require(
844       owner != address(0),
845       "ERC721A: number minted query for the zero address"
846     );
847     return uint256(_addressData[owner].numberMinted);
848   }
849 
850   function ownershipOf(uint256 tokenId)
851     internal
852     view
853     returns (TokenOwnership memory)
854   {
855     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
856 
857     uint256 lowestTokenToCheck;
858     if (tokenId >= maxBatchSize) {
859       lowestTokenToCheck = tokenId - maxBatchSize + 1;
860     }
861 
862     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
863       TokenOwnership memory ownership = _ownerships[curr];
864       if (ownership.addr != address(0)) {
865         return ownership;
866       }
867     }
868 
869     revert("ERC721A: unable to determine the owner of token");
870   }
871 
872   /**
873    * @dev See {IERC721-ownerOf}.
874    */
875   function ownerOf(uint256 tokenId) public view override returns (address) {
876     return ownershipOf(tokenId).addr;
877   }
878 
879   /**
880    * @dev See {IERC721Metadata-name}.
881    */
882   function name() public view virtual override returns (string memory) {
883     return _name;
884   }
885 
886   /**
887    * @dev See {IERC721Metadata-symbol}.
888    */
889   function symbol() public view virtual override returns (string memory) {
890     return _symbol;
891   }
892 
893   /**
894    * @dev See {IERC721Metadata-tokenURI}.
895    */
896   function tokenURI(uint256 tokenId)
897     public
898     view
899     virtual
900     override
901     returns (string memory)
902   {
903     require(
904       _exists(tokenId),
905       "ERC721Metadata: URI query for nonexistent token"
906     );
907 
908     string memory baseURI = _baseURI();
909     return
910       bytes(baseURI).length > 0
911         ? string(abi.encodePacked(baseURI, tokenId.toString()))
912         : "";
913   }
914 
915   /**
916    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
917    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
918    * by default, can be overriden in child contracts.
919    */
920   function _baseURI() internal view virtual returns (string memory) {
921     return "";
922   }
923 
924   /**
925    * @dev See {IERC721-approve}.
926    */
927   function approve(address to, uint256 tokenId) public override {
928     address owner = ERC721A.ownerOf(tokenId);
929     require(to != owner, "ERC721A: approval to current owner");
930 
931     require(
932       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
933       "ERC721A: approve caller is not owner nor approved for all"
934     );
935 
936     _approve(to, tokenId, owner);
937   }
938 
939   /**
940    * @dev See {IERC721-getApproved}.
941    */
942   function getApproved(uint256 tokenId) public view override returns (address) {
943     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
944 
945     return _tokenApprovals[tokenId];
946   }
947 
948   /**
949    * @dev See {IERC721-setApprovalForAll}.
950    */
951   function setApprovalForAll(address operator, bool approved) public override {
952     require(operator != _msgSender(), "ERC721A: approve to caller");
953 
954     _operatorApprovals[_msgSender()][operator] = approved;
955     emit ApprovalForAll(_msgSender(), operator, approved);
956   }
957 
958   /**
959    * @dev See {IERC721-isApprovedForAll}.
960    */
961   function isApprovedForAll(address owner, address operator)
962     public
963     view
964     virtual
965     override
966     returns (bool)
967   {
968     return _operatorApprovals[owner][operator];
969   }
970 
971   /**
972    * @dev See {IERC721-transferFrom}.
973    */
974   function transferFrom(
975     address from,
976     address to,
977     uint256 tokenId
978   ) public override {
979     _transfer(from, to, tokenId);
980   }
981 
982   /**
983    * @dev See {IERC721-safeTransferFrom}.
984    */
985   function safeTransferFrom(
986     address from,
987     address to,
988     uint256 tokenId
989   ) public override {
990     safeTransferFrom(from, to, tokenId, "");
991   }
992 
993   /**
994    * @dev See {IERC721-safeTransferFrom}.
995    */
996   function safeTransferFrom(
997     address from,
998     address to,
999     uint256 tokenId,
1000     bytes memory _data
1001   ) public override {
1002     _transfer(from, to, tokenId);
1003     require(
1004       _checkOnERC721Received(from, to, tokenId, _data),
1005       "ERC721A: transfer to non ERC721Receiver implementer"
1006     );
1007   }
1008 
1009   /**
1010    * @dev Returns whether `tokenId` exists.
1011    *
1012    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1013    *
1014    * Tokens start existing when they are minted (`_mint`),
1015    */
1016   function _exists(uint256 tokenId) internal view returns (bool) {
1017     return tokenId < currentIndex;
1018   }
1019 
1020   function _safeMint(address to, uint256 quantity) internal {
1021     _safeMint(to, quantity, "");
1022   }
1023 
1024   /**
1025    * @dev Mints `quantity` tokens and transfers them to `to`.
1026    *
1027    * Requirements:
1028    *
1029    * - there must be `quantity` tokens remaining unminted in the total collection.
1030    * - `to` cannot be the zero address.
1031    * - `quantity` cannot be larger than the max batch size.
1032    *
1033    * Emits a {Transfer} event.
1034    */
1035   function _safeMint(
1036     address to,
1037     uint256 quantity,
1038     bytes memory _data
1039   ) internal {
1040     uint256 startTokenId = currentIndex;
1041     require(to != address(0), "ERC721A: mint to the zero address");
1042     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1043     require(!_exists(startTokenId), "ERC721A: token already minted");
1044     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1045 
1046     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1047 
1048     AddressData memory addressData = _addressData[to];
1049     _addressData[to] = AddressData(
1050       addressData.balance + uint128(quantity),
1051       addressData.numberMinted + uint128(quantity)
1052     );
1053     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1054 
1055     uint256 updatedIndex = startTokenId;
1056 
1057     for (uint256 i = 0; i < quantity; i++) {
1058       emit Transfer(address(0), to, updatedIndex);
1059       require(
1060         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1061         "ERC721A: transfer to non ERC721Receiver implementer"
1062       );
1063       updatedIndex++;
1064     }
1065 
1066     currentIndex = updatedIndex;
1067     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1068   }
1069 
1070   /**
1071    * @dev Transfers `tokenId` from `from` to `to`.
1072    *
1073    * Requirements:
1074    *
1075    * - `to` cannot be the zero address.
1076    * - `tokenId` token must be owned by `from`.
1077    *
1078    * Emits a {Transfer} event.
1079    */
1080   function _transfer(
1081     address from,
1082     address to,
1083     uint256 tokenId
1084   ) private {
1085     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1086 
1087     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1088       getApproved(tokenId) == _msgSender() ||
1089       isApprovedForAll(prevOwnership.addr, _msgSender()));
1090 
1091     require(
1092       isApprovedOrOwner,
1093       "ERC721A: transfer caller is not owner nor approved"
1094     );
1095 
1096     require(
1097       prevOwnership.addr == from,
1098       "ERC721A: transfer from incorrect owner"
1099     );
1100     require(to != address(0), "ERC721A: transfer to the zero address");
1101 
1102     _beforeTokenTransfers(from, to, tokenId, 1);
1103 
1104     // Clear approvals from the previous owner
1105     _approve(address(0), tokenId, prevOwnership.addr);
1106 
1107     _addressData[from].balance -= 1;
1108     _addressData[to].balance += 1;
1109     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1110 
1111     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1112     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1113     uint256 nextTokenId = tokenId + 1;
1114     if (_ownerships[nextTokenId].addr == address(0)) {
1115       if (_exists(nextTokenId)) {
1116         _ownerships[nextTokenId] = TokenOwnership(
1117           prevOwnership.addr,
1118           prevOwnership.startTimestamp
1119         );
1120       }
1121     }
1122 
1123     emit Transfer(from, to, tokenId);
1124     _afterTokenTransfers(from, to, tokenId, 1);
1125   }
1126 
1127   /**
1128    * @dev Approve `to` to operate on `tokenId`
1129    *
1130    * Emits a {Approval} event.
1131    */
1132   function _approve(
1133     address to,
1134     uint256 tokenId,
1135     address owner
1136   ) private {
1137     _tokenApprovals[tokenId] = to;
1138     emit Approval(owner, to, tokenId);
1139   }
1140 
1141   uint256 public nextOwnerToExplicitlySet = 0;
1142 
1143   /**
1144    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1145    */
1146   function _setOwnersExplicit(uint256 quantity) internal {
1147     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1148     require(quantity > 0, "quantity must be nonzero");
1149     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1150     if (endIndex > collectionSize - 1) {
1151       endIndex = collectionSize - 1;
1152     }
1153     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1154     require(_exists(endIndex), "not enough minted yet for this cleanup");
1155     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1156       if (_ownerships[i].addr == address(0)) {
1157         TokenOwnership memory ownership = ownershipOf(i);
1158         _ownerships[i] = TokenOwnership(
1159           ownership.addr,
1160           ownership.startTimestamp
1161         );
1162       }
1163     }
1164     nextOwnerToExplicitlySet = endIndex + 1;
1165   }
1166 
1167   /**
1168    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1169    * The call is not executed if the target address is not a contract.
1170    *
1171    * @param from address representing the previous owner of the given token ID
1172    * @param to target address that will receive the tokens
1173    * @param tokenId uint256 ID of the token to be transferred
1174    * @param _data bytes optional data to send along with the call
1175    * @return bool whether the call correctly returned the expected magic value
1176    */
1177   function _checkOnERC721Received(
1178     address from,
1179     address to,
1180     uint256 tokenId,
1181     bytes memory _data
1182   ) private returns (bool) {
1183     if (to.isContract()) {
1184       try
1185         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1186       returns (bytes4 retval) {
1187         return retval == IERC721Receiver(to).onERC721Received.selector;
1188       } catch (bytes memory reason) {
1189         if (reason.length == 0) {
1190           revert("ERC721A: transfer to non ERC721Receiver implementer");
1191         } else {
1192           assembly {
1193             revert(add(32, reason), mload(reason))
1194           }
1195         }
1196       }
1197     } else {
1198       return true;
1199     }
1200   }
1201 
1202   /**
1203    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1204    *
1205    * startTokenId - the first token id to be transferred
1206    * quantity - the amount to be transferred
1207    *
1208    * Calling conditions:
1209    *
1210    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1211    * transferred to `to`.
1212    * - When `from` is zero, `tokenId` will be minted for `to`.
1213    */
1214   function _beforeTokenTransfers(
1215     address from,
1216     address to,
1217     uint256 startTokenId,
1218     uint256 quantity
1219   ) internal virtual {}
1220 
1221   /**
1222    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1223    * minting.
1224    *
1225    * startTokenId - the first token id to be transferred
1226    * quantity - the amount to be transferred
1227    *
1228    * Calling conditions:
1229    *
1230    * - when `from` and `to` are both non-zero.
1231    * - `from` and `to` are never both zero.
1232    */
1233   function _afterTokenTransfers(
1234     address from,
1235     address to,
1236     uint256 startTokenId,
1237     uint256 quantity
1238   ) internal virtual {}
1239 }
1240 // File: @openzeppelin/contracts/access/Ownable.sol
1241 
1242 
1243 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1244 
1245 pragma solidity ^0.8.0;
1246 
1247 
1248 /**
1249  * @dev Contract module which provides a basic access control mechanism, where
1250  * there is an account (an owner) that can be granted exclusive access to
1251  * specific functions.
1252  *
1253  * By default, the owner account will be the one that deploys the contract. This
1254  * can later be changed with {transferOwnership}.
1255  *
1256  * This module is used through inheritance. It will make available the modifier
1257  * `onlyOwner`, which can be applied to your functions to restrict their use to
1258  * the owner.
1259  */
1260 abstract contract Ownable is Context {
1261     address private _owner;
1262 
1263     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1264 
1265     /**
1266      * @dev Initializes the contract setting the deployer as the initial owner.
1267      */
1268     constructor() {
1269         _transferOwnership(_msgSender());
1270     }
1271 
1272     /**
1273      * @dev Returns the address of the current owner.
1274      */
1275     function owner() public view virtual returns (address) {
1276         return _owner;
1277     }
1278 
1279     /**
1280      * @dev Throws if called by any account other than the owner.
1281      */
1282     modifier onlyOwner() {
1283         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1284         _;
1285     }
1286 
1287     /**
1288      * @dev Leaves the contract without owner. It will not be possible to call
1289      * `onlyOwner` functions anymore. Can only be called by the current owner.
1290      *
1291      * NOTE: Renouncing ownership will leave the contract without an owner,
1292      * thereby removing any functionality that is only available to the owner.
1293      */
1294     function renounceOwnership() public virtual onlyOwner {
1295         _transferOwnership(address(0));
1296     }
1297 
1298     /**
1299      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1300      * Can only be called by the current owner.
1301      */
1302     function transferOwnership(address newOwner) public virtual onlyOwner {
1303         require(newOwner != address(0), "Ownable: new owner is the zero address");
1304         _transferOwnership(newOwner);
1305     }
1306 
1307     /**
1308      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1309      * Internal function without access restriction.
1310      */
1311     function _transferOwnership(address newOwner) internal virtual {
1312         address oldOwner = _owner;
1313         _owner = newOwner;
1314         emit OwnershipTransferred(oldOwner, newOwner);
1315     }
1316 }
1317 
1318 // File: contracts/DeckOfDegeneracy.sol
1319 
1320 
1321 
1322 pragma solidity >=0.7.0 <0.9.0;
1323 
1324 
1325 
1326 
1327 contract DeckOfDegeneracy is ERC721A, Ownable {
1328 	using Strings for uint256;
1329 
1330 	string baseURI;
1331 	string baseExtension = ".json";
1332 	string notRevealedUri;
1333 	uint256 public cost = .1 ether;
1334 	uint256 public maxSupply = 2700;
1335 	uint256 public maxMintPerBatch = 108;
1336 	bool public paused = true;
1337 	bool public revealed = false;
1338 	bool public isPresale = true;
1339 	bool public isMainSale = false;
1340 	bytes32 public whitelistMerkleRoot;
1341 	bool public useWhitelistedAddressesBackup = false;
1342 	mapping(address => uint256) public addressMintedBalance;
1343 	mapping(address => bool) public whitelistedAddressesBackup;
1344 
1345 	constructor(
1346 		string memory _name,
1347 		string memory _symbol,
1348 		string memory _notRevealedUri
1349 	) ERC721A(_name, _symbol, maxMintPerBatch, maxSupply) {
1350 		notRevealedUri = _notRevealedUri;
1351 	}
1352 
1353 	// internal
1354 	function _baseURI() internal view virtual override returns (string memory) {
1355 		return baseURI;
1356 	}
1357 
1358 	function _generateMerkleLeaf(address account)
1359 		internal
1360 		pure
1361 		returns (bytes32)
1362 	{
1363 		return keccak256(abi.encodePacked(account));
1364 	}
1365 
1366 	/**
1367 	 * Validates a Merkle proof based on a provided merkle root and leaf node.
1368 	 */
1369 	function _verify(
1370 		bytes32[] memory proof,
1371 		bytes32 merkleRoot,
1372 		bytes32 leafNode
1373 	) internal pure returns (bool) {
1374 		return MerkleProof.verify(proof, merkleRoot, leafNode);
1375 	}
1376 
1377 	// require checks refactored for presaleMint() & mint().
1378 	function requireChecks(uint256 _mintAmount) internal {
1379 		require(paused == false, "the contract is paused");
1380 		require(_mintAmount > 0, "need to mint at least 1 NFT");
1381 		require(totalSupply() + _mintAmount <= maxSupply, "max NFT limit exceeded");
1382 		require(
1383 			_mintAmount <= maxMintPerBatch,
1384 			"max NFT per address exceeded"
1385 		);
1386 
1387 	}
1388 
1389 	/**
1390 	 * Go all in!
1391 	 *
1392 	 * Limit: 2 Whitelist Presale
1393 	 * Only whitelisted individuals can mint presale. We utilize a Merkle Proof to determine who is whitelisted.
1394 	 *
1395 	 * If these cases are not met, the mint WILL fail, and your gas will NOT be refunded.
1396 	 * Please only mint through deckofdegeneracy.io unless you're absolutely sure you know what you're doing!
1397 	 */
1398 	function presaleMint(uint256 _mintAmount, bytes32[] calldata proof)
1399 		public
1400 		payable
1401 	{
1402 		requireChecks(_mintAmount);
1403 		// The owner of the smart contract can mint at any time, regardless of if the presale is on.
1404 		if (msg.sender != owner()) {
1405 			if (useWhitelistedAddressesBackup) {
1406 				require(whitelistedAddressesBackup[msg.sender] == true, "user is not whitelisted");
1407 			} else {
1408 				require(
1409 					_verify(
1410 						proof,
1411 						whitelistMerkleRoot,
1412 						_generateMerkleLeaf(msg.sender)
1413 					),
1414 					"user is not whitelisted"
1415 				);
1416 			}
1417 		}
1418 		
1419 		if (msg.sender != owner()) {
1420 			require(msg.value >= cost * _mintAmount, "insufficient funds");
1421 		}
1422 
1423 		_safeMint(msg.sender, _mintAmount);
1424 	}
1425 
1426 
1427 	// mint function for the public sale
1428 	function mint(uint256 _mintAmount)
1429 		public
1430 		payable
1431 	{
1432 
1433 		requireChecks(_mintAmount);
1434 		require(isMainSale == true, "sale not on");
1435 		if (msg.sender != owner()) {
1436 			require(msg.value >= cost * _mintAmount, "insufficient funds");
1437 		}
1438 
1439 		_safeMint(msg.sender, _mintAmount);
1440 	}
1441 
1442 
1443 	function tokenURI(uint256 tokenId)
1444 			public
1445 			view
1446 			virtual
1447 			override
1448 			returns (string memory)
1449 		{
1450 			require(
1451 				_exists(tokenId),
1452 				"ERC721Metadata: URI query for nonexistent token"
1453 			);
1454 
1455 			if (revealed == false) {
1456 				return notRevealedUri;
1457 			}
1458 
1459 			string memory currentBaseURI = _baseURI();
1460 			return
1461 				bytes(currentBaseURI).length > 0
1462 					? string(
1463 						abi.encodePacked(
1464 							currentBaseURI,
1465 							tokenId.toString(),
1466 							baseExtension
1467 						)
1468 					)
1469 					: "";
1470 	}
1471 
1472 	/** Sets the merkle root for the whitelisted individuals. */
1473 	function setWhiteListMerkleRoot(bytes32 merkleRoot) public onlyOwner {
1474 		whitelistMerkleRoot = merkleRoot;
1475 	}
1476 
1477 	function setWhitelistedAddressesBackup(address[] memory addresses) public onlyOwner {
1478 		for (uint256 i = 0; i < addresses.length; i++) {
1479 			whitelistedAddressesBackup[addresses[i]] = true;
1480 		}
1481 	}
1482 
1483 	function setBackupWhitelistedAddressState(bool state) public onlyOwner {
1484 		useWhitelistedAddressesBackup = state;
1485 	}
1486 
1487 	//cost in Wei
1488 	function setCost(uint256 _newCost) public onlyOwner {
1489 		cost = _newCost;
1490 	}
1491 
1492 	function setBaseURI(string memory _newBaseURI) public onlyOwner {
1493 		baseURI = _newBaseURI;
1494 	}
1495 
1496 	function setBaseExtension(string memory _newBaseExtension)
1497 		public
1498 		onlyOwner
1499 	{
1500 		baseExtension = _newBaseExtension;
1501 	}
1502 
1503 	function setRevealedState(bool revealedState) public onlyOwner {
1504 		revealed = revealedState;
1505 	}
1506 
1507 	function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1508 		notRevealedUri = _notRevealedURI;
1509 	}
1510 
1511 	function pause(bool _state) public onlyOwner {
1512 		paused = _state;
1513 	}
1514 
1515 	function setPresale(bool _state) public onlyOwner {
1516 		isPresale = _state;
1517 	}
1518 
1519 	function setMainSale(bool _state) public onlyOwner {
1520 		isMainSale = _state;
1521 	}
1522 
1523 	function withdraw() public payable onlyOwner {
1524 		(bool os, ) = payable(owner()).call{value: address(this).balance}("");
1525 		require(os);
1526 	}
1527 }