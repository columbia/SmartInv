1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Address.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Collection of functions related to the address type
80  */
81 library Address {
82     /**
83      * @dev Returns true if `account` is a contract.
84      *
85      * [IMPORTANT]
86      * ====
87      * It is unsafe to assume that an address for which this function returns
88      * false is an externally-owned account (EOA) and not a contract.
89      *
90      * Among others, `isContract` will return false for the following
91      * types of addresses:
92      *
93      *  - an externally-owned account
94      *  - a contract in construction
95      *  - an address where a contract will be created
96      *  - an address where a contract lived, but was destroyed
97      * ====
98      */
99     function isContract(address account) internal view returns (bool) {
100         // This method relies on extcodesize, which returns 0 for contracts in
101         // construction, since the code is only stored at the end of the
102         // constructor execution.
103 
104         uint256 size;
105         assembly {
106             size := extcodesize(account)
107         }
108         return size > 0;
109     }
110 
111     /**
112      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
113      * `recipient`, forwarding all available gas and reverting on errors.
114      *
115      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
116      * of certain opcodes, possibly making contracts go over the 2300 gas limit
117      * imposed by `transfer`, making them unable to receive funds via
118      * `transfer`. {sendValue} removes this limitation.
119      *
120      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
121      *
122      * IMPORTANT: because control is transferred to `recipient`, care must be
123      * taken to not create reentrancy vulnerabilities. Consider using
124      * {ReentrancyGuard} or the
125      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
126      */
127     function sendValue(address payable recipient, uint256 amount) internal {
128         require(address(this).balance >= amount, "Address: insufficient balance");
129 
130         (bool success, ) = recipient.call{value: amount}("");
131         require(success, "Address: unable to send value, recipient may have reverted");
132     }
133 
134     /**
135      * @dev Performs a Solidity function call using a low level `call`. A
136      * plain `call` is an unsafe replacement for a function call: use this
137      * function instead.
138      *
139      * If `target` reverts with a revert reason, it is bubbled up by this
140      * function (like regular Solidity function calls).
141      *
142      * Returns the raw returned data. To convert to the expected return value,
143      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
144      *
145      * Requirements:
146      *
147      * - `target` must be a contract.
148      * - calling `target` with `data` must not revert.
149      *
150      * _Available since v3.1._
151      */
152     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
153         return functionCall(target, data, "Address: low-level call failed");
154     }
155 
156     /**
157      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
158      * `errorMessage` as a fallback revert reason when `target` reverts.
159      *
160      * _Available since v3.1._
161      */
162     function functionCall(
163         address target,
164         bytes memory data,
165         string memory errorMessage
166     ) internal returns (bytes memory) {
167         return functionCallWithValue(target, data, 0, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but also transferring `value` wei to `target`.
173      *
174      * Requirements:
175      *
176      * - the calling contract must have an ETH balance of at least `value`.
177      * - the called Solidity function must be `payable`.
178      *
179      * _Available since v3.1._
180      */
181     function functionCallWithValue(
182         address target,
183         bytes memory data,
184         uint256 value
185     ) internal returns (bytes memory) {
186         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
191      * with `errorMessage` as a fallback revert reason when `target` reverts.
192      *
193      * _Available since v3.1._
194      */
195     function functionCallWithValue(
196         address target,
197         bytes memory data,
198         uint256 value,
199         string memory errorMessage
200     ) internal returns (bytes memory) {
201         require(address(this).balance >= value, "Address: insufficient balance for call");
202         require(isContract(target), "Address: call to non-contract");
203 
204         (bool success, bytes memory returndata) = target.call{value: value}(data);
205         return verifyCallResult(success, returndata, errorMessage);
206     }
207 
208     /**
209      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
210      * but performing a static call.
211      *
212      * _Available since v3.3._
213      */
214     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
215         return functionStaticCall(target, data, "Address: low-level static call failed");
216     }
217 
218     /**
219      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
220      * but performing a static call.
221      *
222      * _Available since v3.3._
223      */
224     function functionStaticCall(
225         address target,
226         bytes memory data,
227         string memory errorMessage
228     ) internal view returns (bytes memory) {
229         require(isContract(target), "Address: static call to non-contract");
230 
231         (bool success, bytes memory returndata) = target.staticcall(data);
232         return verifyCallResult(success, returndata, errorMessage);
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
237      * but performing a delegate call.
238      *
239      * _Available since v3.4._
240      */
241     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
242         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
247      * but performing a delegate call.
248      *
249      * _Available since v3.4._
250      */
251     function functionDelegateCall(
252         address target,
253         bytes memory data,
254         string memory errorMessage
255     ) internal returns (bytes memory) {
256         require(isContract(target), "Address: delegate call to non-contract");
257 
258         (bool success, bytes memory returndata) = target.delegatecall(data);
259         return verifyCallResult(success, returndata, errorMessage);
260     }
261 
262     /**
263      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
264      * revert reason using the provided one.
265      *
266      * _Available since v4.3._
267      */
268     function verifyCallResult(
269         bool success,
270         bytes memory returndata,
271         string memory errorMessage
272     ) internal pure returns (bytes memory) {
273         if (success) {
274             return returndata;
275         } else {
276             // Look for revert reason and bubble it up if present
277             if (returndata.length > 0) {
278                 // The easiest way to bubble the revert reason is using memory via assembly
279 
280                 assembly {
281                     let returndata_size := mload(returndata)
282                     revert(add(32, returndata), returndata_size)
283                 }
284             } else {
285                 revert(errorMessage);
286             }
287         }
288     }
289 }
290 
291 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
292 
293 
294 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
295 
296 pragma solidity ^0.8.0;
297 
298 /**
299  * @title ERC721 token receiver interface
300  * @dev Interface for any contract that wants to support safeTransfers
301  * from ERC721 asset contracts.
302  */
303 interface IERC721Receiver {
304     /**
305      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
306      * by `operator` from `from`, this function is called.
307      *
308      * It must return its Solidity selector to confirm the token transfer.
309      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
310      *
311      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
312      */
313     function onERC721Received(
314         address operator,
315         address from,
316         uint256 tokenId,
317         bytes calldata data
318     ) external returns (bytes4);
319 }
320 
321 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
322 
323 
324 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
325 
326 pragma solidity ^0.8.0;
327 
328 /**
329  * @dev Interface of the ERC165 standard, as defined in the
330  * https://eips.ethereum.org/EIPS/eip-165[EIP].
331  *
332  * Implementers can declare support of contract interfaces, which can then be
333  * queried by others ({ERC165Checker}).
334  *
335  * For an implementation, see {ERC165}.
336  */
337 interface IERC165 {
338     /**
339      * @dev Returns true if this contract implements the interface defined by
340      * `interfaceId`. See the corresponding
341      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
342      * to learn more about how these ids are created.
343      *
344      * This function call must use less than 30 000 gas.
345      */
346     function supportsInterface(bytes4 interfaceId) external view returns (bool);
347 }
348 
349 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
350 
351 
352 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
353 
354 pragma solidity ^0.8.0;
355 
356 
357 /**
358  * @dev Implementation of the {IERC165} interface.
359  *
360  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
361  * for the additional interface id that will be supported. For example:
362  *
363  * ```solidity
364  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
365  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
366  * }
367  * ```
368  *
369  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
370  */
371 abstract contract ERC165 is IERC165 {
372     /**
373      * @dev See {IERC165-supportsInterface}.
374      */
375     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
376         return interfaceId == type(IERC165).interfaceId;
377     }
378 }
379 
380 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
381 
382 
383 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
384 
385 pragma solidity ^0.8.0;
386 
387 
388 /**
389  * @dev Required interface of an ERC721 compliant contract.
390  */
391 interface IERC721 is IERC165 {
392     /**
393      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
394      */
395     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
396 
397     /**
398      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
399      */
400     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
401 
402     /**
403      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
404      */
405     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
406 
407     /**
408      * @dev Returns the number of tokens in ``owner``'s account.
409      */
410     function balanceOf(address owner) external view returns (uint256 balance);
411 
412     /**
413      * @dev Returns the owner of the `tokenId` token.
414      *
415      * Requirements:
416      *
417      * - `tokenId` must exist.
418      */
419     function ownerOf(uint256 tokenId) external view returns (address owner);
420 
421     /**
422      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
423      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
424      *
425      * Requirements:
426      *
427      * - `from` cannot be the zero address.
428      * - `to` cannot be the zero address.
429      * - `tokenId` token must exist and be owned by `from`.
430      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
431      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
432      *
433      * Emits a {Transfer} event.
434      */
435     function safeTransferFrom(
436         address from,
437         address to,
438         uint256 tokenId
439     ) external;
440 
441     /**
442      * @dev Transfers `tokenId` token from `from` to `to`.
443      *
444      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
445      *
446      * Requirements:
447      *
448      * - `from` cannot be the zero address.
449      * - `to` cannot be the zero address.
450      * - `tokenId` token must be owned by `from`.
451      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
452      *
453      * Emits a {Transfer} event.
454      */
455     function transferFrom(
456         address from,
457         address to,
458         uint256 tokenId
459     ) external;
460 
461     /**
462      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
463      * The approval is cleared when the token is transferred.
464      *
465      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
466      *
467      * Requirements:
468      *
469      * - The caller must own the token or be an approved operator.
470      * - `tokenId` must exist.
471      *
472      * Emits an {Approval} event.
473      */
474     function approve(address to, uint256 tokenId) external;
475 
476     /**
477      * @dev Returns the account approved for `tokenId` token.
478      *
479      * Requirements:
480      *
481      * - `tokenId` must exist.
482      */
483     function getApproved(uint256 tokenId) external view returns (address operator);
484 
485     /**
486      * @dev Approve or remove `operator` as an operator for the caller.
487      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
488      *
489      * Requirements:
490      *
491      * - The `operator` cannot be the caller.
492      *
493      * Emits an {ApprovalForAll} event.
494      */
495     function setApprovalForAll(address operator, bool _approved) external;
496 
497     /**
498      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
499      *
500      * See {setApprovalForAll}
501      */
502     function isApprovedForAll(address owner, address operator) external view returns (bool);
503 
504     /**
505      * @dev Safely transfers `tokenId` token from `from` to `to`.
506      *
507      * Requirements:
508      *
509      * - `from` cannot be the zero address.
510      * - `to` cannot be the zero address.
511      * - `tokenId` token must exist and be owned by `from`.
512      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
513      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
514      *
515      * Emits a {Transfer} event.
516      */
517     function safeTransferFrom(
518         address from,
519         address to,
520         uint256 tokenId,
521         bytes calldata data
522     ) external;
523 }
524 
525 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
526 
527 
528 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
529 
530 pragma solidity ^0.8.0;
531 
532 
533 /**
534  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
535  * @dev See https://eips.ethereum.org/EIPS/eip-721
536  */
537 interface IERC721Enumerable is IERC721 {
538     /**
539      * @dev Returns the total amount of tokens stored by the contract.
540      */
541     function totalSupply() external view returns (uint256);
542 
543     /**
544      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
545      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
546      */
547     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
548 
549     /**
550      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
551      * Use along with {totalSupply} to enumerate all tokens.
552      */
553     function tokenByIndex(uint256 index) external view returns (uint256);
554 }
555 
556 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
557 
558 
559 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
560 
561 pragma solidity ^0.8.0;
562 
563 
564 /**
565  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
566  * @dev See https://eips.ethereum.org/EIPS/eip-721
567  */
568 interface IERC721Metadata is IERC721 {
569     /**
570      * @dev Returns the token collection name.
571      */
572     function name() external view returns (string memory);
573 
574     /**
575      * @dev Returns the token collection symbol.
576      */
577     function symbol() external view returns (string memory);
578 
579     /**
580      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
581      */
582     function tokenURI(uint256 tokenId) external view returns (string memory);
583 }
584 
585 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
586 
587 
588 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
589 
590 pragma solidity ^0.8.0;
591 
592 /**
593  * @dev Contract module that helps prevent reentrant calls to a function.
594  *
595  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
596  * available, which can be applied to functions to make sure there are no nested
597  * (reentrant) calls to them.
598  *
599  * Note that because there is a single `nonReentrant` guard, functions marked as
600  * `nonReentrant` may not call one another. This can be worked around by making
601  * those functions `private`, and then adding `external` `nonReentrant` entry
602  * points to them.
603  *
604  * TIP: If you would like to learn more about reentrancy and alternative ways
605  * to protect against it, check out our blog post
606  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
607  */
608 abstract contract ReentrancyGuard {
609     // Booleans are more expensive than uint256 or any type that takes up a full
610     // word because each write operation emits an extra SLOAD to first read the
611     // slot's contents, replace the bits taken up by the boolean, and then write
612     // back. This is the compiler's defense against contract upgrades and
613     // pointer aliasing, and it cannot be disabled.
614 
615     // The values being non-zero value makes deployment a bit more expensive,
616     // but in exchange the refund on every call to nonReentrant will be lower in
617     // amount. Since refunds are capped to a percentage of the total
618     // transaction's gas, it is best to keep them low in cases like this one, to
619     // increase the likelihood of the full refund coming into effect.
620     uint256 private constant _NOT_ENTERED = 1;
621     uint256 private constant _ENTERED = 2;
622 
623     uint256 private _status;
624 
625     constructor() {
626         _status = _NOT_ENTERED;
627     }
628 
629     /**
630      * @dev Prevents a contract from calling itself, directly or indirectly.
631      * Calling a `nonReentrant` function from another `nonReentrant`
632      * function is not supported. It is possible to prevent this from happening
633      * by making the `nonReentrant` function external, and making it call a
634      * `private` function that does the actual work.
635      */
636     modifier nonReentrant() {
637         // On the first call to nonReentrant, _notEntered will be true
638         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
639 
640         // Any calls to nonReentrant after this point will fail
641         _status = _ENTERED;
642 
643         _;
644 
645         // By storing the original value once again, a refund is triggered (see
646         // https://eips.ethereum.org/EIPS/eip-2200)
647         _status = _NOT_ENTERED;
648     }
649 }
650 
651 // File: @openzeppelin/contracts/utils/Context.sol
652 
653 
654 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
655 
656 pragma solidity ^0.8.0;
657 
658 /**
659  * @dev Provides information about the current execution context, including the
660  * sender of the transaction and its data. While these are generally available
661  * via msg.sender and msg.data, they should not be accessed in such a direct
662  * manner, since when dealing with meta-transactions the account sending and
663  * paying for execution may not be the actual sender (as far as an application
664  * is concerned).
665  *
666  * This contract is only required for intermediate, library-like contracts.
667  */
668 abstract contract Context {
669     function _msgSender() internal view virtual returns (address) {
670         return msg.sender;
671     }
672 
673     function _msgData() internal view virtual returns (bytes calldata) {
674         return msg.data;
675     }
676 }
677 
678 // File: contracts/ERC721A.sol
679 
680 
681 
682 
683 
684 pragma solidity ^0.8.0;
685 
686 
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
697 
698  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
699 
700  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
701 
702  *
703 
704  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
705 
706  *
707 
708  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
709 
710  *
711 
712  * Does not support burning tokens to address(0).
713 
714  */
715 
716 contract ERC721A is
717 
718   Context,
719 
720   ERC165,
721 
722   IERC721,
723 
724   IERC721Metadata,
725 
726   IERC721Enumerable
727 
728 {
729 
730   using Address for address;
731 
732   using Strings for uint256;
733 
734 
735 
736   struct TokenOwnership {
737 
738     address addr;
739 
740     uint64 startTimestamp;
741 
742   }
743 
744 
745 
746   struct AddressData {
747 
748     uint128 balance;
749 
750     uint128 numberMinted;
751 
752   }
753 
754 
755 
756   uint256 private currentIndex = 0;
757 
758 
759 
760   uint256 internal immutable collectionSize;
761 
762   uint256 internal immutable maxBatchSize;
763 
764 
765 
766   // Token name
767 
768   string private _name;
769 
770 
771 
772   // Token symbol
773 
774   string private _symbol;
775 
776 
777 
778   // Mapping from token ID to ownership details
779 
780   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
781 
782   mapping(uint256 => TokenOwnership) private _ownerships;
783 
784 
785 
786   // Mapping owner address to address data
787 
788   mapping(address => AddressData) private _addressData;
789 
790 
791 
792   // Mapping from token ID to approved address
793 
794   mapping(uint256 => address) private _tokenApprovals;
795 
796 
797 
798   // Mapping from owner to operator approvals
799 
800   mapping(address => mapping(address => bool)) private _operatorApprovals;
801 
802 
803 
804   /**
805 
806    * @dev
807 
808    * `maxBatchSize` refers to how much a minter can mint at a time.
809 
810    * `collectionSize_` refers to how many tokens are in the collection.
811 
812    */
813 
814   constructor(
815 
816     string memory name_,
817 
818     string memory symbol_,
819 
820     uint256 maxBatchSize_,
821 
822     uint256 collectionSize_
823 
824   ) {
825 
826     require(
827 
828       collectionSize_ > 0,
829 
830       "ERC721A: collection must have a nonzero supply"
831 
832     );
833 
834     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
835 
836     _name = name_;
837 
838     _symbol = symbol_;
839 
840     maxBatchSize = maxBatchSize_;
841 
842     collectionSize = collectionSize_;
843 
844   }
845 
846 
847 
848   /**
849 
850    * @dev See {IERC721Enumerable-totalSupply}.
851 
852    */
853 
854   function totalSupply() public view override returns (uint256) {
855 
856     return currentIndex;
857 
858   }
859 
860 
861 
862   /**
863 
864    * @dev See {IERC721Enumerable-tokenByIndex}.
865 
866    */
867 
868   function tokenByIndex(uint256 index) public view override returns (uint256) {
869 
870     require(index < totalSupply(), "ERC721A: global index out of bounds");
871 
872     return index;
873 
874   }
875 
876 
877 
878   /**
879 
880    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
881 
882    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
883 
884    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
885 
886    */
887 
888   function tokenOfOwnerByIndex(address owner, uint256 index)
889 
890     public
891 
892     view
893 
894     override
895 
896     returns (uint256)
897 
898   {
899 
900     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
901 
902     uint256 numMintedSoFar = totalSupply();
903 
904     uint256 tokenIdsIdx = 0;
905 
906     address currOwnershipAddr = address(0);
907 
908     for (uint256 i = 0; i < numMintedSoFar; i++) {
909 
910       TokenOwnership memory ownership = _ownerships[i];
911 
912       if (ownership.addr != address(0)) {
913 
914         currOwnershipAddr = ownership.addr;
915 
916       }
917 
918       if (currOwnershipAddr == owner) {
919 
920         if (tokenIdsIdx == index) {
921 
922           return i;
923 
924         }
925 
926         tokenIdsIdx++;
927 
928       }
929 
930     }
931 
932     revert("ERC721A: unable to get token of owner by index");
933 
934   }
935 
936 
937 
938   /**
939 
940    * @dev See {IERC165-supportsInterface}.
941 
942    */
943 
944   function supportsInterface(bytes4 interfaceId)
945 
946     public
947 
948     view
949 
950     virtual
951 
952     override(ERC165, IERC165)
953 
954     returns (bool)
955 
956   {
957 
958     return
959 
960       interfaceId == type(IERC721).interfaceId ||
961 
962       interfaceId == type(IERC721Metadata).interfaceId ||
963 
964       interfaceId == type(IERC721Enumerable).interfaceId ||
965 
966       super.supportsInterface(interfaceId);
967 
968   }
969 
970 
971 
972   /**
973 
974    * @dev See {IERC721-balanceOf}.
975 
976    */
977 
978   function balanceOf(address owner) public view override returns (uint256) {
979 
980     require(owner != address(0), "ERC721A: balance query for the zero address");
981 
982     return uint256(_addressData[owner].balance);
983 
984   }
985 
986 
987 
988   function _numberMinted(address owner) internal view returns (uint256) {
989 
990     require(
991 
992       owner != address(0),
993 
994       "ERC721A: number minted query for the zero address"
995 
996     );
997 
998     return uint256(_addressData[owner].numberMinted);
999 
1000   }
1001 
1002 
1003 
1004   function ownershipOf(uint256 tokenId)
1005 
1006     internal
1007 
1008     view
1009 
1010     returns (TokenOwnership memory)
1011 
1012   {
1013 
1014     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1015 
1016 
1017 
1018     uint256 lowestTokenToCheck;
1019 
1020     if (tokenId >= maxBatchSize) {
1021 
1022       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1023 
1024     }
1025 
1026 
1027 
1028     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1029 
1030       TokenOwnership memory ownership = _ownerships[curr];
1031 
1032       if (ownership.addr != address(0)) {
1033 
1034         return ownership;
1035 
1036       }
1037 
1038     }
1039 
1040 
1041 
1042     revert("ERC721A: unable to determine the owner of token");
1043 
1044   }
1045 
1046 
1047 
1048   /**
1049 
1050    * @dev See {IERC721-ownerOf}.
1051 
1052    */
1053 
1054   function ownerOf(uint256 tokenId) public view override returns (address) {
1055 
1056     return ownershipOf(tokenId).addr;
1057 
1058   }
1059 
1060 
1061 
1062   /**
1063 
1064    * @dev See {IERC721Metadata-name}.
1065 
1066    */
1067 
1068   function name() public view virtual override returns (string memory) {
1069 
1070     return _name;
1071 
1072   }
1073 
1074 
1075 
1076   /**
1077 
1078    * @dev See {IERC721Metadata-symbol}.
1079 
1080    */
1081 
1082   function symbol() public view virtual override returns (string memory) {
1083 
1084     return _symbol;
1085 
1086   }
1087 
1088 
1089 
1090   /**
1091 
1092    * @dev See {IERC721Metadata-tokenURI}.
1093 
1094    */
1095 
1096   function tokenURI(uint256 tokenId)
1097 
1098     public
1099 
1100     view
1101 
1102     virtual
1103 
1104     override
1105 
1106     returns (string memory)
1107 
1108   {
1109 
1110     require(
1111 
1112       _exists(tokenId),
1113 
1114       "ERC721Metadata: URI query for nonexistent token"
1115 
1116     );
1117 
1118 
1119 
1120     string memory baseURI = _baseURI();
1121 
1122     return
1123 
1124       bytes(baseURI).length > 0
1125 
1126         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1127 
1128         : "";
1129 
1130   }
1131 
1132 
1133 
1134   /**
1135 
1136    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1137 
1138    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1139 
1140    * by default, can be overriden in child contracts.
1141 
1142    */
1143 
1144   function _baseURI() internal view virtual returns (string memory) {
1145 
1146     return "";
1147 
1148   }
1149 
1150 
1151 
1152   /**
1153 
1154    * @dev See {IERC721-approve}.
1155 
1156    */
1157 
1158   function approve(address to, uint256 tokenId) public override {
1159 
1160     address owner = ERC721A.ownerOf(tokenId);
1161 
1162     require(to != owner, "ERC721A: approval to current owner");
1163 
1164 
1165 
1166     require(
1167 
1168       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1169 
1170       "ERC721A: approve caller is not owner nor approved for all"
1171 
1172     );
1173 
1174 
1175 
1176     _approve(to, tokenId, owner);
1177 
1178   }
1179 
1180 
1181 
1182   /**
1183 
1184    * @dev See {IERC721-getApproved}.
1185 
1186    */
1187 
1188   function getApproved(uint256 tokenId) public view override returns (address) {
1189 
1190     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1191 
1192 
1193 
1194     return _tokenApprovals[tokenId];
1195 
1196   }
1197 
1198 
1199 
1200   /**
1201 
1202    * @dev See {IERC721-setApprovalForAll}.
1203 
1204    */
1205 
1206   function setApprovalForAll(address operator, bool approved) public override {
1207 
1208     require(operator != _msgSender(), "ERC721A: approve to caller");
1209 
1210 
1211 
1212     _operatorApprovals[_msgSender()][operator] = approved;
1213 
1214     emit ApprovalForAll(_msgSender(), operator, approved);
1215 
1216   }
1217 
1218 
1219 
1220   /**
1221 
1222    * @dev See {IERC721-isApprovedForAll}.
1223 
1224    */
1225 
1226   function isApprovedForAll(address owner, address operator)
1227 
1228     public
1229 
1230     view
1231 
1232     virtual
1233 
1234     override
1235 
1236     returns (bool)
1237 
1238   {
1239 
1240     return _operatorApprovals[owner][operator];
1241 
1242   }
1243 
1244 
1245 
1246   /**
1247 
1248    * @dev See {IERC721-transferFrom}.
1249 
1250    */
1251 
1252   function transferFrom(
1253 
1254     address from,
1255 
1256     address to,
1257 
1258     uint256 tokenId
1259 
1260   ) public override {
1261 
1262     _transfer(from, to, tokenId);
1263 
1264   }
1265 
1266 
1267 
1268   /**
1269 
1270    * @dev See {IERC721-safeTransferFrom}.
1271 
1272    */
1273 
1274   function safeTransferFrom(
1275 
1276     address from,
1277 
1278     address to,
1279 
1280     uint256 tokenId
1281 
1282   ) public override {
1283 
1284     safeTransferFrom(from, to, tokenId, "");
1285 
1286   }
1287 
1288 
1289 
1290   /**
1291 
1292    * @dev See {IERC721-safeTransferFrom}.
1293 
1294    */
1295 
1296   function safeTransferFrom(
1297 
1298     address from,
1299 
1300     address to,
1301 
1302     uint256 tokenId,
1303 
1304     bytes memory _data
1305 
1306   ) public override {
1307 
1308     _transfer(from, to, tokenId);
1309 
1310     require(
1311 
1312       _checkOnERC721Received(from, to, tokenId, _data),
1313 
1314       "ERC721A: transfer to non ERC721Receiver implementer"
1315 
1316     );
1317 
1318   }
1319 
1320 
1321 
1322   /**
1323 
1324    * @dev Returns whether `tokenId` exists.
1325 
1326    *
1327 
1328    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1329 
1330    *
1331 
1332    * Tokens start existing when they are minted (`_mint`),
1333 
1334    */
1335 
1336   function _exists(uint256 tokenId) internal view returns (bool) {
1337 
1338     return tokenId < currentIndex;
1339 
1340   }
1341 
1342 
1343 
1344   function _safeMint(address to, uint256 quantity) internal {
1345 
1346     _safeMint(to, quantity, "");
1347 
1348   }
1349 
1350 
1351 
1352   /**
1353 
1354    * @dev Mints `quantity` tokens and transfers them to `to`.
1355 
1356    *
1357 
1358    * Requirements:
1359 
1360    *
1361 
1362    * - there must be `quantity` tokens remaining unminted in the total collection.
1363 
1364    * - `to` cannot be the zero address.
1365 
1366    * - `quantity` cannot be larger than the max batch size.
1367 
1368    *
1369 
1370    * Emits a {Transfer} event.
1371 
1372    */
1373 
1374   function _safeMint(
1375 
1376     address to,
1377 
1378     uint256 quantity,
1379 
1380     bytes memory _data
1381 
1382   ) internal {
1383 
1384     uint256 startTokenId = currentIndex;
1385 
1386     require(to != address(0), "ERC721A: mint to the zero address");
1387 
1388     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1389 
1390     require(!_exists(startTokenId), "ERC721A: token already minted");
1391 
1392     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1393 
1394 
1395 
1396     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1397 
1398 
1399 
1400     AddressData memory addressData = _addressData[to];
1401 
1402     _addressData[to] = AddressData(
1403 
1404       addressData.balance + uint128(quantity),
1405 
1406       addressData.numberMinted + uint128(quantity)
1407 
1408     );
1409 
1410     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1411 
1412 
1413 
1414     uint256 updatedIndex = startTokenId;
1415 
1416 
1417 
1418     for (uint256 i = 0; i < quantity; i++) {
1419 
1420       emit Transfer(address(0), to, updatedIndex);
1421 
1422       require(
1423 
1424         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1425 
1426         "ERC721A: transfer to non ERC721Receiver implementer"
1427 
1428       );
1429 
1430       updatedIndex++;
1431 
1432     }
1433 
1434 
1435 
1436     currentIndex = updatedIndex;
1437 
1438     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1439 
1440   }
1441 
1442 
1443 
1444   /**
1445 
1446    * @dev Transfers `tokenId` from `from` to `to`.
1447 
1448    *
1449 
1450    * Requirements:
1451 
1452    *
1453 
1454    * - `to` cannot be the zero address.
1455 
1456    * - `tokenId` token must be owned by `from`.
1457 
1458    *
1459 
1460    * Emits a {Transfer} event.
1461 
1462    */
1463 
1464   function _transfer(
1465 
1466     address from,
1467 
1468     address to,
1469 
1470     uint256 tokenId
1471 
1472   ) private {
1473 
1474     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1475 
1476 
1477 
1478     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1479 
1480       getApproved(tokenId) == _msgSender() ||
1481 
1482       isApprovedForAll(prevOwnership.addr, _msgSender()));
1483 
1484 
1485 
1486     require(
1487 
1488       isApprovedOrOwner,
1489 
1490       "ERC721A: transfer caller is not owner nor approved"
1491 
1492     );
1493 
1494 
1495 
1496     require(
1497 
1498       prevOwnership.addr == from,
1499 
1500       "ERC721A: transfer from incorrect owner"
1501 
1502     );
1503 
1504     require(to != address(0), "ERC721A: transfer to the zero address");
1505 
1506 
1507 
1508     _beforeTokenTransfers(from, to, tokenId, 1);
1509 
1510 
1511 
1512     // Clear approvals from the previous owner
1513 
1514     _approve(address(0), tokenId, prevOwnership.addr);
1515 
1516 
1517 
1518     _addressData[from].balance -= 1;
1519 
1520     _addressData[to].balance += 1;
1521 
1522     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1523 
1524 
1525 
1526     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1527 
1528     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1529 
1530     uint256 nextTokenId = tokenId + 1;
1531 
1532     if (_ownerships[nextTokenId].addr == address(0)) {
1533 
1534       if (_exists(nextTokenId)) {
1535 
1536         _ownerships[nextTokenId] = TokenOwnership(
1537 
1538           prevOwnership.addr,
1539 
1540           prevOwnership.startTimestamp
1541 
1542         );
1543 
1544       }
1545 
1546     }
1547 
1548 
1549 
1550     emit Transfer(from, to, tokenId);
1551 
1552     _afterTokenTransfers(from, to, tokenId, 1);
1553 
1554   }
1555 
1556 
1557 
1558   /**
1559 
1560    * @dev Approve `to` to operate on `tokenId`
1561 
1562    *
1563 
1564    * Emits a {Approval} event.
1565 
1566    */
1567 
1568   function _approve(
1569 
1570     address to,
1571 
1572     uint256 tokenId,
1573 
1574     address owner
1575 
1576   ) private {
1577 
1578     _tokenApprovals[tokenId] = to;
1579 
1580     emit Approval(owner, to, tokenId);
1581 
1582   }
1583 
1584 
1585 
1586   uint256 public nextOwnerToExplicitlySet = 0;
1587 
1588 
1589 
1590   /**
1591 
1592    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1593 
1594    */
1595 
1596   function _setOwnersExplicit(uint256 quantity) internal {
1597 
1598     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1599 
1600     require(quantity > 0, "quantity must be nonzero");
1601 
1602     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1603 
1604     if (endIndex > collectionSize - 1) {
1605 
1606       endIndex = collectionSize - 1;
1607 
1608     }
1609 
1610     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1611 
1612     require(_exists(endIndex), "not enough minted yet for this cleanup");
1613 
1614     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1615 
1616       if (_ownerships[i].addr == address(0)) {
1617 
1618         TokenOwnership memory ownership = ownershipOf(i);
1619 
1620         _ownerships[i] = TokenOwnership(
1621 
1622           ownership.addr,
1623 
1624           ownership.startTimestamp
1625 
1626         );
1627 
1628       }
1629 
1630     }
1631 
1632     nextOwnerToExplicitlySet = endIndex + 1;
1633 
1634   }
1635 
1636 
1637 
1638   /**
1639 
1640    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1641 
1642    * The call is not executed if the target address is not a contract.
1643 
1644    *
1645 
1646    * @param from address representing the previous owner of the given token ID
1647 
1648    * @param to target address that will receive the tokens
1649 
1650    * @param tokenId uint256 ID of the token to be transferred
1651 
1652    * @param _data bytes optional data to send along with the call
1653 
1654    * @return bool whether the call correctly returned the expected magic value
1655 
1656    */
1657 
1658   function _checkOnERC721Received(
1659 
1660     address from,
1661 
1662     address to,
1663 
1664     uint256 tokenId,
1665 
1666     bytes memory _data
1667 
1668   ) private returns (bool) {
1669 
1670     if (to.isContract()) {
1671 
1672       try
1673 
1674         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1675 
1676       returns (bytes4 retval) {
1677 
1678         return retval == IERC721Receiver(to).onERC721Received.selector;
1679 
1680       } catch (bytes memory reason) {
1681 
1682         if (reason.length == 0) {
1683 
1684           revert("ERC721A: transfer to non ERC721Receiver implementer");
1685 
1686         } else {
1687 
1688           assembly {
1689 
1690             revert(add(32, reason), mload(reason))
1691 
1692           }
1693 
1694         }
1695 
1696       }
1697 
1698     } else {
1699 
1700       return true;
1701 
1702     }
1703 
1704   }
1705 
1706 
1707 
1708   /**
1709 
1710    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1711 
1712    *
1713 
1714    * startTokenId - the first token id to be transferred
1715 
1716    * quantity - the amount to be transferred
1717 
1718    *
1719 
1720    * Calling conditions:
1721 
1722    *
1723 
1724    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1725 
1726    * transferred to `to`.
1727 
1728    * - When `from` is zero, `tokenId` will be minted for `to`.
1729 
1730    */
1731 
1732   function _beforeTokenTransfers(
1733 
1734     address from,
1735 
1736     address to,
1737 
1738     uint256 startTokenId,
1739 
1740     uint256 quantity
1741 
1742   ) internal virtual {}
1743 
1744 
1745 
1746   /**
1747 
1748    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1749 
1750    * minting.
1751 
1752    *
1753 
1754    * startTokenId - the first token id to be transferred
1755 
1756    * quantity - the amount to be transferred
1757 
1758    *
1759 
1760    * Calling conditions:
1761 
1762    *
1763 
1764    * - when `from` and `to` are both non-zero.
1765 
1766    * - `from` and `to` are never both zero.
1767 
1768    */
1769 
1770   function _afterTokenTransfers(
1771 
1772     address from,
1773 
1774     address to,
1775 
1776     uint256 startTokenId,
1777 
1778     uint256 quantity
1779 
1780   ) internal virtual {}
1781 
1782 }
1783 // File: @openzeppelin/contracts/access/Ownable.sol
1784 
1785 
1786 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1787 
1788 pragma solidity ^0.8.0;
1789 
1790 
1791 /**
1792  * @dev Contract module which provides a basic access control mechanism, where
1793  * there is an account (an owner) that can be granted exclusive access to
1794  * specific functions.
1795  *
1796  * By default, the owner account will be the one that deploys the contract. This
1797  * can later be changed with {transferOwnership}.
1798  *
1799  * This module is used through inheritance. It will make available the modifier
1800  * `onlyOwner`, which can be applied to your functions to restrict their use to
1801  * the owner.
1802  */
1803 abstract contract Ownable is Context {
1804     address private _owner;
1805 
1806     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1807 
1808     /**
1809      * @dev Initializes the contract setting the deployer as the initial owner.
1810      */
1811     constructor() {
1812         _transferOwnership(_msgSender());
1813     }
1814 
1815     /**
1816      * @dev Returns the address of the current owner.
1817      */
1818     function owner() public view virtual returns (address) {
1819         return _owner;
1820     }
1821 
1822     /**
1823      * @dev Throws if called by any account other than the owner.
1824      */
1825     modifier onlyOwner() {
1826         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1827         _;
1828     }
1829 
1830     /**
1831      * @dev Leaves the contract without owner. It will not be possible to call
1832      * `onlyOwner` functions anymore. Can only be called by the current owner.
1833      *
1834      * NOTE: Renouncing ownership will leave the contract without an owner,
1835      * thereby removing any functionality that is only available to the owner.
1836      */
1837     function renounceOwnership() public virtual onlyOwner {
1838         _transferOwnership(address(0));
1839     }
1840 
1841     /**
1842      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1843      * Can only be called by the current owner.
1844      */
1845     function transferOwnership(address newOwner) public virtual onlyOwner {
1846         require(newOwner != address(0), "Ownable: new owner is the zero address");
1847         _transferOwnership(newOwner);
1848     }
1849 
1850     /**
1851      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1852      * Internal function without access restriction.
1853      */
1854     function _transferOwnership(address newOwner) internal virtual {
1855         address oldOwner = _owner;
1856         _owner = newOwner;
1857         emit OwnershipTransferred(oldOwner, newOwner);
1858     }
1859 }
1860 
1861 // File: contracts/AdofoYTestnet.sol
1862 
1863 
1864 
1865 // SPDX-License-Identifier: MIT
1866 
1867 /*
1868 
1869  █████╗ ██████╗  ██████╗ ███████╗ ██████╗      ██╗   ██╗    
1870 ██╔══██╗██╔══██╗██╔═══██╗██╔════╝██╔═══██╗     ╚██╗ ██╔╝    
1871 ███████║██║  ██║██║   ██║█████╗  ██║   ██║█████╗╚████╔╝     
1872 ██╔══██║██║  ██║██║   ██║██╔══╝  ██║   ██║╚════╝ ╚██╔╝      
1873 ██║  ██║██████╔╝╚██████╔╝██║     ╚██████╔╝        ██║       
1874 ╚═╝  ╚═╝╚═════╝  ╚═════╝ ╚═╝      ╚═════╝         ╚═╝       
1875 
1876                                         Developer: BR33D
1877                                         Artist: JC-X     */
1878 
1879 
1880 
1881 pragma solidity ^0.8.0;
1882 
1883 
1884 
1885 
1886 
1887 
1888 
1889 interface MintPass {
1890 
1891     function balanceOf(address owner) external view returns (uint256);
1892 
1893 }
1894 
1895 
1896 
1897 contract AdofoY is Ownable, ERC721A, ReentrancyGuard {
1898 
1899   uint256 public immutable maxPerAddressDuringMint;
1900 
1901   uint256 public immutable maxPerWhitelistMint;
1902 
1903   uint256 public immutable amountForDevs;
1904 
1905   uint256 public maxPerTxPublic;
1906 
1907   address public mintPassedContract = 0xF92cF4a3776bA3F6a3eD96E1974D38Fcf59307f6;
1908 
1909   address[] public whitelistedAddresses;
1910 
1911   address payable public payments;
1912 
1913   bool public hasDevMinted;
1914 
1915   address private authority;
1916 
1917   uint private key;
1918 
1919 
1920 
1921   struct SaleConfig {
1922 
1923     uint32 holdersSaleStartTime;
1924 
1925     uint32 whitelistSaleStartTime;
1926 
1927     uint32 publicSaleStartTime;
1928 
1929     uint64 adofoXMintPrice;
1930 
1931     uint64 publicPrice;
1932 
1933   }
1934 
1935 
1936 
1937   SaleConfig public saleConfig;
1938 
1939 
1940 
1941   mapping(address => bool) public whitelistMinted;
1942 
1943   mapping(address => bool) public mintPassHolders;
1944 
1945   mapping(address => uint256) public adofoXWhitelist;
1946 
1947 
1948 
1949   constructor(
1950 
1951     uint256 maxBatchSize_,
1952 
1953     uint256 maxWhitelistBatch_,
1954 
1955     uint256 collectionSize_,
1956 
1957     uint256 amountForDevs_,
1958 
1959     uint256 txMaxPer_,
1960 
1961     address payments_,
1962 
1963     bool devMint_
1964 
1965   ) ERC721A("Adofo-Y", "ADOFO-Y", maxBatchSize_, collectionSize_) {
1966 
1967     payments = payable(payments_);
1968 
1969     maxPerAddressDuringMint = maxBatchSize_;
1970 
1971     amountForDevs = amountForDevs_;
1972 
1973     maxPerWhitelistMint = maxWhitelistBatch_;
1974 
1975     maxPerTxPublic = txMaxPer_;
1976 
1977     hasDevMinted = devMint_;
1978 
1979   }
1980 
1981 
1982 
1983   modifier callerIsUser() {
1984 
1985     require(tx.origin == msg.sender, "The caller is another contract");
1986 
1987     _;
1988 
1989   }
1990 
1991 
1992 
1993   /*
1994 
1995     |----------------------------|
1996 
1997     |------ Mint Functions ------|
1998 
1999     |----------------------------|
2000 
2001   */
2002 
2003 
2004 
2005     // adofo-x holders mint
2006 
2007   function adofoXHoldersMint(uint256 numOfAdofos) external payable callerIsUser {
2008 
2009     uint256 price = uint256(saleConfig.adofoXMintPrice);
2010     uint256 saleStart = uint256(saleConfig.holdersSaleStartTime);
2011     uint256 whitelistBalance = adofoXWhitelist[msg.sender];
2012 
2013     require(
2014 
2015       block.timestamp >= saleStart && 
2016 
2017       saleStart > 0, "holders sale has not begun yet");
2018 
2019     require(price != 0, "X holder sale has not begun yet");
2020     require(whitelistBalance > 0,"Invalid whitelist balance - Public sale not live");
2021     require(whitelistBalance >= numOfAdofos,"Amount more than your whitelist limit");
2022     require(totalSupply() + numOfAdofos <= collectionSize, "reached max supply");
2023     require(numOfAdofos <= maxPerWhitelistMint, "exceeds mint allowance");
2024 
2025     adofoXWhitelist[msg.sender] -= numOfAdofos;
2026 
2027     _safeMint(msg.sender, numOfAdofos);
2028 
2029     refundIfOver(price * numOfAdofos);
2030 
2031   }
2032 
2033     // whitelist mint
2034 
2035   function whiteListMint(bytes32 _hash, uint256 numOfAdofos) external payable callerIsUser {
2036 
2037     uint256 price = uint256(saleConfig.publicPrice);
2038 
2039     uint256 saleStart = uint256(saleConfig.whitelistSaleStartTime);
2040 
2041     require(
2042 
2043       block.timestamp >= saleStart && 
2044 
2045       saleStart > 0, "whitelist sale has not begun yet");
2046 
2047     require(totalSupply() + numOfAdofos <= collectionSize, "reached max supply");
2048 
2049     require(numOfAdofos <= maxPerWhitelistMint, "exceeds mint allowance");
2050 
2051     require(_hash == checkHash(msg.sender), "Not a true warrior");
2052 
2053     require(whitelistMinted[msg.sender] == false, "Already minted");
2054 
2055     whitelistMinted[msg.sender] = true;
2056 
2057     _safeMint(msg.sender, numOfAdofos);
2058 
2059     refundIfOver(price * numOfAdofos);
2060 
2061   }
2062 
2063     // NFT holders mint
2064 
2065   function tokenHoldersMint(uint256 numOfAdofos) external payable callerIsUser {
2066 
2067     uint256 price = uint256(saleConfig.adofoXMintPrice);
2068 
2069     uint256 saleStart = uint256(saleConfig.holdersSaleStartTime);
2070 
2071     require(
2072 
2073       block.timestamp >= saleStart && 
2074 
2075       saleStart > 0, "holders sale has not begun yet");
2076 
2077     bool minted = mintPassHolders[msg.sender];
2078 
2079     require(hasMintPass(msg.sender) == true, "must hold a mint pass");
2080 
2081     require(totalSupply() + numOfAdofos <= collectionSize, "reached max supply");
2082 
2083     require(numOfAdofos <= maxPerWhitelistMint, "exceeds mint allowance");
2084 
2085     require(minted == false, "already minted");
2086 
2087 
2088 
2089     mintPassHolders[msg.sender] = true;
2090 
2091     _safeMint(msg.sender, numOfAdofos);
2092 
2093     refundIfOver(price * numOfAdofos);
2094 
2095   }
2096 
2097     // public sale
2098 
2099   function publicSaleMint(uint256 quantity)
2100 
2101     external
2102 
2103     payable
2104 
2105     callerIsUser
2106 
2107   {
2108 
2109     SaleConfig memory config = saleConfig;
2110 
2111     uint256 publicPrice = uint256(config.publicPrice);
2112 
2113     uint256 publicSaleStartTime = uint256(config.publicSaleStartTime);
2114 
2115     require(isPublicSaleOn(publicPrice, publicSaleStartTime), "public sale has not begun yet");
2116 
2117     require(totalSupply() + quantity <= collectionSize, "reached max supply");
2118 
2119     require(numberMinted(msg.sender) + quantity <= maxPerAddressDuringMint, "can not mint this many");
2120 
2121     require(quantity <= maxPerTxPublic, "too many per tx");
2122 
2123     _safeMint(msg.sender, quantity);
2124 
2125     refundIfOver(publicPrice * quantity);
2126 
2127   }
2128 
2129 
2130 
2131   /*
2132 
2133     |----------------------------|
2134 
2135     |---- Contract Functions ----|
2136 
2137     |----------------------------|
2138 
2139   */
2140 
2141 
2142 
2143     // returns any extra funds sent by user, protects user from over paying
2144 
2145   function refundIfOver(uint256 price) private {
2146 
2147     require(msg.value >= price, "Need to send more ETH.");
2148 
2149     if (msg.value > price) {
2150 
2151       payable(msg.sender).transfer(msg.value - price);
2152 
2153     }
2154 
2155   }
2156 
2157 
2158 
2159   /*
2160 
2161     |----------------------------|
2162 
2163     |------ View Functions ------|
2164 
2165     |----------------------------|
2166 
2167   */
2168 
2169 
2170 
2171     // check if public sale has started
2172 
2173   function isPublicSaleOn(
2174 
2175     uint256 publicPriceWei,
2176 
2177     uint256 publicSaleStartTime
2178 
2179   ) public view returns (bool) {
2180 
2181     return
2182 
2183       publicPriceWei != 0 &&
2184 
2185       block.timestamp >= publicSaleStartTime;
2186 
2187   }
2188 
2189 
2190 
2191     //Retrieves token ids owned of address provided
2192 
2193     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
2194 
2195         uint256 ownerTokenCount = balanceOf(_owner);
2196 
2197         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
2198 
2199         for (uint256 i; i < ownerTokenCount; i++) {
2200 
2201             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
2202 
2203             
2204 
2205         }
2206 
2207         return tokenIds;
2208 
2209     }
2210 
2211 
2212 
2213   // check if an address is whitelisted
2214 
2215   function isWhitelisted(address _user) public view returns (bool) {
2216 
2217     for (uint i = 0; i < whitelistedAddresses.length; i++) {
2218 
2219       if (whitelistedAddresses[i] == _user) {
2220 
2221           return true;
2222 
2223       }
2224 
2225     }
2226 
2227     return false;
2228 
2229   }
2230 
2231     // check if holder has mint passed NFT
2232 
2233   function hasMintPass(address _user) public view returns (bool) {
2234 
2235 		uint pass = MintPass(mintPassedContract).balanceOf(_user);
2236 
2237 		
2238 
2239 		if (pass >= 1){
2240 
2241 			return true;
2242 
2243 		}
2244 
2245 		return false;
2246 
2247 	}
2248 
2249     function checkHash(address _minter) internal view returns (bytes32) {
2250 
2251         bytes32 correctHash = bytes32(keccak256(abi.encodePacked(_minter, key, authority)));
2252 
2253         return correctHash;
2254 
2255     }
2256 
2257 
2258 
2259   function numberMinted(address owner) public view returns (uint256) {
2260 
2261     return _numberMinted(owner);
2262 
2263   }
2264 
2265 
2266 
2267   function getOwnershipData(uint256 tokenId)
2268 
2269     external
2270 
2271     view
2272 
2273     returns (TokenOwnership memory)
2274 
2275   {
2276 
2277     return ownershipOf(tokenId);
2278 
2279   }
2280 
2281 
2282 
2283   // metadata URI
2284 
2285   string private _baseTokenURI;
2286 
2287 
2288 
2289   function _baseURI() internal view virtual override returns (string memory) {
2290 
2291     return _baseTokenURI;
2292 
2293   }
2294 
2295 
2296 
2297   /*
2298 
2299     |----------------------------|
2300 
2301     |----- Owner  Functions -----|
2302 
2303     |----------------------------|
2304 
2305   */
2306 
2307 
2308 
2309     // setup minting info
2310 
2311   function setupSaleInfo(
2312 
2313     uint64 adofoXMintPriceWei,
2314 
2315     uint64 publicPriceWei,
2316 
2317     uint32 holdersSaleStartTime,
2318 
2319     uint32 whitelistSaleStartTime,
2320 
2321     uint32 publicSaleStartTime
2322 
2323   ) external onlyOwner {
2324 
2325     saleConfig = SaleConfig(
2326 
2327       holdersSaleStartTime,
2328 
2329       whitelistSaleStartTime,
2330 
2331       publicSaleStartTime,
2332 
2333       adofoXMintPriceWei,
2334 
2335       publicPriceWei
2336 
2337     );
2338 
2339   }
2340 
2341 
2342 
2343   // create list of adofo-x holders addresses
2344 
2345   function setWhitelist(address[] calldata addresses) public onlyOwner {
2346         for (uint256 i = 0; i < addresses.length; i++) {
2347             adofoXWhitelist[addresses[i]] = maxPerWhitelistMint;
2348         }
2349     }
2350 
2351 
2352 
2353   // for OG holders/promotions/giveaways
2354 
2355   function devMint() external onlyOwner {
2356 
2357     require(
2358 
2359       totalSupply() + amountForDevs <= collectionSize,
2360 
2361       "too many already minted before dev mint"
2362 
2363     );
2364 
2365     require(
2366 
2367       hasDevMinted == false, "dev has already claimed"
2368 
2369     );
2370 
2371       _safeMint(msg.sender, amountForDevs);
2372 
2373       hasDevMinted = true;
2374 
2375   }
2376 
2377 
2378 
2379   function setBaseURI(string calldata baseURI) external onlyOwner {
2380 
2381     _baseTokenURI = baseURI;
2382 
2383   }
2384 
2385 
2386 
2387   function setMintPassContract(address _contract) public onlyOwner {
2388 
2389 		mintPassedContract = _contract;
2390 
2391 	}
2392 
2393 
2394 
2395   function withdraw() external onlyOwner nonReentrant {
2396 
2397     (bool success, ) = payable(payments).call{value: address(this).balance}("");
2398 
2399     require(success);
2400 
2401   }
2402 
2403   function setKey(uint _key) external onlyOwner{
2404 
2405     key = _key;
2406 
2407     }
2408 
2409 
2410 
2411     function setAuthority(address _address) external onlyOwner{
2412 
2413         authority = _address;
2414 
2415     }
2416 
2417 
2418 
2419   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
2420 
2421     _setOwnersExplicit(quantity);
2422 
2423   }
2424 
2425 }