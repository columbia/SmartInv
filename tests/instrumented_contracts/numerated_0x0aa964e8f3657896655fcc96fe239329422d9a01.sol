1 // File: contracts/sCARY gUYZ.sol
2 
3 
4 //SPDX-License-Identifier: MIT
5 
6 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
7 
8 
9 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Contract module that helps prevent reentrant calls to a function.
15  *
16  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
17  * available, which can be applied to functions to make sure there are no nested
18  * (reentrant) calls to them.
19  *
20  * Note that because there is a single `nonReentrant` guard, functions marked as
21  * `nonReentrant` may not call one another. This can be worked around by making
22  * those functions `private`, and then adding `external` `nonReentrant` entry
23  * points to them.
24  *
25  * TIP: If you would like to learn more about reentrancy and alternative ways
26  * to protect against it, check out our blog post
27  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
28  */
29 abstract contract ReentrancyGuard {
30     // Booleans are more expensive than uint256 or any type that takes up a full
31     // word because each write operation emits an extra SLOAD to first read the
32     // slot's contents, replace the bits taken up by the boolean, and then write
33     // back. This is the compiler's defense against contract upgrades and
34     // pointer aliasing, and it cannot be disabled.
35 
36     // The values being non-zero value makes deployment a bit more expensive,
37     // but in exchange the refund on every call to nonReentrant will be lower in
38     // amount. Since refunds are capped to a percentage of the total
39     // transaction's gas, it is best to keep them low in cases like this one, to
40     // increase the likelihood of the full refund coming into effect.
41     uint256 private constant _NOT_ENTERED = 1;
42     uint256 private constant _ENTERED = 2;
43 
44     uint256 private _status;
45 
46     constructor() {
47         _status = _NOT_ENTERED;
48     }
49 
50     /**
51      * @dev Prevents a contract from calling itself, directly or indirectly.
52      * Calling a `nonReentrant` function from another `nonReentrant`
53      * function is not supported. It is possible to prevent this from happening
54      * by making the `nonReentrant` function external, and making it call a
55      * `private` function that does the actual work.
56      */
57     modifier nonReentrant() {
58         // On the first call to nonReentrant, _notEntered will be true
59         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
60 
61         // Any calls to nonReentrant after this point will fail
62         _status = _ENTERED;
63 
64         _;
65 
66         // By storing the original value once again, a refund is triggered (see
67         // https://eips.ethereum.org/EIPS/eip-2200)
68         _status = _NOT_ENTERED;
69     }
70 }
71 
72 // File: @openzeppelin/contracts/utils/Strings.sol
73 
74 
75 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
76 
77 pragma solidity ^0.8.0;
78 
79 /**
80  * @dev String operations.
81  */
82 library Strings {
83     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
84     uint8 private constant _ADDRESS_LENGTH = 20;
85 
86     /**
87      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
88      */
89     function toString(uint256 value) internal pure returns (string memory) {
90         // Inspired by OraclizeAPI's implementation - MIT licence
91         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
92 
93         if (value == 0) {
94             return "0";
95         }
96         uint256 temp = value;
97         uint256 digits;
98         while (temp != 0) {
99             digits++;
100             temp /= 10;
101         }
102         bytes memory buffer = new bytes(digits);
103         while (value != 0) {
104             digits -= 1;
105             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
106             value /= 10;
107         }
108         return string(buffer);
109     }
110 
111     /**
112      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
113      */
114     function toHexString(uint256 value) internal pure returns (string memory) {
115         if (value == 0) {
116             return "0x00";
117         }
118         uint256 temp = value;
119         uint256 length = 0;
120         while (temp != 0) {
121             length++;
122             temp >>= 8;
123         }
124         return toHexString(value, length);
125     }
126 
127     /**
128      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
129      */
130     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
131         bytes memory buffer = new bytes(2 * length + 2);
132         buffer[0] = "0";
133         buffer[1] = "x";
134         for (uint256 i = 2 * length + 1; i > 1; --i) {
135             buffer[i] = _HEX_SYMBOLS[value & 0xf];
136             value >>= 4;
137         }
138         require(value == 0, "Strings: hex length insufficient");
139         return string(buffer);
140     }
141 
142     /**
143      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
144      */
145     function toHexString(address addr) internal pure returns (string memory) {
146         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
147     }
148 }
149 
150 // File: @openzeppelin/contracts/utils/Address.sol
151 
152 
153 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
154 
155 pragma solidity ^0.8.1;
156 
157 /**
158  * @dev Collection of functions related to the address type
159  */
160 library Address {
161     /**
162      * @dev Returns true if `account` is a contract.
163      *
164      * [IMPORTANT]
165      * ====
166      * It is unsafe to assume that an address for which this function returns
167      * false is an externally-owned account (EOA) and not a contract.
168      *
169      * Among others, `isContract` will return false for the following
170      * types of addresses:
171      *
172      *  - an externally-owned account
173      *  - a contract in construction
174      *  - an address where a contract will be created
175      *  - an address where a contract lived, but was destroyed
176      * ====
177      *
178      * [IMPORTANT]
179      * ====
180      * You shouldn't rely on `isContract` to protect against flash loan attacks!
181      *
182      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
183      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
184      * constructor.
185      * ====
186      */
187     function isContract(address account) internal view returns (bool) {
188         // This method relies on extcodesize/address.code.length, which returns 0
189         // for contracts in construction, since the code is only stored at the end
190         // of the constructor execution.
191 
192         return account.code.length > 0;
193     }
194 
195     /**
196      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
197      * `recipient`, forwarding all available gas and reverting on errors.
198      *
199      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
200      * of certain opcodes, possibly making contracts go over the 2300 gas limit
201      * imposed by `transfer`, making them unable to receive funds via
202      * `transfer`. {sendValue} removes this limitation.
203      *
204      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
205      *
206      * IMPORTANT: because control is transferred to `recipient`, care must be
207      * taken to not create reentrancy vulnerabilities. Consider using
208      * {ReentrancyGuard} or the
209      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
210      */
211     function sendValue(address payable recipient, uint256 amount) internal {
212         require(address(this).balance >= amount, "Address: insufficient balance");
213 
214         (bool success, ) = recipient.call{value: amount}("");
215         require(success, "Address: unable to send value, recipient may have reverted");
216     }
217 
218     /**
219      * @dev Performs a Solidity function call using a low level `call`. A
220      * plain `call` is an unsafe replacement for a function call: use this
221      * function instead.
222      *
223      * If `target` reverts with a revert reason, it is bubbled up by this
224      * function (like regular Solidity function calls).
225      *
226      * Returns the raw returned data. To convert to the expected return value,
227      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
228      *
229      * Requirements:
230      *
231      * - `target` must be a contract.
232      * - calling `target` with `data` must not revert.
233      *
234      * _Available since v3.1._
235      */
236     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
237         return functionCall(target, data, "Address: low-level call failed");
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
242      * `errorMessage` as a fallback revert reason when `target` reverts.
243      *
244      * _Available since v3.1._
245      */
246     function functionCall(
247         address target,
248         bytes memory data,
249         string memory errorMessage
250     ) internal returns (bytes memory) {
251         return functionCallWithValue(target, data, 0, errorMessage);
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
256      * but also transferring `value` wei to `target`.
257      *
258      * Requirements:
259      *
260      * - the calling contract must have an ETH balance of at least `value`.
261      * - the called Solidity function must be `payable`.
262      *
263      * _Available since v3.1._
264      */
265     function functionCallWithValue(
266         address target,
267         bytes memory data,
268         uint256 value
269     ) internal returns (bytes memory) {
270         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
271     }
272 
273     /**
274      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
275      * with `errorMessage` as a fallback revert reason when `target` reverts.
276      *
277      * _Available since v3.1._
278      */
279     function functionCallWithValue(
280         address target,
281         bytes memory data,
282         uint256 value,
283         string memory errorMessage
284     ) internal returns (bytes memory) {
285         require(address(this).balance >= value, "Address: insufficient balance for call");
286         require(isContract(target), "Address: call to non-contract");
287 
288         (bool success, bytes memory returndata) = target.call{value: value}(data);
289         return verifyCallResult(success, returndata, errorMessage);
290     }
291 
292     /**
293      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
294      * but performing a static call.
295      *
296      * _Available since v3.3._
297      */
298     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
299         return functionStaticCall(target, data, "Address: low-level static call failed");
300     }
301 
302     /**
303      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
304      * but performing a static call.
305      *
306      * _Available since v3.3._
307      */
308     function functionStaticCall(
309         address target,
310         bytes memory data,
311         string memory errorMessage
312     ) internal view returns (bytes memory) {
313         require(isContract(target), "Address: static call to non-contract");
314 
315         (bool success, bytes memory returndata) = target.staticcall(data);
316         return verifyCallResult(success, returndata, errorMessage);
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
321      * but performing a delegate call.
322      *
323      * _Available since v3.4._
324      */
325     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
326         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
331      * but performing a delegate call.
332      *
333      * _Available since v3.4._
334      */
335     function functionDelegateCall(
336         address target,
337         bytes memory data,
338         string memory errorMessage
339     ) internal returns (bytes memory) {
340         require(isContract(target), "Address: delegate call to non-contract");
341 
342         (bool success, bytes memory returndata) = target.delegatecall(data);
343         return verifyCallResult(success, returndata, errorMessage);
344     }
345 
346     /**
347      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
348      * revert reason using the provided one.
349      *
350      * _Available since v4.3._
351      */
352     function verifyCallResult(
353         bool success,
354         bytes memory returndata,
355         string memory errorMessage
356     ) internal pure returns (bytes memory) {
357         if (success) {
358             return returndata;
359         } else {
360             // Look for revert reason and bubble it up if present
361             if (returndata.length > 0) {
362                 // The easiest way to bubble the revert reason is using memory via assembly
363                 /// @solidity memory-safe-assembly
364                 assembly {
365                     let returndata_size := mload(returndata)
366                     revert(add(32, returndata), returndata_size)
367                 }
368             } else {
369                 revert(errorMessage);
370             }
371         }
372     }
373 }
374 
375 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
376 
377 
378 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
379 
380 pragma solidity ^0.8.0;
381 
382 /**
383  * @title ERC721 token receiver interface
384  * @dev Interface for any contract that wants to support safeTransfers
385  * from ERC721 asset contracts.
386  */
387 interface IERC721Receiver {
388     /**
389      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
390      * by `operator` from `from`, this function is called.
391      *
392      * It must return its Solidity selector to confirm the token transfer.
393      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
394      *
395      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
396      */
397     function onERC721Received(
398         address operator,
399         address from,
400         uint256 tokenId,
401         bytes calldata data
402     ) external returns (bytes4);
403 }
404 
405 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
406 
407 
408 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
409 
410 pragma solidity ^0.8.0;
411 
412 /**
413  * @dev Interface of the ERC165 standard, as defined in the
414  * https://eips.ethereum.org/EIPS/eip-165[EIP].
415  *
416  * Implementers can declare support of contract interfaces, which can then be
417  * queried by others ({ERC165Checker}).
418  *
419  * For an implementation, see {ERC165}.
420  */
421 interface IERC165 {
422     /**
423      * @dev Returns true if this contract implements the interface defined by
424      * `interfaceId`. See the corresponding
425      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
426      * to learn more about how these ids are created.
427      *
428      * This function call must use less than 30 000 gas.
429      */
430     function supportsInterface(bytes4 interfaceId) external view returns (bool);
431 }
432 
433 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
434 
435 
436 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
437 
438 pragma solidity ^0.8.0;
439 
440 
441 /**
442  * @dev Implementation of the {IERC165} interface.
443  *
444  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
445  * for the additional interface id that will be supported. For example:
446  *
447  * ```solidity
448  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
449  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
450  * }
451  * ```
452  *
453  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
454  */
455 abstract contract ERC165 is IERC165 {
456     /**
457      * @dev See {IERC165-supportsInterface}.
458      */
459     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
460         return interfaceId == type(IERC165).interfaceId;
461     }
462 }
463 
464 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
465 
466 
467 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
468 
469 pragma solidity ^0.8.0;
470 
471 
472 /**
473  * @dev Required interface of an ERC721 compliant contract.
474  */
475 interface IERC721 is IERC165 {
476     /**
477      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
478      */
479     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
480 
481     /**
482      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
483      */
484     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
485 
486     /**
487      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
488      */
489     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
490 
491     /**
492      * @dev Returns the number of tokens in ``owner``'s account.
493      */
494     function balanceOf(address owner) external view returns (uint256 balance);
495 
496     /**
497      * @dev Returns the owner of the `tokenId` token.
498      *
499      * Requirements:
500      *
501      * - `tokenId` must exist.
502      */
503     function ownerOf(uint256 tokenId) external view returns (address owner);
504 
505     /**
506      * @dev Safely transfers `tokenId` token from `from` to `to`.
507      *
508      * Requirements:
509      *
510      * - `from` cannot be the zero address.
511      * - `to` cannot be the zero address.
512      * - `tokenId` token must exist and be owned by `from`.
513      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
514      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
515      *
516      * Emits a {Transfer} event.
517      */
518     function safeTransferFrom(
519         address from,
520         address to,
521         uint256 tokenId,
522         bytes calldata data
523     ) external;
524 
525     /**
526      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
527      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
528      *
529      * Requirements:
530      *
531      * - `from` cannot be the zero address.
532      * - `to` cannot be the zero address.
533      * - `tokenId` token must exist and be owned by `from`.
534      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
535      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
536      *
537      * Emits a {Transfer} event.
538      */
539     function safeTransferFrom(
540         address from,
541         address to,
542         uint256 tokenId
543     ) external;
544 
545     /**
546      * @dev Transfers `tokenId` token from `from` to `to`.
547      *
548      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
549      *
550      * Requirements:
551      *
552      * - `from` cannot be the zero address.
553      * - `to` cannot be the zero address.
554      * - `tokenId` token must be owned by `from`.
555      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
556      *
557      * Emits a {Transfer} event.
558      */
559     function transferFrom(
560         address from,
561         address to,
562         uint256 tokenId
563     ) external;
564 
565     /**
566      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
567      * The approval is cleared when the token is transferred.
568      *
569      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
570      *
571      * Requirements:
572      *
573      * - The caller must own the token or be an approved operator.
574      * - `tokenId` must exist.
575      *
576      * Emits an {Approval} event.
577      */
578     function approve(address to, uint256 tokenId) external;
579 
580     /**
581      * @dev Approve or remove `operator` as an operator for the caller.
582      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
583      *
584      * Requirements:
585      *
586      * - The `operator` cannot be the caller.
587      *
588      * Emits an {ApprovalForAll} event.
589      */
590     function setApprovalForAll(address operator, bool _approved) external;
591 
592     /**
593      * @dev Returns the account approved for `tokenId` token.
594      *
595      * Requirements:
596      *
597      * - `tokenId` must exist.
598      */
599     function getApproved(uint256 tokenId) external view returns (address operator);
600 
601     /**
602      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
603      *
604      * See {setApprovalForAll}
605      */
606     function isApprovedForAll(address owner, address operator) external view returns (bool);
607 }
608 
609 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
610 
611 
612 
613 
614 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
615 
616 pragma solidity ^0.8.0;
617 
618 
619 /**
620  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
621  * @dev See https://eips.ethereum.org/EIPS/eip-721
622  */
623 interface IERC721Enumerable is IERC721 {
624     /**
625      * @dev Returns the total amount of tokens stored by the contract.
626      */
627     function totalSupply() external view returns (uint256);
628 
629     /**
630      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
631      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
632      */
633     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
634 
635     /**
636      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
637      * Use along with {totalSupply} to enumerate all tokens.
638      */
639     function tokenByIndex(uint256 index) external view returns (uint256);
640 }
641 
642 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
643 
644 
645 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
646 
647 pragma solidity ^0.8.0;
648 
649 
650 /**
651  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
652  * @dev See https://eips.ethereum.org/EIPS/eip-721
653  */
654 interface IERC721Metadata is IERC721 {
655     /**
656      * @dev Returns the token collection name.
657      */
658     function name() external view returns (string memory);
659 
660     /**
661      * @dev Returns the token collection symbol.
662      */
663     function symbol() external view returns (string memory);
664 
665     /**
666      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
667      */
668     function tokenURI(uint256 tokenId) external view returns (string memory);
669 }
670 
671 // File: @openzeppelin/contracts/utils/Context.sol
672 
673 
674 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
675 
676 pragma solidity ^0.8.0;
677 
678 /**
679  * @dev Provides information about the current execution context, including the
680  * sender of the transaction and its data. While these are generally available
681  * via msg.sender and msg.data, they should not be accessed in such a direct
682  * manner, since when dealing with meta-transactions the account sending and
683  * paying for execution may not be the actual sender (as far as an application
684  * is concerned).
685  *
686  * This contract is only required for intermediate, library-like contracts.
687  */
688 abstract contract Context {
689     function _msgSender() internal view virtual returns (address) {
690         return msg.sender;
691     }
692 
693     function _msgData() internal view virtual returns (bytes calldata) {
694         return msg.data;
695     }
696 }
697 
698 // File: ERC721A.sol
699 
700 
701 
702 // Creator: Chiru Labs
703 
704 pragma solidity ^0.8.4;
705 
706 
707 
708 
709 
710 
711 
712 
713 
714 error ApprovalCallerNotOwnerNorApproved();
715 error ApprovalQueryForNonexistentToken();
716 error ApproveToCaller();
717 error ApprovalToCurrentOwner();
718 error BalanceQueryForZeroAddress();
719 error MintedQueryForZeroAddress();
720 error BurnedQueryForZeroAddress();
721 error AuxQueryForZeroAddress();
722 error MintToZeroAddress();
723 error MintZeroQuantity();
724 error OwnerIndexOutOfBounds();
725 error OwnerQueryForNonexistentToken();
726 error TokenIndexOutOfBounds();
727 error TransferCallerNotOwnerNorApproved();
728 error TransferFromIncorrectOwner();
729 error TransferToNonERC721ReceiverImplementer();
730 error TransferToZeroAddress();
731 error URIQueryForNonexistentToken();
732 
733 /**
734  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
735  * the Metadata extension. Built to optimize for lower gas during batch mints.
736  *
737  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
738  *
739  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
740  *
741  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
742  */
743 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
744     using Address for address;
745     using Strings for uint256;
746 
747     // Compiler will pack this into a single 256bit word.
748     struct TokenOwnership {
749         // The address of the owner.
750         address addr;
751         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
752         uint64 startTimestamp;
753         // Whether the token has been burned.
754         bool burned;
755     }
756 
757     // Compiler will pack this into a single 256bit word.
758     struct AddressData {
759         // Realistically, 2**64-1 is more than enough.
760         uint64 balance;
761         // Keeps track of mint count with minimal overhead for tokenomics.
762         uint64 numberMinted;
763         // Keeps track of burn count with minimal overhead for tokenomics.
764         uint64 numberBurned;
765         // For miscellaneous variable(s) pertaining to the address
766         // (e.g. number of whitelist mint slots used).
767         // If there are multiple variables, please pack them into a uint64.
768         uint64 aux;
769     }
770 
771     // The tokenId of the next token to be minted.
772     uint256 internal _currentIndex;
773 
774     // The number of tokens burned.
775     uint256 internal _burnCounter;
776 
777     // Token name
778     string private _name;
779 
780     // Token symbol
781     string private _symbol;
782 
783     // Mapping from token ID to ownership details
784     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
785     mapping(uint256 => TokenOwnership) internal _ownerships;
786 
787     // Mapping owner address to address data
788     mapping(address => AddressData) private _addressData;
789 
790     // Mapping from token ID to approved address
791     mapping(uint256 => address) private _tokenApprovals;
792 
793     // Mapping from owner to operator approvals
794     mapping(address => mapping(address => bool)) private _operatorApprovals;
795 
796     constructor(string memory name_, string memory symbol_) {
797         _name = name_;
798         _symbol = symbol_;
799         _currentIndex = _startTokenId();
800     }
801 
802     /**
803      * To change the starting tokenId, please override this function.
804      */
805     function _startTokenId() internal view virtual returns (uint256) {
806         return 0;
807     }
808 
809     /**
810      * @dev See {IERC721Enumerable-totalSupply}.
811      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
812      */
813     function totalSupply() public view returns (uint256) {
814         // Counter underflow is impossible as _burnCounter cannot be incremented
815         // more than _currentIndex - _startTokenId() times
816         unchecked {
817             return _currentIndex - _burnCounter - _startTokenId();
818         }
819     }
820 
821     /**
822      * Returns the total amount of tokens minted in the contract.
823      */
824     function _totalMinted() internal view returns (uint256) {
825         // Counter underflow is impossible as _currentIndex does not decrement,
826         // and it is initialized to _startTokenId()
827         unchecked {
828             return _currentIndex - _startTokenId();
829         }
830     }
831 
832     /**
833      * @dev See {IERC165-supportsInterface}.
834      */
835     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
836         return
837             interfaceId == type(IERC721).interfaceId ||
838             interfaceId == type(IERC721Metadata).interfaceId ||
839             super.supportsInterface(interfaceId);
840     }
841 
842     /**
843      * @dev See {IERC721-balanceOf}.
844      */
845     function balanceOf(address owner) public view override returns (uint256) {
846         if (owner == address(0)) revert BalanceQueryForZeroAddress();
847         return uint256(_addressData[owner].balance);
848     }
849 
850     /**
851      * Returns the number of tokens minted by `owner`.
852      */
853     function _numberMinted(address owner) internal view returns (uint256) {
854         if (owner == address(0)) revert MintedQueryForZeroAddress();
855         return uint256(_addressData[owner].numberMinted);
856     }
857 
858     /**
859      * Returns the number of tokens burned by or on behalf of `owner`.
860      */
861     function _numberBurned(address owner) internal view returns (uint256) {
862         if (owner == address(0)) revert BurnedQueryForZeroAddress();
863         return uint256(_addressData[owner].numberBurned);
864     }
865 
866     /**
867      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
868      */
869     function _getAux(address owner) internal view returns (uint64) {
870         if (owner == address(0)) revert AuxQueryForZeroAddress();
871         return _addressData[owner].aux;
872     }
873 
874     /**
875      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
876      * If there are multiple variables, please pack them into a uint64.
877      */
878     function _setAux(address owner, uint64 aux) internal {
879         if (owner == address(0)) revert AuxQueryForZeroAddress();
880         _addressData[owner].aux = aux;
881     }
882 
883     /**
884      * Gas spent here starts off proportional to the maximum mint batch size.
885      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
886      */
887     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
888         uint256 curr = tokenId;
889 
890         unchecked {
891             if (_startTokenId() <= curr && curr < _currentIndex) {
892                 TokenOwnership memory ownership = _ownerships[curr];
893                 if (!ownership.burned) {
894                     if (ownership.addr != address(0)) {
895                         return ownership;
896                     }
897                     // Invariant:
898                     // There will always be an ownership that has an address and is not burned
899                     // before an ownership that does not have an address and is not burned.
900                     // Hence, curr will not underflow.
901                     while (true) {
902                         curr--;
903                         ownership = _ownerships[curr];
904                         if (ownership.addr != address(0)) {
905                             return ownership;
906                         }
907                     }
908                 }
909             }
910         }
911         revert OwnerQueryForNonexistentToken();
912     }
913 
914 
915     /**
916      * @dev See {IERC721-ownerOf}.
917      */
918     function ownerOf(uint256 tokenId) public view override returns (address) {
919         return ownershipOf(tokenId).addr;
920     }
921 
922     /**
923      * @dev See {IERC721Metadata-name}.
924      */
925     function name() public view virtual override returns (string memory) {
926         return _name;
927     }
928 
929     /**
930      * @dev See {IERC721Metadata-symbol}.
931      */
932     function symbol() public view virtual override returns (string memory) {
933         return _symbol;
934     }
935 
936     /**
937      * @dev See {IERC721Metadata-tokenURI}.
938      */
939     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
940         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
941 
942         string memory baseURI = _baseURI();
943         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
944     }
945 
946     /**
947      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
948      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
949      * by default, can be overriden in child contracts.
950      */
951     function _baseURI() internal view virtual returns (string memory) {
952         return '';
953     }
954 
955     /**
956      * @dev See {IERC721-approve}.
957      */
958     function approve(address to, uint256 tokenId) public override {
959         address owner = ERC721A.ownerOf(tokenId);
960         if (to == owner) revert ApprovalToCurrentOwner();
961 
962         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
963             revert ApprovalCallerNotOwnerNorApproved();
964         }
965 
966         _approve(to, tokenId, owner);
967     }
968 
969     /**
970      * @dev See {IERC721-getApproved}.
971      */
972     function getApproved(uint256 tokenId) public view override returns (address) {
973         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
974 
975         return _tokenApprovals[tokenId];
976     }
977 
978     /**
979      * @dev See {IERC721-setApprovalForAll}.
980      */
981     function setApprovalForAll(address operator, bool approved) public override {
982         if (operator == _msgSender()) revert ApproveToCaller();
983 
984         _operatorApprovals[_msgSender()][operator] = approved;
985         emit ApprovalForAll(_msgSender(), operator, approved);
986     }
987 
988     /**
989      * @dev See {IERC721-isApprovedForAll}.
990      */
991     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
992         return _operatorApprovals[owner][operator];
993     }
994 
995     /**
996      * @dev See {IERC721-transferFrom}.
997      */
998     function transferFrom(
999         address from,
1000         address to,
1001         uint256 tokenId
1002     ) public virtual override {
1003         _transfer(from, to, tokenId);
1004     }
1005 
1006     /**
1007      * @dev See {IERC721-safeTransferFrom}.
1008      */
1009     function safeTransferFrom(
1010         address from,
1011         address to,
1012         uint256 tokenId
1013     ) public virtual override {
1014         safeTransferFrom(from, to, tokenId, '');
1015     }
1016 
1017     /**
1018      * @dev See {IERC721-safeTransferFrom}.
1019      */
1020     function safeTransferFrom(
1021         address from,
1022         address to,
1023         uint256 tokenId,
1024         bytes memory _data
1025     ) public virtual override {
1026         _transfer(from, to, tokenId);
1027         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1028             revert TransferToNonERC721ReceiverImplementer();
1029         }
1030     }
1031 
1032     /**
1033      * @dev Returns whether `tokenId` exists.
1034      *
1035      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1036      *
1037      * Tokens start existing when they are minted (`_mint`),
1038      */
1039     function _exists(uint256 tokenId) internal view returns (bool) {
1040         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1041             !_ownerships[tokenId].burned;
1042     }
1043 
1044     function _safeMint(address to, uint256 quantity) internal {
1045         _safeMint(to, quantity, '');
1046     }
1047 
1048     /**
1049      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1050      *
1051      * Requirements:
1052      *
1053      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1054      * - `quantity` must be greater than 0.
1055      *
1056      * Emits a {Transfer} event.
1057      */
1058     function _safeMint(
1059         address to,
1060         uint256 quantity,
1061         bytes memory _data
1062     ) internal {
1063         _mint(to, quantity, _data, true);
1064     }
1065 
1066 
1067 
1068 
1069     /**
1070      * @dev Mints `quantity` tokens and transfers them to `to`.
1071      *
1072      * Requirements:
1073      *
1074      * - `to` cannot be the zero address.
1075      * - `quantity` must be greater than 0.
1076      *
1077      * Emits a {Transfer} event.
1078      */
1079     function _mint(
1080         address to,
1081         uint256 quantity,
1082         bytes memory _data,
1083         bool safe
1084     ) internal {
1085         uint256 startTokenId = _currentIndex;
1086         if (to == address(0)) revert MintToZeroAddress();
1087         if (quantity == 0) revert MintZeroQuantity();
1088 
1089         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1090 
1091         // Overflows are incredibly unrealistic.
1092         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1093         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1094         unchecked {
1095             _addressData[to].balance += uint64(quantity);
1096             _addressData[to].numberMinted += uint64(quantity);
1097 
1098             _ownerships[startTokenId].addr = to;
1099             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1100 
1101             uint256 updatedIndex = startTokenId;
1102             uint256 end = updatedIndex + quantity;
1103 
1104             if (safe && to.isContract()) {
1105                 do {
1106                     emit Transfer(address(0), to, updatedIndex);
1107                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1108                         revert TransferToNonERC721ReceiverImplementer();
1109                     }
1110                 } while (updatedIndex != end);
1111                 // Reentrancy protection
1112                 if (_currentIndex != startTokenId) revert();
1113             } else {
1114                 do {
1115                     emit Transfer(address(0), to, updatedIndex++);
1116                 } while (updatedIndex != end);
1117             }
1118             _currentIndex = updatedIndex;
1119         }
1120         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1121     }
1122 
1123     /**
1124      * @dev Transfers `tokenId` from `from` to `to`.
1125      *
1126      * Requirements:
1127      *
1128      * - `to` cannot be the zero address.
1129      * - `tokenId` token must be owned by `from`.
1130      *
1131      * Emits a {Transfer} event.
1132      */
1133     function _transfer(
1134         address from,
1135         address to,
1136         uint256 tokenId
1137     ) private {
1138         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1139 
1140         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1141             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1142             getApproved(tokenId) == _msgSender());
1143 
1144         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1145         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1146         if (to == address(0)) revert TransferToZeroAddress();
1147 
1148         _beforeTokenTransfers(from, to, tokenId, 1);
1149 
1150         // Clear approvals from the previous owner
1151         _approve(address(0), tokenId, prevOwnership.addr);
1152 
1153         // Underflow of the sender's balance is impossible because we check for
1154         // ownership above and the recipient's balance can't realistically overflow.
1155         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1156         unchecked {
1157             _addressData[from].balance -= 1;
1158             _addressData[to].balance += 1;
1159 
1160             _ownerships[tokenId].addr = to;
1161             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1162 
1163             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1164             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1165             uint256 nextTokenId = tokenId + 1;
1166             if (_ownerships[nextTokenId].addr == address(0)) {
1167                 // This will suffice for checking _exists(nextTokenId),
1168                 // as a burned slot cannot contain the zero address.
1169                 if (nextTokenId < _currentIndex) {
1170                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1171                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1172                 }
1173             }
1174         }
1175 
1176         emit Transfer(from, to, tokenId);
1177         _afterTokenTransfers(from, to, tokenId, 1);
1178     }
1179 
1180     /**
1181      * @dev Destroys `tokenId`.
1182      * The approval is cleared when the token is burned.
1183      *
1184      * Requirements:
1185      *
1186      * - `tokenId` must exist.
1187      *
1188      * Emits a {Transfer} event.
1189      */
1190     function _burn(uint256 tokenId) internal virtual {
1191         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1192 
1193         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1194 
1195         // Clear approvals from the previous owner
1196         _approve(address(0), tokenId, prevOwnership.addr);
1197 
1198         // Underflow of the sender's balance is impossible because we check for
1199         // ownership above and the recipient's balance can't realistically overflow.
1200         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1201         unchecked {
1202             _addressData[prevOwnership.addr].balance -= 1;
1203             _addressData[prevOwnership.addr].numberBurned += 1;
1204 
1205             // Keep track of who burned the token, and the timestamp of burning.
1206             _ownerships[tokenId].addr = prevOwnership.addr;
1207             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1208             _ownerships[tokenId].burned = true;
1209 
1210             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1211             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1212             uint256 nextTokenId = tokenId + 1;
1213             if (_ownerships[nextTokenId].addr == address(0)) {
1214                 // This will suffice for checking _exists(nextTokenId),
1215                 // as a burned slot cannot contain the zero address.
1216                 if (nextTokenId < _currentIndex) {
1217                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1218                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1219                 }
1220             }
1221         }
1222 
1223         emit Transfer(prevOwnership.addr, address(0), tokenId);
1224         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1225 
1226         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1227         unchecked {
1228             _burnCounter++;
1229         }
1230     }
1231 
1232     /**
1233      * @dev Approve `to` to operate on `tokenId`
1234      *
1235      * Emits a {Approval} event.
1236      */
1237     function _approve(
1238         address to,
1239         uint256 tokenId,
1240         address owner
1241     ) private {
1242         _tokenApprovals[tokenId] = to;
1243         emit Approval(owner, to, tokenId);
1244     }
1245 
1246     /**
1247      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1248      *
1249      * @param from address representing the previous owner of the given token ID
1250      * @param to target address that will receive the tokens
1251      * @param tokenId uint256 ID of the token to be transferred
1252      * @param _data bytes optional data to send along with the call
1253      * @return bool whether the call correctly returned the expected magic value
1254      */
1255     function _checkContractOnERC721Received(
1256         address from,
1257         address to,
1258         uint256 tokenId,
1259         bytes memory _data
1260     ) private returns (bool) {
1261         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1262             return retval == IERC721Receiver(to).onERC721Received.selector;
1263         } catch (bytes memory reason) {
1264             if (reason.length == 0) {
1265                 revert TransferToNonERC721ReceiverImplementer();
1266             } else {
1267                 assembly {
1268                     revert(add(32, reason), mload(reason))
1269                 }
1270             }
1271         }
1272     }
1273 
1274     /**
1275      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1276      * And also called before burning one token.
1277      *
1278      * startTokenId - the first token id to be transferred
1279      * quantity - the amount to be transferred
1280      *
1281      * Calling conditions:
1282      *
1283      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1284      * transferred to `to`.
1285      * - When `from` is zero, `tokenId` will be minted for `to`.
1286      * - When `to` is zero, `tokenId` will be burned by `from`.
1287      * - `from` and `to` are never both zero.
1288      */
1289     function _beforeTokenTransfers(
1290         address from,
1291         address to,
1292         uint256 startTokenId,
1293         uint256 quantity
1294     ) internal virtual {}
1295 
1296     /**
1297      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1298      * minting.
1299      * And also called after one token has been burned.
1300      *
1301      * startTokenId - the first token id to be transferred
1302      * quantity - the amount to be transferred
1303      *
1304      * Calling conditions:
1305      *
1306      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1307      * transferred to `to`.
1308      * - When `from` is zero, `tokenId` has been minted for `to`.
1309      * - When `to` is zero, `tokenId` has been burned by `from`.
1310      * - `from` and `to` are never both zero.
1311      */
1312     function _afterTokenTransfers(
1313         address from,
1314         address to,
1315         uint256 startTokenId,
1316         uint256 quantity
1317     ) internal virtual {}
1318 }
1319 // File: @openzeppelin/contracts/access/Ownable.sol
1320 
1321 
1322 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1323 
1324 pragma solidity ^0.8.0;
1325 
1326 
1327 /**
1328  * @dev Contract module which provides a basic access control mechanism, where
1329  * there is an account (an owner) that can be granted exclusive access to
1330  * specific functions.
1331  *
1332  * By default, the owner account will be the one that deploys the contract. This
1333  * can later be changed with {transferOwnership}.
1334  *
1335  * This module is used through inheritance. It will make available the modifier
1336  * `onlyOwner`, which can be applied to your functions to restrict their use to
1337  * the owner.
1338  */
1339 abstract contract Ownable is Context {
1340     address private _owner;
1341 
1342     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1343 
1344     /**
1345      * @dev Initializes the contract setting the deployer as the initial owner.
1346      */
1347     constructor() {
1348         _transferOwnership(_msgSender());
1349     }
1350 
1351     /**
1352      * @dev Throws if called by any account other than the owner.
1353      */
1354     modifier onlyOwner() {
1355         _checkOwner();
1356         _;
1357     }
1358 
1359     /**
1360      * @dev Returns the address of the current owner.
1361      */
1362     function owner() public view virtual returns (address) {
1363         return _owner;
1364     }
1365 
1366     /**
1367      * @dev Throws if the sender is not the owner.
1368      */
1369     function _checkOwner() internal view virtual {
1370         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1371     }
1372 
1373 
1374 
1375     /**
1376      * @dev Leaves the contract without owner. It will not be possible to call
1377      * `onlyOwner` functions anymore. Can only be called by the current owner.
1378      *
1379      * NOTE: Renouncing ownership will leave the contract without an owner,
1380      * thereby removing any functionality that is only available to the owner.
1381      */
1382     function renounceOwnership() public virtual onlyOwner {
1383         _transferOwnership(address(0));
1384     }
1385 
1386     /**
1387      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1388      * Can only be called by the current owner.
1389      */
1390     function transferOwnership(address newOwner) public virtual onlyOwner {
1391         require(newOwner != address(0), "Ownable: new owner is the zero address");
1392         _transferOwnership(newOwner);
1393     }
1394 
1395     /**
1396      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1397      * Internal function without access restriction.
1398      */
1399     function _transferOwnership(address newOwner) internal virtual {
1400         address oldOwner = _owner;
1401         _owner = newOwner;
1402         emit OwnershipTransferred(oldOwner, newOwner);
1403     }
1404 }
1405 
1406 
1407 
1408 
1409 pragma solidity ^0.8.2;
1410 
1411 
1412 
1413 
1414 contract ScaryGuyz is ERC721A, Ownable, ReentrancyGuard {
1415     enum Status {
1416         Waiting,
1417         Started,
1418         Finished
1419     }
1420     using Strings for uint256;
1421     bool public isPublicSaleActive = false;
1422     string private baseURI = "ipfs://QmRRhRR7pw2MVEBUYaWUTKgkAzkGKtSB4ayFp21NbqShMc/";
1423     uint256 public constant MAX_MINT_PER_ADDR = 5;
1424     uint256 public constant MAX_FREE_MINT_PER_ADDR = 1;
1425     uint256 public PUBLIC_PRICE = 0.001 * 10**18;
1426     uint256 public constant MAX_SUPPLY = 667;
1427     uint256 public constant FREE_MINT_SUPPLY = 111;
1428     uint256 public INSTANT_FREE_MINTED = 0;
1429 
1430     event Minted(address minter, uint256 amount);
1431 
1432     constructor(string memory initBaseURI) ERC721A("Scary Guyz", "SG") {
1433         baseURI = initBaseURI;
1434         _safeMint(msg.sender, MAX_FREE_MINT_PER_ADDR);
1435     }
1436 
1437     function _baseURI() internal view override returns (string memory) {
1438         return baseURI;
1439     }
1440     function ownerMint(uint quantity, address user)
1441     public
1442     onlyOwner
1443     {
1444     require(
1445       quantity > 0,
1446       "Invalid mint amount"
1447     );
1448     require(
1449       totalSupply() + quantity <= MAX_SUPPLY,
1450       "Maximum supply exceeded"
1451     );
1452     _safeMint(user, quantity);
1453     }
1454 
1455     function _startTokenId() internal view virtual override returns (uint256) {
1456         return 1;
1457     }
1458 
1459     function tokenURI(uint256 _tokenId)
1460         public
1461         view
1462         virtual
1463         override
1464         returns (string memory)
1465     {
1466         require(
1467             _exists(_tokenId),
1468             "ERC721Metadata: URI query for nonexistent token"
1469         );
1470         return
1471             string(
1472                 abi.encodePacked(baseURI, "/", _tokenId.toString(), ".json")
1473             );
1474     }
1475 
1476     function setBaseURI(string calldata newBaseURI) external onlyOwner {
1477         baseURI = newBaseURI;
1478     }
1479 
1480     function mint(uint256 quantity) external payable nonReentrant {
1481         require(isPublicSaleActive, "Public sale is not open");
1482         require(tx.origin == msg.sender, "-Contract call not allowed-");
1483         require(
1484             numberMinted(msg.sender) + quantity <= MAX_MINT_PER_ADDR,
1485             "-This is more than allowed-"
1486         );
1487         require(
1488             totalSupply() + quantity <= MAX_SUPPLY,
1489             "-Not enough quantity-"
1490         );
1491 
1492         uint256 _cost;
1493         if (INSTANT_FREE_MINTED < FREE_MINT_SUPPLY) {
1494             uint256 remainFreeAmont = (numberMinted(msg.sender) <
1495                 MAX_FREE_MINT_PER_ADDR)
1496                 ? (MAX_FREE_MINT_PER_ADDR - numberMinted(msg.sender))
1497                 : 0;
1498 
1499             _cost =
1500                 PUBLIC_PRICE *
1501                 (
1502                     (quantity <= remainFreeAmont)
1503                         ? 0
1504                         : (quantity - remainFreeAmont)
1505                 );
1506 
1507             INSTANT_FREE_MINTED += (
1508                 (quantity <= remainFreeAmont) ? quantity : remainFreeAmont
1509             );
1510         } else {
1511             _cost = PUBLIC_PRICE * quantity;
1512         }
1513         require(msg.value >= _cost, "-Not enough ETH-");
1514         _safeMint(msg.sender, quantity);
1515         emit Minted(msg.sender, quantity);
1516     }
1517 
1518     function numberMinted(address owner) public view returns (uint256) {
1519         return _numberMinted(owner);
1520     }
1521     
1522     function setIsPublicSaleActive(bool _isPublicSaleActive)
1523       external
1524       onlyOwner
1525   {
1526       isPublicSaleActive = _isPublicSaleActive;
1527   }
1528 
1529 
1530     function withdraw(address payable recipient)
1531         external
1532         onlyOwner
1533         nonReentrant
1534     {
1535         uint256 balance = address(this).balance;
1536         (bool success, ) = recipient.call{value: balance}("");
1537         require(success, "-Withdraw failed-");
1538     }
1539 
1540     function updatePrice(uint256 __price) external onlyOwner {
1541         PUBLIC_PRICE = __price;
1542     }
1543 }