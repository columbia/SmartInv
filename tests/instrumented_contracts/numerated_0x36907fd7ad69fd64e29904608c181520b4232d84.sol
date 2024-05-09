1 //  /$$$$$$$  /$$$$$$$  /$$   /$$
2 // | $$__  $$| $$__  $$| $$  | $$
3 // | $$  \ $$| $$  \ $$| $$  | $$
4 // | $$$$$$$/| $$  | $$| $$$$$$$$
5 // | $$__  $$| $$  | $$| $$__  $$
6 // | $$  \ $$| $$  | $$| $$  | $$
7 // | $$  | $$| $$$$$$$/| $$  | $$
8 // |__/  |__/|_______/ |__/  |__/
9 
10 
11 // SPDX-License-Identifier: MIT
12 
13 pragma solidity ^0.8.0;
14 
15 /**
16  * @dev String operations.
17  */
18 library Strings {
19     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
20 
21     /**
22      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
23      */
24     function toString(uint256 value) internal pure returns (string memory) {
25         // Inspired by OraclizeAPI's implementation - MIT licence
26         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
27 
28         if (value == 0) {
29             return "0";
30         }
31         uint256 temp = value;
32         uint256 digits;
33         while (temp != 0) {
34             digits++;
35             temp /= 10;
36         }
37         bytes memory buffer = new bytes(digits);
38         while (value != 0) {
39             digits -= 1;
40             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
41             value /= 10;
42         }
43         return string(buffer);
44     }
45 
46     /**
47      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
48      */
49     function toHexString(uint256 value) internal pure returns (string memory) {
50         if (value == 0) {
51             return "0x00";
52         }
53         uint256 temp = value;
54         uint256 length = 0;
55         while (temp != 0) {
56             length++;
57             temp >>= 8;
58         }
59         return toHexString(value, length);
60     }
61 
62     /**
63      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
64      */
65     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
66         bytes memory buffer = new bytes(2 * length + 2);
67         buffer[0] = "0";
68         buffer[1] = "x";
69         for (uint256 i = 2 * length + 1; i > 1; --i) {
70             buffer[i] = _HEX_SYMBOLS[value & 0xf];
71             value >>= 4;
72         }
73         require(value == 0, "Strings: hex length insufficient");
74         return string(buffer);
75     }
76 }
77 
78 
79 // File: Context.sol
80 
81 
82 
83 pragma solidity ^0.8.0;
84 
85 /**
86  * @dev Provides information about the current execution context, including the
87  * sender of the transaction and its data. While these are generally available
88  * via msg.sender and msg.data, they should not be accessed in such a direct
89  * manner, since when dealing with meta-transactions the account sending and
90  * paying for execution may not be the actual sender (as far as an application
91  * is concerned).
92  *
93  * This contract is only required for intermediate, library-like contracts.
94  */
95 abstract contract Context {
96     function _msgSender() internal view virtual returns (address) {
97         return msg.sender;
98     }
99 
100     function _msgData() internal view virtual returns (bytes calldata) {
101         return msg.data;
102     }
103 }
104 
105 
106 // File: Ownable.sol
107 
108 
109 
110 pragma solidity ^0.8.0;
111 
112 
113 /**
114  * @dev Contract module which provides a basic access control mechanism, where
115  * there is an account (an owner) that can be granted exclusive access to
116  * specific functions.
117  *
118  * By default, the owner account will be the one that deploys the contract. This
119  * can later be changed with {transferOwnership}.
120  *
121  * This module is used through inheritance. It will make available the modifier
122  * `onlyOwner`, which can be applied to your functions to restrict their use to
123  * the owner.
124  */
125 abstract contract Ownable is Context {
126     address private _owner;
127 
128     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
129 
130     /**
131      * @dev Initializes the contract setting the deployer as the initial owner.
132      */
133     constructor() {
134         _setOwner(_msgSender());
135     }
136 
137     /**
138      * @dev Returns the address of the current owner.
139      */
140     function owner() public view virtual returns (address) {
141         return _owner;
142     }
143 
144     /**
145      * @dev Throws if called by any account other than the owner.
146      */
147     modifier onlyOwner() {
148         require(owner() == _msgSender(), "Ownable: caller is not the owner");
149         _;
150     }
151 
152     /**
153      * @dev Leaves the contract without owner. It will not be possible to call
154      * `onlyOwner` functions anymore. Can only be called by the current owner.
155      *
156      * NOTE: Renouncing ownership will leave the contract without an owner,
157      * thereby removing any functionality that is only available to the owner.
158      */
159     function renounceOwnership() public virtual onlyOwner {
160         _setOwner(address(0));
161     }
162 
163     /**
164      * @dev Transfers ownership of the contract to a new account (`newOwner`).
165      * Can only be called by the current owner.
166      */
167     function transferOwnership(address newOwner) public virtual onlyOwner {
168         require(newOwner != address(0), "Ownable: new owner is the zero address");
169         _setOwner(newOwner);
170     }
171 
172     function _setOwner(address newOwner) private {
173         address oldOwner = _owner;
174         _owner = newOwner;
175         emit OwnershipTransferred(oldOwner, newOwner);
176     }
177 }
178 
179 
180 // File: Address.sol
181 
182 
183 
184 pragma solidity ^0.8.0;
185 
186 /**
187  * @dev Collection of functions related to the address type
188  */
189 library Address {
190     /**
191      * @dev Returns true if `account` is a contract.
192      *
193      * [IMPORTANT]
194      * ====
195      * It is unsafe to assume that an address for which this function returns
196      * false is an externally-owned account (EOA) and not a contract.
197      *
198      * Among others, `isContract` will return false for the following
199      * types of addresses:
200      *
201      *  - an externally-owned account
202      *  - a contract in construction
203      *  - an address where a contract will be created
204      *  - an address where a contract lived, but was destroyed
205      * ====
206      */
207     function isContract(address account) internal view returns (bool) {
208         // This method relies on extcodesize, which returns 0 for contracts in
209         // construction, since the code is only stored at the end of the
210         // constructor execution.
211 
212         uint256 size;
213         assembly {
214             size := extcodesize(account)
215         }
216         return size > 0;
217     }
218 
219     /**
220      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
221      * `recipient`, forwarding all available gas and reverting on errors.
222      *
223      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
224      * of certain opcodes, possibly making contracts go over the 2300 gas limit
225      * imposed by `transfer`, making them unable to receive funds via
226      * `transfer`. {sendValue} removes this limitation.
227      *
228      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
229      *
230      * IMPORTANT: because control is transferred to `recipient`, care must be
231      * taken to not create reentrancy vulnerabilities. Consider using
232      * {ReentrancyGuard} or the
233      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
234      */
235     function sendValue(address payable recipient, uint256 amount) internal {
236         require(address(this).balance >= amount, "Address: insufficient balance");
237 
238         (bool success, ) = recipient.call{value: amount}("");
239         require(success, "Address: unable to send value, recipient may have reverted");
240     }
241 
242     /**
243      * @dev Performs a Solidity function call using a low level `call`. A
244      * plain `call` is an unsafe replacement for a function call: use this
245      * function instead.
246      *
247      * If `target` reverts with a revert reason, it is bubbled up by this
248      * function (like regular Solidity function calls).
249      *
250      * Returns the raw returned data. To convert to the expected return value,
251      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
252      *
253      * Requirements:
254      *
255      * - `target` must be a contract.
256      * - calling `target` with `data` must not revert.
257      *
258      * _Available since v3.1._
259      */
260     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
261         return functionCall(target, data, "Address: low-level call failed");
262     }
263 
264     /**
265      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
266      * `errorMessage` as a fallback revert reason when `target` reverts.
267      *
268      * _Available since v3.1._
269      */
270     function functionCall(
271         address target,
272         bytes memory data,
273         string memory errorMessage
274     ) internal returns (bytes memory) {
275         return functionCallWithValue(target, data, 0, errorMessage);
276     }
277 
278     /**
279      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
280      * but also transferring `value` wei to `target`.
281      *
282      * Requirements:
283      *
284      * - the calling contract must have an ETH balance of at least `value`.
285      * - the called Solidity function must be `payable`.
286      *
287      * _Available since v3.1._
288      */
289     function functionCallWithValue(
290         address target,
291         bytes memory data,
292         uint256 value
293     ) internal returns (bytes memory) {
294         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
295     }
296 
297     /**
298      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
299      * with `errorMessage` as a fallback revert reason when `target` reverts.
300      *
301      * _Available since v3.1._
302      */
303     function functionCallWithValue(
304         address target,
305         bytes memory data,
306         uint256 value,
307         string memory errorMessage
308     ) internal returns (bytes memory) {
309         require(address(this).balance >= value, "Address: insufficient balance for call");
310         require(isContract(target), "Address: call to non-contract");
311 
312         (bool success, bytes memory returndata) = target.call{value: value}(data);
313         return _verifyCallResult(success, returndata, errorMessage);
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
318      * but performing a static call.
319      *
320      * _Available since v3.3._
321      */
322     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
323         return functionStaticCall(target, data, "Address: low-level static call failed");
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
328      * but performing a static call.
329      *
330      * _Available since v3.3._
331      */
332     function functionStaticCall(
333         address target,
334         bytes memory data,
335         string memory errorMessage
336     ) internal view returns (bytes memory) {
337         require(isContract(target), "Address: static call to non-contract");
338 
339         (bool success, bytes memory returndata) = target.staticcall(data);
340         return _verifyCallResult(success, returndata, errorMessage);
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
345      * but performing a delegate call.
346      *
347      * _Available since v3.4._
348      */
349     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
350         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
355      * but performing a delegate call.
356      *
357      * _Available since v3.4._
358      */
359     function functionDelegateCall(
360         address target,
361         bytes memory data,
362         string memory errorMessage
363     ) internal returns (bytes memory) {
364         require(isContract(target), "Address: delegate call to non-contract");
365 
366         (bool success, bytes memory returndata) = target.delegatecall(data);
367         return _verifyCallResult(success, returndata, errorMessage);
368     }
369 
370     function _verifyCallResult(
371         bool success,
372         bytes memory returndata,
373         string memory errorMessage
374     ) private pure returns (bytes memory) {
375         if (success) {
376             return returndata;
377         } else {
378             // Look for revert reason and bubble it up if present
379             if (returndata.length > 0) {
380                 // The easiest way to bubble the revert reason is using memory via assembly
381 
382                 assembly {
383                     let returndata_size := mload(returndata)
384                     revert(add(32, returndata), returndata_size)
385                 }
386             } else {
387                 revert(errorMessage);
388             }
389         }
390     }
391 }
392 
393 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
394 
395 pragma solidity ^0.8.0;
396 
397 /**
398  * @dev Contract module that helps prevent reentrant calls to a function.
399  *
400  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
401  * available, which can be applied to functions to make sure there are no nested
402  * (reentrant) calls to them.
403  *
404  * Note that because there is a single `nonReentrant` guard, functions marked as
405  * `nonReentrant` may not call one another. This can be worked around by making
406  * those functions `private`, and then adding `external` `nonReentrant` entry
407  * points to them.
408  *
409  * TIP: If you would like to learn more about reentrancy and alternative ways
410  * to protect against it, check out our blog post
411  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
412  */
413 abstract contract ReentrancyGuard {
414     // Booleans are more expensive than uint256 or any type that takes up a full
415     // word because each write operation emits an extra SLOAD to first read the
416     // slot's contents, replace the bits taken up by the boolean, and then write
417     // back. This is the compiler's defense against contract upgrades and
418     // pointer aliasing, and it cannot be disabled.
419 
420     // The values being non-zero value makes deployment a bit more expensive,
421     // but in exchange the refund on every call to nonReentrant will be lower in
422     // amount. Since refunds are capped to a percentage of the total
423     // transaction's gas, it is best to keep them low in cases like this one, to
424     // increase the likelihood of the full refund coming into effect.
425     uint256 private constant _NOT_ENTERED = 1;
426     uint256 private constant _ENTERED = 2;
427 
428     uint256 private _status;
429 
430     constructor() {
431         _status = _NOT_ENTERED;
432     }
433 
434     /**
435      * @dev Prevents a contract from calling itself, directly or indirectly.
436      * Calling a `nonReentrant` function from another `nonReentrant`
437      * function is not supported. It is possible to prevent this from happening
438      * by making the `nonReentrant` function external, and making it call a
439      * `private` function that does the actual work.
440      */
441     modifier nonReentrant() {
442         // On the first call to nonReentrant, _notEntered will be true
443         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
444 
445         // Any calls to nonReentrant after this point will fail
446         _status = _ENTERED;
447 
448         _;
449 
450         // By storing the original value once again, a refund is triggered (see
451         // https://eips.ethereum.org/EIPS/eip-2200)
452         _status = _NOT_ENTERED;
453     }
454 }
455 
456 
457 // File: IERC721Receiver.sol
458 
459 
460 
461 pragma solidity ^0.8.0;
462 
463 /**
464  * @title ERC721 token receiver interface
465  * @dev Interface for any contract that wants to support safeTransfers
466  * from ERC721 asset contracts.
467  */
468 interface IERC721Receiver {
469     /**
470      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
471      * by `operator` from `from`, this function is called.
472      *
473      * It must return its Solidity selector to confirm the token transfer.
474      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
475      *
476      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
477      */
478     function onERC721Received(
479         address operator,
480         address from,
481         uint256 tokenId,
482         bytes calldata data
483     ) external returns (bytes4);
484 }
485 
486 
487 // File: IERC165.sol
488 
489 
490 
491 pragma solidity ^0.8.0;
492 
493 /**
494  * @dev Interface of the ERC165 standard, as defined in the
495  * https://eips.ethereum.org/EIPS/eip-165[EIP].
496  *
497  * Implementers can declare support of contract interfaces, which can then be
498  * queried by others ({ERC165Checker}).
499  *
500  * For an implementation, see {ERC165}.
501  */
502 interface IERC165 {
503     /**
504      * @dev Returns true if this contract implements the interface defined by
505      * `interfaceId`. See the corresponding
506      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
507      * to learn more about how these ids are created.
508      *
509      * This function call must use less than 30 000 gas.
510      */
511     function supportsInterface(bytes4 interfaceId) external view returns (bool);
512 }
513 
514 
515 // File: ERC165.sol
516 
517 
518 
519 pragma solidity ^0.8.0;
520 
521 
522 /**
523  * @dev Implementation of the {IERC165} interface.
524  *
525  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
526  * for the additional interface id that will be supported. For example:
527  *
528  * ```solidity
529  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
530  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
531  * }
532  * ```
533  *
534  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
535  */
536 abstract contract ERC165 is IERC165 {
537     /**
538      * @dev See {IERC165-supportsInterface}.
539      */
540     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
541         return interfaceId == type(IERC165).interfaceId;
542     }
543 }
544 
545 
546 // File: IERC721.sol
547 
548 
549 
550 pragma solidity ^0.8.0;
551 
552 
553 /**
554  * @dev Required interface of an ERC721 compliant contract.
555  */
556 interface IERC721 is IERC165 {
557     /**
558      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
559      */
560     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
561 
562     /**
563      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
564      */
565     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
566 
567     /**
568      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
569      */
570     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
571 
572     /**
573      * @dev Returns the number of tokens in ``owner``'s account.
574      */
575     function balanceOf(address owner) external view returns (uint256 balance);
576 
577     /**
578      * @dev Returns the owner of the `tokenId` token.
579      *
580      * Requirements:
581      *
582      * - `tokenId` must exist.
583      */
584     function ownerOf(uint256 tokenId) external view returns (address owner);
585 
586     /**
587      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
588      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
589      *
590      * Requirements:
591      *
592      * - `from` cannot be the zero address.
593      * - `to` cannot be the zero address.
594      * - `tokenId` token must exist and be owned by `from`.
595      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
596      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
597      *
598      * Emits a {Transfer} event.
599      */
600     function safeTransferFrom(
601         address from,
602         address to,
603         uint256 tokenId
604     ) external;
605 
606     /**
607      * @dev Transfers `tokenId` token from `from` to `to`.
608      *
609      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
610      *
611      * Requirements:
612      *
613      * - `from` cannot be the zero address.
614      * - `to` cannot be the zero address.
615      * - `tokenId` token must be owned by `from`.
616      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
617      *
618      * Emits a {Transfer} event.
619      */
620     function transferFrom(
621         address from,
622         address to,
623         uint256 tokenId
624     ) external;
625 
626     /**
627      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
628      * The approval is cleared when the token is transferred.
629      *
630      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
631      *
632      * Requirements:
633      *
634      * - The caller must own the token or be an approved operator.
635      * - `tokenId` must exist.
636      *
637      * Emits an {Approval} event.
638      */
639     function approve(address to, uint256 tokenId) external;
640 
641     /**
642      * @dev Returns the account approved for `tokenId` token.
643      *
644      * Requirements:
645      *
646      * - `tokenId` must exist.
647      */
648     function getApproved(uint256 tokenId) external view returns (address operator);
649 
650     /**
651      * @dev Approve or remove `operator` as an operator for the caller.
652      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
653      *
654      * Requirements:
655      *
656      * - The `operator` cannot be the caller.
657      *
658      * Emits an {ApprovalForAll} event.
659      */
660     function setApprovalForAll(address operator, bool _approved) external;
661 
662     /**
663      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
664      *
665      * See {setApprovalForAll}
666      */
667     function isApprovedForAll(address owner, address operator) external view returns (bool);
668 
669     /**
670      * @dev Safely transfers `tokenId` token from `from` to `to`.
671      *
672      * Requirements:
673      *
674      * - `from` cannot be the zero address.
675      * - `to` cannot be the zero address.
676      * - `tokenId` token must exist and be owned by `from`.
677      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
678      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
679      *
680      * Emits a {Transfer} event.
681      */
682     function safeTransferFrom(
683         address from,
684         address to,
685         uint256 tokenId,
686         bytes calldata data
687     ) external;
688 }
689 
690 
691 
692 // File: IERC721Metadata.sol
693 
694 
695 
696 pragma solidity ^0.8.0;
697 
698 
699 /**
700  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
701  * @dev See https://eips.ethereum.org/EIPS/eip-721
702  */
703 interface IERC721Metadata is IERC721 {
704     /**
705      * @dev Returns the token collection name.
706      */
707     function name() external view returns (string memory);
708 
709     /**
710      * @dev Returns the token collection symbol.
711      */
712     function symbol() external view returns (string memory);
713 
714     /**
715      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
716      */
717     function tokenURI(uint256 tokenId) external view returns (string memory);
718 }
719 
720 
721 // ERC721A Contracts v3.3.0
722 // Creator: Chiru Labs
723 
724 pragma solidity ^0.8.4;
725 
726 
727 /**
728  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
729  * the Metadata extension. Built to optimize for lower gas during batch mints.
730  *
731  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
732  *
733  * Assumes that an owner cannot have more than 2**128 - 1 (max value of uint128) of supply.
734  *
735  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
736  */
737 
738 error ApprovalCallerNotOwnerNorApproved();
739 error ApprovalQueryForNonexistentToken();
740 error ApproveToCaller();
741 error ApprovalToCurrentOwner();
742 error BalanceQueryForZeroAddress();
743 error MintedQueryForZeroAddress();
744 error MintToZeroAddress();
745 error MintZeroQuantity();
746 error OwnerQueryForNonexistentToken();
747 error TransferCallerNotOwnerNorApproved();
748 error TransferFromIncorrectOwner();
749 error TransferToNonERC721ReceiverImplementer();
750 error TransferToNonERC721ReceiverImplementerFunction();
751 error MintToNonERC721ReceiverImplementer();
752 error TransferToZeroAddress();
753 error URIQueryForNonexistentToken();
754 
755 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, ReentrancyGuard {
756     using Address for address;
757     using Strings for uint256;
758 
759     struct TokenOwnership {
760         address addr;
761         uint64 startTimestamp;
762     }
763 
764     // Compiler will pack this into a single 256bit word.
765     struct AddressData {
766         // Realistically, 2**64-1 is more than enough.
767         uint128 balance;
768         // Keeps track of mint count with minimal overhead for tokenomics.
769         uint128 numberMinted;
770     }
771 
772     // The tokenId of the next regular token to be minted.
773     uint256 internal _currentIndexGold = 1;
774     uint256 internal _currentIndexDiamond = 56;
775     uint256 internal _currentIndex = 499;
776 
777     // Token name
778     string private _name;
779 
780     // Token symbol
781     string private _symbol;
782 
783     // Mapping from token ID to ownership details
784     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
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
799     }
800 
801     /**
802      * @dev Returns _currentIndex.
803      */
804     function totalSupply() public view returns (uint256) {
805         return (_currentIndex-499 + _currentIndexDiamond-56 + _currentIndexGold-1);
806     }
807 
808     /**
809      * @dev See {IERC165-supportsInterface}.
810      */
811     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
812         return
813             interfaceId == type(IERC721).interfaceId ||
814             interfaceId == type(IERC721Metadata).interfaceId ||
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
826     /**
827      * Returns the number of tokens minted by `owner`.
828      */
829     function _numberMinted(address owner) internal view returns (uint256) {
830         if (owner == address(0)) revert MintedQueryForZeroAddress();
831         return uint256(_addressData[owner].numberMinted);
832     }
833 
834     /**
835      * Gas spent here starts off proportional to the maximum mint batch size.
836      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
837      */
838     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
839         uint256 curr = tokenId;
840 
841         unchecked {
842             if ( (1 <= curr && curr < _currentIndexGold) || (56 <= curr && curr < _currentIndexDiamond) || (499 <= curr && curr < _currentIndex) ) {
843                 TokenOwnership memory ownership = _ownerships[curr];
844                 if (ownership.addr != address(0)) {
845                     return ownership;
846                 }
847                 // think about it... won't underflow ;)
848                 while (true) {
849                     curr--;
850                     ownership = _ownerships[curr];
851                     if (ownership.addr != address(0)) {
852                         return ownership;
853                     }
854                 }
855             }
856         } // unchecked
857         revert OwnerQueryForNonexistentToken();
858     }
859 
860     /**
861      * @dev See {IERC721-ownerOf}.
862      */
863     function ownerOf(uint256 tokenId) public view override returns (address) {
864         return _ownershipOf(tokenId).addr;
865     }
866 
867     /**
868      * @dev See {IERC721Metadata-name}.
869      */
870     function name() public view virtual override returns (string memory) {
871         return _name;
872     }
873 
874     /**
875      * @dev See {IERC721Metadata-symbol}.
876      */
877     function symbol() public view virtual override returns (string memory) {
878         return _symbol;
879     }
880 
881     /**
882      * @dev See {IERC721Metadata-tokenURI}.
883      */
884     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
885         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
886 
887         string memory baseURI = _baseURI();
888         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
889     }
890 
891     /**
892      * @dev Base URI for {tokenURI}. Empty
893      * by default, can be overriden in child contracts.
894      */
895     function _baseURI() internal view virtual returns (string memory) {
896         return '';
897     }
898 
899     /**
900      * @dev See {IERC721-approve}.
901      */
902     function approve(address to, uint256 tokenId) public override {
903         address owner = ERC721A.ownerOf(tokenId);
904         if (to == owner) revert ApprovalToCurrentOwner();
905 
906         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
907             revert ApprovalCallerNotOwnerNorApproved();
908         }
909 
910         _approve(to, tokenId, owner);
911     }
912 
913     /**
914      * @dev See {IERC721-getApproved}.
915      */
916     function getApproved(uint256 tokenId) public view override returns (address) {
917         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
918 
919         return _tokenApprovals[tokenId];
920     }
921 
922     /**
923      * @dev See {IERC721-setApprovalForAll}.
924      */
925     function setApprovalForAll(address operator, bool approved) public override {
926         if (operator == _msgSender()) revert ApproveToCaller();
927 
928         _operatorApprovals[_msgSender()][operator] = approved;
929         emit ApprovalForAll(_msgSender(), operator, approved);
930     }
931 
932     /**
933      * @dev See {IERC721-isApprovedForAll}.
934      */
935     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
936         return _operatorApprovals[owner][operator];
937     }
938 
939     /**
940      * @dev See {IERC721-transferFrom}.
941      */
942     function transferFrom(
943         address from,
944         address to,
945         uint256 tokenId
946     ) public override {
947         _transfer(from, to, tokenId);
948     }
949 
950     /**
951      * @dev See {IERC721-safeTransferFrom}.
952      */
953     function safeTransferFrom(
954         address from,
955         address to,
956         uint256 tokenId
957     ) public override {
958         safeTransferFrom(from, to, tokenId, '');
959     }
960 
961     /**
962      * @dev See {IERC721-safeTransferFrom}.
963      */
964     function safeTransferFrom(
965         address from,
966         address to,
967         uint256 tokenId,
968         bytes memory _data
969     ) public override {
970         _transfer(from, to, tokenId);
971         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
972             revert TransferToNonERC721ReceiverImplementer();
973         }
974     }
975 
976     /**
977      * @dev Returns whether `tokenId` exists.
978      *
979      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
980      *
981      * Tokens start existing when they are minted (`_mint`),
982      */
983     function _exists(uint256 tokenId) internal view returns (bool) {
984         if (tokenId < 56) {
985             return tokenId < _currentIndexGold;
986         } else if (tokenId < 499) {
987             return tokenId < _currentIndexDiamond;
988         } else {
989             return tokenId < _currentIndex;
990         }
991     }
992 
993     /**
994      * @dev Safely mints `quantity` tokens and transfers them to `to`.
995      *
996      * Requirements:
997      *
998      * - If `to` refers to a smart contract, it must implement
999      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1000      * - `quantity` must be greater than 0.
1001      *
1002      * Emits a {Transfer} event.
1003      */
1004     function _safeMint(
1005         address to,
1006         uint256 quantity,
1007         uint256 special
1008     ) internal {
1009         if (to == address(0)) revert MintToZeroAddress();
1010         if (quantity == 0) revert MintZeroQuantity();
1011 
1012         uint256 startTokenId;
1013         if (special == 1) { // gold
1014             startTokenId = _currentIndexGold;
1015         } else if (special == 2) { // diamond
1016             startTokenId = _currentIndexDiamond;
1017         } else {
1018             startTokenId = _currentIndex;
1019         }
1020 
1021         // Overflows are incredibly unrealistic
1022         // balance or numberMinted overflow if current value of either + quantity > (2**128) - 1
1023         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1024         unchecked {
1025             _addressData[to].balance += uint128(quantity);
1026             _addressData[to].numberMinted += uint128(quantity);
1027 
1028             _ownerships[startTokenId].addr = to;
1029             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1030 
1031             uint256 updatedIndex = startTokenId;
1032 
1033             for (uint256 i = 0; i < quantity; i++) {
1034                 emit Transfer(address(0), to, updatedIndex);
1035                 if (!_checkOnERC721Received(address(0), to, updatedIndex, '')) {
1036                     revert MintToNonERC721ReceiverImplementer();
1037                 }
1038                 updatedIndex++;
1039 
1040             }
1041 
1042             if (special == 1) { // gold
1043                 _currentIndexGold = updatedIndex;
1044             } else if (special == 2) { // diamond
1045                 _currentIndexDiamond = updatedIndex;
1046             } else {
1047                 _currentIndex = updatedIndex;
1048             }
1049         } // unchecked
1050     }
1051 
1052     /**
1053      * @dev Transfers `tokenId` from `from` to `to`.
1054      *
1055      * Requirements:
1056      *
1057      * - `to` cannot be the zero address.
1058      * - `tokenId` token must be owned by `from`.
1059      *
1060      * Emits a {Transfer} event.
1061      */
1062     function _transfer(
1063         address from,
1064         address to,
1065         uint256 tokenId
1066     ) private nonReentrant {
1067         if (to == address(0)) revert TransferToZeroAddress();
1068 
1069         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1070         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1071 
1072         bool isApprovedOrOwner = (_msgSender() == from ||
1073             isApprovedForAll(from, _msgSender()) ||
1074             getApproved(tokenId) == _msgSender());
1075 
1076         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1077 
1078         // Clear approvals from the previous owner
1079         _approve(address(0), tokenId, from);
1080 
1081         // Underflow of the sender's balance is impossible because we check for
1082         // ownership above and the recipient's balance can't realistically overflow.
1083         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1084         //      Me: meh, I'm not convinced the underflow is safe from re-entrancy attacks 
1085         // (comes down to a race condition); to still save gas I modified this 
1086         // to be nonReentrant to be safe
1087         unchecked {
1088             _addressData[from].balance -= 1;
1089             _addressData[to].balance += 1;
1090 
1091             _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1092 
1093             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1094             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1095             uint256 nextTokenId = tokenId + 1;
1096             if (_ownerships[nextTokenId].addr == address(0)) {
1097                 if (_exists(nextTokenId)) {
1098                     _ownerships[nextTokenId] = TokenOwnership(
1099                         prevOwnership.addr,
1100                         prevOwnership.startTimestamp
1101                     );
1102                 }
1103             }
1104         } // unchecked
1105 
1106         emit Transfer(from, to, tokenId);
1107     }
1108 
1109     /**
1110      * @dev Approve `to` to operate on `tokenId`
1111      *
1112      * Emits a {Approval} event.
1113      */
1114     function _approve(
1115         address to,
1116         uint256 tokenId,
1117         address owner
1118     ) private {
1119         _tokenApprovals[tokenId] = to;
1120         emit Approval(owner, to, tokenId);
1121     }
1122 
1123     /**
1124      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1125      *
1126      * @param from address representing the previous owner of the given token ID
1127      * @param to target address that will receive the tokens
1128      * @param tokenId uint256 ID of the token to be transferred
1129      * @param _data bytes optional data to send along with the call
1130      * @return bool whether the call correctly returned the expected magic value
1131      */
1132     function _checkOnERC721Received(
1133         address from,
1134         address to,
1135         uint256 tokenId,
1136         bytes memory _data
1137     ) private returns (bool) {
1138         if (to.isContract()) {
1139             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1140                 return retval == IERC721Receiver(to).onERC721Received.selector;
1141             } catch (bytes memory reason) {
1142                 if (reason.length == 0) {
1143                     revert TransferToNonERC721ReceiverImplementerFunction();
1144                 } else {
1145                     assembly {
1146                         revert(add(32, reason), mload(reason))
1147                     }
1148                 }
1149             }
1150         } else {
1151             return true;
1152         }
1153     }
1154 }
1155 
1156 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
1157 
1158 pragma solidity ^0.8.0;
1159 
1160 /**
1161  * @dev These functions deal with verification of Merkle Tree proofs.
1162  *
1163  * The proofs can be generated using the JavaScript library
1164  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1165  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1166  *
1167  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1168  *
1169  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1170  * hashing, or use a hash function other than keccak256 for hashing leaves.
1171  * This is because the concatenation of a sorted pair of internal nodes in
1172  * the merkle tree could be reinterpreted as a leaf value.
1173  */
1174 library MerkleProof {
1175     /**
1176      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1177      * defined by `root`. For this, a `proof` must be provided, containing
1178      * sibling hashes on the branch from the leaf to the root of the tree. Each
1179      * pair of leaves and each pair of pre-images are assumed to be sorted.
1180      */
1181     function verify(
1182         bytes32[] memory proof,
1183         bytes32 root,
1184         bytes32 leaf
1185     ) internal pure returns (bool) {
1186         return processProof(proof, leaf) == root;
1187     }
1188 
1189     /**
1190      * @dev Calldata version of {verify}
1191      *
1192      * _Available since v4.7._
1193      */
1194     function verifyCalldata(
1195         bytes32[] calldata proof,
1196         bytes32 root,
1197         bytes32 leaf
1198     ) internal pure returns (bool) {
1199         return processProofCalldata(proof, leaf) == root;
1200     }
1201 
1202     /**
1203      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1204      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1205      * hash matches the root of the tree. When processing the proof, the pairs
1206      * of leafs & pre-images are assumed to be sorted.
1207      *
1208      * _Available since v4.4._
1209      */
1210     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1211         bytes32 computedHash = leaf;
1212         for (uint256 i = 0; i < proof.length; i++) {
1213             computedHash = _hashPair(computedHash, proof[i]);
1214         }
1215         return computedHash;
1216     }
1217 
1218     /**
1219      * @dev Calldata version of {processProof}
1220      *
1221      * _Available since v4.7._
1222      */
1223     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1224         bytes32 computedHash = leaf;
1225         for (uint256 i = 0; i < proof.length; i++) {
1226             computedHash = _hashPair(computedHash, proof[i]);
1227         }
1228         return computedHash;
1229     }
1230 
1231     /**
1232      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1233      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1234      *
1235      * _Available since v4.7._
1236      */
1237     function multiProofVerify(
1238         bytes32[] memory proof,
1239         bool[] memory proofFlags,
1240         bytes32 root,
1241         bytes32[] memory leaves
1242     ) internal pure returns (bool) {
1243         return processMultiProof(proof, proofFlags, leaves) == root;
1244     }
1245 
1246     /**
1247      * @dev Calldata version of {multiProofVerify}
1248      *
1249      * _Available since v4.7._
1250      */
1251     function multiProofVerifyCalldata(
1252         bytes32[] calldata proof,
1253         bool[] calldata proofFlags,
1254         bytes32 root,
1255         bytes32[] memory leaves
1256     ) internal pure returns (bool) {
1257         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1258     }
1259 
1260     /**
1261      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1262      * consuming from one or the other at each step according to the instructions given by
1263      * `proofFlags`.
1264      *
1265      * _Available since v4.7._
1266      */
1267     function processMultiProof(
1268         bytes32[] memory proof,
1269         bool[] memory proofFlags,
1270         bytes32[] memory leaves
1271     ) internal pure returns (bytes32 merkleRoot) {
1272         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1273         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1274         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1275         // the merkle tree.
1276         uint256 leavesLen = leaves.length;
1277         uint256 totalHashes = proofFlags.length;
1278 
1279         // Check proof validity.
1280         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1281 
1282         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1283         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1284         bytes32[] memory hashes = new bytes32[](totalHashes);
1285         uint256 leafPos = 0;
1286         uint256 hashPos = 0;
1287         uint256 proofPos = 0;
1288         // At each step, we compute the next hash using two values:
1289         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1290         //   get the next hash.
1291         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1292         //   `proof` array.
1293         for (uint256 i = 0; i < totalHashes; i++) {
1294             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1295             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1296             hashes[i] = _hashPair(a, b);
1297         }
1298 
1299         if (totalHashes > 0) {
1300             return hashes[totalHashes - 1];
1301         } else if (leavesLen > 0) {
1302             return leaves[0];
1303         } else {
1304             return proof[0];
1305         }
1306     }
1307 
1308     /**
1309      * @dev Calldata version of {processMultiProof}
1310      *
1311      * _Available since v4.7._
1312      */
1313     function processMultiProofCalldata(
1314         bytes32[] calldata proof,
1315         bool[] calldata proofFlags,
1316         bytes32[] memory leaves
1317     ) internal pure returns (bytes32 merkleRoot) {
1318         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1319         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1320         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1321         // the merkle tree.
1322         uint256 leavesLen = leaves.length;
1323         uint256 totalHashes = proofFlags.length;
1324 
1325         // Check proof validity.
1326         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1327 
1328         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1329         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1330         bytes32[] memory hashes = new bytes32[](totalHashes);
1331         uint256 leafPos = 0;
1332         uint256 hashPos = 0;
1333         uint256 proofPos = 0;
1334         // At each step, we compute the next hash using two values:
1335         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1336         //   get the next hash.
1337         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1338         //   `proof` array.
1339         for (uint256 i = 0; i < totalHashes; i++) {
1340             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1341             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1342             hashes[i] = _hashPair(a, b);
1343         }
1344 
1345         if (totalHashes > 0) {
1346             return hashes[totalHashes - 1];
1347         } else if (leavesLen > 0) {
1348             return leaves[0];
1349         } else {
1350             return proof[0];
1351         }
1352     }
1353 
1354     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1355         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1356     }
1357 
1358     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1359         /// @solidity memory-safe-assembly
1360         assembly {
1361             mstore(0x00, a)
1362             mstore(0x20, b)
1363             value := keccak256(0x00, 0x40)
1364         }
1365     }
1366 }
1367 
1368 pragma solidity >=0.8.4 <0.9.0;
1369 
1370 error MintFromContract();
1371 error MintNonpositive();
1372 error MerkleProofInvalid();
1373 error SaleNotActive();
1374 error WithdrawFailed();
1375 
1376 contract RDH is ERC721A, Ownable {  
1377     using Strings for uint256;
1378 
1379     uint256 public max_supply = 5555;
1380     uint256 public wl_start     = 1661972400; // Wed Aug 31 2022 16:37:25 GMT+0000
1381     uint256 public public_start = 1661983200; // 3 hours later
1382 
1383     uint256 public cost_wl = 0.05 ether;
1384     uint256 public cost_public = 0.05 ether;
1385 
1386     bool public revealed = false;
1387 
1388     uint256 public mint_limit_gold   = 1;  // per wallet
1389     uint256 public mint_limit_team   = 10; // per wallet
1390     uint256 public mint_limit_og     = 2;  // per wallet
1391     uint256 public mint_limit_fr     = 1;  // per wallet
1392     uint256 public mint_limit_wl     = 1;  // per wallet
1393     uint256 public mint_limit_public = 1;  // per wallet
1394 
1395     bytes32 public merkle_root_gold;
1396     bytes32 public merkle_root_team;
1397     bytes32 public merkle_root_og;
1398     bytes32 public merkle_root_fr;
1399     bytes32 public merkle_root_wl;
1400 
1401     string private _myBaseURI;
1402     string private _myHiddenURI;
1403 
1404 	constructor() ERC721A("Rekted Diamond Hands", "RDH") {}
1405 
1406     function setMaxSupply(uint256 _maxSupply) external onlyOwner {
1407          max_supply = _maxSupply;
1408     }
1409 
1410     function setWLStart(uint256 _wlStart) external onlyOwner {
1411         wl_start = _wlStart;
1412     }
1413     function setPublicStart(uint256 _publicStart) external onlyOwner {
1414         public_start = _publicStart;
1415     }
1416 
1417     function setCostWL(uint256 _costWL) external onlyOwner {
1418         cost_wl = _costWL;
1419     }
1420     function setCostPublic(uint256 _costPublic) external onlyOwner {
1421         cost_public = _costPublic;
1422     }
1423     function setRevealed(bool _revealed) external onlyOwner {
1424         revealed = _revealed;
1425     }
1426 
1427     function setMintLimitGold(uint256 _mintLimit) external onlyOwner {
1428         mint_limit_gold = _mintLimit;
1429     }
1430     function setMintLimitTeam(uint256 _mintLimit) external onlyOwner {
1431         mint_limit_team = _mintLimit;
1432     }
1433     function setMintLimitOG(uint256 _mintLimit) external onlyOwner {
1434         mint_limit_og = _mintLimit;
1435     }
1436     function setMintLimitFR(uint256 _mintLimit) external onlyOwner {
1437         mint_limit_fr = _mintLimit;
1438     }
1439     function setMintLimitWL(uint256 _mintLimit) external onlyOwner {
1440         mint_limit_wl = _mintLimit;
1441     }
1442     function setMintLimitPublic(uint256 _mintLimit) external onlyOwner {
1443         mint_limit_public = _mintLimit;
1444     }
1445 
1446     function setMerkleRootGold(bytes32 _merkleRoot) external onlyOwner {
1447         merkle_root_gold = _merkleRoot;
1448     }
1449     function setMerkleRootTeam(bytes32 _merkleRoot) external onlyOwner {
1450         merkle_root_team = _merkleRoot;
1451     }
1452     function setMerkleRootOG(bytes32 _merkleRoot) external onlyOwner {
1453         merkle_root_og = _merkleRoot;
1454     }
1455     function setMerkleRootWL(bytes32 _merkleRoot) external onlyOwner {
1456         merkle_root_wl = _merkleRoot;
1457     }
1458     function setMerkleRootFR(bytes32 _merkleRoot) external onlyOwner {
1459         merkle_root_fr = _merkleRoot;
1460     }
1461 
1462 
1463     // note v0.8.0 checks safe math by default :)
1464     function mint(uint256 mintAmount, bytes32[] calldata _merkleProof) payable external nonReentrant {
1465         require(tx.origin == msg.sender, "tried to mint from contract");
1466         require(block.timestamp >= wl_start, "wl sale not active");
1467         require(totalSupply() + mintAmount <= max_supply, "tried to mint more than max supply");
1468 
1469         uint256 state = 0;
1470         if (MerkleProof.verify(_merkleProof, merkle_root_gold, keccak256(abi.encodePacked(_msgSender())))) {
1471             require(_numberMinted(_msgSender()) + mintAmount <= mint_limit_gold, "tried to mint too many gold");
1472             state = 1; // gold
1473         } else if (MerkleProof.verify(_merkleProof, merkle_root_team, keccak256(abi.encodePacked(_msgSender())))) {
1474             require(_numberMinted(_msgSender()) + mintAmount <= mint_limit_team, "tried to mint too many investor/team");
1475             mintAmount = mint_limit_team;
1476         } else if (MerkleProof.verify(_merkleProof, merkle_root_og, keccak256(abi.encodePacked(_msgSender())))) {
1477             require(_numberMinted(_msgSender()) + mintAmount <= mint_limit_og, "tried to mint too many og");
1478             state = 2;
1479         } else if (MerkleProof.verify(_merkleProof, merkle_root_fr, keccak256(abi.encodePacked(_msgSender())))) {
1480             require(_numberMinted(_msgSender()) + mintAmount <= mint_limit_fr, "tried to mint too many fr");
1481         } else if (MerkleProof.verify(_merkleProof, merkle_root_wl, keccak256(abi.encodePacked(_msgSender())))) {
1482             require(_numberMinted(_msgSender()) + mintAmount <= mint_limit_wl, "tried to mint too many wl");
1483             require(msg.value >= cost_wl*mint_limit_wl, "wl didn't pay enough");
1484 
1485             if (_currentIndexDiamond < 499) {
1486                 state = 2;
1487                 require(mintAmount + _currentIndexDiamond <= 499, "error, tried to mint too many diamond pre");
1488             }
1489         } else {
1490             require(false, "invalid merkle proof");
1491         }
1492         _safeMint(_msgSender(), mintAmount, state);
1493     }
1494 
1495     function publicMint(uint256 mintAmount) payable external nonReentrant {
1496         require(tx.origin == msg.sender, "tried to mint from contract");
1497         require(block.timestamp >= public_start, "public sale not active");
1498         require(totalSupply() + mintAmount <= max_supply, "tried to mint more than max supply jic");
1499 
1500         uint256 state = 0;
1501         if (_currentIndexDiamond < 499) {
1502                 state = 2;
1503                 require(mintAmount + _currentIndexDiamond <= 499, "error, tried to mint too many diamond public");
1504         }
1505         require(msg.value >= cost_public*mint_limit_public, "public didn't pay enough");
1506         _safeMint(_msgSender(), mintAmount, state);
1507     }
1508 
1509     function teamMint(uint256 mintAmount, uint256 choice) external onlyOwner {
1510         require(totalSupply() + mintAmount <= max_supply, "tried to mint more than max supply tm");
1511         if (choice == 1) { // gold
1512             _safeMint(_msgSender(), mintAmount, choice);
1513         } else if (choice == 2) { // diamond
1514             _safeMint(_msgSender(), mintAmount, choice);
1515         } else {
1516             _safeMint(_msgSender(), mintAmount, 0);
1517         }
1518     }
1519 
1520     function setMyBaseURI(string memory _myNewBaseURI) external onlyOwner {
1521         _myBaseURI = _myNewBaseURI;
1522     }
1523     function setMyHiddenURI(string memory _myNewHiddenURI) external onlyOwner {
1524         _myHiddenURI = _myNewHiddenURI;
1525     }
1526 
1527     function tokenURI(uint256 tokenId) public view virtual override(ERC721A) returns (string memory) {
1528         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1529        
1530         if (revealed) {
1531             return bytes(_myBaseURI).length != 0 ? string(abi.encodePacked(_myBaseURI, tokenId.toString(), ".json")) : "";
1532         } else {
1533             return bytes(_myHiddenURI).length != 0 ? _myHiddenURI : "";
1534         }
1535     }
1536 
1537     event DonationReceived(address sender, uint256 amount);
1538     receive() external payable {
1539         emit DonationReceived(msg.sender, msg.value);
1540     }
1541 
1542     function withdraw() external payable nonReentrant {
1543         uint256 balance0 = address(this).balance;
1544 
1545         (bool LU, ) = payable(0x01656D41e041b50fc7c1eb270f7d891021937436).call{value: balance0 * 1000 / 10000}("");
1546         (bool ED, ) = payable(0x97cc51cD15ba17B79046004d34341fCE028d9505).call{value: balance0 * 1000 / 10000}("");
1547         (bool NB, ) = payable(0x13eeDD1582fC3738C67c3AfeE997D394802c2C6b).call{value: balance0 * 1000 / 10000}(""); 
1548         (bool RM, ) = payable(0x681bc14ad38069705197506Bd7f1DE40B49A8E44).call{value: balance0 *  881 / 10000}("");
1549         (bool OK, ) = payable(0x2a97e97c5BEa2dE2a3C79482bA850E91683a01d0).call{value: balance0 * 3000 / 10000}("");
1550         (bool IV, ) = payable(0xC042B012998C94fCcf5BA78685f3a7eFC9228D6B).call{value: balance0 * 1200 / 10000}("");
1551         (bool TM, ) = payable(0xfC78AC48ee9E375D1BB63b983f4929279656dF1B).call{value: balance0 *  900 / 10000}("");
1552         (bool TS, ) = payable(0xC05207E2936141134dD92E731c15c4b0A1032e43).call{value: balance0 * 1019 / 10000}("");
1553 
1554         if (!(LU && ED && NB && RM && OK && IV && TM && TS)) revert WithdrawFailed();
1555     }
1556 }