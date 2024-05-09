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
531 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
532 
533 
534 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
535 
536 pragma solidity ^0.8.0;
537 
538 
539 /**
540  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
541  * @dev See https://eips.ethereum.org/EIPS/eip-721
542  */
543 interface IERC721Enumerable is IERC721 {
544     /**
545      * @dev Returns the total amount of tokens stored by the contract.
546      */
547     function totalSupply() external view returns (uint256);
548 
549     /**
550      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
551      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
552      */
553     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
554 
555     /**
556      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
557      * Use along with {totalSupply} to enumerate all tokens.
558      */
559     function tokenByIndex(uint256 index) external view returns (uint256);
560 }
561 
562 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
563 
564 
565 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
566 
567 pragma solidity ^0.8.0;
568 
569 
570 /**
571  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
572  * @dev See https://eips.ethereum.org/EIPS/eip-721
573  */
574 interface IERC721Metadata is IERC721 {
575     /**
576      * @dev Returns the token collection name.
577      */
578     function name() external view returns (string memory);
579 
580     /**
581      * @dev Returns the token collection symbol.
582      */
583     function symbol() external view returns (string memory);
584 
585     /**
586      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
587      */
588     function tokenURI(uint256 tokenId) external view returns (string memory);
589 }
590 
591 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
592 
593 
594 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
595 
596 pragma solidity ^0.8.0;
597 
598 /**
599  * @dev These functions deal with verification of Merkle Trees proofs.
600  *
601  * The proofs can be generated using the JavaScript library
602  * https://github.com/miguelmota/merkletreejs[merkletreejs].
603  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
604  *
605  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
606  */
607 library MerkleProof {
608     /**
609      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
610      * defined by `root`. For this, a `proof` must be provided, containing
611      * sibling hashes on the branch from the leaf to the root of the tree. Each
612      * pair of leaves and each pair of pre-images are assumed to be sorted.
613      */
614     function verify(
615         bytes32[] memory proof,
616         bytes32 root,
617         bytes32 leaf
618     ) internal pure returns (bool) {
619         return processProof(proof, leaf) == root;
620     }
621 
622     /**
623      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
624      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
625      * hash matches the root of the tree. When processing the proof, the pairs
626      * of leafs & pre-images are assumed to be sorted.
627      *
628      * _Available since v4.4._
629      */
630     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
631         bytes32 computedHash = leaf;
632         for (uint256 i = 0; i < proof.length; i++) {
633             bytes32 proofElement = proof[i];
634             if (computedHash <= proofElement) {
635                 // Hash(current computed hash + current element of the proof)
636                 computedHash = _efficientHash(computedHash, proofElement);
637             } else {
638                 // Hash(current element of the proof + current computed hash)
639                 computedHash = _efficientHash(proofElement, computedHash);
640             }
641         }
642         return computedHash;
643     }
644 
645     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
646         assembly {
647             mstore(0x00, a)
648             mstore(0x20, b)
649             value := keccak256(0x00, 0x40)
650         }
651     }
652 }
653 
654 // File: @openzeppelin/contracts/utils/Context.sol
655 
656 
657 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
658 
659 pragma solidity ^0.8.0;
660 
661 /**
662  * @dev Provides information about the current execution context, including the
663  * sender of the transaction and its data. While these are generally available
664  * via msg.sender and msg.data, they should not be accessed in such a direct
665  * manner, since when dealing with meta-transactions the account sending and
666  * paying for execution may not be the actual sender (as far as an application
667  * is concerned).
668  *
669  * This contract is only required for intermediate, library-like contracts.
670  */
671 abstract contract Context {
672     function _msgSender() internal view virtual returns (address) {
673         return msg.sender;
674     }
675 
676     function _msgData() internal view virtual returns (bytes calldata) {
677         return msg.data;
678     }
679 }
680 
681 // File: contracts/ERC721A.sol
682 
683 
684 // Creator: Chiru Labs
685 
686 pragma solidity ^0.8.4;
687 
688 
689 
690 
691 
692 
693 
694 
695 
696 error ApprovalCallerNotOwnerNorApproved();
697 error ApprovalQueryForNonexistentToken();
698 error ApproveToCaller();
699 error ApprovalToCurrentOwner();
700 error BalanceQueryForZeroAddress();
701 error MintedQueryForZeroAddress();
702 error BurnedQueryForZeroAddress();
703 error MintToZeroAddress();
704 error MintZeroQuantity();
705 error OwnerIndexOutOfBounds();
706 error OwnerQueryForNonexistentToken();
707 error TokenIndexOutOfBounds();
708 error TransferCallerNotOwnerNorApproved();
709 error TransferFromIncorrectOwner();
710 error TransferToNonERC721ReceiverImplementer();
711 error TransferToZeroAddress();
712 error URIQueryForNonexistentToken();
713 
714 /**
715  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
716  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
717  *
718  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
719  *
720  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
721  *
722  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
723  */
724 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
725     using Address for address;
726     using Strings for uint256;
727 
728     // Compiler will pack this into a single 256bit word.
729     struct TokenOwnership {
730         // The address of the owner.
731         address addr;
732         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
733         uint64 startTimestamp;
734         // Whether the token has been burned.
735         bool burned;
736     }
737 
738     // Compiler will pack this into a single 256bit word.
739     struct AddressData {
740         // Realistically, 2**64-1 is more than enough.
741         uint64 balance;
742         // Keeps track of mint count with minimal overhead for tokenomics.
743         uint64 numberMinted;
744         // Keeps track of burn count with minimal overhead for tokenomics.
745         uint64 numberBurned;
746     }
747 
748     // The tokenId of the next token to be minted.
749     uint256 internal _currentIndex;
750 
751     // The number of tokens burned.
752     uint256 internal _burnCounter;
753 
754     // Token name
755     string private _name;
756 
757     // Token symbol
758     string private _symbol;
759 
760     // Mapping from token ID to ownership details
761     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
762     mapping(uint256 => TokenOwnership) internal _ownerships;
763 
764     // Mapping owner address to address data
765     mapping(address => AddressData) private _addressData;
766 
767     // Mapping from token ID to approved address
768     mapping(uint256 => address) private _tokenApprovals;
769 
770     // Mapping from owner to operator approvals
771     mapping(address => mapping(address => bool)) private _operatorApprovals;
772 
773     constructor(string memory name_, string memory symbol_) {
774         _name = name_;
775         _symbol = symbol_;
776     }
777 
778     /**
779      * @dev See {IERC721Enumerable-totalSupply}.
780      */
781     function totalSupply() public view override returns (uint256) {
782         // Counter underflow is impossible as _burnCounter cannot be incremented
783         // more than _currentIndex times
784         unchecked {
785             return _currentIndex - _burnCounter;    
786         }
787     }
788 
789     /**
790      * @dev See {IERC721Enumerable-tokenByIndex}.
791      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
792      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
793      */
794     function tokenByIndex(uint256 index) public view override returns (uint256) {
795         uint256 numMintedSoFar = _currentIndex;
796         uint256 tokenIdsIdx;
797 
798         // Counter overflow is impossible as the loop breaks when
799         // uint256 i is equal to another uint256 numMintedSoFar.
800         unchecked {
801             for (uint256 i; i < numMintedSoFar; i++) {
802                 TokenOwnership memory ownership = _ownerships[i];
803                 if (!ownership.burned) {
804                     if (tokenIdsIdx == index) {
805                         return i;
806                     }
807                     tokenIdsIdx++;
808                 }
809             }
810         }
811         revert TokenIndexOutOfBounds();
812     }
813 
814     /**
815      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
816      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
817      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
818      */
819     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
820         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
821         uint256 numMintedSoFar = _currentIndex;
822         uint256 tokenIdsIdx;
823         address currOwnershipAddr;
824 
825         // Counter overflow is impossible as the loop breaks when
826         // uint256 i is equal to another uint256 numMintedSoFar.
827         unchecked {
828             for (uint256 i; i < numMintedSoFar; i++) {
829                 TokenOwnership memory ownership = _ownerships[i];
830                 if (ownership.burned) {
831                     continue;
832                 }
833                 if (ownership.addr != address(0)) {
834                     currOwnershipAddr = ownership.addr;
835                 }
836                 if (currOwnershipAddr == owner) {
837                     if (tokenIdsIdx == index) {
838                         return i;
839                     }
840                     tokenIdsIdx++;
841                 }
842             }
843         }
844 
845         // Execution should never reach this point.
846         revert();
847     }
848 
849     /**
850      * @dev See {IERC165-supportsInterface}.
851      */
852     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
853         return
854             interfaceId == type(IERC721).interfaceId ||
855             interfaceId == type(IERC721Metadata).interfaceId ||
856             interfaceId == type(IERC721Enumerable).interfaceId ||
857             super.supportsInterface(interfaceId);
858     }
859 
860     /**
861      * @dev See {IERC721-balanceOf}.
862      */
863     function balanceOf(address owner) public view override returns (uint256) {
864         if (owner == address(0)) revert BalanceQueryForZeroAddress();
865         return uint256(_addressData[owner].balance);
866     }
867 
868     function _numberMinted(address owner) internal view returns (uint256) {
869         if (owner == address(0)) revert MintedQueryForZeroAddress();
870         return uint256(_addressData[owner].numberMinted);
871     }
872 
873     function _numberBurned(address owner) internal view returns (uint256) {
874         if (owner == address(0)) revert BurnedQueryForZeroAddress();
875         return uint256(_addressData[owner].numberBurned);
876     }
877 
878     /**
879      * Gas spent here starts off proportional to the maximum mint batch size.
880      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
881      */
882     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
883         uint256 curr = tokenId;
884 
885         unchecked {
886             if (curr < _currentIndex) {
887                 TokenOwnership memory ownership = _ownerships[curr];
888                 if (!ownership.burned) {
889                     if (ownership.addr != address(0)) {
890                         return ownership;
891                     }
892                     // Invariant: 
893                     // There will always be an ownership that has an address and is not burned 
894                     // before an ownership that does not have an address and is not burned.
895                     // Hence, curr will not underflow.
896                     while (true) {
897                         curr--;
898                         ownership = _ownerships[curr];
899                         if (ownership.addr != address(0)) {
900                             return ownership;
901                         }
902                     }
903                 }
904             }
905         }
906         revert OwnerQueryForNonexistentToken();
907     }
908 
909     /**
910      * @dev See {IERC721-ownerOf}.
911      */
912     function ownerOf(uint256 tokenId) public view override returns (address) {
913         return ownershipOf(tokenId).addr;
914     }
915 
916     /**
917      * @dev See {IERC721Metadata-name}.
918      */
919     function name() public view virtual override returns (string memory) {
920         return _name;
921     }
922 
923     /**
924      * @dev See {IERC721Metadata-symbol}.
925      */
926     function symbol() public view virtual override returns (string memory) {
927         return _symbol;
928     }
929 
930     /**
931      * @dev See {IERC721Metadata-tokenURI}.
932      */
933     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
934         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
935 
936         string memory baseURI = _baseURI();
937         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
938     }
939 
940     /**
941      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
942      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
943      * by default, can be overriden in child contracts.
944      */
945     function _baseURI() internal view virtual returns (string memory) {
946         return '';
947     }
948 
949     /**
950      * @dev See {IERC721-approve}.
951      */
952     function approve(address to, uint256 tokenId) public override {
953         address owner = ERC721A.ownerOf(tokenId);
954         if (to == owner) revert ApprovalToCurrentOwner();
955 
956         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
957             revert ApprovalCallerNotOwnerNorApproved();
958         }
959 
960         _approve(to, tokenId, owner);
961     }
962 
963     /**
964      * @dev See {IERC721-getApproved}.
965      */
966     function getApproved(uint256 tokenId) public view override returns (address) {
967         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
968 
969         return _tokenApprovals[tokenId];
970     }
971 
972     /**
973      * @dev See {IERC721-setApprovalForAll}.
974      */
975     function setApprovalForAll(address operator, bool approved) public override {
976         if (operator == _msgSender()) revert ApproveToCaller();
977 
978         _operatorApprovals[_msgSender()][operator] = approved;
979         emit ApprovalForAll(_msgSender(), operator, approved);
980     }
981 
982     /**
983      * @dev See {IERC721-isApprovedForAll}.
984      */
985     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
986         return _operatorApprovals[owner][operator];
987     }
988 
989     /**
990      * @dev See {IERC721-transferFrom}.
991      */
992     function transferFrom(
993         address from,
994         address to,
995         uint256 tokenId
996     ) public virtual override {
997         _transfer(from, to, tokenId);
998     }
999 
1000     /**
1001      * @dev See {IERC721-safeTransferFrom}.
1002      */
1003     function safeTransferFrom(
1004         address from,
1005         address to,
1006         uint256 tokenId
1007     ) public virtual override {
1008         safeTransferFrom(from, to, tokenId, '');
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-safeTransferFrom}.
1013      */
1014     function safeTransferFrom(
1015         address from,
1016         address to,
1017         uint256 tokenId,
1018         bytes memory _data
1019     ) public virtual override {
1020         _transfer(from, to, tokenId);
1021         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1022             revert TransferToNonERC721ReceiverImplementer();
1023         }
1024     }
1025 
1026     /**
1027      * @dev Returns whether `tokenId` exists.
1028      *
1029      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1030      *
1031      * Tokens start existing when they are minted (`_mint`),
1032      */
1033     function _exists(uint256 tokenId) internal view returns (bool) {
1034         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1035     }
1036 
1037     function _safeMint(address to, uint256 quantity) internal {
1038         _safeMint(to, quantity, '');
1039     }
1040 
1041     /**
1042      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1043      *
1044      * Requirements:
1045      *
1046      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1047      * - `quantity` must be greater than 0.
1048      *
1049      * Emits a {Transfer} event.
1050      */
1051     function _safeMint(
1052         address to,
1053         uint256 quantity,
1054         bytes memory _data
1055     ) internal {
1056         _mint(to, quantity, _data, true);
1057     }
1058 
1059     /**
1060      * @dev Mints `quantity` tokens and transfers them to `to`.
1061      *
1062      * Requirements:
1063      *
1064      * - `to` cannot be the zero address.
1065      * - `quantity` must be greater than 0.
1066      *
1067      * Emits a {Transfer} event.
1068      */
1069     function _mint(
1070         address to,
1071         uint256 quantity,
1072         bytes memory _data,
1073         bool safe
1074     ) internal {
1075         uint256 startTokenId = _currentIndex;
1076         if (to == address(0)) revert MintToZeroAddress();
1077         if (quantity == 0) revert MintZeroQuantity();
1078 
1079         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1080 
1081         // Overflows are incredibly unrealistic.
1082         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1083         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1084         unchecked {
1085             _addressData[to].balance += uint64(quantity);
1086             _addressData[to].numberMinted += uint64(quantity);
1087 
1088             _ownerships[startTokenId].addr = to;
1089             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1090 
1091             uint256 updatedIndex = startTokenId;
1092 
1093             for (uint256 i; i < quantity; i++) {
1094                 emit Transfer(address(0), to, updatedIndex);
1095                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1096                     revert TransferToNonERC721ReceiverImplementer();
1097                 }
1098                 updatedIndex++;
1099             }
1100 
1101             _currentIndex = updatedIndex;
1102         }
1103         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1104     }
1105 
1106     /**
1107      * @dev Transfers `tokenId` from `from` to `to`.
1108      *
1109      * Requirements:
1110      *
1111      * - `to` cannot be the zero address.
1112      * - `tokenId` token must be owned by `from`.
1113      *
1114      * Emits a {Transfer} event.
1115      */
1116     function _transfer(
1117         address from,
1118         address to,
1119         uint256 tokenId
1120     ) private {
1121         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1122 
1123         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1124             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1125             getApproved(tokenId) == _msgSender());
1126 
1127         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1128         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1129         if (to == address(0)) revert TransferToZeroAddress();
1130 
1131         _beforeTokenTransfers(from, to, tokenId, 1);
1132 
1133         // Clear approvals from the previous owner
1134         _approve(address(0), tokenId, prevOwnership.addr);
1135 
1136         // Underflow of the sender's balance is impossible because we check for
1137         // ownership above and the recipient's balance can't realistically overflow.
1138         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1139         unchecked {
1140             _addressData[from].balance -= 1;
1141             _addressData[to].balance += 1;
1142 
1143             _ownerships[tokenId].addr = to;
1144             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1145 
1146             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1147             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1148             uint256 nextTokenId = tokenId + 1;
1149             if (_ownerships[nextTokenId].addr == address(0)) {
1150                 // This will suffice for checking _exists(nextTokenId),
1151                 // as a burned slot cannot contain the zero address.
1152                 if (nextTokenId < _currentIndex) {
1153                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1154                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1155                 }
1156             }
1157         }
1158 
1159         emit Transfer(from, to, tokenId);
1160         _afterTokenTransfers(from, to, tokenId, 1);
1161     }
1162 
1163     /**
1164      * @dev Destroys `tokenId`.
1165      * The approval is cleared when the token is burned.
1166      *
1167      * Requirements:
1168      *
1169      * - `tokenId` must exist.
1170      *
1171      * Emits a {Transfer} event.
1172      */
1173     function _burn(uint256 tokenId) internal virtual {
1174         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1175 
1176         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1177 
1178         // Clear approvals from the previous owner
1179         _approve(address(0), tokenId, prevOwnership.addr);
1180 
1181         // Underflow of the sender's balance is impossible because we check for
1182         // ownership above and the recipient's balance can't realistically overflow.
1183         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1184         unchecked {
1185             _addressData[prevOwnership.addr].balance -= 1;
1186             _addressData[prevOwnership.addr].numberBurned += 1;
1187 
1188             // Keep track of who burned the token, and the timestamp of burning.
1189             _ownerships[tokenId].addr = prevOwnership.addr;
1190             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1191             _ownerships[tokenId].burned = true;
1192 
1193             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1194             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1195             uint256 nextTokenId = tokenId + 1;
1196             if (_ownerships[nextTokenId].addr == address(0)) {
1197                 // This will suffice for checking _exists(nextTokenId),
1198                 // as a burned slot cannot contain the zero address.
1199                 if (nextTokenId < _currentIndex) {
1200                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1201                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1202                 }
1203             }
1204         }
1205 
1206         emit Transfer(prevOwnership.addr, address(0), tokenId);
1207         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1208 
1209         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1210         unchecked { 
1211             _burnCounter++;
1212         }
1213     }
1214 
1215     /**
1216      * @dev Approve `to` to operate on `tokenId`
1217      *
1218      * Emits a {Approval} event.
1219      */
1220     function _approve(
1221         address to,
1222         uint256 tokenId,
1223         address owner
1224     ) private {
1225         _tokenApprovals[tokenId] = to;
1226         emit Approval(owner, to, tokenId);
1227     }
1228 
1229     /**
1230      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1231      * The call is not executed if the target address is not a contract.
1232      *
1233      * @param from address representing the previous owner of the given token ID
1234      * @param to target address that will receive the tokens
1235      * @param tokenId uint256 ID of the token to be transferred
1236      * @param _data bytes optional data to send along with the call
1237      * @return bool whether the call correctly returned the expected magic value
1238      */
1239     function _checkOnERC721Received(
1240         address from,
1241         address to,
1242         uint256 tokenId,
1243         bytes memory _data
1244     ) private returns (bool) {
1245         if (to.isContract()) {
1246             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1247                 return retval == IERC721Receiver(to).onERC721Received.selector;
1248             } catch (bytes memory reason) {
1249                 if (reason.length == 0) {
1250                     revert TransferToNonERC721ReceiverImplementer();
1251                 } else {
1252                     assembly {
1253                         revert(add(32, reason), mload(reason))
1254                     }
1255                 }
1256             }
1257         } else {
1258             return true;
1259         }
1260     }
1261 
1262     /**
1263      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1264      * And also called before burning one token.
1265      *
1266      * startTokenId - the first token id to be transferred
1267      * quantity - the amount to be transferred
1268      *
1269      * Calling conditions:
1270      *
1271      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1272      * transferred to `to`.
1273      * - When `from` is zero, `tokenId` will be minted for `to`.
1274      * - When `to` is zero, `tokenId` will be burned by `from`.
1275      * - `from` and `to` are never both zero.
1276      */
1277     function _beforeTokenTransfers(
1278         address from,
1279         address to,
1280         uint256 startTokenId,
1281         uint256 quantity
1282     ) internal virtual {}
1283 
1284     /**
1285      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1286      * minting.
1287      * And also called after one token has been burned.
1288      *
1289      * startTokenId - the first token id to be transferred
1290      * quantity - the amount to be transferred
1291      *
1292      * Calling conditions:
1293      *
1294      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1295      * transferred to `to`.
1296      * - When `from` is zero, `tokenId` has been minted for `to`.
1297      * - When `to` is zero, `tokenId` has been burned by `from`.
1298      * - `from` and `to` are never both zero.
1299      */
1300     function _afterTokenTransfers(
1301         address from,
1302         address to,
1303         uint256 startTokenId,
1304         uint256 quantity
1305     ) internal virtual {}
1306 }
1307 
1308 // File: @openzeppelin/contracts/access/Ownable.sol
1309 
1310 
1311 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1312 
1313 pragma solidity ^0.8.0;
1314 
1315 
1316 /**
1317  * @dev Contract module which provides a basic access control mechanism, where
1318  * there is an account (an owner) that can be granted exclusive access to
1319  * specific functions.
1320  *
1321  * By default, the owner account will be the one that deploys the contract. This
1322  * can later be changed with {transferOwnership}.
1323  *
1324  * This module is used through inheritance. It will make available the modifier
1325  * `onlyOwner`, which can be applied to your functions to restrict their use to
1326  * the owner.
1327  */
1328 abstract contract Ownable is Context {
1329     address private _owner;
1330 
1331     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1332 
1333     /**
1334      * @dev Initializes the contract setting the deployer as the initial owner.
1335      */
1336     constructor() {
1337         _transferOwnership(_msgSender());
1338     }
1339 
1340     /**
1341      * @dev Returns the address of the current owner.
1342      */
1343     function owner() public view virtual returns (address) {
1344         return _owner;
1345     }
1346 
1347     /**
1348      * @dev Throws if called by any account other than the owner.
1349      */
1350     modifier onlyOwner() {
1351         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1352         _;
1353     }
1354 
1355     /**
1356      * @dev Leaves the contract without owner. It will not be possible to call
1357      * `onlyOwner` functions anymore. Can only be called by the current owner.
1358      *
1359      * NOTE: Renouncing ownership will leave the contract without an owner,
1360      * thereby removing any functionality that is only available to the owner.
1361      */
1362     function renounceOwnership() public virtual onlyOwner {
1363         _transferOwnership(address(0));
1364     }
1365 
1366     /**
1367      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1368      * Can only be called by the current owner.
1369      */
1370     function transferOwnership(address newOwner) public virtual onlyOwner {
1371         require(newOwner != address(0), "Ownable: new owner is the zero address");
1372         _transferOwnership(newOwner);
1373     }
1374 
1375     /**
1376      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1377      * Internal function without access restriction.
1378      */
1379     function _transferOwnership(address newOwner) internal virtual {
1380         address oldOwner = _owner;
1381         _owner = newOwner;
1382         emit OwnershipTransferred(oldOwner, newOwner);
1383     }
1384 }
1385 
1386 // File: contracts/RoboFrens.sol
1387 
1388 
1389 pragma solidity >=0.7.0 <0.9.0;
1390 
1391 // import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
1392 
1393 
1394 
1395 
1396 contract RoboFrens is ERC721A, Ownable {
1397     using Strings for uint256;
1398 
1399     enum ContractMintState { PAUSED, ALLOWLIST, PUBLIC }
1400 
1401     ContractMintState public state = ContractMintState.PAUSED;
1402 
1403     string public uriPrefix = "";
1404     string public hiddenMetadataUri = "ipfs://QmQp2XakuACyV72jauBpbFX9Usd9eu3HaKmBLcgePV5GPC/prereveal.json";
1405 
1406     uint256 public allowlistCost = 0.05 ether;
1407     uint256 public publicCost = 0.07 ether;
1408     uint256 public maxSupply = 7777;
1409     uint256 public maxMintAmountPerTx = 10;
1410 
1411     bool public revealed = false;
1412 
1413     bytes32 public whitelistMerkleRoot = 0xf44daa990333ba115984b1f61962ae748d7ce374e46d3ecb60b687a52e057d34;
1414     
1415     constructor() ERC721A("RoboFrens", "ROBO") {}
1416 
1417     modifier mintCompliance(uint256 _mintAmount) {
1418         require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount");
1419         require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded");
1420         _;
1421     }
1422 
1423     function setState(ContractMintState _state) public onlyOwner {
1424         state = _state;
1425     }
1426 
1427     function numberMinted(address _minter) public view returns (uint256) {
1428         return _numberMinted(_minter);
1429     }
1430 
1431     function _verify(bytes32 leaf, bytes32[] memory proof) internal view returns (bool) {
1432         return MerkleProof.verify(proof, whitelistMerkleRoot, leaf);
1433     }
1434 
1435     function _leaf(address account, uint256 allowance) internal pure returns (bytes32) {
1436         return keccak256(abi.encodePacked(account, allowance));
1437     }
1438 
1439     function setWhitelistMerkleRoot(bytes32 _whitelistMerkleRoot) external onlyOwner {
1440         whitelistMerkleRoot = _whitelistMerkleRoot;
1441     }
1442 
1443     function mint(uint256 amount) public payable mintCompliance(amount) {
1444         require(state == ContractMintState.PUBLIC, "Public mint is disabled");
1445         require(msg.value >= publicCost * amount, "Insufficient funds");
1446 
1447         _safeMint(msg.sender, amount);
1448     }
1449 
1450     function mintAllowList(uint256 amount, uint allowance, bytes32[] calldata proof) public payable mintCompliance(amount) {
1451         require(state == ContractMintState.ALLOWLIST, "Allowlist mint is disabled"); 
1452         require(msg.value >= allowlistCost * amount, "Insufficient funds");
1453         require(numberMinted(msg.sender) + amount <= allowance, "Can't mint that many");
1454         require(_verify(_leaf(msg.sender, allowance), proof), "Invalid proof");
1455 
1456         _safeMint(msg.sender, amount);
1457     }
1458 
1459     // Minting function for team
1460     function mintForAddress(uint256 amount, address _receiver) public mintCompliance(amount) onlyOwner {
1461         _safeMint(_receiver, amount);
1462     }
1463 
1464     // Get all tokens owned by _owner
1465     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1466         uint256 ownerTokenCount = balanceOf(_owner);
1467         uint256[] memory ownerTokens = new uint256[](ownerTokenCount);
1468         uint256 ownerTokenIdx = 0;
1469         for (uint256 tokenIdx = 0; tokenIdx < totalSupply(); tokenIdx++) {
1470             if (ownerOf(tokenIdx) == _owner) {
1471                 ownerTokens[ownerTokenIdx] = tokenIdx;
1472                 ownerTokenIdx++;
1473             }
1474         }
1475         return ownerTokens;
1476     }
1477 
1478     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1479         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1480 
1481         if (!revealed) {
1482             return hiddenMetadataUri;
1483         }
1484 
1485         string memory currentBaseURI = _baseURI();
1486         return bytes(currentBaseURI).length > 0
1487             ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json"))
1488             : "";
1489     }
1490 
1491     function setRevealed(bool _revealed) public onlyOwner {
1492         revealed = _revealed;
1493     }
1494 
1495     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1496         hiddenMetadataUri = _hiddenMetadataUri;
1497     }
1498 
1499     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1500         uriPrefix = _uriPrefix;
1501     }
1502 
1503     function withdraw() public onlyOwner {
1504         uint256 contractBalance = address(this).balance;
1505         bool success = true;
1506 
1507         (success, ) = payable(0x23Ca4447aE0fb7607C44e9aC9F9A3D9C1DC9504E).call{value: 150 * contractBalance / 1000}("");
1508         require(success, "Transfer failed");
1509 
1510         (success, ) = payable(0x69BF2F3533a40010E208D8b0C0E982f6F558fA9B).call{value: 150 * contractBalance / 1000}("");
1511         require(success, "Transfer failed");
1512 
1513         (success, ) = payable(0x6bE687A5143Ff5220CC5f4B3c6a43468b5331bc1).call{value: 30 * contractBalance / 1000}("");
1514         require(success, "Transfer failed");
1515 
1516         (success, ) = payable(0x251F9970062E9810102762aA92546261128C702C).call{value: 30 * contractBalance / 1000}("");
1517         require(success, "Transfer failed");
1518 
1519         (success, ) = payable(0xC7Ff430E64d3615bE49136BD370158fDBeBC1784).call{value: 30 * contractBalance / 1000}("");
1520         require(success, "Transfer failed");
1521 
1522         (success, ) = payable(0x028ba99Ce7454407E0aB7e3e981db148E74b10e4).call{value: 30 * contractBalance / 1000}("");
1523         require(success, "Transfer failed");
1524 
1525         (success, ) = payable(0xCb28ffdACAf576086Aec0FAFe08d2e1272BBa460).call{value: 30 * contractBalance / 1000}("");
1526         require(success, "Transfer failed");
1527 
1528         (success, ) = payable(0x44230C74E406d5690333ba81b198441bCF02CEc8).call{value: 25 * contractBalance / 1000}("");
1529         require(success, "Transfer failed");
1530 
1531         (success, ) = payable(0xFA9A358b821f4b4A1B5ac2E0c594bB3f860AFbd8).call{value: 25 * contractBalance / 1000}("");
1532         require(success, "Transfer failed");
1533 
1534         (success, ) = payable(0x556b25640a632695150200F1c83E04108d60Ed4b).call{value: 500 * contractBalance / 1000}("");
1535         require(success, "Transfer failed");
1536     }
1537 
1538     function _baseURI() internal view virtual override returns (string memory) {
1539         return uriPrefix;
1540     }
1541 }