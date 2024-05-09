1 // SPDX-License-Identifier: MIT
2 // File: contracts/interfaces/IOpenSeaCompatible.sol
3 
4 
5 
6 pragma solidity ^0.8.0;
7 
8 interface IOpenSeaCompatible {
9     /**
10      * Get the contract metadata
11      */
12     function contractURI() external view returns (string memory);
13 
14     /**
15      * Set the contract metadata
16      */
17     function setContractURI(string memory contract_uri) external;
18 }
19 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
20 
21 
22 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
23 
24 pragma solidity ^0.8.0;
25 
26 /**
27  * @dev Contract module that helps prevent reentrant calls to a function.
28  *
29  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
30  * available, which can be applied to functions to make sure there are no nested
31  * (reentrant) calls to them.
32  *
33  * Note that because there is a single `nonReentrant` guard, functions marked as
34  * `nonReentrant` may not call one another. This can be worked around by making
35  * those functions `private`, and then adding `external` `nonReentrant` entry
36  * points to them.
37  *
38  * TIP: If you would like to learn more about reentrancy and alternative ways
39  * to protect against it, check out our blog post
40  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
41  */
42 abstract contract ReentrancyGuard {
43     // Booleans are more expensive than uint256 or any type that takes up a full
44     // word because each write operation emits an extra SLOAD to first read the
45     // slot's contents, replace the bits taken up by the boolean, and then write
46     // back. This is the compiler's defense against contract upgrades and
47     // pointer aliasing, and it cannot be disabled.
48 
49     // The values being non-zero value makes deployment a bit more expensive,
50     // but in exchange the refund on every call to nonReentrant will be lower in
51     // amount. Since refunds are capped to a percentage of the total
52     // transaction's gas, it is best to keep them low in cases like this one, to
53     // increase the likelihood of the full refund coming into effect.
54     uint256 private constant _NOT_ENTERED = 1;
55     uint256 private constant _ENTERED = 2;
56 
57     uint256 private _status;
58 
59     constructor() {
60         _status = _NOT_ENTERED;
61     }
62 
63     /**
64      * @dev Prevents a contract from calling itself, directly or indirectly.
65      * Calling a `nonReentrant` function from another `nonReentrant`
66      * function is not supported. It is possible to prevent this from happening
67      * by making the `nonReentrant` function external, and making it call a
68      * `private` function that does the actual work.
69      */
70     modifier nonReentrant() {
71         // On the first call to nonReentrant, _notEntered will be true
72         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
73 
74         // Any calls to nonReentrant after this point will fail
75         _status = _ENTERED;
76 
77         _;
78 
79         // By storing the original value once again, a refund is triggered (see
80         // https://eips.ethereum.org/EIPS/eip-2200)
81         _status = _NOT_ENTERED;
82     }
83 }
84 
85 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
86 
87 
88 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
89 
90 pragma solidity ^0.8.0;
91 
92 /**
93  * @dev These functions deal with verification of Merkle Trees proofs.
94  *
95  * The proofs can be generated using the JavaScript library
96  * https://github.com/miguelmota/merkletreejs[merkletreejs].
97  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
98  *
99  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
100  */
101 library MerkleProof {
102     /**
103      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
104      * defined by `root`. For this, a `proof` must be provided, containing
105      * sibling hashes on the branch from the leaf to the root of the tree. Each
106      * pair of leaves and each pair of pre-images are assumed to be sorted.
107      */
108     function verify(
109         bytes32[] memory proof,
110         bytes32 root,
111         bytes32 leaf
112     ) internal pure returns (bool) {
113         return processProof(proof, leaf) == root;
114     }
115 
116     /**
117      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
118      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
119      * hash matches the root of the tree. When processing the proof, the pairs
120      * of leafs & pre-images are assumed to be sorted.
121      *
122      * _Available since v4.4._
123      */
124     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
125         bytes32 computedHash = leaf;
126         for (uint256 i = 0; i < proof.length; i++) {
127             bytes32 proofElement = proof[i];
128             if (computedHash <= proofElement) {
129                 // Hash(current computed hash + current element of the proof)
130                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
131             } else {
132                 // Hash(current element of the proof + current computed hash)
133                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
134             }
135         }
136         return computedHash;
137     }
138 }
139 
140 // File: @openzeppelin/contracts/utils/Strings.sol
141 
142 
143 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
144 
145 pragma solidity ^0.8.0;
146 
147 /**
148  * @dev String operations.
149  */
150 library Strings {
151     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
152 
153     /**
154      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
155      */
156     function toString(uint256 value) internal pure returns (string memory) {
157         // Inspired by OraclizeAPI's implementation - MIT licence
158         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
159 
160         if (value == 0) {
161             return "0";
162         }
163         uint256 temp = value;
164         uint256 digits;
165         while (temp != 0) {
166             digits++;
167             temp /= 10;
168         }
169         bytes memory buffer = new bytes(digits);
170         while (value != 0) {
171             digits -= 1;
172             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
173             value /= 10;
174         }
175         return string(buffer);
176     }
177 
178     /**
179      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
180      */
181     function toHexString(uint256 value) internal pure returns (string memory) {
182         if (value == 0) {
183             return "0x00";
184         }
185         uint256 temp = value;
186         uint256 length = 0;
187         while (temp != 0) {
188             length++;
189             temp >>= 8;
190         }
191         return toHexString(value, length);
192     }
193 
194     /**
195      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
196      */
197     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
198         bytes memory buffer = new bytes(2 * length + 2);
199         buffer[0] = "0";
200         buffer[1] = "x";
201         for (uint256 i = 2 * length + 1; i > 1; --i) {
202             buffer[i] = _HEX_SYMBOLS[value & 0xf];
203             value >>= 4;
204         }
205         require(value == 0, "Strings: hex length insufficient");
206         return string(buffer);
207     }
208 }
209 
210 // File: @openzeppelin/contracts/utils/Address.sol
211 
212 
213 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
214 
215 pragma solidity ^0.8.0;
216 
217 /**
218  * @dev Collection of functions related to the address type
219  */
220 library Address {
221     /**
222      * @dev Returns true if `account` is a contract.
223      *
224      * [IMPORTANT]
225      * ====
226      * It is unsafe to assume that an address for which this function returns
227      * false is an externally-owned account (EOA) and not a contract.
228      *
229      * Among others, `isContract` will return false for the following
230      * types of addresses:
231      *
232      *  - an externally-owned account
233      *  - a contract in construction
234      *  - an address where a contract will be created
235      *  - an address where a contract lived, but was destroyed
236      * ====
237      */
238     function isContract(address account) internal view returns (bool) {
239         // This method relies on extcodesize, which returns 0 for contracts in
240         // construction, since the code is only stored at the end of the
241         // constructor execution.
242 
243         uint256 size;
244         assembly {
245             size := extcodesize(account)
246         }
247         return size > 0;
248     }
249 
250     /**
251      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
252      * `recipient`, forwarding all available gas and reverting on errors.
253      *
254      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
255      * of certain opcodes, possibly making contracts go over the 2300 gas limit
256      * imposed by `transfer`, making them unable to receive funds via
257      * `transfer`. {sendValue} removes this limitation.
258      *
259      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
260      *
261      * IMPORTANT: because control is transferred to `recipient`, care must be
262      * taken to not create reentrancy vulnerabilities. Consider using
263      * {ReentrancyGuard} or the
264      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
265      */
266     function sendValue(address payable recipient, uint256 amount) internal {
267         require(address(this).balance >= amount, "Address: insufficient balance");
268 
269         (bool success, ) = recipient.call{value: amount}("");
270         require(success, "Address: unable to send value, recipient may have reverted");
271     }
272 
273     /**
274      * @dev Performs a Solidity function call using a low level `call`. A
275      * plain `call` is an unsafe replacement for a function call: use this
276      * function instead.
277      *
278      * If `target` reverts with a revert reason, it is bubbled up by this
279      * function (like regular Solidity function calls).
280      *
281      * Returns the raw returned data. To convert to the expected return value,
282      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
283      *
284      * Requirements:
285      *
286      * - `target` must be a contract.
287      * - calling `target` with `data` must not revert.
288      *
289      * _Available since v3.1._
290      */
291     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
292         return functionCall(target, data, "Address: low-level call failed");
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
297      * `errorMessage` as a fallback revert reason when `target` reverts.
298      *
299      * _Available since v3.1._
300      */
301     function functionCall(
302         address target,
303         bytes memory data,
304         string memory errorMessage
305     ) internal returns (bytes memory) {
306         return functionCallWithValue(target, data, 0, errorMessage);
307     }
308 
309     /**
310      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
311      * but also transferring `value` wei to `target`.
312      *
313      * Requirements:
314      *
315      * - the calling contract must have an ETH balance of at least `value`.
316      * - the called Solidity function must be `payable`.
317      *
318      * _Available since v3.1._
319      */
320     function functionCallWithValue(
321         address target,
322         bytes memory data,
323         uint256 value
324     ) internal returns (bytes memory) {
325         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
330      * with `errorMessage` as a fallback revert reason when `target` reverts.
331      *
332      * _Available since v3.1._
333      */
334     function functionCallWithValue(
335         address target,
336         bytes memory data,
337         uint256 value,
338         string memory errorMessage
339     ) internal returns (bytes memory) {
340         require(address(this).balance >= value, "Address: insufficient balance for call");
341         require(isContract(target), "Address: call to non-contract");
342 
343         (bool success, bytes memory returndata) = target.call{value: value}(data);
344         return verifyCallResult(success, returndata, errorMessage);
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
349      * but performing a static call.
350      *
351      * _Available since v3.3._
352      */
353     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
354         return functionStaticCall(target, data, "Address: low-level static call failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
359      * but performing a static call.
360      *
361      * _Available since v3.3._
362      */
363     function functionStaticCall(
364         address target,
365         bytes memory data,
366         string memory errorMessage
367     ) internal view returns (bytes memory) {
368         require(isContract(target), "Address: static call to non-contract");
369 
370         (bool success, bytes memory returndata) = target.staticcall(data);
371         return verifyCallResult(success, returndata, errorMessage);
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
376      * but performing a delegate call.
377      *
378      * _Available since v3.4._
379      */
380     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
381         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
386      * but performing a delegate call.
387      *
388      * _Available since v3.4._
389      */
390     function functionDelegateCall(
391         address target,
392         bytes memory data,
393         string memory errorMessage
394     ) internal returns (bytes memory) {
395         require(isContract(target), "Address: delegate call to non-contract");
396 
397         (bool success, bytes memory returndata) = target.delegatecall(data);
398         return verifyCallResult(success, returndata, errorMessage);
399     }
400 
401     /**
402      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
403      * revert reason using the provided one.
404      *
405      * _Available since v4.3._
406      */
407     function verifyCallResult(
408         bool success,
409         bytes memory returndata,
410         string memory errorMessage
411     ) internal pure returns (bytes memory) {
412         if (success) {
413             return returndata;
414         } else {
415             // Look for revert reason and bubble it up if present
416             if (returndata.length > 0) {
417                 // The easiest way to bubble the revert reason is using memory via assembly
418 
419                 assembly {
420                     let returndata_size := mload(returndata)
421                     revert(add(32, returndata), returndata_size)
422                 }
423             } else {
424                 revert(errorMessage);
425             }
426         }
427     }
428 }
429 
430 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
431 
432 
433 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
434 
435 pragma solidity ^0.8.0;
436 
437 /**
438  * @title ERC721 token receiver interface
439  * @dev Interface for any contract that wants to support safeTransfers
440  * from ERC721 asset contracts.
441  */
442 interface IERC721Receiver {
443     /**
444      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
445      * by `operator` from `from`, this function is called.
446      *
447      * It must return its Solidity selector to confirm the token transfer.
448      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
449      *
450      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
451      */
452     function onERC721Received(
453         address operator,
454         address from,
455         uint256 tokenId,
456         bytes calldata data
457     ) external returns (bytes4);
458 }
459 
460 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
461 
462 
463 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
464 
465 pragma solidity ^0.8.0;
466 
467 /**
468  * @dev Interface of the ERC165 standard, as defined in the
469  * https://eips.ethereum.org/EIPS/eip-165[EIP].
470  *
471  * Implementers can declare support of contract interfaces, which can then be
472  * queried by others ({ERC165Checker}).
473  *
474  * For an implementation, see {ERC165}.
475  */
476 interface IERC165 {
477     /**
478      * @dev Returns true if this contract implements the interface defined by
479      * `interfaceId`. See the corresponding
480      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
481      * to learn more about how these ids are created.
482      *
483      * This function call must use less than 30 000 gas.
484      */
485     function supportsInterface(bytes4 interfaceId) external view returns (bool);
486 }
487 
488 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
489 
490 
491 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
492 
493 pragma solidity ^0.8.0;
494 
495 
496 /**
497  * @dev Implementation of the {IERC165} interface.
498  *
499  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
500  * for the additional interface id that will be supported. For example:
501  *
502  * ```solidity
503  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
504  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
505  * }
506  * ```
507  *
508  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
509  */
510 abstract contract ERC165 is IERC165 {
511     /**
512      * @dev See {IERC165-supportsInterface}.
513      */
514     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
515         return interfaceId == type(IERC165).interfaceId;
516     }
517 }
518 
519 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
520 
521 
522 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
523 
524 pragma solidity ^0.8.0;
525 
526 
527 /**
528  * @dev Required interface of an ERC721 compliant contract.
529  */
530 interface IERC721 is IERC165 {
531     /**
532      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
533      */
534     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
535 
536     /**
537      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
538      */
539     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
540 
541     /**
542      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
543      */
544     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
545 
546     /**
547      * @dev Returns the number of tokens in ``owner``'s account.
548      */
549     function balanceOf(address owner) external view returns (uint256 balance);
550 
551     /**
552      * @dev Returns the owner of the `tokenId` token.
553      *
554      * Requirements:
555      *
556      * - `tokenId` must exist.
557      */
558     function ownerOf(uint256 tokenId) external view returns (address owner);
559 
560     /**
561      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
562      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
563      *
564      * Requirements:
565      *
566      * - `from` cannot be the zero address.
567      * - `to` cannot be the zero address.
568      * - `tokenId` token must exist and be owned by `from`.
569      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
570      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
571      *
572      * Emits a {Transfer} event.
573      */
574     function safeTransferFrom(
575         address from,
576         address to,
577         uint256 tokenId
578     ) external;
579 
580     /**
581      * @dev Transfers `tokenId` token from `from` to `to`.
582      *
583      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
584      *
585      * Requirements:
586      *
587      * - `from` cannot be the zero address.
588      * - `to` cannot be the zero address.
589      * - `tokenId` token must be owned by `from`.
590      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
591      *
592      * Emits a {Transfer} event.
593      */
594     function transferFrom(
595         address from,
596         address to,
597         uint256 tokenId
598     ) external;
599 
600     /**
601      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
602      * The approval is cleared when the token is transferred.
603      *
604      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
605      *
606      * Requirements:
607      *
608      * - The caller must own the token or be an approved operator.
609      * - `tokenId` must exist.
610      *
611      * Emits an {Approval} event.
612      */
613     function approve(address to, uint256 tokenId) external;
614 
615     /**
616      * @dev Returns the account approved for `tokenId` token.
617      *
618      * Requirements:
619      *
620      * - `tokenId` must exist.
621      */
622     function getApproved(uint256 tokenId) external view returns (address operator);
623 
624     /**
625      * @dev Approve or remove `operator` as an operator for the caller.
626      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
627      *
628      * Requirements:
629      *
630      * - The `operator` cannot be the caller.
631      *
632      * Emits an {ApprovalForAll} event.
633      */
634     function setApprovalForAll(address operator, bool _approved) external;
635 
636     /**
637      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
638      *
639      * See {setApprovalForAll}
640      */
641     function isApprovedForAll(address owner, address operator) external view returns (bool);
642 
643     /**
644      * @dev Safely transfers `tokenId` token from `from` to `to`.
645      *
646      * Requirements:
647      *
648      * - `from` cannot be the zero address.
649      * - `to` cannot be the zero address.
650      * - `tokenId` token must exist and be owned by `from`.
651      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
652      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
653      *
654      * Emits a {Transfer} event.
655      */
656     function safeTransferFrom(
657         address from,
658         address to,
659         uint256 tokenId,
660         bytes calldata data
661     ) external;
662 }
663 
664 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
665 
666 
667 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
668 
669 pragma solidity ^0.8.0;
670 
671 
672 /**
673  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
674  * @dev See https://eips.ethereum.org/EIPS/eip-721
675  */
676 interface IERC721Enumerable is IERC721 {
677     /**
678      * @dev Returns the total amount of tokens stored by the contract.
679      */
680     function totalSupply() external view returns (uint256);
681 
682     /**
683      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
684      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
685      */
686     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
687 
688     /**
689      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
690      * Use along with {totalSupply} to enumerate all tokens.
691      */
692     function tokenByIndex(uint256 index) external view returns (uint256);
693 }
694 
695 // File: contracts/interfaces/IPeachProject.sol
696 
697 
698 pragma solidity ^0.8.0;
699 
700 
701 interface IPeachProject is IERC721Enumerable {
702     function canMint(uint256 quantity) external view returns (bool);
703 
704     function canMintPresale(
705         address owner,
706         uint256 quantity,
707         bytes32[] calldata proof
708     ) external view returns (bool);
709 
710     function presaleMinted(address owner) external view returns (uint256);
711 
712     function purchase(uint256 quantity) external payable;
713 
714     function purchasePresale(uint256 quantity, bytes32[] calldata proof) external payable;
715 }
716 
717 interface IPeachProjectAdmin {
718     function mintToAddress(uint256 quantity, address to) external;
719 
720     function mintToAddresses(address[] calldata to) external;
721 
722     function setBaseURI(string memory baseURI) external;
723 
724     function setBaseURIRevealed(string memory baseURI) external;
725 
726     function setPresaleLimit(uint256 limit) external;
727 
728     function setPresaleRoot(bytes32 merkleRoot) external;
729 
730     function togglePresaleIsActive() external;
731 
732     function toggleSaleIsActive() external;
733 
734     function withdraw() external;
735 }
736 
737 interface IPeachToken {
738   function burn(address from, uint256 amount) external;
739 }
740 
741 interface ITraits {
742   function tokenURI(uint256 tokenId) external view returns (string memory);
743 }
744 
745 interface IPeachStakingFactory {
746   function addManyPeachToStake(address account, uint16[] calldata tokenIds) external;
747 }
748 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
749 
750 
751 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
752 
753 pragma solidity ^0.8.0;
754 
755 
756 /**
757  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
758  * @dev See https://eips.ethereum.org/EIPS/eip-721
759  */
760 interface IERC721Metadata is IERC721 {
761     /**
762      * @dev Returns the token collection name.
763      */
764     function name() external view returns (string memory);
765 
766     /**
767      * @dev Returns the token collection symbol.
768      */
769     function symbol() external view returns (string memory);
770 
771     /**
772      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
773      */
774     function tokenURI(uint256 tokenId) external view returns (string memory);
775 }
776 
777 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
778 
779 
780 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
781 
782 pragma solidity ^0.8.0;
783 
784 // CAUTION
785 // This version of SafeMath should only be used with Solidity 0.8 or later,
786 // because it relies on the compiler's built in overflow checks.
787 
788 /**
789  * @dev Wrappers over Solidity's arithmetic operations.
790  *
791  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
792  * now has built in overflow checking.
793  */
794 library SafeMath {
795     /**
796      * @dev Returns the addition of two unsigned integers, with an overflow flag.
797      *
798      * _Available since v3.4._
799      */
800     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
801         unchecked {
802             uint256 c = a + b;
803             if (c < a) return (false, 0);
804             return (true, c);
805         }
806     }
807 
808     /**
809      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
810      *
811      * _Available since v3.4._
812      */
813     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
814         unchecked {
815             if (b > a) return (false, 0);
816             return (true, a - b);
817         }
818     }
819 
820     /**
821      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
822      *
823      * _Available since v3.4._
824      */
825     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
826         unchecked {
827             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
828             // benefit is lost if 'b' is also tested.
829             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
830             if (a == 0) return (true, 0);
831             uint256 c = a * b;
832             if (c / a != b) return (false, 0);
833             return (true, c);
834         }
835     }
836 
837     /**
838      * @dev Returns the division of two unsigned integers, with a division by zero flag.
839      *
840      * _Available since v3.4._
841      */
842     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
843         unchecked {
844             if (b == 0) return (false, 0);
845             return (true, a / b);
846         }
847     }
848 
849     /**
850      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
851      *
852      * _Available since v3.4._
853      */
854     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
855         unchecked {
856             if (b == 0) return (false, 0);
857             return (true, a % b);
858         }
859     }
860 
861     /**
862      * @dev Returns the addition of two unsigned integers, reverting on
863      * overflow.
864      *
865      * Counterpart to Solidity's `+` operator.
866      *
867      * Requirements:
868      *
869      * - Addition cannot overflow.
870      */
871     function add(uint256 a, uint256 b) internal pure returns (uint256) {
872         return a + b;
873     }
874 
875     /**
876      * @dev Returns the subtraction of two unsigned integers, reverting on
877      * overflow (when the result is negative).
878      *
879      * Counterpart to Solidity's `-` operator.
880      *
881      * Requirements:
882      *
883      * - Subtraction cannot overflow.
884      */
885     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
886         return a - b;
887     }
888 
889     /**
890      * @dev Returns the multiplication of two unsigned integers, reverting on
891      * overflow.
892      *
893      * Counterpart to Solidity's `*` operator.
894      *
895      * Requirements:
896      *
897      * - Multiplication cannot overflow.
898      */
899     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
900         return a * b;
901     }
902 
903     /**
904      * @dev Returns the integer division of two unsigned integers, reverting on
905      * division by zero. The result is rounded towards zero.
906      *
907      * Counterpart to Solidity's `/` operator.
908      *
909      * Requirements:
910      *
911      * - The divisor cannot be zero.
912      */
913     function div(uint256 a, uint256 b) internal pure returns (uint256) {
914         return a / b;
915     }
916 
917     /**
918      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
919      * reverting when dividing by zero.
920      *
921      * Counterpart to Solidity's `%` operator. This function uses a `revert`
922      * opcode (which leaves remaining gas untouched) while Solidity uses an
923      * invalid opcode to revert (consuming all remaining gas).
924      *
925      * Requirements:
926      *
927      * - The divisor cannot be zero.
928      */
929     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
930         return a % b;
931     }
932 
933     /**
934      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
935      * overflow (when the result is negative).
936      *
937      * CAUTION: This function is deprecated because it requires allocating memory for the error
938      * message unnecessarily. For custom revert reasons use {trySub}.
939      *
940      * Counterpart to Solidity's `-` operator.
941      *
942      * Requirements:
943      *
944      * - Subtraction cannot overflow.
945      */
946     function sub(
947         uint256 a,
948         uint256 b,
949         string memory errorMessage
950     ) internal pure returns (uint256) {
951         unchecked {
952             require(b <= a, errorMessage);
953             return a - b;
954         }
955     }
956 
957     /**
958      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
959      * division by zero. The result is rounded towards zero.
960      *
961      * Counterpart to Solidity's `/` operator. Note: this function uses a
962      * `revert` opcode (which leaves remaining gas untouched) while Solidity
963      * uses an invalid opcode to revert (consuming all remaining gas).
964      *
965      * Requirements:
966      *
967      * - The divisor cannot be zero.
968      */
969     function div(
970         uint256 a,
971         uint256 b,
972         string memory errorMessage
973     ) internal pure returns (uint256) {
974         unchecked {
975             require(b > 0, errorMessage);
976             return a / b;
977         }
978     }
979 
980     /**
981      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
982      * reverting with custom message when dividing by zero.
983      *
984      * CAUTION: This function is deprecated because it requires allocating memory for the error
985      * message unnecessarily. For custom revert reasons use {tryMod}.
986      *
987      * Counterpart to Solidity's `%` operator. This function uses a `revert`
988      * opcode (which leaves remaining gas untouched) while Solidity uses an
989      * invalid opcode to revert (consuming all remaining gas).
990      *
991      * Requirements:
992      *
993      * - The divisor cannot be zero.
994      */
995     function mod(
996         uint256 a,
997         uint256 b,
998         string memory errorMessage
999     ) internal pure returns (uint256) {
1000         unchecked {
1001             require(b > 0, errorMessage);
1002             return a % b;
1003         }
1004     }
1005 }
1006 
1007 // File: @openzeppelin/contracts/utils/Context.sol
1008 
1009 
1010 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1011 
1012 pragma solidity ^0.8.0;
1013 
1014 /**
1015  * @dev Provides information about the current execution context, including the
1016  * sender of the transaction and its data. While these are generally available
1017  * via msg.sender and msg.data, they should not be accessed in such a direct
1018  * manner, since when dealing with meta-transactions the account sending and
1019  * paying for execution may not be the actual sender (as far as an application
1020  * is concerned).
1021  *
1022  * This contract is only required for intermediate, library-like contracts.
1023  */
1024 abstract contract Context {
1025     function _msgSender() internal view virtual returns (address) {
1026         return msg.sender;
1027     }
1028 
1029     function _msgData() internal view virtual returns (bytes calldata) {
1030         return msg.data;
1031     }
1032 }
1033 
1034 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1035 
1036 
1037 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
1038 
1039 pragma solidity ^0.8.0;
1040 
1041 
1042 
1043 
1044 
1045 
1046 
1047 
1048 /**
1049  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1050  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1051  * {ERC721Enumerable}.
1052  */
1053 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1054     using Address for address;
1055     using Strings for uint256;
1056 
1057     // Token name
1058     string private _name;
1059 
1060     // Token symbol
1061     string private _symbol;
1062 
1063     // Mapping from token ID to owner address
1064     mapping(uint256 => address) private _owners;
1065 
1066     // Mapping owner address to token count
1067     mapping(address => uint256) private _balances;
1068 
1069     // Mapping from token ID to approved address
1070     mapping(uint256 => address) private _tokenApprovals;
1071 
1072     // Mapping from owner to operator approvals
1073     mapping(address => mapping(address => bool)) private _operatorApprovals;
1074 
1075     /**
1076      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1077      */
1078     constructor(string memory name_, string memory symbol_) {
1079         _name = name_;
1080         _symbol = symbol_;
1081     }
1082 
1083     /**
1084      * @dev See {IERC165-supportsInterface}.
1085      */
1086     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1087         return
1088             interfaceId == type(IERC721).interfaceId ||
1089             interfaceId == type(IERC721Metadata).interfaceId ||
1090             super.supportsInterface(interfaceId);
1091     }
1092 
1093     /**
1094      * @dev See {IERC721-balanceOf}.
1095      */
1096     function balanceOf(address owner) public view virtual override returns (uint256) {
1097         require(owner != address(0), "ERC721: balance query for the zero address");
1098         return _balances[owner];
1099     }
1100 
1101     /**
1102      * @dev See {IERC721-ownerOf}.
1103      */
1104     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1105         address owner = _owners[tokenId];
1106         require(owner != address(0), "ERC721: owner query for nonexistent token");
1107         return owner;
1108     }
1109 
1110     /**
1111      * @dev See {IERC721Metadata-name}.
1112      */
1113     function name() public view virtual override returns (string memory) {
1114         return _name;
1115     }
1116 
1117     /**
1118      * @dev See {IERC721Metadata-symbol}.
1119      */
1120     function symbol() public view virtual override returns (string memory) {
1121         return _symbol;
1122     }
1123 
1124     /**
1125      * @dev See {IERC721Metadata-tokenURI}.
1126      */
1127     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1128         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1129 
1130         string memory baseURI = _baseURI();
1131         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1132     }
1133 
1134     /**
1135      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1136      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1137      * by default, can be overriden in child contracts.
1138      */
1139     function _baseURI() internal view virtual returns (string memory) {
1140         return "";
1141     }
1142 
1143     /**
1144      * @dev See {IERC721-approve}.
1145      */
1146     function approve(address to, uint256 tokenId) public virtual override {
1147         address owner = ERC721.ownerOf(tokenId);
1148         require(to != owner, "ERC721: approval to current owner");
1149 
1150         require(
1151             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1152             "ERC721: approve caller is not owner nor approved for all"
1153         );
1154 
1155         _approve(to, tokenId);
1156     }
1157 
1158     /**
1159      * @dev See {IERC721-getApproved}.
1160      */
1161     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1162         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1163 
1164         return _tokenApprovals[tokenId];
1165     }
1166 
1167     /**
1168      * @dev See {IERC721-setApprovalForAll}.
1169      */
1170     function setApprovalForAll(address operator, bool approved) public virtual override {
1171         _setApprovalForAll(_msgSender(), operator, approved);
1172     }
1173 
1174     /**
1175      * @dev See {IERC721-isApprovedForAll}.
1176      */
1177     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1178         return _operatorApprovals[owner][operator];
1179     }
1180 
1181     /**
1182      * @dev See {IERC721-transferFrom}.
1183      */
1184     function transferFrom(
1185         address from,
1186         address to,
1187         uint256 tokenId
1188     ) public virtual override {
1189         //solhint-disable-next-line max-line-length
1190         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1191 
1192         _transfer(from, to, tokenId);
1193     }
1194 
1195     /**
1196      * @dev See {IERC721-safeTransferFrom}.
1197      */
1198     function safeTransferFrom(
1199         address from,
1200         address to,
1201         uint256 tokenId
1202     ) public virtual override {
1203         safeTransferFrom(from, to, tokenId, "");
1204     }
1205 
1206     /**
1207      * @dev See {IERC721-safeTransferFrom}.
1208      */
1209     function safeTransferFrom(
1210         address from,
1211         address to,
1212         uint256 tokenId,
1213         bytes memory _data
1214     ) public virtual override {
1215         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1216         _safeTransfer(from, to, tokenId, _data);
1217     }
1218 
1219     /**
1220      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1221      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1222      *
1223      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1224      *
1225      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1226      * implement alternative mechanisms to perform token transfer, such as signature-based.
1227      *
1228      * Requirements:
1229      *
1230      * - `from` cannot be the zero address.
1231      * - `to` cannot be the zero address.
1232      * - `tokenId` token must exist and be owned by `from`.
1233      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1234      *
1235      * Emits a {Transfer} event.
1236      */
1237     function _safeTransfer(
1238         address from,
1239         address to,
1240         uint256 tokenId,
1241         bytes memory _data
1242     ) internal virtual {
1243         _transfer(from, to, tokenId);
1244         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1245     }
1246 
1247     /**
1248      * @dev Returns whether `tokenId` exists.
1249      *
1250      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1251      *
1252      * Tokens start existing when they are minted (`_mint`),
1253      * and stop existing when they are burned (`_burn`).
1254      */
1255     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1256         return _owners[tokenId] != address(0);
1257     }
1258 
1259     /**
1260      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1261      *
1262      * Requirements:
1263      *
1264      * - `tokenId` must exist.
1265      */
1266     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1267         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1268         address owner = ERC721.ownerOf(tokenId);
1269         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1270     }
1271 
1272     /**
1273      * @dev Safely mints `tokenId` and transfers it to `to`.
1274      *
1275      * Requirements:
1276      *
1277      * - `tokenId` must not exist.
1278      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1279      *
1280      * Emits a {Transfer} event.
1281      */
1282     function _safeMint(address to, uint256 tokenId) internal virtual {
1283         _safeMint(to, tokenId, "");
1284     }
1285 
1286     /**
1287      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1288      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1289      */
1290     function _safeMint(
1291         address to,
1292         uint256 tokenId,
1293         bytes memory _data
1294     ) internal virtual {
1295         _mint(to, tokenId);
1296         require(
1297             _checkOnERC721Received(address(0), to, tokenId, _data),
1298             "ERC721: transfer to non ERC721Receiver implementer"
1299         );
1300     }
1301 
1302     /**
1303      * @dev Mints `tokenId` and transfers it to `to`.
1304      *
1305      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1306      *
1307      * Requirements:
1308      *
1309      * - `tokenId` must not exist.
1310      * - `to` cannot be the zero address.
1311      *
1312      * Emits a {Transfer} event.
1313      */
1314     function _mint(address to, uint256 tokenId) internal virtual {
1315         require(to != address(0), "ERC721: mint to the zero address");
1316         require(!_exists(tokenId), "ERC721: token already minted");
1317 
1318         _beforeTokenTransfer(address(0), to, tokenId);
1319 
1320         _balances[to] += 1;
1321         _owners[tokenId] = to;
1322 
1323         emit Transfer(address(0), to, tokenId);
1324     }
1325 
1326     /**
1327      * @dev Destroys `tokenId`.
1328      * The approval is cleared when the token is burned.
1329      *
1330      * Requirements:
1331      *
1332      * - `tokenId` must exist.
1333      *
1334      * Emits a {Transfer} event.
1335      */
1336     function _burn(uint256 tokenId) internal virtual {
1337         address owner = ERC721.ownerOf(tokenId);
1338 
1339         _beforeTokenTransfer(owner, address(0), tokenId);
1340 
1341         // Clear approvals
1342         _approve(address(0), tokenId);
1343 
1344         _balances[owner] -= 1;
1345         delete _owners[tokenId];
1346 
1347         emit Transfer(owner, address(0), tokenId);
1348     }
1349 
1350     /**
1351      * @dev Transfers `tokenId` from `from` to `to`.
1352      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1353      *
1354      * Requirements:
1355      *
1356      * - `to` cannot be the zero address.
1357      * - `tokenId` token must be owned by `from`.
1358      *
1359      * Emits a {Transfer} event.
1360      */
1361     function _transfer(
1362         address from,
1363         address to,
1364         uint256 tokenId
1365     ) internal virtual {
1366         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1367         require(to != address(0), "ERC721: transfer to the zero address");
1368 
1369         _beforeTokenTransfer(from, to, tokenId);
1370 
1371         // Clear approvals from the previous owner
1372         _approve(address(0), tokenId);
1373 
1374         _balances[from] -= 1;
1375         _balances[to] += 1;
1376         _owners[tokenId] = to;
1377 
1378         emit Transfer(from, to, tokenId);
1379     }
1380 
1381     /**
1382      * @dev Approve `to` to operate on `tokenId`
1383      *
1384      * Emits a {Approval} event.
1385      */
1386     function _approve(address to, uint256 tokenId) internal virtual {
1387         _tokenApprovals[tokenId] = to;
1388         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1389     }
1390 
1391     /**
1392      * @dev Approve `operator` to operate on all of `owner` tokens
1393      *
1394      * Emits a {ApprovalForAll} event.
1395      */
1396     function _setApprovalForAll(
1397         address owner,
1398         address operator,
1399         bool approved
1400     ) internal virtual {
1401         require(owner != operator, "ERC721: approve to caller");
1402         _operatorApprovals[owner][operator] = approved;
1403         emit ApprovalForAll(owner, operator, approved);
1404     }
1405 
1406     /**
1407      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1408      * The call is not executed if the target address is not a contract.
1409      *
1410      * @param from address representing the previous owner of the given token ID
1411      * @param to target address that will receive the tokens
1412      * @param tokenId uint256 ID of the token to be transferred
1413      * @param _data bytes optional data to send along with the call
1414      * @return bool whether the call correctly returned the expected magic value
1415      */
1416     function _checkOnERC721Received(
1417         address from,
1418         address to,
1419         uint256 tokenId,
1420         bytes memory _data
1421     ) private returns (bool) {
1422         if (to.isContract()) {
1423             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1424                 return retval == IERC721Receiver.onERC721Received.selector;
1425             } catch (bytes memory reason) {
1426                 if (reason.length == 0) {
1427                     revert("ERC721: transfer to non ERC721Receiver implementer");
1428                 } else {
1429                     assembly {
1430                         revert(add(32, reason), mload(reason))
1431                     }
1432                 }
1433             }
1434         } else {
1435             return true;
1436         }
1437     }
1438 
1439     /**
1440      * @dev Hook that is called before any token transfer. This includes minting
1441      * and burning.
1442      *
1443      * Calling conditions:
1444      *
1445      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1446      * transferred to `to`.
1447      * - When `from` is zero, `tokenId` will be minted for `to`.
1448      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1449      * - `from` and `to` are never both zero.
1450      *
1451      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1452      */
1453     function _beforeTokenTransfer(
1454         address from,
1455         address to,
1456         uint256 tokenId
1457     ) internal virtual {}
1458 }
1459 
1460 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1461 
1462 
1463 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1464 
1465 pragma solidity ^0.8.0;
1466 
1467 
1468 
1469 /**
1470  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1471  * enumerability of all the token ids in the contract as well as all token ids owned by each
1472  * account.
1473  */
1474 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1475     // Mapping from owner to list of owned token IDs
1476     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1477 
1478     // Mapping from token ID to index of the owner tokens list
1479     mapping(uint256 => uint256) private _ownedTokensIndex;
1480 
1481     // Array with all token ids, used for enumeration
1482     uint256[] private _allTokens;
1483 
1484     // Mapping from token id to position in the allTokens array
1485     mapping(uint256 => uint256) private _allTokensIndex;
1486 
1487     /**
1488      * @dev See {IERC165-supportsInterface}.
1489      */
1490     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1491         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1492     }
1493 
1494     /**
1495      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1496      */
1497     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1498         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1499         return _ownedTokens[owner][index];
1500     }
1501 
1502     /**
1503      * @dev See {IERC721Enumerable-totalSupply}.
1504      */
1505     function totalSupply() public view virtual override returns (uint256) {
1506         return _allTokens.length;
1507     }
1508 
1509     /**
1510      * @dev See {IERC721Enumerable-tokenByIndex}.
1511      */
1512     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1513         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1514         return _allTokens[index];
1515     }
1516 
1517     /**
1518      * @dev Hook that is called before any token transfer. This includes minting
1519      * and burning.
1520      *
1521      * Calling conditions:
1522      *
1523      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1524      * transferred to `to`.
1525      * - When `from` is zero, `tokenId` will be minted for `to`.
1526      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1527      * - `from` cannot be the zero address.
1528      * - `to` cannot be the zero address.
1529      *
1530      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1531      */
1532     function _beforeTokenTransfer(
1533         address from,
1534         address to,
1535         uint256 tokenId
1536     ) internal virtual override {
1537         super._beforeTokenTransfer(from, to, tokenId);
1538 
1539         if (from == address(0)) {
1540             _addTokenToAllTokensEnumeration(tokenId);
1541         } else if (from != to) {
1542             _removeTokenFromOwnerEnumeration(from, tokenId);
1543         }
1544         if (to == address(0)) {
1545             _removeTokenFromAllTokensEnumeration(tokenId);
1546         } else if (to != from) {
1547             _addTokenToOwnerEnumeration(to, tokenId);
1548         }
1549     }
1550 
1551     /**
1552      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1553      * @param to address representing the new owner of the given token ID
1554      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1555      */
1556     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1557         uint256 length = ERC721.balanceOf(to);
1558         _ownedTokens[to][length] = tokenId;
1559         _ownedTokensIndex[tokenId] = length;
1560     }
1561 
1562     /**
1563      * @dev Private function to add a token to this extension's token tracking data structures.
1564      * @param tokenId uint256 ID of the token to be added to the tokens list
1565      */
1566     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1567         _allTokensIndex[tokenId] = _allTokens.length;
1568         _allTokens.push(tokenId);
1569     }
1570 
1571     /**
1572      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1573      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1574      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1575      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1576      * @param from address representing the previous owner of the given token ID
1577      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1578      */
1579     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1580         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1581         // then delete the last slot (swap and pop).
1582 
1583         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1584         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1585 
1586         // When the token to delete is the last token, the swap operation is unnecessary
1587         if (tokenIndex != lastTokenIndex) {
1588             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1589 
1590             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1591             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1592         }
1593 
1594         // This also deletes the contents at the last position of the array
1595         delete _ownedTokensIndex[tokenId];
1596         delete _ownedTokens[from][lastTokenIndex];
1597     }
1598 
1599     /**
1600      * @dev Private function to remove a token from this extension's token tracking data structures.
1601      * This has O(1) time complexity, but alters the order of the _allTokens array.
1602      * @param tokenId uint256 ID of the token to be removed from the tokens list
1603      */
1604     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1605         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1606         // then delete the last slot (swap and pop).
1607 
1608         uint256 lastTokenIndex = _allTokens.length - 1;
1609         uint256 tokenIndex = _allTokensIndex[tokenId];
1610 
1611         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1612         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1613         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1614         uint256 lastTokenId = _allTokens[lastTokenIndex];
1615 
1616         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1617         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1618 
1619         // This also deletes the contents at the last position of the array
1620         delete _allTokensIndex[tokenId];
1621         _allTokens.pop();
1622     }
1623 }
1624 
1625 // File: @openzeppelin/contracts/access/Ownable.sol
1626 
1627 
1628 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1629 
1630 pragma solidity ^0.8.0;
1631 
1632 
1633 /**
1634  * @dev Contract module which provides a basic access control mechanism, where
1635  * there is an account (an owner) that can be granted exclusive access to
1636  * specific functions.
1637  *
1638  * By default, the owner account will be the one that deploys the contract. This
1639  * can later be changed with {transferOwnership}.
1640  *
1641  * This module is used through inheritance. It will make available the modifier
1642  * `onlyOwner`, which can be applied to your functions to restrict their use to
1643  * the owner.
1644  */
1645 abstract contract Ownable is Context {
1646     address private _owner;
1647 
1648     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1649 
1650     /**
1651      * @dev Initializes the contract setting the deployer as the initial owner.
1652      */
1653     constructor() {
1654         _transferOwnership(_msgSender());
1655     }
1656 
1657     /**
1658      * @dev Returns the address of the current owner.
1659      */
1660     function owner() public view virtual returns (address) {
1661         return _owner;
1662     }
1663 
1664     /**
1665      * @dev Throws if called by any account other than the owner.
1666      */
1667     modifier onlyOwner() {
1668         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1669         _;
1670     }
1671 
1672     /**
1673      * @dev Leaves the contract without owner. It will not be possible to call
1674      * `onlyOwner` functions anymore. Can only be called by the current owner.
1675      *
1676      * NOTE: Renouncing ownership will leave the contract without an owner,
1677      * thereby removing any functionality that is only available to the owner.
1678      */
1679     function renounceOwnership() public virtual onlyOwner {
1680         _transferOwnership(address(0));
1681     }
1682 
1683     /**
1684      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1685      * Can only be called by the current owner.
1686      */
1687     function transferOwnership(address newOwner) public virtual onlyOwner {
1688         require(newOwner != address(0), "Ownable: new owner is the zero address");
1689         _transferOwnership(newOwner);
1690     }
1691 
1692     /**
1693      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1694      * Internal function without access restriction.
1695      */
1696     function _transferOwnership(address newOwner) internal virtual {
1697         address oldOwner = _owner;
1698         _owner = newOwner;
1699         emit OwnershipTransferred(oldOwner, newOwner);
1700     }
1701 }
1702 
1703 // File: contracts/IDCard-ERC721.sol
1704 
1705 
1706 // Author: @Harry.XBT
1707 // ID Card NFT for PeachProject
1708 
1709 pragma solidity ^0.8.0;
1710 
1711 
1712 
1713 
1714 
1715 
1716 
1717 
1718 
1719 
1720 contract PeachProjectID is Ownable, ERC721Enumerable, ReentrancyGuard, IPeachProject, IPeachProjectAdmin, IOpenSeaCompatible {
1721     using Address for address;
1722     using Strings for uint256;
1723     using SafeMath for uint256;
1724 
1725     event PresaleActive(bool state);
1726     event SaleActive(bool state);
1727     event PresaleLimitChanged(uint256 limit);
1728 
1729     bool public saleIsActive;
1730     bool public presaleIsActive;
1731 
1732     uint256 public maxPurchaseQuantity;
1733     uint256 public maxMintableSupply;
1734     uint256 public maxAdminSupply;
1735     uint256 public MAX_TOKENS;
1736     uint256 public presaleLimit;
1737     uint256 public baseExtension;
1738     bytes32 public presaleRoot;
1739     uint256 public price;
1740 
1741     uint256 private _adminMinted = 0;
1742     uint256 private _publicMinted = 0;
1743 
1744     string private _contractURI;
1745     string private _tokenBaseURI;
1746     string private _tokenRevealedBaseURI;
1747 
1748     address payable public payments;
1749 
1750     mapping(address => uint256) private _presaleClaimedCount;
1751 
1752     constructor(
1753         string memory name,
1754         string memory symbol,
1755         address _payments
1756     ) ERC721(name, symbol) {
1757 
1758         saleIsActive = false;
1759         presaleIsActive = false;
1760         payments = payable(_payments);
1761         presaleLimit = 2; //Pending
1762 
1763         price = 50000000000000000; //0.05 ETH
1764         maxPurchaseQuantity = 2; 
1765         MAX_TOKENS = 450; 
1766         maxMintableSupply = 400; 
1767         maxAdminSupply = 50; 
1768 
1769         _contractURI = 'PENDING';
1770         _tokenBaseURI = 'PENDING';
1771         _tokenRevealedBaseURI = 'PENDING';
1772     }
1773 
1774     // IOpenSeaCompatible
1775 
1776     function contractURI() public view override returns (string memory) {
1777         return _contractURI;
1778     }
1779 
1780     function setContractURI(string memory contract_uri) external override onlyOwner {
1781         _contractURI = contract_uri;
1782     }
1783 
1784     //IPeachProjectMetadata
1785 
1786     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1787         require(_exists(tokenId), 'Token does not exist');
1788 
1789         string memory revealedBaseURI = _tokenRevealedBaseURI;
1790         return
1791             bytes(revealedBaseURI).length > 0
1792                 ? string(abi.encodePacked(revealedBaseURI, tokenId.toString()))
1793                 : _tokenBaseURI;
1794     }
1795 
1796     // IPeachProject
1797 
1798     function canMint(uint256 quantity) public view override returns (bool) {
1799         require(saleIsActive, "sale hasn't started");
1800         require(!presaleIsActive, 'only presale');
1801         require(totalSupply().add(quantity) <= MAX_TOKENS, 'quantity exceeds supply');
1802         require(_publicMinted.add(quantity) <= maxMintableSupply, 'quantity exceeds mintable');
1803         require(quantity <= maxPurchaseQuantity, 'quantity exceeds max');
1804 
1805         return true;
1806     }
1807 
1808     function canMintPresale(
1809         address owner,
1810         uint256 quantity,
1811         bytes32[] calldata proof
1812     ) public view override returns (bool) {
1813         require(!saleIsActive && presaleIsActive, "presale hasn't started");
1814         require(_verify(_leaf(owner), proof), 'invalid proof');
1815         require(totalSupply().add(quantity) <= MAX_TOKENS, 'quantity exceeds supply');
1816         require(_publicMinted.add(quantity) <= maxMintableSupply, 'quantity exceeds mintable');
1817         require(_presaleClaimedCount[owner].add(quantity) <= presaleLimit, 'quantity exceeds limit');
1818 
1819         return true;
1820     }
1821 
1822     function presaleMinted(address owner) external view override returns (uint256) {
1823         require(owner != address(0), 'black hole not allowed');
1824         return _presaleClaimedCount[owner];
1825     }
1826 
1827     function purchase(uint256 quantity) external payable override nonReentrant {
1828         require(canMint(quantity), 'cannot mint');
1829         require(msg.value >= price.mul(quantity), 'amount too low');
1830 
1831         for (uint256 i = 0; i < quantity; i++) {
1832             uint256 mintIndex = totalSupply();
1833             if (totalSupply() < MAX_TOKENS) {
1834                 _publicMinted += 1;
1835                 _safeMint(msg.sender, mintIndex);
1836             }
1837         }
1838     }
1839 
1840     function purchasePresale(uint256 quantity, bytes32[] calldata proof) external payable override nonReentrant {
1841         require(canMintPresale(msg.sender, quantity, proof), 'cannot mint presale');
1842         require(msg.value >= price.mul(quantity), 'amount too low');
1843 
1844         for (uint256 i = 0; i < quantity; i++) {
1845             uint256 mintIndex = totalSupply();
1846             if (totalSupply() < MAX_TOKENS) {
1847                 _publicMinted += 1;
1848                 _presaleClaimedCount[msg.sender] += 1;
1849                 _safeMint(msg.sender, mintIndex);
1850             }
1851         }
1852     }
1853 
1854     // IPeachProjectAdmin
1855 
1856     function mintToAddress(uint256 quantity, address to) external override onlyOwner {
1857         require(totalSupply().add(quantity) <= MAX_TOKENS, 'quantity exceeds supply');
1858         require(_adminMinted.add(quantity) <= maxAdminSupply, 'quantity exceeds mintable');
1859 
1860         for (uint256 i = 0; i < quantity; i++) {
1861             uint256 mintIndex = totalSupply();
1862             if (totalSupply() < MAX_TOKENS) {
1863                 _adminMinted += 1;
1864                 _safeMint(to, mintIndex);
1865             }
1866         }
1867     }
1868 
1869     function mintToAddresses(address[] calldata to) external override onlyOwner {
1870         require(totalSupply().add(to.length) <= MAX_TOKENS, 'quantity exceeds supply');
1871         require(_adminMinted.add(to.length) <= maxAdminSupply, 'quantity exceeds mintable');
1872 
1873         for (uint256 i = 0; i < to.length; i++) {
1874             uint256 mintIndex = totalSupply();
1875             if (totalSupply() < MAX_TOKENS) {
1876                 _adminMinted += 1;
1877                 _safeMint(to[i], mintIndex);
1878             }
1879         }
1880     }
1881 
1882     function setBaseURI(string memory baseURI) external override onlyOwner {
1883         _tokenBaseURI = baseURI;
1884     }
1885 
1886     function setBaseURIRevealed(string memory baseURI) external override onlyOwner {
1887         _tokenRevealedBaseURI = baseURI;
1888     }
1889 
1890     function setPresaleLimit(uint256 limit) external override onlyOwner {
1891         presaleLimit = limit;
1892         emit PresaleLimitChanged(presaleLimit);
1893     }
1894 
1895     function setPresaleRoot(bytes32 merkleRoot) external override onlyOwner {
1896         presaleRoot = merkleRoot;
1897     }
1898 
1899     function togglePresaleIsActive() external override onlyOwner {
1900         presaleIsActive = !presaleIsActive;
1901         emit PresaleActive(presaleIsActive);
1902     }
1903 
1904     function toggleSaleIsActive() external override onlyOwner {
1905         saleIsActive = !saleIsActive;
1906         emit SaleActive(saleIsActive);
1907     }
1908 
1909     function withdraw() public override onlyOwner {
1910         uint256 balance = address(this).balance;
1911         payable(msg.sender).transfer(balance);
1912     }
1913 
1914     function getTokenIds(address _owner) public view returns (uint256[] memory _tokensOfOwner) {
1915         _tokensOfOwner = new uint256[](balanceOf(_owner));
1916         for (uint256 i;i<balanceOf(_owner);i++){
1917             _tokensOfOwner[i] = tokenOfOwnerByIndex(_owner, i);
1918         }
1919       }
1920 
1921 
1922     // _internal
1923 
1924     function _leaf(address account) internal pure returns (bytes32) {
1925         return keccak256(abi.encodePacked(account));
1926     }
1927 
1928     function _verify(bytes32 leaf, bytes32[] memory proof) internal view returns (bool) {
1929         return MerkleProof.verify(proof, presaleRoot, leaf);
1930     }
1931 }