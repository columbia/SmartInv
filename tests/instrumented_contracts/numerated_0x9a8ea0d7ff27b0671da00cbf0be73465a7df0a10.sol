1 // File: contracts/sketch.sol
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2022-07-19
5 */
6 
7 // File: contracts/trest.sol
8 
9 
10 //SPDX-License-Identifier: MIT
11 
12 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
13 
14 
15 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
16 
17 pragma solidity ^0.8.0;
18 
19 /**
20  * @dev Contract module that helps prevent reentrant calls to a function.
21  *
22  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
23  * available, which can be applied to functions to make sure there are no nested
24  * (reentrant) calls to them.
25  *
26  * Note that because there is a single `nonReentrant` guard, functions marked as
27  * `nonReentrant` may not call one another. This can be worked around by making
28  * those functions `private`, and then adding `external` `nonReentrant` entry
29  * points to them.
30  *
31  * TIP: If you would like to learn more about reentrancy and alternative ways
32  * to protect against it, check out our blog post
33  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
34  */
35 abstract contract ReentrancyGuard {
36     // Booleans are more expensive than uint256 or any type that takes up a full
37     // word because each write operation emits an extra SLOAD to first read the
38     // slot's contents, replace the bits taken up by the boolean, and then write
39     // back. This is the compiler's defense against contract upgrades and
40     // pointer aliasing, and it cannot be disabled.
41 
42     // The values being non-zero value makes deployment a bit more expensive,
43     // but in exchange the refund on every call to nonReentrant will be lower in
44     // amount. Since refunds are capped to a percentage of the total
45     // transaction's gas, it is best to keep them low in cases like this one, to
46     // increase the likelihood of the full refund coming into effect.
47     uint256 private constant _NOT_ENTERED = 1;
48     uint256 private constant _ENTERED = 2;
49 
50     uint256 private _status;
51 
52     constructor() {
53         _status = _NOT_ENTERED;
54     }
55 
56     /**
57      * @dev Prevents a contract from calling itself, directly or indirectly.
58      * Calling a `nonReentrant` function from another `nonReentrant`
59      * function is not supported. It is possible to prevent this from happening
60      * by making the `nonReentrant` function external, and making it call a
61      * `private` function that does the actual work.
62      */
63     modifier nonReentrant() {
64         // On the first call to nonReentrant, _notEntered will be true
65         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
66 
67         // Any calls to nonReentrant after this point will fail
68         _status = _ENTERED;
69 
70         _;
71 
72         // By storing the original value once again, a refund is triggered (see
73         // https://eips.ethereum.org/EIPS/eip-2200)
74         _status = _NOT_ENTERED;
75     }
76 }
77 
78 // File: @openzeppelin/contracts/utils/Strings.sol
79 
80 
81 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
82 
83 pragma solidity ^0.8.0;
84 
85 /**
86  * @dev String operations.
87  */
88 library Strings {
89     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
90     uint8 private constant _ADDRESS_LENGTH = 20;
91 
92     /**
93      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
94      */
95     function toString(uint256 value) internal pure returns (string memory) {
96         // Inspired by OraclizeAPI's implementation - MIT licence
97         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
98 
99         if (value == 0) {
100             return "0";
101         }
102         uint256 temp = value;
103         uint256 digits;
104         while (temp != 0) {
105             digits++;
106             temp /= 10;
107         }
108         bytes memory buffer = new bytes(digits);
109         while (value != 0) {
110             digits -= 1;
111             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
112             value /= 10;
113         }
114         return string(buffer);
115     }
116 
117     /**
118      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
119      */
120     function toHexString(uint256 value) internal pure returns (string memory) {
121         if (value == 0) {
122             return "0x00";
123         }
124         uint256 temp = value;
125         uint256 length = 0;
126         while (temp != 0) {
127             length++;
128             temp >>= 8;
129         }
130         return toHexString(value, length);
131     }
132 
133     /**
134      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
135      */
136     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
137         bytes memory buffer = new bytes(2 * length + 2);
138         buffer[0] = "0";
139         buffer[1] = "x";
140         for (uint256 i = 2 * length + 1; i > 1; --i) {
141             buffer[i] = _HEX_SYMBOLS[value & 0xf];
142             value >>= 4;
143         }
144         require(value == 0, "Strings: hex length insufficient");
145         return string(buffer);
146     }
147 
148     /**
149      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
150      */
151     function toHexString(address addr) internal pure returns (string memory) {
152         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
153     }
154 }
155 
156 // File: @openzeppelin/contracts/utils/Address.sol
157 
158 
159 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
160 
161 pragma solidity ^0.8.1;
162 
163 /**
164  * @dev Collection of functions related to the address type
165  */
166 library Address {
167     /**
168      * @dev Returns true if `account` is a contract.
169      *
170      * [IMPORTANT]
171      * ====
172      * It is unsafe to assume that an address for which this function returns
173      * false is an externally-owned account (EOA) and not a contract.
174      *
175      * Among others, `isContract` will return false for the following
176      * types of addresses:
177      *
178      *  - an externally-owned account
179      *  - a contract in construction
180      *  - an address where a contract will be created
181      *  - an address where a contract lived, but was destroyed
182      * ====
183      *
184      * [IMPORTANT]
185      * ====
186      * You shouldn't rely on `isContract` to protect against flash loan attacks!
187      *
188      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
189      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
190      * constructor.
191      * ====
192      */
193     function isContract(address account) internal view returns (bool) {
194         // This method relies on extcodesize/address.code.length, which returns 0
195         // for contracts in construction, since the code is only stored at the end
196         // of the constructor execution.
197 
198         return account.code.length > 0;
199     }
200 
201     /**
202      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
203      * `recipient`, forwarding all available gas and reverting on errors.
204      *
205      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
206      * of certain opcodes, possibly making contracts go over the 2300 gas limit
207      * imposed by `transfer`, making them unable to receive funds via
208      * `transfer`. {sendValue} removes this limitation.
209      *
210      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
211      *
212      * IMPORTANT: because control is transferred to `recipient`, care must be
213      * taken to not create reentrancy vulnerabilities. Consider using
214      * {ReentrancyGuard} or the
215      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
216      */
217     function sendValue(address payable recipient, uint256 amount) internal {
218         require(address(this).balance >= amount, "Address: insufficient balance");
219 
220         (bool success, ) = recipient.call{value: amount}("");
221         require(success, "Address: unable to send value, recipient may have reverted");
222     }
223 
224     /**
225      * @dev Performs a Solidity function call using a low level `call`. A
226      * plain `call` is an unsafe replacement for a function call: use this
227      * function instead.
228      *
229      * If `target` reverts with a revert reason, it is bubbled up by this
230      * function (like regular Solidity function calls).
231      *
232      * Returns the raw returned data. To convert to the expected return value,
233      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
234      *
235      * Requirements:
236      *
237      * - `target` must be a contract.
238      * - calling `target` with `data` must not revert.
239      *
240      * _Available since v3.1._
241      */
242     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
243         return functionCall(target, data, "Address: low-level call failed");
244     }
245 
246     /**
247      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
248      * `errorMessage` as a fallback revert reason when `target` reverts.
249      *
250      * _Available since v3.1._
251      */
252     function functionCall(
253         address target,
254         bytes memory data,
255         string memory errorMessage
256     ) internal returns (bytes memory) {
257         return functionCallWithValue(target, data, 0, errorMessage);
258     }
259 
260     /**
261      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
262      * but also transferring `value` wei to `target`.
263      *
264      * Requirements:
265      *
266      * - the calling contract must have an ETH balance of at least `value`.
267      * - the called Solidity function must be `payable`.
268      *
269      * _Available since v3.1._
270      */
271     function functionCallWithValue(
272         address target,
273         bytes memory data,
274         uint256 value
275     ) internal returns (bytes memory) {
276         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
277     }
278 
279     /**
280      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
281      * with `errorMessage` as a fallback revert reason when `target` reverts.
282      *
283      * _Available since v3.1._
284      */
285     function functionCallWithValue(
286         address target,
287         bytes memory data,
288         uint256 value,
289         string memory errorMessage
290     ) internal returns (bytes memory) {
291         require(address(this).balance >= value, "Address: insufficient balance for call");
292         require(isContract(target), "Address: call to non-contract");
293 
294         (bool success, bytes memory returndata) = target.call{value: value}(data);
295         return verifyCallResult(success, returndata, errorMessage);
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
300      * but performing a static call.
301      *
302      * _Available since v3.3._
303      */
304     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
305         return functionStaticCall(target, data, "Address: low-level static call failed");
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
310      * but performing a static call.
311      *
312      * _Available since v3.3._
313      */
314     function functionStaticCall(
315         address target,
316         bytes memory data,
317         string memory errorMessage
318     ) internal view returns (bytes memory) {
319         require(isContract(target), "Address: static call to non-contract");
320 
321         (bool success, bytes memory returndata) = target.staticcall(data);
322         return verifyCallResult(success, returndata, errorMessage);
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
327      * but performing a delegate call.
328      *
329      * _Available since v3.4._
330      */
331     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
332         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
337      * but performing a delegate call.
338      *
339      * _Available since v3.4._
340      */
341     function functionDelegateCall(
342         address target,
343         bytes memory data,
344         string memory errorMessage
345     ) internal returns (bytes memory) {
346         require(isContract(target), "Address: delegate call to non-contract");
347 
348         (bool success, bytes memory returndata) = target.delegatecall(data);
349         return verifyCallResult(success, returndata, errorMessage);
350     }
351 
352     /**
353      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
354      * revert reason using the provided one.
355      *
356      * _Available since v4.3._
357      */
358     function verifyCallResult(
359         bool success,
360         bytes memory returndata,
361         string memory errorMessage
362     ) internal pure returns (bytes memory) {
363         if (success) {
364             return returndata;
365         } else {
366             // Look for revert reason and bubble it up if present
367             if (returndata.length > 0) {
368                 // The easiest way to bubble the revert reason is using memory via assembly
369                 /// @solidity memory-safe-assembly
370                 assembly {
371                     let returndata_size := mload(returndata)
372                     revert(add(32, returndata), returndata_size)
373                 }
374             } else {
375                 revert(errorMessage);
376             }
377         }
378     }
379 }
380 
381 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
382 
383 
384 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
385 
386 pragma solidity ^0.8.0;
387 
388 /**
389  * @title ERC721 token receiver interface
390  * @dev Interface for any contract that wants to support safeTransfers
391  * from ERC721 asset contracts.
392  */
393 interface IERC721Receiver {
394     /**
395      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
396      * by `operator` from `from`, this function is called.
397      *
398      * It must return its Solidity selector to confirm the token transfer.
399      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
400      *
401      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
402      */
403     function onERC721Received(
404         address operator,
405         address from,
406         uint256 tokenId,
407         bytes calldata data
408     ) external returns (bytes4);
409 }
410 
411 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
412 
413 
414 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
415 
416 pragma solidity ^0.8.0;
417 
418 /**
419  * @dev Interface of the ERC165 standard, as defined in the
420  * https://eips.ethereum.org/EIPS/eip-165[EIP].
421  *
422  * Implementers can declare support of contract interfaces, which can then be
423  * queried by others ({ERC165Checker}).
424  *
425  * For an implementation, see {ERC165}.
426  */
427 interface IERC165 {
428     /**
429      * @dev Returns true if this contract implements the interface defined by
430      * `interfaceId`. See the corresponding
431      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
432      * to learn more about how these ids are created.
433      *
434      * This function call must use less than 30 000 gas.
435      */
436     function supportsInterface(bytes4 interfaceId) external view returns (bool);
437 }
438 
439 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
440 
441 
442 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
443 
444 pragma solidity ^0.8.0;
445 
446 
447 /**
448  * @dev Implementation of the {IERC165} interface.
449  *
450  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
451  * for the additional interface id that will be supported. For example:
452  *
453  * ```solidity
454  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
455  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
456  * }
457  * ```
458  *
459  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
460  */
461 abstract contract ERC165 is IERC165 {
462     /**
463      * @dev See {IERC165-supportsInterface}.
464      */
465     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
466         return interfaceId == type(IERC165).interfaceId;
467     }
468 }
469 
470 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
471 
472 
473 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
474 
475 pragma solidity ^0.8.0;
476 
477 
478 /**
479  * @dev Required interface of an ERC721 compliant contract.
480  */
481 interface IERC721 is IERC165 {
482     /**
483      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
484      */
485     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
486 
487     /**
488      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
489      */
490     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
491 
492     /**
493      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
494      */
495     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
496 
497     /**
498      * @dev Returns the number of tokens in ``owner``'s account.
499      */
500     function balanceOf(address owner) external view returns (uint256 balance);
501 
502     /**
503      * @dev Returns the owner of the `tokenId` token.
504      *
505      * Requirements:
506      *
507      * - `tokenId` must exist.
508      */
509     function ownerOf(uint256 tokenId) external view returns (address owner);
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
530 
531     /**
532      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
533      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
534      *
535      * Requirements:
536      *
537      * - `from` cannot be the zero address.
538      * - `to` cannot be the zero address.
539      * - `tokenId` token must exist and be owned by `from`.
540      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
541      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
542      *
543      * Emits a {Transfer} event.
544      */
545     function safeTransferFrom(
546         address from,
547         address to,
548         uint256 tokenId
549     ) external;
550 
551     /**
552      * @dev Transfers `tokenId` token from `from` to `to`.
553      *
554      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
555      *
556      * Requirements:
557      *
558      * - `from` cannot be the zero address.
559      * - `to` cannot be the zero address.
560      * - `tokenId` token must be owned by `from`.
561      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
562      *
563      * Emits a {Transfer} event.
564      */
565     function transferFrom(
566         address from,
567         address to,
568         uint256 tokenId
569     ) external;
570 
571     /**
572      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
573      * The approval is cleared when the token is transferred.
574      *
575      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
576      *
577      * Requirements:
578      *
579      * - The caller must own the token or be an approved operator.
580      * - `tokenId` must exist.
581      *
582      * Emits an {Approval} event.
583      */
584     function approve(address to, uint256 tokenId) external;
585 
586     /**
587      * @dev Approve or remove `operator` as an operator for the caller.
588      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
589      *
590      * Requirements:
591      *
592      * - The `operator` cannot be the caller.
593      *
594      * Emits an {ApprovalForAll} event.
595      */
596     function setApprovalForAll(address operator, bool _approved) external;
597 
598     /**
599      * @dev Returns the account approved for `tokenId` token.
600      *
601      * Requirements:
602      *
603      * - `tokenId` must exist.
604      */
605     function getApproved(uint256 tokenId) external view returns (address operator);
606 
607     /**
608      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
609      *
610      * See {setApprovalForAll}
611      */
612     function isApprovedForAll(address owner, address operator) external view returns (bool);
613 }
614 
615 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
616 
617 
618 
619 
620 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
621 
622 pragma solidity ^0.8.0;
623 
624 
625 /**
626  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
627  * @dev See https://eips.ethereum.org/EIPS/eip-721
628  */
629 interface IERC721Enumerable is IERC721 {
630     /**
631      * @dev Returns the total amount of tokens stored by the contract.
632      */
633     function totalSupply() external view returns (uint256);
634 
635     /**
636      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
637      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
638      */
639     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
640 
641     /**
642      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
643      * Use along with {totalSupply} to enumerate all tokens.
644      */
645     function tokenByIndex(uint256 index) external view returns (uint256);
646 }
647 
648 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
649 
650 
651 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
652 
653 pragma solidity ^0.8.0;
654 
655 
656 /**
657  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
658  * @dev See https://eips.ethereum.org/EIPS/eip-721
659  */
660 interface IERC721Metadata is IERC721 {
661     /**
662      * @dev Returns the token collection name.
663      */
664     function name() external view returns (string memory);
665 
666     /**
667      * @dev Returns the token collection symbol.
668      */
669     function symbol() external view returns (string memory);
670 
671     /**
672      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
673      */
674     function tokenURI(uint256 tokenId) external view returns (string memory);
675 }
676 
677 // File: @openzeppelin/contracts/utils/Context.sol
678 
679 
680 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
681 
682 pragma solidity ^0.8.0;
683 
684 /**
685  * @dev Provides information about the current execution context, including the
686  * sender of the transaction and its data. While these are generally available
687  * via msg.sender and msg.data, they should not be accessed in such a direct
688  * manner, since when dealing with meta-transactions the account sending and
689  * paying for execution may not be the actual sender (as far as an application
690  * is concerned).
691  *
692  * This contract is only required for intermediate, library-like contracts.
693  */
694 abstract contract Context {
695     function _msgSender() internal view virtual returns (address) {
696         return msg.sender;
697     }
698 
699     function _msgData() internal view virtual returns (bytes calldata) {
700         return msg.data;
701     }
702 }
703 
704 // File: ERC721A.sol
705 
706 
707 
708 // Creator: Chiru Labs
709 
710 pragma solidity ^0.8.4;
711 
712 
713 
714 
715 
716 
717 
718 
719 
720 error ApprovalCallerNotOwnerNorApproved();
721 error ApprovalQueryForNonexistentToken();
722 error ApproveToCaller();
723 error ApprovalToCurrentOwner();
724 error BalanceQueryForZeroAddress();
725 error MintedQueryForZeroAddress();
726 error BurnedQueryForZeroAddress();
727 error AuxQueryForZeroAddress();
728 error MintToZeroAddress();
729 error MintZeroQuantity();
730 error OwnerIndexOutOfBounds();
731 error OwnerQueryForNonexistentToken();
732 error TokenIndexOutOfBounds();
733 error TransferCallerNotOwnerNorApproved();
734 error TransferFromIncorrectOwner();
735 error TransferToNonERC721ReceiverImplementer();
736 error TransferToZeroAddress();
737 error URIQueryForNonexistentToken();
738 
739 /**
740  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
741  * the Metadata extension. Built to optimize for lower gas during batch mints.
742  *
743  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
744  *
745  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
746  *
747  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
748  */
749 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
750     using Address for address;
751     using Strings for uint256;
752 
753     // Compiler will pack this into a single 256bit word.
754     struct TokenOwnership {
755         // The address of the owner.
756         address addr;
757         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
758         uint64 startTimestamp;
759         // Whether the token has been burned.
760         bool burned;
761     }
762 
763     // Compiler will pack this into a single 256bit word.
764     struct AddressData {
765         // Realistically, 2**64-1 is more than enough.
766         uint64 balance;
767         // Keeps track of mint count with minimal overhead for tokenomics.
768         uint64 numberMinted;
769         // Keeps track of burn count with minimal overhead for tokenomics.
770         uint64 numberBurned;
771         // For miscellaneous variable(s) pertaining to the address
772         // (e.g. number of whitelist mint slots used).
773         // If there are multiple variables, please pack them into a uint64.
774         uint64 aux;
775     }
776 
777     // The tokenId of the next token to be minted.
778     uint256 internal _currentIndex;
779 
780     // The number of tokens burned.
781     uint256 internal _burnCounter;
782 
783     // Token name
784     string private _name;
785 
786     // Token symbol
787     string private _symbol;
788 
789     // Mapping from token ID to ownership details
790     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
791     mapping(uint256 => TokenOwnership) internal _ownerships;
792 
793     // Mapping owner address to address data
794     mapping(address => AddressData) private _addressData;
795 
796     // Mapping from token ID to approved address
797     mapping(uint256 => address) private _tokenApprovals;
798 
799     // Mapping from owner to operator approvals
800     mapping(address => mapping(address => bool)) private _operatorApprovals;
801 
802     constructor(string memory name_, string memory symbol_) {
803         _name = name_;
804         _symbol = symbol_;
805         _currentIndex = _startTokenId();
806     }
807 
808     /**
809      * To change the starting tokenId, please override this function.
810      */
811     function _startTokenId() internal view virtual returns (uint256) {
812         return 0;
813     }
814 
815     /**
816      * @dev See {IERC721Enumerable-totalSupply}.
817      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
818      */
819     function totalSupply() public view returns (uint256) {
820         // Counter underflow is impossible as _burnCounter cannot be incremented
821         // more than _currentIndex - _startTokenId() times
822         unchecked {
823             return _currentIndex - _burnCounter - _startTokenId();
824         }
825     }
826 
827     /**
828      * Returns the total amount of tokens minted in the contract.
829      */
830     function _totalMinted() internal view returns (uint256) {
831         // Counter underflow is impossible as _currentIndex does not decrement,
832         // and it is initialized to _startTokenId()
833         unchecked {
834             return _currentIndex - _startTokenId();
835         }
836     }
837 
838     /**
839      * @dev See {IERC165-supportsInterface}.
840      */
841     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
842         return
843             interfaceId == type(IERC721).interfaceId ||
844             interfaceId == type(IERC721Metadata).interfaceId ||
845             super.supportsInterface(interfaceId);
846     }
847 
848     /**
849      * @dev See {IERC721-balanceOf}.
850      */
851     function balanceOf(address owner) public view override returns (uint256) {
852         if (owner == address(0)) revert BalanceQueryForZeroAddress();
853         return uint256(_addressData[owner].balance);
854     }
855 
856     /**
857      * Returns the number of tokens minted by `owner`.
858      */
859     function _numberMinted(address owner) internal view returns (uint256) {
860         if (owner == address(0)) revert MintedQueryForZeroAddress();
861         return uint256(_addressData[owner].numberMinted);
862     }
863 
864     /**
865      * Returns the number of tokens burned by or on behalf of `owner`.
866      */
867     function _numberBurned(address owner) internal view returns (uint256) {
868         if (owner == address(0)) revert BurnedQueryForZeroAddress();
869         return uint256(_addressData[owner].numberBurned);
870     }
871 
872     /**
873      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
874      */
875     function _getAux(address owner) internal view returns (uint64) {
876         if (owner == address(0)) revert AuxQueryForZeroAddress();
877         return _addressData[owner].aux;
878     }
879 
880     /**
881      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
882      * If there are multiple variables, please pack them into a uint64.
883      */
884     function _setAux(address owner, uint64 aux) internal {
885         if (owner == address(0)) revert AuxQueryForZeroAddress();
886         _addressData[owner].aux = aux;
887     }
888 
889     /**
890      * Gas spent here starts off proportional to the maximum mint batch size.
891      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
892      */
893     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
894         uint256 curr = tokenId;
895 
896         unchecked {
897             if (_startTokenId() <= curr && curr < _currentIndex) {
898                 TokenOwnership memory ownership = _ownerships[curr];
899                 if (!ownership.burned) {
900                     if (ownership.addr != address(0)) {
901                         return ownership;
902                     }
903                     // Invariant:
904                     // There will always be an ownership that has an address and is not burned
905                     // before an ownership that does not have an address and is not burned.
906                     // Hence, curr will not underflow.
907                     while (true) {
908                         curr--;
909                         ownership = _ownerships[curr];
910                         if (ownership.addr != address(0)) {
911                             return ownership;
912                         }
913                     }
914                 }
915             }
916         }
917         revert OwnerQueryForNonexistentToken();
918     }
919 
920 
921     /**
922      * @dev See {IERC721-ownerOf}.
923      */
924     function ownerOf(uint256 tokenId) public view override returns (address) {
925         return ownershipOf(tokenId).addr;
926     }
927 
928     /**
929      * @dev See {IERC721Metadata-name}.
930      */
931     function name() public view virtual override returns (string memory) {
932         return _name;
933     }
934 
935     /**
936      * @dev See {IERC721Metadata-symbol}.
937      */
938     function symbol() public view virtual override returns (string memory) {
939         return _symbol;
940     }
941 
942     /**
943      * @dev See {IERC721Metadata-tokenURI}.
944      */
945     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
946         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
947 
948         string memory baseURI = _baseURI();
949         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
950     }
951 
952     /**
953      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
954      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
955      * by default, can be overriden in child contracts.
956      */
957     function _baseURI() internal view virtual returns (string memory) {
958         return '';
959     }
960 
961     /**
962      * @dev See {IERC721-approve}.
963      */
964     function approve(address to, uint256 tokenId) public override {
965         address owner = ERC721A.ownerOf(tokenId);
966         if (to == owner) revert ApprovalToCurrentOwner();
967 
968         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
969             revert ApprovalCallerNotOwnerNorApproved();
970         }
971 
972         _approve(to, tokenId, owner);
973     }
974 
975     /**
976      * @dev See {IERC721-getApproved}.
977      */
978     function getApproved(uint256 tokenId) public view override returns (address) {
979         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
980 
981         return _tokenApprovals[tokenId];
982     }
983 
984     /**
985      * @dev See {IERC721-setApprovalForAll}.
986      */
987     function setApprovalForAll(address operator, bool approved) public override {
988         if (operator == _msgSender()) revert ApproveToCaller();
989 
990         _operatorApprovals[_msgSender()][operator] = approved;
991         emit ApprovalForAll(_msgSender(), operator, approved);
992     }
993 
994     /**
995      * @dev See {IERC721-isApprovedForAll}.
996      */
997     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
998         return _operatorApprovals[owner][operator];
999     }
1000 
1001     /**
1002      * @dev See {IERC721-transferFrom}.
1003      */
1004     function transferFrom(
1005         address from,
1006         address to,
1007         uint256 tokenId
1008     ) public virtual override {
1009         _transfer(from, to, tokenId);
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-safeTransferFrom}.
1014      */
1015     function safeTransferFrom(
1016         address from,
1017         address to,
1018         uint256 tokenId
1019     ) public virtual override {
1020         safeTransferFrom(from, to, tokenId, '');
1021     }
1022 
1023     /**
1024      * @dev See {IERC721-safeTransferFrom}.
1025      */
1026     function safeTransferFrom(
1027         address from,
1028         address to,
1029         uint256 tokenId,
1030         bytes memory _data
1031     ) public virtual override {
1032         _transfer(from, to, tokenId);
1033         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1034             revert TransferToNonERC721ReceiverImplementer();
1035         }
1036     }
1037 
1038     /**
1039      * @dev Returns whether `tokenId` exists.
1040      *
1041      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1042      *
1043      * Tokens start existing when they are minted (`_mint`),
1044      */
1045     function _exists(uint256 tokenId) internal view returns (bool) {
1046         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1047             !_ownerships[tokenId].burned;
1048     }
1049 
1050     function _safeMint(address to, uint256 quantity) internal {
1051         _safeMint(to, quantity, '');
1052     }
1053 
1054     /**
1055      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1056      *
1057      * Requirements:
1058      *
1059      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1060      * - `quantity` must be greater than 0.
1061      *
1062      * Emits a {Transfer} event.
1063      */
1064     function _safeMint(
1065         address to,
1066         uint256 quantity,
1067         bytes memory _data
1068     ) internal {
1069         _mint(to, quantity, _data, true);
1070     }
1071 
1072 
1073 
1074 
1075     /**
1076      * @dev Mints `quantity` tokens and transfers them to `to`.
1077      *
1078      * Requirements:
1079      *
1080      * - `to` cannot be the zero address.
1081      * - `quantity` must be greater than 0.
1082      *
1083      * Emits a {Transfer} event.
1084      */
1085     function _mint(
1086         address to,
1087         uint256 quantity,
1088         bytes memory _data,
1089         bool safe
1090     ) internal {
1091         uint256 startTokenId = _currentIndex;
1092         if (to == address(0)) revert MintToZeroAddress();
1093         if (quantity == 0) revert MintZeroQuantity();
1094 
1095         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1096 
1097         // Overflows are incredibly unrealistic.
1098         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1099         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1100         unchecked {
1101             _addressData[to].balance += uint64(quantity);
1102             _addressData[to].numberMinted += uint64(quantity);
1103 
1104             _ownerships[startTokenId].addr = to;
1105             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1106 
1107             uint256 updatedIndex = startTokenId;
1108             uint256 end = updatedIndex + quantity;
1109 
1110             if (safe && to.isContract()) {
1111                 do {
1112                     emit Transfer(address(0), to, updatedIndex);
1113                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1114                         revert TransferToNonERC721ReceiverImplementer();
1115                     }
1116                 } while (updatedIndex != end);
1117                 // Reentrancy protection
1118                 if (_currentIndex != startTokenId) revert();
1119             } else {
1120                 do {
1121                     emit Transfer(address(0), to, updatedIndex++);
1122                 } while (updatedIndex != end);
1123             }
1124             _currentIndex = updatedIndex;
1125         }
1126         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1127     }
1128 
1129     /**
1130      * @dev Transfers `tokenId` from `from` to `to`.
1131      *
1132      * Requirements:
1133      *
1134      * - `to` cannot be the zero address.
1135      * - `tokenId` token must be owned by `from`.
1136      *
1137      * Emits a {Transfer} event.
1138      */
1139     function _transfer(
1140         address from,
1141         address to,
1142         uint256 tokenId
1143     ) private {
1144         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1145 
1146         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1147             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1148             getApproved(tokenId) == _msgSender());
1149 
1150         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1151         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1152         if (to == address(0)) revert TransferToZeroAddress();
1153 
1154         _beforeTokenTransfers(from, to, tokenId, 1);
1155 
1156         // Clear approvals from the previous owner
1157         _approve(address(0), tokenId, prevOwnership.addr);
1158 
1159         // Underflow of the sender's balance is impossible because we check for
1160         // ownership above and the recipient's balance can't realistically overflow.
1161         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1162         unchecked {
1163             _addressData[from].balance -= 1;
1164             _addressData[to].balance += 1;
1165 
1166             _ownerships[tokenId].addr = to;
1167             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1168 
1169             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1170             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1171             uint256 nextTokenId = tokenId + 1;
1172             if (_ownerships[nextTokenId].addr == address(0)) {
1173                 // This will suffice for checking _exists(nextTokenId),
1174                 // as a burned slot cannot contain the zero address.
1175                 if (nextTokenId < _currentIndex) {
1176                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1177                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1178                 }
1179             }
1180         }
1181 
1182         emit Transfer(from, to, tokenId);
1183         _afterTokenTransfers(from, to, tokenId, 1);
1184     }
1185 
1186     /**
1187      * @dev Destroys `tokenId`.
1188      * The approval is cleared when the token is burned.
1189      *
1190      * Requirements:
1191      *
1192      * - `tokenId` must exist.
1193      *
1194      * Emits a {Transfer} event.
1195      */
1196     function _burn(uint256 tokenId) internal virtual {
1197         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1198 
1199         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1200 
1201         // Clear approvals from the previous owner
1202         _approve(address(0), tokenId, prevOwnership.addr);
1203 
1204         // Underflow of the sender's balance is impossible because we check for
1205         // ownership above and the recipient's balance can't realistically overflow.
1206         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1207         unchecked {
1208             _addressData[prevOwnership.addr].balance -= 1;
1209             _addressData[prevOwnership.addr].numberBurned += 1;
1210 
1211             // Keep track of who burned the token, and the timestamp of burning.
1212             _ownerships[tokenId].addr = prevOwnership.addr;
1213             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1214             _ownerships[tokenId].burned = true;
1215 
1216             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1217             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1218             uint256 nextTokenId = tokenId + 1;
1219             if (_ownerships[nextTokenId].addr == address(0)) {
1220                 // This will suffice for checking _exists(nextTokenId),
1221                 // as a burned slot cannot contain the zero address.
1222                 if (nextTokenId < _currentIndex) {
1223                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1224                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1225                 }
1226             }
1227         }
1228 
1229         emit Transfer(prevOwnership.addr, address(0), tokenId);
1230         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1231 
1232         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1233         unchecked {
1234             _burnCounter++;
1235         }
1236     }
1237 
1238     /**
1239      * @dev Approve `to` to operate on `tokenId`
1240      *
1241      * Emits a {Approval} event.
1242      */
1243     function _approve(
1244         address to,
1245         uint256 tokenId,
1246         address owner
1247     ) private {
1248         _tokenApprovals[tokenId] = to;
1249         emit Approval(owner, to, tokenId);
1250     }
1251 
1252     /**
1253      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1254      *
1255      * @param from address representing the previous owner of the given token ID
1256      * @param to target address that will receive the tokens
1257      * @param tokenId uint256 ID of the token to be transferred
1258      * @param _data bytes optional data to send along with the call
1259      * @return bool whether the call correctly returned the expected magic value
1260      */
1261     function _checkContractOnERC721Received(
1262         address from,
1263         address to,
1264         uint256 tokenId,
1265         bytes memory _data
1266     ) private returns (bool) {
1267         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1268             return retval == IERC721Receiver(to).onERC721Received.selector;
1269         } catch (bytes memory reason) {
1270             if (reason.length == 0) {
1271                 revert TransferToNonERC721ReceiverImplementer();
1272             } else {
1273                 assembly {
1274                     revert(add(32, reason), mload(reason))
1275                 }
1276             }
1277         }
1278     }
1279 
1280     /**
1281      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1282      * And also called before burning one token.
1283      *
1284      * startTokenId - the first token id to be transferred
1285      * quantity - the amount to be transferred
1286      *
1287      * Calling conditions:
1288      *
1289      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1290      * transferred to `to`.
1291      * - When `from` is zero, `tokenId` will be minted for `to`.
1292      * - When `to` is zero, `tokenId` will be burned by `from`.
1293      * - `from` and `to` are never both zero.
1294      */
1295     function _beforeTokenTransfers(
1296         address from,
1297         address to,
1298         uint256 startTokenId,
1299         uint256 quantity
1300     ) internal virtual {}
1301 
1302     /**
1303      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1304      * minting.
1305      * And also called after one token has been burned.
1306      *
1307      * startTokenId - the first token id to be transferred
1308      * quantity - the amount to be transferred
1309      *
1310      * Calling conditions:
1311      *
1312      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1313      * transferred to `to`.
1314      * - When `from` is zero, `tokenId` has been minted for `to`.
1315      * - When `to` is zero, `tokenId` has been burned by `from`.
1316      * - `from` and `to` are never both zero.
1317      */
1318     function _afterTokenTransfers(
1319         address from,
1320         address to,
1321         uint256 startTokenId,
1322         uint256 quantity
1323     ) internal virtual {}
1324 }
1325 // File: @openzeppelin/contracts/access/Ownable.sol
1326 
1327 
1328 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1329 
1330 pragma solidity ^0.8.0;
1331 
1332 
1333 /**
1334  * @dev Contract module which provides a basic access control mechanism, where
1335  * there is an account (an owner) that can be granted exclusive access to
1336  * specific functions.
1337  *
1338  * By default, the owner account will be the one that deploys the contract. This
1339  * can later be changed with {transferOwnership}.
1340  *
1341  * This module is used through inheritance. It will make available the modifier
1342  * `onlyOwner`, which can be applied to your functions to restrict their use to
1343  * the owner.
1344  */
1345 abstract contract Ownable is Context {
1346     address private _owner;
1347 
1348     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1349 
1350     /**
1351      * @dev Initializes the contract setting the deployer as the initial owner.
1352      */
1353     constructor() {
1354         _transferOwnership(_msgSender());
1355     }
1356 
1357     /**
1358      * @dev Throws if called by any account other than the owner.
1359      */
1360     modifier onlyOwner() {
1361         _checkOwner();
1362         _;
1363     }
1364 
1365     /**
1366      * @dev Returns the address of the current owner.
1367      */
1368     function owner() public view virtual returns (address) {
1369         return _owner;
1370     }
1371 
1372     /**
1373      * @dev Throws if the sender is not the owner.
1374      */
1375     function _checkOwner() internal view virtual {
1376         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1377     }
1378 
1379 
1380 
1381     /**
1382      * @dev Leaves the contract without owner. It will not be possible to call
1383      * `onlyOwner` functions anymore. Can only be called by the current owner.
1384      *
1385      * NOTE: Renouncing ownership will leave the contract without an owner,
1386      * thereby removing any functionality that is only available to the owner.
1387      */
1388     function renounceOwnership() public virtual onlyOwner {
1389         _transferOwnership(address(0));
1390     }
1391 
1392     /**
1393      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1394      * Can only be called by the current owner.
1395      */
1396     function transferOwnership(address newOwner) public virtual onlyOwner {
1397         require(newOwner != address(0), "Ownable: new owner is the zero address");
1398         _transferOwnership(newOwner);
1399     }
1400 
1401     /**
1402      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1403      * Internal function without access restriction.
1404      */
1405     function _transferOwnership(address newOwner) internal virtual {
1406         address oldOwner = _owner;
1407         _owner = newOwner;
1408         emit OwnershipTransferred(oldOwner, newOwner);
1409     }
1410 }
1411 
1412 
1413 
1414 
1415 pragma solidity ^0.8.2;
1416 
1417 
1418 
1419 
1420 contract SpectacleByGaelLangley is ERC721A, Ownable, ReentrancyGuard {
1421     enum Status {
1422         Waiting,
1423         Started,
1424         Finished
1425     }
1426     using Strings for uint256;
1427     bool public isPublicSaleActive = false;
1428     string private baseURI = "ipfs://Qme6DbGM9yWbZEDFfPLcpkEWNJ7LxNteQEVZsWYwFo9pjs/";
1429     uint256 public constant MAX_MINT_PER_ADDR = 2;
1430     uint256 public constant MAX_FREE_MINT_PER_ADDR = 2;
1431     uint256 public PUBLIC_PRICE = 0.005 * 10**18;
1432     uint256 public constant MAX_SUPPLY = 1000;
1433     uint256 public constant FREE_MINT_SUPPLY = 300;
1434     uint256 public INSTANT_FREE_MINTED = 1;
1435 
1436     event Minted(address minter, uint256 amount);
1437 
1438     constructor(string memory initBaseURI) ERC721A("SpectacleByGaelLangley", "SP") {
1439         baseURI = initBaseURI;
1440         _safeMint(msg.sender, MAX_FREE_MINT_PER_ADDR);
1441     }
1442 
1443     function _baseURI() internal view override returns (string memory) {
1444         return baseURI;
1445     }
1446 
1447     function _startTokenId() internal view virtual override returns (uint256) {
1448         return 1;
1449     }
1450 
1451     function tokenURI(uint256 _tokenId)
1452         public
1453         view
1454         virtual
1455         override
1456         returns (string memory)
1457     {
1458         require(
1459             _exists(_tokenId),
1460             "ERC721Metadata: URI query for nonexistent token"
1461         );
1462         return
1463             string(
1464                 abi.encodePacked(baseURI, "/", _tokenId.toString(), ".json")
1465             );
1466     }
1467 
1468     function setBaseURI(string calldata newBaseURI) external onlyOwner {
1469         baseURI = newBaseURI;
1470     }
1471 
1472     function mint(uint256 quantity) external payable nonReentrant {
1473         require(isPublicSaleActive, "Public sale is not open");
1474         require(tx.origin == msg.sender, "-Contract call not allowed-");
1475         require(
1476             numberMinted(msg.sender) + quantity <= MAX_MINT_PER_ADDR,
1477             "-This is more than allowed-"
1478         );
1479         require(
1480             totalSupply() + quantity <= MAX_SUPPLY,
1481             "-Not enough quantity-"
1482         );
1483 
1484         uint256 _cost;
1485         if (INSTANT_FREE_MINTED < FREE_MINT_SUPPLY) {
1486             uint256 remainFreeAmont = (numberMinted(msg.sender) <
1487                 MAX_FREE_MINT_PER_ADDR)
1488                 ? (MAX_FREE_MINT_PER_ADDR - numberMinted(msg.sender))
1489                 : 0;
1490 
1491             _cost =
1492                 PUBLIC_PRICE *
1493                 (
1494                     (quantity <= remainFreeAmont)
1495                         ? 0
1496                         : (quantity - remainFreeAmont)
1497                 );
1498 
1499             INSTANT_FREE_MINTED += (
1500                 (quantity <= remainFreeAmont) ? quantity : remainFreeAmont
1501             );
1502         } else {
1503             _cost = PUBLIC_PRICE * quantity;
1504         }
1505         require(msg.value >= _cost, "-Not enough ETH-");
1506         _safeMint(msg.sender, quantity);
1507         emit Minted(msg.sender, quantity);
1508     }
1509 
1510     function numberMinted(address owner) public view returns (uint256) {
1511         return _numberMinted(owner);
1512     }
1513     
1514     function setIsPublicSaleActive(bool _isPublicSaleActive)
1515       external
1516       onlyOwner
1517   {
1518       isPublicSaleActive = _isPublicSaleActive;
1519   }
1520 
1521 
1522     function withdraw(address payable recipient)
1523         external
1524         onlyOwner
1525         nonReentrant
1526     {
1527         uint256 balance = address(this).balance;
1528         (bool success, ) = recipient.call{value: balance}("");
1529         require(success, "-Withdraw failed-");
1530     }
1531 
1532     function updatePrice(uint256 __price) external onlyOwner {
1533         PUBLIC_PRICE = __price;
1534     }
1535 }