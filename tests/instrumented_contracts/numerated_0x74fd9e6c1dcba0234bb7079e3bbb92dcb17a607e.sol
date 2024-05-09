1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Address.sol
4 
5 pragma solidity ^0.8.4;
6 
7 
8 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
9 
10 
11 /**
12  * @dev Collection of functions related to the address type
13  */
14 library Address {
15     /**
16      * @dev Returns true if `account` is a contract.
17      *
18      * [IMPORTANT]
19      * ====
20      * It is unsafe to assume that an address for which this function returns
21      * false is an externally-owned account (EOA) and not a contract.
22      *
23      * Among others, `isContract` will return false for the following
24      * types of addresses:
25      *
26      *  - an externally-owned account
27      *  - a contract in construction
28      *  - an address where a contract will be created
29      *  - an address where a contract lived, but was destroyed
30      * ====
31      *
32      * [IMPORTANT]
33      * ====
34      * You shouldn't rely on `isContract` to protect against flash loan attacks!
35      *
36      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
37      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
38      * constructor.
39      * ====
40      */
41     function isContract(address account) internal view returns (bool) {
42         // This method relies on extcodesize/address.code.length, which returns 0
43         // for contracts in construction, since the code is only stored at the end
44         // of the constructor execution.
45 
46         return account.code.length > 0;
47     }
48 
49     /**
50      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
51      * `recipient`, forwarding all available gas and reverting on errors.
52      *
53      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
54      * of certain opcodes, possibly making contracts go over the 2300 gas limit
55      * imposed by `transfer`, making them unable to receive funds via
56      * `transfer`. {sendValue} removes this limitation.
57      *
58      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
59      *
60      * IMPORTANT: because control is transferred to `recipient`, care must be
61      * taken to not create reentrancy vulnerabilities. Consider using
62      * {ReentrancyGuard} or the
63      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
64      */
65     function sendValue(address payable recipient, uint256 amount) internal {
66         require(address(this).balance >= amount, "Address: insufficient balance");
67 
68         (bool success, ) = recipient.call{value: amount}("");
69         require(success, "Address: unable to send value, recipient may have reverted");
70     }
71 
72     /**
73      * @dev Performs a Solidity function call using a low level `call`. A
74      * plain `call` is an unsafe replacement for a function call: use this
75      * function instead.
76      *
77      * If `target` reverts with a revert reason, it is bubbled up by this
78      * function (like regular Solidity function calls).
79      *
80      * Returns the raw returned data. To convert to the expected return value,
81      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
82      *
83      * Requirements:
84      *
85      * - `target` must be a contract.
86      * - calling `target` with `data` must not revert.
87      *
88      * _Available since v3.1._
89      */
90     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
91         return functionCall(target, data, "Address: low-level call failed");
92     }
93 
94     /**
95      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
96      * `errorMessage` as a fallback revert reason when `target` reverts.
97      *
98      * _Available since v3.1._
99      */
100     function functionCall(
101         address target,
102         bytes memory data,
103         string memory errorMessage
104     ) internal returns (bytes memory) {
105         return functionCallWithValue(target, data, 0, errorMessage);
106     }
107 
108     /**
109      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
110      * but also transferring `value` wei to `target`.
111      *
112      * Requirements:
113      *
114      * - the calling contract must have an ETH balance of at least `value`.
115      * - the called Solidity function must be `payable`.
116      *
117      * _Available since v3.1._
118      */
119     function functionCallWithValue(
120         address target,
121         bytes memory data,
122         uint256 value
123     ) internal returns (bytes memory) {
124         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
125     }
126 
127     /**
128      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
129      * with `errorMessage` as a fallback revert reason when `target` reverts.
130      *
131      * _Available since v3.1._
132      */
133     function functionCallWithValue(
134         address target,
135         bytes memory data,
136         uint256 value,
137         string memory errorMessage
138     ) internal returns (bytes memory) {
139         require(address(this).balance >= value, "Address: insufficient balance for call");
140         require(isContract(target), "Address: call to non-contract");
141 
142         (bool success, bytes memory returndata) = target.call{value: value}(data);
143         return verifyCallResult(success, returndata, errorMessage);
144     }
145 
146     /**
147      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
148      * but performing a static call.
149      *
150      * _Available since v3.3._
151      */
152     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
153         return functionStaticCall(target, data, "Address: low-level static call failed");
154     }
155 
156     /**
157      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
158      * but performing a static call.
159      *
160      * _Available since v3.3._
161      */
162     function functionStaticCall(
163         address target,
164         bytes memory data,
165         string memory errorMessage
166     ) internal view returns (bytes memory) {
167         require(isContract(target), "Address: static call to non-contract");
168 
169         (bool success, bytes memory returndata) = target.staticcall(data);
170         return verifyCallResult(success, returndata, errorMessage);
171     }
172 
173     /**
174      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
175      * but performing a delegate call.
176      *
177      * _Available since v3.4._
178      */
179     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
180         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
185      * but performing a delegate call.
186      *
187      * _Available since v3.4._
188      */
189     function functionDelegateCall(
190         address target,
191         bytes memory data,
192         string memory errorMessage
193     ) internal returns (bytes memory) {
194         require(isContract(target), "Address: delegate call to non-contract");
195 
196         (bool success, bytes memory returndata) = target.delegatecall(data);
197         return verifyCallResult(success, returndata, errorMessage);
198     }
199 
200     /**
201      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
202      * revert reason using the provided one.
203      *
204      * _Available since v4.3._
205      */
206     function verifyCallResult(
207         bool success,
208         bytes memory returndata,
209         string memory errorMessage
210     ) internal pure returns (bytes memory) {
211         if (success) {
212             return returndata;
213         } else {
214             // Look for revert reason and bubble it up if present
215             if (returndata.length > 0) {
216                 // The easiest way to bubble the revert reason is using memory via assembly
217 
218                 assembly {
219                     let returndata_size := mload(returndata)
220                     revert(add(32, returndata), returndata_size)
221                 }
222             } else {
223                 revert(errorMessage);
224             }
225         }
226     }
227 }
228 
229 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
230 
231 
232 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
233 
234 
235 /**
236  * @title ERC721 token receiver interface
237  * @dev Interface for any contract that wants to support safeTransfers
238  * from ERC721 asset contracts.
239  */
240 interface IERC721Receiver {
241     /**
242      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
243      * by `operator` from `from`, this function is called.
244      *
245      * It must return its Solidity selector to confirm the token transfer.
246      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
247      *
248      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
249      */
250     function onERC721Received(
251         address operator,
252         address from,
253         uint256 tokenId,
254         bytes calldata data
255     ) external returns (bytes4);
256 }
257 
258 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
259 
260 
261 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
262 
263 
264 /**
265  * @dev Interface of the ERC165 standard, as defined in the
266  * https://eips.ethereum.org/EIPS/eip-165[EIP].
267  *
268  * Implementers can declare support of contract interfaces, which can then be
269  * queried by others ({ERC165Checker}).
270  *
271  * For an implementation, see {ERC165}.
272  */
273 interface IERC165 {
274     /**
275      * @dev Returns true if this contract implements the interface defined by
276      * `interfaceId`. See the corresponding
277      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
278      * to learn more about how these ids are created.
279      *
280      * This function call must use less than 30 000 gas.
281      */
282     function supportsInterface(bytes4 interfaceId) external view returns (bool);
283 }
284 
285 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
286 
287 
288 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
289 
290 
291 /**
292  * @dev Implementation of the {IERC165} interface.
293  *
294  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
295  * for the additional interface id that will be supported. For example:
296  *
297  * ```solidity
298  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
299  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
300  * }
301  * ```
302  *
303  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
304  */
305 abstract contract ERC165 is IERC165 {
306     /**
307      * @dev See {IERC165-supportsInterface}.
308      */
309     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
310         return interfaceId == type(IERC165).interfaceId;
311     }
312 }
313 
314 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
315 
316 
317 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
318 
319 
320 /**
321  * @dev Required interface of an ERC721 compliant contract.
322  */
323 interface IERC721 is IERC165 {
324     /**
325      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
326      */
327     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
328 
329     /**
330      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
331      */
332     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
333 
334     /**
335      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
336      */
337     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
338 
339     /**
340      * @dev Returns the number of tokens in ``owner``'s account.
341      */
342     function balanceOf(address owner) external view returns (uint256 balance);
343 
344     /**
345      * @dev Returns the owner of the `tokenId` token.
346      *
347      * Requirements:
348      *
349      * - `tokenId` must exist.
350      */
351     function ownerOf(uint256 tokenId) external view returns (address owner);
352 
353     /**
354      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
355      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
356      *
357      * Requirements:
358      *
359      * - `from` cannot be the zero address.
360      * - `to` cannot be the zero address.
361      * - `tokenId` token must exist and be owned by `from`.
362      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
363      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
364      *
365      * Emits a {Transfer} event.
366      */
367     function safeTransferFrom(
368         address from,
369         address to,
370         uint256 tokenId
371     ) external;
372 
373     /**
374      * @dev Transfers `tokenId` token from `from` to `to`.
375      *
376      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
377      *
378      * Requirements:
379      *
380      * - `from` cannot be the zero address.
381      * - `to` cannot be the zero address.
382      * - `tokenId` token must be owned by `from`.
383      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
384      *
385      * Emits a {Transfer} event.
386      */
387     function transferFrom(
388         address from,
389         address to,
390         uint256 tokenId
391     ) external;
392 
393     /**
394      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
395      * The approval is cleared when the token is transferred.
396      *
397      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
398      *
399      * Requirements:
400      *
401      * - The caller must own the token or be an approved operator.
402      * - `tokenId` must exist.
403      *
404      * Emits an {Approval} event.
405      */
406     function approve(address to, uint256 tokenId) external;
407 
408     /**
409      * @dev Returns the account approved for `tokenId` token.
410      *
411      * Requirements:
412      *
413      * - `tokenId` must exist.
414      */
415     function getApproved(uint256 tokenId) external view returns (address operator);
416 
417     /**
418      * @dev Approve or remove `operator` as an operator for the caller.
419      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
420      *
421      * Requirements:
422      *
423      * - The `operator` cannot be the caller.
424      *
425      * Emits an {ApprovalForAll} event.
426      */
427     function setApprovalForAll(address operator, bool _approved) external;
428 
429     /**
430      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
431      *
432      * See {setApprovalForAll}
433      */
434     function isApprovedForAll(address owner, address operator) external view returns (bool);
435 
436     /**
437      * @dev Safely transfers `tokenId` token from `from` to `to`.
438      *
439      * Requirements:
440      *
441      * - `from` cannot be the zero address.
442      * - `to` cannot be the zero address.
443      * - `tokenId` token must exist and be owned by `from`.
444      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
445      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
446      *
447      * Emits a {Transfer} event.
448      */
449     function safeTransferFrom(
450         address from,
451         address to,
452         uint256 tokenId,
453         bytes calldata data
454     ) external;
455 }
456 
457 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
458 
459 
460 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
461 
462 
463 /**
464  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
465  * @dev See https://eips.ethereum.org/EIPS/eip-721
466  */
467 interface IERC721Enumerable is IERC721 {
468     /**
469      * @dev Returns the total amount of tokens stored by the contract.
470      */
471     function totalSupply() external view returns (uint256);
472 
473     /**
474      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
475      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
476      */
477     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
478 
479     /**
480      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
481      * Use along with {totalSupply} to enumerate all tokens.
482      */
483     function tokenByIndex(uint256 index) external view returns (uint256);
484 }
485 
486 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
487 
488 
489 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
490 
491 
492 
493 /**
494  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
495  * @dev See https://eips.ethereum.org/EIPS/eip-721
496  */
497 interface IERC721Metadata is IERC721 {
498     /**
499      * @dev Returns the token collection name.
500      */
501     function name() external view returns (string memory);
502 
503     /**
504      * @dev Returns the token collection symbol.
505      */
506     function symbol() external view returns (string memory);
507 
508     /**
509      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
510      */
511     function tokenURI(uint256 tokenId) external view returns (string memory);
512 }
513 
514 // File: @openzeppelin/contracts/utils/Strings.sol
515 
516 
517 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
518 
519 
520 /**
521  * @dev String operations.
522  */
523 library Strings {
524     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
525 
526     /**
527      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
528      */
529     function toString(uint256 value) internal pure returns (string memory) {
530         // Inspired by OraclizeAPI's implementation - MIT licence
531         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
532 
533         if (value == 0) {
534             return "0";
535         }
536         uint256 temp = value;
537         uint256 digits;
538         while (temp != 0) {
539             digits++;
540             temp /= 10;
541         }
542         bytes memory buffer = new bytes(digits);
543         while (value != 0) {
544             digits -= 1;
545             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
546             value /= 10;
547         }
548         return string(buffer);
549     }
550 
551     /**
552      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
553      */
554     function toHexString(uint256 value) internal pure returns (string memory) {
555         if (value == 0) {
556             return "0x00";
557         }
558         uint256 temp = value;
559         uint256 length = 0;
560         while (temp != 0) {
561             length++;
562             temp >>= 8;
563         }
564         return toHexString(value, length);
565     }
566 
567     /**
568      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
569      */
570     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
571         bytes memory buffer = new bytes(2 * length + 2);
572         buffer[0] = "0";
573         buffer[1] = "x";
574         for (uint256 i = 2 * length + 1; i > 1; --i) {
575             buffer[i] = _HEX_SYMBOLS[value & 0xf];
576             value >>= 4;
577         }
578         require(value == 0, "Strings: hex length insufficient");
579         return string(buffer);
580     }
581 }
582 
583 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
584 
585 
586 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
587 
588 
589 /**
590  * @dev Contract module that helps prevent reentrant calls to a function.
591  *
592  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
593  * available, which can be applied to functions to make sure there are no nested
594  * (reentrant) calls to them.
595  *
596  * Note that because there is a single `nonReentrant` guard, functions marked as
597  * `nonReentrant` may not call one another. This can be worked around by making
598  * those functions `private`, and then adding `external` `nonReentrant` entry
599  * points to them.
600  *
601  * TIP: If you would like to learn more about reentrancy and alternative ways
602  * to protect against it, check out our blog post
603  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
604  */
605 abstract contract ReentrancyGuard {
606     // Booleans are more expensive than uint256 or any type that takes up a full
607     // word because each write operation emits an extra SLOAD to first read the
608     // slot's contents, replace the bits taken up by the boolean, and then write
609     // back. This is the compiler's defense against contract upgrades and
610     // pointer aliasing, and it cannot be disabled.
611 
612     // The values being non-zero value makes deployment a bit more expensive,
613     // but in exchange the refund on every call to nonReentrant will be lower in
614     // amount. Since refunds are capped to a percentage of the total
615     // transaction's gas, it is best to keep them low in cases like this one, to
616     // increase the likelihood of the full refund coming into effect.
617     uint256 private constant _NOT_ENTERED = 1;
618     uint256 private constant _ENTERED = 2;
619 
620     uint256 private _status;
621 
622     constructor() {
623         _status = _NOT_ENTERED;
624     }
625 
626     /**
627      * @dev Prevents a contract from calling itself, directly or indirectly.
628      * Calling a `nonReentrant` function from another `nonReentrant`
629      * function is not supported. It is possible to prevent this from happening
630      * by making the `nonReentrant` function external, and making it call a
631      * `private` function that does the actual work.
632      */
633     modifier nonReentrant() {
634         // On the first call to nonReentrant, _notEntered will be true
635         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
636 
637         // Any calls to nonReentrant after this point will fail
638         _status = _ENTERED;
639 
640         _;
641 
642         // By storing the original value once again, a refund is triggered (see
643         // https://eips.ethereum.org/EIPS/eip-2200)
644         _status = _NOT_ENTERED;
645     }
646 }
647 
648 // File: @openzeppelin/contracts/utils/Context.sol
649 
650 
651 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
652 
653 
654 /**
655  * @dev Provides information about the current execution context, including the
656  * sender of the transaction and its data. While these are generally available
657  * via msg.sender and msg.data, they should not be accessed in such a direct
658  * manner, since when dealing with meta-transactions the account sending and
659  * paying for execution may not be the actual sender (as far as an application
660  * is concerned).
661  *
662  * This contract is only required for intermediate, library-like contracts.
663  */
664 abstract contract Context {
665     function _msgSender() internal view virtual returns (address) {
666         return msg.sender;
667     }
668 
669     function _msgData() internal view virtual returns (bytes calldata) {
670         return msg.data;
671     }
672 }
673 
674 // File: contracts/ERC721A.sol
675 
676 
677 // Creator: Chiru Labs
678 
679 
680 
681 
682 
683 
684 
685 
686 
687 
688 error ApprovalCallerNotOwnerNorApproved();
689 error ApprovalQueryForNonexistentToken();
690 error ApproveToCaller();
691 error ApprovalToCurrentOwner();
692 error BalanceQueryForZeroAddress();
693 error MintedQueryForZeroAddress();
694 error BurnedQueryForZeroAddress();
695 error AuxQueryForZeroAddress();
696 error MintToZeroAddress();
697 error MintZeroQuantity();
698 error OwnerIndexOutOfBounds();
699 error OwnerQueryForNonexistentToken();
700 error TokenIndexOutOfBounds();
701 error TransferCallerNotOwnerNorApproved();
702 error TransferFromIncorrectOwner();
703 error TransferToNonERC721ReceiverImplementer();
704 error TransferToZeroAddress();
705 error URIQueryForNonexistentToken();
706 
707 /**
708  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
709  * the Metadata extension. Built to optimize for lower gas during batch mints.
710  *
711  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
712  *
713  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
714  *
715  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
716  */
717 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
718     using Address for address;
719     using Strings for uint256;
720 
721     // Compiler will pack this into a single 256bit word.
722     struct TokenOwnership {
723         // The address of the owner.
724         address addr;
725         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
726         uint64 startTimestamp;
727         // Whether the token has been burned.
728         bool burned;
729     }
730 
731     // Compiler will pack this into a single 256bit word.
732     struct AddressData {
733         // Realistically, 2**64-1 is more than enough.
734         uint64 balance;
735         // Keeps track of mint count with minimal overhead for tokenomics.
736         uint64 numberMinted;
737         // Keeps track of burn count with minimal overhead for tokenomics.
738         uint64 numberBurned;
739         // For miscellaneous variable(s) pertaining to the address
740         // (e.g. number of whitelist mint slots used).
741         // If there are multiple variables, please pack them into a uint64.
742         uint64 aux;
743     }
744 
745     // The tokenId of the next token to be minted.
746     uint256 internal _currentIndex;
747 
748     // The number of tokens burned.
749     uint256 internal _burnCounter;
750 
751     // Token name
752     string private _name;
753 
754     // Token symbol
755     string private _symbol;
756 
757     // Mapping from token ID to ownership details
758     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
759     mapping(uint256 => TokenOwnership) internal _ownerships;
760 
761     // Mapping owner address to address data
762     mapping(address => AddressData) private _addressData;
763 
764     // Mapping from token ID to approved address
765     mapping(uint256 => address) private _tokenApprovals;
766 
767     // Mapping from owner to operator approvals
768     mapping(address => mapping(address => bool)) private _operatorApprovals;
769 
770     constructor(string memory name_, string memory symbol_) {
771         _name = name_;
772         _symbol = symbol_;
773         _currentIndex = _startTokenId();
774     }
775 
776     /**
777      * To change the starting tokenId, please override this function.
778      */
779     function _startTokenId() internal view virtual returns (uint256) {
780         return 0;
781     }
782 
783     /**
784      * @dev See {IERC721Enumerable-totalSupply}.
785      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
786      */
787     function totalSupply() public view returns (uint256) {
788         // Counter underflow is impossible as _burnCounter cannot be incremented
789         // more than _currentIndex - _startTokenId() times
790         unchecked {
791             return _currentIndex - _burnCounter - _startTokenId();
792         }
793     }
794 
795     /**
796      * Returns the total amount of tokens minted in the contract.
797      */
798     function _totalMinted() internal view returns (uint256) {
799         // Counter underflow is impossible as _currentIndex does not decrement,
800         // and it is initialized to _startTokenId()
801         unchecked {
802             return _currentIndex - _startTokenId();
803         }
804     }
805 
806     /**
807      * @dev See {IERC165-supportsInterface}.
808      */
809     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
810         return
811             interfaceId == type(IERC721).interfaceId ||
812             interfaceId == type(IERC721Metadata).interfaceId ||
813             super.supportsInterface(interfaceId);
814     }
815 
816     /**
817      * @dev See {IERC721-balanceOf}.
818      */
819     function balanceOf(address owner) public view override returns (uint256) {
820         if (owner == address(0)) revert BalanceQueryForZeroAddress();
821         return uint256(_addressData[owner].balance);
822     }
823 
824     /**
825      * Returns the number of tokens minted by `owner`.
826      */
827     function _numberMinted(address owner) internal view returns (uint256) {
828         if (owner == address(0)) revert MintedQueryForZeroAddress();
829         return uint256(_addressData[owner].numberMinted);
830     }
831 
832     /**
833      * Returns the number of tokens burned by or on behalf of `owner`.
834      */
835     function _numberBurned(address owner) internal view returns (uint256) {
836         if (owner == address(0)) revert BurnedQueryForZeroAddress();
837         return uint256(_addressData[owner].numberBurned);
838     }
839 
840     /**
841      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
842      */
843     function _getAux(address owner) internal view returns (uint64) {
844         if (owner == address(0)) revert AuxQueryForZeroAddress();
845         return _addressData[owner].aux;
846     }
847 
848     /**
849      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
850      * If there are multiple variables, please pack them into a uint64.
851      */
852     function _setAux(address owner, uint64 aux) internal {
853         if (owner == address(0)) revert AuxQueryForZeroAddress();
854         _addressData[owner].aux = aux;
855     }
856 
857     /**
858      * Gas spent here starts off proportional to the maximum mint batch size.
859      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
860      */
861     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
862         uint256 curr = tokenId;
863 
864         unchecked {
865             if (_startTokenId() <= curr && curr < _currentIndex) {
866                 TokenOwnership memory ownership = _ownerships[curr];
867                 if (!ownership.burned) {
868                     if (ownership.addr != address(0)) {
869                         return ownership;
870                     }
871                     // Invariant:
872                     // There will always be an ownership that has an address and is not burned
873                     // before an ownership that does not have an address and is not burned.
874                     // Hence, curr will not underflow.
875                     while (true) {
876                         curr--;
877                         ownership = _ownerships[curr];
878                         if (ownership.addr != address(0)) {
879                             return ownership;
880                         }
881                     }
882                 }
883             }
884         }
885         revert OwnerQueryForNonexistentToken();
886     }
887 
888     /**
889      * @dev See {IERC721-ownerOf}.
890      */
891     function ownerOf(uint256 tokenId) public view override returns (address) {
892         return ownershipOf(tokenId).addr;
893     }
894 
895     /**
896      * @dev See {IERC721Metadata-name}.
897      */
898     function name() public view virtual override returns (string memory) {
899         return _name;
900     }
901 
902     /**
903      * @dev See {IERC721Metadata-symbol}.
904      */
905     function symbol() public view virtual override returns (string memory) {
906         return _symbol;
907     }
908 
909     /**
910      * @dev See {IERC721Metadata-tokenURI}.
911      */
912     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
913         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
914 
915         string memory baseURI = _baseURI();
916         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
917     }
918 
919     /**
920      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
921      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
922      * by default, can be overriden in child contracts.
923      */
924     function _baseURI() internal view virtual returns (string memory) {
925         return '';
926     }
927 
928     /**
929      * @dev See {IERC721-approve}.
930      */
931     function approve(address to, uint256 tokenId) public override {
932         address owner = ERC721A.ownerOf(tokenId);
933         if (to == owner) revert ApprovalToCurrentOwner();
934 
935         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
936             revert ApprovalCallerNotOwnerNorApproved();
937         }
938 
939         _approve(to, tokenId, owner);
940     }
941 
942     /**
943      * @dev See {IERC721-getApproved}.
944      */
945     function getApproved(uint256 tokenId) public view override returns (address) {
946         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
947 
948         return _tokenApprovals[tokenId];
949     }
950 
951     /**
952      * @dev See {IERC721-setApprovalForAll}.
953      */
954     function setApprovalForAll(address operator, bool approved) public override {
955         if (operator == _msgSender()) revert ApproveToCaller();
956 
957         _operatorApprovals[_msgSender()][operator] = approved;
958         emit ApprovalForAll(_msgSender(), operator, approved);
959     }
960 
961     /**
962      * @dev See {IERC721-isApprovedForAll}.
963      */
964     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
965         return _operatorApprovals[owner][operator];
966     }
967 
968     /**
969      * @dev See {IERC721-transferFrom}.
970      */
971     function transferFrom(
972         address from,
973         address to,
974         uint256 tokenId
975     ) public virtual override {
976         _transfer(from, to, tokenId);
977     }
978 
979     /**
980      * @dev See {IERC721-safeTransferFrom}.
981      */
982     function safeTransferFrom(
983         address from,
984         address to,
985         uint256 tokenId
986     ) public virtual override {
987         safeTransferFrom(from, to, tokenId, '');
988     }
989 
990     /**
991      * @dev See {IERC721-safeTransferFrom}.
992      */
993     function safeTransferFrom(
994         address from,
995         address to,
996         uint256 tokenId,
997         bytes memory _data
998     ) public virtual override {
999         _transfer(from, to, tokenId);
1000         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1001             revert TransferToNonERC721ReceiverImplementer();
1002         }
1003     }
1004 
1005     /**
1006      * @dev Returns whether `tokenId` exists.
1007      *
1008      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1009      *
1010      * Tokens start existing when they are minted (`_mint`),
1011      */
1012     function _exists(uint256 tokenId) internal view returns (bool) {
1013         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1014             !_ownerships[tokenId].burned;
1015     }
1016 
1017     function _safeMint(address to, uint256 quantity) internal {
1018         _safeMint(to, quantity, '');
1019     }
1020 
1021     /**
1022      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1023      *
1024      * Requirements:
1025      *
1026      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1027      * - `quantity` must be greater than 0.
1028      *
1029      * Emits a {Transfer} event.
1030      */
1031     function _safeMint(
1032         address to,
1033         uint256 quantity,
1034         bytes memory _data
1035     ) internal {
1036         _mint(to, quantity, _data, true);
1037     }
1038 
1039     /**
1040      * @dev Mints `quantity` tokens and transfers them to `to`.
1041      *
1042      * Requirements:
1043      *
1044      * - `to` cannot be the zero address.
1045      * - `quantity` must be greater than 0.
1046      *
1047      * Emits a {Transfer} event.
1048      */
1049     function _mint(
1050         address to,
1051         uint256 quantity,
1052         bytes memory _data,
1053         bool safe
1054     ) internal {
1055         uint256 startTokenId = _currentIndex;
1056         if (to == address(0)) revert MintToZeroAddress();
1057         if (quantity == 0) revert MintZeroQuantity();
1058 
1059         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1060 
1061         // Overflows are incredibly unrealistic.
1062         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1063         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1064         unchecked {
1065             _addressData[to].balance += uint64(quantity);
1066             _addressData[to].numberMinted += uint64(quantity);
1067 
1068             _ownerships[startTokenId].addr = to;
1069             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1070 
1071             uint256 updatedIndex = startTokenId;
1072             uint256 end = updatedIndex + quantity;
1073 
1074             if (safe && to.isContract()) {
1075                 do {
1076                     emit Transfer(address(0), to, updatedIndex);
1077                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1078                         revert TransferToNonERC721ReceiverImplementer();
1079                     }
1080                 } while (updatedIndex != end);
1081                 // Reentrancy protection
1082                 if (_currentIndex != startTokenId) revert();
1083             } else {
1084                 do {
1085                     emit Transfer(address(0), to, updatedIndex++);
1086                 } while (updatedIndex != end);
1087             }
1088             _currentIndex = updatedIndex;
1089         }
1090         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1091     }
1092 
1093     /**
1094      * @dev Transfers `tokenId` from `from` to `to`.
1095      *
1096      * Requirements:
1097      *
1098      * - `to` cannot be the zero address.
1099      * - `tokenId` token must be owned by `from`.
1100      *
1101      * Emits a {Transfer} event.
1102      */
1103     function _transfer(
1104         address from,
1105         address to,
1106         uint256 tokenId
1107     ) private {
1108         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1109 
1110         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1111             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1112             getApproved(tokenId) == _msgSender());
1113 
1114         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1115         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1116         if (to == address(0)) revert TransferToZeroAddress();
1117 
1118         _beforeTokenTransfers(from, to, tokenId, 1);
1119 
1120         // Clear approvals from the previous owner
1121         _approve(address(0), tokenId, prevOwnership.addr);
1122 
1123         // Underflow of the sender's balance is impossible because we check for
1124         // ownership above and the recipient's balance can't realistically overflow.
1125         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1126         unchecked {
1127             _addressData[from].balance -= 1;
1128             _addressData[to].balance += 1;
1129 
1130             _ownerships[tokenId].addr = to;
1131             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1132 
1133             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1134             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1135             uint256 nextTokenId = tokenId + 1;
1136             if (_ownerships[nextTokenId].addr == address(0)) {
1137                 // This will suffice for checking _exists(nextTokenId),
1138                 // as a burned slot cannot contain the zero address.
1139                 if (nextTokenId < _currentIndex) {
1140                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1141                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1142                 }
1143             }
1144         }
1145 
1146         emit Transfer(from, to, tokenId);
1147         _afterTokenTransfers(from, to, tokenId, 1);
1148     }
1149 
1150     /**
1151      * @dev Destroys `tokenId`.
1152      * The approval is cleared when the token is burned.
1153      *
1154      * Requirements:
1155      *
1156      * - `tokenId` must exist.
1157      *
1158      * Emits a {Transfer} event.
1159      */
1160     function _burn(uint256 tokenId) internal virtual {
1161         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1162 
1163         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1164 
1165         // Clear approvals from the previous owner
1166         _approve(address(0), tokenId, prevOwnership.addr);
1167 
1168         // Underflow of the sender's balance is impossible because we check for
1169         // ownership above and the recipient's balance can't realistically overflow.
1170         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1171         unchecked {
1172             _addressData[prevOwnership.addr].balance -= 1;
1173             _addressData[prevOwnership.addr].numberBurned += 1;
1174 
1175             // Keep track of who burned the token, and the timestamp of burning.
1176             _ownerships[tokenId].addr = prevOwnership.addr;
1177             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1178             _ownerships[tokenId].burned = true;
1179 
1180             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1181             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1182             uint256 nextTokenId = tokenId + 1;
1183             if (_ownerships[nextTokenId].addr == address(0)) {
1184                 // This will suffice for checking _exists(nextTokenId),
1185                 // as a burned slot cannot contain the zero address.
1186                 if (nextTokenId < _currentIndex) {
1187                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1188                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1189                 }
1190             }
1191         }
1192 
1193         emit Transfer(prevOwnership.addr, address(0), tokenId);
1194         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1195 
1196         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1197         unchecked {
1198             _burnCounter++;
1199         }
1200     }
1201 
1202     /**
1203      * @dev Approve `to` to operate on `tokenId`
1204      *
1205      * Emits a {Approval} event.
1206      */
1207     function _approve(
1208         address to,
1209         uint256 tokenId,
1210         address owner
1211     ) private {
1212         _tokenApprovals[tokenId] = to;
1213         emit Approval(owner, to, tokenId);
1214     }
1215 
1216     /**
1217      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1218      *
1219      * @param from address representing the previous owner of the given token ID
1220      * @param to target address that will receive the tokens
1221      * @param tokenId uint256 ID of the token to be transferred
1222      * @param _data bytes optional data to send along with the call
1223      * @return bool whether the call correctly returned the expected magic value
1224      */
1225     function _checkContractOnERC721Received(
1226         address from,
1227         address to,
1228         uint256 tokenId,
1229         bytes memory _data
1230     ) private returns (bool) {
1231         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1232             return retval == IERC721Receiver(to).onERC721Received.selector;
1233         } catch (bytes memory reason) {
1234             if (reason.length == 0) {
1235                 revert TransferToNonERC721ReceiverImplementer();
1236             } else {
1237                 assembly {
1238                     revert(add(32, reason), mload(reason))
1239                 }
1240             }
1241         }
1242     }
1243 
1244     /**
1245      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1246      * And also called before burning one token.
1247      *
1248      * startTokenId - the first token id to be transferred
1249      * quantity - the amount to be transferred
1250      *
1251      * Calling conditions:
1252      *
1253      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1254      * transferred to `to`.
1255      * - When `from` is zero, `tokenId` will be minted for `to`.
1256      * - When `to` is zero, `tokenId` will be burned by `from`.
1257      * - `from` and `to` are never both zero.
1258      */
1259     function _beforeTokenTransfers(
1260         address from,
1261         address to,
1262         uint256 startTokenId,
1263         uint256 quantity
1264     ) internal virtual {}
1265 
1266     /**
1267      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1268      * minting.
1269      * And also called after one token has been burned.
1270      *
1271      * startTokenId - the first token id to be transferred
1272      * quantity - the amount to be transferred
1273      *
1274      * Calling conditions:
1275      *
1276      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1277      * transferred to `to`.
1278      * - When `from` is zero, `tokenId` has been minted for `to`.
1279      * - When `to` is zero, `tokenId` has been burned by `from`.
1280      * - `from` and `to` are never both zero.
1281      */
1282     function _afterTokenTransfers(
1283         address from,
1284         address to,
1285         uint256 startTokenId,
1286         uint256 quantity
1287     ) internal virtual {}
1288 }
1289 // File: @openzeppelin/contracts/access/Ownable.sol
1290 
1291 
1292 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1293 
1294 /**
1295  * @dev Contract module which provides a basic access control mechanism, where
1296  * there is an account (an owner) that can be granted exclusive access to
1297  * specific functions.
1298  *
1299  * By default, the owner account will be the one that deploys the contract. This
1300  * can later be changed with {transferOwnership}.
1301  *
1302  * This module is used through inheritance. It will make available the modifier
1303  * `onlyOwner`, which can be applied to your functions to restrict their use to
1304  * the owner.
1305  */
1306 abstract contract Ownable is Context {
1307     address private _owner;
1308 
1309     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1310 
1311     /**
1312      * @dev Initializes the contract setting the deployer as the initial owner.
1313      */
1314     constructor() {
1315         _transferOwnership(_msgSender());
1316     }
1317 
1318     /**
1319      * @dev Returns the address of the current owner.
1320      */
1321     function owner() public view virtual returns (address) {
1322         return _owner;
1323     }
1324 
1325     /**
1326      * @dev Throws if called by any account other than the owner.
1327      */
1328     modifier onlyOwner() {
1329         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1330         _;
1331     }
1332 
1333     /**
1334      * @dev Leaves the contract without owner. It will not be possible to call
1335      * `onlyOwner` functions anymore. Can only be called by the current owner.
1336      *
1337      * NOTE: Renouncing ownership will leave the contract without an owner,
1338      * thereby removing any functionality that is only available to the owner.
1339      */
1340     function renounceOwnership() public virtual onlyOwner {
1341         _transferOwnership(address(0));
1342     }
1343 
1344     /**
1345      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1346      * Can only be called by the current owner.
1347      */
1348     function transferOwnership(address newOwner) public virtual onlyOwner {
1349         require(newOwner != address(0), "Ownable: new owner is the zero address");
1350         _transferOwnership(newOwner);
1351     }
1352 
1353     /**
1354      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1355      * Internal function without access restriction.
1356      */
1357     function _transferOwnership(address newOwner) internal virtual {
1358         address oldOwner = _owner;
1359         _owner = newOwner;
1360         emit OwnershipTransferred(oldOwner, newOwner);
1361     }
1362 }
1363 
1364 // File: contracts/platypal.sol
1365 
1366 
1367 
1368 contract PlatyPals is Ownable, ERC721A, ReentrancyGuard {
1369 
1370   uint256 public MAX_TRANSACTION = 20;
1371   uint256 public MAX_SUPPLY = 10000;
1372   uint256 public MAX_MINTTO = 10;
1373   uint256 public reserves;
1374   
1375   uint256 public Price = 0.01 ether;
1376 
1377   bool saleActive = false;
1378 
1379   address[] payees = [
1380 	0xC3b615216362aA20384D74B0dEB082c9a6f1ec20,
1381 	0x8d9267C5b9fbDb4AE25E0CC6C1F1314924a50cAA,
1382 	0x30EBED83cedC319b0f7340676675ac8a399bF307,
1383 	0x1de5A79a5E400306B103eb952Dc2D48AB66ec332,
1384 	0xA0BfFBF77957bf2b99101ff014F7c4DB9C5ce20D,
1385 	0x09A31e9eA6490991995d4EceC3C5748B993064fd,
1386 	0xd6D0e0F6155cC645B3Cae81CC423022904eE2b9B,
1387 	0xbb2F64A6559Fc5b18FaBB4438b1E0ed89f8aBA29
1388   ];
1389 
1390   uint[] owed = [15, 15, 10, 10, 10, 10, 10, 20];
1391 
1392   constructor() ERC721A("PlatyPals", "PP") { }
1393 
1394   function publicMint(uint256 quantity) external payable {
1395     require(saleActive, "Sale not started");
1396     require(tx.origin == msg.sender, "No proxy calls");
1397     require(quantity <= MAX_TRANSACTION, "Order exceeds transaction limit");
1398     require(totalSupply() + quantity <= MAX_SUPPLY, "Order exceeds max supply");
1399 
1400     require(msg.value >= Price * quantity, "Insufficient ETH sent");
1401 	
1402     _safeMint(msg.sender, quantity);
1403   }
1404 
1405   // // metadata URI
1406   string private _baseTokenURI;
1407 
1408   function _baseURI() internal view virtual override returns (string memory) {
1409     return _baseTokenURI;
1410   }
1411 
1412   function numberMinted(address owner) public view returns (uint256) {
1413     return _numberMinted(owner);
1414   }
1415   
1416   function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1417     return ownershipOf(tokenId);
1418   }
1419 
1420   // Only Owner
1421   
1422   function setBaseURI(string calldata baseURI) external onlyOwner {
1423     _baseTokenURI = baseURI;
1424   }
1425 
1426   function mintTo(address _receiver, uint256 quantity) external onlyOwner {
1427     require(totalSupply() + quantity <= MAX_SUPPLY, "Order exceeds max supply");
1428 	require(quantity + reserves <= MAX_MINTTO, "Exceeds reserves");
1429 
1430 	reserves += quantity;
1431     _safeMint(_receiver, quantity);
1432   }
1433 
1434   function flipSaleState() external onlyOwner {
1435     saleActive = !saleActive;
1436   }
1437   
1438   function reduceSupply(uint _newMax) external onlyOwner {
1439     require(_newMax < MAX_SUPPLY && _newMax > totalSupply(), "Invalid Supply");
1440     MAX_SUPPLY = _newMax;
1441   }
1442 
1443   function sendPayments() payable external onlyOwner nonReentrant {
1444     uint startingBal = address(this).balance;
1445     uint balanceDue;
1446 
1447     for(uint i=0; i < payees.length; i++) {
1448       balanceDue = startingBal * owed[i] / 100;
1449       (bool success, ) = payable(payees[i]).call{value: balanceDue}("");
1450       require(success, "Transfer failed.");
1451     }
1452   }
1453 
1454 }