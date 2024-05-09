1 // File: @openzeppelin/contracts/utils/Address.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
5 
6 pragma solidity ^0.8.1;
7 
8 /**
9  * @dev Collection of functions related to the address type
10  */
11 library Address {
12     /**
13      * @dev Returns true if `account` is a contract.
14      *
15      * [IMPORTANT]
16      * ====
17      * It is unsafe to assume that an address for which this function returns
18      * false is an externally-owned account (EOA) and not a contract.
19      *
20      * Among others, `isContract` will return false for the following
21      * types of addresses:
22      *
23      *  - an externally-owned account
24      *  - a contract in construction
25      *  - an address where a contract will be created
26      *  - an address where a contract lived, but was destroyed
27      * ====
28      *
29      * [IMPORTANT]
30      * ====
31      * You shouldn't rely on `isContract` to protect against flash loan attacks!
32      *
33      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
34      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
35      * constructor.
36      * ====
37      */
38     function isContract(address account) internal view returns (bool) {
39         // This method relies on extcodesize/address.code.length, which returns 0
40         // for contracts in construction, since the code is only stored at the end
41         // of the constructor execution.
42 
43         return account.code.length > 0;
44     }
45 
46     /**
47      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
48      * `recipient`, forwarding all available gas and reverting on errors.
49      *
50      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
51      * of certain opcodes, possibly making contracts go over the 2300 gas limit
52      * imposed by `transfer`, making them unable to receive funds via
53      * `transfer`. {sendValue} removes this limitation.
54      *
55      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
56      *
57      * IMPORTANT: because control is transferred to `recipient`, care must be
58      * taken to not create reentrancy vulnerabilities. Consider using
59      * {ReentrancyGuard} or the
60      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
61      */
62     function sendValue(address payable recipient, uint256 amount) internal {
63         require(address(this).balance >= amount, "Address: insufficient balance");
64 
65         (bool success, ) = recipient.call{value: amount}("");
66         require(success, "Address: unable to send value, recipient may have reverted");
67     }
68 
69     /**
70      * @dev Performs a Solidity function call using a low level `call`. A
71      * plain `call` is an unsafe replacement for a function call: use this
72      * function instead.
73      *
74      * If `target` reverts with a revert reason, it is bubbled up by this
75      * function (like regular Solidity function calls).
76      *
77      * Returns the raw returned data. To convert to the expected return value,
78      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
79      *
80      * Requirements:
81      *
82      * - `target` must be a contract.
83      * - calling `target` with `data` must not revert.
84      *
85      * _Available since v3.1._
86      */
87     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
88         return functionCall(target, data, "Address: low-level call failed");
89     }
90 
91     /**
92      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
93      * `errorMessage` as a fallback revert reason when `target` reverts.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(
98         address target,
99         bytes memory data,
100         string memory errorMessage
101     ) internal returns (bytes memory) {
102         return functionCallWithValue(target, data, 0, errorMessage);
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
107      * but also transferring `value` wei to `target`.
108      *
109      * Requirements:
110      *
111      * - the calling contract must have an ETH balance of at least `value`.
112      * - the called Solidity function must be `payable`.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(
117         address target,
118         bytes memory data,
119         uint256 value
120     ) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
126      * with `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value,
134         string memory errorMessage
135     ) internal returns (bytes memory) {
136         require(address(this).balance >= value, "Address: insufficient balance for call");
137         require(isContract(target), "Address: call to non-contract");
138 
139         (bool success, bytes memory returndata) = target.call{value: value}(data);
140         return verifyCallResult(success, returndata, errorMessage);
141     }
142 
143     /**
144      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
145      * but performing a static call.
146      *
147      * _Available since v3.3._
148      */
149     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
150         return functionStaticCall(target, data, "Address: low-level static call failed");
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
155      * but performing a static call.
156      *
157      * _Available since v3.3._
158      */
159     function functionStaticCall(
160         address target,
161         bytes memory data,
162         string memory errorMessage
163     ) internal view returns (bytes memory) {
164         require(isContract(target), "Address: static call to non-contract");
165 
166         (bool success, bytes memory returndata) = target.staticcall(data);
167         return verifyCallResult(success, returndata, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but performing a delegate call.
173      *
174      * _Available since v3.4._
175      */
176     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
177         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
182      * but performing a delegate call.
183      *
184      * _Available since v3.4._
185      */
186     function functionDelegateCall(
187         address target,
188         bytes memory data,
189         string memory errorMessage
190     ) internal returns (bytes memory) {
191         require(isContract(target), "Address: delegate call to non-contract");
192 
193         (bool success, bytes memory returndata) = target.delegatecall(data);
194         return verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     /**
198      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
199      * revert reason using the provided one.
200      *
201      * _Available since v4.3._
202      */
203     function verifyCallResult(
204         bool success,
205         bytes memory returndata,
206         string memory errorMessage
207     ) internal pure returns (bytes memory) {
208         if (success) {
209             return returndata;
210         } else {
211             // Look for revert reason and bubble it up if present
212             if (returndata.length > 0) {
213                 // The easiest way to bubble the revert reason is using memory via assembly
214 
215                 assembly {
216                     let returndata_size := mload(returndata)
217                     revert(add(32, returndata), returndata_size)
218                 }
219             } else {
220                 revert(errorMessage);
221             }
222         }
223     }
224 }
225 
226 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
227 
228 
229 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
230 
231 pragma solidity ^0.8.0;
232 
233 /**
234  * @title ERC721 token receiver interface
235  * @dev Interface for any contract that wants to support safeTransfers
236  * from ERC721 asset contracts.
237  */
238 interface IERC721Receiver {
239     /**
240      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
241      * by `operator` from `from`, this function is called.
242      *
243      * It must return its Solidity selector to confirm the token transfer.
244      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
245      *
246      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
247      */
248     function onERC721Received(
249         address operator,
250         address from,
251         uint256 tokenId,
252         bytes calldata data
253     ) external returns (bytes4);
254 }
255 
256 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
257 
258 
259 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
260 
261 pragma solidity ^0.8.0;
262 
263 /**
264  * @dev Interface of the ERC165 standard, as defined in the
265  * https://eips.ethereum.org/EIPS/eip-165[EIP].
266  *
267  * Implementers can declare support of contract interfaces, which can then be
268  * queried by others ({ERC165Checker}).
269  *
270  * For an implementation, see {ERC165}.
271  */
272 interface IERC165 {
273     /**
274      * @dev Returns true if this contract implements the interface defined by
275      * `interfaceId`. See the corresponding
276      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
277      * to learn more about how these ids are created.
278      *
279      * This function call must use less than 30 000 gas.
280      */
281     function supportsInterface(bytes4 interfaceId) external view returns (bool);
282 }
283 
284 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
285 
286 
287 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
288 
289 pragma solidity ^0.8.0;
290 
291 
292 /**
293  * @dev Implementation of the {IERC165} interface.
294  *
295  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
296  * for the additional interface id that will be supported. For example:
297  *
298  * ```solidity
299  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
300  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
301  * }
302  * ```
303  *
304  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
305  */
306 abstract contract ERC165 is IERC165 {
307     /**
308      * @dev See {IERC165-supportsInterface}.
309      */
310     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
311         return interfaceId == type(IERC165).interfaceId;
312     }
313 }
314 
315 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
316 
317 
318 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
319 
320 pragma solidity ^0.8.0;
321 
322 
323 /**
324  * @dev Required interface of an ERC721 compliant contract.
325  */
326 interface IERC721 is IERC165 {
327     /**
328      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
329      */
330     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
331 
332     /**
333      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
334      */
335     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
336 
337     /**
338      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
339      */
340     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
341 
342     /**
343      * @dev Returns the number of tokens in ``owner``'s account.
344      */
345     function balanceOf(address owner) external view returns (uint256 balance);
346 
347     /**
348      * @dev Returns the owner of the `tokenId` token.
349      *
350      * Requirements:
351      *
352      * - `tokenId` must exist.
353      */
354     function ownerOf(uint256 tokenId) external view returns (address owner);
355 
356     /**
357      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
358      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
359      *
360      * Requirements:
361      *
362      * - `from` cannot be the zero address.
363      * - `to` cannot be the zero address.
364      * - `tokenId` token must exist and be owned by `from`.
365      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
366      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
367      *
368      * Emits a {Transfer} event.
369      */
370     function safeTransferFrom(
371         address from,
372         address to,
373         uint256 tokenId
374     ) external;
375 
376     /**
377      * @dev Transfers `tokenId` token from `from` to `to`.
378      *
379      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
380      *
381      * Requirements:
382      *
383      * - `from` cannot be the zero address.
384      * - `to` cannot be the zero address.
385      * - `tokenId` token must be owned by `from`.
386      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
387      *
388      * Emits a {Transfer} event.
389      */
390     function transferFrom(
391         address from,
392         address to,
393         uint256 tokenId
394     ) external;
395 
396     /**
397      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
398      * The approval is cleared when the token is transferred.
399      *
400      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
401      *
402      * Requirements:
403      *
404      * - The caller must own the token or be an approved operator.
405      * - `tokenId` must exist.
406      *
407      * Emits an {Approval} event.
408      */
409     function approve(address to, uint256 tokenId) external;
410 
411     /**
412      * @dev Returns the account approved for `tokenId` token.
413      *
414      * Requirements:
415      *
416      * - `tokenId` must exist.
417      */
418     function getApproved(uint256 tokenId) external view returns (address operator);
419 
420     /**
421      * @dev Approve or remove `operator` as an operator for the caller.
422      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
423      *
424      * Requirements:
425      *
426      * - The `operator` cannot be the caller.
427      *
428      * Emits an {ApprovalForAll} event.
429      */
430     function setApprovalForAll(address operator, bool _approved) external;
431 
432     /**
433      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
434      *
435      * See {setApprovalForAll}
436      */
437     function isApprovedForAll(address owner, address operator) external view returns (bool);
438 
439     /**
440      * @dev Safely transfers `tokenId` token from `from` to `to`.
441      *
442      * Requirements:
443      *
444      * - `from` cannot be the zero address.
445      * - `to` cannot be the zero address.
446      * - `tokenId` token must exist and be owned by `from`.
447      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
448      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
449      *
450      * Emits a {Transfer} event.
451      */
452     function safeTransferFrom(
453         address from,
454         address to,
455         uint256 tokenId,
456         bytes calldata data
457     ) external;
458 }
459 
460 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
461 
462 
463 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
464 
465 pragma solidity ^0.8.0;
466 
467 
468 /**
469  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
470  * @dev See https://eips.ethereum.org/EIPS/eip-721
471  */
472 interface IERC721Enumerable is IERC721 {
473     /**
474      * @dev Returns the total amount of tokens stored by the contract.
475      */
476     function totalSupply() external view returns (uint256);
477 
478     /**
479      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
480      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
481      */
482     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
483 
484     /**
485      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
486      * Use along with {totalSupply} to enumerate all tokens.
487      */
488     function tokenByIndex(uint256 index) external view returns (uint256);
489 }
490 
491 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
492 
493 
494 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
495 
496 pragma solidity ^0.8.0;
497 
498 
499 /**
500  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
501  * @dev See https://eips.ethereum.org/EIPS/eip-721
502  */
503 interface IERC721Metadata is IERC721 {
504     /**
505      * @dev Returns the token collection name.
506      */
507     function name() external view returns (string memory);
508 
509     /**
510      * @dev Returns the token collection symbol.
511      */
512     function symbol() external view returns (string memory);
513 
514     /**
515      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
516      */
517     function tokenURI(uint256 tokenId) external view returns (string memory);
518 }
519 
520 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
521 
522 
523 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
524 
525 pragma solidity ^0.8.0;
526 
527 /**
528  * @dev Contract module that helps prevent reentrant calls to a function.
529  *
530  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
531  * available, which can be applied to functions to make sure there are no nested
532  * (reentrant) calls to them.
533  *
534  * Note that because there is a single `nonReentrant` guard, functions marked as
535  * `nonReentrant` may not call one another. This can be worked around by making
536  * those functions `private`, and then adding `external` `nonReentrant` entry
537  * points to them.
538  *
539  * TIP: If you would like to learn more about reentrancy and alternative ways
540  * to protect against it, check out our blog post
541  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
542  */
543 abstract contract ReentrancyGuard {
544     // Booleans are more expensive than uint256 or any type that takes up a full
545     // word because each write operation emits an extra SLOAD to first read the
546     // slot's contents, replace the bits taken up by the boolean, and then write
547     // back. This is the compiler's defense against contract upgrades and
548     // pointer aliasing, and it cannot be disabled.
549 
550     // The values being non-zero value makes deployment a bit more expensive,
551     // but in exchange the refund on every call to nonReentrant will be lower in
552     // amount. Since refunds are capped to a percentage of the total
553     // transaction's gas, it is best to keep them low in cases like this one, to
554     // increase the likelihood of the full refund coming into effect.
555     uint256 private constant _NOT_ENTERED = 1;
556     uint256 private constant _ENTERED = 2;
557 
558     uint256 private _status;
559 
560     constructor() {
561         _status = _NOT_ENTERED;
562     }
563 
564     /**
565      * @dev Prevents a contract from calling itself, directly or indirectly.
566      * Calling a `nonReentrant` function from another `nonReentrant`
567      * function is not supported. It is possible to prevent this from happening
568      * by making the `nonReentrant` function external, and making it call a
569      * `private` function that does the actual work.
570      */
571     modifier nonReentrant() {
572         // On the first call to nonReentrant, _notEntered will be true
573         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
574 
575         // Any calls to nonReentrant after this point will fail
576         _status = _ENTERED;
577 
578         _;
579 
580         // By storing the original value once again, a refund is triggered (see
581         // https://eips.ethereum.org/EIPS/eip-2200)
582         _status = _NOT_ENTERED;
583     }
584 }
585 
586 // File: @openzeppelin/contracts/utils/Strings.sol
587 
588 
589 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
590 
591 pragma solidity ^0.8.0;
592 
593 /**
594  * @dev String operations.
595  */
596 library Strings {
597     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
598 
599     /**
600      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
601      */
602     function toString(uint256 value) internal pure returns (string memory) {
603         // Inspired by OraclizeAPI's implementation - MIT licence
604         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
605 
606         if (value == 0) {
607             return "0";
608         }
609         uint256 temp = value;
610         uint256 digits;
611         while (temp != 0) {
612             digits++;
613             temp /= 10;
614         }
615         bytes memory buffer = new bytes(digits);
616         while (value != 0) {
617             digits -= 1;
618             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
619             value /= 10;
620         }
621         return string(buffer);
622     }
623 
624     /**
625      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
626      */
627     function toHexString(uint256 value) internal pure returns (string memory) {
628         if (value == 0) {
629             return "0x00";
630         }
631         uint256 temp = value;
632         uint256 length = 0;
633         while (temp != 0) {
634             length++;
635             temp >>= 8;
636         }
637         return toHexString(value, length);
638     }
639 
640     /**
641      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
642      */
643     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
644         bytes memory buffer = new bytes(2 * length + 2);
645         buffer[0] = "0";
646         buffer[1] = "x";
647         for (uint256 i = 2 * length + 1; i > 1; --i) {
648             buffer[i] = _HEX_SYMBOLS[value & 0xf];
649             value >>= 4;
650         }
651         require(value == 0, "Strings: hex length insufficient");
652         return string(buffer);
653     }
654 }
655 
656 // File: @openzeppelin/contracts/utils/Context.sol
657 
658 
659 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
660 
661 pragma solidity ^0.8.0;
662 
663 /**
664  * @dev Provides information about the current execution context, including the
665  * sender of the transaction and its data. While these are generally available
666  * via msg.sender and msg.data, they should not be accessed in such a direct
667  * manner, since when dealing with meta-transactions the account sending and
668  * paying for execution may not be the actual sender (as far as an application
669  * is concerned).
670  *
671  * This contract is only required for intermediate, library-like contracts.
672  */
673 abstract contract Context {
674     function _msgSender() internal view virtual returns (address) {
675         return msg.sender;
676     }
677 
678     function _msgData() internal view virtual returns (bytes calldata) {
679         return msg.data;
680     }
681 }
682 
683 // File: https://github.com/chiru-labs/ERC721A/blob/v2.2.0/contracts/ERC721A.sol
684 
685 
686 // Creator: Chiru Labs
687 
688 pragma solidity ^0.8.4;
689 
690 
691 
692 
693 
694 
695 
696 
697 
698 error ApprovalCallerNotOwnerNorApproved();
699 error ApprovalQueryForNonexistentToken();
700 error ApproveToCaller();
701 error ApprovalToCurrentOwner();
702 error BalanceQueryForZeroAddress();
703 error MintedQueryForZeroAddress();
704 error BurnedQueryForZeroAddress();
705 error MintToZeroAddress();
706 error MintZeroQuantity();
707 error OwnerIndexOutOfBounds();
708 error OwnerQueryForNonexistentToken();
709 error TokenIndexOutOfBounds();
710 error TransferCallerNotOwnerNorApproved();
711 error TransferFromIncorrectOwner();
712 error TransferToNonERC721ReceiverImplementer();
713 error TransferToZeroAddress();
714 error URIQueryForNonexistentToken();
715 
716 /**
717  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
718  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
719  *
720  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
721  *
722  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
723  *
724  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
725  */
726 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
727     using Address for address;
728     using Strings for uint256;
729 
730     // Compiler will pack this into a single 256bit word.
731     struct TokenOwnership {
732         // The address of the owner.
733         address addr;
734         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
735         uint64 startTimestamp;
736         // Whether the token has been burned.
737         bool burned;
738     }
739 
740     // Compiler will pack this into a single 256bit word.
741     struct AddressData {
742         // Realistically, 2**64-1 is more than enough.
743         uint64 balance;
744         // Keeps track of mint count with minimal overhead for tokenomics.
745         uint64 numberMinted;
746         // Keeps track of burn count with minimal overhead for tokenomics.
747         uint64 numberBurned;
748     }
749 
750     // Compiler will pack the following 
751     // _currentIndex and _burnCounter into a single 256bit word.
752     
753     // The tokenId of the next token to be minted.
754     uint128 internal _currentIndex;
755 
756     // The number of tokens burned.
757     uint128 internal _burnCounter;
758 
759     // Token name
760     string private _name;
761 
762     // Token symbol
763     string private _symbol;
764 
765     // Mapping from token ID to ownership details
766     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
767     mapping(uint256 => TokenOwnership) internal _ownerships;
768 
769     // Mapping owner address to address data
770     mapping(address => AddressData) private _addressData;
771 
772     // Mapping from token ID to approved address
773     mapping(uint256 => address) private _tokenApprovals;
774 
775     // Mapping from owner to operator approvals
776     mapping(address => mapping(address => bool)) private _operatorApprovals;
777 
778     constructor(string memory name_, string memory symbol_) {
779         _name = name_;
780         _symbol = symbol_;
781     }
782 
783     /**
784      * @dev See {IERC721Enumerable-totalSupply}.
785      */
786     function totalSupply() public view override returns (uint256) {
787         // Counter underflow is impossible as _burnCounter cannot be incremented
788         // more than _currentIndex times
789         unchecked {
790             return _currentIndex - _burnCounter;    
791         }
792     }
793 
794     /**
795      * @dev See {IERC721Enumerable-tokenByIndex}.
796      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
797      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
798      */
799     function tokenByIndex(uint256 index) public view override returns (uint256) {
800         uint256 numMintedSoFar = _currentIndex;
801         uint256 tokenIdsIdx;
802 
803         // Counter overflow is impossible as the loop breaks when
804         // uint256 i is equal to another uint256 numMintedSoFar.
805         unchecked {
806             for (uint256 i; i < numMintedSoFar; i++) {
807                 TokenOwnership memory ownership = _ownerships[i];
808                 if (!ownership.burned) {
809                     if (tokenIdsIdx == index) {
810                         return i;
811                     }
812                     tokenIdsIdx++;
813                 }
814             }
815         }
816         revert TokenIndexOutOfBounds();
817     }
818 
819     /**
820      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
821      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
822      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
823      */
824     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
825         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
826         uint256 numMintedSoFar = _currentIndex;
827         uint256 tokenIdsIdx;
828         address currOwnershipAddr;
829 
830         // Counter overflow is impossible as the loop breaks when
831         // uint256 i is equal to another uint256 numMintedSoFar.
832         unchecked {
833             for (uint256 i; i < numMintedSoFar; i++) {
834                 TokenOwnership memory ownership = _ownerships[i];
835                 if (ownership.burned) {
836                     continue;
837                 }
838                 if (ownership.addr != address(0)) {
839                     currOwnershipAddr = ownership.addr;
840                 }
841                 if (currOwnershipAddr == owner) {
842                     if (tokenIdsIdx == index) {
843                         return i;
844                     }
845                     tokenIdsIdx++;
846                 }
847             }
848         }
849 
850         // Execution should never reach this point.
851         revert();
852     }
853 
854     /**
855      * @dev See {IERC165-supportsInterface}.
856      */
857     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
858         return
859             interfaceId == type(IERC721).interfaceId ||
860             interfaceId == type(IERC721Metadata).interfaceId ||
861             interfaceId == type(IERC721Enumerable).interfaceId ||
862             super.supportsInterface(interfaceId);
863     }
864 
865     /**
866      * @dev See {IERC721-balanceOf}.
867      */
868     function balanceOf(address owner) public view override returns (uint256) {
869         if (owner == address(0)) revert BalanceQueryForZeroAddress();
870         return uint256(_addressData[owner].balance);
871     }
872 
873     function _numberMinted(address owner) internal view returns (uint256) {
874         if (owner == address(0)) revert MintedQueryForZeroAddress();
875         return uint256(_addressData[owner].numberMinted);
876     }
877 
878     function _numberBurned(address owner) internal view returns (uint256) {
879         if (owner == address(0)) revert BurnedQueryForZeroAddress();
880         return uint256(_addressData[owner].numberBurned);
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
891             if (curr < _currentIndex) {
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
914     /**
915      * @dev See {IERC721-ownerOf}.
916      */
917     function ownerOf(uint256 tokenId) public view override returns (address) {
918         return ownershipOf(tokenId).addr;
919     }
920 
921     /**
922      * @dev See {IERC721Metadata-name}.
923      */
924     function name() public view virtual override returns (string memory) {
925         return _name;
926     }
927 
928     /**
929      * @dev See {IERC721Metadata-symbol}.
930      */
931     function symbol() public view virtual override returns (string memory) {
932         return _symbol;
933     }
934 
935     /**
936      * @dev See {IERC721Metadata-tokenURI}.
937      */
938     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
939         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
940 
941         string memory baseURI = _baseURI();
942         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
943     }
944 
945     /**
946      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
947      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
948      * by default, can be overriden in child contracts.
949      */
950     function _baseURI() internal view virtual returns (string memory) {
951         return '';
952     }
953 
954     /**
955      * @dev See {IERC721-approve}.
956      */
957     function approve(address to, uint256 tokenId) public override {
958         address owner = ERC721A.ownerOf(tokenId);
959         if (to == owner) revert ApprovalToCurrentOwner();
960 
961         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
962             revert ApprovalCallerNotOwnerNorApproved();
963         }
964 
965         _approve(to, tokenId, owner);
966     }
967 
968     /**
969      * @dev See {IERC721-getApproved}.
970      */
971     function getApproved(uint256 tokenId) public view override returns (address) {
972         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
973 
974         return _tokenApprovals[tokenId];
975     }
976 
977     /**
978      * @dev See {IERC721-setApprovalForAll}.
979      */
980     function setApprovalForAll(address operator, bool approved) public override {
981         if (operator == _msgSender()) revert ApproveToCaller();
982 
983         _operatorApprovals[_msgSender()][operator] = approved;
984         emit ApprovalForAll(_msgSender(), operator, approved);
985     }
986 
987     /**
988      * @dev See {IERC721-isApprovedForAll}.
989      */
990     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
991         return _operatorApprovals[owner][operator];
992     }
993 
994     /**
995      * @dev See {IERC721-transferFrom}.
996      */
997     function transferFrom(
998         address from,
999         address to,
1000         uint256 tokenId
1001     ) public virtual override {
1002         _transfer(from, to, tokenId);
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-safeTransferFrom}.
1007      */
1008     function safeTransferFrom(
1009         address from,
1010         address to,
1011         uint256 tokenId
1012     ) public virtual override {
1013         safeTransferFrom(from, to, tokenId, '');
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-safeTransferFrom}.
1018      */
1019     function safeTransferFrom(
1020         address from,
1021         address to,
1022         uint256 tokenId,
1023         bytes memory _data
1024     ) public virtual override {
1025         _transfer(from, to, tokenId);
1026         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1027             revert TransferToNonERC721ReceiverImplementer();
1028         }
1029     }
1030 
1031     /**
1032      * @dev Returns whether `tokenId` exists.
1033      *
1034      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1035      *
1036      * Tokens start existing when they are minted (`_mint`),
1037      */
1038     function _exists(uint256 tokenId) internal view returns (bool) {
1039         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1040     }
1041 
1042     function _safeMint(address to, uint256 quantity) internal {
1043         _safeMint(to, quantity, '');
1044     }
1045 
1046     /**
1047      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1048      *
1049      * Requirements:
1050      *
1051      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1052      * - `quantity` must be greater than 0.
1053      *
1054      * Emits a {Transfer} event.
1055      */
1056     function _safeMint(
1057         address to,
1058         uint256 quantity,
1059         bytes memory _data
1060     ) internal {
1061         _mint(to, quantity, _data, true);
1062     }
1063 
1064     /**
1065      * @dev Mints `quantity` tokens and transfers them to `to`.
1066      *
1067      * Requirements:
1068      *
1069      * - `to` cannot be the zero address.
1070      * - `quantity` must be greater than 0.
1071      *
1072      * Emits a {Transfer} event.
1073      */
1074     function _mint(
1075         address to,
1076         uint256 quantity,
1077         bytes memory _data,
1078         bool safe
1079     ) internal {
1080         uint256 startTokenId = _currentIndex;
1081         if (to == address(0)) revert MintToZeroAddress();
1082         if (quantity == 0) revert MintZeroQuantity();
1083 
1084         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1085 
1086         // Overflows are incredibly unrealistic.
1087         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1088         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
1089         unchecked {
1090             _addressData[to].balance += uint64(quantity);
1091             _addressData[to].numberMinted += uint64(quantity);
1092 
1093             _ownerships[startTokenId].addr = to;
1094             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1095 
1096             uint256 updatedIndex = startTokenId;
1097 
1098             for (uint256 i; i < quantity; i++) {
1099                 emit Transfer(address(0), to, updatedIndex);
1100                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1101                     revert TransferToNonERC721ReceiverImplementer();
1102                 }
1103                 updatedIndex++;
1104             }
1105 
1106             _currentIndex = uint128(updatedIndex);
1107         }
1108         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1109     }
1110 
1111     /**
1112      * @dev Transfers `tokenId` from `from` to `to`.
1113      *
1114      * Requirements:
1115      *
1116      * - `to` cannot be the zero address.
1117      * - `tokenId` token must be owned by `from`.
1118      *
1119      * Emits a {Transfer} event.
1120      */
1121     function _transfer(
1122         address from,
1123         address to,
1124         uint256 tokenId
1125     ) private {
1126         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1127 
1128         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1129             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1130             getApproved(tokenId) == _msgSender());
1131 
1132         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1133         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1134         if (to == address(0)) revert TransferToZeroAddress();
1135 
1136         _beforeTokenTransfers(from, to, tokenId, 1);
1137 
1138         // Clear approvals from the previous owner
1139         _approve(address(0), tokenId, prevOwnership.addr);
1140 
1141         // Underflow of the sender's balance is impossible because we check for
1142         // ownership above and the recipient's balance can't realistically overflow.
1143         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1144         unchecked {
1145             _addressData[from].balance -= 1;
1146             _addressData[to].balance += 1;
1147 
1148             _ownerships[tokenId].addr = to;
1149             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1150 
1151             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1152             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1153             uint256 nextTokenId = tokenId + 1;
1154             if (_ownerships[nextTokenId].addr == address(0)) {
1155                 // This will suffice for checking _exists(nextTokenId),
1156                 // as a burned slot cannot contain the zero address.
1157                 if (nextTokenId < _currentIndex) {
1158                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1159                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1160                 }
1161             }
1162         }
1163 
1164         emit Transfer(from, to, tokenId);
1165         _afterTokenTransfers(from, to, tokenId, 1);
1166     }
1167 
1168     /**
1169      * @dev Destroys `tokenId`.
1170      * The approval is cleared when the token is burned.
1171      *
1172      * Requirements:
1173      *
1174      * - `tokenId` must exist.
1175      *
1176      * Emits a {Transfer} event.
1177      */
1178     function _burn(uint256 tokenId) internal virtual {
1179         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1180 
1181         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1182 
1183         // Clear approvals from the previous owner
1184         _approve(address(0), tokenId, prevOwnership.addr);
1185 
1186         // Underflow of the sender's balance is impossible because we check for
1187         // ownership above and the recipient's balance can't realistically overflow.
1188         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1189         unchecked {
1190             _addressData[prevOwnership.addr].balance -= 1;
1191             _addressData[prevOwnership.addr].numberBurned += 1;
1192 
1193             // Keep track of who burned the token, and the timestamp of burning.
1194             _ownerships[tokenId].addr = prevOwnership.addr;
1195             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1196             _ownerships[tokenId].burned = true;
1197 
1198             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1199             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1200             uint256 nextTokenId = tokenId + 1;
1201             if (_ownerships[nextTokenId].addr == address(0)) {
1202                 // This will suffice for checking _exists(nextTokenId),
1203                 // as a burned slot cannot contain the zero address.
1204                 if (nextTokenId < _currentIndex) {
1205                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1206                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1207                 }
1208             }
1209         }
1210 
1211         emit Transfer(prevOwnership.addr, address(0), tokenId);
1212         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1213 
1214         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1215         unchecked { 
1216             _burnCounter++;
1217         }
1218     }
1219 
1220     /**
1221      * @dev Approve `to` to operate on `tokenId`
1222      *
1223      * Emits a {Approval} event.
1224      */
1225     function _approve(
1226         address to,
1227         uint256 tokenId,
1228         address owner
1229     ) private {
1230         _tokenApprovals[tokenId] = to;
1231         emit Approval(owner, to, tokenId);
1232     }
1233 
1234     /**
1235      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1236      * The call is not executed if the target address is not a contract.
1237      *
1238      * @param from address representing the previous owner of the given token ID
1239      * @param to target address that will receive the tokens
1240      * @param tokenId uint256 ID of the token to be transferred
1241      * @param _data bytes optional data to send along with the call
1242      * @return bool whether the call correctly returned the expected magic value
1243      */
1244     function _checkOnERC721Received(
1245         address from,
1246         address to,
1247         uint256 tokenId,
1248         bytes memory _data
1249     ) private returns (bool) {
1250         if (to.isContract()) {
1251             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1252                 return retval == IERC721Receiver(to).onERC721Received.selector;
1253             } catch (bytes memory reason) {
1254                 if (reason.length == 0) {
1255                     revert TransferToNonERC721ReceiverImplementer();
1256                 } else {
1257                     assembly {
1258                         revert(add(32, reason), mload(reason))
1259                     }
1260                 }
1261             }
1262         } else {
1263             return true;
1264         }
1265     }
1266 
1267     /**
1268      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1269      * And also called before burning one token.
1270      *
1271      * startTokenId - the first token id to be transferred
1272      * quantity - the amount to be transferred
1273      *
1274      * Calling conditions:
1275      *
1276      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1277      * transferred to `to`.
1278      * - When `from` is zero, `tokenId` will be minted for `to`.
1279      * - When `to` is zero, `tokenId` will be burned by `from`.
1280      * - `from` and `to` are never both zero.
1281      */
1282     function _beforeTokenTransfers(
1283         address from,
1284         address to,
1285         uint256 startTokenId,
1286         uint256 quantity
1287     ) internal virtual {}
1288 
1289     /**
1290      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1291      * minting.
1292      * And also called after one token has been burned.
1293      *
1294      * startTokenId - the first token id to be transferred
1295      * quantity - the amount to be transferred
1296      *
1297      * Calling conditions:
1298      *
1299      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1300      * transferred to `to`.
1301      * - When `from` is zero, `tokenId` has been minted for `to`.
1302      * - When `to` is zero, `tokenId` has been burned by `from`.
1303      * - `from` and `to` are never both zero.
1304      */
1305     function _afterTokenTransfers(
1306         address from,
1307         address to,
1308         uint256 startTokenId,
1309         uint256 quantity
1310     ) internal virtual {}
1311 }
1312 
1313 // File: @openzeppelin/contracts/access/Ownable.sol
1314 
1315 
1316 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1317 
1318 pragma solidity ^0.8.0;
1319 
1320 
1321 /**
1322  * @dev Contract module which provides a basic access control mechanism, where
1323  * there is an account (an owner) that can be granted exclusive access to
1324  * specific functions.
1325  *
1326  * By default, the owner account will be the one that deploys the contract. This
1327  * can later be changed with {transferOwnership}.
1328  *
1329  * This module is used through inheritance. It will make available the modifier
1330  * `onlyOwner`, which can be applied to your functions to restrict their use to
1331  * the owner.
1332  */
1333 abstract contract Ownable is Context {
1334     address private _owner;
1335 
1336     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1337 
1338     /**
1339      * @dev Initializes the contract setting the deployer as the initial owner.
1340      */
1341     constructor() {
1342         _transferOwnership(_msgSender());
1343     }
1344 
1345     /**
1346      * @dev Returns the address of the current owner.
1347      */
1348     function owner() public view virtual returns (address) {
1349         return _owner;
1350     }
1351 
1352     /**
1353      * @dev Throws if called by any account other than the owner.
1354      */
1355     modifier onlyOwner() {
1356         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1357         _;
1358     }
1359 
1360     /**
1361      * @dev Leaves the contract without owner. It will not be possible to call
1362      * `onlyOwner` functions anymore. Can only be called by the current owner.
1363      *
1364      * NOTE: Renouncing ownership will leave the contract without an owner,
1365      * thereby removing any functionality that is only available to the owner.
1366      */
1367     function renounceOwnership() public virtual onlyOwner {
1368         _transferOwnership(address(0));
1369     }
1370 
1371     /**
1372      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1373      * Can only be called by the current owner.
1374      */
1375     function transferOwnership(address newOwner) public virtual onlyOwner {
1376         require(newOwner != address(0), "Ownable: new owner is the zero address");
1377         _transferOwnership(newOwner);
1378     }
1379 
1380     /**
1381      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1382      * Internal function without access restriction.
1383      */
1384     function _transferOwnership(address newOwner) internal virtual {
1385         address oldOwner = _owner;
1386         _owner = newOwner;
1387         emit OwnershipTransferred(oldOwner, newOwner);
1388     }
1389 }
1390 
1391 // File: SeshWorld.sol
1392 
1393 
1394 pragma solidity ^0.8.12;
1395 
1396 
1397 
1398 
1399 
1400 contract SeshWorld is ERC721A, Ownable, ReentrancyGuard {
1401     using Strings for uint256;
1402 
1403     string internal _baseTokenURI;
1404     string internal _unrevealedURI;
1405     string internal _lockedURIHeaven;
1406     string internal _lockedURIHell;
1407 
1408     uint256 internal reserved;
1409 
1410     bool public revealed;
1411     bool public saleActive;
1412 
1413     mapping(uint256 => uint256) public tokenLevels;
1414     mapping(uint256 => bool) public isLocked;
1415 
1416     uint256 public mintPrice = 0.05 ether;
1417 
1418     uint256 public constant MAX_LEVEL = 2;
1419     uint256 public constant MAX_TOTAL_SUPPLY = 10_000;
1420     uint256 public constant MAX_AMOUNT_PER_MINT = 100;
1421     uint256 public constant MAX_RESERVED_AMOUNT = 50;
1422 
1423     constructor(
1424         string memory unrevealedURI,
1425         string memory lockedURIHeaven,
1426         string memory lockedURIHell
1427     ) ERC721A("SeshWorld", "SESH") {
1428         _unrevealedURI = unrevealedURI;
1429         _lockedURIHeaven = lockedURIHeaven;
1430         _lockedURIHell = lockedURIHell;
1431     }
1432 
1433     // MODIFIERS
1434 
1435     modifier onlyTokenOwner(uint256 tokenId) {
1436         require(msg.sender == ownerOf(tokenId), "Sender is not the token owner");
1437         _;
1438     }
1439 
1440     // URI FUNCTIONS
1441 
1442     function _baseURI() internal view virtual override returns (string memory) {
1443         return _baseTokenURI;
1444     }
1445 
1446     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1447         if (!revealed) {
1448             return _unrevealedURI;
1449         }
1450 
1451         if (isLocked[tokenId]) {
1452             if (tokenId % 2 == 0) {
1453                 return _lockedURIHeaven;
1454             } else {
1455                 return _lockedURIHell;
1456             }
1457         }
1458 
1459         string memory baseURI = _baseURI();
1460         uint256 level = tokenLevels[tokenId];
1461         return string(abi.encodePacked(baseURI, tokenId.toString(), "-", level.toString()));
1462     }
1463 
1464     // OWNER FUNCTIONS
1465 
1466     function setBaseURI(string calldata baseURI) external onlyOwner {
1467         _baseTokenURI = baseURI;
1468     }
1469 
1470     function setUnrevealedURI(string calldata unrevealedURI) external onlyOwner {
1471         _unrevealedURI = unrevealedURI;
1472     }
1473 
1474     function setLockedURIHeaven(string calldata lockedURIHeaven) external onlyOwner {
1475         _lockedURIHeaven = lockedURIHeaven;
1476     }
1477 
1478     function setLockedURIHell(string calldata lockedURIHell) external onlyOwner {
1479         _lockedURIHell = lockedURIHell;
1480     }
1481 
1482     function setMintPrice(uint256 price) public onlyOwner {
1483         mintPrice = price;
1484     }
1485 
1486     function flipSaleStatus() public onlyOwner {
1487         // kev was here
1488         saleActive = !saleActive;
1489     }
1490 
1491     function flipReveal() public onlyOwner {
1492         revealed = !revealed;
1493     }
1494 
1495     function flipLockStatus(uint256 tokenId) public onlyOwner {
1496         isLocked[tokenId] = !isLocked[tokenId];
1497     }
1498 
1499     function withdraw() external onlyOwner nonReentrant {
1500         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1501         require(success, "Withdraw failed");
1502     }
1503 
1504     // MINTING FUNCTIONS
1505 
1506     function mint(uint256 amount) external payable {
1507         require(saleActive, "Public sale not active");
1508         require(msg.value == amount * mintPrice, "Not enough ETH sent");
1509         require(amount <= MAX_AMOUNT_PER_MINT, "Minting too many at a time");
1510         require(amount + totalSupply() <= MAX_TOTAL_SUPPLY, "Would exceed max supply");
1511 
1512         _mint(msg.sender, amount, "", false);
1513     }
1514 
1515     // reserves 'amount' NFTs minted direct to a specified wallet
1516     function reserve(address to, uint256 amount) external onlyOwner {
1517         require(amount + totalSupply() <= MAX_TOTAL_SUPPLY, "Would exceed max supply");
1518         require(reserved + amount <= MAX_RESERVED_AMOUNT, "Would exceed max reserved amount");
1519 
1520         _mint(to, amount, "", false);
1521         reserved += amount;
1522     }
1523 
1524     // UPDATE FUNCTIONS
1525 
1526     function plunge(uint256 tokenId) public onlyTokenOwner(tokenId) {
1527         require(!isLocked[tokenId], "Gator is dead");
1528 
1529         uint256 currentLevel = tokenLevels[tokenId];
1530         require(currentLevel < MAX_LEVEL, "Gator already max level");
1531 
1532         uint256 pseudoRandomNumber = _genPseudoRandomNumber(tokenId);
1533 
1534         if (currentLevel == 0) {
1535             // first upgrade, 90% chance of success
1536             if (pseudoRandomNumber < 9) {
1537                 tokenLevels[tokenId] += 1;
1538             } else {
1539                 tokenLevels[tokenId] = 0;
1540                 isLocked[tokenId] = true;
1541             }
1542         } else {
1543             // second upgrade, 30% chance of success
1544             if (pseudoRandomNumber < 3) {
1545                 tokenLevels[tokenId] += 1;
1546             } else {
1547                 tokenLevels[tokenId] = 0;
1548                 isLocked[tokenId] = true;
1549             }
1550         }
1551     }
1552 
1553     // VIEW FUNCTIONS
1554 
1555     function walletOfOwner(address wallet) public view returns (uint256[] memory) {
1556         uint256 tokenCount = balanceOf(wallet);
1557         uint256[] memory tokenIds = new uint256[](tokenCount);
1558         for (uint256 i; i < tokenCount; i++) {
1559             tokenIds[i] = tokenOfOwnerByIndex(wallet, i);
1560         }
1561         return tokenIds;
1562     }
1563 
1564     function _genPseudoRandomNumber(uint256 tokenId) private view returns (uint256) {
1565         // you coward
1566         uint256 pseudoRandomHash = uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, tokenId)));
1567         return pseudoRandomHash % 10;
1568     }
1569 }