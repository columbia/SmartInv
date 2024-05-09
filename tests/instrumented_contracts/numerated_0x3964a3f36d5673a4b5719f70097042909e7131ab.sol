1 // SPDX-License-Identifier: MIT 
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 }
71 
72 // File: @openzeppelin/contracts/utils/Address.sol
73 
74 
75 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
76 
77 pragma solidity ^0.8.1;
78 
79 /**
80  * @dev Collection of functions related to the address type
81  */
82 library Address {
83     /**
84      * @dev Returns true if `account` is a contract.
85      *
86      * [IMPORTANT]
87      * ====
88      * It is unsafe to assume that an address for which this function returns
89      * false is an externally-owned account (EOA) and not a contract.
90      *
91      * Among others, `isContract` will return false for the following
92      * types of addresses:
93      *
94      *  - an externally-owned account
95      *  - a contract in construction
96      *  - an address where a contract will be created
97      *  - an address where a contract lived, but was destroyed
98      * ====
99      *
100      * [IMPORTANT]
101      * ====
102      * You shouldn't rely on `isContract` to protect against flash loan attacks!
103      *
104      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
105      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
106      * constructor.
107      * ====
108      */
109     function isContract(address account) internal view returns (bool) {
110         // This method relies on extcodesize/address.code.length, which returns 0
111         // for contracts in construction, since the code is only stored at the end
112         // of the constructor execution.
113 
114         return account.code.length > 0;
115     }
116 
117     /**
118      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
119      * `recipient`, forwarding all available gas and reverting on errors.
120      *
121      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
122      * of certain opcodes, possibly making contracts go over the 2300 gas limit
123      * imposed by `transfer`, making them unable to receive funds via
124      * `transfer`. {sendValue} removes this limitation.
125      *
126      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
127      *
128      * IMPORTANT: because control is transferred to `recipient`, care must be
129      * taken to not create reentrancy vulnerabilities. Consider using
130      * {ReentrancyGuard} or the
131      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
132      */
133     function sendValue(address payable recipient, uint256 amount) internal {
134         require(address(this).balance >= amount, "Address: insufficient balance");
135 
136         (bool success, ) = recipient.call{value: amount}("");
137         require(success, "Address: unable to send value, recipient may have reverted");
138     }
139 
140     /**
141      * @dev Performs a Solidity function call using a low level `call`. A
142      * plain `call` is an unsafe replacement for a function call: use this
143      * function instead.
144      *
145      * If `target` reverts with a revert reason, it is bubbled up by this
146      * function (like regular Solidity function calls).
147      *
148      * Returns the raw returned data. To convert to the expected return value,
149      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
150      *
151      * Requirements:
152      *
153      * - `target` must be a contract.
154      * - calling `target` with `data` must not revert.
155      *
156      * _Available since v3.1._
157      */
158     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
159         return functionCall(target, data, "Address: low-level call failed");
160     }
161 
162     /**
163      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
164      * `errorMessage` as a fallback revert reason when `target` reverts.
165      *
166      * _Available since v3.1._
167      */
168     function functionCall(
169         address target,
170         bytes memory data,
171         string memory errorMessage
172     ) internal returns (bytes memory) {
173         return functionCallWithValue(target, data, 0, errorMessage);
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
178      * but also transferring `value` wei to `target`.
179      *
180      * Requirements:
181      *
182      * - the calling contract must have an ETH balance of at least `value`.
183      * - the called Solidity function must be `payable`.
184      *
185      * _Available since v3.1._
186      */
187     function functionCallWithValue(
188         address target,
189         bytes memory data,
190         uint256 value
191     ) internal returns (bytes memory) {
192         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
193     }
194 
195     /**
196      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
197      * with `errorMessage` as a fallback revert reason when `target` reverts.
198      *
199      * _Available since v3.1._
200      */
201     function functionCallWithValue(
202         address target,
203         bytes memory data,
204         uint256 value,
205         string memory errorMessage
206     ) internal returns (bytes memory) {
207         require(address(this).balance >= value, "Address: insufficient balance for call");
208         require(isContract(target), "Address: call to non-contract");
209 
210         (bool success, bytes memory returndata) = target.call{value: value}(data);
211         return verifyCallResult(success, returndata, errorMessage);
212     }
213 
214     /**
215      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
216      * but performing a static call.
217      *
218      * _Available since v3.3._
219      */
220     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
221         return functionStaticCall(target, data, "Address: low-level static call failed");
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
226      * but performing a static call.
227      *
228      * _Available since v3.3._
229      */
230     function functionStaticCall(
231         address target,
232         bytes memory data,
233         string memory errorMessage
234     ) internal view returns (bytes memory) {
235         require(isContract(target), "Address: static call to non-contract");
236 
237         (bool success, bytes memory returndata) = target.staticcall(data);
238         return verifyCallResult(success, returndata, errorMessage);
239     }
240 
241     /**
242      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
243      * but performing a delegate call.
244      *
245      * _Available since v3.4._
246      */
247     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
248         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
253      * but performing a delegate call.
254      *
255      * _Available since v3.4._
256      */
257     function functionDelegateCall(
258         address target,
259         bytes memory data,
260         string memory errorMessage
261     ) internal returns (bytes memory) {
262         require(isContract(target), "Address: delegate call to non-contract");
263 
264         (bool success, bytes memory returndata) = target.delegatecall(data);
265         return verifyCallResult(success, returndata, errorMessage);
266     }
267 
268     /**
269      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
270      * revert reason using the provided one.
271      *
272      * _Available since v4.3._
273      */
274     function verifyCallResult(
275         bool success,
276         bytes memory returndata,
277         string memory errorMessage
278     ) internal pure returns (bytes memory) {
279         if (success) {
280             return returndata;
281         } else {
282             // Look for revert reason and bubble it up if present
283             if (returndata.length > 0) {
284                 // The easiest way to bubble the revert reason is using memory via assembly
285 
286                 assembly {
287                     let returndata_size := mload(returndata)
288                     revert(add(32, returndata), returndata_size)
289                 }
290             } else {
291                 revert(errorMessage);
292             }
293         }
294     }
295 }
296 
297 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
298 
299 
300 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
301 
302 pragma solidity ^0.8.0;
303 
304 /**
305  * @title ERC721 token receiver interface
306  * @dev Interface for any contract that wants to support safeTransfers
307  * from ERC721 asset contracts.
308  */
309 interface IERC721Receiver {
310     /**
311      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
312      * by `operator` from `from`, this function is called.
313      *
314      * It must return its Solidity selector to confirm the token transfer.
315      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
316      *
317      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
318      */
319     function onERC721Received(
320         address operator,
321         address from,
322         uint256 tokenId,
323         bytes calldata data
324     ) external returns (bytes4);
325 }
326 
327 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
328 
329 
330 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
331 
332 pragma solidity ^0.8.0;
333 
334 /**
335  * @dev Interface of the ERC165 standard, as defined in the
336  * https://eips.ethereum.org/EIPS/eip-165[EIP].
337  *
338  * Implementers can declare support of contract interfaces, which can then be
339  * queried by others ({ERC165Checker}).
340  *
341  * For an implementation, see {ERC165}.
342  */
343 interface IERC165 {
344     /**
345      * @dev Returns true if this contract implements the interface defined by
346      * `interfaceId`. See the corresponding
347      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
348      * to learn more about how these ids are created.
349      *
350      * This function call must use less than 30 000 gas.
351      */
352     function supportsInterface(bytes4 interfaceId) external view returns (bool);
353 }
354 
355 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
356 
357 
358 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
359 
360 pragma solidity ^0.8.0;
361 
362 
363 /**
364  * @dev Implementation of the {IERC165} interface.
365  *
366  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
367  * for the additional interface id that will be supported. For example:
368  *
369  * ```solidity
370  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
371  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
372  * }
373  * ```
374  *
375  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
376  */
377 abstract contract ERC165 is IERC165 {
378     /**
379      * @dev See {IERC165-supportsInterface}.
380      */
381     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
382         return interfaceId == type(IERC165).interfaceId;
383     }
384 }
385 
386 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
387 
388 
389 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
390 
391 pragma solidity ^0.8.0;
392 
393 
394 /**
395  * @dev Required interface of an ERC721 compliant contract.
396  */
397 interface IERC721 is IERC165 {
398     /**
399      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
400      */
401     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
402 
403     /**
404      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
405      */
406     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
407 
408     /**
409      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
410      */
411     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
412 
413     /**
414      * @dev Returns the number of tokens in ``owner``'s account.
415      */
416     function balanceOf(address owner) external view returns (uint256 balance);
417 
418     /**
419      * @dev Returns the owner of the `tokenId` token.
420      *
421      * Requirements:
422      *
423      * - `tokenId` must exist.
424      */
425     function ownerOf(uint256 tokenId) external view returns (address owner);
426 
427     /**
428      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
429      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
430      *
431      * Requirements:
432      *
433      * - `from` cannot be the zero address.
434      * - `to` cannot be the zero address.
435      * - `tokenId` token must exist and be owned by `from`.
436      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
437      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
438      *
439      * Emits a {Transfer} event.
440      */
441     function safeTransferFrom(
442         address from,
443         address to,
444         uint256 tokenId
445     ) external;
446 
447     /**
448      * @dev Transfers `tokenId` token from `from` to `to`.
449      *
450      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
451      *
452      * Requirements:
453      *
454      * - `from` cannot be the zero address.
455      * - `to` cannot be the zero address.
456      * - `tokenId` token must be owned by `from`.
457      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
458      *
459      * Emits a {Transfer} event.
460      */
461     function transferFrom(
462         address from,
463         address to,
464         uint256 tokenId
465     ) external;
466 
467     /**
468      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
469      * The approval is cleared when the token is transferred.
470      *
471      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
472      *
473      * Requirements:
474      *
475      * - The caller must own the token or be an approved operator.
476      * - `tokenId` must exist.
477      *
478      * Emits an {Approval} event.
479      */
480     function approve(address to, uint256 tokenId) external;
481 
482     /**
483      * @dev Returns the account approved for `tokenId` token.
484      *
485      * Requirements:
486      *
487      * - `tokenId` must exist.
488      */
489     function getApproved(uint256 tokenId) external view returns (address operator);
490 
491     /**
492      * @dev Approve or remove `operator` as an operator for the caller.
493      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
494      *
495      * Requirements:
496      *
497      * - The `operator` cannot be the caller.
498      *
499      * Emits an {ApprovalForAll} event.
500      */
501     function setApprovalForAll(address operator, bool _approved) external;
502 
503     /**
504      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
505      *
506      * See {setApprovalForAll}
507      */
508     function isApprovedForAll(address owner, address operator) external view returns (bool);
509 
510     /**
511      * @dev Safely transfers `tokenId` token from `from` to `to`.
512      *
513      * Requirements:
514      *
515      * - `from` cannot be the zero address.
516      * - `to` cannot be the zero address.
517      * - `tokenId` token must exist and be owned by `from`.
518      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
519      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
520      *
521      * Emits a {Transfer} event.
522      */
523     function safeTransferFrom(
524         address from,
525         address to,
526         uint256 tokenId,
527         bytes calldata data
528     ) external;
529 }
530 
531 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
532 
533 
534 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
535 
536 pragma solidity ^0.8.0;
537 
538 
539 /**
540  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
541  * @dev See https://eips.ethereum.org/EIPS/eip-721
542  */
543 interface IERC721Metadata is IERC721 {
544     /**
545      * @dev Returns the token collection name.
546      */
547     function name() external view returns (string memory);
548 
549     /**
550      * @dev Returns the token collection symbol.
551      */
552     function symbol() external view returns (string memory);
553 
554     /**
555      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
556      */
557     function tokenURI(uint256 tokenId) external view returns (string memory);
558 }
559 
560 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
561 
562 
563 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
564 
565 pragma solidity ^0.8.0;
566 
567 /**
568  * @dev These functions deal with verification of Merkle Trees proofs.
569  *
570  * The proofs can be generated using the JavaScript library
571  * https://github.com/miguelmota/merkletreejs[merkletreejs].
572  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
573  *
574  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
575  */
576 library MerkleProof {
577     /**
578      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
579      * defined by `root`. For this, a `proof` must be provided, containing
580      * sibling hashes on the branch from the leaf to the root of the tree. Each
581      * pair of leaves and each pair of pre-images are assumed to be sorted.
582      */
583     function verify(
584         bytes32[] memory proof,
585         bytes32 root,
586         bytes32 leaf
587     ) internal pure returns (bool) {
588         return processProof(proof, leaf) == root;
589     }
590 
591     /**
592      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
593      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
594      * hash matches the root of the tree. When processing the proof, the pairs
595      * of leafs & pre-images are assumed to be sorted.
596      *
597      * _Available since v4.4._
598      */
599     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
600         bytes32 computedHash = leaf;
601         for (uint256 i = 0; i < proof.length; i++) {
602             bytes32 proofElement = proof[i];
603             if (computedHash <= proofElement) {
604                 // Hash(current computed hash + current element of the proof)
605                 computedHash = _efficientHash(computedHash, proofElement);
606             } else {
607                 // Hash(current element of the proof + current computed hash)
608                 computedHash = _efficientHash(proofElement, computedHash);
609             }
610         }
611         return computedHash;
612     }
613 
614     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
615         assembly {
616             mstore(0x00, a)
617             mstore(0x20, b)
618             value := keccak256(0x00, 0x40)
619         }
620     }
621 }
622 
623 // File: @openzeppelin/contracts/utils/Context.sol
624 
625 
626 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
627 
628 pragma solidity ^0.8.0;
629 
630 /**
631  * @dev Provides information about the current execution context, including the
632  * sender of the transaction and its data. While these are generally available
633  * via msg.sender and msg.data, they should not be accessed in such a direct
634  * manner, since when dealing with meta-transactions the account sending and
635  * paying for execution may not be the actual sender (as far as an application
636  * is concerned).
637  *
638  * This contract is only required for intermediate, library-like contracts.
639  */
640 abstract contract Context {
641     function _msgSender() internal view virtual returns (address) {
642         return msg.sender;
643     }
644 
645     function _msgData() internal view virtual returns (bytes calldata) {
646         return msg.data;
647     }
648 }
649 
650 // File: erc721a/contracts/ERC721A.sol
651 
652 
653 // Creator: Chiru Labs
654 
655 pragma solidity ^0.8.4;
656 
657 
658 
659 
660 
661 
662 
663 
664 error ApprovalCallerNotOwnerNorApproved();
665 error ApprovalQueryForNonexistentToken();
666 error ApproveToCaller();
667 error ApprovalToCurrentOwner();
668 error BalanceQueryForZeroAddress();
669 error MintToZeroAddress();
670 error MintZeroQuantity();
671 error OwnerQueryForNonexistentToken();
672 error TransferCallerNotOwnerNorApproved();
673 error TransferFromIncorrectOwner();
674 error TransferToNonERC721ReceiverImplementer();
675 error TransferToZeroAddress();
676 error URIQueryForNonexistentToken();
677 
678 /**
679  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
680  * the Metadata extension. Built to optimize for lower gas during batch mints.
681  *
682  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
683  *
684  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
685  *
686  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
687  */
688 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
689     using Address for address;
690     using Strings for uint256;
691 
692     // Compiler will pack this into a single 256bit word.
693     struct TokenOwnership {
694         // The address of the owner.
695         address addr;
696         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
697         uint64 startTimestamp;
698         // Whether the token has been burned.
699         bool burned;
700     }
701 
702     // Compiler will pack this into a single 256bit word.
703     struct AddressData {
704         // Realistically, 2**64-1 is more than enough.
705         uint64 balance;
706         // Keeps track of mint count with minimal overhead for tokenomics.
707         uint64 numberMinted;
708         // Keeps track of burn count with minimal overhead for tokenomics.
709         uint64 numberBurned;
710         // For miscellaneous variable(s) pertaining to the address
711         // (e.g. number of whitelist mint slots used).
712         // If there are multiple variables, please pack them into a uint64.
713         uint64 aux;
714     }
715 
716     // The tokenId of the next token to be minted.
717     uint256 internal _currentIndex;
718 
719     // The number of tokens burned.
720     uint256 internal _burnCounter;
721 
722     // Token name
723     string private _name;
724 
725     // Token symbol
726     string private _symbol;
727 
728     // Mapping from token ID to ownership details
729     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
730     mapping(uint256 => TokenOwnership) internal _ownerships;
731 
732     // Mapping owner address to address data
733     mapping(address => AddressData) private _addressData;
734 
735     // Mapping from token ID to approved address
736     mapping(uint256 => address) private _tokenApprovals;
737 
738     // Mapping from owner to operator approvals
739     mapping(address => mapping(address => bool)) private _operatorApprovals;
740 
741     constructor(string memory name_, string memory symbol_) {
742         _name = name_;
743         _symbol = symbol_;
744         _currentIndex = _startTokenId();
745     }
746 
747     /**
748      * To change the starting tokenId, please override this function.
749      */
750     function _startTokenId() internal view virtual returns (uint256) {
751         return 0;
752     }
753 
754     /**
755      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
756      */
757     function totalSupply() public view returns (uint256) {
758         // Counter underflow is impossible as _burnCounter cannot be incremented
759         // more than _currentIndex - _startTokenId() times
760         unchecked {
761             return _currentIndex - _burnCounter - _startTokenId();
762         }
763     }
764 
765     /**
766      * Returns the total amount of tokens minted in the contract.
767      */
768     function _totalMinted() internal view returns (uint256) {
769         // Counter underflow is impossible as _currentIndex does not decrement,
770         // and it is initialized to _startTokenId()
771         unchecked {
772             return _currentIndex - _startTokenId();
773         }
774     }
775 
776     /**
777      * @dev See {IERC165-supportsInterface}.
778      */
779     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
780         return
781             interfaceId == type(IERC721).interfaceId ||
782             interfaceId == type(IERC721Metadata).interfaceId ||
783             super.supportsInterface(interfaceId);
784     }
785 
786     /**
787      * @dev See {IERC721-balanceOf}.
788      */
789     function balanceOf(address owner) public view override returns (uint256) {
790         if (owner == address(0)) revert BalanceQueryForZeroAddress();
791         return uint256(_addressData[owner].balance);
792     }
793 
794     /**
795      * Returns the number of tokens minted by `owner`.
796      */
797     function _numberMinted(address owner) internal view returns (uint256) {
798         return uint256(_addressData[owner].numberMinted);
799     }
800 
801     /**
802      * Returns the number of tokens burned by or on behalf of `owner`.
803      */
804     function _numberBurned(address owner) internal view returns (uint256) {
805         return uint256(_addressData[owner].numberBurned);
806     }
807 
808     /**
809      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
810      */
811     function _getAux(address owner) internal view returns (uint64) {
812         return _addressData[owner].aux;
813     }
814 
815     /**
816      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
817      * If there are multiple variables, please pack them into a uint64.
818      */
819     function _setAux(address owner, uint64 aux) internal {
820         _addressData[owner].aux = aux;
821     }
822 
823     /**
824      * Gas spent here starts off proportional to the maximum mint batch size.
825      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
826      */
827     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
828         uint256 curr = tokenId;
829 
830         unchecked {
831             if (_startTokenId() <= curr && curr < _currentIndex) {
832                 TokenOwnership memory ownership = _ownerships[curr];
833                 if (!ownership.burned) {
834                     if (ownership.addr != address(0)) {
835                         return ownership;
836                     }
837                     // Invariant:
838                     // There will always be an ownership that has an address and is not burned
839                     // before an ownership that does not have an address and is not burned.
840                     // Hence, curr will not underflow.
841                     while (true) {
842                         curr--;
843                         ownership = _ownerships[curr];
844                         if (ownership.addr != address(0)) {
845                             return ownership;
846                         }
847                     }
848                 }
849             }
850         }
851         revert OwnerQueryForNonexistentToken();
852     }
853 
854     /**
855      * @dev See {IERC721-ownerOf}.
856      */
857     function ownerOf(uint256 tokenId) public view override returns (address) {
858         return _ownershipOf(tokenId).addr;
859     }
860 
861     /**
862      * @dev See {IERC721Metadata-name}.
863      */
864     function name() public view virtual override returns (string memory) {
865         return _name;
866     }
867 
868     /**
869      * @dev See {IERC721Metadata-symbol}.
870      */
871     function symbol() public view virtual override returns (string memory) {
872         return _symbol;
873     }
874 
875     /**
876      * @dev See {IERC721Metadata-tokenURI}.
877      */
878     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
879         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
880 
881         string memory baseURI = _baseURI();
882         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
883     }
884 
885     /**
886      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
887      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
888      * by default, can be overriden in child contracts.
889      */
890     function _baseURI() internal view virtual returns (string memory) {
891         return '';
892     }
893 
894     /**
895      * @dev See {IERC721-approve}.
896      */
897     function approve(address to, uint256 tokenId) public override {
898         address owner = ERC721A.ownerOf(tokenId);
899         if (to == owner) revert ApprovalToCurrentOwner();
900 
901         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
902             revert ApprovalCallerNotOwnerNorApproved();
903         }
904 
905         _approve(to, tokenId, owner);
906     }
907 
908     /**
909      * @dev See {IERC721-getApproved}.
910      */
911     function getApproved(uint256 tokenId) public view override returns (address) {
912         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
913 
914         return _tokenApprovals[tokenId];
915     }
916 
917     /**
918      * @dev See {IERC721-setApprovalForAll}.
919      */
920     function setApprovalForAll(address operator, bool approved) public virtual override {
921         if (operator == _msgSender()) revert ApproveToCaller();
922 
923         _operatorApprovals[_msgSender()][operator] = approved;
924         emit ApprovalForAll(_msgSender(), operator, approved);
925     }
926 
927     /**
928      * @dev See {IERC721-isApprovedForAll}.
929      */
930     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
931         return _operatorApprovals[owner][operator];
932     }
933 
934     /**
935      * @dev See {IERC721-transferFrom}.
936      */
937     function transferFrom(
938         address from,
939         address to,
940         uint256 tokenId
941     ) public virtual override {
942         _transfer(from, to, tokenId);
943     }
944 
945     /**
946      * @dev See {IERC721-safeTransferFrom}.
947      */
948     function safeTransferFrom(
949         address from,
950         address to,
951         uint256 tokenId
952     ) public virtual override {
953         safeTransferFrom(from, to, tokenId, '');
954     }
955 
956     /**
957      * @dev See {IERC721-safeTransferFrom}.
958      */
959     function safeTransferFrom(
960         address from,
961         address to,
962         uint256 tokenId,
963         bytes memory _data
964     ) public virtual override {
965         _transfer(from, to, tokenId);
966         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
967             revert TransferToNonERC721ReceiverImplementer();
968         }
969     }
970 
971     /**
972      * @dev Returns whether `tokenId` exists.
973      *
974      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
975      *
976      * Tokens start existing when they are minted (`_mint`),
977      */
978     function _exists(uint256 tokenId) internal view returns (bool) {
979         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
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
1278 // File: @openzeppelin/contracts/access/Ownable.sol
1279 
1280 
1281 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1282 
1283 pragma solidity ^0.8.0;
1284 
1285 
1286 /**
1287  * @dev Contract module which provides a basic access control mechanism, where
1288  * there is an account (an owner) that can be granted exclusive access to
1289  * specific functions.
1290  *
1291  * By default, the owner account will be the one that deploys the contract. This
1292  * can later be changed with {transferOwnership}.
1293  *
1294  * This module is used through inheritance. It will make available the modifier
1295  * `onlyOwner`, which can be applied to your functions to restrict their use to
1296  * the owner.
1297  */
1298 abstract contract Ownable is Context {
1299     address private _owner;
1300 
1301     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1302 
1303     /**
1304      * @dev Initializes the contract setting the deployer as the initial owner.
1305      */
1306     constructor() {
1307         _transferOwnership(_msgSender());
1308     }
1309 
1310     /**
1311      * @dev Returns the address of the current owner.
1312      */
1313     function owner() public view virtual returns (address) {
1314         return _owner;
1315     }
1316 
1317     /**
1318      * @dev Throws if called by any account other than the owner.
1319      */
1320     modifier onlyOwner() {
1321         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1322         _;
1323     }
1324 
1325     /**
1326      * @dev Leaves the contract without owner. It will not be possible to call
1327      * `onlyOwner` functions anymore. Can only be called by the current owner.
1328      *
1329      * NOTE: Renouncing ownership will leave the contract without an owner,
1330      * thereby removing any functionality that is only available to the owner.
1331      */
1332     function renounceOwnership() public virtual onlyOwner {
1333         _transferOwnership(address(0));
1334     }
1335 
1336     /**
1337      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1338      * Can only be called by the current owner.
1339      */
1340     function transferOwnership(address newOwner) public virtual onlyOwner {
1341         require(newOwner != address(0), "Ownable: new owner is the zero address");
1342         _transferOwnership(newOwner);
1343     }
1344 
1345     /**
1346      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1347      * Internal function without access restriction.
1348      */
1349     function _transferOwnership(address newOwner) internal virtual {
1350         address oldOwner = _owner;
1351         _owner = newOwner;
1352         emit OwnershipTransferred(oldOwner, newOwner);
1353     }
1354 }
1355 
1356 // File: contracts/Presale_Reveal.sol
1357 
1358 
1359 
1360 pragma solidity >=0.8.0 <0.9.0;
1361 
1362 
1363 contract CrittersTown is ERC721A, Ownable { 
1364 
1365   using Strings for uint256; 
1366 
1367   bytes32 public merkleRoot = 0xdad4fa560b70dd2227de75a38426a4b27e07d3d666d3941a61f65e3022d62db8; // Add MerkleRoot
1368   
1369   string public uriPrefix = "ipfs://QmfRdPJMkf9jTTwWfVPNQzgQo8uj8RhtHjmMwtdjx2XGJk/"; // Add ipfs://__CID__/ 
1370   string public uriSuffix = ".json"; 
1371   string public hiddenMetadataUri;
1372   
1373   uint256 public cost = 0.005 ether;    
1374 
1375   uint256 public publicTotalSupply = 0; 
1376   uint256 public reservedTotalSupply = 0; 
1377   uint256 public publicMaxSupply = 7227; 
1378   uint256 public reservedMaxSupply = 550; 
1379   uint256 public maxSupply = 7777; 
1380 
1381   uint256 public freeMaxMintAmount = 1; 
1382   uint256 public maxMintAmountPerTx = 10; 
1383   uint256 public TOTAL_MAX_MINT_AMOUNT = 15; 
1384 
1385   bool public paused = true;
1386   bool public publicSale = false;
1387   bool public revealed = true;
1388 
1389   mapping(address => uint256) public addressMintedBalance; 
1390   mapping(address => bool) whitelistedAddresses; 
1391 
1392   constructor() ERC721A("CTNFT", "CrittersTown") { // Replace NAME and SYMBOL 
1393         setHiddenMetadataUri("ipfs://__CID__/hidden.json"); // Replace CID
1394         ownerMint(50); // Replace uint - Automatic Free Mint for the owner and team 
1395     } 
1396 
1397   // MODIFIERS 
1398    modifier mintCompliance(uint256 _mintAmount) {
1399         if (msg.sender != owner()) {
1400     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
1401         }
1402     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1403     _;
1404   }
1405 
1406   modifier mintPriceCompliance(uint256 _mintAmount) {
1407     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1408    if (ownerMintedCount >= freeMaxMintAmount) {
1409         require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1410    }
1411         _;
1412   }
1413 
1414    // MERKLE TREE
1415     function _verify(bytes32 leaf, bytes32[] memory proof)
1416         internal
1417         view
1418         returns (bool)
1419     {
1420         return MerkleProof.verify(proof, merkleRoot, leaf);
1421     }
1422 
1423     function _leaf(address account)
1424         internal
1425         pure
1426         returns (bytes32)
1427     {
1428         return keccak256(abi.encodePacked(account));
1429     }
1430 
1431   // MINT 
1432    function mint(uint256 _mintAmount, bytes32[] calldata proof) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1433     require(!paused, 'The contract is paused!'); 
1434     require(publicSale, "Not open to public yet!");
1435     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1436     bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1437 
1438     if (!MerkleProof.verify(proof, merkleRoot, leaf) ||  (MerkleProof.verify(proof, merkleRoot, leaf) && ownerMintedCount >= freeMaxMintAmount)) {
1439         require(publicTotalSupply + _mintAmount <= publicMaxSupply, 'Public max supply exceeded!');
1440         if (ownerMintedCount < freeMaxMintAmount) {  
1441             require(ownerMintedCount + _mintAmount <= freeMaxMintAmount, "Exceeded Free Mint Limit");
1442         } else if (ownerMintedCount >= freeMaxMintAmount) { 
1443             require(ownerMintedCount + _mintAmount <= TOTAL_MAX_MINT_AMOUNT, "Exceeded Mint Limit");
1444         }
1445 
1446     _safeMint(_msgSender(), _mintAmount);
1447     for (uint256 i = 1; i <=_mintAmount; i++){
1448         addressMintedBalance[msg.sender]++;
1449         publicTotalSupply++;
1450     }
1451    } 
1452    
1453    else if (MerkleProof.verify(proof, merkleRoot, leaf)) {
1454        require(reservedTotalSupply + _mintAmount <= reservedMaxSupply, 'Reserved max supply exceeded!');
1455        if (ownerMintedCount < freeMaxMintAmount) {  
1456             require(ownerMintedCount + _mintAmount <= freeMaxMintAmount, "Exceeded Free Mint Limit");
1457         } else if (ownerMintedCount >= freeMaxMintAmount) { 
1458             require(ownerMintedCount + _mintAmount <= TOTAL_MAX_MINT_AMOUNT, "Exceeded Mint Limit");
1459         }
1460 
1461     _safeMint(_msgSender(), _mintAmount);
1462     for (uint256 i = 1; i <=_mintAmount; i++){
1463         addressMintedBalance[msg.sender]++;
1464         reservedTotalSupply++;
1465    }
1466   }
1467 }
1468 
1469   function ownerMint(uint256 _mintAmount) public payable onlyOwner {
1470      require(_mintAmount > 0, 'Invalid mint amount!');
1471      require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1472     _safeMint(_msgSender(), _mintAmount);
1473   }
1474 
1475 function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1476     _safeMint(_receiver, _mintAmount);
1477   }
1478 
1479   function isWhiteListed(address account, bytes32[] calldata proof) internal view returns(bool) {
1480         return _verify(_leaf(account), proof);
1481     }
1482   
1483   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1484     uint256 ownerTokenCount = balanceOf(_owner);
1485     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1486     uint256 currentTokenId = _startTokenId();
1487     uint256 ownedTokenIndex = 0;
1488     address latestOwnerAddress;
1489 
1490     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1491       TokenOwnership memory ownership = _ownerships[currentTokenId];
1492 
1493       if (!ownership.burned && ownership.addr != address(0)) {
1494         latestOwnerAddress = ownership.addr;
1495       }
1496 
1497       if (latestOwnerAddress == _owner) {
1498         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1499 
1500         ownedTokenIndex++;
1501       }
1502 
1503       currentTokenId++;
1504     }
1505 
1506     return ownedTokenIds;
1507   }
1508 
1509   function _startTokenId() internal view virtual override returns (uint256) {
1510     return 1;
1511   }
1512 
1513   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1514     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1515 
1516     if (revealed == false) {
1517       return hiddenMetadataUri;
1518     }
1519 
1520     string memory currentBaseURI = _baseURI();
1521     return bytes(currentBaseURI).length > 0
1522         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1523         : '';
1524   }
1525 
1526   function setRevealed(bool _state) public onlyOwner {
1527     revealed = _state;
1528   }
1529 
1530   function setCost(uint256 _cost) public onlyOwner {
1531     cost = _cost;
1532   }
1533 
1534   function setTotalMaxMintAmount(uint _amount) public onlyOwner {
1535       require(_amount <= maxSupply, "Exceed total amount");
1536       TOTAL_MAX_MINT_AMOUNT = _amount;
1537   }
1538 
1539   function setFreeMaxMintAmount(uint256 _freeMaxMintAmount) public onlyOwner {
1540     freeMaxMintAmount = _freeMaxMintAmount;
1541   }
1542 
1543   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1544     maxMintAmountPerTx = _maxMintAmountPerTx;
1545   }
1546 
1547   function setReservedMaxSupply(uint256 _reservedMaxSupply) public onlyOwner {
1548     reservedMaxSupply = _reservedMaxSupply;
1549   }
1550 
1551   function setPublicMaxSupply(uint256 _publicMaxSupply) public onlyOwner {
1552     publicMaxSupply = _publicMaxSupply;
1553   }
1554 
1555   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1556     hiddenMetadataUri = _hiddenMetadataUri;
1557   }
1558 
1559   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1560     uriPrefix = _uriPrefix;
1561   }
1562 
1563   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1564     uriSuffix = _uriSuffix;
1565   }
1566 
1567   function setPaused(bool _state) public onlyOwner {
1568     paused = _state;
1569   }
1570 
1571   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1572     merkleRoot = _merkleRoot;
1573   }
1574 
1575   function setPublicSale(bool _state) public onlyOwner {
1576     publicSale = _state;
1577   }
1578 
1579   // WITHDRAW
1580     function withdraw() public payable onlyOwner {
1581   
1582     (bool os, ) = payable(owner()).call{value: address(this).balance}(""); 
1583     require(os);
1584    
1585   }
1586 
1587   function addWhitelistUsers(address[] calldata _users) public onlyOwner {
1588       for (uint i=0; i < _users.length; i++) {
1589         whitelistedAddresses[_users[i]] = true;
1590     }
1591   }
1592 
1593   function _baseURI() internal view virtual override returns (string memory) {
1594     return uriPrefix;
1595   }
1596 }