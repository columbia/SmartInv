1 // File: utils/MerkleProof.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 library MerkleProof {
8     /**
9      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
10      * defined by `root`. For this, a `proof` must be provided, containing
11      * sibling hashes on the branch from the leaf to the root of the tree. Each
12      * pair of leaves and each pair of pre-images are assumed to be sorted.
13      */
14     function verify(
15         bytes32[] memory proof,
16         bytes32 root,
17         bytes32 leaf
18     ) internal pure returns (bool) {
19         return processProof(proof, leaf) == root;
20     }
21 
22     /**
23      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
24      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
25      * hash matches the root of the tree. When processing the proof, the pairs
26      * of leafs & pre-images are assumed to be sorted.
27      *
28      * _Available since v4.4._
29      */
30     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
31         bytes32 computedHash = leaf;
32         for (uint256 i = 0; i < proof.length; i++) {
33             bytes32 proofElement = proof[i];
34             if (computedHash <= proofElement) {
35                 // Hash(current computed hash + current element of the proof)
36                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
37             } else {
38                 // Hash(current element of the proof + current computed hash)
39                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
40             }
41         }
42         return computedHash;
43     }
44 }
45 // File: utils/Strings.sol
46 
47 
48 
49 pragma solidity ^0.8.0;
50 
51 /**
52  * @dev String operations.
53  */
54 library Strings {
55     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
59      */
60     function toString(uint256 value) internal pure returns (string memory) {
61         // Inspired by OraclizeAPI's implementation - MIT licence
62         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
63 
64         if (value == 0) {
65             return "0";
66         }
67         uint256 temp = value;
68         uint256 digits;
69         while (temp != 0) {
70             digits++;
71             temp /= 10;
72         }
73         bytes memory buffer = new bytes(digits);
74         while (value != 0) {
75             digits -= 1;
76             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
77             value /= 10;
78         }
79         return string(buffer);
80     }
81 
82     /**
83      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
84      */
85     function toHexString(uint256 value) internal pure returns (string memory) {
86         if (value == 0) {
87             return "0x00";
88         }
89         uint256 temp = value;
90         uint256 length = 0;
91         while (temp != 0) {
92             length++;
93             temp >>= 8;
94         }
95         return toHexString(value, length);
96     }
97 
98     /**
99      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
100      */
101     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
102         bytes memory buffer = new bytes(2 * length + 2);
103         buffer[0] = "0";
104         buffer[1] = "x";
105         for (uint256 i = 2 * length + 1; i > 1; --i) {
106             buffer[i] = _HEX_SYMBOLS[value & 0xf];
107             value >>= 4;
108         }
109         require(value == 0, "Strings: hex length insufficient");
110         return string(buffer);
111     }
112 }
113 // File: utils/Address.sol
114 
115 
116 
117 pragma solidity ^0.8.0;
118 
119 /**
120  * @dev Collection of functions related to the address type
121  */
122 library Address {
123     /**
124      * @dev Returns true if `account` is a contract.
125      *
126      * [IMPORTANT]
127      * ====
128      * It is unsafe to assume that an address for which this function returns
129      * false is an externally-owned account (EOA) and not a contract.
130      *
131      * Among others, `isContract` will return false for the following
132      * types of addresses:
133      *
134      *  - an externally-owned account
135      *  - a contract in construction
136      *  - an address where a contract will be created
137      *  - an address where a contract lived, but was destroyed
138      * ====
139      */
140     function isContract(address account) internal view returns (bool) {
141         // This method relies on extcodesize, which returns 0 for contracts in
142         // construction, since the code is only stored at the end of the
143         // constructor execution.
144 
145         uint256 size;
146         assembly {
147             size := extcodesize(account)
148         }
149         return size > 0;
150     }
151 
152     /**
153      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
154      * `recipient`, forwarding all available gas and reverting on errors.
155      *
156      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
157      * of certain opcodes, possibly making contracts go over the 2300 gas limit
158      * imposed by `transfer`, making them unable to receive funds via
159      * `transfer`. {sendValue} removes this limitation.
160      *
161      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
162      *
163      * IMPORTANT: because control is transferred to `recipient`, care must be
164      * taken to not create reentrancy vulnerabilities. Consider using
165      * {ReentrancyGuard} or the
166      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
167      */
168     function sendValue(address payable recipient, uint256 amount) internal {
169         require(address(this).balance >= amount, "Address: insufficient balance");
170 
171         (bool success, ) = recipient.call{value: amount}("");
172         require(success, "Address: unable to send value, recipient may have reverted");
173     }
174 
175     /**
176      * @dev Performs a Solidity function call using a low level `call`. A
177      * plain `call` is an unsafe replacement for a function call: use this
178      * function instead.
179      *
180      * If `target` reverts with a revert reason, it is bubbled up by this
181      * function (like regular Solidity function calls).
182      *
183      * Returns the raw returned data. To convert to the expected return value,
184      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
185      *
186      * Requirements:
187      *
188      * - `target` must be a contract.
189      * - calling `target` with `data` must not revert.
190      *
191      * _Available since v3.1._
192      */
193     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
194         return functionCall(target, data, "Address: low-level call failed");
195     }
196 
197     /**
198      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
199      * `errorMessage` as a fallback revert reason when `target` reverts.
200      *
201      * _Available since v3.1._
202      */
203     function functionCall(
204         address target,
205         bytes memory data,
206         string memory errorMessage
207     ) internal returns (bytes memory) {
208         return functionCallWithValue(target, data, 0, errorMessage);
209     }
210 
211     /**
212      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
213      * but also transferring `value` wei to `target`.
214      *
215      * Requirements:
216      *
217      * - the calling contract must have an ETH balance of at least `value`.
218      * - the called Solidity function must be `payable`.
219      *
220      * _Available since v3.1._
221      */
222     function functionCallWithValue(
223         address target,
224         bytes memory data,
225         uint256 value
226     ) internal returns (bytes memory) {
227         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
228     }
229 
230     /**
231      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
232      * with `errorMessage` as a fallback revert reason when `target` reverts.
233      *
234      * _Available since v3.1._
235      */
236     function functionCallWithValue(
237         address target,
238         bytes memory data,
239         uint256 value,
240         string memory errorMessage
241     ) internal returns (bytes memory) {
242         require(address(this).balance >= value, "Address: insufficient balance for call");
243         require(isContract(target), "Address: call to non-contract");
244 
245         (bool success, bytes memory returndata) = target.call{value: value}(data);
246         return _verifyCallResult(success, returndata, errorMessage);
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
251      * but performing a static call.
252      *
253      * _Available since v3.3._
254      */
255     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
256         return functionStaticCall(target, data, "Address: low-level static call failed");
257     }
258 
259     /**
260      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
261      * but performing a static call.
262      *
263      * _Available since v3.3._
264      */
265     function functionStaticCall(
266         address target,
267         bytes memory data,
268         string memory errorMessage
269     ) internal view returns (bytes memory) {
270         require(isContract(target), "Address: static call to non-contract");
271 
272         (bool success, bytes memory returndata) = target.staticcall(data);
273         return _verifyCallResult(success, returndata, errorMessage);
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
278      * but performing a delegate call.
279      *
280      * _Available since v3.4._
281      */
282     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
283         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
288      * but performing a delegate call.
289      *
290      * _Available since v3.4._
291      */
292     function functionDelegateCall(
293         address target,
294         bytes memory data,
295         string memory errorMessage
296     ) internal returns (bytes memory) {
297         require(isContract(target), "Address: delegate call to non-contract");
298 
299         (bool success, bytes memory returndata) = target.delegatecall(data);
300         return _verifyCallResult(success, returndata, errorMessage);
301     }
302 
303     function _verifyCallResult(
304         bool success,
305         bytes memory returndata,
306         string memory errorMessage
307     ) private pure returns (bytes memory) {
308         if (success) {
309             return returndata;
310         } else {
311             // Look for revert reason and bubble it up if present
312             if (returndata.length > 0) {
313                 // The easiest way to bubble the revert reason is using memory via assembly
314 
315                 assembly {
316                     let returndata_size := mload(returndata)
317                     revert(add(32, returndata), returndata_size)
318                 }
319             } else {
320                 revert(errorMessage);
321             }
322         }
323     }
324 }
325 // File: token/ERC721/IERC721Receiver.sol
326 
327 
328 
329 pragma solidity ^0.8.0;
330 
331 /**
332  * @title ERC721 token receiver interface
333  * @dev Interface for any contract that wants to support safeTransfers
334  * from ERC721 asset contracts.
335  */
336 interface IERC721Receiver {
337     /**
338      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
339      * by `operator` from `from`, this function is called.
340      *
341      * It must return its Solidity selector to confirm the token transfer.
342      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
343      *
344      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
345      */
346     function onERC721Received(
347         address operator,
348         address from,
349         uint256 tokenId,
350         bytes calldata data
351     ) external returns (bytes4);
352 }
353 // File: utils/introspection/IERC165.sol
354 
355 
356 
357 pragma solidity ^0.8.0;
358 
359 /**
360  * @dev Interface of the ERC165 standard, as defined in the
361  * https://eips.ethereum.org/EIPS/eip-165[EIP].
362  *
363  * Implementers can declare support of contract interfaces, which can then be
364  * queried by others ({ERC165Checker}).
365  *
366  * For an implementation, see {ERC165}.
367  */
368 interface IERC165 {
369     /**
370      * @dev Returns true if this contract implements the interface defined by
371      * `interfaceId`. See the corresponding
372      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
373      * to learn more about how these ids are created.
374      *
375      * This function call must use less than 30 000 gas.
376      */
377     function supportsInterface(bytes4 interfaceId) external view returns (bool);
378 }
379 // File: utils/introspection/ERC165.sol
380 
381 
382 
383 pragma solidity ^0.8.0;
384 
385 
386 /**
387  * @dev Implementation of the {IERC165} interface.
388  *
389  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
390  * for the additional interface id that will be supported. For example:
391  *
392  * ```solidity
393  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
394  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
395  * }
396  * ```
397  *
398  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
399  */
400 abstract contract ERC165 is IERC165 {
401     /**
402      * @dev See {IERC165-supportsInterface}.
403      */
404     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
405         return interfaceId == type(IERC165).interfaceId;
406     }
407 }
408 // File: token/ERC721/IERC721.sol
409 
410 
411 
412 pragma solidity ^0.8.0;
413 
414 
415 /**
416  * @dev Required interface of an ERC721 compliant contract.
417  */
418 interface IERC721 is IERC165 {
419     /**
420      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
421      */
422     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
423 
424     /**
425      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
426      */
427     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
428 
429     /**
430      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
431      */
432     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
433 
434     /**
435      * @dev Returns the number of tokens in ``owner``'s account.
436      */
437     function balanceOf(address owner) external view returns (uint256 balance);
438 
439     /**
440      * @dev Returns the owner of the `tokenId` token.
441      *
442      * Requirements:
443      *
444      * - `tokenId` must exist.
445      */
446     function ownerOf(uint256 tokenId) external view returns (address owner);
447 
448     /**
449      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
450      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
451      *
452      * Requirements:
453      *
454      * - `from` cannot be the zero address.
455      * - `to` cannot be the zero address.
456      * - `tokenId` token must exist and be owned by `from`.
457      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
458      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
459      *
460      * Emits a {Transfer} event.
461      */
462     function safeTransferFrom(
463         address from,
464         address to,
465         uint256 tokenId
466     ) external;
467 
468     /**
469      * @dev Transfers `tokenId` token from `from` to `to`.
470      *
471      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
472      *
473      * Requirements:
474      *
475      * - `from` cannot be the zero address.
476      * - `to` cannot be the zero address.
477      * - `tokenId` token must be owned by `from`.
478      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
479      *
480      * Emits a {Transfer} event.
481      */
482     function transferFrom(
483         address from,
484         address to,
485         uint256 tokenId
486     ) external;
487 
488     /**
489      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
490      * The approval is cleared when the token is transferred.
491      *
492      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
493      *
494      * Requirements:
495      *
496      * - The caller must own the token or be an approved operator.
497      * - `tokenId` must exist.
498      *
499      * Emits an {Approval} event.
500      */
501     function approve(address to, uint256 tokenId) external;
502 
503     /**
504      * @dev Returns the account approved for `tokenId` token.
505      *
506      * Requirements:
507      *
508      * - `tokenId` must exist.
509      */
510     function getApproved(uint256 tokenId) external view returns (address operator);
511 
512     /**
513      * @dev Approve or remove `operator` as an operator for the caller.
514      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
515      *
516      * Requirements:
517      *
518      * - The `operator` cannot be the caller.
519      *
520      * Emits an {ApprovalForAll} event.
521      */
522     function setApprovalForAll(address operator, bool _approved) external;
523 
524     /**
525      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
526      *
527      * See {setApprovalForAll}
528      */
529     function isApprovedForAll(address owner, address operator) external view returns (bool);
530 
531     /**
532      * @dev Safely transfers `tokenId` token from `from` to `to`.
533      *
534      * Requirements:
535      *
536      * - `from` cannot be the zero address.
537      * - `to` cannot be the zero address.
538      * - `tokenId` token must exist and be owned by `from`.
539      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
540      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
541      *
542      * Emits a {Transfer} event.
543      */
544     function safeTransferFrom(
545         address from,
546         address to,
547         uint256 tokenId,
548         bytes calldata data
549     ) external;
550 }
551 // File: token/ERC721/extensions/IERC721Enumerable.sol
552 
553 
554 
555 pragma solidity ^0.8.0;
556 
557 
558 /**
559  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
560  * @dev See https://eips.ethereum.org/EIPS/eip-721
561  */
562 interface IERC721Enumerable is IERC721 {
563     /**
564      * @dev Returns the total amount of tokens stored by the contract.
565      */
566     function totalSupply() external view returns (uint256);
567 
568     /**
569      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
570      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
571      */
572     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
573 
574     /**
575      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
576      * Use along with {totalSupply} to enumerate all tokens.
577      */
578     function tokenByIndex(uint256 index) external view returns (uint256);
579 }
580 // File: token/ERC721/extensions/IERC721Metadata.sol
581 
582 
583 
584 pragma solidity ^0.8.0;
585 
586 
587 /**
588  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
589  * @dev See https://eips.ethereum.org/EIPS/eip-721
590  */
591 interface IERC721Metadata is IERC721 {
592     /**
593      * @dev Returns the token collection name.
594      */
595     function name() external view returns (string memory);
596 
597     /**
598      * @dev Returns the token collection symbol.
599      */
600     function symbol() external view returns (string memory);
601 
602     /**
603      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
604      */
605     function tokenURI(uint256 tokenId) external view returns (string memory);
606 }
607 // File: security/ReentrancyGuard.sol
608 
609 
610 
611 pragma solidity ^0.8.0;
612 
613 /**
614  * @dev Contract module that helps prevent reentrant calls to a function.
615  *
616  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
617  * available, which can be applied to functions to make sure there are no nested
618  * (reentrant) calls to them.
619  *
620  * Note that because there is a single `nonReentrant` guard, functions marked as
621  * `nonReentrant` may not call one another. This can be worked around by making
622  * those functions `private`, and then adding `external` `nonReentrant` entry
623  * points to them.
624  *
625  * TIP: If you would like to learn more about reentrancy and alternative ways
626  * to protect against it, check out our blog post
627  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
628  */
629 abstract contract ReentrancyGuard {
630     // Booleans are more expensive than uint256 or any type that takes up a full
631     // word because each write operation emits an extra SLOAD to first read the
632     // slot's contents, replace the bits taken up by the boolean, and then write
633     // back. This is the compiler's defense against contract upgrades and
634     // pointer aliasing, and it cannot be disabled.
635 
636     // The values being non-zero value makes deployment a bit more expensive,
637     // but in exchange the refund on every call to nonReentrant will be lower in
638     // amount. Since refunds are capped to a percentage of the total
639     // transaction's gas, it is best to keep them low in cases like this one, to
640     // increase the likelihood of the full refund coming into effect.
641     uint256 private constant _NOT_ENTERED = 1;
642     uint256 private constant _ENTERED = 2;
643 
644     uint256 private _status;
645 
646     constructor() {
647         _status = _NOT_ENTERED;
648     }
649 
650     /**
651      * @dev Prevents a contract from calling itself, directly or indirectly.
652      * Calling a `nonReentrant` function from another `nonReentrant`
653      * function is not supported. It is possible to prevent this from happening
654      * by making the `nonReentrant` function external, and make it call a
655      * `private` function that does the actual work.
656      */
657     modifier nonReentrant() {
658         // On the first call to nonReentrant, _notEntered will be true
659         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
660 
661         // Any calls to nonReentrant after this point will fail
662         _status = _ENTERED;
663 
664         _;
665 
666         // By storing the original value once again, a refund is triggered (see
667         // https://eips.ethereum.org/EIPS/eip-2200)
668         _status = _NOT_ENTERED;
669     }
670 }
671 // File: utils/Context.sol
672 
673 
674 
675 pragma solidity ^0.8.0;
676 
677 /*
678  * @dev Provides information about the current execution context, including the
679  * sender of the transaction and its data. While these are generally available
680  * via msg.sender and msg.data, they should not be accessed in such a direct
681  * manner, since when dealing with meta-transactions the account sending and
682  * paying for execution may not be the actual sender (as far as an application
683  * is concerned).
684  *
685  * This contract is only required for intermediate, library-like contracts.
686  */
687 abstract contract Context {
688     function _msgSender() internal view virtual returns (address) {
689         return msg.sender;
690     }
691 
692     function _msgData() internal view virtual returns (bytes calldata) {
693         return msg.data;
694     }
695 }
696 // File: ERC721A.sol
697 
698 
699 
700 pragma solidity ^0.8.0;
701 
702 
703 
704 
705 
706 
707 
708 
709 
710 /**
711  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
712  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
713  *
714  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
715  *
716  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
717  *
718  * Does not support burning tokens to address(0).
719  */
720 contract ERC721A is
721   Context,
722   ERC165,
723   IERC721,
724   IERC721Metadata,
725   IERC721Enumerable
726 {
727   using Address for address;
728   using Strings for uint256;
729 
730   struct TokenOwnership {
731     address addr;
732     uint64 startTimestamp;
733   }
734 
735   struct AddressData {
736     uint128 balance;
737     uint128 numberMinted;
738   }
739 
740   uint256 private currentIndex = 0;
741 
742   uint256 internal immutable collectionSize;
743   uint256 internal immutable maxBatchSize;
744 
745   // Token name
746   string private _name;
747 
748   // Token symbol
749   string private _symbol;
750 
751   // Mapping from token ID to ownership details
752   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
753   mapping(uint256 => TokenOwnership) private _ownerships;
754 
755   // Mapping owner address to address data
756   mapping(address => AddressData) private _addressData;
757 
758   // Mapping from token ID to approved address
759   mapping(uint256 => address) private _tokenApprovals;
760 
761   // Mapping from owner to operator approvals
762   mapping(address => mapping(address => bool)) private _operatorApprovals;
763 
764   /**
765    * @dev
766    * `maxBatchSize` refers to how much a minter can mint at a time.
767    * `collectionSize_` refers to how many tokens are in the collection.
768    */
769   constructor(
770     string memory name_,
771     string memory symbol_,
772     uint256 maxBatchSize_,
773     uint256 collectionSize_
774   ) {
775     require(
776       collectionSize_ > 0,
777       "ERC721A: collection must have a nonzero supply"
778     );
779     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
780     _name = name_;
781     _symbol = symbol_;
782     maxBatchSize = maxBatchSize_;
783     collectionSize = collectionSize_;
784   }
785 
786   /**
787    * @dev See {IERC721Enumerable-totalSupply}.
788    */
789   function totalSupply() public view override returns (uint256) {
790     return currentIndex;
791   }
792 
793   /**
794    * @dev See {IERC721Enumerable-tokenByIndex}.
795    */
796   function tokenByIndex(uint256 index) public view override returns (uint256) {
797     require(index < totalSupply(), "ERC721A: global index out of bounds");
798     return index;
799   }
800 
801   /**
802    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
803    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
804    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
805    */
806   function tokenOfOwnerByIndex(address owner, uint256 index)
807     public
808     view
809     override
810     returns (uint256)
811   {
812     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
813     uint256 numMintedSoFar = totalSupply();
814     uint256 tokenIdsIdx = 0;
815     address currOwnershipAddr = address(0);
816     for (uint256 i = 0; i < numMintedSoFar; i++) {
817       TokenOwnership memory ownership = _ownerships[i];
818       if (ownership.addr != address(0)) {
819         currOwnershipAddr = ownership.addr;
820       }
821       if (currOwnershipAddr == owner) {
822         if (tokenIdsIdx == index) {
823           return i;
824         }
825         tokenIdsIdx++;
826       }
827     }
828     revert("ERC721A: unable to get token of owner by index");
829   }
830 
831   /**
832    * @dev See {IERC165-supportsInterface}.
833    */
834   function supportsInterface(bytes4 interfaceId)
835     public
836     view
837     virtual
838     override(ERC165, IERC165)
839     returns (bool)
840   {
841     return
842       interfaceId == type(IERC721).interfaceId ||
843       interfaceId == type(IERC721Metadata).interfaceId ||
844       interfaceId == type(IERC721Enumerable).interfaceId ||
845       super.supportsInterface(interfaceId);
846   }
847 
848   /**
849    * @dev See {IERC721-balanceOf}.
850    */
851   function balanceOf(address owner) public view override returns (uint256) {
852     require(owner != address(0), "ERC721A: balance query for the zero address");
853     return uint256(_addressData[owner].balance);
854   }
855 
856   function _numberMinted(address owner) internal view returns (uint256) {
857     require(
858       owner != address(0),
859       "ERC721A: number minted query for the zero address"
860     );
861     return uint256(_addressData[owner].numberMinted);
862   }
863 
864   function ownershipOf(uint256 tokenId)
865     internal
866     view
867     returns (TokenOwnership memory)
868   {
869     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
870 
871     uint256 lowestTokenToCheck;
872     if (tokenId >= maxBatchSize) {
873       lowestTokenToCheck = tokenId - maxBatchSize + 1;
874     }
875 
876     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
877       TokenOwnership memory ownership = _ownerships[curr];
878       if (ownership.addr != address(0)) {
879         return ownership;
880       }
881     }
882 
883     revert("ERC721A: unable to determine the owner of token");
884   }
885 
886   /**
887    * @dev See {IERC721-ownerOf}.
888    */
889   function ownerOf(uint256 tokenId) public view override returns (address) {
890     return ownershipOf(tokenId).addr;
891   }
892 
893   /**
894    * @dev See {IERC721Metadata-name}.
895    */
896   function name() public view virtual override returns (string memory) {
897     return _name;
898   }
899 
900   /**
901    * @dev See {IERC721Metadata-symbol}.
902    */
903   function symbol() public view virtual override returns (string memory) {
904     return _symbol;
905   }
906 
907   /**
908    * @dev See {IERC721Metadata-tokenURI}.
909    */
910   function tokenURI(uint256 tokenId)
911     public
912     view
913     virtual
914     override
915     returns (string memory)
916   {
917     require(
918       _exists(tokenId),
919       "ERC721Metadata: URI query for nonexistent token"
920     );
921 
922     string memory baseURI = _baseURI();
923     return
924       bytes(baseURI).length > 0
925         ? string(abi.encodePacked(baseURI, tokenId.toString()))
926         : "";
927   }
928 
929   /**
930    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
931    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
932    * by default, can be overriden in child contracts.
933    */
934   function _baseURI() internal view virtual returns (string memory) {
935     return "";
936   }
937 
938   /**
939    * @dev See {IERC721-approve}.
940    */
941   function approve(address to, uint256 tokenId) public override {
942     address owner = ERC721A.ownerOf(tokenId);
943     require(to != owner, "ERC721A: approval to current owner");
944 
945     require(
946       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
947       "ERC721A: approve caller is not owner nor approved for all"
948     );
949 
950     _approve(to, tokenId, owner);
951   }
952 
953   /**
954    * @dev See {IERC721-getApproved}.
955    */
956   function getApproved(uint256 tokenId) public view override returns (address) {
957     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
958 
959     return _tokenApprovals[tokenId];
960   }
961 
962   /**
963    * @dev See {IERC721-setApprovalForAll}.
964    */
965   function setApprovalForAll(address operator, bool approved) public override {
966     require(operator != _msgSender(), "ERC721A: approve to caller");
967 
968     _operatorApprovals[_msgSender()][operator] = approved;
969     emit ApprovalForAll(_msgSender(), operator, approved);
970   }
971 
972   /**
973    * @dev See {IERC721-isApprovedForAll}.
974    */
975   function isApprovedForAll(address owner, address operator)
976     public
977     view
978     virtual
979     override
980     returns (bool)
981   {
982     return _operatorApprovals[owner][operator];
983   }
984 
985   /**
986    * @dev See {IERC721-transferFrom}.
987    */
988   function transferFrom(
989     address from,
990     address to,
991     uint256 tokenId
992   ) public override {
993     _transfer(from, to, tokenId);
994   }
995 
996   /**
997    * @dev See {IERC721-safeTransferFrom}.
998    */
999   function safeTransferFrom(
1000     address from,
1001     address to,
1002     uint256 tokenId
1003   ) public override {
1004     safeTransferFrom(from, to, tokenId, "");
1005   }
1006 
1007   /**
1008    * @dev See {IERC721-safeTransferFrom}.
1009    */
1010   function safeTransferFrom(
1011     address from,
1012     address to,
1013     uint256 tokenId,
1014     bytes memory _data
1015   ) public override {
1016     _transfer(from, to, tokenId);
1017     require(
1018       _checkOnERC721Received(from, to, tokenId, _data),
1019       "ERC721A: transfer to non ERC721Receiver implementer"
1020     );
1021   }
1022 
1023   /**
1024    * @dev Returns whether `tokenId` exists.
1025    *
1026    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1027    *
1028    * Tokens start existing when they are minted (`_mint`),
1029    */
1030   function _exists(uint256 tokenId) internal view returns (bool) {
1031     return tokenId < currentIndex;
1032   }
1033 
1034   function _safeMint(address to, uint256 quantity) internal {
1035     _safeMint(to, quantity, "");
1036   }
1037 
1038   /**
1039    * @dev Mints `quantity` tokens and transfers them to `to`.
1040    *
1041    * Requirements:
1042    *
1043    * - there must be `quantity` tokens remaining unminted in the total collection.
1044    * - `to` cannot be the zero address.
1045    * - `quantity` cannot be larger than the max batch size.
1046    *
1047    * Emits a {Transfer} event.
1048    */
1049   function _safeMint(
1050     address to,
1051     uint256 quantity,
1052     bytes memory _data
1053   ) internal {
1054     uint256 startTokenId = currentIndex;
1055     require(to != address(0), "ERC721A: mint to the zero address");
1056     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1057     require(!_exists(startTokenId), "ERC721A: token already minted");
1058     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1059 
1060     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1061 
1062     AddressData memory addressData = _addressData[to];
1063     _addressData[to] = AddressData(
1064       addressData.balance + uint128(quantity),
1065       addressData.numberMinted + uint128(quantity)
1066     );
1067     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1068 
1069     uint256 updatedIndex = startTokenId;
1070 
1071     for (uint256 i = 0; i < quantity; i++) {
1072       emit Transfer(address(0), to, updatedIndex);
1073       require(
1074         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1075         "ERC721A: transfer to non ERC721Receiver implementer"
1076       );
1077       updatedIndex++;
1078     }
1079 
1080     currentIndex = updatedIndex;
1081     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1082   }
1083 
1084   /**
1085    * @dev Transfers `tokenId` from `from` to `to`.
1086    *
1087    * Requirements:
1088    *
1089    * - `to` cannot be the zero address.
1090    * - `tokenId` token must be owned by `from`.
1091    *
1092    * Emits a {Transfer} event.
1093    */
1094   function _transfer(
1095     address from,
1096     address to,
1097     uint256 tokenId
1098   ) private {
1099     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1100 
1101     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1102       getApproved(tokenId) == _msgSender() ||
1103       isApprovedForAll(prevOwnership.addr, _msgSender()));
1104 
1105     require(
1106       isApprovedOrOwner,
1107       "ERC721A: transfer caller is not owner nor approved"
1108     );
1109 
1110     require(
1111       prevOwnership.addr == from,
1112       "ERC721A: transfer from incorrect owner"
1113     );
1114     require(to != address(0), "ERC721A: transfer to the zero address");
1115 
1116     _beforeTokenTransfers(from, to, tokenId, 1);
1117 
1118     // Clear approvals from the previous owner
1119     _approve(address(0), tokenId, prevOwnership.addr);
1120 
1121     _addressData[from].balance -= 1;
1122     _addressData[to].balance += 1;
1123     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1124 
1125     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1126     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1127     uint256 nextTokenId = tokenId + 1;
1128     if (_ownerships[nextTokenId].addr == address(0)) {
1129       if (_exists(nextTokenId)) {
1130         _ownerships[nextTokenId] = TokenOwnership(
1131           prevOwnership.addr,
1132           prevOwnership.startTimestamp
1133         );
1134       }
1135     }
1136 
1137     emit Transfer(from, to, tokenId);
1138     _afterTokenTransfers(from, to, tokenId, 1);
1139   }
1140 
1141   /**
1142    * @dev Approve `to` to operate on `tokenId`
1143    *
1144    * Emits a {Approval} event.
1145    */
1146   function _approve(
1147     address to,
1148     uint256 tokenId,
1149     address owner
1150   ) private {
1151     _tokenApprovals[tokenId] = to;
1152     emit Approval(owner, to, tokenId);
1153   }
1154 
1155   uint256 public nextOwnerToExplicitlySet = 0;
1156 
1157   /**
1158    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1159    */
1160   function _setOwnersExplicit(uint256 quantity) internal {
1161     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1162     require(quantity > 0, "quantity must be nonzero");
1163     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1164     if (endIndex > collectionSize - 1) {
1165       endIndex = collectionSize - 1;
1166     }
1167     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1168     require(_exists(endIndex), "not enough minted yet for this cleanup");
1169     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1170       if (_ownerships[i].addr == address(0)) {
1171         TokenOwnership memory ownership = ownershipOf(i);
1172         _ownerships[i] = TokenOwnership(
1173           ownership.addr,
1174           ownership.startTimestamp
1175         );
1176       }
1177     }
1178     nextOwnerToExplicitlySet = endIndex + 1;
1179   }
1180 
1181   /**
1182    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1183    * The call is not executed if the target address is not a contract.
1184    *
1185    * @param from address representing the previous owner of the given token ID
1186    * @param to target address that will receive the tokens
1187    * @param tokenId uint256 ID of the token to be transferred
1188    * @param _data bytes optional data to send along with the call
1189    * @return bool whether the call correctly returned the expected magic value
1190    */
1191   function _checkOnERC721Received(
1192     address from,
1193     address to,
1194     uint256 tokenId,
1195     bytes memory _data
1196   ) private returns (bool) {
1197     if (to.isContract()) {
1198       try
1199         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1200       returns (bytes4 retval) {
1201         return retval == IERC721Receiver(to).onERC721Received.selector;
1202       } catch (bytes memory reason) {
1203         if (reason.length == 0) {
1204           revert("ERC721A: transfer to non ERC721Receiver implementer");
1205         } else {
1206           assembly {
1207             revert(add(32, reason), mload(reason))
1208           }
1209         }
1210       }
1211     } else {
1212       return true;
1213     }
1214   }
1215 
1216   /**
1217    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1218    *
1219    * startTokenId - the first token id to be transferred
1220    * quantity - the amount to be transferred
1221    *
1222    * Calling conditions:
1223    *
1224    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1225    * transferred to `to`.
1226    * - When `from` is zero, `tokenId` will be minted for `to`.
1227    */
1228   function _beforeTokenTransfers(
1229     address from,
1230     address to,
1231     uint256 startTokenId,
1232     uint256 quantity
1233   ) internal virtual {}
1234 
1235   /**
1236    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1237    * minting.
1238    *
1239    * startTokenId - the first token id to be transferred
1240    * quantity - the amount to be transferred
1241    *
1242    * Calling conditions:
1243    *
1244    * - when `from` and `to` are both non-zero.
1245    * - `from` and `to` are never both zero.
1246    */
1247   function _afterTokenTransfers(
1248     address from,
1249     address to,
1250     uint256 startTokenId,
1251     uint256 quantity
1252   ) internal virtual {}
1253 }
1254 // File: access/Ownable.sol
1255 
1256 
1257 
1258 pragma solidity ^0.8.0;
1259 
1260 
1261 /**
1262  * @dev Contract module which provides a basic access control mechanism, where
1263  * there is an account (an owner) that can be granted exclusive access to
1264  * specific functions.
1265  *
1266  * By default, the owner account will be the one that deploys the contract. This
1267  * can later be changed with {transferOwnership}.
1268  *
1269  * This module is used through inheritance. It will make available the modifier
1270  * `onlyOwner`, which can be applied to your functions to restrict their use to
1271  * the owner.
1272  */
1273 abstract contract Ownable is Context {
1274     address private _owner;
1275 
1276     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1277 
1278     /**
1279      * @dev Initializes the contract setting the deployer as the initial owner.
1280      */
1281     constructor() {
1282         _setOwner(_msgSender());
1283     }
1284 
1285     /**
1286      * @dev Returns the address of the current owner.
1287      */
1288     function owner() public view virtual returns (address) {
1289         return _owner;
1290     }
1291 
1292     /**
1293      * @dev Throws if called by any account other than the owner.
1294      */
1295     modifier onlyOwner() {
1296         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1297         _;
1298     }
1299 
1300     /**
1301      * @dev Leaves the contract without owner. It will not be possible to call
1302      * `onlyOwner` functions anymore. Can only be called by the current owner.
1303      *
1304      * NOTE: Renouncing ownership will leave the contract without an owner,
1305      * thereby removing any functionality that is only available to the owner.
1306      */
1307     function renounceOwnership() public virtual onlyOwner {
1308         _setOwner(address(0));
1309     }
1310 
1311     /**
1312      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1313      * Can only be called by the current owner.
1314      */
1315     function transferOwnership(address newOwner) public virtual onlyOwner {
1316         require(newOwner != address(0), "Ownable: new owner is the zero address");
1317         _setOwner(newOwner);
1318     }
1319 
1320     function _setOwner(address newOwner) private {
1321         address oldOwner = _owner;
1322         _owner = newOwner;
1323         emit OwnershipTransferred(oldOwner, newOwner);
1324     }
1325 }
1326 // File: SushiUKI.sol
1327 
1328 
1329 
1330 pragma solidity ^0.8.0;
1331 
1332 
1333 
1334 
1335 
1336 
1337 contract SUSHIUKI is Ownable, ERC721A, ReentrancyGuard {
1338 
1339     address public manageContract;
1340 
1341     function setManageContract(address contractAddress) public onlyOwner {
1342         manageContract = contractAddress;
1343     }
1344 
1345     function burningLab(uint256 tokenId, bytes32[] calldata proof) external callerIsUser {
1346         // burn
1347         transferFrom(msg.sender, address(0x000000000000000000000000000000000000dEaD), tokenId);
1348         UkiManager manager = UkiManager(manageContract);
1349         bool result = manager.burningLab(msg.sender, proof);
1350         require(result, "Burning lab failed");
1351     }
1352 
1353     enum MintType { Premium, Fam, Wl, Public }
1354 
1355     /**
1356      * @dev Config start time of each turn
1357      */
1358     mapping (MintType => uint32) public _startTimes;
1359     function setStartTimes(MintType mintType, uint32 startTime) external onlyOwner {
1360         _startTimes[mintType] = startTime;
1361     }
1362     function isSaleOn(MintType mintType) public view returns (bool) {
1363         if (_startTimes[mintType] == 0) {
1364             return false;
1365         }
1366         return block.timestamp >= _startTimes[mintType];
1367     }
1368 
1369     /**
1370      * @dev Config merkle root of each turn
1371      */
1372     mapping (MintType => bytes32) public _merkleRoots;
1373     function setMerkleRoot(MintType mintType, bytes32 merkleRoot) external onlyOwner {
1374         _merkleRoots[mintType] = merkleRoot;
1375     }
1376     function verifyProof(MintType mintType, bytes32[] memory _merkleProof) internal view returns (bool) {
1377         if (mintType == MintType.Public) {
1378             return true;
1379         }
1380         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1381         return MerkleProof.verify(_merkleProof, _merkleRoots[mintType], leaf);
1382     }
1383 
1384     function maxMintNumber(MintType mintType) public view returns (uint256) {
1385         uint maxMintNumberOfAddress;
1386         if (mintType == MintType.Public) {
1387             maxMintNumberOfAddress = 1;
1388         } else {
1389             maxMintNumberOfAddress = 3 - uint(mintType);
1390         }
1391         return maxMintNumberOfAddress - numberMinted(msg.sender);
1392     }
1393 
1394     constructor() ERC721A("SUSHIUKI", "UKI", 3, 5555) {
1395     }
1396 
1397     modifier callerIsUser() {
1398         require(tx.origin == msg.sender, "The caller is another contract");
1399         _;
1400     }
1401 
1402     function mint(MintType mintType, uint256 quantity, bytes32[] calldata proof) external callerIsUser {
1403         require(quantity > 0, "Number of tokens can not be less than or equal to 0");
1404         require(isSaleOn(mintType), "sale has not started yet");
1405         require(totalSupply() + quantity <= collectionSize, "reached max supply");
1406         require(
1407             quantity <= maxMintNumber(mintType),
1408             "can not mint this many"
1409         );
1410         if (mintType != MintType.Public) {
1411             require(verifyProof(mintType, proof), "Not in the whitelist");
1412         }
1413         _safeMint(msg.sender, quantity);
1414     }
1415 
1416     // metadata URI
1417     string private _baseTokenURI;
1418 
1419     function _baseURI() internal view virtual override returns (string memory) {
1420         return _baseTokenURI;
1421     }
1422 
1423     function setBaseURI(string calldata baseURI) external onlyOwner {
1424         _baseTokenURI = baseURI;
1425     }
1426 
1427     function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1428         _setOwnersExplicit(quantity);
1429     }
1430 
1431     function numberMinted(address owner) public view returns (uint256) {
1432         return _numberMinted(owner);
1433     }
1434 
1435     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1436         return ownershipOf(tokenId);
1437     }
1438 
1439 }
1440 
1441 interface UkiManager {
1442 
1443     function burningLab(address owner, bytes32[] calldata proof) external returns (bool);
1444 
1445 }