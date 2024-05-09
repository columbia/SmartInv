1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev String operations.
7  */
8 library Strings {
9     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
10 
11     /**
12      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
13      */
14     function toString(uint256 value) internal pure returns (string memory) {
15         // Inspired by OraclizeAPI's implementation - MIT licence
16         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
17 
18         if (value == 0) {
19             return "0";
20         }
21         uint256 temp = value;
22         uint256 digits;
23         while (temp != 0) {
24             digits++;
25             temp /= 10;
26         }
27         bytes memory buffer = new bytes(digits);
28         while (value != 0) {
29             digits -= 1;
30             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
31             value /= 10;
32         }
33         return string(buffer);
34     }
35 
36     /**
37      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
38      */
39     function toHexString(uint256 value) internal pure returns (string memory) {
40         if (value == 0) {
41             return "0x00";
42         }
43         uint256 temp = value;
44         uint256 length = 0;
45         while (temp != 0) {
46             length++;
47             temp >>= 8;
48         }
49         return toHexString(value, length);
50     }
51 
52     /**
53      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
54      */
55     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
56         bytes memory buffer = new bytes(2 * length + 2);
57         buffer[0] = "0";
58         buffer[1] = "x";
59         for (uint256 i = 2 * length + 1; i > 1; --i) {
60             buffer[i] = _HEX_SYMBOLS[value & 0xf];
61             value >>= 4;
62         }
63         require(value == 0, "Strings: hex length insufficient");
64         return string(buffer);
65     }
66 }
67 
68 // File: @openzeppelin/contracts/utils/Address.sol
69 
70 
71 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
72 
73 pragma solidity ^0.8.1;
74 
75 /**
76  * @dev Collection of functions related to the address type
77  */
78 library Address {
79     /**
80      * @dev Returns true if `account` is a contract.
81      *
82      * [IMPORTANT]
83      * ====
84      * It is unsafe to assume that an address for which this function returns
85      * false is an externally-owned account (EOA) and not a contract.
86      *
87      * Among others, `isContract` will return false for the following
88      * types of addresses:
89      *
90      *  - an externally-owned account
91      *  - a contract in construction
92      *  - an address where a contract will be created
93      *  - an address where a contract lived, but was destroyed
94      * ====
95      *
96      * [IMPORTANT]
97      * ====
98      * You shouldn't rely on `isContract` to protect against flash loan attacks!
99      *
100      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
101      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
102      * constructor.
103      * ====
104      */
105     function isContract(address account) internal view returns (bool) {
106         // This method relies on extcodesize/address.code.length, which returns 0
107         // for contracts in construction, since the code is only stored at the end
108         // of the constructor execution.
109 
110         return account.code.length > 0;
111     }
112 
113     /**
114      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
115      * `recipient`, forwarding all available gas and reverting on errors.
116      *
117      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
118      * of certain opcodes, possibly making contracts go over the 2300 gas limit
119      * imposed by `transfer`, making them unable to receive funds via
120      * `transfer`. {sendValue} removes this limitation.
121      *
122      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
123      *
124      * IMPORTANT: because control is transferred to `recipient`, care must be
125      * taken to not create reentrancy vulnerabilities. Consider using
126      * {ReentrancyGuard} or the
127      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
128      */
129     function sendValue(address payable recipient, uint256 amount) internal {
130         require(address(this).balance >= amount, "Address: insufficient balance");
131 
132         (bool success, ) = recipient.call{value: amount}("");
133         require(success, "Address: unable to send value, recipient may have reverted");
134     }
135 
136     /**
137      * @dev Performs a Solidity function call using a low level `call`. A
138      * plain `call` is an unsafe replacement for a function call: use this
139      * function instead.
140      *
141      * If `target` reverts with a revert reason, it is bubbled up by this
142      * function (like regular Solidity function calls).
143      *
144      * Returns the raw returned data. To convert to the expected return value,
145      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
146      *
147      * Requirements:
148      *
149      * - `target` must be a contract.
150      * - calling `target` with `data` must not revert.
151      *
152      * _Available since v3.1._
153      */
154     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
155         return functionCall(target, data, "Address: low-level call failed");
156     }
157 
158     /**
159      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
160      * `errorMessage` as a fallback revert reason when `target` reverts.
161      *
162      * _Available since v3.1._
163      */
164     function functionCall(
165         address target,
166         bytes memory data,
167         string memory errorMessage
168     ) internal returns (bytes memory) {
169         return functionCallWithValue(target, data, 0, errorMessage);
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
174      * but also transferring `value` wei to `target`.
175      *
176      * Requirements:
177      *
178      * - the calling contract must have an ETH balance of at least `value`.
179      * - the called Solidity function must be `payable`.
180      *
181      * _Available since v3.1._
182      */
183     function functionCallWithValue(
184         address target,
185         bytes memory data,
186         uint256 value
187     ) internal returns (bytes memory) {
188         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
193      * with `errorMessage` as a fallback revert reason when `target` reverts.
194      *
195      * _Available since v3.1._
196      */
197     function functionCallWithValue(
198         address target,
199         bytes memory data,
200         uint256 value,
201         string memory errorMessage
202     ) internal returns (bytes memory) {
203         require(address(this).balance >= value, "Address: insufficient balance for call");
204         require(isContract(target), "Address: call to non-contract");
205 
206         (bool success, bytes memory returndata) = target.call{value: value}(data);
207         return verifyCallResult(success, returndata, errorMessage);
208     }
209 
210     /**
211      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
212      * but performing a static call.
213      *
214      * _Available since v3.3._
215      */
216     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
217         return functionStaticCall(target, data, "Address: low-level static call failed");
218     }
219 
220     /**
221      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
222      * but performing a static call.
223      *
224      * _Available since v3.3._
225      */
226     function functionStaticCall(
227         address target,
228         bytes memory data,
229         string memory errorMessage
230     ) internal view returns (bytes memory) {
231         require(isContract(target), "Address: static call to non-contract");
232 
233         (bool success, bytes memory returndata) = target.staticcall(data);
234         return verifyCallResult(success, returndata, errorMessage);
235     }
236 
237     /**
238      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
239      * but performing a delegate call.
240      *
241      * _Available since v3.4._
242      */
243     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
244         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
245     }
246 
247     /**
248      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
249      * but performing a delegate call.
250      *
251      * _Available since v3.4._
252      */
253     function functionDelegateCall(
254         address target,
255         bytes memory data,
256         string memory errorMessage
257     ) internal returns (bytes memory) {
258         require(isContract(target), "Address: delegate call to non-contract");
259 
260         (bool success, bytes memory returndata) = target.delegatecall(data);
261         return verifyCallResult(success, returndata, errorMessage);
262     }
263 
264     /**
265      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
266      * revert reason using the provided one.
267      *
268      * _Available since v4.3._
269      */
270     function verifyCallResult(
271         bool success,
272         bytes memory returndata,
273         string memory errorMessage
274     ) internal pure returns (bytes memory) {
275         if (success) {
276             return returndata;
277         } else {
278             // Look for revert reason and bubble it up if present
279             if (returndata.length > 0) {
280                 // The easiest way to bubble the revert reason is using memory via assembly
281 
282                 assembly {
283                     let returndata_size := mload(returndata)
284                     revert(add(32, returndata), returndata_size)
285                 }
286             } else {
287                 revert(errorMessage);
288             }
289         }
290     }
291 }
292 
293 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
294 
295 
296 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
297 
298 pragma solidity ^0.8.0;
299 
300 /**
301  * @title ERC721 token receiver interface
302  * @dev Interface for any contract that wants to support safeTransfers
303  * from ERC721 asset contracts.
304  */
305 interface IERC721Receiver {
306     /**
307      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
308      * by `operator` from `from`, this function is called.
309      *
310      * It must return its Solidity selector to confirm the token transfer.
311      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
312      *
313      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
314      */
315     function onERC721Received(
316         address operator,
317         address from,
318         uint256 tokenId,
319         bytes calldata data
320     ) external returns (bytes4);
321 }
322 
323 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
324 
325 
326 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
327 
328 pragma solidity ^0.8.0;
329 
330 /**
331  * @dev Interface of the ERC165 standard, as defined in the
332  * https://eips.ethereum.org/EIPS/eip-165[EIP].
333  *
334  * Implementers can declare support of contract interfaces, which can then be
335  * queried by others ({ERC165Checker}).
336  *
337  * For an implementation, see {ERC165}.
338  */
339 interface IERC165 {
340     /**
341      * @dev Returns true if this contract implements the interface defined by
342      * `interfaceId`. See the corresponding
343      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
344      * to learn more about how these ids are created.
345      *
346      * This function call must use less than 30 000 gas.
347      */
348     function supportsInterface(bytes4 interfaceId) external view returns (bool);
349 }
350 
351 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
352 
353 
354 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
355 
356 pragma solidity ^0.8.0;
357 
358 
359 /**
360  * @dev Implementation of the {IERC165} interface.
361  *
362  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
363  * for the additional interface id that will be supported. For example:
364  *
365  * ```solidity
366  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
367  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
368  * }
369  * ```
370  *
371  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
372  */
373 abstract contract ERC165 is IERC165 {
374     /**
375      * @dev See {IERC165-supportsInterface}.
376      */
377     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
378         return interfaceId == type(IERC165).interfaceId;
379     }
380 }
381 
382 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
383 
384 
385 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
386 
387 pragma solidity ^0.8.0;
388 
389 
390 /**
391  * @dev Required interface of an ERC721 compliant contract.
392  */
393 interface IERC721 is IERC165 {
394     /**
395      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
396      */
397     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
398 
399     /**
400      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
401      */
402     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
403 
404     /**
405      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
406      */
407     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
408 
409     /**
410      * @dev Returns the number of tokens in ``owner``'s account.
411      */
412     function balanceOf(address owner) external view returns (uint256 balance);
413 
414     /**
415      * @dev Returns the owner of the `tokenId` token.
416      *
417      * Requirements:
418      *
419      * - `tokenId` must exist.
420      */
421     function ownerOf(uint256 tokenId) external view returns (address owner);
422 
423     /**
424      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
425      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
426      *
427      * Requirements:
428      *
429      * - `from` cannot be the zero address.
430      * - `to` cannot be the zero address.
431      * - `tokenId` token must exist and be owned by `from`.
432      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
433      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
434      *
435      * Emits a {Transfer} event.
436      */
437     function safeTransferFrom(
438         address from,
439         address to,
440         uint256 tokenId
441     ) external;
442 
443     /**
444      * @dev Transfers `tokenId` token from `from` to `to`.
445      *
446      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
447      *
448      * Requirements:
449      *
450      * - `from` cannot be the zero address.
451      * - `to` cannot be the zero address.
452      * - `tokenId` token must be owned by `from`.
453      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
454      *
455      * Emits a {Transfer} event.
456      */
457     function transferFrom(
458         address from,
459         address to,
460         uint256 tokenId
461     ) external;
462 
463     /**
464      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
465      * The approval is cleared when the token is transferred.
466      *
467      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
468      *
469      * Requirements:
470      *
471      * - The caller must own the token or be an approved operator.
472      * - `tokenId` must exist.
473      *
474      * Emits an {Approval} event.
475      */
476     function approve(address to, uint256 tokenId) external;
477 
478     /**
479      * @dev Returns the account approved for `tokenId` token.
480      *
481      * Requirements:
482      *
483      * - `tokenId` must exist.
484      */
485     function getApproved(uint256 tokenId) external view returns (address operator);
486 
487     /**
488      * @dev Approve or remove `operator` as an operator for the caller.
489      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
490      *
491      * Requirements:
492      *
493      * - The `operator` cannot be the caller.
494      *
495      * Emits an {ApprovalForAll} event.
496      */
497     function setApprovalForAll(address operator, bool _approved) external;
498 
499     /**
500      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
501      *
502      * See {setApprovalForAll}
503      */
504     function isApprovedForAll(address owner, address operator) external view returns (bool);
505 
506     /**
507      * @dev Safely transfers `tokenId` token from `from` to `to`.
508      *
509      * Requirements:
510      *
511      * - `from` cannot be the zero address.
512      * - `to` cannot be the zero address.
513      * - `tokenId` token must exist and be owned by `from`.
514      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
515      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
516      *
517      * Emits a {Transfer} event.
518      */
519     function safeTransferFrom(
520         address from,
521         address to,
522         uint256 tokenId,
523         bytes calldata data
524     ) external;
525 }
526 
527 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
528 
529 
530 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
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
549     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
550 
551     /**
552      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
553      * Use along with {totalSupply} to enumerate all tokens.
554      */
555     function tokenByIndex(uint256 index) external view returns (uint256);
556 }
557 
558 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
559 
560 
561 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
562 
563 pragma solidity ^0.8.0;
564 
565 
566 /**
567  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
568  * @dev See https://eips.ethereum.org/EIPS/eip-721
569  */
570 interface IERC721Metadata is IERC721 {
571     /**
572      * @dev Returns the token collection name.
573      */
574     function name() external view returns (string memory);
575 
576     /**
577      * @dev Returns the token collection symbol.
578      */
579     function symbol() external view returns (string memory);
580 
581     /**
582      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
583      */
584     function tokenURI(uint256 tokenId) external view returns (string memory);
585 }
586 
587 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
588 
589 
590 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
591 
592 pragma solidity ^0.8.0;
593 
594 /**
595  * @dev Contract module that helps prevent reentrant calls to a function.
596  *
597  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
598  * available, which can be applied to functions to make sure there are no nested
599  * (reentrant) calls to them.
600  *
601  * Note that because there is a single `nonReentrant` guard, functions marked as
602  * `nonReentrant` may not call one another. This can be worked around by making
603  * those functions `private`, and then adding `external` `nonReentrant` entry
604  * points to them.
605  *
606  * TIP: If you would like to learn more about reentrancy and alternative ways
607  * to protect against it, check out our blog post
608  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
609  */
610 abstract contract ReentrancyGuard {
611     // Booleans are more expensive than uint256 or any type that takes up a full
612     // word because each write operation emits an extra SLOAD to first read the
613     // slot's contents, replace the bits taken up by the boolean, and then write
614     // back. This is the compiler's defense against contract upgrades and
615     // pointer aliasing, and it cannot be disabled.
616 
617     // The values being non-zero value makes deployment a bit more expensive,
618     // but in exchange the refund on every call to nonReentrant will be lower in
619     // amount. Since refunds are capped to a percentage of the total
620     // transaction's gas, it is best to keep them low in cases like this one, to
621     // increase the likelihood of the full refund coming into effect.
622     uint256 private constant _NOT_ENTERED = 1;
623     uint256 private constant _ENTERED = 2;
624 
625     uint256 private _status;
626 
627     constructor() {
628         _status = _NOT_ENTERED;
629     }
630 
631     /**
632      * @dev Prevents a contract from calling itself, directly or indirectly.
633      * Calling a `nonReentrant` function from another `nonReentrant`
634      * function is not supported. It is possible to prevent this from happening
635      * by making the `nonReentrant` function external, and making it call a
636      * `private` function that does the actual work.
637      */
638     modifier nonReentrant() {
639         // On the first call to nonReentrant, _notEntered will be true
640         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
641 
642         // Any calls to nonReentrant after this point will fail
643         _status = _ENTERED;
644 
645         _;
646 
647         // By storing the original value once again, a refund is triggered (see
648         // https://eips.ethereum.org/EIPS/eip-2200)
649         _status = _NOT_ENTERED;
650     }
651 }
652 
653 // File: @openzeppelin/contracts/utils/Context.sol
654 
655 
656 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
657 
658 pragma solidity ^0.8.0;
659 
660 /**
661  * @dev Provides information about the current execution context, including the
662  * sender of the transaction and its data. While these are generally available
663  * via msg.sender and msg.data, they should not be accessed in such a direct
664  * manner, since when dealing with meta-transactions the account sending and
665  * paying for execution may not be the actual sender (as far as an application
666  * is concerned).
667  *
668  * This contract is only required for intermediate, library-like contracts.
669  */
670 abstract contract Context {
671     function _msgSender() internal view virtual returns (address) {
672         return msg.sender;
673     }
674 
675     function _msgData() internal view virtual returns (bytes calldata) {
676         return msg.data;
677     }
678 }
679 
680 // File: contracts/ERC721A.sol
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
694 /**
695  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
696  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
697  *
698  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
699  *
700  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
701  *
702  * Does not support burning tokens to address(0).
703  */
704 contract ERC721A is
705   Context,
706   ERC165,
707   IERC721,
708   IERC721Metadata,
709   IERC721Enumerable
710 {
711   using Address for address;
712   using Strings for uint256;
713 
714   struct TokenOwnership {
715     address addr;
716     uint64 startTimestamp;
717   }
718 
719   struct AddressData {
720     uint128 balance;
721     uint128 numberMinted;
722   }
723 
724   uint256 private currentIndex = 0;
725 
726   uint256 internal immutable collectionSize;
727   uint256 internal immutable maxBatchSize;
728 
729   // Token name
730   string private _name;
731 
732   // Token symbol
733   string private _symbol;
734 
735   // Mapping from token ID to ownership details
736   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
737   mapping(uint256 => TokenOwnership) private _ownerships;
738 
739   // Mapping owner address to address data
740   mapping(address => AddressData) private _addressData;
741 
742   // Mapping from token ID to approved address
743   mapping(uint256 => address) private _tokenApprovals;
744 
745   // Mapping from owner to operator approvals
746   mapping(address => mapping(address => bool)) private _operatorApprovals;
747 
748   /**
749    * @dev
750    * `maxBatchSize` refers to how much a minter can mint at a time.
751    * `collectionSize_` refers to how many tokens are in the collection.
752    */
753   constructor(
754     string memory name_,
755     string memory symbol_,
756     uint256 maxBatchSize_,
757     uint256 collectionSize_
758   ) {
759     require(
760       collectionSize_ > 0,
761       "ERC721A: collection must have a nonzero supply"
762     );
763     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
764     _name = name_;
765     _symbol = symbol_;
766     maxBatchSize = maxBatchSize_;
767     collectionSize = collectionSize_;
768   }
769 
770   /**
771    * @dev See {IERC721Enumerable-totalSupply}.
772    */
773   function totalSupply() public view override returns (uint256) {
774     return currentIndex;
775   }
776 
777   /**
778    * @dev See {IERC721Enumerable-tokenByIndex}.
779    */
780   function tokenByIndex(uint256 index) public view override returns (uint256) {
781     require(index < totalSupply(), "ERC721A: global index out of bounds");
782     return index;
783   }
784 
785   /**
786    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
787    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
788    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
789    */
790   function tokenOfOwnerByIndex(address owner, uint256 index)
791     public
792     view
793     override
794     returns (uint256)
795   {
796     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
797     uint256 numMintedSoFar = totalSupply();
798     uint256 tokenIdsIdx = 0;
799     address currOwnershipAddr = address(0);
800     for (uint256 i = 0; i < numMintedSoFar; i++) {
801       TokenOwnership memory ownership = _ownerships[i];
802       if (ownership.addr != address(0)) {
803         currOwnershipAddr = ownership.addr;
804       }
805       if (currOwnershipAddr == owner) {
806         if (tokenIdsIdx == index) {
807           return i;
808         }
809         tokenIdsIdx++;
810       }
811     }
812     revert("ERC721A: unable to get token of owner by index");
813   }
814 
815   /**
816    * @dev See {IERC165-supportsInterface}.
817    */
818   function supportsInterface(bytes4 interfaceId)
819     public
820     view
821     virtual
822     override(ERC165, IERC165)
823     returns (bool)
824   {
825     return
826       interfaceId == type(IERC721).interfaceId ||
827       interfaceId == type(IERC721Metadata).interfaceId ||
828       interfaceId == type(IERC721Enumerable).interfaceId ||
829       super.supportsInterface(interfaceId);
830   }
831 
832   /**
833    * @dev See {IERC721-balanceOf}.
834    */
835   function balanceOf(address owner) public view override returns (uint256) {
836     require(owner != address(0), "ERC721A: balance query for the zero address");
837     return uint256(_addressData[owner].balance);
838   }
839 
840   function _numberMinted(address owner) internal view returns (uint256) {
841     require(
842       owner != address(0),
843       "ERC721A: number minted query for the zero address"
844     );
845     return uint256(_addressData[owner].numberMinted);
846   }
847 
848   function ownershipOf(uint256 tokenId)
849     internal
850     view
851     returns (TokenOwnership memory)
852   {
853     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
854 
855     uint256 lowestTokenToCheck;
856     if (tokenId >= maxBatchSize) {
857       lowestTokenToCheck = tokenId - maxBatchSize + 1;
858     }
859 
860     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
861       TokenOwnership memory ownership = _ownerships[curr];
862       if (ownership.addr != address(0)) {
863         return ownership;
864       }
865     }
866 
867     revert("ERC721A: unable to determine the owner of token");
868   }
869 
870   /**
871    * @dev See {IERC721-ownerOf}.
872    */
873   function ownerOf(uint256 tokenId) public view override returns (address) {
874     return ownershipOf(tokenId).addr;
875   }
876 
877   /**
878    * @dev See {IERC721Metadata-name}.
879    */
880   function name() public view virtual override returns (string memory) {
881     return _name;
882   }
883 
884   /**
885    * @dev See {IERC721Metadata-symbol}.
886    */
887   function symbol() public view virtual override returns (string memory) {
888     return _symbol;
889   }
890 
891   /**
892    * @dev See {IERC721Metadata-tokenURI}.
893    */
894   function tokenURI(uint256 tokenId)
895     public
896     view
897     virtual
898     override
899     returns (string memory)
900   {
901     require(
902       _exists(tokenId),
903       "ERC721Metadata: URI query for nonexistent token"
904     );
905 
906     string memory baseURI = _baseURI();
907     return
908       bytes(baseURI).length > 0
909         ? string(abi.encodePacked(baseURI, tokenId.toString()))
910         : "";
911   }
912 
913   /**
914    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
915    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
916    * by default, can be overriden in child contracts.
917    */
918   function _baseURI() internal view virtual returns (string memory) {
919     return "";
920   }
921 
922   /**
923    * @dev See {IERC721-approve}.
924    */
925   function approve(address to, uint256 tokenId) public override {
926     address owner = ERC721A.ownerOf(tokenId);
927     require(to != owner, "ERC721A: approval to current owner");
928 
929     require(
930       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
931       "ERC721A: approve caller is not owner nor approved for all"
932     );
933 
934     _approve(to, tokenId, owner);
935   }
936 
937   /**
938    * @dev See {IERC721-getApproved}.
939    */
940   function getApproved(uint256 tokenId) public view override returns (address) {
941     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
942 
943     return _tokenApprovals[tokenId];
944   }
945 
946   /**
947    * @dev See {IERC721-setApprovalForAll}.
948    */
949   function setApprovalForAll(address operator, bool approved) public override {
950     require(operator != _msgSender(), "ERC721A: approve to caller");
951 
952     _operatorApprovals[_msgSender()][operator] = approved;
953     emit ApprovalForAll(_msgSender(), operator, approved);
954   }
955 
956   /**
957    * @dev See {IERC721-isApprovedForAll}.
958    */
959   function isApprovedForAll(address owner, address operator)
960     public
961     view
962     virtual
963     override
964     returns (bool)
965   {
966     return _operatorApprovals[owner][operator];
967   }
968 
969   /**
970    * @dev See {IERC721-transferFrom}.
971    */
972   function transferFrom(
973     address from,
974     address to,
975     uint256 tokenId
976   ) public override {
977     _transfer(from, to, tokenId);
978   }
979 
980   /**
981    * @dev See {IERC721-safeTransferFrom}.
982    */
983   function safeTransferFrom(
984     address from,
985     address to,
986     uint256 tokenId
987   ) public override {
988     safeTransferFrom(from, to, tokenId, "");
989   }
990 
991   /**
992    * @dev See {IERC721-safeTransferFrom}.
993    */
994   function safeTransferFrom(
995     address from,
996     address to,
997     uint256 tokenId,
998     bytes memory _data
999   ) public override {
1000     _transfer(from, to, tokenId);
1001     require(
1002       _checkOnERC721Received(from, to, tokenId, _data),
1003       "ERC721A: transfer to non ERC721Receiver implementer"
1004     );
1005   }
1006 
1007   /**
1008    * @dev Returns whether `tokenId` exists.
1009    *
1010    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1011    *
1012    * Tokens start existing when they are minted (`_mint`),
1013    */
1014   function _exists(uint256 tokenId) internal view returns (bool) {
1015     return tokenId < currentIndex;
1016   }
1017 
1018   function _safeMint(address to, uint256 quantity) internal {
1019     _safeMint(to, quantity, "");
1020   }
1021 
1022   /**
1023    * @dev Mints `quantity` tokens and transfers them to `to`.
1024    *
1025    * Requirements:
1026    *
1027    * - there must be `quantity` tokens remaining unminted in the total collection.
1028    * - `to` cannot be the zero address.
1029    * - `quantity` cannot be larger than the max batch size.
1030    *
1031    * Emits a {Transfer} event.
1032    */
1033   function _safeMint(
1034     address to,
1035     uint256 quantity,
1036     bytes memory _data
1037   ) internal {
1038     uint256 startTokenId = currentIndex;
1039     require(to != address(0), "ERC721A: mint to the zero address");
1040     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1041     require(!_exists(startTokenId), "ERC721A: token already minted");
1042     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1043 
1044     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1045 
1046     AddressData memory addressData = _addressData[to];
1047     _addressData[to] = AddressData(
1048       addressData.balance + uint128(quantity),
1049       addressData.numberMinted + uint128(quantity)
1050     );
1051     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1052 
1053     uint256 updatedIndex = startTokenId;
1054 
1055     for (uint256 i = 0; i < quantity; i++) {
1056       emit Transfer(address(0), to, updatedIndex);
1057       require(
1058         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1059         "ERC721A: transfer to non ERC721Receiver implementer"
1060       );
1061       updatedIndex++;
1062     }
1063 
1064     currentIndex = updatedIndex;
1065     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1066   }
1067 
1068   /**
1069    * @dev Transfers `tokenId` from `from` to `to`.
1070    *
1071    * Requirements:
1072    *
1073    * - `to` cannot be the zero address.
1074    * - `tokenId` token must be owned by `from`.
1075    *
1076    * Emits a {Transfer} event.
1077    */
1078   function _transfer(
1079     address from,
1080     address to,
1081     uint256 tokenId
1082   ) private {
1083     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1084 
1085     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1086       getApproved(tokenId) == _msgSender() ||
1087       isApprovedForAll(prevOwnership.addr, _msgSender()));
1088 
1089     require(
1090       isApprovedOrOwner,
1091       "ERC721A: transfer caller is not owner nor approved"
1092     );
1093 
1094     require(
1095       prevOwnership.addr == from,
1096       "ERC721A: transfer from incorrect owner"
1097     );
1098     require(to != address(0), "ERC721A: transfer to the zero address");
1099 
1100     _beforeTokenTransfers(from, to, tokenId, 1);
1101 
1102     // Clear approvals from the previous owner
1103     _approve(address(0), tokenId, prevOwnership.addr);
1104 
1105     _addressData[from].balance -= 1;
1106     _addressData[to].balance += 1;
1107     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1108 
1109     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1110     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1111     uint256 nextTokenId = tokenId + 1;
1112     if (_ownerships[nextTokenId].addr == address(0)) {
1113       if (_exists(nextTokenId)) {
1114         _ownerships[nextTokenId] = TokenOwnership(
1115           prevOwnership.addr,
1116           prevOwnership.startTimestamp
1117         );
1118       }
1119     }
1120 
1121     emit Transfer(from, to, tokenId);
1122     _afterTokenTransfers(from, to, tokenId, 1);
1123   }
1124 
1125   /**
1126    * @dev Approve `to` to operate on `tokenId`
1127    *
1128    * Emits a {Approval} event.
1129    */
1130   function _approve(
1131     address to,
1132     uint256 tokenId,
1133     address owner
1134   ) private {
1135     _tokenApprovals[tokenId] = to;
1136     emit Approval(owner, to, tokenId);
1137   }
1138 
1139   uint256 public nextOwnerToExplicitlySet = 0;
1140 
1141   /**
1142    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1143    */
1144   function _setOwnersExplicit(uint256 quantity) internal {
1145     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1146     require(quantity > 0, "quantity must be nonzero");
1147     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1148     if (endIndex > collectionSize - 1) {
1149       endIndex = collectionSize - 1;
1150     }
1151     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1152     require(_exists(endIndex), "not enough minted yet for this cleanup");
1153     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1154       if (_ownerships[i].addr == address(0)) {
1155         TokenOwnership memory ownership = ownershipOf(i);
1156         _ownerships[i] = TokenOwnership(
1157           ownership.addr,
1158           ownership.startTimestamp
1159         );
1160       }
1161     }
1162     nextOwnerToExplicitlySet = endIndex + 1;
1163   }
1164 
1165   /**
1166    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1167    * The call is not executed if the target address is not a contract.
1168    *
1169    * @param from address representing the previous owner of the given token ID
1170    * @param to target address that will receive the tokens
1171    * @param tokenId uint256 ID of the token to be transferred
1172    * @param _data bytes optional data to send along with the call
1173    * @return bool whether the call correctly returned the expected magic value
1174    */
1175   function _checkOnERC721Received(
1176     address from,
1177     address to,
1178     uint256 tokenId,
1179     bytes memory _data
1180   ) private returns (bool) {
1181     if (to.isContract()) {
1182       try
1183         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1184       returns (bytes4 retval) {
1185         return retval == IERC721Receiver(to).onERC721Received.selector;
1186       } catch (bytes memory reason) {
1187         if (reason.length == 0) {
1188           revert("ERC721A: transfer to non ERC721Receiver implementer");
1189         } else {
1190           assembly {
1191             revert(add(32, reason), mload(reason))
1192           }
1193         }
1194       }
1195     } else {
1196       return true;
1197     }
1198   }
1199 
1200   /**
1201    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1202    *
1203    * startTokenId - the first token id to be transferred
1204    * quantity - the amount to be transferred
1205    *
1206    * Calling conditions:
1207    *
1208    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1209    * transferred to `to`.
1210    * - When `from` is zero, `tokenId` will be minted for `to`.
1211    */
1212   function _beforeTokenTransfers(
1213     address from,
1214     address to,
1215     uint256 startTokenId,
1216     uint256 quantity
1217   ) internal virtual {}
1218 
1219   /**
1220    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1221    * minting.
1222    *
1223    * startTokenId - the first token id to be transferred
1224    * quantity - the amount to be transferred
1225    *
1226    * Calling conditions:
1227    *
1228    * - when `from` and `to` are both non-zero.
1229    * - `from` and `to` are never both zero.
1230    */
1231   function _afterTokenTransfers(
1232     address from,
1233     address to,
1234     uint256 startTokenId,
1235     uint256 quantity
1236   ) internal virtual {}
1237 }
1238 // File: @openzeppelin/contracts/access/Ownable.sol
1239 
1240 
1241 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1242 
1243 pragma solidity ^0.8.0;
1244 
1245 
1246 /**
1247  * @dev Contract module which provides a basic access control mechanism, where
1248  * there is an account (an owner) that can be granted exclusive access to
1249  * specific functions.
1250  *
1251  * By default, the owner account will be the one that deploys the contract. This
1252  * can later be changed with {transferOwnership}.
1253  *
1254  * This module is used through inheritance. It will make available the modifier
1255  * `onlyOwner`, which can be applied to your functions to restrict their use to
1256  * the owner.
1257  */
1258 abstract contract Ownable is Context {
1259     address private _owner;
1260 
1261     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1262 
1263     /**
1264      * @dev Initializes the contract setting the deployer as the initial owner.
1265      */
1266     constructor() {
1267         _transferOwnership(_msgSender());
1268     }
1269 
1270     /**
1271      * @dev Returns the address of the current owner.
1272      */
1273     function owner() public view virtual returns (address) {
1274         return _owner;
1275     }
1276 
1277     /**
1278      * @dev Throws if called by any account other than the owner.
1279      */
1280     modifier onlyOwner() {
1281         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1282         _;
1283     }
1284 
1285     /**
1286      * @dev Leaves the contract without owner. It will not be possible to call
1287      * `onlyOwner` functions anymore. Can only be called by the current owner.
1288      *
1289      * NOTE: Renouncing ownership will leave the contract without an owner,
1290      * thereby removing any functionality that is only available to the owner.
1291      */
1292     function renounceOwnership() public virtual onlyOwner {
1293         _transferOwnership(address(0));
1294     }
1295 
1296     /**
1297      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1298      * Can only be called by the current owner.
1299      */
1300     function transferOwnership(address newOwner) public virtual onlyOwner {
1301         require(newOwner != address(0), "Ownable: new owner is the zero address");
1302         _transferOwnership(newOwner);
1303     }
1304 
1305     /**
1306      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1307      * Internal function without access restriction.
1308      */
1309     function _transferOwnership(address newOwner) internal virtual {
1310         address oldOwner = _owner;
1311         _owner = newOwner;
1312         emit OwnershipTransferred(oldOwner, newOwner);
1313     }
1314 }
1315 
1316 // File: contracts/SoulZ.sol
1317 
1318 
1319 
1320 pragma solidity ^0.8.0;
1321 
1322 
1323 
1324 
1325 
1326 contract SoulZ is Ownable, ERC721A, ReentrancyGuard {
1327   uint256 public immutable maxPerAddressDuringMint;
1328   uint256 private immutable amountForDevs;
1329   uint256 private immutable amountForAuctionAndDev;
1330   uint256 private immutable maxPerWhitelist;
1331   uint256 private immutable maxPerCollected;
1332 
1333   struct SaleConfig {
1334     uint32 auctionSaleStartTime;
1335     uint32 whitelistSalesTime;
1336     uint32 publicSaleStartTime;
1337     uint64 whitelistPrice;
1338     uint64 collectedlistPrice;
1339     uint64 publicPrice;
1340     uint32 publicSaleKey;
1341   }
1342 
1343   SaleConfig public saleConfig;
1344 
1345   mapping(address => uint256) public whitelist;
1346   mapping(address => uint256) public collectedlist;
1347 
1348   constructor(
1349     uint256 maxBatchSize_,
1350     uint256 collectionSize_,
1351     uint256 collectedlistBatchSize_,
1352     uint256 whitelistBatchSize_,
1353     uint256 amountForAuctionAndDev_,
1354     uint256 amountForDevs_
1355 
1356   ) ERC721A("SoulZ Monogatari", "SLZM", maxBatchSize_, collectionSize_ ) {
1357     maxPerAddressDuringMint = maxBatchSize_;
1358     maxPerWhitelist = whitelistBatchSize_;
1359     maxPerCollected = collectedlistBatchSize_;
1360     amountForAuctionAndDev = amountForAuctionAndDev_;
1361     amountForDevs = amountForDevs_;
1362     require(
1363       amountForAuctionAndDev_ <= collectionSize_,
1364       "larger collection size needed"
1365     );
1366   }
1367 
1368   modifier callerIsUser() {
1369     require(tx.origin == msg.sender, "The caller is another contract");
1370     _;
1371   }
1372 
1373   function auctionMint(uint256 quantity) external payable callerIsUser {
1374     uint256 _saleStartTime = uint256(saleConfig.auctionSaleStartTime);
1375     require(
1376       _saleStartTime != 0 && block.timestamp >= _saleStartTime,
1377       "sale has not started yet"
1378     );
1379     require(
1380       totalSupply() + quantity <= amountForAuctionAndDev,
1381       "not enough remaining reserved for auction to support desired mint amount"
1382     );
1383     require(
1384       numberMinted(msg.sender) + quantity <= maxPerAddressDuringMint,
1385       "can not mint this many"
1386     );
1387     uint256 totalCost = getAuctionPrice(_saleStartTime) * quantity;
1388     _safeMint(msg.sender, quantity);
1389     refundIfOver(totalCost);
1390   }
1391 
1392     function whitelistMint(uint256 quantity) external payable callerIsUser {
1393     uint256 price = uint256(saleConfig.whitelistPrice);
1394     require(price != 0, "whitelist sale has not begun yet");
1395     require(whitelist[msg.sender] > 0, "not eligible for whitelist mint");
1396     require(totalSupply() + 1 <= collectionSize, "reached max supply");
1397     require(numberMinted(msg.sender) + quantity <= maxPerWhitelist,"Ascended can not mint this many");
1398     whitelist[msg.sender]--;
1399     _safeMint(msg.sender, 1);
1400     refundIfOver(price);
1401   }
1402 
1403     function collectedlistMint(uint256 quantity) external payable callerIsUser {
1404     uint256 price = uint256(saleConfig.collectedlistPrice);
1405     require(price != 0, "Collected sale has not begun yet");
1406     require(collectedlist[msg.sender] > 0, "not eligible for collected mint");
1407     require(totalSupply() + 1 <= collectionSize, "reached max supply");
1408     require(numberMinted(msg.sender) + quantity <= maxPerCollected,"Collected can not mint this many");
1409     collectedlist[msg.sender]--;
1410     _safeMint(msg.sender, 1);
1411     refundIfOver(price);
1412   }
1413 
1414   function publicSaleMint(uint256 quantity, uint256 callerPublicSaleKey)
1415     external
1416     payable
1417     callerIsUser
1418   {
1419     SaleConfig memory config = saleConfig;
1420     uint256 publicSaleKey = uint256(config.publicSaleKey);
1421     uint256 publicPrice = uint256(config.publicPrice);
1422     uint256 publicSaleStartTime = uint256(config.publicSaleStartTime);
1423     require(
1424       publicSaleKey == callerPublicSaleKey,
1425       "called with incorrect public sale key"
1426     );
1427 
1428     require(
1429       isPublicSaleOn(publicPrice, publicSaleKey, publicSaleStartTime),
1430       "public sale has not begun yet"
1431     );
1432     require(totalSupply() + quantity <= collectionSize, "reached max supply");
1433     require(
1434       numberMinted(msg.sender) + quantity <= maxPerAddressDuringMint,
1435       "can not mint this many"
1436     );
1437     _safeMint(msg.sender, quantity);
1438     refundIfOver(publicPrice * quantity);
1439   }
1440 
1441   function refundIfOver(uint256 price) private {
1442     require(msg.value >= price, "Need to send more ETH.");
1443     if (msg.value > price) {
1444       payable(msg.sender).transfer(msg.value - price);
1445     }
1446   }
1447 
1448   function isPublicSaleOn(
1449     uint256 publicPriceWei,
1450     uint256 publicSaleKey,
1451     uint256 publicSaleStartTime
1452   ) public view returns (bool) {
1453     return
1454       publicPriceWei != 0 &&
1455       publicSaleKey != 0 &&
1456       block.timestamp >= publicSaleStartTime;
1457   }
1458 
1459   uint256 public constant AUCTION_START_PRICE = 0.75 ether;
1460   uint256 public constant AUCTION_END_PRICE = 0.2 ether;
1461   uint256 public constant AUCTION_PRICE_CURVE_LENGTH = 720 minutes;
1462   uint256 public constant AUCTION_DROP_INTERVAL = 30 minutes;
1463   uint256 public constant AUCTION_DROP_PER_STEP = 0.05 ether;
1464   
1465   function getAuctionPrice(uint256 _saleStartTime)
1466     public
1467     view
1468     returns (uint256)
1469   {
1470     if (block.timestamp < _saleStartTime) {
1471       return AUCTION_START_PRICE;
1472     }
1473     if (block.timestamp - _saleStartTime >= AUCTION_PRICE_CURVE_LENGTH) {
1474       return AUCTION_END_PRICE;
1475     } else {
1476       uint256 steps = (block.timestamp - _saleStartTime) /
1477         AUCTION_DROP_INTERVAL;
1478       return AUCTION_START_PRICE - (steps * AUCTION_DROP_PER_STEP);
1479     }
1480   }
1481 
1482   function endAuctionAndSetupNonAuctionSaleInfo(
1483     uint64 whitelistPriceWei,
1484     uint64 publicPriceWei,
1485     uint32 whitelistSaleStartTime,
1486     uint32 collectedlistSaleStartTime,
1487     uint32 publicSaleStartTime
1488   ) external onlyOwner {
1489     saleConfig = SaleConfig(
1490       0,
1491       publicSaleStartTime,
1492       whitelistSaleStartTime,
1493       collectedlistSaleStartTime,
1494       whitelistPriceWei,
1495       publicPriceWei,
1496       saleConfig.publicSaleKey
1497     );
1498   }
1499 
1500   function setAuctionSaleStartTime(uint32 timestamp) external onlyOwner {
1501     saleConfig.auctionSaleStartTime = timestamp;
1502   }
1503 
1504   function setPublicSaleKey(uint32 key) external onlyOwner {
1505     saleConfig.publicSaleKey = key;
1506   }
1507 
1508   function seedWhitelist(address[] memory addresses, uint256[] memory numSlots)
1509     external
1510     onlyOwner
1511   {
1512     require(
1513       addresses.length == numSlots.length,
1514       "addresses does not match numSlots length"
1515     );
1516     for (uint256 i = 0; i < addresses.length; i++) {
1517       whitelist[addresses[i]] = numSlots[i];
1518     }
1519   }
1520 
1521   function seedCollectedlist(address[] memory addresses, uint256[] memory numSlots)
1522     external
1523     onlyOwner
1524   {
1525     require(
1526       addresses.length == numSlots.length,
1527       "addresses does not match numSlots length"
1528     );
1529     for (uint256 i = 0; i < addresses.length; i++) {
1530       collectedlist[addresses[i]] = numSlots[i];
1531     }
1532   }
1533 
1534   // For marketing etc.
1535   function devMint(uint256 quantity) external onlyOwner {
1536     require(
1537       totalSupply() + quantity <= amountForDevs,
1538       "too many already minted before dev mint"
1539     );
1540     require(
1541       quantity % maxBatchSize == 0,
1542       "can only mint a multiple of the maxBatchSize"
1543     );
1544     uint256 numChunks = quantity / maxBatchSize;
1545     for (uint256 i = 0; i < numChunks; i++) {
1546       _safeMint(msg.sender, maxBatchSize);
1547     }
1548   }
1549 
1550   // // metadata URI
1551   string private _baseTokenURI;
1552   bool public revealed = false;
1553 
1554   function _baseURI() internal view virtual override returns (string memory) {
1555     return _baseTokenURI;
1556   }
1557 
1558   function setBaseURI(string calldata baseURI) external onlyOwner {
1559     _baseTokenURI = baseURI;
1560   }
1561 
1562   function changeRevealed(bool _revealed) public onlyOwner {
1563     revealed = _revealed;
1564   }
1565   
1566   function tokenURI(uint256 tokenid) public view override returns (string memory) {
1567     require(_exists(tokenid), "ERC721Metadata: URI query for nonexistant token");
1568 
1569     if (revealed) {
1570       string memory baseURI = _baseURI();
1571     return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenid)) : "";
1572     } else {
1573       return string(abi.encodePacked(_baseURI(), "Hidden.json"));
1574     }
1575   }
1576 
1577   
1578     function withdrawToSender() external onlyOwner {
1579         uint256 balance = address(this).balance;
1580         payable(msg.sender).transfer(balance);
1581     }
1582 
1583     function withdraw() external onlyOwner {
1584         address[8] memory addresses = [
1585             0x2bC46E31a324AB9a208B3B0Fb91958E390DC0797,
1586             0x897C456868d4888c258528f8660b932804Cb6948,
1587             0xc0524078b6ABC601158bFc328c9A2B64Ee376e23,
1588             0x8FE4A152939Ece65f1fC651e57b8aA84cFc137C2,
1589             0x29d54F704a4253B5c3a8aE6CBDFDb01472119713,
1590             0x896baBEE76dBdF3F6d3b7470ad1e47e8c2016BDB,
1591             0xE892C48B5CdD20F50dbFdF4A949c649Aee9F24Da,
1592             0x24e21ae83ccB58EbAE990Cf1e014e062F6bb7B19
1593         ];
1594 
1595         uint256[8] memory shares = [
1596             uint256(2),
1597             uint256(2),
1598             uint256(3),
1599             uint256(3),
1600             uint256(10),
1601             uint256(60),
1602             uint256(60),
1603             uint256(60)
1604         ];
1605 
1606         uint256 balance = address(this).balance;
1607 
1608         for (uint256 i = 0; i < addresses.length; i++) {
1609             uint256 amount = i == addresses.length - 1 ? address(this).balance : balance * shares[i] / 200;
1610             payable(addresses[i]).transfer(amount);
1611         }
1612     }
1613 
1614   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1615     _setOwnersExplicit(quantity);
1616   }
1617 
1618   function numberMinted(address owner) public view returns (uint256) {
1619     return _numberMinted(owner);
1620   }
1621 
1622   function getOwnershipData(uint256 tokenId)
1623     external
1624     view
1625     returns (TokenOwnership memory)
1626   {
1627     return ownershipOf(tokenId);
1628   }
1629 }