1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.13;
3 
4 /// @title Citizens Of Humania
5 /// @author Andre Costa @ Terratecc
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
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
49                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
50             } else {
51                 // Hash(current element of the proof + current computed hash)
52                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
53             }
54         }
55         return computedHash;
56     }
57 }
58 
59 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
60 
61 pragma solidity ^0.8.0;
62 
63 /**
64  * @dev Interface of the ERC165 standard, as defined in the
65  * https://eips.ethereum.org/EIPS/eip-165[EIP].
66  *
67  * Implementers can declare support of contract interfaces, which can then be
68  * queried by others ({ERC165Checker}).
69  *
70  * For an implementation, see {ERC165}.
71  */
72 interface IERC165 {
73     /**
74      * @dev Returns true if this contract implements the interface defined by
75      * `interfaceId`. See the corresponding
76      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
77      * to learn more about how these ids are created.
78      *
79      * This function call must use less than 30 000 gas.
80      */
81     function supportsInterface(bytes4 interfaceId) external view returns (bool);
82 }
83 
84 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
85 
86 pragma solidity ^0.8.0;
87 
88 /**
89  * @dev Required interface of an ERC721 compliant contract.
90  */
91 interface IERC721 is IERC165 {
92     /**
93      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
96 
97     /**
98      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
99      */
100     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
101 
102     /**
103      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
104      */
105     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
106 
107     /**
108      * @dev Returns the number of tokens in ``owner``'s account.
109      */
110     function balanceOf(address owner) external view returns (uint256 balance);
111 
112     /**
113      * @dev Returns the owner of the `tokenId` token.
114      *
115      * Requirements:
116      *
117      * - `tokenId` must exist.
118      */
119     function ownerOf(uint256 tokenId) external view returns (address owner);
120 
121     /**
122      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
123      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
124      *
125      * Requirements:
126      *
127      * - `from` cannot be the zero address.
128      * - `to` cannot be the zero address.
129      * - `tokenId` token must exist and be owned by `from`.
130      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
131      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
132      *
133      * Emits a {Transfer} event.
134      */
135     function safeTransferFrom(
136         address from,
137         address to,
138         uint256 tokenId
139     ) external;
140 
141     /**
142      * @dev Transfers `tokenId` token from `from` to `to`.
143      *
144      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
145      *
146      * Requirements:
147      *
148      * - `from` cannot be the zero address.
149      * - `to` cannot be the zero address.
150      * - `tokenId` token must be owned by `from`.
151      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
152      *
153      * Emits a {Transfer} event.
154      */
155     function transferFrom(
156         address from,
157         address to,
158         uint256 tokenId
159     ) external;
160 
161     /**
162      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
163      * The approval is cleared when the token is transferred.
164      *
165      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
166      *
167      * Requirements:
168      *
169      * - The caller must own the token or be an approved operator.
170      * - `tokenId` must exist.
171      *
172      * Emits an {Approval} event.
173      */
174     function approve(address to, uint256 tokenId) external;
175 
176     /**
177      * @dev Returns the account approved for `tokenId` token.
178      *
179      * Requirements:
180      *
181      * - `tokenId` must exist.
182      */
183     function getApproved(uint256 tokenId) external view returns (address operator);
184 
185     /**
186      * @dev Approve or remove `operator` as an operator for the caller.
187      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
188      *
189      * Requirements:
190      *
191      * - The `operator` cannot be the caller.
192      *
193      * Emits an {ApprovalForAll} event.
194      */
195     function setApprovalForAll(address operator, bool _approved) external;
196 
197     /**
198      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
199      *
200      * See {setApprovalForAll}
201      */
202     function isApprovedForAll(address owner, address operator) external view returns (bool);
203 
204     /**
205      * @dev Safely transfers `tokenId` token from `from` to `to`.
206      *
207      * Requirements:
208      *
209      * - `from` cannot be the zero address.
210      * - `to` cannot be the zero address.
211      * - `tokenId` token must exist and be owned by `from`.
212      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
213      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
214      *
215      * Emits a {Transfer} event.
216      */
217     function safeTransferFrom(
218         address from,
219         address to,
220         uint256 tokenId,
221         bytes calldata data
222     ) external;
223 }
224 
225 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
226 
227 pragma solidity ^0.8.0;
228 
229 /**
230  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
231  * @dev See https://eips.ethereum.org/EIPS/eip-721
232  */
233 interface IERC721Enumerable is IERC721 {
234     /**
235      * @dev Returns the total amount of tokens stored by the contract.
236      */
237     function totalSupply() external view returns (uint256);
238 
239     /**
240      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
241      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
242      */
243     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
244 
245     /**
246      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
247      * Use along with {totalSupply} to enumerate all tokens.
248      */
249     function tokenByIndex(uint256 index) external view returns (uint256);
250 }
251 
252 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
253 
254 pragma solidity ^0.8.0;
255 
256 /**
257  * @title ERC721 token receiver interface
258  * @dev Interface for any contract that wants to support safeTransfers
259  * from ERC721 asset contracts.
260  */
261 interface IERC721Receiver {
262     /**
263      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
264      * by `operator` from `from`, this function is called.
265      *
266      * It must return its Solidity selector to confirm the token transfer.
267      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
268      *
269      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
270      */
271     function onERC721Received(
272         address operator,
273         address from,
274         uint256 tokenId,
275         bytes calldata data
276     ) external returns (bytes4);
277 }
278 
279 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
280 
281 pragma solidity ^0.8.0;
282 
283 /**
284  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
285  * @dev See https://eips.ethereum.org/EIPS/eip-721
286  */
287 interface IERC721Metadata is IERC721 {
288     /**
289      * @dev Returns the token collection name.
290      */
291     function name() external view returns (string memory);
292 
293     /**
294      * @dev Returns the token collection symbol.
295      */
296     function symbol() external view returns (string memory);
297 
298     /**
299      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
300      */
301     function tokenURI(uint256 tokenId) external view returns (string memory);
302 }
303 
304 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
305 
306 pragma solidity ^0.8.0;
307 
308 /**
309  * @dev Collection of functions related to the address type
310  */
311 library Address {
312     /**
313      * @dev Returns true if `account` is a contract.
314      *
315      * [IMPORTANT]
316      * ====
317      * It is unsafe to assume that an address for which this function returns
318      * false is an externally-owned account (EOA) and not a contract.
319      *
320      * Among others, `isContract` will return false for the following
321      * types of addresses:
322      *
323      *  - an externally-owned account
324      *  - a contract in construction
325      *  - an address where a contract will be created
326      *  - an address where a contract lived, but was destroyed
327      * ====
328      */
329     function isContract(address account) internal view returns (bool) {
330         // This method relies on extcodesize, which returns 0 for contracts in
331         // construction, since the code is only stored at the end of the
332         // constructor execution.
333 
334         uint256 size;
335         assembly {
336             size := extcodesize(account)
337         }
338         return size > 0;
339     }
340 
341     /**
342      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
343      * `recipient`, forwarding all available gas and reverting on errors.
344      *
345      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
346      * of certain opcodes, possibly making contracts go over the 2300 gas limit
347      * imposed by `transfer`, making them unable to receive funds via
348      * `transfer`. {sendValue} removes this limitation.
349      *
350      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
351      *
352      * IMPORTANT: because control is transferred to `recipient`, care must be
353      * taken to not create reentrancy vulnerabilities. Consider using
354      * {ReentrancyGuard} or the
355      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
356      */
357     function sendValue(address payable recipient, uint256 amount) internal {
358         require(address(this).balance >= amount, "Address: insufficient balance");
359 
360         (bool success, ) = recipient.call{value: amount}("");
361         require(success, "Address: unable to send value, recipient may have reverted");
362     }
363 
364     /**
365      * @dev Performs a Solidity function call using a low level `call`. A
366      * plain `call` is an unsafe replacement for a function call: use this
367      * function instead.
368      *
369      * If `target` reverts with a revert reason, it is bubbled up by this
370      * function (like regular Solidity function calls).
371      *
372      * Returns the raw returned data. To convert to the expected return value,
373      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
374      *
375      * Requirements:
376      *
377      * - `target` must be a contract.
378      * - calling `target` with `data` must not revert.
379      *
380      * _Available since v3.1._
381      */
382     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
383         return functionCall(target, data, "Address: low-level call failed");
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
388      * `errorMessage` as a fallback revert reason when `target` reverts.
389      *
390      * _Available since v3.1._
391      */
392     function functionCall(
393         address target,
394         bytes memory data,
395         string memory errorMessage
396     ) internal returns (bytes memory) {
397         return functionCallWithValue(target, data, 0, errorMessage);
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
402      * but also transferring `value` wei to `target`.
403      *
404      * Requirements:
405      *
406      * - the calling contract must have an ETH balance of at least `value`.
407      * - the called Solidity function must be `payable`.
408      *
409      * _Available since v3.1._
410      */
411     function functionCallWithValue(
412         address target,
413         bytes memory data,
414         uint256 value
415     ) internal returns (bytes memory) {
416         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
421      * with `errorMessage` as a fallback revert reason when `target` reverts.
422      *
423      * _Available since v3.1._
424      */
425     function functionCallWithValue(
426         address target,
427         bytes memory data,
428         uint256 value,
429         string memory errorMessage
430     ) internal returns (bytes memory) {
431         require(address(this).balance >= value, "Address: insufficient balance for call");
432         require(isContract(target), "Address: call to non-contract");
433 
434         (bool success, bytes memory returndata) = target.call{value: value}(data);
435         return verifyCallResult(success, returndata, errorMessage);
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
440      * but performing a static call.
441      *
442      * _Available since v3.3._
443      */
444     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
445         return functionStaticCall(target, data, "Address: low-level static call failed");
446     }
447 
448     /**
449      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
450      * but performing a static call.
451      *
452      * _Available since v3.3._
453      */
454     function functionStaticCall(
455         address target,
456         bytes memory data,
457         string memory errorMessage
458     ) internal view returns (bytes memory) {
459         require(isContract(target), "Address: static call to non-contract");
460 
461         (bool success, bytes memory returndata) = target.staticcall(data);
462         return verifyCallResult(success, returndata, errorMessage);
463     }
464 
465     /**
466      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
467      * but performing a delegate call.
468      *
469      * _Available since v3.4._
470      */
471     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
472         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
477      * but performing a delegate call.
478      *
479      * _Available since v3.4._
480      */
481     function functionDelegateCall(
482         address target,
483         bytes memory data,
484         string memory errorMessage
485     ) internal returns (bytes memory) {
486         require(isContract(target), "Address: delegate call to non-contract");
487 
488         (bool success, bytes memory returndata) = target.delegatecall(data);
489         return verifyCallResult(success, returndata, errorMessage);
490     }
491 
492     /**
493      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
494      * revert reason using the provided one.
495      *
496      * _Available since v4.3._
497      */
498     function verifyCallResult(
499         bool success,
500         bytes memory returndata,
501         string memory errorMessage
502     ) internal pure returns (bytes memory) {
503         if (success) {
504             return returndata;
505         } else {
506             // Look for revert reason and bubble it up if present
507             if (returndata.length > 0) {
508                 // The easiest way to bubble the revert reason is using memory via assembly
509 
510                 assembly {
511                     let returndata_size := mload(returndata)
512                     revert(add(32, returndata), returndata_size)
513                 }
514             } else {
515                 revert(errorMessage);
516             }
517         }
518     }
519 }
520 
521 // File: @openzeppelin/contracts/utils/Context.sol
522 
523 
524 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
525 
526 pragma solidity ^0.8.0;
527 
528 /**
529  * @dev Provides information about the current execution context, including the
530  * sender of the transaction and its data. While these are generally available
531  * via msg.sender and msg.data, they should not be accessed in such a direct
532  * manner, since when dealing with meta-transactions the account sending and
533  * paying for execution may not be the actual sender (as far as an application
534  * is concerned).
535  *
536  * This contract is only required for intermediate, library-like contracts.
537  */
538 abstract contract Context {
539     function _msgSender() internal view virtual returns (address) {
540         return msg.sender;
541     }
542 
543     function _msgData() internal view virtual returns (bytes calldata) {
544         return msg.data;
545     }
546 }
547 
548 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
549 
550 pragma solidity ^0.8.0;
551 
552 /**
553  * @dev String operations.
554  */
555 library Strings {
556     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
557 
558     /**
559      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
560      */
561     function toString(uint256 value) internal pure returns (string memory) {
562         // Inspired by OraclizeAPI's implementation - MIT licence
563         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
564 
565         if (value == 0) {
566             return "0";
567         }
568         uint256 temp = value;
569         uint256 digits;
570         while (temp != 0) {
571             digits++;
572             temp /= 10;
573         }
574         bytes memory buffer = new bytes(digits);
575         while (value != 0) {
576             digits -= 1;
577             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
578             value /= 10;
579         }
580         return string(buffer);
581     }
582 
583     /**
584      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
585      */
586     function toHexString(uint256 value) internal pure returns (string memory) {
587         if (value == 0) {
588             return "0x00";
589         }
590         uint256 temp = value;
591         uint256 length = 0;
592         while (temp != 0) {
593             length++;
594             temp >>= 8;
595         }
596         return toHexString(value, length);
597     }
598 
599     /**
600      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
601      */
602     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
603         bytes memory buffer = new bytes(2 * length + 2);
604         buffer[0] = "0";
605         buffer[1] = "x";
606         for (uint256 i = 2 * length + 1; i > 1; --i) {
607             buffer[i] = _HEX_SYMBOLS[value & 0xf];
608             value >>= 4;
609         }
610         require(value == 0, "Strings: hex length insufficient");
611         return string(buffer);
612     }
613 }
614 
615 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
616 
617 pragma solidity ^0.8.0;
618 
619 /**
620  * @dev Implementation of the {IERC165} interface.
621  *
622  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
623  * for the additional interface id that will be supported. For example:
624  *
625  * ```solidity
626  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
627  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
628  * }
629  * ```
630  *
631  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
632  */
633 abstract contract ERC165 is IERC165 {
634     /**
635      * @dev See {IERC165-supportsInterface}.
636      */
637     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
638         return interfaceId == type(IERC165).interfaceId;
639     }
640 }
641 
642 pragma solidity ^0.8.4;
643 
644 error ApprovalCallerNotOwnerNorApproved();
645 error ApprovalQueryForNonexistentToken();
646 error ApproveToCaller();
647 error ApprovalToCurrentOwner();
648 error BalanceQueryForZeroAddress();
649 error MintToZeroAddress();
650 error MintZeroQuantity();
651 error OwnerQueryForNonexistentToken();
652 error TransferCallerNotOwnerNorApproved();
653 error TransferFromIncorrectOwner();
654 error TransferToNonERC721ReceiverImplementer();
655 error TransferToZeroAddress();
656 error URIQueryForNonexistentToken();
657 
658 /**
659  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
660  * the Metadata extension. Built to optimize for lower gas during batch mints.
661  *
662  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
663  *
664  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
665  *
666  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
667  */
668 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
669     using Address for address;
670     using Strings for uint256;
671 
672     // Compiler will pack this into a single 256bit word.
673     struct TokenOwnership {
674         // The address of the owner.
675         address addr;
676         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
677         uint64 startTimestamp;
678         // Whether the token has been burned.
679         bool burned;
680     }
681 
682     // Compiler will pack this into a single 256bit word.
683     struct AddressData {
684         // Realistically, 2**64-1 is more than enough.
685         uint64 balance;
686         // Keeps track of mint count with minimal overhead for tokenomics.
687         uint64 numberMinted;
688         // Keeps track of burn count with minimal overhead for tokenomics.
689         uint64 numberBurned;
690         // For miscellaneous variable(s) pertaining to the address
691         // (e.g. number of whitelist mint slots used).
692         // If there are multiple variables, please pack them into a uint64.
693         uint64 aux;
694     }
695 
696     // The tokenId of the next token to be minted.
697     uint256 internal _currentIndex;
698 
699     // The number of tokens burned.
700     uint256 internal _burnCounter;
701 
702     // Token name
703     string private _name;
704 
705     // Token symbol
706     string private _symbol;
707 
708     // Mapping from token ID to ownership details
709     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
710     mapping(uint256 => TokenOwnership) internal _ownerships;
711 
712     // Mapping owner address to address data
713     mapping(address => AddressData) private _addressData;
714 
715     // Mapping from token ID to approved address
716     mapping(uint256 => address) private _tokenApprovals;
717 
718     // Mapping from owner to operator approvals
719     mapping(address => mapping(address => bool)) private _operatorApprovals;
720 
721     constructor(string memory name_, string memory symbol_) {
722         _name = name_;
723         _symbol = symbol_;
724         _currentIndex = _startTokenId();
725     }
726 
727     /**
728      * To change the starting tokenId, please override this function.
729      */
730     function _startTokenId() internal view virtual returns (uint256) {
731         return 0;
732     }
733 
734     /**
735      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
736      */
737     function totalSupply() public view virtual returns (uint256) {
738         // Counter underflow is impossible as _burnCounter cannot be incremented
739         // more than _currentIndex - _startTokenId() times
740         unchecked {
741             return _currentIndex - _burnCounter - _startTokenId();
742         }
743     }
744 
745     /**
746      * Returns the total amount of tokens minted in the contract.
747      */
748     function _totalMinted() internal view returns (uint256) {
749         // Counter underflow is impossible as _currentIndex does not decrement,
750         // and it is initialized to _startTokenId()
751         unchecked {
752             return _currentIndex - _startTokenId();
753         }
754     }
755 
756     /**
757      * @dev See {IERC165-supportsInterface}.
758      */
759     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
760         return
761             interfaceId == type(IERC721).interfaceId ||
762             interfaceId == type(IERC721Metadata).interfaceId ||
763             super.supportsInterface(interfaceId);
764     }
765 
766     /**
767      * @dev See {IERC721-balanceOf}.
768      */
769     function balanceOf(address owner) public view override returns (uint256) {
770         if (owner == address(0)) revert BalanceQueryForZeroAddress();
771         return uint256(_addressData[owner].balance);
772     }
773 
774     /**
775      * Returns the number of tokens minted by `owner`.
776      */
777     function _numberMinted(address owner) internal view returns (uint256) {
778         return uint256(_addressData[owner].numberMinted);
779     }
780 
781     /**
782      * Returns the number of tokens burned by or on behalf of `owner`.
783      */
784     function _numberBurned(address owner) internal view returns (uint256) {
785         return uint256(_addressData[owner].numberBurned);
786     }
787 
788     /**
789      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
790      */
791     function _getAux(address owner) internal view returns (uint64) {
792         return _addressData[owner].aux;
793     }
794 
795     /**
796      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
797      * If there are multiple variables, please pack them into a uint64.
798      */
799     function _setAux(address owner, uint64 aux) internal {
800         _addressData[owner].aux = aux;
801     }
802 
803     /**
804      * Gas spent here starts off proportional to the maximum mint batch size.
805      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
806      */
807     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
808         uint256 curr = tokenId;
809 
810         unchecked {
811             if (_startTokenId() <= curr && curr < _currentIndex) {
812                 TokenOwnership memory ownership = _ownerships[curr];
813                 if (!ownership.burned) {
814                     if (ownership.addr != address(0)) {
815                         return ownership;
816                     }
817                     // Invariant:
818                     // There will always be an ownership that has an address and is not burned
819                     // before an ownership that does not have an address and is not burned.
820                     // Hence, curr will not underflow.
821                     while (true) {
822                         curr--;
823                         ownership = _ownerships[curr];
824                         if (ownership.addr != address(0)) {
825                             return ownership;
826                         }
827                     }
828                 }
829             }
830         }
831         revert OwnerQueryForNonexistentToken();
832     }
833 
834     /**
835      * @dev See {IERC721-ownerOf}.
836      */
837     function ownerOf(uint256 tokenId) public view override returns (address) {
838         return _ownershipOf(tokenId).addr;
839     }
840 
841     /**
842      * @dev See {IERC721Metadata-name}.
843      */
844     function name() public view virtual override returns (string memory) {
845         return _name;
846     }
847 
848     /**
849      * @dev See {IERC721Metadata-symbol}.
850      */
851     function symbol() public view virtual override returns (string memory) {
852         return _symbol;
853     }
854 
855     /**
856      * @dev See {IERC721Metadata-tokenURI}.
857      */
858     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
859         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
860 
861         string memory baseURI = _baseURI();
862         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
863     }
864 
865     /**
866      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
867      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
868      * by default, can be overriden in child contracts.
869      */
870     function _baseURI() internal view virtual returns (string memory) {
871         return '';
872     }
873 
874     /**
875      * @dev See {IERC721-approve}.
876      */
877     function approve(address to, uint256 tokenId) public virtual override(IERC721) {
878         address owner = ERC721A.ownerOf(tokenId);
879         if (to == owner) revert ApprovalToCurrentOwner();
880 
881         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
882             revert ApprovalCallerNotOwnerNorApproved();
883         }
884 
885         _approve(to, tokenId, owner);
886     }
887 
888     /**
889      * @dev See {IERC721-getApproved}.
890      */
891     function getApproved(uint256 tokenId) public view override returns (address) {
892         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
893 
894         return _tokenApprovals[tokenId];
895     }
896 
897     /**
898      * @dev See {IERC721-setApprovalForAll}.
899      */
900     function setApprovalForAll(address operator, bool approved) public virtual override {
901         if (operator == _msgSender()) revert ApproveToCaller();
902 
903         _operatorApprovals[_msgSender()][operator] = approved;
904         emit ApprovalForAll(_msgSender(), operator, approved);
905     }
906 
907     /**
908      * @dev See {IERC721-isApprovedForAll}.
909      */
910     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
911         return _operatorApprovals[owner][operator];
912     }
913 
914     /**
915      * @dev See {IERC721-transferFrom}.
916      */
917     function transferFrom(
918         address from,
919         address to,
920         uint256 tokenId
921     ) public virtual override {
922         _transfer(from, to, tokenId);
923     }
924 
925     /**
926      * @dev See {IERC721-safeTransferFrom}.
927      */
928     function safeTransferFrom(
929         address from,
930         address to,
931         uint256 tokenId
932     ) public virtual override {
933         safeTransferFrom(from, to, tokenId, '');
934     }
935 
936     /**
937      * @dev See {IERC721-safeTransferFrom}.
938      */
939     function safeTransferFrom(
940         address from,
941         address to,
942         uint256 tokenId,
943         bytes memory _data
944     ) public virtual override {
945         _transfer(from, to, tokenId);
946         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
947             revert TransferToNonERC721ReceiverImplementer();
948         }
949     }
950 
951     /**
952      * @dev Returns whether `tokenId` exists.
953      *
954      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
955      *
956      * Tokens start existing when they are minted (`_mint`),
957      */
958     function _exists(uint256 tokenId) internal view returns (bool) {
959         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
960             !_ownerships[tokenId].burned;
961     }
962 
963     function _safeMint(address to, uint256 quantity) internal {
964         _safeMint(to, quantity, '');
965     }
966 
967     /**
968      * @dev Safely mints `quantity` tokens and transfers them to `to`.
969      *
970      * Requirements:
971      *
972      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
973      * - `quantity` must be greater than 0.
974      *
975      * Emits a {Transfer} event.
976      */
977     function _safeMint(
978         address to,
979         uint256 quantity,
980         bytes memory _data
981     ) internal {
982         _mint(to, quantity, _data, true);
983     }
984 
985     /**
986      * @dev Mints `quantity` tokens and transfers them to `to`.
987      *
988      * Requirements:
989      *
990      * - `to` cannot be the zero address.
991      * - `quantity` must be greater than 0.
992      *
993      * Emits a {Transfer} event.
994      */
995     function _mint(
996         address to,
997         uint256 quantity,
998         bytes memory _data,
999         bool safe
1000     ) internal {
1001         uint256 startTokenId = _currentIndex;
1002         if (to == address(0)) revert MintToZeroAddress();
1003         if (quantity == 0) revert MintZeroQuantity();
1004 
1005         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1006 
1007         // Overflows are incredibly unrealistic.
1008         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1009         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1010         unchecked {
1011             _addressData[to].balance += uint64(quantity);
1012             _addressData[to].numberMinted += uint64(quantity);
1013 
1014             _ownerships[startTokenId].addr = to;
1015             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1016 
1017             uint256 updatedIndex = startTokenId;
1018             uint256 end = updatedIndex + quantity;
1019 
1020             if (safe && to.isContract()) {
1021                 do {
1022                     emit Transfer(address(0), to, updatedIndex);
1023                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1024                         revert TransferToNonERC721ReceiverImplementer();
1025                     }
1026                 } while (updatedIndex != end);
1027                 // Reentrancy protection
1028                 if (_currentIndex != startTokenId) revert();
1029             } else {
1030                 do {
1031                     emit Transfer(address(0), to, updatedIndex++);
1032                 } while (updatedIndex != end);
1033             }
1034             _currentIndex = updatedIndex;
1035         }
1036         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1037     }
1038 
1039     /**
1040      * @dev Transfers `tokenId` from `from` to `to`.
1041      *
1042      * Requirements:
1043      *
1044      * - `to` cannot be the zero address.
1045      * - `tokenId` token must be owned by `from`.
1046      *
1047      * Emits a {Transfer} event.
1048      */
1049     function _transfer(
1050         address from,
1051         address to,
1052         uint256 tokenId
1053     ) private {
1054         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1055 
1056         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1057 
1058         bool isApprovedOrOwner = (_msgSender() == from ||
1059             isApprovedForAll(from, _msgSender()) ||
1060             getApproved(tokenId) == _msgSender());
1061 
1062         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1063         if (to == address(0)) revert TransferToZeroAddress();
1064 
1065         _beforeTokenTransfers(from, to, tokenId, 1);
1066 
1067         // Clear approvals from the previous owner
1068         _approve(address(0), tokenId, from);
1069 
1070         // Underflow of the sender's balance is impossible because we check for
1071         // ownership above and the recipient's balance can't realistically overflow.
1072         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1073         unchecked {
1074             _addressData[from].balance -= 1;
1075             _addressData[to].balance += 1;
1076 
1077             TokenOwnership storage currSlot = _ownerships[tokenId];
1078             currSlot.addr = to;
1079             currSlot.startTimestamp = uint64(block.timestamp);
1080 
1081             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1082             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1083             uint256 nextTokenId = tokenId + 1;
1084             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1085             if (nextSlot.addr == address(0)) {
1086                 // This will suffice for checking _exists(nextTokenId),
1087                 // as a burned slot cannot contain the zero address.
1088                 if (nextTokenId != _currentIndex) {
1089                     nextSlot.addr = from;
1090                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1091                 }
1092             }
1093         }
1094 
1095         emit Transfer(from, to, tokenId);
1096         _afterTokenTransfers(from, to, tokenId, 1);
1097     }
1098 
1099     /**
1100      * @dev This is equivalent to _burn(tokenId, false)
1101      */
1102     function _burn(uint256 tokenId) internal virtual {
1103         _burn(tokenId, false);
1104     }
1105 
1106     /**
1107      * @dev Destroys `tokenId`.
1108      * The approval is cleared when the token is burned.
1109      *
1110      * Requirements:
1111      *
1112      * - `tokenId` must exist.
1113      *
1114      * Emits a {Transfer} event.
1115      */
1116     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1117         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1118 
1119         address from = prevOwnership.addr;
1120 
1121         if (approvalCheck) {
1122             bool isApprovedOrOwner = (_msgSender() == from ||
1123                 isApprovedForAll(from, _msgSender()) ||
1124                 getApproved(tokenId) == _msgSender());
1125 
1126             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1127         }
1128 
1129         _beforeTokenTransfers(from, address(0), tokenId, 1);
1130 
1131         // Clear approvals from the previous owner
1132         _approve(address(0), tokenId, from);
1133 
1134         // Underflow of the sender's balance is impossible because we check for
1135         // ownership above and the recipient's balance can't realistically overflow.
1136         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1137         unchecked {
1138             AddressData storage addressData = _addressData[from];
1139             addressData.balance -= 1;
1140             addressData.numberBurned += 1;
1141 
1142             // Keep track of who burned the token, and the timestamp of burning.
1143             TokenOwnership storage currSlot = _ownerships[tokenId];
1144             currSlot.addr = from;
1145             currSlot.startTimestamp = uint64(block.timestamp);
1146             currSlot.burned = true;
1147 
1148             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1149             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1150             uint256 nextTokenId = tokenId + 1;
1151             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1152             if (nextSlot.addr == address(0)) {
1153                 // This will suffice for checking _exists(nextTokenId),
1154                 // as a burned slot cannot contain the zero address.
1155                 if (nextTokenId != _currentIndex) {
1156                     nextSlot.addr = from;
1157                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1158                 }
1159             }
1160         }
1161 
1162         emit Transfer(from, address(0), tokenId);
1163         _afterTokenTransfers(from, address(0), tokenId, 1);
1164 
1165         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1166         unchecked {
1167             _burnCounter++;
1168         }
1169     }
1170 
1171     /**
1172      * @dev Approve `to` to operate on `tokenId`
1173      *
1174      * Emits a {Approval} event.
1175      */
1176     function _approve(
1177         address to,
1178         uint256 tokenId,
1179         address owner
1180     ) private {
1181         _tokenApprovals[tokenId] = to;
1182         emit Approval(owner, to, tokenId);
1183     }
1184 
1185     /**
1186      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1187      *
1188      * @param from address representing the previous owner of the given token ID
1189      * @param to target address that will receive the tokens
1190      * @param tokenId uint256 ID of the token to be transferred
1191      * @param _data bytes optional data to send along with the call
1192      * @return bool whether the call correctly returned the expected magic value
1193      */
1194     function _checkContractOnERC721Received(
1195         address from,
1196         address to,
1197         uint256 tokenId,
1198         bytes memory _data
1199     ) private returns (bool) {
1200         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1201             return retval == IERC721Receiver(to).onERC721Received.selector;
1202         } catch (bytes memory reason) {
1203             if (reason.length == 0) {
1204                 revert TransferToNonERC721ReceiverImplementer();
1205             } else {
1206                 assembly {
1207                     revert(add(32, reason), mload(reason))
1208                 }
1209             }
1210         }
1211     }
1212 
1213     /**
1214      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1215      * And also called before burning one token.
1216      *
1217      * startTokenId - the first token id to be transferred
1218      * quantity - the amount to be transferred
1219      *
1220      * Calling conditions:
1221      *
1222      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1223      * transferred to `to`.
1224      * - When `from` is zero, `tokenId` will be minted for `to`.
1225      * - When `to` is zero, `tokenId` will be burned by `from`.
1226      * - `from` and `to` are never both zero.
1227      */
1228     function _beforeTokenTransfers(
1229         address from,
1230         address to,
1231         uint256 startTokenId,
1232         uint256 quantity
1233     ) internal virtual {}
1234 
1235     /**
1236      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1237      * minting.
1238      * And also called after one token has been burned.
1239      *
1240      * startTokenId - the first token id to be transferred
1241      * quantity - the amount to be transferred
1242      *
1243      * Calling conditions:
1244      *
1245      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1246      * transferred to `to`.
1247      * - When `from` is zero, `tokenId` has been minted for `to`.
1248      * - When `to` is zero, `tokenId` has been burned by `from`.
1249      * - `from` and `to` are never both zero.
1250      */
1251     function _afterTokenTransfers(
1252         address from,
1253         address to,
1254         uint256 startTokenId,
1255         uint256 quantity
1256     ) internal virtual {}
1257 }
1258 
1259 error IndexOutOfBounds();
1260 error QueryForZeroAddress();
1261 
1262 contract ERC721AEnumerable is ERC721A, IERC721Enumerable {
1263     constructor(string memory name_, string memory symbol_) ERC721A(name_, symbol_) {}
1264 
1265     /**
1266      * @dev Returns the total amount of tokens stored by the contract.
1267      * Uses the ERC721A implementation.
1268      */
1269     function totalSupply() public view override(ERC721A, IERC721Enumerable) returns (uint256) {
1270         return ERC721A.totalSupply();
1271     }
1272 
1273     /**
1274      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1275      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1276      * @notice This method is intended for read only purposes.
1277      */
1278     function tokenOfOwnerByIndex(address owner, uint256 index) external view override returns (uint256 tokenId) {
1279         if (owner == address(0)) {
1280             revert QueryForZeroAddress();
1281         }
1282         if (balanceOf(owner) <= index) {
1283             revert IndexOutOfBounds();
1284         }
1285         uint256 upToIndex = 0;
1286         uint256 highestTokenId = _startTokenId() + _totalMinted();
1287         for (uint256 i = _startTokenId(); i < highestTokenId; i++) {
1288             if (_ownerOfWithoutError(i) == owner) {
1289                 if (upToIndex == index) {
1290                     return i;
1291                 }
1292                 upToIndex++;
1293             }
1294         }
1295         // Should never reach this case
1296         revert IndexOutOfBounds();
1297     }
1298 
1299     /**
1300      * A copy of the ERC721A._ownershipOf implementation that returns address(0) when unowned instead of an error.
1301      */
1302     function _ownerOfWithoutError(uint256 tokenId) internal view returns (address) {
1303         uint256 curr = tokenId;
1304 
1305         unchecked {
1306             if (_startTokenId() <= curr && curr < _currentIndex) {
1307                 TokenOwnership memory ownership = _ownerships[curr];
1308                 if (!ownership.burned) {
1309                     if (ownership.addr != address(0)) {
1310                         return ownership.addr;
1311                     }
1312                     // Invariant:
1313                     // There will always be an ownership that has an address and is not burned
1314                     // before an ownership that does not have an address and is not burned.
1315                     // Hence, curr will not underflow.
1316                     while (true) {
1317                         curr--;
1318                         ownership = _ownerships[curr];
1319                         if (ownership.addr != address(0)) {
1320                             return ownership.addr;
1321                         }
1322                     }
1323                 }
1324             }
1325         }
1326         return address(0);
1327     }
1328 
1329     /**
1330      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1331      * Use along with {totalSupply} to enumerate all tokens.
1332      * @notice This method is intended for read only purposes.
1333      */
1334     function tokenByIndex(uint256 index) external view override returns (uint256) {
1335         uint256 highestTokenId = _startTokenId() + _totalMinted();
1336         if (index > highestTokenId) {
1337             revert IndexOutOfBounds();
1338         }
1339         uint256 indexedId = 0;
1340         for (uint256 i = _startTokenId(); i < highestTokenId; i++) {
1341             if (!_ownerships[i].burned) {
1342                 if (indexedId == index) {
1343                     return i;
1344                 }
1345                 indexedId++;
1346             }
1347         }
1348         revert IndexOutOfBounds();
1349     }
1350 
1351     /**
1352      * @dev Returns a list of token IDs owned by `owner`.
1353      * @notice This method is intended for read only purposes.
1354      */
1355     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
1356         if (owner == address(0)) {
1357             revert QueryForZeroAddress();
1358         }
1359         uint256 balance = balanceOf(owner);
1360         uint256[] memory tokens = new uint256[](balance);
1361 
1362         uint256 index = 0;
1363         uint256 highestTokenId = _startTokenId() + _totalMinted();
1364         for (uint256 i = _startTokenId(); i < highestTokenId; i++) {
1365             if (_ownerOfWithoutError(i) == owner) {
1366                 tokens[index] = i;
1367                 index++;
1368                 if (index == balance) {
1369                     break;
1370                 }
1371             }
1372         }
1373         return tokens;
1374     }
1375 }
1376 
1377 pragma solidity >=0.8.4;
1378 
1379 // File: @openzeppelin/contracts/access/Ownable.sol
1380 
1381 
1382 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
1383 
1384 pragma solidity ^0.8.0;
1385 
1386 
1387 /**
1388  * @dev Contract module which provides a basic access control mechanism, where
1389  * there is an account (an owner) that can be granted exclusive access to
1390  * specific functions.
1391  *
1392  * By default, the owner account will be the one that deploys the contract. This
1393  * can later be changed with {transferOwnership}.
1394  *
1395  * This module is used through inheritance. It will make available the modifier
1396  * `onlyOwner`, which can be applied to your functions to restrict their use to
1397  * the owner.
1398  */
1399 abstract contract Ownable is Context {
1400     address private _owner;
1401 
1402     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1403 
1404     /**
1405      * @dev Initializes the contract setting the deployer as the initial owner.
1406      */
1407     constructor() {
1408         _transferOwnership(_msgSender());
1409     }
1410 
1411     /**
1412      * @dev Returns the address of the current owner.
1413      */
1414     function owner() public view virtual returns (address) {
1415         return _owner;
1416     }
1417 
1418     /**
1419      * @dev Throws if called by any account other than the owner.
1420      */
1421     modifier onlyOwner() {
1422         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1423         _;
1424     }
1425 
1426     /**
1427      * @dev Leaves the contract without owner. It will not be possible to call
1428      * `onlyOwner` functions anymore. Can only be called by the current owner.
1429      *
1430      * NOTE: Renouncing ownership will leave the contract without an owner,
1431      * thereby removing any functionality that is only available to the owner.
1432      */
1433     function renounceOwnership() public virtual onlyOwner {
1434         _transferOwnership(address(0));
1435     }
1436 
1437     /**
1438      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1439      * Can only be called by the current owner.
1440      */
1441     function transferOwnership(address newOwner) public virtual onlyOwner {
1442         require(newOwner != address(0), "Ownable: new owner is the zero address");
1443         _transferOwnership(newOwner);
1444     }
1445 
1446     /**
1447      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1448      * Internal function without access restriction.
1449      */
1450     function _transferOwnership(address newOwner) internal virtual {
1451         address oldOwner = _owner;
1452         _owner = newOwner;
1453         emit OwnershipTransferred(oldOwner, newOwner);
1454     }
1455 }
1456 
1457 /**
1458  * @dev Interface for the NFT Royalty Standard
1459  */
1460 interface IERC2981 is IERC165 {
1461     /**
1462      * @dev Called with the sale price to determine how much royalty is owed and to whom.
1463      * @param tokenId - the NFT asset queried for royalty information
1464      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
1465      * @return receiver - address of who should be sent the royalty payment
1466      * @return royaltyAmount - the royalty payment amount for `salePrice`
1467      */
1468     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1469         external
1470         view
1471         returns (address receiver, uint256 royaltyAmount);
1472 }
1473 
1474 /// @dev This is a contract used to add ERC2981 support to ERC721 and 1155
1475 contract ERC2981 is IERC2981 {
1476     struct RoyaltyInfo {
1477         address recipient;
1478         uint24 amount;
1479     }
1480 
1481     RoyaltyInfo private _royalties;
1482 
1483     /// @dev Sets token royalties
1484     /// @param recipient recipient of the royalties
1485     /// @param value percentage (using 2 decimals - 10000 = 100, 0 = 0)
1486     function _setRoyalties(address recipient, uint256 value) internal {
1487         require(value <= 10000, "ERC2981Royalties: Too high");
1488         _royalties = RoyaltyInfo(recipient, uint24(value));
1489     }
1490 
1491     /// @inheritdoc IERC2981
1492     function royaltyInfo(uint256, uint256 value)
1493         external
1494         view
1495         override
1496         returns (address receiver, uint256 royaltyAmount)
1497     {
1498         RoyaltyInfo memory royalties = _royalties;
1499         receiver = royalties.recipient;
1500         royaltyAmount = (value * royalties.amount) / 10000;
1501     }
1502 
1503     /// @inheritdoc IERC165
1504     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1505         return interfaceId == type(IERC2981).interfaceId || interfaceId == type(IERC165).interfaceId;
1506     }
1507 }
1508 
1509 contract Payable is Ownable, ERC2981 {
1510 
1511     mapping (address => uint256) public permittedWithdrawals;
1512 
1513     constructor() {
1514         // 5% royalties
1515         _setRoyalties(owner(), 500);
1516     }
1517 
1518     //
1519     // ERC2981
1520     //
1521 
1522     /**
1523      * Set the royalties information.
1524      * @param recipient recipient of the royalties.
1525      * @param value percentage (using 2 decimals - 10000 = 100, 0 = 0).
1526      */
1527     function setRoyalties(address recipient, uint256 value) external onlyOwner {
1528         require(recipient != address(0), "zero address");
1529         _setRoyalties(recipient, value);
1530     }
1531 
1532     //
1533     // Withdraw
1534     //
1535 
1536     /**
1537      * Allow a certain address to withdraw funds
1538      * @param account The account to withdraw to.
1539      * @param amount The amount to withdraw.
1540      */
1541     function setPermittedWithdrawal(address account, uint256 amount) external onlyOwner {
1542         require(account != address(0), "Invalid Address!");
1543         permittedWithdrawals[account] = amount;
1544     }
1545 
1546     /**
1547      * Withdraw contract funds to a given address.
1548      * @param account The account to withdraw to.
1549      * @param amount The amount to withdraw.
1550      */
1551     function withdraw(address payable account, uint256 amount) external virtual {
1552         require(permittedWithdrawals[msg.sender] >= amount, "Amount Exceeds Permitted Withdrawal!");
1553 
1554         permittedWithdrawals[msg.sender] -= amount;
1555         Address.sendValue(account, amount);
1556     }
1557 
1558     /**
1559      * Withdraw contract funds to a given address.
1560      * @param account The account to withdraw to.
1561      * @param amount The amount to withdraw.
1562      */
1563     function ownerWithdraw(address payable account, uint256 amount) external virtual onlyOwner {
1564         Address.sendValue(account, amount);
1565     }
1566 }
1567 
1568 pragma solidity ^0.8.13;
1569 
1570 interface IOperatorFilterRegistry {
1571     /**
1572      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
1573      *         true if supplied registrant address is not registered.
1574      */
1575     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1576 
1577     /**
1578      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
1579      */
1580     function register(address registrant) external;
1581 
1582     /**
1583      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
1584      */
1585     function registerAndSubscribe(address registrant, address subscription) external;
1586 
1587     /**
1588      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
1589      *         address without subscribing.
1590      */
1591     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1592 
1593     /**
1594      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
1595      *         Note that this does not remove any filtered addresses or codeHashes.
1596      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
1597      */
1598     function unregister(address addr) external;
1599 
1600     /**
1601      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
1602      */
1603     function updateOperator(address registrant, address operator, bool filtered) external;
1604 
1605     /**
1606      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
1607      */
1608     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1609 
1610     /**
1611      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
1612      */
1613     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1614 
1615     /**
1616      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
1617      */
1618     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1619 
1620     /**
1621      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
1622      *         subscription if present.
1623      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
1624      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
1625      *         used.
1626      */
1627     function subscribe(address registrant, address registrantToSubscribe) external;
1628 
1629     /**
1630      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
1631      */
1632     function unsubscribe(address registrant, bool copyExistingEntries) external;
1633 
1634     /**
1635      * @notice Get the subscription address of a given registrant, if any.
1636      */
1637     function subscriptionOf(address addr) external returns (address registrant);
1638 
1639     /**
1640      * @notice Get the set of addresses subscribed to a given registrant.
1641      *         Note that order is not guaranteed as updates are made.
1642      */
1643     function subscribers(address registrant) external returns (address[] memory);
1644 
1645     /**
1646      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
1647      *         Note that order is not guaranteed as updates are made.
1648      */
1649     function subscriberAt(address registrant, uint256 index) external returns (address);
1650 
1651     /**
1652      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
1653      */
1654     function copyEntriesOf(address registrant, address registrantToCopy) external;
1655 
1656     /**
1657      * @notice Returns true if operator is filtered by a given address or its subscription.
1658      */
1659     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1660 
1661     /**
1662      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
1663      */
1664     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1665 
1666     /**
1667      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
1668      */
1669     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1670 
1671     /**
1672      * @notice Returns a list of filtered operators for a given address or its subscription.
1673      */
1674     function filteredOperators(address addr) external returns (address[] memory);
1675 
1676     /**
1677      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
1678      *         Note that order is not guaranteed as updates are made.
1679      */
1680     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1681 
1682     /**
1683      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
1684      *         its subscription.
1685      *         Note that order is not guaranteed as updates are made.
1686      */
1687     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1688 
1689     /**
1690      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
1691      *         its subscription.
1692      *         Note that order is not guaranteed as updates are made.
1693      */
1694     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1695 
1696     /**
1697      * @notice Returns true if an address has registered
1698      */
1699     function isRegistered(address addr) external returns (bool);
1700 
1701     /**
1702      * @dev Convenience method to compute the code hash of an arbitrary contract
1703      */
1704     function codeHashOf(address addr) external returns (bytes32);
1705 }
1706 
1707 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
1708 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
1709 
1710 pragma solidity ^0.8.13;
1711 
1712 /**
1713  * @title  OperatorFilterer
1714  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1715  *         registrant's entries in the OperatorFilterRegistry.
1716  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1717  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1718  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1719  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
1720  *         administration methods on the contract itself to interact with the registry otherwise the subscription
1721  *         will be locked to the options set during construction.
1722  */
1723 
1724 abstract contract OperatorFilterer {
1725     /// @dev Emitted when an operator is not allowed.
1726     error OperatorNotAllowed(address operator);
1727 
1728     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1729         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
1730 
1731     /// @dev The constructor that is called when the contract is being deployed.
1732     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1733         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1734         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1735         // order for the modifier to filter addresses.
1736         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1737             if (subscribe) {
1738                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1739             } else {
1740                 if (subscriptionOrRegistrantToCopy != address(0)) {
1741                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1742                 } else {
1743                     OPERATOR_FILTER_REGISTRY.register(address(this));
1744                 }
1745             }
1746         }
1747     }
1748 
1749     /**
1750      * @dev A helper function to check if an operator is allowed.
1751      */
1752     modifier onlyAllowedOperator(address from) virtual {
1753         // Allow spending tokens from addresses with balance
1754         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1755         // from an EOA.
1756         if (from != msg.sender) {
1757             _checkFilterOperator(msg.sender);
1758         }
1759         _;
1760     }
1761 
1762     /**
1763      * @dev A helper function to check if an operator approval is allowed.
1764      */
1765     modifier onlyAllowedOperatorApproval(address operator) virtual {
1766         _checkFilterOperator(operator);
1767         _;
1768     }
1769 
1770     /**
1771      * @dev A helper function to check if an operator is allowed.
1772      */
1773     function _checkFilterOperator(address operator) internal view virtual {
1774         // Check registry code length to facilitate testing in environments without a deployed registry.
1775         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1776             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
1777             // may specify their own OperatorFilterRegistry implementations, which may behave differently
1778             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1779                 revert OperatorNotAllowed(operator);
1780             }
1781         }
1782     }
1783 }
1784 
1785 pragma solidity ^0.8.13;
1786 
1787 /**
1788  * @title  DefaultOperatorFilterer
1789  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1790  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
1791  *         administration methods on the contract itself to interact with the registry otherwise the subscription
1792  *         will be locked to the options set during construction.
1793  */
1794 
1795 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1796     /// @dev The constructor that is called when the contract is being deployed.
1797     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
1798 }
1799 
1800 interface IStaking {
1801 
1802     function getTokenOwner(uint256 tokenId) external view returns (address);
1803 
1804     function listStakedTokensOfOwner(address owner) external view returns (uint256[] memory);
1805 
1806 }
1807 
1808 contract CitizensOfHumania is ERC721AEnumerable, Payable, DefaultOperatorFilterer {
1809     using Strings for uint256;
1810 
1811     uint256 private maxSalePlusOne = 10001;
1812     uint256 private maxPresalePlusOne = 10001;
1813 
1814     uint256 public tokenPrice = 0.005 ether;
1815 
1816     uint256 private txLimitPlusOne = 20;
1817     uint256 public presaleAllowancePlusOne = 20;
1818 
1819     bytes32 public merkleRootPresale1 = 0x4757c98906b0ef4e0318147b4b8124b95cd6654108406d43eea0acb2936fff24;
1820     bytes32 public merkleRootPresale2 = 0x70266e3ee01ed9ee88060198e7ad0c50d38a9e056702d283e0cd84a84f754fce;
1821     bytes32 public merkleRootSidekicks = 0x7215889933c7c5fde7fe96e2c2eb452f1e354a0b3a1a3c592d30ef3556e3134b;
1822     bytes32 public merkleRootHeros = 0x3812bc24523765d40ff75c73b6428acda7f16dab9eeed4455ed7d1cb60652d5d;
1823     bytes32 public merkleRootFree = 0x825b7e55685e52bdcfed6c0c31c328c92016487c9c99ed5b83b761fcec401ad1;
1824 
1825     mapping(address => bool) public freeClaims;
1826 
1827     enum ContractState {
1828         OFF,
1829         PRESALE1,
1830         PRESALE2,
1831         PUBLIC
1832     }
1833     ContractState public contractState = ContractState.OFF;
1834 
1835     mapping(uint256 => uint256) public revealStage;
1836     mapping(uint256 => string) public revealStageUri;
1837     uint256 public latestRevealStage;
1838 
1839     IERC721 public humanians;
1840     IStaking public humaniansStaking;
1841 
1842     mapping(uint256 => bool) public claimedTokenIds;
1843     mapping(address => uint256) public claimed;
1844 
1845     constructor() ERC721AEnumerable("Citizens Of Humania", "CITIZENS") {
1846         humanians = IERC721(0x7F9c2C1a1ff282748Cba62D38D5acc801710f6d0);
1847         humaniansStaking = IStaking(0xbB2582a6eA2eb271bF37Ac0371d4356EF99Cb5B5);
1848 
1849 
1850         revealStageUri[0] = 'ipfs://QmZs4VNmkabBtroDQg2X56BKiwJNx2rk4WcJQnhHW7c7rG/';
1851     }
1852 
1853     //
1854     // Modifiers
1855     //
1856 
1857     /**
1858      * Do not allow calls from other contracts.
1859      */
1860     modifier noBots() {
1861         require(msg.sender == tx.origin, "Humanians: No bots");
1862         _;
1863     }
1864 
1865     /**
1866      * Ensure current state is correct for this method.
1867      */
1868     modifier isContractState(ContractState contractState_) {
1869         require(contractState == contractState_, "Humanians: Invalid state");
1870         _;
1871     }
1872 
1873     /**
1874      * Ensure amount of tokens to mint is within the limit.
1875      */
1876     modifier withinMintLimit(uint256 quantity) {
1877         if (contractState == ContractState.PRESALE1 || contractState == ContractState.PRESALE2) {
1878             require((_totalMinted() + quantity) < maxPresalePlusOne, "Humanians: Exceeds available tokens");
1879         } else {
1880             require((_totalMinted() + quantity) < maxSalePlusOne, "Humanians: Exceeds available tokens");
1881         }
1882         _;
1883     }
1884 
1885     /**
1886      * Ensure correct amount of Ether present in transaction.
1887      */
1888     modifier correctValue(uint256 expectedValue) {
1889         require(expectedValue == msg.value, "Humanians: Ether value sent is not correct");
1890         _;
1891     }
1892 
1893     //
1894     // Mint
1895     //
1896 
1897     /**
1898      * Public mint.
1899      * @param quantity Amount of tokens to mint.
1900      */
1901     function mintPublic(uint256 quantity)
1902         external
1903         payable
1904         noBots
1905         isContractState(ContractState.PUBLIC)
1906         withinMintLimit(quantity)
1907         correctValue(tokenPrice * quantity)
1908     {
1909         require(quantity < txLimitPlusOne, "Humanians: Exceeds transaction limit");
1910         _safeMint(msg.sender, quantity);
1911     }
1912 
1913     /**
1914      * Mint tokens during the presale.
1915      * @notice This function is only available to those on the allowlist.
1916      * @param quantity The number of tokens to mint.
1917      * @param proof The Merkle proof used to validate the leaf is in the root.
1918      */
1919     function mintPresale(uint256 quantity, bytes32[] calldata proof, bytes32 leaf)
1920         external
1921         payable
1922         noBots
1923         withinMintLimit(quantity)
1924         correctValue(tokenPrice * quantity)
1925     {
1926         require(_numberMinted(msg.sender) + quantity - claimed[msg.sender] < presaleAllowancePlusOne, "Humanians: Exceeds allowance");
1927 
1928         if (contractState == ContractState.PRESALE1) {
1929             require(verify(merkleRootPresale1, leaf, proof) || humanians.balanceOf(msg.sender) > 0 || humaniansStaking.listStakedTokensOfOwner(msg.sender).length > 0, "Humanians: Not a valid proof");
1930         }   
1931         else if (contractState == ContractState.PRESALE2) {
1932             require(verify(merkleRootPresale2, leaf, proof), "Humanians: Not a valid proof");
1933         }
1934         else {
1935             revert("Humanians: Invalid State");
1936         }
1937         
1938         _safeMint(msg.sender, quantity);
1939     }
1940 
1941     /**
1942      * Claim free tokens
1943      * @notice This function is only available to those who have staked or own a past humanians NFT or are on one of the lists
1944      */
1945     function freeClaim(uint256[] memory tokenIds, bool useProof, bytes32 leaf, bytes32[] calldata proofFree, bytes32[] calldata proofSidekicks, bytes32[] calldata proofHeros)
1946         external
1947     {
1948         require(contractState != ContractState.OFF, "Humanians: Invalid state");
1949 
1950         uint256 totalMints;
1951         if (useProof) {
1952             require(!freeClaims[msg.sender], "Humanians: Free Mint Claimed");
1953             //bytes32 leaf = keccak256(abi.encode(msg.sender));
1954             if (verify(merkleRootFree, leaf, proofFree)) {
1955                 totalMints += 1;
1956             }
1957             if (verify(merkleRootSidekicks, leaf, proofSidekicks)) {
1958                 totalMints += 1;
1959             }
1960             if (verify(merkleRootHeros, leaf, proofHeros)) {
1961                 totalMints += 1;
1962             }
1963             freeClaims[msg.sender] = true;
1964         }
1965 
1966         for (uint i; i < tokenIds.length; i++) {
1967             require(!claimedTokenIds[tokenIds[i]], "Humanians: Free Token has already been claimed!");
1968             require(msg.sender == humanians.ownerOf(tokenIds[i]) || msg.sender == humaniansStaking.getTokenOwner(tokenIds[i]), "Humanians: Not Owner or Staked!");
1969             claimedTokenIds[tokenIds[i]] = true;
1970         }
1971         totalMints += tokenIds.length;
1972 
1973         if (contractState == ContractState.PRESALE1 || contractState == ContractState.PRESALE2) {
1974             require((_totalMinted() + totalMints) < maxPresalePlusOne, "Humanians: Exceeds available tokens");
1975         } else {
1976             require((_totalMinted() + totalMints) < maxSalePlusOne, "Humanians: Exceeds available tokens");
1977         }
1978         
1979         claimed[msg.sender] += totalMints;
1980         _safeMint(msg.sender, totalMints);
1981     }
1982 
1983 
1984     /**
1985      * Team reserved mint.
1986      * @param to Address to mint to.
1987      * @param quantity Amount of tokens to mint.
1988      */
1989     function mintReserved(address to, uint256 quantity) external onlyOwner withinMintLimit(quantity) {
1990         _safeMint(to, quantity);
1991     }
1992 
1993     //
1994     // Admin
1995     //
1996 
1997     /**
1998      * Set contract state.
1999      * @param contractState_ The new state of the contract.
2000      */
2001     function setContractState(uint256 contractState_) external onlyOwner {
2002         require(contractState_ < 4, "Invalid State!");
2003         
2004         if (contractState_ == 0) {
2005             contractState = ContractState.OFF;
2006         }
2007         else if (contractState_ == 1) {
2008             contractState = ContractState.PRESALE1;
2009         }
2010         else if (contractState_ == 2) {
2011             contractState = ContractState.PRESALE2;
2012         }
2013         else {
2014             contractState = ContractState.PUBLIC;
2015         }
2016     }
2017 
2018     /**
2019      * Update token price.
2020      * @param tokenPrice_ The new token price
2021      */
2022     function setTokenPrice(uint256 tokenPrice_) external onlyOwner {
2023         tokenPrice = tokenPrice_;
2024     }
2025 
2026     /**
2027      * Update maximum number of tokens for sale.
2028      * @param maxSale The maximum number of tokens available for sale.
2029      */
2030     function setMaxSale(uint256 maxSale) external onlyOwner {
2031         uint256 maxSalePlusOne_ = maxSale + 1;
2032         require(maxSalePlusOne_ < maxSalePlusOne, "Humanians: Can only reduce supply");
2033         maxSalePlusOne = maxSalePlusOne_;
2034     }
2035 
2036     /**
2037      * Update maximum number of tokens for presale.
2038      * @param maxPresale The maximum number of tokens available for presale.
2039      */
2040     function setMaxPresale(uint256 maxPresale) external onlyOwner {
2041         uint256 maxPresalePlusOne_ = maxPresale + 1;
2042         require(maxPresalePlusOne_ < maxPresalePlusOne, "Humanians: Can only reduce supply");
2043         maxPresalePlusOne = maxPresalePlusOne_;
2044     }
2045 
2046     /**
2047      * Update maximum number of tokens per transaction in public sale.
2048      * @param txLimit The new transaction limit.
2049      */
2050     function setTxLimit(uint256 txLimit) external onlyOwner {
2051         uint256 txLimitPlusOne_ = txLimit + 1;
2052         txLimitPlusOne = txLimitPlusOne_;
2053     }
2054 
2055     /**
2056      * Update presale allowance.
2057      * @param presaleAllowance The new presale allowance.
2058      */
2059     function setPresaleAllowance(uint256 presaleAllowance) external onlyOwner {
2060         presaleAllowancePlusOne = presaleAllowance + 1;
2061     }
2062 
2063     /**
2064      * Set the presale Merkle root.
2065      * @dev The Merkle root is calculated from [address, allowance] pairs.
2066      * @param merkleRoot_ The new merkle roo
2067      */
2068     function setMerkleRootPresale1(bytes32 merkleRoot_) external onlyOwner {
2069         merkleRootPresale1 = merkleRoot_;
2070     }
2071 
2072     /**
2073      * Set the presale Merkle root.
2074      * @dev The Merkle root is calculated from [address, allowance] pairs.
2075      * @param merkleRoot_ The new merkle roo
2076      */
2077     function setMerkleRootPresale2(bytes32 merkleRoot_) external onlyOwner {
2078         merkleRootPresale2 = merkleRoot_;
2079     }
2080 
2081     /**
2082      * Set the sidekicks claim Merkle root.
2083      * @dev The Merkle root is calculated from [address, allowance] pairs.
2084      * @param merkleRoot_ The new merkle roo
2085      */
2086     function setMerkleRootSidekicks(bytes32 merkleRoot_) external onlyOwner {
2087         merkleRootSidekicks = merkleRoot_;
2088     }
2089 
2090         /**
2091      * Set the heros claim Merkle root.
2092      * @dev The Merkle root is calculated from [address, allowance] pairs.
2093      * @param merkleRoot_ The new merkle roo
2094      */
2095     function setMerkleRootHeros(bytes32 merkleRoot_) external onlyOwner {
2096         merkleRootHeros = merkleRoot_;
2097     }
2098 
2099         /**
2100      * Set the heros claim Merkle root.
2101      * @dev The Merkle root is calculated from [address, allowance] pairs.
2102      * @param merkleRoot_ The new merkle roo
2103      */
2104     function setMerkleRootFree(bytes32 merkleRoot_) external onlyOwner {
2105         merkleRootFree = merkleRoot_;
2106     }
2107 
2108     /**
2109      * Set the address of Humanians NFT Collection
2110      * @param newAddress The new humanians address
2111      */
2112     function setHumanians(address newAddress) external onlyOwner {
2113         humanians = IERC721(newAddress);
2114     }
2115 
2116     /**
2117      * Set the address of Humanians Staking
2118      * @param newAddress The new humanians staking address
2119      */
2120     function setHumaniansStaking(address newAddress) external onlyOwner {
2121         humaniansStaking = IStaking(newAddress);
2122     }
2123 
2124     //
2125     // Views
2126     //
2127 
2128     /**
2129      * The block.timestamp when this token was transferred to the current owner.
2130      * @param tokenId The token id to query
2131      */
2132     function holdingSince(uint256 tokenId) public view returns (uint256) {
2133         return _ownershipOf(tokenId).startTimestamp;
2134     }
2135 
2136     /**
2137      * Return sale info.
2138      * @param addr The address to return sales data for.
2139      * saleInfo[0]: contractState
2140      * saleInfo[1]: maxSale (total available tokens)
2141      * saleInfo[2]: totalMinted
2142      * saleInfo[3]: tokenPrice
2143      * saleInfo[4]: numberMinted (by given address)
2144      * saleInfo[5]: presaleAllowance
2145      * saleInfo[6]: maxPresale (total available tokens during presale)
2146      */
2147     function saleInfo(address addr) public view virtual returns (uint256[7] memory) {
2148         return [
2149             uint256(contractState),
2150             maxSalePlusOne - 1,
2151             _totalMinted(),
2152             tokenPrice,
2153             _numberMinted(addr),
2154             presaleAllowancePlusOne - 1,
2155             maxPresalePlusOne - 1
2156         ];
2157     }
2158 
2159     /**
2160      * @dev See {IERC721Metadata-tokenURI}.
2161      */
2162     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2163         require(_exists(uint16(tokenId)), "Humanians: URI query for nonexistent token");
2164 
2165         return string(abi.encodePacked(revealStageUri[revealStage[tokenId]], tokenId.toString(), ".json"));
2166     }
2167 
2168     /// @inheritdoc IERC165
2169     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721A, ERC2981) returns (bool) {
2170         return ERC721A.supportsInterface(interfaceId) || ERC2981.supportsInterface(interfaceId);
2171     }
2172 
2173     /**
2174      * Verify the Merkle proof is valid.
2175      * @param root The Merkle root. Use the value stored in the contract
2176      * @param leaf The leaf. A [address, availableAmt] pair
2177      * @param proof The Merkle proof used to validate the leaf is in the root
2178      */
2179     function verify(
2180         bytes32 root,
2181         bytes32 leaf,
2182         bytes32[] memory proof
2183     ) public pure returns (bool) {
2184         return MerkleProof.verify(proof, root, leaf);
2185     }
2186 
2187     /**
2188      * Change the starting tokenId to 1.
2189      */
2190     function _startTokenId() internal pure override returns (uint256) {
2191         return 1;
2192     }
2193 
2194     //
2195     // Reveal
2196     //
2197 
2198     /**
2199      * Sets URI for specific stage
2200      * @param baseURI_ The base URI
2201      */
2202     function setUri(uint256 stage, string memory baseURI_) external onlyOwner {
2203         require(stage <= latestRevealStage, "Invalid Stage!");
2204         revealStageUri[stage] = baseURI_;
2205     }
2206 
2207     
2208     /**
2209      * Starts a new reveal stage and sets its uri
2210      * @param baseURI_ The base URI
2211      */
2212     function newRevealStage(string memory baseURI_) external onlyOwner {
2213         latestRevealStage++;
2214         revealStageUri[latestRevealStage] = baseURI_;
2215     }
2216 
2217     /**
2218      * Sets URI for specific stage
2219      * @param tokenIds the ids of the tokens to be revealed
2220      */
2221     function reveal(uint256[] calldata tokenIds) external {
2222         for (uint i; i < tokenIds.length; i++) {
2223             require(ownerOf(tokenIds[i]) == msg.sender, "Humanians: Not the Owner of this Token!");
2224             require(revealStage[tokenIds[i]] < latestRevealStage, "Humanians: Already at Latest Reveal Stage!");
2225             revealStage[tokenIds[i]]++;
2226         }
2227         
2228     }
2229 
2230     
2231 
2232     //
2233     // Default Operator Filter
2234     //
2235 
2236     /**
2237      * @dev See {IERC721-setApprovalForAll}.
2238      *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
2239      */
2240     function setApprovalForAll(address operator, bool approved) public override(ERC721A, IERC721) onlyAllowedOperatorApproval(operator) {
2241         super.setApprovalForAll(operator, approved);
2242     }
2243 
2244     /**
2245      * @dev See {IERC721-approve}.
2246      *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
2247      */
2248     function approve(address operator, uint256 tokenId) public override(ERC721A, IERC721) onlyAllowedOperatorApproval(operator) {
2249         super.approve(operator, tokenId);
2250     }
2251 
2252     /**
2253      * @dev See {IERC721-transferFrom}.
2254      *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
2255      */
2256     function transferFrom(address from, address to, uint256 tokenId) public override(ERC721A, IERC721) onlyAllowedOperator(from) {
2257         super.transferFrom(from, to, tokenId);
2258     }
2259 
2260     /**
2261      * @dev See {IERC721-safeTransferFrom}.
2262      *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
2263      */
2264     function safeTransferFrom(address from, address to, uint256 tokenId) public override(ERC721A, IERC721) onlyAllowedOperator(from) {
2265         super.safeTransferFrom(from, to, tokenId);
2266     }
2267 
2268     /**
2269      * @dev See {IERC721-safeTransferFrom}.
2270      *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
2271      */
2272     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2273         public
2274         override(ERC721A, IERC721)
2275         onlyAllowedOperator(from)
2276     {
2277         super.safeTransferFrom(from, to, tokenId, data);
2278     }
2279 }