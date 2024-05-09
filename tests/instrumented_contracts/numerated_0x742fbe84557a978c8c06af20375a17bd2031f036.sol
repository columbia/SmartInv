1 // SPDX-License-Identifier: MIT
2 //   _____          __  __          _____ 
3 //  |_   _|   /\   |  \/  |   /\   |_   _|
4 //    | |    /  \  | \  / |  /  \    | |  
5 //    | |   / /\ \ | |\/| | / /\ \   | |  
6 //   _| |_ / ____ \| |  | |/ ____ \ _| |_ 
7 //  |_____/_/    \_\_|  |_/_/    \_\_____|
8 // 
9 
10 // File: openzeppelin-solidity/contracts/utils/Strings.sol
11 
12 
13 
14 pragma solidity ^0.8.0;
15 
16 /**
17  * @dev String operations.
18  */
19 library Strings {
20     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
21 
22     /**
23      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
24      */
25     function toString(uint256 value) internal pure returns (string memory) {
26         // Inspired by OraclizeAPI's implementation - MIT licence
27         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
28 
29         if (value == 0) {
30             return "0";
31         }
32         uint256 temp = value;
33         uint256 digits;
34         while (temp != 0) {
35             digits++;
36             temp /= 10;
37         }
38         bytes memory buffer = new bytes(digits);
39         while (value != 0) {
40             digits -= 1;
41             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
42             value /= 10;
43         }
44         return string(buffer);
45     }
46 
47     /**
48      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
49      */
50     function toHexString(uint256 value) internal pure returns (string memory) {
51         if (value == 0) {
52             return "0x00";
53         }
54         uint256 temp = value;
55         uint256 length = 0;
56         while (temp != 0) {
57             length++;
58             temp >>= 8;
59         }
60         return toHexString(value, length);
61     }
62 
63     /**
64      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
65      */
66     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
67         bytes memory buffer = new bytes(2 * length + 2);
68         buffer[0] = "0";
69         buffer[1] = "x";
70         for (uint256 i = 2 * length + 1; i > 1; --i) {
71             buffer[i] = _HEX_SYMBOLS[value & 0xf];
72             value >>= 4;
73         }
74         require(value == 0, "Strings: hex length insufficient");
75         return string(buffer);
76     }
77 }
78 
79 // File: openzeppelin-solidity/contracts/utils/Address.sol
80 
81 
82 
83 pragma solidity ^0.8.0;
84 
85 /**
86  * @dev Collection of functions related to the address type
87  */
88 library Address {
89     /**
90      * @dev Returns true if `account` is a contract.
91      *
92      * [IMPORTANT]
93      * ====
94      * It is unsafe to assume that an address for which this function returns
95      * false is an externally-owned account (EOA) and not a contract.
96      *
97      * Among others, `isContract` will return false for the following
98      * types of addresses:
99      *
100      *  - an externally-owned account
101      *  - a contract in construction
102      *  - an address where a contract will be created
103      *  - an address where a contract lived, but was destroyed
104      * ====
105      */
106     function isContract(address account) internal view returns (bool) {
107         // This method relies on extcodesize, which returns 0 for contracts in
108         // construction, since the code is only stored at the end of the
109         // constructor execution.
110 
111         uint256 size;
112         assembly {
113             size := extcodesize(account)
114         }
115         return size > 0;
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
298 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
299 
300 
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
327 // File: openzeppelin-solidity/contracts/utils/introspection/IERC165.sol
328 
329 
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
354 // File: openzeppelin-solidity/contracts/utils/introspection/ERC165.sol
355 
356 
357 
358 pragma solidity ^0.8.0;
359 
360 
361 /**
362  * @dev Implementation of the {IERC165} interface.
363  *
364  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
365  * for the additional interface id that will be supported. For example:
366  *
367  * ```solidity
368  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
369  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
370  * }
371  * ```
372  *
373  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
374  */
375 abstract contract ERC165 is IERC165 {
376     /**
377      * @dev See {IERC165-supportsInterface}.
378      */
379     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
380         return interfaceId == type(IERC165).interfaceId;
381     }
382 }
383 
384 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
385 
386 
387 
388 pragma solidity ^0.8.0;
389 
390 
391 /**
392  * @dev Required interface of an ERC721 compliant contract.
393  */
394 interface IERC721 is IERC165 {
395     /**
396      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
397      */
398     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
399 
400     /**
401      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
402      */
403     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
404 
405     /**
406      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
407      */
408     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
409 
410     /**
411      * @dev Returns the number of tokens in ``owner``'s account.
412      */
413     function balanceOf(address owner) external view returns (uint256 balance);
414 
415     /**
416      * @dev Returns the owner of the `tokenId` token.
417      *
418      * Requirements:
419      *
420      * - `tokenId` must exist.
421      */
422     function ownerOf(uint256 tokenId) external view returns (address owner);
423 
424     /**
425      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
426      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
427      *
428      * Requirements:
429      *
430      * - `from` cannot be the zero address.
431      * - `to` cannot be the zero address.
432      * - `tokenId` token must exist and be owned by `from`.
433      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
434      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
435      *
436      * Emits a {Transfer} event.
437      */
438     function safeTransferFrom(
439         address from,
440         address to,
441         uint256 tokenId
442     ) external;
443 
444     /**
445      * @dev Transfers `tokenId` token from `from` to `to`.
446      *
447      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
448      *
449      * Requirements:
450      *
451      * - `from` cannot be the zero address.
452      * - `to` cannot be the zero address.
453      * - `tokenId` token must be owned by `from`.
454      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
455      *
456      * Emits a {Transfer} event.
457      */
458     function transferFrom(
459         address from,
460         address to,
461         uint256 tokenId
462     ) external;
463 
464     /**
465      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
466      * The approval is cleared when the token is transferred.
467      *
468      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
469      *
470      * Requirements:
471      *
472      * - The caller must own the token or be an approved operator.
473      * - `tokenId` must exist.
474      *
475      * Emits an {Approval} event.
476      */
477     function approve(address to, uint256 tokenId) external;
478 
479     /**
480      * @dev Returns the account approved for `tokenId` token.
481      *
482      * Requirements:
483      *
484      * - `tokenId` must exist.
485      */
486     function getApproved(uint256 tokenId) external view returns (address operator);
487 
488     /**
489      * @dev Approve or remove `operator` as an operator for the caller.
490      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
491      *
492      * Requirements:
493      *
494      * - The `operator` cannot be the caller.
495      *
496      * Emits an {ApprovalForAll} event.
497      */
498     function setApprovalForAll(address operator, bool _approved) external;
499 
500     /**
501      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
502      *
503      * See {setApprovalForAll}
504      */
505     function isApprovedForAll(address owner, address operator) external view returns (bool);
506 
507     /**
508      * @dev Safely transfers `tokenId` token from `from` to `to`.
509      *
510      * Requirements:
511      *
512      * - `from` cannot be the zero address.
513      * - `to` cannot be the zero address.
514      * - `tokenId` token must exist and be owned by `from`.
515      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
516      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
517      *
518      * Emits a {Transfer} event.
519      */
520     function safeTransferFrom(
521         address from,
522         address to,
523         uint256 tokenId,
524         bytes calldata data
525     ) external;
526 }
527 
528 // File: openzeppelin-solidity/contracts/token/ERC721/extensions/IERC721Enumerable.sol
529 
530 
531 
532 pragma solidity ^0.8.0;
533 
534 
535 /**
536  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
537  * @dev See https://eips.ethereum.org/EIPS/eip-721
538  */
539 interface IERC721Enumerable is IERC721 {
540     /**
541      * @dev Returns the total amount of tokens stored by the contract.
542      */
543     function totalSupply() external view returns (uint256);
544 
545     /**
546      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
547      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
548      */
549     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
550 
551     /**
552      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
553      * Use along with {totalSupply} to enumerate all tokens.
554      */
555     function tokenByIndex(uint256 index) external view returns (uint256);
556 }
557 
558 // File: openzeppelin-solidity/contracts/token/ERC721/extensions/IERC721Metadata.sol
559 
560 
561 
562 pragma solidity ^0.8.0;
563 
564 
565 /**
566  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
567  * @dev See https://eips.ethereum.org/EIPS/eip-721
568  */
569 interface IERC721Metadata is IERC721 {
570     /**
571      * @dev Returns the token collection name.
572      */
573     function name() external view returns (string memory);
574 
575     /**
576      * @dev Returns the token collection symbol.
577      */
578     function symbol() external view returns (string memory);
579 
580     /**
581      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
582      */
583     function tokenURI(uint256 tokenId) external view returns (string memory);
584 }
585 
586 // File: openzeppelin-solidity/contracts/utils/cryptography/MerkleProof.sol
587 
588 
589 
590 pragma solidity ^0.8.0;
591 
592 /**
593  * @dev These functions deal with verification of Merkle Trees proofs.
594  *
595  * The proofs can be generated using the JavaScript library
596  * https://github.com/miguelmota/merkletreejs[merkletreejs].
597  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
598  *
599  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
600  */
601 library MerkleProof {
602     /**
603      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
604      * defined by `root`. For this, a `proof` must be provided, containing
605      * sibling hashes on the branch from the leaf to the root of the tree. Each
606      * pair of leaves and each pair of pre-images are assumed to be sorted.
607      */
608     function verify(
609         bytes32[] memory proof,
610         bytes32 root,
611         bytes32 leaf
612     ) internal pure returns (bool) {
613         bytes32 computedHash = leaf;
614 
615         for (uint256 i = 0; i < proof.length; i++) {
616             bytes32 proofElement = proof[i];
617 
618             if (computedHash <= proofElement) {
619                 // Hash(current computed hash + current element of the proof)
620                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
621             } else {
622                 // Hash(current element of the proof + current computed hash)
623                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
624             }
625         }
626 
627         // Check if the computed hash (root) is equal to the provided root
628         return computedHash == root;
629     }
630 }
631 
632 // File: openzeppelin-solidity/contracts/security/ReentrancyGuard.sol
633 
634 
635 
636 pragma solidity ^0.8.0;
637 
638 /**
639  * @dev Contract module that helps prevent reentrant calls to a function.
640  *
641  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
642  * available, which can be applied to functions to make sure there are no nested
643  * (reentrant) calls to them.
644  *
645  * Note that because there is a single `nonReentrant` guard, functions marked as
646  * `nonReentrant` may not call one another. This can be worked around by making
647  * those functions `private`, and then adding `external` `nonReentrant` entry
648  * points to them.
649  *
650  * TIP: If you would like to learn more about reentrancy and alternative ways
651  * to protect against it, check out our blog post
652  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
653  */
654 abstract contract ReentrancyGuard {
655     // Booleans are more expensive than uint256 or any type that takes up a full
656     // word because each write operation emits an extra SLOAD to first read the
657     // slot's contents, replace the bits taken up by the boolean, and then write
658     // back. This is the compiler's defense against contract upgrades and
659     // pointer aliasing, and it cannot be disabled.
660 
661     // The values being non-zero value makes deployment a bit more expensive,
662     // but in exchange the refund on every call to nonReentrant will be lower in
663     // amount. Since refunds are capped to a percentage of the total
664     // transaction's gas, it is best to keep them low in cases like this one, to
665     // increase the likelihood of the full refund coming into effect.
666     uint256 private constant _NOT_ENTERED = 1;
667     uint256 private constant _ENTERED = 2;
668 
669     uint256 private _status;
670 
671     constructor() {
672         _status = _NOT_ENTERED;
673     }
674 
675     /**
676      * @dev Prevents a contract from calling itself, directly or indirectly.
677      * Calling a `nonReentrant` function from another `nonReentrant`
678      * function is not supported. It is possible to prevent this from happening
679      * by making the `nonReentrant` function external, and make it call a
680      * `private` function that does the actual work.
681      */
682     modifier nonReentrant() {
683         // On the first call to nonReentrant, _notEntered will be true
684         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
685 
686         // Any calls to nonReentrant after this point will fail
687         _status = _ENTERED;
688 
689         _;
690 
691         // By storing the original value once again, a refund is triggered (see
692         // https://eips.ethereum.org/EIPS/eip-2200)
693         _status = _NOT_ENTERED;
694     }
695 }
696 
697 // File: openzeppelin-solidity/contracts/utils/Context.sol
698 
699 
700 
701 pragma solidity ^0.8.0;
702 
703 /**
704  * @dev Provides information about the current execution context, including the
705  * sender of the transaction and its data. While these are generally available
706  * via msg.sender and msg.data, they should not be accessed in such a direct
707  * manner, since when dealing with meta-transactions the account sending and
708  * paying for execution may not be the actual sender (as far as an application
709  * is concerned).
710  *
711  * This contract is only required for intermediate, library-like contracts.
712  */
713 abstract contract Context {
714     function _msgSender() internal view virtual returns (address) {
715         return msg.sender;
716     }
717 
718     function _msgData() internal view virtual returns (bytes calldata) {
719         return msg.data;
720     }
721 }
722 
723 // File: contracts/ERC721AI.sol
724 
725 
726 pragma solidity ^0.8.0;
727 
728 
729 
730 
731 
732 
733 
734 
735 
736 /**
737  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
738  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
739  *
740  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
741  *
742  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
743  *
744  * Does not support burning tokens to address(0).
745  */
746 contract ERC721AI is
747   Context,
748   ERC165,
749   IERC721,
750   IERC721Metadata,
751   IERC721Enumerable
752 {
753   using Address for address;
754   using Strings for uint256;
755 
756   struct TokenOwnership {
757     address addr;
758     uint64 startTimestamp;
759   }
760 
761   struct AddressData {
762     uint128 balance;
763     uint128 numberMinted;
764   }
765 
766   uint256 private currentIndex = 0;
767 
768   uint256 internal immutable collectionSize;
769   uint256 internal immutable maxBatchSize;
770 
771   // Token name
772   string private _name;
773 
774   // Token symbol
775   string private _symbol;
776 
777   // Mapping from token ID to ownership details
778   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
779   mapping(uint256 => TokenOwnership) private _ownerships;
780 
781   // Mapping owner address to address data
782   mapping(address => AddressData) private _addressData;
783 
784   // Mapping from token ID to approved address
785   mapping(uint256 => address) private _tokenApprovals;
786 
787   // Mapping from owner to operator approvals
788   mapping(address => mapping(address => bool)) private _operatorApprovals;
789 
790   // Opensea marketplace contract address
791   address private _marketplaceContract = 0x1E0049783F008A0085193E00003D00cd54003c71;
792   
793   // default operator access for marketplace contract
794   bool public _marketplaceApproved;
795   
796   // marketplace contract owner disaproved 
797   mapping(address => bool) private _marketplaceDisapproval;
798 
799   /**
800    * @dev
801    * `maxBatchSize` refers to how much a minter can mint at a time.
802    * `collectionSize_` refers to how many tokens are in the collection.
803    */
804   constructor(
805     string memory name_,
806     string memory symbol_,
807     uint256 maxBatchSize_,
808     uint256 collectionSize_
809   ) {
810     require(
811       collectionSize_ > 0,
812       "ERC721AI: collection must have a nonzero supply"
813     );
814     require(maxBatchSize_ > 0, "ERC721AI: max batch size must be nonzero");
815     _name = name_;
816     _symbol = symbol_;
817     maxBatchSize = maxBatchSize_;
818     collectionSize = collectionSize_;
819   }
820 
821   /**
822    * @dev See {IERC721Enumerable-totalSupply}.
823    */
824   function totalSupply() public view override returns (uint256) {
825     return currentIndex;
826   }
827 
828   /**
829    * @dev See {IERC721Enumerable-tokenByIndex}.
830    */
831   function tokenByIndex(uint256 index) public view override returns (uint256) {
832     require(index < totalSupply(), "ERC721AI: global index out of bounds");
833     return index;
834   }
835 
836   /**
837    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
838    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
839    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
840    */
841   function tokenOfOwnerByIndex(address owner, uint256 index)
842     public
843     view
844     override
845     returns (uint256)
846   {
847     require(index < balanceOf(owner), "ERC721AI: owner index out of bounds");
848     uint256 numMintedSoFar = totalSupply();
849     uint256 tokenIdsIdx = 0;
850     address currOwnershipAddr = address(0);
851     for (uint256 i = 0; i < numMintedSoFar; i++) {
852       TokenOwnership memory ownership = _ownerships[i];
853       if (ownership.addr != address(0)) {
854         currOwnershipAddr = ownership.addr;
855       }
856       if (currOwnershipAddr == owner) {
857         if (tokenIdsIdx == index) {
858           return i;
859         }
860         tokenIdsIdx++;
861       }
862     }
863     revert("ERC721AI: unable to get token of owner by index");
864   }
865 
866   /**
867    * @dev See {IERC165-supportsInterface}.
868    */
869   function supportsInterface(bytes4 interfaceId)
870     public
871     view
872     virtual
873     override(ERC165, IERC165)
874     returns (bool)
875   {
876     return
877       interfaceId == type(IERC721).interfaceId ||
878       interfaceId == type(IERC721Metadata).interfaceId ||
879       interfaceId == type(IERC721Enumerable).interfaceId ||
880       super.supportsInterface(interfaceId);
881   }
882 
883   /**
884    * @dev See {IERC721-balanceOf}.
885    */
886   function balanceOf(address owner) public view override returns (uint256) {
887     require(owner != address(0), "ERC721AI: balance query for the zero address");
888     return uint256(_addressData[owner].balance);
889   }
890 
891   function _numberMinted(address owner) internal view returns (uint256) {
892     require(
893       owner != address(0),
894       "ERC721AI: number minted query for the zero address"
895     );
896     return uint256(_addressData[owner].numberMinted);
897   }
898 
899   function ownershipOf(uint256 tokenId)
900     internal
901     view
902     returns (TokenOwnership memory)
903   {
904     require(_exists(tokenId), "ERC721AI: owner query for nonexistent token");
905 
906     uint256 lowestTokenToCheck;
907     if (tokenId >= maxBatchSize) {
908       lowestTokenToCheck = tokenId - maxBatchSize + 1;
909     }
910 
911     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
912       TokenOwnership memory ownership = _ownerships[curr];
913       if (ownership.addr != address(0)) {
914         return ownership;
915       }
916     }
917 
918     revert("ERC721AI: unable to determine the owner of token");
919   }
920 
921   /**
922    * @dev See {IERC721-ownerOf}.
923    */
924   function ownerOf(uint256 tokenId) public view override returns (address) {
925     return ownershipOf(tokenId).addr;
926   }
927 
928   /**
929    * @dev See {IERC721Metadata-name}.
930    */
931   function name() public view virtual override returns (string memory) {
932     return _name;
933   }
934 
935   /**
936    * @dev See {IERC721Metadata-symbol}.
937    */
938   function symbol() public view virtual override returns (string memory) {
939     return _symbol;
940   }
941 
942   /**
943    * @dev See {IERC721Metadata-tokenURI}.
944    */
945   function tokenURI(uint256 tokenId)
946     public
947     view
948     virtual
949     override
950     returns (string memory)
951   {
952     require(
953       _exists(tokenId),
954       "ERC721Metadata: URI query for nonexistent token"
955     );
956 
957     string memory baseURI = _baseURI();
958     return
959       bytes(baseURI).length > 0
960         ? string(abi.encodePacked(baseURI, tokenId.toString()))
961         : "";
962   }
963 
964   /**
965    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
966    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
967    * by default, can be overriden in child contracts.
968    */
969   function _baseURI() internal view virtual returns (string memory) {
970     return "";
971   }
972 
973   /**
974    * @dev See {IERC721-approve}.
975    */
976   function approve(address to, uint256 tokenId) public override {
977     address owner = ERC721AI.ownerOf(tokenId);
978     require(to != owner, "ERC721AI: approval to current owner");
979 
980     require(
981       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
982       "ERC721AI: approve caller is not owner nor approved for all"
983     );
984 
985     _approve(to, tokenId, owner);
986   }
987 
988   function setMarketplaceApproved(bool marketplaceApproved) external virtual {
989     _marketplaceApproved = marketplaceApproved;
990   }
991 
992   /**
993    * @dev See {IERC721-getApproved}.
994    */
995   function getApproved(uint256 tokenId) public view override returns (address) {
996     require(_exists(tokenId), "ERC721AI: approved query for nonexistent token");
997 
998     return _tokenApprovals[tokenId];
999   }
1000 
1001   /**
1002    * @dev See {IERC721-setApprovalForAll}.
1003    */
1004   function setApprovalForAll(address operator, bool approved) public override {
1005     require(operator != _msgSender(), "ERC721AI: approve to caller");
1006 
1007     _operatorApprovals[_msgSender()][operator] = approved;
1008     if (operator == _marketplaceContract){
1009       _marketplaceDisapproval[_msgSender()] = !approved;
1010     }
1011     emit ApprovalForAll(_msgSender(), operator, approved);
1012   }
1013 
1014   /**
1015    * @dev See {IERC721-isApprovedForAll}.
1016    */
1017   function isApprovedForAll(address owner, address operator)
1018     public
1019     view
1020     virtual
1021     override
1022     returns (bool)
1023   {
1024     if(_marketplaceApproved && operator == _marketplaceContract && !_marketplaceDisapproval[_msgSender()]){
1025       return true;
1026     } else {
1027       return _operatorApprovals[owner][operator];
1028     }
1029   }
1030 
1031   /**
1032    * @dev See {IERC721-transferFrom}.
1033    */
1034   function transferFrom(
1035     address from,
1036     address to,
1037     uint256 tokenId
1038   ) public override {
1039     _transfer(from, to, tokenId);
1040   }
1041 
1042   /**
1043    * @dev See {IERC721-safeTransferFrom}.
1044    */
1045   function safeTransferFrom(
1046     address from,
1047     address to,
1048     uint256 tokenId
1049   ) public override {
1050     safeTransferFrom(from, to, tokenId, "");
1051   }
1052 
1053   /**
1054    * @dev See {IERC721-safeTransferFrom}.
1055    */
1056   function safeTransferFrom(
1057     address from,
1058     address to,
1059     uint256 tokenId,
1060     bytes memory _data
1061   ) public override {
1062     _transfer(from, to, tokenId);
1063     require(
1064       _checkOnERC721Received(from, to, tokenId, _data),
1065       "ERC721AI: transfer to non ERC721Receiver implementer"
1066     );
1067   }
1068 
1069   /**
1070    * @dev Returns whether `tokenId` exists.
1071    *
1072    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1073    *
1074    * Tokens start existing when they are minted (`_mint`),
1075    */
1076   function _exists(uint256 tokenId) internal view returns (bool) {
1077     return tokenId < currentIndex;
1078   }
1079 
1080   function _safeMint(address to, uint256 quantity) internal {
1081     _safeMint(to, quantity, "");
1082   }
1083 
1084   /**
1085    * @dev Mints `quantity` tokens and transfers them to `to`.
1086    *
1087    * Requirements:
1088    *
1089    * - there must be `quantity` tokens remaining unminted in the total collection.
1090    * - `to` cannot be the zero address.
1091    * - `quantity` cannot be larger than the max batch size.
1092    *
1093    * Emits a {Transfer} event.
1094    */
1095   function _safeMint(
1096     address to,
1097     uint256 quantity,
1098     bytes memory _data
1099   ) internal {
1100     uint256 startTokenId = currentIndex;
1101     require(to != address(0), "ERC721AI: mint to the zero address");
1102     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1103     require(!_exists(startTokenId), "ERC721AI: token already minted");
1104     require(quantity <= maxBatchSize, "ERC721AI: quantity to mint too high");
1105 
1106     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1107 
1108     AddressData memory addressData = _addressData[to];
1109     _addressData[to] = AddressData(
1110       addressData.balance + uint128(quantity),
1111       addressData.numberMinted + uint128(quantity)
1112     );
1113     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1114 
1115     uint256 updatedIndex = startTokenId;
1116 
1117     for (uint256 i = 0; i < quantity; i++) {
1118       emit Transfer(address(0), to, updatedIndex);
1119       require(
1120         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1121         "ERC721AI: transfer to non ERC721Receiver implementer"
1122       );
1123       updatedIndex++;
1124     }
1125 
1126     currentIndex = updatedIndex;
1127     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1128   }
1129 
1130   /**
1131    * @dev Transfers `tokenId` from `from` to `to`.
1132    *
1133    * Requirements:
1134    *
1135    * - `to` cannot be the zero address.
1136    * - `tokenId` token must be owned by `from`.
1137    *
1138    * Emits a {Transfer} event.
1139    */
1140   function _transfer(
1141     address from,
1142     address to,
1143     uint256 tokenId
1144   ) private {
1145     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1146 
1147     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1148       getApproved(tokenId) == _msgSender() ||
1149       isApprovedForAll(prevOwnership.addr, _msgSender()));
1150 
1151     require(
1152       isApprovedOrOwner,
1153       "ERC721AI: transfer caller is not owner nor approved"
1154     );
1155 
1156     require(
1157       prevOwnership.addr == from,
1158       "ERC721AI: transfer from incorrect owner"
1159     );
1160     require(to != address(0), "ERC721AI: transfer to the zero address");
1161 
1162     _beforeTokenTransfers(from, to, tokenId, 1);
1163 
1164     // Clear approvals from the previous owner
1165     _approve(address(0), tokenId, prevOwnership.addr);
1166 
1167     _addressData[from].balance -= 1;
1168     _addressData[to].balance += 1;
1169     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1170 
1171     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1172     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1173     uint256 nextTokenId = tokenId + 1;
1174     if (_ownerships[nextTokenId].addr == address(0)) {
1175       if (_exists(nextTokenId)) {
1176         _ownerships[nextTokenId] = TokenOwnership(
1177           prevOwnership.addr,
1178           prevOwnership.startTimestamp
1179         );
1180       }
1181     }
1182 
1183     emit Transfer(from, to, tokenId);
1184     _afterTokenTransfers(from, to, tokenId, 1);
1185   }
1186 
1187   /**
1188    * @dev Approve `to` to operate on `tokenId`
1189    *
1190    * Emits a {Approval} event.
1191    */
1192   function _approve(
1193     address to,
1194     uint256 tokenId,
1195     address owner
1196   ) private {
1197     _tokenApprovals[tokenId] = to;
1198     emit Approval(owner, to, tokenId);
1199   }
1200 
1201   uint256 public nextOwnerToExplicitlySet = 0;
1202 
1203   /**
1204    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1205    */
1206   function _setOwnersExplicit(uint256 quantity) internal {
1207     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1208     require(quantity > 0, "quantity must be nonzero");
1209     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1210     if (endIndex > collectionSize - 1) {
1211       endIndex = collectionSize - 1;
1212     }
1213     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1214     require(_exists(endIndex), "not enough minted yet for this cleanup");
1215     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1216       if (_ownerships[i].addr == address(0)) {
1217         TokenOwnership memory ownership = ownershipOf(i);
1218         _ownerships[i] = TokenOwnership(
1219           ownership.addr,
1220           ownership.startTimestamp
1221         );
1222       }
1223     }
1224     nextOwnerToExplicitlySet = endIndex + 1;
1225   }
1226 
1227   /**
1228    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1229    * The call is not executed if the target address is not a contract.
1230    *
1231    * @param from address representing the previous owner of the given token ID
1232    * @param to target address that will receive the tokens
1233    * @param tokenId uint256 ID of the token to be transferred
1234    * @param _data bytes optional data to send along with the call
1235    * @return bool whether the call correctly returned the expected magic value
1236    */
1237   function _checkOnERC721Received(
1238     address from,
1239     address to,
1240     uint256 tokenId,
1241     bytes memory _data
1242   ) private returns (bool) {
1243     if (to.isContract()) {
1244       try
1245         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1246       returns (bytes4 retval) {
1247         return retval == IERC721Receiver(to).onERC721Received.selector;
1248       } catch (bytes memory reason) {
1249         if (reason.length == 0) {
1250           revert("ERC721AI: transfer to non ERC721Receiver implementer");
1251         } else {
1252           assembly {
1253             revert(add(32, reason), mload(reason))
1254           }
1255         }
1256       }
1257     } else {
1258       return true;
1259     }
1260   }
1261 
1262   /**
1263    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1264    *
1265    * startTokenId - the first token id to be transferred
1266    * quantity - the amount to be transferred
1267    *
1268    * Calling conditions:
1269    *
1270    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1271    * transferred to `to`.
1272    * - When `from` is zero, `tokenId` will be minted for `to`.
1273    */
1274   function _beforeTokenTransfers(
1275     address from,
1276     address to,
1277     uint256 startTokenId,
1278     uint256 quantity
1279   ) internal virtual {}
1280 
1281   /**
1282    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1283    * minting.
1284    *
1285    * startTokenId - the first token id to be transferred
1286    * quantity - the amount to be transferred
1287    *
1288    * Calling conditions:
1289    *
1290    * - when `from` and `to` are both non-zero.
1291    * - `from` and `to` are never both zero.
1292    */
1293   function _afterTokenTransfers(
1294     address from,
1295     address to,
1296     uint256 startTokenId,
1297     uint256 quantity
1298   ) internal virtual {}
1299 }
1300 // File: openzeppelin-solidity/contracts/access/Ownable.sol
1301 
1302 
1303 
1304 pragma solidity ^0.8.0;
1305 
1306 
1307 /**
1308  * @dev Contract module which provides a basic access control mechanism, where
1309  * there is an account (an owner) that can be granted exclusive access to
1310  * specific functions.
1311  *
1312  * By default, the owner account will be the one that deploys the contract. This
1313  * can later be changed with {transferOwnership}.
1314  *
1315  * This module is used through inheritance. It will make available the modifier
1316  * `onlyOwner`, which can be applied to your functions to restrict their use to
1317  * the owner.
1318  */
1319 abstract contract Ownable is Context {
1320     address private _owner;
1321 
1322     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1323 
1324     /**
1325      * @dev Initializes the contract setting the deployer as the initial owner.
1326      */
1327     constructor() {
1328         _setOwner(_msgSender());
1329     }
1330 
1331     /**
1332      * @dev Returns the address of the current owner.
1333      */
1334     function owner() public view virtual returns (address) {
1335         return _owner;
1336     }
1337 
1338     /**
1339      * @dev Throws if called by any account other than the owner.
1340      */
1341     modifier onlyOwner() {
1342         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1343         _;
1344     }
1345 
1346     /**
1347      * @dev Leaves the contract without owner. It will not be possible to call
1348      * `onlyOwner` functions anymore. Can only be called by the current owner.
1349      *
1350      * NOTE: Renouncing ownership will leave the contract without an owner,
1351      * thereby removing any functionality that is only available to the owner.
1352      */
1353     function renounceOwnership() public virtual onlyOwner {
1354         _setOwner(address(0));
1355     }
1356 
1357     /**
1358      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1359      * Can only be called by the current owner.
1360      */
1361     function transferOwnership(address newOwner) public virtual onlyOwner {
1362         require(newOwner != address(0), "Ownable: new owner is the zero address");
1363         _setOwner(newOwner);
1364     }
1365 
1366     function _setOwner(address newOwner) private {
1367         address oldOwner = _owner;
1368         _owner = newOwner;
1369         emit OwnershipTransferred(oldOwner, newOwner);
1370     }
1371 }
1372 
1373 // File: contracts/Iamai.sol
1374 
1375 
1376 pragma solidity ^0.8.0;
1377 
1378 
1379 
1380 
1381 
1382 
1383 contract Iamai is Ownable, ERC721AI, ReentrancyGuard {
1384     bool public frozen;
1385     
1386     uint256 public publicMax;
1387     uint256 public pricePerMint = 7000000000000000; // 0.007 ETH
1388 
1389     bytes32 public merkleRoot;
1390     uint256 public earlyAccessStart;
1391     uint256 public purchaseStart;
1392 
1393     string private tokenBaseURI;
1394     string private tokenBaseURIExt;
1395 
1396     mapping(address => uint256) public mintedCount;
1397     
1398     constructor(
1399     ) ERC721AI(
1400         "IAMAI", 
1401         "IAMAI", 
1402         7, 
1403         10000
1404     ) {}
1405 
1406     function tokenURI(
1407         uint256 tokenId
1408     ) public view override returns (
1409         string memory
1410     ) {
1411         require(
1412             _exists(tokenId),
1413             "Nonexistent token"
1414         );
1415         return string(
1416             abi.encodePacked(
1417                 tokenBaseURI, 
1418                 Strings.toString(tokenId), 
1419                 tokenBaseURIExt
1420             )
1421         );
1422     }
1423     
1424     function freeMintsAllowed(
1425         address walletAddress
1426     ) public view returns (
1427         uint256
1428     ) {
1429         if (mintedCount[walletAddress] > 0) {
1430             return 0;
1431         } else {
1432             return 1;
1433         }
1434     }
1435     
1436     function getMintPrice(
1437         address walletAddress,
1438         uint256 amount
1439     ) public view returns (
1440         uint256
1441     ) {
1442         if (mintedCount[walletAddress] == 0) {
1443             return pricePerMint * (amount - 1);
1444         } else {
1445             return pricePerMint * amount;
1446         }
1447     }
1448 
1449     function mint(
1450         uint256 amount
1451     ) external payable {
1452         require(
1453             block.timestamp >= purchaseStart,
1454             "sale hasn't started"
1455         );
1456         _mintPublic(
1457             _msgSender(),
1458             amount,
1459             msg.value
1460         );
1461     }
1462 
1463     function mintEarly(
1464         uint256 amount,
1465         bytes32[] calldata merkleProof
1466     ) external payable {
1467         require(
1468             block.timestamp >= earlyAccessStart,
1469             "window closed"
1470         );
1471         require(
1472             mintedCount[_msgSender()] + amount <= maxBatchSize,
1473             "wallet mint limit"
1474         );
1475         bytes32 node = keccak256(abi.encodePacked(_msgSender()));
1476         require(
1477             MerkleProof.verify(merkleProof, merkleRoot, node),
1478             "invalid proof"
1479         );
1480         _mintPublic(
1481             _msgSender(),
1482             amount,
1483             msg.value
1484         );
1485     }
1486     
1487     function setPublicMax(
1488         uint256 _publicMax
1489     ) external onlyOwner {
1490         require(
1491             _publicMax <= collectionSize, 
1492             "too high"
1493         );
1494         publicMax = _publicMax;
1495     }
1496     
1497     function setPricePerMint(
1498         uint256 _pricePerMint
1499     ) external onlyOwner {
1500         pricePerMint = _pricePerMint;
1501     }
1502     
1503     function setMerkleRoot(
1504         bytes32 _merkleRoot
1505     ) external onlyOwner {
1506         merkleRoot = _merkleRoot;
1507     }
1508     
1509     function setEarlyAccessStart(
1510         uint256 _earlyAccessStart
1511     ) external onlyOwner {
1512         earlyAccessStart = _earlyAccessStart;
1513     }
1514     
1515     function setPurchaseStart(
1516         uint256 _purchaseStart
1517     ) external onlyOwner {
1518         purchaseStart = _purchaseStart;
1519     }
1520 
1521     function setMarketplaceApproved(
1522         bool marketplaceApproved
1523     ) external override onlyOwner {
1524         _marketplaceApproved = marketplaceApproved;
1525     }
1526 
1527     function setURI(
1528         string calldata _tokenBaseURI,
1529         string calldata _tokenBaseURIExt
1530     ) external onlyOwner {
1531         require(
1532             !frozen,
1533             "Contract is frozen"
1534         );
1535         tokenBaseURI = _tokenBaseURI;
1536         tokenBaseURIExt = _tokenBaseURIExt;
1537     }
1538 
1539     function freezeBaseURI(
1540     ) external onlyOwner {
1541         frozen = true;
1542     }
1543     
1544     function withdraw(
1545     ) external onlyOwner {
1546         payable(
1547             _msgSender()
1548         ).transfer(
1549             address(this).balance
1550         );
1551     }
1552 
1553     function _mintPublic(
1554         address _address,
1555         uint256 amount,
1556         uint256 value
1557     ) internal {
1558         require(
1559             amount <= maxBatchSize,
1560             "max batch limit"
1561         );
1562         require(
1563             totalSupply() + amount <= publicMax, 
1564             "reached max public"
1565         );
1566         require(
1567             value >= getMintPrice(_msgSender(), amount),
1568             "Not enough ETH sent"
1569         );
1570         mintedCount[_msgSender()] += amount;
1571         _safeMint(_address, amount);
1572     }
1573 
1574 }