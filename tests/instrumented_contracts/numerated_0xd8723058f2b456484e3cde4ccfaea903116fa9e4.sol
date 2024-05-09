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
681 // Creator: Chiru Labs
682 
683 pragma solidity ^0.8.4;
684 
685 
686 
687 
688 
689 
690 
691 
692 
693 error ApprovalCallerNotOwnerNorApproved();
694 error ApprovalQueryForNonexistentToken();
695 error ApproveToCaller();
696 error ApprovalToCurrentOwner();
697 error BalanceQueryForZeroAddress();
698 error MintedQueryForZeroAddress();
699 error MintToZeroAddress();
700 error MintZeroQuantity();
701 error OwnerIndexOutOfBounds();
702 error OwnerQueryForNonexistentToken();
703 error TokenIndexOutOfBounds();
704 error TransferCallerNotOwnerNorApproved();
705 error TransferFromIncorrectOwner();
706 error TransferToNonERC721ReceiverImplementer();
707 error TransferToZeroAddress();
708 error UnableDetermineTokenOwner();
709 error URIQueryForNonexistentToken();
710 
711 /**
712  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
713  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
714  *
715  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
716  *
717  * Does not support burning tokens to address(0).
718  *
719  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
720  */
721 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
722     using Address for address;
723     using Strings for uint256;
724 
725     struct TokenOwnership {
726         address addr;
727         uint64 startTimestamp;
728     }
729 
730     struct AddressData {
731         uint128 balance;
732         uint128 numberMinted;
733     }
734 
735     uint256 internal _currentIndex;
736 
737     // Token name
738     string private _name;
739 
740     // Token symbol
741     string private _symbol;
742 
743     // Mapping from token ID to ownership details
744     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
745     mapping(uint256 => TokenOwnership) internal _ownerships;
746 
747     // Mapping owner address to address data
748     mapping(address => AddressData) private _addressData;
749 
750     // Mapping from token ID to approved address
751     mapping(uint256 => address) private _tokenApprovals;
752 
753     // Mapping from owner to operator approvals
754     mapping(address => mapping(address => bool)) private _operatorApprovals;
755 
756     constructor(string memory name_, string memory symbol_) {
757         _name = name_;
758         _symbol = symbol_;
759     }
760 
761     /**
762      * @dev See {IERC721Enumerable-totalSupply}.
763      */
764     function totalSupply() public view override returns (uint256) {
765         return _currentIndex;
766     }
767 
768     /**
769      * @dev See {IERC721Enumerable-tokenByIndex}.
770      */
771     function tokenByIndex(uint256 index) public view override returns (uint256) {
772         if (index >= totalSupply()) revert TokenIndexOutOfBounds();
773         return index;
774     }
775 
776     /**
777      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
778      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
779      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
780      */
781     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
782         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
783         uint256 numMintedSoFar = totalSupply();
784         uint256 tokenIdsIdx;
785         address currOwnershipAddr;
786 
787         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
788         unchecked {
789             for (uint256 i; i < numMintedSoFar; i++) {
790                 TokenOwnership memory ownership = _ownerships[i];
791                 if (ownership.addr != address(0)) {
792                     currOwnershipAddr = ownership.addr;
793                 }
794                 if (currOwnershipAddr == owner) {
795                     if (tokenIdsIdx == index) {
796                         return i;
797                     }
798                     tokenIdsIdx++;
799                 }
800             }
801         }
802 
803         // Execution should never reach this point.
804         assert(false);
805     }
806 
807     /**
808      * @dev See {IERC165-supportsInterface}.
809      */
810     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
811         return
812             interfaceId == type(IERC721).interfaceId ||
813             interfaceId == type(IERC721Metadata).interfaceId ||
814             interfaceId == type(IERC721Enumerable).interfaceId ||
815             super.supportsInterface(interfaceId);
816     }
817 
818     /**
819      * @dev See {IERC721-balanceOf}.
820      */
821     function balanceOf(address owner) public view override returns (uint256) {
822         if (owner == address(0)) revert BalanceQueryForZeroAddress();
823         return uint256(_addressData[owner].balance);
824     }
825 
826     function _numberMinted(address owner) internal view returns (uint256) {
827         if (owner == address(0)) revert MintedQueryForZeroAddress();
828         return uint256(_addressData[owner].numberMinted);
829     }
830 
831     /**
832      * Gas spent here starts off proportional to the maximum mint batch size.
833      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
834      */
835     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
836         if (!_exists(tokenId)) revert OwnerQueryForNonexistentToken();
837 
838         unchecked {
839             for (uint256 curr = tokenId;; curr--) {
840                 TokenOwnership memory ownership = _ownerships[curr];
841                 if (ownership.addr != address(0)) {
842                     return ownership;
843                 }
844             }
845         }
846     }
847 
848     /**
849      * @dev See {IERC721-ownerOf}.
850      */
851     function ownerOf(uint256 tokenId) public view override returns (address) {
852         return ownershipOf(tokenId).addr;
853     }
854 
855     /**
856      * @dev See {IERC721Metadata-name}.
857      */
858     function name() public view virtual override returns (string memory) {
859         return _name;
860     }
861 
862     /**
863      * @dev See {IERC721Metadata-symbol}.
864      */
865     function symbol() public view virtual override returns (string memory) {
866         return _symbol;
867     }
868 
869     /**
870      * @dev See {IERC721Metadata-tokenURI}.
871      */
872     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
873         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
874 
875         string memory baseURI = _baseURI();
876         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
877     }
878 
879     /**
880      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
881      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
882      * by default, can be overriden in child contracts.
883      */
884     function _baseURI() internal view virtual returns (string memory) {
885         return '';
886     }
887 
888     /**
889      * @dev See {IERC721-approve}.
890      */
891     function approve(address to, uint256 tokenId) public override {
892         address owner = ERC721A.ownerOf(tokenId);
893         if (to == owner) revert ApprovalToCurrentOwner();
894 
895         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) revert ApprovalCallerNotOwnerNorApproved();
896 
897         _approve(to, tokenId, owner);
898     }
899 
900     /**
901      * @dev See {IERC721-getApproved}.
902      */
903     function getApproved(uint256 tokenId) public view override returns (address) {
904         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
905 
906         return _tokenApprovals[tokenId];
907     }
908 
909     /**
910      * @dev See {IERC721-setApprovalForAll}.
911      */
912     function setApprovalForAll(address operator, bool approved) public override {
913         if (operator == _msgSender()) revert ApproveToCaller();
914 
915         _operatorApprovals[_msgSender()][operator] = approved;
916         emit ApprovalForAll(_msgSender(), operator, approved);
917     }
918 
919     /**
920      * @dev See {IERC721-isApprovedForAll}.
921      */
922     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
923         return _operatorApprovals[owner][operator];
924     }
925 
926     /**
927      * @dev See {IERC721-transferFrom}.
928      */
929     function transferFrom(
930         address from,
931         address to,
932         uint256 tokenId
933     ) public virtual override {
934         _transfer(from, to, tokenId);
935     }
936 
937     /**
938      * @dev See {IERC721-safeTransferFrom}.
939      */
940     function safeTransferFrom(
941         address from,
942         address to,
943         uint256 tokenId
944     ) public virtual override {
945         safeTransferFrom(from, to, tokenId, '');
946     }
947 
948     /**
949      * @dev See {IERC721-safeTransferFrom}.
950      */
951     function safeTransferFrom(
952         address from,
953         address to,
954         uint256 tokenId,
955         bytes memory _data
956     ) public override {
957         _transfer(from, to, tokenId);
958         if (!_checkOnERC721Received(from, to, tokenId, _data)) revert TransferToNonERC721ReceiverImplementer();
959     }
960 
961     /**
962      * @dev Returns whether `tokenId` exists.
963      *
964      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
965      *
966      * Tokens start existing when they are minted (`_mint`),
967      */
968     function _exists(uint256 tokenId) internal view returns (bool) {
969         return tokenId < _currentIndex;
970     }
971 
972     function _safeMint(address to, uint256 quantity) internal {
973         _safeMint(to, quantity, '');
974     }
975 
976     /**
977      * @dev Safely mints `quantity` tokens and transfers them to `to`.
978      *
979      * Requirements:
980      *
981      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
982      * - `quantity` must be greater than 0.
983      *
984      * Emits a {Transfer} event.
985      */
986     function _safeMint(
987         address to,
988         uint256 quantity,
989         bytes memory _data
990     ) internal {
991         _mint(to, quantity, _data, true);
992     }
993 
994     /**
995      * @dev Mints `quantity` tokens and transfers them to `to`.
996      *
997      * Requirements:
998      *w
999      * - `to` cannot be the zero address.
1000      * - `quantity` must be greater than 0.
1001      *
1002      * Emits a {Transfer} event.
1003      */
1004     function _mint(
1005         address to,
1006         uint256 quantity,
1007         bytes memory _data,
1008         bool safe
1009     ) internal {
1010         uint256 startTokenId = _currentIndex;
1011         if (to == address(0)) revert MintToZeroAddress();
1012         if (quantity == 0) revert MintZeroQuantity();
1013 
1014         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1015 
1016         // Overflows are incredibly unrealistic.
1017         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1018         // updatedIndex overflows if _currentIndex + quantity > 1.56e77 (2**256) - 1
1019         unchecked {
1020             _addressData[to].balance += uint128(quantity);
1021             _addressData[to].numberMinted += uint128(quantity);
1022 
1023             _ownerships[startTokenId].addr = to;
1024             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1025 
1026             uint256 updatedIndex = startTokenId;
1027 
1028             for (uint256 i; i < quantity; i++) {
1029                 emit Transfer(address(0), to, updatedIndex);
1030                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1031                     revert TransferToNonERC721ReceiverImplementer();
1032                 }
1033 
1034                 updatedIndex++;
1035             }
1036 
1037             _currentIndex = updatedIndex;
1038         }
1039 
1040         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1041     }
1042 
1043     /**
1044      * @dev Transfers `tokenId` from `from` to `to`.
1045      *
1046      * Requirements:
1047      *
1048      * - `to` cannot be the zero address.
1049      * - `tokenId` token must be owned by `from`.
1050      *
1051      * Emits a {Transfer} event.
1052      */
1053     function _transfer(
1054         address from,
1055         address to,
1056         uint256 tokenId
1057     ) private {
1058         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1059 
1060         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1061             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1062             getApproved(tokenId) == _msgSender());
1063 
1064         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1065         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1066         if (to == address(0)) revert TransferToZeroAddress();
1067 
1068         _beforeTokenTransfers(from, to, tokenId, 1);
1069 
1070         // Clear approvals from the previous owner
1071         _approve(address(0), tokenId, prevOwnership.addr);
1072 
1073         // Underflow of the sender's balance is impossible because we check for
1074         // ownership above and the recipient's balance can't realistically overflow.
1075         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1076         unchecked {
1077             _addressData[from].balance -= 1;
1078             _addressData[to].balance += 1;
1079 
1080             _ownerships[tokenId].addr = to;
1081             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1082 
1083             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1084             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1085             uint256 nextTokenId = tokenId + 1;
1086             if (_ownerships[nextTokenId].addr == address(0)) {
1087                 if (_exists(nextTokenId)) {
1088                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1089                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1090                 }
1091             }
1092         }
1093 
1094         emit Transfer(from, to, tokenId);
1095         _afterTokenTransfers(from, to, tokenId, 1);
1096     }
1097 
1098     /**
1099      * @dev Approve `to` to operate on `tokenId`
1100      *
1101      * Emits a {Approval} event.
1102      */
1103     function _approve(
1104         address to,
1105         uint256 tokenId,
1106         address owner
1107     ) private {
1108         _tokenApprovals[tokenId] = to;
1109         emit Approval(owner, to, tokenId);
1110     }
1111 
1112     /**
1113      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1114      * The call is not executed if the target address is not a contract.
1115      *
1116      * @param from address representing the previous owner of the given token ID
1117      * @param to target address that will receive the tokens
1118      * @param tokenId uint256 ID of the token to be transferred
1119      * @param _data bytes optional data to send along with the call
1120      * @return bool whether the call correctly returned the expected magic value
1121      */
1122     function _checkOnERC721Received(
1123         address from,
1124         address to,
1125         uint256 tokenId,
1126         bytes memory _data
1127     ) private returns (bool) {
1128         if (to.isContract()) {
1129             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1130                 return retval == IERC721Receiver(to).onERC721Received.selector;
1131             } catch (bytes memory reason) {
1132                 if (reason.length == 0) revert TransferToNonERC721ReceiverImplementer();
1133                 else {
1134                     assembly {
1135                         revert(add(32, reason), mload(reason))
1136                     }
1137                 }
1138             }
1139         } else {
1140             return true;
1141         }
1142     }
1143 
1144     /**
1145      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1146      *
1147      * startTokenId - the first token id to be transferred
1148      * quantity - the amount to be transferred
1149      *
1150      * Calling conditions:
1151      *
1152      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1153      * transferred to `to`.
1154      * - When `from` is zero, `tokenId` will be minted for `to`.
1155      */
1156     function _beforeTokenTransfers(
1157         address from,
1158         address to,
1159         uint256 startTokenId,
1160         uint256 quantity
1161     ) internal virtual {}
1162 
1163     /**
1164      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1165      * minting.
1166      *
1167      * startTokenId - the first token id to be transferred
1168      * quantity - the amount to be transferred
1169      *
1170      * Calling conditions:
1171      *
1172      * - when `from` and `to` are both non-zero.
1173      * - `from` and `to` are never both zero.
1174      */
1175     function _afterTokenTransfers(
1176         address from,
1177         address to,
1178         uint256 startTokenId,
1179         uint256 quantity
1180     ) internal virtual {}
1181 }
1182 // File: @openzeppelin/contracts/access/Ownable.sol
1183 
1184 
1185 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1186 
1187 pragma solidity ^0.8.0;
1188 
1189 
1190 /**
1191  * @dev Contract module which provides a basic access control mechanism, where
1192  * there is an account (an owner) that can be granted exclusive access to
1193  * specific functions.
1194  *
1195  * By default, the owner account will be the one that deploys the contract. This
1196  * can later be changed with {transferOwnership}.
1197  *
1198  * This module is used through inheritance. It will make available the modifier
1199  * `onlyOwner`, which can be applied to your functions to restrict their use to
1200  * the owner.
1201  */
1202 abstract contract Ownable is Context {
1203     address private _owner;
1204 
1205     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1206 
1207     /**
1208      * @dev Initializes the contract setting the deployer as the initial owner.
1209      */
1210     constructor() {
1211         _transferOwnership(_msgSender());
1212     }
1213 
1214     /**
1215      * @dev Returns the address of the current owner.
1216      */
1217     function owner() public view virtual returns (address) {
1218         return _owner;
1219     }
1220 
1221     /**
1222      * @dev Throws if called by any account other than the owner.
1223      */
1224     modifier onlyOwner() {
1225         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1226         _;
1227     }
1228 
1229     /**
1230      * @dev Leaves the contract without owner. It will not be possible to call
1231      * `onlyOwner` functions anymore. Can only be called by the current owner.
1232      *
1233      * NOTE: Renouncing ownership will leave the contract without an owner,
1234      * thereby removing any functionality that is only available to the owner.
1235      */
1236     function renounceOwnership() public virtual onlyOwner {
1237         _transferOwnership(address(0));
1238     }
1239 
1240     /**
1241      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1242      * Can only be called by the current owner.
1243      */
1244     function transferOwnership(address newOwner) public virtual onlyOwner {
1245         require(newOwner != address(0), "Ownable: new owner is the zero address");
1246         _transferOwnership(newOwner);
1247     }
1248 
1249     /**
1250      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1251      * Internal function without access restriction.
1252      */
1253     function _transferOwnership(address newOwner) internal virtual {
1254         address oldOwner = _owner;
1255         _owner = newOwner;
1256         emit OwnershipTransferred(oldOwner, newOwner);
1257     }
1258 }
1259 
1260 // File: contracts/nft-azuki.sol
1261 
1262 
1263 
1264 pragma solidity ^0.8.4;
1265 
1266 
1267 
1268 
1269 
1270 contract Unity is Ownable, ERC721A, ReentrancyGuard {
1271     using Strings for uint256;
1272     // Addresses
1273     address public signerRole;
1274     address private address1;
1275     address private address2;
1276     address private address3;
1277     // Sales configs
1278     uint256 public maxPerAddressPreSale = 2;
1279     uint256 public maxPerAddressPublic = 3;
1280     uint256 public reserved = 150;
1281     uint256 public maxSupply = 4999;
1282     uint256 public cost = 0.115 ether;
1283     uint256 public maxBatchSize = 3;
1284     // Timeframes
1285     uint256 public preSaleWindowOpens = 1645801200;
1286     uint256 public preSaleWindowCloses  = 1645974000;
1287     uint256 public publicWindowOpens = 1645975800;
1288     uint256 public publicWindowCloses = 1646062200;
1289     uint256 public ogWindowOpens = 1645866000;
1290     // Metadata uris
1291     string public unrevealedURI;
1292     string public baseURI;
1293     // State variables
1294     bool public paused = false;
1295     bool public revealed = false;
1296     // Amount minted at phases
1297     mapping(address => uint256) public preSaleMintedBalance;
1298     mapping(address => uint256) public publicSaleMintedBalance;
1299     mapping(address => uint256) public ogs;
1300     
1301     constructor(
1302     string memory _unrevealedURI,
1303     address _signerRole,
1304     address _address1,
1305     address _address2,
1306     address _address3
1307     ) ERC721A("55Unity", "55Unity") {
1308         unrevealedURI = _unrevealedURI;
1309         signerRole = _signerRole;
1310         address1 = _address1;
1311         address2 = _address2;
1312         address3 = _address3;
1313     }
1314 
1315     // Modifiers
1316     modifier onlyValidAccess(uint8 _v, bytes32 _r, bytes32 _s) {
1317         require(isValidAccessMessage(msg.sender, _v, _r, _s), "Invalid singature for address calling the function, account not in presale.");
1318         _;
1319     }
1320 
1321     // Mint functions ( Presale, public, giveaways)
1322     function mintPreSale(uint256 quantity, uint8 _v, bytes32 _r, bytes32 _s) external payable onlyValidAccess(_v, _r, _s) {
1323         require(block.timestamp >= preSaleWindowOpens && block.timestamp <= preSaleWindowCloses, "Presale: purchase window closed.");
1324         // OGs in the last 6 hours have one more to mint.
1325         if(ogs[msg.sender] == 1 && (preSaleMintedBalance[msg.sender] + quantity) > maxPerAddressPreSale){
1326             require(block.timestamp >= ogWindowOpens, "OG are only allowed to mint their plus one in the last 6 hours.");
1327         }
1328         require(preSaleMintedBalance[msg.sender] + quantity <= (maxPerAddressPreSale + ogs[msg.sender]), "You can only mint 2 (3) tokens during presale (OG role has one more).");
1329        
1330         preSaleMintedBalance[msg.sender] += quantity;
1331         mint(quantity);
1332     }
1333 
1334     function mintPublicSale(uint256 quantity) external payable {
1335         require(block.timestamp >= publicWindowOpens && block.timestamp <= publicWindowCloses, "Public sale: purchase window closed.");
1336         require(publicSaleMintedBalance[msg.sender] + quantity <= maxPerAddressPublic, "You can only mint 3 tokens during public sale.");
1337         
1338         publicSaleMintedBalance[msg.sender] += quantity;
1339         mint(quantity);
1340     }
1341 
1342     function mint(uint256 quantity) private {
1343         require(tx.origin == msg.sender, "No bots allowed.");
1344         require(totalSupply() + quantity <= maxSupply, "This amount of tokens would surpass the max supply (4999).");
1345         require(msg.value >= cost * quantity, "Invalid purchase, the amount of eth sent is insufficient to process the mint.");
1346         require(quantity <= maxBatchSize, "You're only allowed to mint 3 tokens at a time.");
1347         require(!paused, "Minting not available, the contract is paused.");
1348 
1349         _safeMint(msg.sender, quantity);
1350     }
1351 
1352     function giveaway(address to, uint256 quantity) external onlyOwner {
1353         require(quantity <= reserved, "This amount exceeds reserved supply. 100" );
1354         require(totalSupply() + quantity <= maxSupply, "This amount of tokens would surpass the max supply (4999).");
1355 
1356         _safeMint(to, quantity);
1357         reserved -= quantity;
1358     }
1359     
1360     // Uri token functions
1361     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1362         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token.");    
1363         
1364         if(revealed == false) {
1365             return unrevealedURI;
1366         }
1367 
1368         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));  
1369     }
1370 
1371     function setBaseURI(string calldata _baseURI) external onlyOwner {
1372         baseURI = _baseURI;
1373     }
1374     
1375     function setUnrevealedURI(string calldata _unrevealedURI) external onlyOwner {
1376         unrevealedURI = _unrevealedURI;
1377     }
1378 
1379     function reveal(string memory _baseURI) external onlyOwner {
1380         baseURI = _baseURI;
1381         revealed = true;
1382     }
1383 
1384     // Functions to change contract settings
1385     function setMaxSupply( uint256 _newReservedSupply, uint256 _maxPublicSupply) external onlyOwner {
1386         maxSupply = _maxPublicSupply;
1387         reserved = _newReservedSupply;
1388     }
1389     
1390     function pause(bool _state) external onlyOwner {
1391         paused = _state;
1392     }
1393     
1394     function setWindows(uint256 _preSaleWindowOpens, uint256 _preSaleWindowCloses, uint256 _publicWindowOpens, uint256 _publicWindowCloses)  external onlyOwner {
1395         preSaleWindowOpens = _preSaleWindowOpens;
1396         preSaleWindowCloses= _preSaleWindowCloses;
1397         publicWindowOpens = _publicWindowOpens;
1398         publicWindowCloses = _publicWindowCloses;
1399     }
1400 
1401     function setOGWindow(uint256 _OGWindowOpens)  external onlyOwner{
1402         ogWindowOpens = _OGWindowOpens;
1403     }
1404 
1405     function setMaxEarly(uint256 _maxTxEarly) external onlyOwner {
1406         maxPerAddressPreSale = _maxTxEarly;
1407     }
1408 
1409     function setMaxPublic(uint256 _maxTxPublic) external onlyOwner {
1410         maxPerAddressPublic = _maxTxPublic;
1411     }
1412 
1413     function setMaxTxs(uint256 _maxPerTx) external onlyOwner {
1414         maxBatchSize = _maxPerTx;
1415     }
1416 
1417     function setOgs(address[] calldata _ogs) external onlyOwner {
1418         for (uint256 i; i < _ogs.length; i++) {
1419             ogs[_ogs[i]] = 1;
1420         }
1421     }
1422 
1423     function newCost(uint256 _newCost) external onlyOwner {
1424         // Important to set value in wei
1425         cost = _newCost;
1426     }
1427 
1428     // WL signature, only users allowed.
1429     function isValidAccessMessage(address _add, uint8 _v, bytes32 _r, bytes32 _s) view public returns (bool) {
1430         bytes32 hash = keccak256(abi.encodePacked(this, _add));
1431         return signerRole == ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)), _v, _r, _s);
1432     }
1433 
1434     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1435         uint256 ownerTokenCount = balanceOf(_owner);
1436         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1437 
1438         for (uint256 i; i < ownerTokenCount; i++) {
1439             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1440         }
1441         
1442         return tokenIds;
1443     }
1444 
1445     function withdrawMoney() external onlyOwner nonReentrant {
1446         uint256 amount1 = address(this).balance / 100 * 20;
1447         uint256 amount2 = address(this).balance / 100 * 30;
1448         uint256 amount3 = address(this).balance / 100 * 50;
1449 
1450         (bool success, ) = address1.call{value: amount1}("");
1451         (success, ) = address2.call{value: amount2}("");
1452         (success, ) = address3.call{value: amount3}("");
1453         require(success, "Transfer failed.");
1454     }
1455 
1456 }