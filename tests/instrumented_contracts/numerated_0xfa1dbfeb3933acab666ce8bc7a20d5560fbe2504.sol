1 //SPDX-License-Identifier:MIT
2 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
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
47                 computedHash = _efficientHash(computedHash, proofElement);
48             } else {
49                 // Hash(current element of the proof + current computed hash)
50                 computedHash = _efficientHash(proofElement, computedHash);
51             }
52         }
53         return computedHash;
54     }
55 
56     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
57         assembly {
58             mstore(0x00, a)
59             mstore(0x20, b)
60             value := keccak256(0x00, 0x40)
61         }
62     }
63 }
64 
65 // File: contracts/Strings.sol
66 
67 
68 
69 pragma solidity ^0.8.0;
70 
71 /**
72  * @dev String operations.
73  */
74 library Strings {
75     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
76 
77     /**
78      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
79      */
80     function toString(uint256 value) internal pure returns (string memory) {
81         // Inspired by OraclizeAPI's implementation - MIT licence
82         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
83 
84         if (value == 0) {
85             return "0";
86         }
87         uint256 temp = value;
88         uint256 digits;
89         while (temp != 0) {
90             digits++;
91             temp /= 10;
92         }
93         bytes memory buffer = new bytes(digits);
94         while (value != 0) {
95             digits -= 1;
96             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
97             value /= 10;
98         }
99         return string(buffer);
100     }
101 
102     /**
103      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
104      */
105     function toHexString(uint256 value) internal pure returns (string memory) {
106         if (value == 0) {
107             return "0x00";
108         }
109         uint256 temp = value;
110         uint256 length = 0;
111         while (temp != 0) {
112             length++;
113             temp >>= 8;
114         }
115         return toHexString(value, length);
116     }
117 
118     /**
119      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
120      */
121     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
122         bytes memory buffer = new bytes(2 * length + 2);
123         buffer[0] = "0";
124         buffer[1] = "x";
125         for (uint256 i = 2 * length + 1; i > 1; --i) {
126             buffer[i] = _HEX_SYMBOLS[value & 0xf];
127             value >>= 4;
128         }
129         require(value == 0, "Strings: hex length insufficient");
130         return string(buffer);
131     }
132 }
133 
134 // File: contracts/Address.sol
135 
136 
137 
138 pragma solidity ^0.8.0;
139 
140 /**
141  * @dev Collection of functions related to the address type
142  */
143 library Address {
144     /**
145      * @dev Returns true if `account` is a contract.
146      *
147      * [IMPORTANT]
148      * ====
149      * It is unsafe to assume that an address for which this function returns
150      * false is an externally-owned account (EOA) and not a contract.
151      *
152      * Among others, `isContract` will return false for the following
153      * types of addresses:
154      *
155      *  - an externally-owned account
156      *  - a contract in construction
157      *  - an address where a contract will be created
158      *  - an address where a contract lived, but was destroyed
159      * ====
160      */
161     function isContract(address account) internal view returns (bool) {
162         // This method relies on extcodesize, which returns 0 for contracts in
163         // construction, since the code is only stored at the end of the
164         // constructor execution.
165 
166         uint256 size;
167         assembly {
168             size := extcodesize(account)
169         }
170         return size > 0;
171     }
172 
173     /**
174      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
175      * `recipient`, forwarding all available gas and reverting on errors.
176      *
177      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
178      * of certain opcodes, possibly making contracts go over the 2300 gas limit
179      * imposed by `transfer`, making them unable to receive funds via
180      * `transfer`. {sendValue} removes this limitation.
181      *
182      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
183      *
184      * IMPORTANT: because control is transferred to `recipient`, care must be
185      * taken to not create reentrancy vulnerabilities. Consider using
186      * {ReentrancyGuard} or the
187      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
188      */
189     function sendValue(address payable recipient, uint256 amount) internal {
190         require(address(this).balance >= amount, "Address: insufficient balance");
191 
192         (bool success, ) = recipient.call{value: amount}("");
193         require(success, "Address: unable to send value, recipient may have reverted");
194     }
195 
196     /**
197      * @dev Performs a Solidity function call using a low level `call`. A
198      * plain `call` is an unsafe replacement for a function call: use this
199      * function instead.
200      *
201      * If `target` reverts with a revert reason, it is bubbled up by this
202      * function (like regular Solidity function calls).
203      *
204      * Returns the raw returned data. To convert to the expected return value,
205      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
206      *
207      * Requirements:
208      *
209      * - `target` must be a contract.
210      * - calling `target` with `data` must not revert.
211      *
212      * _Available since v3.1._
213      */
214     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
215         return functionCall(target, data, "Address: low-level call failed");
216     }
217 
218     /**
219      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
220      * `errorMessage` as a fallback revert reason when `target` reverts.
221      *
222      * _Available since v3.1._
223      */
224     function functionCall(
225         address target,
226         bytes memory data,
227         string memory errorMessage
228     ) internal returns (bytes memory) {
229         return functionCallWithValue(target, data, 0, errorMessage);
230     }
231 
232     /**
233      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
234      * but also transferring `value` wei to `target`.
235      *
236      * Requirements:
237      *
238      * - the calling contract must have an ETH balance of at least `value`.
239      * - the called Solidity function must be `payable`.
240      *
241      * _Available since v3.1._
242      */
243     function functionCallWithValue(
244         address target,
245         bytes memory data,
246         uint256 value
247     ) internal returns (bytes memory) {
248         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
253      * with `errorMessage` as a fallback revert reason when `target` reverts.
254      *
255      * _Available since v3.1._
256      */
257     function functionCallWithValue(
258         address target,
259         bytes memory data,
260         uint256 value,
261         string memory errorMessage
262     ) internal returns (bytes memory) {
263         require(address(this).balance >= value, "Address: insufficient balance for call");
264         require(isContract(target), "Address: call to non-contract");
265 
266         (bool success, bytes memory returndata) = target.call{value: value}(data);
267         return _verifyCallResult(success, returndata, errorMessage);
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
272      * but performing a static call.
273      *
274      * _Available since v3.3._
275      */
276     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
277         return functionStaticCall(target, data, "Address: low-level static call failed");
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
282      * but performing a static call.
283      *
284      * _Available since v3.3._
285      */
286     function functionStaticCall(
287         address target,
288         bytes memory data,
289         string memory errorMessage
290     ) internal view returns (bytes memory) {
291         require(isContract(target), "Address: static call to non-contract");
292 
293         (bool success, bytes memory returndata) = target.staticcall(data);
294         return _verifyCallResult(success, returndata, errorMessage);
295     }
296 
297     /**
298      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
299      * but performing a delegate call.
300      *
301      * _Available since v3.4._
302      */
303     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
304         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
309      * but performing a delegate call.
310      *
311      * _Available since v3.4._
312      */
313     function functionDelegateCall(
314         address target,
315         bytes memory data,
316         string memory errorMessage
317     ) internal returns (bytes memory) {
318         require(isContract(target), "Address: delegate call to non-contract");
319 
320         (bool success, bytes memory returndata) = target.delegatecall(data);
321         return _verifyCallResult(success, returndata, errorMessage);
322     }
323 
324     function _verifyCallResult(
325         bool success,
326         bytes memory returndata,
327         string memory errorMessage
328     ) private pure returns (bytes memory) {
329         if (success) {
330             return returndata;
331         } else {
332             // Look for revert reason and bubble it up if present
333             if (returndata.length > 0) {
334                 // The easiest way to bubble the revert reason is using memory via assembly
335 
336                 assembly {
337                     let returndata_size := mload(returndata)
338                     revert(add(32, returndata), returndata_size)
339                 }
340             } else {
341                 revert(errorMessage);
342             }
343         }
344     }
345 }
346 // File: contracts/IERC721Receiver.sol
347 
348 
349 
350 pragma solidity ^0.8.0;
351 
352 /**
353  * @title ERC721 token receiver interface
354  * @dev Interface for any contract that wants to support safeTransfers
355  * from ERC721 asset contracts.
356  */
357 interface IERC721Receiver {
358     /**
359      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
360      * by `operator` from `from`, this function is called.
361      *
362      * It must return its Solidity selector to confirm the token transfer.
363      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
364      *
365      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
366      */
367     function onERC721Received(
368         address operator,
369         address from,
370         uint256 tokenId,
371         bytes calldata data
372     ) external returns (bytes4);
373 }
374 // File: contracts/IERC165.sol
375 
376 
377 pragma solidity ^0.8.0;
378 
379 interface IERC165 {
380     /// @notice Query if a contract implements an interface
381     /// @param interfaceID The interface identifier, as specified in ERC-165
382     /// @dev Interface identification is specified in ERC-165. This function
383     ///  uses less than 30,000 gas.
384     /// @return `true` if the contract implements `interfaceID` and
385     ///  `interfaceID` is not 0xffffffff, `false` otherwise
386     function supportsInterface(bytes4 interfaceID) external view returns (bool);
387 }
388 // File: contracts/ERC165.sol
389 
390 
391 pragma solidity ^0.8.0;
392 
393 
394 contract ERC165 is IERC165 {
395 
396     mapping(bytes4 => bool) private _supportedInterfaces;
397 
398     constructor() {
399         _registerInterface(bytes4(keccak256('supportsInterface(bytes4)')));
400     }
401 
402     function supportsInterface(bytes4 interfaceID) external view override virtual  returns (bool) {
403         return _supportedInterfaces[interfaceID];
404     }
405 
406     function _registerInterface(bytes4 interfaceId) internal {
407         require(interfaceId != 0xffffffff, 'Invalid interface request');
408         _supportedInterfaces[interfaceId] = true;
409     }
410 
411 
412 
413 }
414 // File: contracts/IERC721.sol
415 
416 
417 
418 pragma solidity ^0.8.0;
419 
420 
421 /**
422  * @dev Required interface of an ERC721 compliant contract.
423  */
424 interface IERC721 is IERC165 {
425     /**
426      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
427      */
428     event Transfer(
429         address indexed from,
430         address indexed to,
431         uint256 indexed tokenId
432     );
433 
434     /**
435      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
436      */
437     event Approval(
438         address indexed owner,
439         address indexed approved,
440         uint256 indexed tokenId
441     );
442 
443     /**
444      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
445      */
446     event ApprovalForAll(
447         address indexed owner,
448         address indexed operator,
449         bool approved
450     );
451 
452     /**
453      * @dev Returns the number of tokens in ``owner``'s account.
454      */
455     function balanceOf(address owner) external view returns (uint256 balance);
456 
457     /**
458      * @dev Returns the owner of the `tokenId` token.
459      *
460      * Requirements:
461      *
462      * - `tokenId` must exist.
463      */
464     function ownerOf(uint256 tokenId) external view returns (address owner);
465 
466     /**
467      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
468      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
469      *
470      * Requirements:
471      *
472      * - `from` cannot be the zero address.
473      * - `to` cannot be the zero address.
474      * - `tokenId` token must exist and be owned by `from`.
475      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
476      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
477      *
478      * Emits a {Transfer} event.
479      */
480     function safeTransferFrom(
481         address from,
482         address to,
483         uint256 tokenId
484     ) external;
485 
486     /**
487      * @dev Transfers `tokenId` token from `from` to `to`.
488      *
489      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
490      *
491      * Requirements:
492      *
493      * - `from` cannot be the zero address.
494      * - `to` cannot be the zero address.
495      * - `tokenId` token must be owned by `from`.
496      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
497      *
498      * Emits a {Transfer} event.
499      */
500     function transferFrom(
501         address from,
502         address to,
503         uint256 tokenId
504     ) external;
505 
506     /**
507      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
508      * The approval is cleared when the token is transferred.
509      *
510      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
511      *
512      * Requirements:
513      *
514      * - The caller must own the token or be an approved operator.
515      * - `tokenId` must exist.
516      *
517      * Emits an {Approval} event.
518      */
519     function approve(address to, uint256 tokenId) external;
520 
521     /**
522      * @dev Returns the account approved for `tokenId` token.
523      *
524      * Requirements:
525      *
526      * - `tokenId` must exist.
527      */
528     function getApproved(uint256 tokenId)
529         external
530         view
531         returns (address operator);
532 
533     /**
534      * @dev Approve or remove `operator` as an operator for the caller.
535      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
536      *
537      * Requirements:
538      *
539      * - The `operator` cannot be the caller.
540      *
541      * Emits an {ApprovalForAll} event.
542      */
543     function setApprovalForAll(address operator, bool _approved) external;
544 
545     /**
546      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
547      *
548      * See {setApprovalForAll}
549      */
550     function isApprovedForAll(address owner, address operator)
551         external
552         view
553         returns (bool);
554 
555     /**
556      * @dev Safely transfers `tokenId` token from `from` to `to`.
557      *
558      * Requirements:
559      *
560      * - `from` cannot be the zero address.
561      * - `to` cannot be the zero address.
562      * - `tokenId` token must exist and be owned by `from`.
563      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
564      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
565      *
566      * Emits a {Transfer} event.
567      */
568     function safeTransferFrom(
569         address from,
570         address to,
571         uint256 tokenId,
572         bytes calldata data
573     ) external;
574 }
575 
576 
577 // File: contracts/IERC721Enumerable.sol
578 
579 
580 
581 pragma solidity ^0.8.0;
582 
583 
584 /**
585  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
586  * @dev See https://eips.ethereum.org/EIPS/eip-721
587  */
588 interface IERC721Enumerable is IERC721 {
589     /**
590      * @dev Returns the total amount of tokens stored by the contract.
591      */
592     function totalSupply() external view returns (uint256);
593 
594     /**
595      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
596      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
597      */
598     function tokenOfOwnerByIndex(address owner, uint256 index)
599         external
600         view
601         returns (uint256 tokenId);
602 
603     /**
604      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
605      * Use along with {totalSupply} to enumerate all tokens.
606      */
607     function tokenByIndex(uint256 index) external view returns (uint256);
608 }
609 // File: contracts/IERC721Metadata.sol
610 
611 
612 
613 pragma solidity ^0.8.0;
614 
615 
616 /**
617  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
618  * @dev See https://eips.ethereum.org/EIPS/eip-721
619  */
620 interface IERC721Metadata is IERC721 {
621     /**
622      * @dev Returns the token collection name.
623      */
624     function name() external view returns (string memory);
625 
626     /**
627      * @dev Returns the token collection symbol.
628      */
629     function symbol() external view returns (string memory);
630 
631     /**
632      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
633      */
634     function tokenURI(uint256 tokenId) external view returns (string memory);
635 }
636 
637 
638 // File: contracts/ReentrancyGuard.sol
639 
640 
641 
642 pragma solidity ^0.8.0;
643 
644 /**
645  * @dev Contract module that helps prevent reentrant calls to a function.
646  *
647  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
648  * available, which can be applied to functions to make sure there are no nested
649  * (reentrant) calls to them.
650  *
651  * Note that because there is a single `nonReentrant` guard, functions marked as
652  * `nonReentrant` may not call one another. This can be worked around by making
653  * those functions `private`, and then adding `external` `nonReentrant` entry
654  * points to them.
655  *
656  * TIP: If you would like to learn more about reentrancy and alternative ways
657  * to protect against it, check out our blog post
658  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
659  */
660 abstract contract ReentrancyGuard {
661     // Booleans are more expensive than uint256 or any type that takes up a full
662     // word because each write operation emits an extra SLOAD to first read the
663     // slot's contents, replace the bits taken up by the boolean, and then write
664     // back. This is the compiler's defense against contract upgrades and
665     // pointer aliasing, and it cannot be disabled.
666 
667     // The values being non-zero value makes deployment a bit more expensive,
668     // but in exchange the refund on every call to nonReentrant will be lower in
669     // amount. Since refunds are capped to a percentage of the total
670     // transaction's gas, it is best to keep them low in cases like this one, to
671     // increase the likelihood of the full refund coming into effect.
672     uint256 private constant _NOT_ENTERED = 1;
673     uint256 private constant _ENTERED = 2;
674 
675     uint256 private _status;
676 
677     constructor() {
678         _status = _NOT_ENTERED;
679     }
680 
681     /**
682      * @dev Prevents a contract from calling itself, directly or indirectly.
683      * Calling a `nonReentrant` function from another `nonReentrant`
684      * function is not supported. It is possible to prevent this from happening
685      * by making the `nonReentrant` function external, and make it call a
686      * `private` function that does the actual work.
687      */
688     modifier nonReentrant() {
689         // On the first call to nonReentrant, _notEntered will be true
690         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
691 
692         // Any calls to nonReentrant after this point will fail
693         _status = _ENTERED;
694 
695         _;
696 
697         // By storing the original value once again, a refund is triggered (see
698         // https://eips.ethereum.org/EIPS/eip-2200)
699         _status = _NOT_ENTERED;
700     }
701 }
702 // File: contracts/Context.sol
703 
704 
705 
706 pragma solidity ^0.8.0;
707 
708 /*
709  * @dev Provides information about the current execution context, including the
710  * sender of the transaction and its data. While these are generally available
711  * via msg.sender and msg.data, they should not be accessed in such a direct
712  * manner, since when dealing with meta-transactions the account sending and
713  * paying for execution may not be the actual sender (as far as an application
714  * is concerned).
715  *
716  * This contract is only required for intermediate, library-like contracts.
717  */
718 abstract contract Context {
719     function _msgSender() internal view virtual returns (address) {
720         return msg.sender;
721     }
722 
723     function _msgData() internal view virtual returns (bytes calldata) {
724         return msg.data;
725     }
726 }
727 // File: contracts/ERC721A.sol
728 
729 
730 pragma solidity ^0.8.0;
731 
732 
733 
734 
735 
736 
737 
738 
739 
740 /**
741  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
742  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
743  *
744  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
745  *
746  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128. 
747  * uint128 is a number with a maximum value of 2^127-1 or 340,282,366,920,938,463,463,374,607,431,768,211,455.
748  *
749  * Does not support burning tokens to address(0).
750  */
751 contract ERC721A is
752     Context,
753     ERC165,
754     IERC721,
755     IERC721Metadata,
756     IERC721Enumerable
757 {
758     using Address for address;
759     using Strings for uint256;
760 
761     struct TokenOwnership {
762         address addr;
763         uint64 startTimestamp;
764     }
765 
766     struct AddressData {
767         uint128 balance;
768         uint128 numberMinted;
769     }
770 
771     uint256 private currentIndex = 0;
772 
773     uint256 internal immutable collectionSize;
774     uint256 internal immutable maxBatchSize;
775 
776     // Token name
777     string private _name;
778 
779     // Token symbol
780     string private _symbol;
781 
782     // Mapping from token ID to ownership details
783     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
784     mapping(uint256 => TokenOwnership) private _ownerships;
785 
786     // Mapping owner address to address data
787     mapping(address => AddressData) private _addressData;
788 
789     // Mapping from token ID to approved address
790     mapping(uint256 => address) private _tokenApprovals;
791 
792     // Mapping from owner to operator approvals
793     mapping(address => mapping(address => bool)) private _operatorApprovals;
794 
795     /**
796      * @dev
797      * `maxBatchSize` refers to how much a minter can mint at a time.
798      * `collectionSize_` refers to how many tokens are in the collection.
799      */
800     constructor(
801         string memory name_,
802         string memory symbol_,
803         uint256 maxBatchSize_,
804         uint256 collectionSize_
805     ) {
806         require(
807             collectionSize_ > 0,
808             "ERC721A: collection must have a nonzero supply"
809         );
810         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
811         _name = name_;
812         _symbol = symbol_;
813         maxBatchSize = maxBatchSize_;
814         collectionSize = collectionSize_;
815     }
816 
817     /**
818      * @dev See {IERC721Enumerable-totalSupply}.
819      */
820     function totalSupply() public view override returns (uint256) {
821         return currentIndex;
822     }
823 
824     /**
825      * @dev See {IERC721Enumerable-tokenByIndex}.
826      */
827     function tokenByIndex(uint256 index)
828         public
829         view
830         override
831         returns (uint256)
832     {
833         require(index < totalSupply(), "ERC721A: global index out of bounds");
834         return index;
835     }
836 
837     /**
838      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
839      * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
840      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
841      */
842     function tokenOfOwnerByIndex(address owner, uint256 index)
843         public
844         view
845         override
846         returns (uint256)
847     {
848         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
849         uint256 numMintedSoFar = totalSupply();
850         uint256 tokenIdsIdx = 0;
851         address currOwnershipAddr = address(0);
852         for (uint256 i = 0; i < numMintedSoFar; i++) {
853             TokenOwnership memory ownership = _ownerships[i];
854             if (ownership.addr != address(0)) {
855                 currOwnershipAddr = ownership.addr;
856             }
857             if (currOwnershipAddr == owner) {
858                 if (tokenIdsIdx == index) {
859                     return i;
860                 }
861                 tokenIdsIdx++;
862             }
863         }
864         revert("ERC721A: unable to get token of owner by index");
865     }
866 
867     /**
868      * @dev See {IERC165-supportsInterface}.
869      */
870     function supportsInterface(bytes4 interfaceId)
871         public
872         view
873         virtual
874         override(IERC165,ERC165)
875         returns (bool)
876     {
877         return
878             interfaceId == type(IERC721).interfaceId ||
879             interfaceId == type(IERC721Metadata).interfaceId ||
880             interfaceId == type(IERC721Enumerable).interfaceId ;
881     }
882 
883     /**
884      * @dev See {IERC721-balanceOf}.
885      */
886     function balanceOf(address owner) public view override returns (uint256) {
887         require(
888             owner != address(0),
889             "ERC721A: balance query for the zero address"
890         );
891         return uint256(_addressData[owner].balance);
892     }
893 
894     function _numberMinted(address owner) internal view returns (uint256) {
895         require(
896             owner != address(0),
897             "ERC721A: number minted query for the zero address"
898         );
899         return uint256(_addressData[owner].numberMinted);
900     }
901 
902     function ownershipOf(uint256 tokenId)
903         internal
904         view
905         returns (TokenOwnership memory)
906     {
907         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
908 
909         uint256 lowestTokenToCheck;
910         if (tokenId >= maxBatchSize) {
911             lowestTokenToCheck = tokenId - maxBatchSize + 1;
912         }
913 
914         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
915             TokenOwnership memory ownership = _ownerships[curr];
916             if (ownership.addr != address(0)) {
917                 return ownership;
918             }
919         }
920 
921         revert("ERC721A: unable to determine the owner of token");
922     }
923 
924     /**
925      * @dev See {IERC721-ownerOf}.
926      */
927     function ownerOf(uint256 tokenId) public view override returns (address) {
928         return ownershipOf(tokenId).addr;
929     }
930 
931     /**
932      * @dev See {IERC721Metadata-name}.
933      */
934     function name() public view virtual override returns (string memory) {
935         return _name;
936     }
937 
938     /**
939      * @dev See {IERC721Metadata-symbol}.
940      */
941     function symbol() public view virtual override returns (string memory) {
942         return _symbol;
943     }
944 
945     /**
946      * @dev See {IERC721Metadata-tokenURI}.
947      */
948     function tokenURI(uint256 tokenId)
949         public
950         view
951         virtual
952         override
953         returns (string memory)
954     {
955         require(
956             _exists(tokenId),
957             "ERC721Metadata: URI query for nonexistent token"
958         );
959 
960         string memory baseURI = _baseURI();
961         return
962             bytes(baseURI).length > 0
963                 ? string(abi.encodePacked(baseURI, tokenId.toString(),'.json'))
964                 : "";
965     }
966 
967     /**
968      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
969      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
970      * by default, can be overriden in child contracts.
971      */
972     function _baseURI() internal view virtual returns (string memory) {
973         return "";
974     }
975 
976     /**
977      * @dev See {IERC721-approve}.
978      */
979     function approve(address to, uint256 tokenId) public override {
980         address owner = ERC721A.ownerOf(tokenId);
981         require(to != owner, "ERC721A: approval to current owner");
982 
983         require(
984             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
985             "ERC721A: approve caller is not owner nor approved for all"
986         );
987 
988         _approve(to, tokenId, owner);
989     }
990 
991     /**
992      * @dev See {IERC721-getApproved}.
993      */
994     function getApproved(uint256 tokenId)
995         public
996         view
997         override
998         returns (address)
999     {
1000         require(
1001             _exists(tokenId),
1002             "ERC721A: approved query for nonexistent token"
1003         );
1004 
1005         return _tokenApprovals[tokenId];
1006     }
1007 
1008     /**
1009      * @dev See {IERC721-setApprovalForAll}.
1010      */
1011     function setApprovalForAll(address operator, bool approved)
1012         public
1013         override
1014     {
1015         require(operator != _msgSender(), "ERC721A: approve to caller");
1016 
1017         _operatorApprovals[_msgSender()][operator] = approved;
1018         emit ApprovalForAll(_msgSender(), operator, approved);
1019     }
1020 
1021     /**
1022      * @dev See {IERC721-isApprovedForAll}.
1023      */
1024     function isApprovedForAll(address owner, address operator)
1025         public
1026         view
1027         virtual
1028         override
1029         returns (bool)
1030     {
1031         return _operatorApprovals[owner][operator];
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-transferFrom}.
1036      */
1037     function transferFrom(
1038         address from,
1039         address to,
1040         uint256 tokenId
1041     ) public override {
1042         _transfer(from, to, tokenId);
1043     }
1044 
1045     /**
1046      * @dev See {IERC721-safeTransferFrom}.
1047      */
1048     function safeTransferFrom(
1049         address from,
1050         address to,
1051         uint256 tokenId
1052     ) public override {
1053         safeTransferFrom(from, to, tokenId, "");
1054     }
1055 
1056     /**
1057      * @dev See {IERC721-safeTransferFrom}.
1058      */
1059     function safeTransferFrom(
1060         address from,
1061         address to,
1062         uint256 tokenId,
1063         bytes memory _data
1064     ) public override {
1065         _transfer(from, to, tokenId);
1066         require(
1067             _checkOnERC721Received(from, to, tokenId, _data),
1068             "ERC721A: transfer to non ERC721Receiver implementer"
1069         );
1070     }
1071 
1072     /**
1073      * @dev Returns whether `tokenId` exists.
1074      *
1075      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1076      *
1077      * Tokens start existing when they are minted (`_mint`),
1078      */
1079     function _exists(uint256 tokenId) internal view returns (bool) {
1080         return tokenId < currentIndex;
1081     }
1082 
1083     function _safeMint(address to, uint256 quantity) internal {
1084         _safeMint(to, quantity, "");
1085     }
1086 
1087     /**
1088      * @dev Mints `quantity` tokens and transfers them to `to`.
1089      *
1090      * Requirements:
1091      *
1092      * - there must be `quantity` tokens remaining unminted in the total collection.
1093      * - `to` cannot be the zero address.
1094      * - `quantity` cannot be larger than the max batch size.
1095      *
1096      * Emits a {Transfer} event.
1097      */
1098     function _safeMint(
1099         address to,
1100         uint256 quantity,
1101         bytes memory _data
1102     ) internal {
1103         uint256 startTokenId = currentIndex;
1104         require(to != address(0), "ERC721A: mint to the zero address");
1105         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1106         require(!_exists(startTokenId), "ERC721A: token already minted");
1107         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1108 
1109         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1110 
1111         AddressData memory addressData = _addressData[to];
1112         _addressData[to] = AddressData(
1113             addressData.balance + uint128(quantity),
1114             addressData.numberMinted + uint128(quantity)
1115         );
1116         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1117 
1118         uint256 updatedIndex = startTokenId;
1119 
1120         for (uint256 i = 0; i < quantity; i++) {
1121             emit Transfer(address(0), to, updatedIndex);
1122             require(
1123                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1124                 "ERC721A: transfer to non ERC721Receiver implementer"
1125             );
1126             updatedIndex++;
1127         }
1128 
1129         currentIndex = updatedIndex;
1130         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1131     }
1132 
1133     /**
1134      * @dev Transfers `tokenId` from `from` to `to`.
1135      *
1136      * Requirements:
1137      *
1138      * - `to` cannot be the zero address.
1139      * - `tokenId` token must be owned by `from`.
1140      *
1141      * Emits a {Transfer} event.
1142      */
1143     function _transfer(
1144         address from,
1145         address to,
1146         uint256 tokenId
1147     ) private {
1148         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1149 
1150         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1151             getApproved(tokenId) == _msgSender() ||
1152             isApprovedForAll(prevOwnership.addr, _msgSender()));
1153 
1154         require(
1155             isApprovedOrOwner,
1156             "ERC721A: transfer caller is not owner nor approved"
1157         );
1158 
1159         require(
1160             prevOwnership.addr == from,
1161             "ERC721A: transfer from incorrect owner"
1162         );
1163         require(to != address(0), "ERC721A: transfer to the zero address");
1164 
1165         _beforeTokenTransfers(from, to, tokenId, 1);
1166 
1167         // Clear approvals from the previous owner
1168         _approve(address(0), tokenId, prevOwnership.addr);
1169 
1170         _addressData[from].balance -= 1;
1171         _addressData[to].balance += 1;
1172         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1173 
1174         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1175         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1176         uint256 nextTokenId = tokenId + 1;
1177         if (_ownerships[nextTokenId].addr == address(0)) {
1178             if (_exists(nextTokenId)) {
1179                 _ownerships[nextTokenId] = TokenOwnership(
1180                     prevOwnership.addr,
1181                     prevOwnership.startTimestamp
1182                 );
1183             }
1184         }
1185 
1186         emit Transfer(from, to, tokenId);
1187         _afterTokenTransfers(from, to, tokenId, 1);
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
1204     uint256 public nextOwnerToExplicitlySet = 0;
1205 
1206     /**
1207      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1208      */
1209     function _setOwnersExplicit(uint256 quantity) internal {
1210         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1211         require(quantity > 0, "quantity must be nonzero");
1212         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1213         if (endIndex > collectionSize - 1) {
1214             endIndex = collectionSize - 1;
1215         }
1216         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1217         require(_exists(endIndex), "not enough minted yet for this cleanup");
1218         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1219             if (_ownerships[i].addr == address(0)) {
1220                 TokenOwnership memory ownership = ownershipOf(i);
1221                 _ownerships[i] = TokenOwnership(
1222                     ownership.addr,
1223                     ownership.startTimestamp
1224                 );
1225             }
1226         }
1227         nextOwnerToExplicitlySet = endIndex + 1;
1228     }
1229 
1230     /**
1231      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1232      * The call is not executed if the target address is not a contract.
1233      *
1234      * @param from address representing the previous owner of the given token ID
1235      * @param to target address that will receive the tokens
1236      * @param tokenId uint256 ID of the token to be transferred
1237      * @param _data bytes optional data to send along with the call
1238      * @return bool whether the call correctly returned the expected magic value
1239      */
1240     function _checkOnERC721Received(
1241         address from,
1242         address to,
1243         uint256 tokenId,
1244         bytes memory _data
1245     ) private returns (bool) {
1246         if (to.isContract()) {
1247             try
1248                 IERC721Receiver(to).onERC721Received(
1249                     _msgSender(),
1250                     from,
1251                     tokenId,
1252                     _data
1253                 )
1254             returns (bytes4 retval) {
1255                 return retval == IERC721Receiver(to).onERC721Received.selector;
1256             } catch (bytes memory reason) {
1257                 if (reason.length == 0) {
1258                     revert(
1259                         "ERC721A: transfer to non ERC721Receiver implementer"
1260                     );
1261                 } else {
1262                     assembly {
1263                         revert(add(32, reason), mload(reason))
1264                     }
1265                 }
1266             }
1267         } else {
1268             return true;
1269         }
1270     }
1271 
1272     /**
1273      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1274      *
1275      * startTokenId - the first token id to be transferred
1276      * quantity - the amount to be transferred
1277      *
1278      * Calling conditions:
1279      *
1280      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1281      * transferred to `to`.
1282      * - When `from` is zero, `tokenId` will be minted for `to`.
1283      */
1284     function _beforeTokenTransfers(
1285         address from,
1286         address to,
1287         uint256 startTokenId,
1288         uint256 quantity
1289     ) internal virtual {}
1290 
1291     /**
1292      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1293      * minting.
1294      *
1295      * startTokenId - the first token id to be transferred
1296      * quantity - the amount to be transferred
1297      *
1298      * Calling conditions:
1299      *
1300      * - when `from` and `to` are both non-zero.
1301      * - `from` and `to` are never both zero.
1302      */
1303     function _afterTokenTransfers(
1304         address from,
1305         address to,
1306         uint256 startTokenId,
1307         uint256 quantity
1308     ) internal virtual {}
1309 }
1310 // File: contracts/Ownable.sol
1311 
1312 
1313 
1314 pragma solidity ^0.8.0;
1315 
1316 
1317 /**
1318  * @dev Contract module which provides a basic access control mechanism, where
1319  * there is an account (an owner) that can be granted exclusive access to
1320  * specific functions.
1321  *
1322  * By default, the owner account will be the one that deploys the contract. This
1323  * can later be changed with {transferOwnership}.
1324  *
1325  * This module is used through inheritance. It will make available the modifier
1326  * `onlyOwner`, which can be applied to your functions to restrict their use to
1327  * the owner.
1328  */
1329 abstract contract Ownable is Context {
1330     address private _owner;
1331 
1332     event OwnershipTransferred(
1333         address indexed previousOwner,
1334         address indexed newOwner
1335     );
1336 
1337     /**
1338      * @dev Initializes the contract setting the deployer as the initial owner.
1339      */
1340     constructor() {
1341         _setOwner(_msgSender());
1342     }
1343 
1344     /**
1345      * @dev Returns the address of the current owner.
1346      */
1347     function owner() public view virtual returns (address) {
1348         return _owner;
1349     }
1350 
1351     /**
1352      * @dev Throws if called by any account other than the owner.
1353      */
1354     modifier onlyOwner() {
1355         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1356         _;
1357     }
1358 
1359     /**
1360      * @dev Leaves the contract without owner. It will not be possible to call
1361      * `onlyOwner` functions anymore. Can only be called by the current owner.
1362      *
1363      * NOTE: Renouncing ownership will leave the contract without an owner,
1364      * thereby removing any functionality that is only available to the owner.
1365      */
1366     function renounceOwnership() public virtual onlyOwner {
1367         _setOwner(address(0));
1368     }
1369 
1370     /**
1371      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1372      * Can only be called by the current owner.
1373      */
1374     function transferOwnership(address newOwner) public virtual onlyOwner {
1375         require(
1376             newOwner != address(0),
1377             "Ownable: new owner is the zero address"
1378         );
1379         _setOwner(newOwner);
1380     }
1381 
1382     function _setOwner(address newOwner) private {
1383         address oldOwner = _owner;
1384         _owner = newOwner;
1385         emit OwnershipTransferred(oldOwner, newOwner);
1386     }
1387 }
1388 // File: contracts/CryptoBeauties.sol
1389 
1390 
1391 
1392 //\_________                            __            __________                          __   .__                 
1393 //\_   ___ \ _______  ___.__.______  _/  |_   ____   \______   \  ____  _____    __ __ _/  |_ |__|  ____    ______
1394 ///    \  \/ \_  __ \<   |  |\____ \ \   __\ /  _ \   |    |  _/_/ __ \ \__  \  |  |  \\   __\|  |_/ __ \  /  ___/
1395 //\     \____ |  | \/ \___  ||  |_> > |  |  (  <_> )  |    |   \\  ___/  / __ \_|  |  / |  |  |  |\  ___/  \___ \ 
1396 // \______  / |__|    / ____||   __/  |__|   \____/   |______  / \___  >(____  /|____/  |__|  |__| \___  >/____  >
1397  //       \/          \/     |__|                            \/      \/      \/                        \/      \/ 
1398 
1399 
1400 
1401 pragma solidity ^0.8.0;
1402 
1403 
1404 
1405 
1406 
1407 
1408 contract CryptoBeauties is Ownable, ERC721A, ReentrancyGuard {
1409     uint256 public amountForDevsRemaining;
1410     uint256 public freeRemaining; 
1411     uint256 public constant mintPrice = 0.029 ether;
1412 
1413     bytes32 private _freeMintRoot = "INSERT ROOT HERE";
1414     bytes32 private _whitelistRoot = "INSERT ROOT HERE";
1415     
1416     address public Promoter = 0x414508c939B0B78347a22d1F2dE5A7747C1426A5;
1417     address public Developer = 0x64d556cAae3eD6Df460F9CA7A93470722D04bE05;
1418     address public DAO = 0x402881BAd73d3932C2472Ab0453E0b03B32C52F0;
1419     address public Project = 0x421b0B0603fD45719B480CF71670EC00aE64b309;
1420 
1421     mapping(address => bool) public freeMintUsed;
1422     mapping(address => uint256) public whitelistMintsUsed;
1423 
1424     constructor( 
1425         uint256 maxBatchSize_,
1426         uint256 collectionSize_, 
1427         uint256 amountForFreeList_, 
1428         uint256 amountForDevs_
1429     ) ERC721A("CryptoBeauties", "CRYPTOBEAUTIES", maxBatchSize_, collectionSize_) {
1430         freeRemaining = amountForFreeList_; 
1431         amountForDevsRemaining = amountForDevs_;
1432 
1433         require(
1434             amountForFreeList_ <= collectionSize_, "Collection is not large enough."
1435         );
1436     }
1437 
1438     modifier callerIsUser() {
1439         require(tx.origin == msg.sender, "Caller is another contract."); 
1440         _;
1441     }
1442 
1443     //Status of Sale that is going on.
1444 
1445     enum SaleState {
1446         Paused, // 0
1447         Presale, // 1
1448         Public // 2
1449     }
1450 
1451     SaleState public saleState;
1452 
1453     //Merkle Implementation for ease of access
1454 
1455     function _verifyFreeMintStatus(address _account, bytes32[] calldata _merkleProof) private view returns (bool){
1456         bytes32 node = keccak256(abi.encodePacked(_account));
1457         return MerkleProof.verify(_merkleProof, _freeMintRoot, node); 
1458     }
1459 
1460     function _verifyWhitelistStatus(address _account, bytes32[] calldata _merkleProof) private view returns (bool) {
1461         bytes32 node = keccak256(abi.encodePacked(_account)); 
1462         return MerkleProof.verify(_merkleProof, _whitelistRoot, node); 
1463     }
1464 
1465     // Start of whitelist and free mint implementation
1466 
1467     function FreeWhitelistMint (uint256 _beautyAmount, bytes32[] calldata _merkleProof) external payable callerIsUser {
1468         require(_beautyAmount > 0);
1469         require(saleState == SaleState.Presale, "Presale has not begun yet!");
1470         require(whitelistMintsUsed[msg.sender] + _beautyAmount < 6, "Amount exceeds your allocation.");
1471         require(totalSupply() + _beautyAmount + amountForDevsRemaining <= collectionSize, "Exceeds max supply.");
1472         require(_verifyFreeMintStatus(msg.sender, _merkleProof), "Address not on Whitelist.");
1473 
1474         if (freeMintUsed[msg.sender] == false && freeRemaining != 0) {
1475             require(msg.value == mintPrice * (_beautyAmount - 1), "Incorrect ETH amount.");
1476             freeMintUsed[msg.sender] = true;
1477             freeRemaining -= 1;
1478     }
1479         else {
1480             require(msg.value == mintPrice * _beautyAmount, "Incorrect ETH amount.");
1481     }
1482 
1483         whitelistMintsUsed[msg.sender] += _beautyAmount;
1484 
1485         _safeMint(msg.sender, _beautyAmount);
1486 }
1487 
1488     function WhiteListMint(uint256 _beautyAmount, bytes32[] calldata _merkleProof) external payable callerIsUser {
1489         require(_beautyAmount > 0);
1490         require(saleState == SaleState.Presale, "Presale has not begun yet!");
1491         require(whitelistMintsUsed[msg.sender] + _beautyAmount < 6, "Amount exceeds your allocation.");
1492         require(totalSupply() + _beautyAmount + amountForDevsRemaining <= collectionSize, "Exceeds max supply.");
1493         require(_verifyWhitelistStatus(msg.sender, _merkleProof), "Address not on Whitelist.");
1494         require(msg.value == mintPrice * _beautyAmount, "Incorrect ETH amount.");
1495 
1496         whitelistMintsUsed[msg.sender] += _beautyAmount;
1497 
1498         _safeMint(msg.sender, _beautyAmount);
1499 }
1500 
1501     //Owner Mint function
1502 
1503     function AllowOwnerMint(uint256 _beautyAmount) external onlyOwner {
1504         require(_beautyAmount > 0);
1505         require(_beautyAmount <= amountForDevsRemaining, "Not Enough Dev Tokens left");
1506         amountForDevsRemaining -= _beautyAmount;
1507         require(totalSupply() + _beautyAmount <= collectionSize, "Reached Max Supply.");
1508         _safeMint(msg.sender, _beautyAmount); 
1509     }
1510 
1511     function publicSaleMint(uint256 _beautyAmount) external payable callerIsUser {
1512         require(_beautyAmount > 0); 
1513         require(saleState == SaleState.Public, "Presale is still active!");
1514         require(msg.value == mintPrice * _beautyAmount, "Please send more ETH!");
1515         require(totalSupply() + _beautyAmount + amountForDevsRemaining <= collectionSize, "Reached Max Supply.");
1516 
1517         _safeMint(msg.sender, _beautyAmount); 
1518     }
1519 
1520     function setRootFreeList(bytes32 _freeRoot) external onlyOwner {
1521         _freeMintRoot = _freeRoot; 
1522     }
1523 
1524     function setRootWL(bytes32 _rootWL) external onlyOwner {
1525         _whitelistRoot = _rootWL; 
1526     }
1527 
1528     function setSaleState(SaleState _newState) external onlyOwner {
1529         saleState = _newState;
1530     }
1531 
1532     //Metadata URI
1533 
1534     string private _baseTokenURI = "https://ipfs.cryptobeauties.io/metadata/";
1535 
1536     function _baseURI() internal view virtual override returns (string memory) {
1537         return _baseTokenURI;
1538     }
1539 
1540     function setupBaseURI(string calldata _baseURIz) external onlyOwner {
1541         _baseTokenURI = _baseURIz;
1542     }
1543 
1544     // Withdrawal functions
1545 
1546     function setWithdrawAddress(address _DAO, address _Promoter, address _Developer, address _Project ) external onlyOwner {
1547     DAO = _DAO;
1548     Promoter = _Promoter;
1549     Developer = _Developer;
1550     Project = _Project;
1551 
1552     }
1553 
1554     function withdrawMoney() external onlyOwner nonReentrant {
1555     uint256 balance = address(this).balance;
1556     uint256 toPartner = 405*balance/1000;
1557     uint256 toDAO = 14*balance/100;
1558     uint256 toProject = 4*balance/100;
1559     (bool sent1,) = payable(Promoter).call{value: toPartner}("");
1560     (bool sent2,) = payable(Developer).call{value: toPartner}("");
1561     (bool sent3,) = payable(DAO).call{value: toDAO}("");
1562     (bool sent4,) = payable(Project).call{value: toProject}("");
1563     require(sent1 && sent2 && sent3 && sent4, "Failed to send Ether");
1564   
1565     }
1566 
1567     function withdrawFinal() external onlyOwner nonReentrant {
1568         uint256 balance = address(this).balance;
1569         uint256 toPartner = 405*balance/1000;
1570         uint256 toDAO = 14*balance/100;
1571         uint256 toOwner = balance - 2*toPartner - toDAO;
1572         (bool pt, ) = payable(Promoter).call{value: toPartner}("");
1573         (bool dv, ) = payable(Developer).call{value: toPartner}("");
1574         (bool da, ) = payable(DAO).call{value: toDAO}("");
1575         (bool os, ) = payable(msg.sender).call{value: toOwner}("");
1576         require(pt && dv && da && os, "Failed to send Ether");
1577     }
1578 
1579 
1580     function setOwnersExplicit(uint256 quantity)
1581         external
1582         onlyOwner
1583     {
1584         _setOwnersExplicit(quantity);
1585     }
1586 
1587 
1588 
1589 
1590     function getOwnershipData(uint256 tokenId)
1591         external
1592         view
1593         returns (TokenOwnership memory)
1594     {
1595         return ownershipOf(tokenId);
1596     }
1597 }