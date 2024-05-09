1 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Contract module that helps prevent reentrant calls to a function.
7  *
8  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
9  * available, which can be applied to functions to make sure there are no nested
10  * (reentrant) calls to them.
11  *
12  * Note that because there is a single `nonReentrant` guard, functions marked as
13  * `nonReentrant` may not call one another. This can be worked around by making
14  * those functions `private`, and then adding `external` `nonReentrant` entry
15  * points to them.
16  *
17  * TIP: If you would like to learn more about reentrancy and alternative ways
18  * to protect against it, check out our blog post
19  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
20  */
21 abstract contract ReentrancyGuard {
22     // Booleans are more expensive than uint256 or any type that takes up a full
23     // word because each write operation emits an extra SLOAD to first read the
24     // slot's contents, replace the bits taken up by the boolean, and then write
25     // back. This is the compiler's defense against contract upgrades and
26     // pointer aliasing, and it cannot be disabled.
27 
28     // The values being non-zero value makes deployment a bit more expensive,
29     // but in exchange the refund on every call to nonReentrant will be lower in
30     // amount. Since refunds are capped to a percentage of the total
31     // transaction's gas, it is best to keep them low in cases like this one, to
32     // increase the likelihood of the full refund coming into effect.
33     uint256 private constant _NOT_ENTERED = 1;
34     uint256 private constant _ENTERED = 2;
35 
36     uint256 private _status;
37 
38     constructor() {
39         _status = _NOT_ENTERED;
40     }
41 
42     /**
43      * @dev Prevents a contract from calling itself, directly or indirectly.
44      * Calling a `nonReentrant` function from another `nonReentrant`
45      * function is not supported. It is possible to prevent this from happening
46      * by making the `nonReentrant` function external, and making it call a
47      * `private` function that does the actual work.
48      */
49     modifier nonReentrant() {
50         // On the first call to nonReentrant, _notEntered will be true
51         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
52 
53         // Any calls to nonReentrant after this point will fail
54         _status = _ENTERED;
55 
56         _;
57 
58         // By storing the original value once again, a refund is triggered (see
59         // https://eips.ethereum.org/EIPS/eip-2200)
60         _status = _NOT_ENTERED;
61     }
62 }
63 
64 // File: @openzeppelin/contracts/utils/Strings.sol
65 
66 
67 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
68 
69 pragma solidity ^0.8.0;
70 
71 /**
72  * @dev String operations.
73  */
74 library Strings {
75     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
76     uint8 private constant _ADDRESS_LENGTH = 20;
77 
78     /**
79      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
80      */
81     function toString(uint256 value) internal pure returns (string memory) {
82         // Inspired by OraclizeAPI's implementation - MIT licence
83         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
84 
85         if (value == 0) {
86             return "0";
87         }
88         uint256 temp = value;
89         uint256 digits;
90         while (temp != 0) {
91             digits++;
92             temp /= 10;
93         }
94         bytes memory buffer = new bytes(digits);
95         while (value != 0) {
96             digits -= 1;
97             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
98             value /= 10;
99         }
100         return string(buffer);
101     }
102 
103     /**
104      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
105      */
106     function toHexString(uint256 value) internal pure returns (string memory) {
107         if (value == 0) {
108             return "0x00";
109         }
110         uint256 temp = value;
111         uint256 length = 0;
112         while (temp != 0) {
113             length++;
114             temp >>= 8;
115         }
116         return toHexString(value, length);
117     }
118 
119     /**
120      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
121      */
122     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
123         bytes memory buffer = new bytes(2 * length + 2);
124         buffer[0] = "0";
125         buffer[1] = "x";
126         for (uint256 i = 2 * length + 1; i > 1; --i) {
127             buffer[i] = _HEX_SYMBOLS[value & 0xf];
128             value >>= 4;
129         }
130         require(value == 0, "Strings: hex length insufficient");
131         return string(buffer);
132     }
133 
134     /**
135      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
136      */
137     function toHexString(address addr) internal pure returns (string memory) {
138         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
139     }
140 }
141 
142 // File: @openzeppelin/contracts/utils/Address.sol
143 
144 
145 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
146 
147 pragma solidity ^0.8.1;
148 
149 /**
150  * @dev Collection of functions related to the address type
151  */
152 library Address {
153     /**
154      * @dev Returns true if `account` is a contract.
155      *
156      * [IMPORTANT]
157      * ====
158      * It is unsafe to assume that an address for which this function returns
159      * false is an externally-owned account (EOA) and not a contract.
160      *
161      * Among others, `isContract` will return false for the following
162      * types of addresses:
163      *
164      *  - an externally-owned account
165      *  - a contract in construction
166      *  - an address where a contract will be created
167      *  - an address where a contract lived, but was destroyed
168      * ====
169      *
170      * [IMPORTANT]
171      * ====
172      * You shouldn't rely on `isContract` to protect against flash loan attacks!
173      *
174      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
175      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
176      * constructor.
177      * ====
178      */
179     function isContract(address account) internal view returns (bool) {
180         // This method relies on extcodesize/address.code.length, which returns 0
181         // for contracts in construction, since the code is only stored at the end
182         // of the constructor execution.
183 
184         return account.code.length > 0;
185     }
186 
187     /**
188      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
189      * `recipient`, forwarding all available gas and reverting on errors.
190      *
191      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
192      * of certain opcodes, possibly making contracts go over the 2300 gas limit
193      * imposed by `transfer`, making them unable to receive funds via
194      * `transfer`. {sendValue} removes this limitation.
195      *
196      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
197      *
198      * IMPORTANT: because control is transferred to `recipient`, care must be
199      * taken to not create reentrancy vulnerabilities. Consider using
200      * {ReentrancyGuard} or the
201      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
202      */
203     function sendValue(address payable recipient, uint256 amount) internal {
204         require(address(this).balance >= amount, "Address: insufficient balance");
205 
206         (bool success, ) = recipient.call{value: amount}("");
207         require(success, "Address: unable to send value, recipient may have reverted");
208     }
209 
210     /**
211      * @dev Performs a Solidity function call using a low level `call`. A
212      * plain `call` is an unsafe replacement for a function call: use this
213      * function instead.
214      *
215      * If `target` reverts with a revert reason, it is bubbled up by this
216      * function (like regular Solidity function calls).
217      *
218      * Returns the raw returned data. To convert to the expected return value,
219      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
220      *
221      * Requirements:
222      *
223      * - `target` must be a contract.
224      * - calling `target` with `data` must not revert.
225      *
226      * _Available since v3.1._
227      */
228     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
229         return functionCall(target, data, "Address: low-level call failed");
230     }
231 
232     /**
233      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
234      * `errorMessage` as a fallback revert reason when `target` reverts.
235      *
236      * _Available since v3.1._
237      */
238     function functionCall(
239         address target,
240         bytes memory data,
241         string memory errorMessage
242     ) internal returns (bytes memory) {
243         return functionCallWithValue(target, data, 0, errorMessage);
244     }
245 
246     /**
247      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
248      * but also transferring `value` wei to `target`.
249      *
250      * Requirements:
251      *
252      * - the calling contract must have an ETH balance of at least `value`.
253      * - the called Solidity function must be `payable`.
254      *
255      * _Available since v3.1._
256      */
257     function functionCallWithValue(
258         address target,
259         bytes memory data,
260         uint256 value
261     ) internal returns (bytes memory) {
262         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
267      * with `errorMessage` as a fallback revert reason when `target` reverts.
268      *
269      * _Available since v3.1._
270      */
271     function functionCallWithValue(
272         address target,
273         bytes memory data,
274         uint256 value,
275         string memory errorMessage
276     ) internal returns (bytes memory) {
277         require(address(this).balance >= value, "Address: insufficient balance for call");
278         require(isContract(target), "Address: call to non-contract");
279 
280         (bool success, bytes memory returndata) = target.call{value: value}(data);
281         return verifyCallResult(success, returndata, errorMessage);
282     }
283 
284     /**
285      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
286      * but performing a static call.
287      *
288      * _Available since v3.3._
289      */
290     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
291         return functionStaticCall(target, data, "Address: low-level static call failed");
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
296      * but performing a static call.
297      *
298      * _Available since v3.3._
299      */
300     function functionStaticCall(
301         address target,
302         bytes memory data,
303         string memory errorMessage
304     ) internal view returns (bytes memory) {
305         require(isContract(target), "Address: static call to non-contract");
306 
307         (bool success, bytes memory returndata) = target.staticcall(data);
308         return verifyCallResult(success, returndata, errorMessage);
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
313      * but performing a delegate call.
314      *
315      * _Available since v3.4._
316      */
317     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
318         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
323      * but performing a delegate call.
324      *
325      * _Available since v3.4._
326      */
327     function functionDelegateCall(
328         address target,
329         bytes memory data,
330         string memory errorMessage
331     ) internal returns (bytes memory) {
332         require(isContract(target), "Address: delegate call to non-contract");
333 
334         (bool success, bytes memory returndata) = target.delegatecall(data);
335         return verifyCallResult(success, returndata, errorMessage);
336     }
337 
338     /**
339      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
340      * revert reason using the provided one.
341      *
342      * _Available since v4.3._
343      */
344     function verifyCallResult(
345         bool success,
346         bytes memory returndata,
347         string memory errorMessage
348     ) internal pure returns (bytes memory) {
349         if (success) {
350             return returndata;
351         } else {
352             // Look for revert reason and bubble it up if present
353             if (returndata.length > 0) {
354                 // The easiest way to bubble the revert reason is using memory via assembly
355                 /// @solidity memory-safe-assembly
356                 assembly {
357                     let returndata_size := mload(returndata)
358                     revert(add(32, returndata), returndata_size)
359                 }
360             } else {
361                 revert(errorMessage);
362             }
363         }
364     }
365 }
366 
367 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
368 
369 
370 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
371 
372 pragma solidity ^0.8.0;
373 
374 /**
375  * @title ERC721 token receiver interface
376  * @dev Interface for any contract that wants to support safeTransfers
377  * from ERC721 asset contracts.
378  */
379 interface IERC721Receiver {
380     /**
381      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
382      * by `operator` from `from`, this function is called.
383      *
384      * It must return its Solidity selector to confirm the token transfer.
385      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
386      *
387      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
388      */
389     function onERC721Received(
390         address operator,
391         address from,
392         uint256 tokenId,
393         bytes calldata data
394     ) external returns (bytes4);
395 }
396 
397 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
398 
399 
400 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
401 
402 pragma solidity ^0.8.0;
403 
404 /**
405  * @dev Interface of the ERC165 standard, as defined in the
406  * https://eips.ethereum.org/EIPS/eip-165[EIP].
407  *
408  * Implementers can declare support of contract interfaces, which can then be
409  * queried by others ({ERC165Checker}).
410  *
411  * For an implementation, see {ERC165}.
412  */
413 interface IERC165 {
414     /**
415      * @dev Returns true if this contract implements the interface defined by
416      * `interfaceId`. See the corresponding
417      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
418      * to learn more about how these ids are created.
419      *
420      * This function call must use less than 30 000 gas.
421      */
422     function supportsInterface(bytes4 interfaceId) external view returns (bool);
423 }
424 
425 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
426 
427 
428 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
429 
430 pragma solidity ^0.8.0;
431 
432 
433 /**
434  * @dev Implementation of the {IERC165} interface.
435  *
436  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
437  * for the additional interface id that will be supported. For example:
438  *
439  * ```solidity
440  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
441  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
442  * }
443  * ```
444  *
445  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
446  */
447 abstract contract ERC165 is IERC165 {
448     /**
449      * @dev See {IERC165-supportsInterface}.
450      */
451     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
452         return interfaceId == type(IERC165).interfaceId;
453     }
454 }
455 
456 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
457 
458 
459 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
460 
461 pragma solidity ^0.8.0;
462 
463 
464 /**
465  * @dev Required interface of an ERC721 compliant contract.
466  */
467 interface IERC721 is IERC165 {
468     /**
469      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
470      */
471     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
472 
473     /**
474      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
475      */
476     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
477 
478     /**
479      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
480      */
481     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
482 
483     /**
484      * @dev Returns the number of tokens in ``owner``'s account.
485      */
486     function balanceOf(address owner) external view returns (uint256 balance);
487 
488     /**
489      * @dev Returns the owner of the `tokenId` token.
490      *
491      * Requirements:
492      *
493      * - `tokenId` must exist.
494      */
495     function ownerOf(uint256 tokenId) external view returns (address owner);
496 
497     /**
498      * @dev Safely transfers `tokenId` token from `from` to `to`.
499      *
500      * Requirements:
501      *
502      * - `from` cannot be the zero address.
503      * - `to` cannot be the zero address.
504      * - `tokenId` token must exist and be owned by `from`.
505      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
506      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
507      *
508      * Emits a {Transfer} event.
509      */
510     function safeTransferFrom(
511         address from,
512         address to,
513         uint256 tokenId,
514         bytes calldata data
515     ) external;
516 
517     /**
518      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
519      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
520      *
521      * Requirements:
522      *
523      * - `from` cannot be the zero address.
524      * - `to` cannot be the zero address.
525      * - `tokenId` token must exist and be owned by `from`.
526      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
527      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
528      *
529      * Emits a {Transfer} event.
530      */
531     function safeTransferFrom(
532         address from,
533         address to,
534         uint256 tokenId
535     ) external;
536 
537     /**
538      * @dev Transfers `tokenId` token from `from` to `to`.
539      *
540      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
541      *
542      * Requirements:
543      *
544      * - `from` cannot be the zero address.
545      * - `to` cannot be the zero address.
546      * - `tokenId` token must be owned by `from`.
547      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
548      *
549      * Emits a {Transfer} event.
550      */
551     function transferFrom(
552         address from,
553         address to,
554         uint256 tokenId
555     ) external;
556 
557     /**
558      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
559      * The approval is cleared when the token is transferred.
560      *
561      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
562      *
563      * Requirements:
564      *
565      * - The caller must own the token or be an approved operator.
566      * - `tokenId` must exist.
567      *
568      * Emits an {Approval} event.
569      */
570     function approve(address to, uint256 tokenId) external;
571 
572     /**
573      * @dev Approve or remove `operator` as an operator for the caller.
574      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
575      *
576      * Requirements:
577      *
578      * - The `operator` cannot be the caller.
579      *
580      * Emits an {ApprovalForAll} event.
581      */
582     function setApprovalForAll(address operator, bool _approved) external;
583 
584     /**
585      * @dev Returns the account approved for `tokenId` token.
586      *
587      * Requirements:
588      *
589      * - `tokenId` must exist.
590      */
591     function getApproved(uint256 tokenId) external view returns (address operator);
592 
593     /**
594      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
595      *
596      * See {setApprovalForAll}
597      */
598     function isApprovedForAll(address owner, address operator) external view returns (bool);
599 }
600 
601 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
602 
603 
604 
605 
606 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
607 
608 pragma solidity ^0.8.0;
609 
610 
611 /**
612  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
613  * @dev See https://eips.ethereum.org/EIPS/eip-721
614  */
615 interface IERC721Enumerable is IERC721 {
616     /**
617      * @dev Returns the total amount of tokens stored by the contract.
618      */
619     function totalSupply() external view returns (uint256);
620 
621     /**
622      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
623      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
624      */
625     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
626 
627     /**
628      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
629      * Use along with {totalSupply} to enumerate all tokens.
630      */
631     function tokenByIndex(uint256 index) external view returns (uint256);
632 }
633 
634 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
635 
636 
637 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
638 
639 pragma solidity ^0.8.0;
640 
641 
642 /**
643  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
644  * @dev See https://eips.ethereum.org/EIPS/eip-721
645  */
646 interface IERC721Metadata is IERC721 {
647     /**
648      * @dev Returns the token collection name.
649      */
650     function name() external view returns (string memory);
651 
652     /**
653      * @dev Returns the token collection symbol.
654      */
655     function symbol() external view returns (string memory);
656 
657     /**
658      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
659      */
660     function tokenURI(uint256 tokenId) external view returns (string memory);
661 }
662 
663 // File: @openzeppelin/contracts/utils/Context.sol
664 
665 
666 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
667 
668 pragma solidity ^0.8.0;
669 
670 /**
671  * @dev Provides information about the current execution context, including the
672  * sender of the transaction and its data. While these are generally available
673  * via msg.sender and msg.data, they should not be accessed in such a direct
674  * manner, since when dealing with meta-transactions the account sending and
675  * paying for execution may not be the actual sender (as far as an application
676  * is concerned).
677  *
678  * This contract is only required for intermediate, library-like contracts.
679  */
680 abstract contract Context {
681     function _msgSender() internal view virtual returns (address) {
682         return msg.sender;
683     }
684 
685     function _msgData() internal view virtual returns (bytes calldata) {
686         return msg.data;
687     }
688 }
689 
690 // File: ERC721A.sol
691 
692 
693 
694 // Creator: Chiru Labs
695 
696 pragma solidity ^0.8.4;
697 
698 
699 
700 
701 
702 
703 
704 
705 
706 error ApprovalCallerNotOwnerNorApproved();
707 error ApprovalQueryForNonexistentToken();
708 error ApproveToCaller();
709 error ApprovalToCurrentOwner();
710 error BalanceQueryForZeroAddress();
711 error MintedQueryForZeroAddress();
712 error BurnedQueryForZeroAddress();
713 error AuxQueryForZeroAddress();
714 error MintToZeroAddress();
715 error MintZeroQuantity();
716 error OwnerIndexOutOfBounds();
717 error OwnerQueryForNonexistentToken();
718 error TokenIndexOutOfBounds();
719 error TransferCallerNotOwnerNorApproved();
720 error TransferFromIncorrectOwner();
721 error TransferToNonERC721ReceiverImplementer();
722 error TransferToZeroAddress();
723 error URIQueryForNonexistentToken();
724 
725 /**
726  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
727  * the Metadata extension. Built to optimize for lower gas during batch mints.
728  *
729  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
730  *
731  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
732  *
733  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
734  */
735 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
736     using Address for address;
737     using Strings for uint256;
738 
739     // Compiler will pack this into a single 256bit word.
740     struct TokenOwnership {
741         // The address of the owner.
742         address addr;
743         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
744         uint64 startTimestamp;
745         // Whether the token has been burned.
746         bool burned;
747     }
748 
749     // Compiler will pack this into a single 256bit word.
750     struct AddressData {
751         // Realistically, 2**64-1 is more than enough.
752         uint64 balance;
753         // Keeps track of mint count with minimal overhead for tokenomics.
754         uint64 numberMinted;
755         // Keeps track of burn count with minimal overhead for tokenomics.
756         uint64 numberBurned;
757         // For miscellaneous variable(s) pertaining to the address
758         // (e.g. number of whitelist mint slots used).
759         // If there are multiple variables, please pack them into a uint64.
760         uint64 aux;
761     }
762 
763     // The tokenId of the next token to be minted.
764     uint256 internal _currentIndex;
765 
766     // The number of tokens burned.
767     uint256 internal _burnCounter;
768 
769     // Token name
770     string private _name;
771 
772     // Token symbol
773     string private _symbol;
774 
775     // Mapping from token ID to ownership details
776     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
777     mapping(uint256 => TokenOwnership) internal _ownerships;
778 
779     // Mapping owner address to address data
780     mapping(address => AddressData) private _addressData;
781 
782     // Mapping from token ID to approved address
783     mapping(uint256 => address) private _tokenApprovals;
784 
785     // Mapping from owner to operator approvals
786     mapping(address => mapping(address => bool)) private _operatorApprovals;
787 
788     constructor(string memory name_, string memory symbol_) {
789         _name = name_;
790         _symbol = symbol_;
791         _currentIndex = _startTokenId();
792     }
793 
794     /**
795      * To change the starting tokenId, please override this function.
796      */
797     function _startTokenId() internal view virtual returns (uint256) {
798         return 0;
799     }
800 
801     /**
802      * @dev See {IERC721Enumerable-totalSupply}.
803      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
804      */
805     function totalSupply() public view returns (uint256) {
806         // Counter underflow is impossible as _burnCounter cannot be incremented
807         // more than _currentIndex - _startTokenId() times
808         unchecked {
809             return _currentIndex - _burnCounter - _startTokenId();
810         }
811     }
812 
813     /**
814      * Returns the total amount of tokens minted in the contract.
815      */
816     function _totalMinted() internal view returns (uint256) {
817         // Counter underflow is impossible as _currentIndex does not decrement,
818         // and it is initialized to _startTokenId()
819         unchecked {
820             return _currentIndex - _startTokenId();
821         }
822     }
823 
824     /**
825      * @dev See {IERC165-supportsInterface}.
826      */
827     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
828         return
829             interfaceId == type(IERC721).interfaceId ||
830             interfaceId == type(IERC721Metadata).interfaceId ||
831             super.supportsInterface(interfaceId);
832     }
833 
834     /**
835      * @dev See {IERC721-balanceOf}.
836      */
837     function balanceOf(address owner) public view override returns (uint256) {
838         if (owner == address(0)) revert BalanceQueryForZeroAddress();
839         return uint256(_addressData[owner].balance);
840     }
841 
842     /**
843      * Returns the number of tokens minted by `owner`.
844      */
845     function _numberMinted(address owner) internal view returns (uint256) {
846         if (owner == address(0)) revert MintedQueryForZeroAddress();
847         return uint256(_addressData[owner].numberMinted);
848     }
849 
850     /**
851      * Returns the number of tokens burned by or on behalf of `owner`.
852      */
853     function _numberBurned(address owner) internal view returns (uint256) {
854         if (owner == address(0)) revert BurnedQueryForZeroAddress();
855         return uint256(_addressData[owner].numberBurned);
856     }
857 
858     /**
859      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
860      */
861     function _getAux(address owner) internal view returns (uint64) {
862         if (owner == address(0)) revert AuxQueryForZeroAddress();
863         return _addressData[owner].aux;
864     }
865 
866     /**
867      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
868      * If there are multiple variables, please pack them into a uint64.
869      */
870     function _setAux(address owner, uint64 aux) internal {
871         if (owner == address(0)) revert AuxQueryForZeroAddress();
872         _addressData[owner].aux = aux;
873     }
874 
875     /**
876      * Gas spent here starts off proportional to the maximum mint batch size.
877      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
878      */
879     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
880         uint256 curr = tokenId;
881 
882         unchecked {
883             if (_startTokenId() <= curr && curr < _currentIndex) {
884                 TokenOwnership memory ownership = _ownerships[curr];
885                 if (!ownership.burned) {
886                     if (ownership.addr != address(0)) {
887                         return ownership;
888                     }
889                     // Invariant:
890                     // There will always be an ownership that has an address and is not burned
891                     // before an ownership that does not have an address and is not burned.
892                     // Hence, curr will not underflow.
893                     while (true) {
894                         curr--;
895                         ownership = _ownerships[curr];
896                         if (ownership.addr != address(0)) {
897                             return ownership;
898                         }
899                     }
900                 }
901             }
902         }
903         revert OwnerQueryForNonexistentToken();
904     }
905 
906 
907     /**
908      * @dev See {IERC721-ownerOf}.
909      */
910     function ownerOf(uint256 tokenId) public view override returns (address) {
911         return ownershipOf(tokenId).addr;
912     }
913 
914     /**
915      * @dev See {IERC721Metadata-name}.
916      */
917     function name() public view virtual override returns (string memory) {
918         return _name;
919     }
920 
921     /**
922      * @dev See {IERC721Metadata-symbol}.
923      */
924     function symbol() public view virtual override returns (string memory) {
925         return _symbol;
926     }
927 
928     /**
929      * @dev See {IERC721Metadata-tokenURI}.
930      */
931     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
932         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
933 
934         string memory baseURI = _baseURI();
935         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
936     }
937 
938     /**
939      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
940      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
941      * by default, can be overriden in child contracts.
942      */
943     function _baseURI() internal view virtual returns (string memory) {
944         return '';
945     }
946 
947     /**
948      * @dev See {IERC721-approve}.
949      */
950     function approve(address to, uint256 tokenId) public override {
951         address owner = ERC721A.ownerOf(tokenId);
952         if (to == owner) revert ApprovalToCurrentOwner();
953 
954         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
955             revert ApprovalCallerNotOwnerNorApproved();
956         }
957 
958         _approve(to, tokenId, owner);
959     }
960 
961     /**
962      * @dev See {IERC721-getApproved}.
963      */
964     function getApproved(uint256 tokenId) public view override returns (address) {
965         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
966 
967         return _tokenApprovals[tokenId];
968     }
969 
970     /**
971      * @dev See {IERC721-setApprovalForAll}.
972      */
973     function setApprovalForAll(address operator, bool approved) public override {
974         if (operator == _msgSender()) revert ApproveToCaller();
975 
976         _operatorApprovals[_msgSender()][operator] = approved;
977         emit ApprovalForAll(_msgSender(), operator, approved);
978     }
979 
980     /**
981      * @dev See {IERC721-isApprovedForAll}.
982      */
983     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
984         return _operatorApprovals[owner][operator];
985     }
986 
987     /**
988      * @dev See {IERC721-transferFrom}.
989      */
990     function transferFrom(
991         address from,
992         address to,
993         uint256 tokenId
994     ) public virtual override {
995         _transfer(from, to, tokenId);
996     }
997 
998     /**
999      * @dev See {IERC721-safeTransferFrom}.
1000      */
1001     function safeTransferFrom(
1002         address from,
1003         address to,
1004         uint256 tokenId
1005     ) public virtual override {
1006         safeTransferFrom(from, to, tokenId, '');
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-safeTransferFrom}.
1011      */
1012     function safeTransferFrom(
1013         address from,
1014         address to,
1015         uint256 tokenId,
1016         bytes memory _data
1017     ) public virtual override {
1018         _transfer(from, to, tokenId);
1019         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1020             revert TransferToNonERC721ReceiverImplementer();
1021         }
1022     }
1023 
1024     /**
1025      * @dev Returns whether `tokenId` exists.
1026      *
1027      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1028      *
1029      * Tokens start existing when they are minted (`_mint`),
1030      */
1031     function _exists(uint256 tokenId) internal view returns (bool) {
1032         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1033             !_ownerships[tokenId].burned;
1034     }
1035 
1036     function _safeMint(address to, uint256 quantity) internal {
1037         _safeMint(to, quantity, '');
1038     }
1039 
1040     /**
1041      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1042      *
1043      * Requirements:
1044      *
1045      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1046      * - `quantity` must be greater than 0.
1047      *
1048      * Emits a {Transfer} event.
1049      */
1050     function _safeMint(
1051         address to,
1052         uint256 quantity,
1053         bytes memory _data
1054     ) internal {
1055         _mint(to, quantity, _data, true);
1056     }
1057 
1058 
1059 
1060 
1061     /**
1062      * @dev Mints `quantity` tokens and transfers them to `to`.
1063      *
1064      * Requirements:
1065      *
1066      * - `to` cannot be the zero address.
1067      * - `quantity` must be greater than 0.
1068      *
1069      * Emits a {Transfer} event.
1070      */
1071     function _mint(
1072         address to,
1073         uint256 quantity,
1074         bytes memory _data,
1075         bool safe
1076     ) internal {
1077         uint256 startTokenId = _currentIndex;
1078         if (to == address(0)) revert MintToZeroAddress();
1079         if (quantity == 0) revert MintZeroQuantity();
1080 
1081         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1082 
1083         // Overflows are incredibly unrealistic.
1084         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1085         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1086         unchecked {
1087             _addressData[to].balance += uint64(quantity);
1088             _addressData[to].numberMinted += uint64(quantity);
1089 
1090             _ownerships[startTokenId].addr = to;
1091             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1092 
1093             uint256 updatedIndex = startTokenId;
1094             uint256 end = updatedIndex + quantity;
1095 
1096             if (safe && to.isContract()) {
1097                 do {
1098                     emit Transfer(address(0), to, updatedIndex);
1099                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1100                         revert TransferToNonERC721ReceiverImplementer();
1101                     }
1102                 } while (updatedIndex != end);
1103                 // Reentrancy protection
1104                 if (_currentIndex != startTokenId) revert();
1105             } else {
1106                 do {
1107                     emit Transfer(address(0), to, updatedIndex++);
1108                 } while (updatedIndex != end);
1109             }
1110             _currentIndex = updatedIndex;
1111         }
1112         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1113     }
1114 
1115     /**
1116      * @dev Transfers `tokenId` from `from` to `to`.
1117      *
1118      * Requirements:
1119      *
1120      * - `to` cannot be the zero address.
1121      * - `tokenId` token must be owned by `from`.
1122      *
1123      * Emits a {Transfer} event.
1124      */
1125     function _transfer(
1126         address from,
1127         address to,
1128         uint256 tokenId
1129     ) private {
1130         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1131 
1132         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1133             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1134             getApproved(tokenId) == _msgSender());
1135 
1136         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1137         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1138         if (to == address(0)) revert TransferToZeroAddress();
1139 
1140         _beforeTokenTransfers(from, to, tokenId, 1);
1141 
1142         // Clear approvals from the previous owner
1143         _approve(address(0), tokenId, prevOwnership.addr);
1144 
1145         // Underflow of the sender's balance is impossible because we check for
1146         // ownership above and the recipient's balance can't realistically overflow.
1147         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1148         unchecked {
1149             _addressData[from].balance -= 1;
1150             _addressData[to].balance += 1;
1151 
1152             _ownerships[tokenId].addr = to;
1153             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1154 
1155             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1156             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1157             uint256 nextTokenId = tokenId + 1;
1158             if (_ownerships[nextTokenId].addr == address(0)) {
1159                 // This will suffice for checking _exists(nextTokenId),
1160                 // as a burned slot cannot contain the zero address.
1161                 if (nextTokenId < _currentIndex) {
1162                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1163                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1164                 }
1165             }
1166         }
1167 
1168         emit Transfer(from, to, tokenId);
1169         _afterTokenTransfers(from, to, tokenId, 1);
1170     }
1171 
1172     /**
1173      * @dev Destroys `tokenId`.
1174      * The approval is cleared when the token is burned.
1175      *
1176      * Requirements:
1177      *
1178      * - `tokenId` must exist.
1179      *
1180      * Emits a {Transfer} event.
1181      */
1182     function _burn(uint256 tokenId) internal virtual {
1183         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1184 
1185         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1186 
1187         // Clear approvals from the previous owner
1188         _approve(address(0), tokenId, prevOwnership.addr);
1189 
1190         // Underflow of the sender's balance is impossible because we check for
1191         // ownership above and the recipient's balance can't realistically overflow.
1192         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1193         unchecked {
1194             _addressData[prevOwnership.addr].balance -= 1;
1195             _addressData[prevOwnership.addr].numberBurned += 1;
1196 
1197             // Keep track of who burned the token, and the timestamp of burning.
1198             _ownerships[tokenId].addr = prevOwnership.addr;
1199             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1200             _ownerships[tokenId].burned = true;
1201 
1202             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1203             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1204             uint256 nextTokenId = tokenId + 1;
1205             if (_ownerships[nextTokenId].addr == address(0)) {
1206                 // This will suffice for checking _exists(nextTokenId),
1207                 // as a burned slot cannot contain the zero address.
1208                 if (nextTokenId < _currentIndex) {
1209                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1210                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1211                 }
1212             }
1213         }
1214 
1215         emit Transfer(prevOwnership.addr, address(0), tokenId);
1216         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1217 
1218         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1219         unchecked {
1220             _burnCounter++;
1221         }
1222     }
1223 
1224     /**
1225      * @dev Approve `to` to operate on `tokenId`
1226      *
1227      * Emits a {Approval} event.
1228      */
1229     function _approve(
1230         address to,
1231         uint256 tokenId,
1232         address owner
1233     ) private {
1234         _tokenApprovals[tokenId] = to;
1235         emit Approval(owner, to, tokenId);
1236     }
1237 
1238     /**
1239      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1240      *
1241      * @param from address representing the previous owner of the given token ID
1242      * @param to target address that will receive the tokens
1243      * @param tokenId uint256 ID of the token to be transferred
1244      * @param _data bytes optional data to send along with the call
1245      * @return bool whether the call correctly returned the expected magic value
1246      */
1247     function _checkContractOnERC721Received(
1248         address from,
1249         address to,
1250         uint256 tokenId,
1251         bytes memory _data
1252     ) private returns (bool) {
1253         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1254             return retval == IERC721Receiver(to).onERC721Received.selector;
1255         } catch (bytes memory reason) {
1256             if (reason.length == 0) {
1257                 revert TransferToNonERC721ReceiverImplementer();
1258             } else {
1259                 assembly {
1260                     revert(add(32, reason), mload(reason))
1261                 }
1262             }
1263         }
1264     }
1265 
1266     /**
1267      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1268      * And also called before burning one token.
1269      *
1270      * startTokenId - the first token id to be transferred
1271      * quantity - the amount to be transferred
1272      *
1273      * Calling conditions:
1274      *
1275      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1276      * transferred to `to`.
1277      * - When `from` is zero, `tokenId` will be minted for `to`.
1278      * - When `to` is zero, `tokenId` will be burned by `from`.
1279      * - `from` and `to` are never both zero.
1280      */
1281     function _beforeTokenTransfers(
1282         address from,
1283         address to,
1284         uint256 startTokenId,
1285         uint256 quantity
1286     ) internal virtual {}
1287 
1288     /**
1289      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1290      * minting.
1291      * And also called after one token has been burned.
1292      *
1293      * startTokenId - the first token id to be transferred
1294      * quantity - the amount to be transferred
1295      *
1296      * Calling conditions:
1297      *
1298      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1299      * transferred to `to`.
1300      * - When `from` is zero, `tokenId` has been minted for `to`.
1301      * - When `to` is zero, `tokenId` has been burned by `from`.
1302      * - `from` and `to` are never both zero.
1303      */
1304     function _afterTokenTransfers(
1305         address from,
1306         address to,
1307         uint256 startTokenId,
1308         uint256 quantity
1309     ) internal virtual {}
1310 }
1311 // File: @openzeppelin/contracts/access/Ownable.sol
1312 
1313 
1314 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1315 
1316 pragma solidity ^0.8.0;
1317 
1318 
1319 /**
1320  * @dev Contract module which provides a basic access control mechanism, where
1321  * there is an account (an owner) that can be granted exclusive access to
1322  * specific functions.
1323  *
1324  * By default, the owner account will be the one that deploys the contract. This
1325  * can later be changed with {transferOwnership}.
1326  *
1327  * This module is used through inheritance. It will make available the modifier
1328  * `onlyOwner`, which can be applied to your functions to restrict their use to
1329  * the owner.
1330  */
1331 abstract contract Ownable is Context {
1332     address private _owner;
1333 
1334     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1335 
1336     /**
1337      * @dev Initializes the contract setting the deployer as the initial owner.
1338      */
1339     constructor() {
1340         _transferOwnership(_msgSender());
1341     }
1342 
1343     /**
1344      * @dev Throws if called by any account other than the owner.
1345      */
1346     modifier onlyOwner() {
1347         _checkOwner();
1348         _;
1349     }
1350 
1351     /**
1352      * @dev Returns the address of the current owner.
1353      */
1354     function owner() public view virtual returns (address) {
1355         return _owner;
1356     }
1357 
1358     /**
1359      * @dev Throws if the sender is not the owner.
1360      */
1361     function _checkOwner() internal view virtual {
1362         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1363     }
1364 
1365 
1366 
1367     /**
1368      * @dev Leaves the contract without owner. It will not be possible to call
1369      * `onlyOwner` functions anymore. Can only be called by the current owner.
1370      *
1371      * NOTE: Renouncing ownership will leave the contract without an owner,
1372      * thereby removing any functionality that is only available to the owner.
1373      */
1374     function renounceOwnership() public virtual onlyOwner {
1375         _transferOwnership(address(0));
1376     }
1377 
1378     /**
1379      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1380      * Can only be called by the current owner.
1381      */
1382     function transferOwnership(address newOwner) public virtual onlyOwner {
1383         require(newOwner != address(0), "Ownable: new owner is the zero address");
1384         _transferOwnership(newOwner);
1385     }
1386 
1387     /**
1388      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1389      * Internal function without access restriction.
1390      */
1391     function _transferOwnership(address newOwner) internal virtual {
1392         address oldOwner = _owner;
1393         _owner = newOwner;
1394         emit OwnershipTransferred(oldOwner, newOwner);
1395     }
1396 }
1397 
1398 
1399 
1400 
1401 pragma solidity ^0.8.2;
1402 
1403 
1404 
1405 
1406 contract KaleidoscopeKids is ERC721A, Ownable, ReentrancyGuard {
1407     enum Status {
1408         Waiting,
1409         Started,
1410         Finished
1411     }
1412     using Strings for uint256;
1413     bool public isPublicSaleActive = true;
1414     string private baseURI = "ipfs://bafybeiakeihycpdcgcnoldyexlthbzoonohh5ujzx3fn7fvku3bbqf5emq/";
1415     uint256 public constant MAX_MINT_PER_ADDR = 3;
1416     uint256 public constant MAX_FREE_MINT_PER_ADDR = 2;
1417     uint256 public PUBLIC_PRICE = 0.002 * 10**18;
1418     uint256 public constant MAX_SUPPLY = 1013;
1419     uint256 public constant FREE_MINT_SUPPLY = 1013;
1420     uint256 public INSTANT_FREE_MINTED = 0;
1421 
1422     event Minted(address minter, uint256 amount);
1423 
1424     constructor(string memory initBaseURI) ERC721A("KaleidoscopeKids", "KaleidoKid") {
1425         baseURI = initBaseURI;
1426         _safeMint(msg.sender, MAX_FREE_MINT_PER_ADDR);
1427     }
1428 
1429     function _baseURI() internal view override returns (string memory) {
1430         return baseURI;
1431     }
1432     function ownerMint(uint quantity, address user)
1433     public
1434     onlyOwner
1435     {
1436     require(
1437       quantity > 0,
1438       "Invalid mint amount"
1439     );
1440     require(
1441       totalSupply() + quantity <= MAX_SUPPLY,
1442       "Maximum supply exceeded"
1443     );
1444     _safeMint(user, quantity);
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