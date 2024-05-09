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
682 pragma solidity ^0.8.0;
683 
684 
685 
686 
687 
688 
689 
690 
691 
692 /**
693  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
694  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
695  *
696  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
697  *
698  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
699  *
700  * Does not support burning tokens to address(0).
701  */
702 contract ERC721A is
703   Context,
704   ERC165,
705   IERC721,
706   IERC721Metadata,
707   IERC721Enumerable
708 {
709   using Address for address;
710   using Strings for uint256;
711 
712   struct TokenOwnership {
713     address addr;
714     uint64 startTimestamp;
715   }
716 
717   struct AddressData {
718     uint128 balance;
719     uint128 numberMinted;
720   }
721 
722   uint256 private currentIndex = 0;
723 
724   uint256 internal collectionSize;
725   uint256 internal maxBatchSize;
726 
727   // Token name
728   string private _name;
729 
730   // Token symbol
731   string private _symbol;
732 
733   // Mapping from token ID to ownership details
734   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
735   mapping(uint256 => TokenOwnership) private _ownerships;
736 
737   // Mapping owner address to address data
738   mapping(address => AddressData) private _addressData;
739 
740   // Mapping from token ID to approved address
741   mapping(uint256 => address) private _tokenApprovals;
742 
743   // Mapping from owner to operator approvals
744   mapping(address => mapping(address => bool)) private _operatorApprovals;
745 
746   /**
747    * @dev
748    * `maxBatchSize` refers to how much a minter can mint at a time.
749    * `collectionSize_` refers to how many tokens are in the collection.
750    */
751   constructor(
752     string memory name_,
753     string memory symbol_,
754     uint256 maxBatchSize_,
755     uint256 collectionSize_
756   ) {
757     require(
758       collectionSize_ > 0,
759       "ERC721A: collection must have a nonzero supply"
760     );
761     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
762     _name = name_;
763     _symbol = symbol_;
764     maxBatchSize = maxBatchSize_;
765     collectionSize = collectionSize_;
766   }
767 
768    /**
769    * @dev See maxBatchSize Functionality..
770    */
771   function changeMaxBatchSize(uint256 newBatch) public{
772     maxBatchSize = newBatch;
773   }
774 
775   function changeCollectionSize(uint256 newCollectionSize) public{
776     collectionSize = newCollectionSize;
777   }
778 
779   /**
780    * @dev See {IERC721Enumerable-totalSupply}.
781    */
782   function totalSupply() public view override returns (uint256) {
783     return currentIndex;
784   }
785 
786   /**
787    * @dev See {IERC721Enumerable-tokenByIndex}.
788    */
789   function tokenByIndex(uint256 index) public view override returns (uint256) {
790     require(index < totalSupply(), "ERC721A: global index out of bounds");
791     return index;
792   }
793 
794   /**
795    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
796    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
797    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
798    */
799   function tokenOfOwnerByIndex(address owner, uint256 index)
800     public
801     view
802     override
803     returns (uint256)
804   {
805     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
806     uint256 numMintedSoFar = totalSupply();
807     uint256 tokenIdsIdx = 0;
808     address currOwnershipAddr = address(0);
809     for (uint256 i = 0; i < numMintedSoFar; i++) {
810       TokenOwnership memory ownership = _ownerships[i];
811       if (ownership.addr != address(0)) {
812         currOwnershipAddr = ownership.addr;
813       }
814       if (currOwnershipAddr == owner) {
815         if (tokenIdsIdx == index) {
816           return i;
817         }
818         tokenIdsIdx++;
819       }
820     }
821     revert("ERC721A: unable to get token of owner by index");
822   }
823 
824   /**
825    * @dev See {IERC165-supportsInterface}.
826    */
827   function supportsInterface(bytes4 interfaceId)
828     public
829     view
830     virtual
831     override(ERC165, IERC165)
832     returns (bool)
833   {
834     return
835       interfaceId == type(IERC721).interfaceId ||
836       interfaceId == type(IERC721Metadata).interfaceId ||
837       interfaceId == type(IERC721Enumerable).interfaceId ||
838       super.supportsInterface(interfaceId);
839   }
840 
841   /**
842    * @dev See {IERC721-balanceOf}.
843    */
844   function balanceOf(address owner) public view override returns (uint256) {
845     require(owner != address(0), "ERC721A: balance query for the zero address");
846     return uint256(_addressData[owner].balance);
847   }
848 
849   function _numberMinted(address owner) internal view returns (uint256) {
850     require(
851       owner != address(0),
852       "ERC721A: number minted query for the zero address"
853     );
854     return uint256(_addressData[owner].numberMinted);
855   }
856 
857   function ownershipOf(uint256 tokenId)
858     internal
859     view
860     returns (TokenOwnership memory)
861   {
862     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
863 
864     uint256 lowestTokenToCheck;
865     if (tokenId >= maxBatchSize) {
866       lowestTokenToCheck = tokenId - maxBatchSize + 1;
867     }
868 
869     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
870       TokenOwnership memory ownership = _ownerships[curr];
871       if (ownership.addr != address(0)) {
872         return ownership;
873       }
874     }
875 
876     revert("ERC721A: unable to determine the owner of token");
877   }
878 
879   /**
880    * @dev See {IERC721-ownerOf}.
881    */
882   function ownerOf(uint256 tokenId) public view override returns (address) {
883     return ownershipOf(tokenId).addr;
884   }
885 
886   /**
887    * @dev See {IERC721Metadata-name}.
888    */
889   function name() public view virtual override returns (string memory) {
890     return _name;
891   }
892 
893   /**
894    * @dev See {IERC721Metadata-symbol}.
895    */
896   function symbol() public view virtual override returns (string memory) {
897     return _symbol;
898   }
899 
900   /**
901    * @dev See {IERC721Metadata-tokenURI}.
902    */
903   function tokenURI(uint256 tokenId)
904     public
905     view
906     virtual
907     override
908     returns (string memory)
909   {
910     require(
911       _exists(tokenId),
912       "ERC721Metadata: URI query for nonexistent token"
913     );
914 
915     string memory baseURI = _baseURI();
916     return
917       bytes(baseURI).length > 0
918         ? string(abi.encodePacked(baseURI, tokenId.toString()))
919         : "";
920   }
921 
922   /**
923    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
924    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
925    * by default, can be overriden in child contracts.
926    */
927   function _baseURI() internal view virtual returns (string memory) {
928     return "";
929   }
930 
931   /**
932    * @dev See {IERC721-approve}.
933    */
934   function approve(address to, uint256 tokenId) public override {
935     address owner = ERC721A.ownerOf(tokenId);
936     require(to != owner, "ERC721A: approval to current owner");
937 
938     require(
939       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
940       "ERC721A: approve caller is not owner nor approved for all"
941     );
942 
943     _approve(to, tokenId, owner);
944   }
945 
946   /**
947    * @dev See {IERC721-getApproved}.
948    */
949   function getApproved(uint256 tokenId) public view override returns (address) {
950     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
951 
952     return _tokenApprovals[tokenId];
953   }
954 
955   /**
956    * @dev See {IERC721-setApprovalForAll}.
957    */
958   function setApprovalForAll(address operator, bool approved) public override {
959     require(operator != _msgSender(), "ERC721A: approve to caller");
960 
961     _operatorApprovals[_msgSender()][operator] = approved;
962     emit ApprovalForAll(_msgSender(), operator, approved);
963   }
964 
965   /**
966    * @dev See {IERC721-isApprovedForAll}.
967    */
968   function isApprovedForAll(address owner, address operator)
969     public
970     view
971     virtual
972     override
973     returns (bool)
974   {
975     return _operatorApprovals[owner][operator];
976   }
977 
978   /**
979    * @dev See {IERC721-transferFrom}.
980    */
981   function transferFrom(
982     address from,
983     address to,
984     uint256 tokenId
985   ) public override {
986     _transfer(from, to, tokenId);
987   }
988 
989   /**
990    * @dev See {IERC721-safeTransferFrom}.
991    */
992   function safeTransferFrom(
993     address from,
994     address to,
995     uint256 tokenId
996   ) public override {
997     safeTransferFrom(from, to, tokenId, "");
998   }
999 
1000   /**
1001    * @dev See {IERC721-safeTransferFrom}.
1002    */
1003   function safeTransferFrom(
1004     address from,
1005     address to,
1006     uint256 tokenId,
1007     bytes memory _data
1008   ) public override {
1009     _transfer(from, to, tokenId);
1010     require(
1011       _checkOnERC721Received(from, to, tokenId, _data),
1012       "ERC721A: transfer to non ERC721Receiver implementer"
1013     );
1014   }
1015 
1016   /**
1017    * @dev Returns whether `tokenId` exists.
1018    *
1019    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1020    *
1021    * Tokens start existing when they are minted (`_mint`),
1022    */
1023   function _exists(uint256 tokenId) internal view returns (bool) {
1024     return tokenId < currentIndex;
1025   }
1026 
1027   function _safeMint(address to, uint256 quantity) internal {
1028     _safeMint(to, quantity, "");
1029   }
1030 
1031   /**
1032    * @dev Mints `quantity` tokens and transfers them to `to`.
1033    *
1034    * Requirements:
1035    *
1036    * - there must be `quantity` tokens remaining unminted in the total collection.
1037    * - `to` cannot be the zero address.
1038    * - `quantity` cannot be larger than the max batch size.
1039    *
1040    * Emits a {Transfer} event.
1041    */
1042   function _safeMint(
1043     address to,
1044     uint256 quantity,
1045     bytes memory _data
1046   ) internal {
1047     uint256 startTokenId = currentIndex;
1048     require(to != address(0), "ERC721A: mint to the zero address");
1049     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1050     require(!_exists(startTokenId), "ERC721A: token already minted");
1051     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1052 
1053     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1054 
1055     AddressData memory addressData = _addressData[to];
1056     _addressData[to] = AddressData(
1057       addressData.balance + uint128(quantity),
1058       addressData.numberMinted + uint128(quantity)
1059     );
1060     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1061 
1062     uint256 updatedIndex = startTokenId;
1063 
1064     for (uint256 i = 0; i < quantity; i++) {
1065       emit Transfer(address(0), to, updatedIndex);
1066       require(
1067         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1068         "ERC721A: transfer to non ERC721Receiver implementer"
1069       );
1070       updatedIndex++;
1071     }
1072 
1073     currentIndex = updatedIndex;
1074     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1075   }
1076 
1077   /**
1078    * @dev Transfers `tokenId` from `from` to `to`.
1079    *
1080    * Requirements:
1081    *
1082    * - `to` cannot be the zero address.
1083    * - `tokenId` token must be owned by `from`.
1084    *
1085    * Emits a {Transfer} event.
1086    */
1087   function _transfer(
1088     address from,
1089     address to,
1090     uint256 tokenId
1091   ) private {
1092     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1093 
1094     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1095       getApproved(tokenId) == _msgSender() ||
1096       isApprovedForAll(prevOwnership.addr, _msgSender()));
1097 
1098     require(
1099       isApprovedOrOwner,
1100       "ERC721A: transfer caller is not owner nor approved"
1101     );
1102 
1103     require(
1104       prevOwnership.addr == from,
1105       "ERC721A: transfer from incorrect owner"
1106     );
1107     require(to != address(0), "ERC721A: transfer to the zero address");
1108 
1109     _beforeTokenTransfers(from, to, tokenId, 1);
1110 
1111     // Clear approvals from the previous owner
1112     _approve(address(0), tokenId, prevOwnership.addr);
1113 
1114     _addressData[from].balance -= 1;
1115     _addressData[to].balance += 1;
1116     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1117 
1118     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1119     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1120     uint256 nextTokenId = tokenId + 1;
1121     if (_ownerships[nextTokenId].addr == address(0)) {
1122       if (_exists(nextTokenId)) {
1123         _ownerships[nextTokenId] = TokenOwnership(
1124           prevOwnership.addr,
1125           prevOwnership.startTimestamp
1126         );
1127       }
1128     }
1129 
1130     emit Transfer(from, to, tokenId);
1131     _afterTokenTransfers(from, to, tokenId, 1);
1132   }
1133 
1134   /**
1135    * @dev Approve `to` to operate on `tokenId`
1136    *
1137    * Emits a {Approval} event.
1138    */
1139   function _approve(
1140     address to,
1141     uint256 tokenId,
1142     address owner
1143   ) private {
1144     _tokenApprovals[tokenId] = to;
1145     emit Approval(owner, to, tokenId);
1146   }
1147 
1148   uint256 public nextOwnerToExplicitlySet = 0;
1149 
1150   /**
1151    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1152    */
1153   function _setOwnersExplicit(uint256 quantity) internal {
1154     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1155     require(quantity > 0, "quantity must be nonzero");
1156     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1157     if (endIndex > collectionSize - 1) {
1158       endIndex = collectionSize - 1;
1159     }
1160     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1161     require(_exists(endIndex), "not enough minted yet for this cleanup");
1162     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1163       if (_ownerships[i].addr == address(0)) {
1164         TokenOwnership memory ownership = ownershipOf(i);
1165         _ownerships[i] = TokenOwnership(
1166           ownership.addr,
1167           ownership.startTimestamp
1168         );
1169       }
1170     }
1171     nextOwnerToExplicitlySet = endIndex + 1;
1172   }
1173 
1174   /**
1175    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1176    * The call is not executed if the target address is not a contract.
1177    *
1178    * @param from address representing the previous owner of the given token ID
1179    * @param to target address that will receive the tokens
1180    * @param tokenId uint256 ID of the token to be transferred
1181    * @param _data bytes optional data to send along with the call
1182    * @return bool whether the call correctly returned the expected magic value
1183    */
1184   function _checkOnERC721Received(
1185     address from,
1186     address to,
1187     uint256 tokenId,
1188     bytes memory _data
1189   ) private returns (bool) {
1190     if (to.isContract()) {
1191       try
1192         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1193       returns (bytes4 retval) {
1194         return retval == IERC721Receiver(to).onERC721Received.selector;
1195       } catch (bytes memory reason) {
1196         if (reason.length == 0) {
1197           revert("ERC721A: transfer to non ERC721Receiver implementer");
1198         } else {
1199           assembly {
1200             revert(add(32, reason), mload(reason))
1201           }
1202         }
1203       }
1204     } else {
1205       return true;
1206     }
1207   }
1208 
1209   /**
1210    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1211    *
1212    * startTokenId - the first token id to be transferred
1213    * quantity - the amount to be transferred
1214    *
1215    * Calling conditions:
1216    *
1217    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1218    * transferred to `to`.
1219    * - When `from` is zero, `tokenId` will be minted for `to`.
1220    */
1221   function _beforeTokenTransfers(
1222     address from,
1223     address to,
1224     uint256 startTokenId,
1225     uint256 quantity
1226   ) internal virtual {}
1227 
1228   /**
1229    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1230    * minting.
1231    *
1232    * startTokenId - the first token id to be transferred
1233    * quantity - the amount to be transferred
1234    *
1235    * Calling conditions:
1236    *
1237    * - when `from` and `to` are both non-zero.
1238    * - `from` and `to` are never both zero.
1239    */
1240   function _afterTokenTransfers(
1241     address from,
1242     address to,
1243     uint256 startTokenId,
1244     uint256 quantity
1245   ) internal virtual {}
1246 }
1247 // File: @openzeppelin/contracts/access/Ownable.sol
1248 
1249 
1250 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1251 
1252 pragma solidity ^0.8.0;
1253 
1254 
1255 /**
1256  * @dev Contract module which provides a basic access control mechanism, where
1257  * there is an account (an owner) that can be granted exclusive access to
1258  * specific functions.
1259  *
1260  * By default, the owner account will be the one that deploys the contract. This
1261  * can later be changed with {transferOwnership}.
1262  *
1263  * This module is used through inheritance. It will make available the modifier
1264  * `onlyOwner`, which can be applied to your functions to restrict their use to
1265  * the owner.
1266  */
1267 abstract contract Ownable is Context {
1268     address private _owner;
1269 
1270     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1271 
1272     /**
1273      * @dev Initializes the contract setting the deployer as the initial owner.
1274      */
1275     constructor() {
1276         _transferOwnership(_msgSender());
1277     }
1278 
1279     /**
1280      * @dev Returns the address of the current owner.
1281      */
1282     function owner() public view virtual returns (address) {
1283         return _owner;
1284     }
1285 
1286     /**
1287      * @dev Throws if called by any account other than the owner.
1288      */
1289     modifier onlyOwner() {
1290         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1291         _;
1292     }
1293 
1294     /**
1295      * @dev Leaves the contract without owner. It will not be possible to call
1296      * `onlyOwner` functions anymore. Can only be called by the current owner.
1297      *
1298      * NOTE: Renouncing ownership will leave the contract without an owner,
1299      * thereby removing any functionality that is only available to the owner.
1300      */
1301     function renounceOwnership() public virtual onlyOwner {
1302         _transferOwnership(address(0));
1303     }
1304 
1305     /**
1306      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1307      * Can only be called by the current owner.
1308      */
1309     function transferOwnership(address newOwner) public virtual onlyOwner {
1310         require(newOwner != address(0), "Ownable: new owner is the zero address");
1311         _transferOwnership(newOwner);
1312     }
1313 
1314     /**
1315      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1316      * Internal function without access restriction.
1317      */
1318     function _transferOwnership(address newOwner) internal virtual {
1319         address oldOwner = _owner;
1320         _owner = newOwner;
1321         emit OwnershipTransferred(oldOwner, newOwner);
1322     }
1323 }
1324 
1325 // File: contracts/DegeneratesClub.sol
1326 
1327 
1328 
1329 pragma solidity ^0.8.0;
1330 
1331 
1332 
1333 
1334 
1335 contract DegeneratesClub is Ownable, ERC721A, ReentrancyGuard {
1336 
1337   constructor(
1338     uint256 maxBatchSize_,
1339     uint256 collectionSize_,
1340     uint256 amountForAuctionAndDev_,
1341     uint256 amountForDevs_
1342   ) ERC721A("Degenerates Club", "Degens", maxBatchSize_, collectionSize_) {
1343     require(amountForAuctionAndDev_ <= collectionSize_, "larger collection size needed" );
1344   }
1345     
1346     uint256 pricePer = 0.04 ether;
1347     uint256 totalCost;
1348     uint256 maxSupply = 5000;
1349     uint256 saleIsActive = 0;
1350 
1351     function flipSaleState(uint256 num) public onlyOwner {
1352         saleIsActive = num;
1353     }
1354     function setMintPrice(uint256 price) public onlyOwner {
1355         pricePer = price;
1356     }
1357     function maxSupplyChange(uint256 newMax) public onlyOwner {
1358         maxSupply = newMax;
1359     }
1360 
1361     /**
1362      * @dev Public sale mint
1363      * @param quantity Number of tokens to mint
1364      *
1365      * 
1366      * - Degenerates Club members cost 0.04 per mint.
1367      * - 10 can be minted per transaction. Gas fees are real small, if you want more just send another transaction.
1368      * - The contract is constructed to optimize gas.
1369      */
1370   function mint(uint256 quantity) external payable {
1371     require(saleIsActive == 1, 'Sale is not active');
1372     require(quantity <= 10, 'Cant mint more than 10');
1373     require(totalSupply() + quantity <= maxSupply);
1374     require(msg.value >= (pricePer*quantity), 'Not enough Eth sent');
1375     _safeMint(msg.sender, quantity);
1376   }
1377 
1378   function mintMarketing(address toPerson, uint256 quantity) external onlyOwner {
1379     require(saleIsActive == 1, 'Sale is not active');
1380     require(quantity <= 10, 'Cant mint more than 10');
1381     require(totalSupply() + quantity <= maxSupply);
1382     _safeMint(toPerson, quantity);
1383   }
1384 
1385   // // metadata URI
1386   string private _baseTokenURI;
1387 
1388   function _baseURI() internal view virtual override returns (string memory) {
1389     return _baseTokenURI;
1390   }
1391 
1392   function setBaseURI(string calldata baseURI) external onlyOwner {
1393     _baseTokenURI = baseURI;
1394   }
1395 
1396   function withdrawMoney() external onlyOwner nonReentrant {
1397     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1398     require(success, "Transfer failed.");
1399   }
1400 
1401   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1402     _setOwnersExplicit(quantity);
1403   }
1404 
1405   function numberMinted(address owner) public view returns (uint256) {
1406     return _numberMinted(owner);
1407   }
1408 
1409   function getOwnershipData(uint256 tokenId)
1410     external
1411     view
1412     returns (TokenOwnership memory)
1413   {
1414     return ownershipOf(tokenId);
1415   }
1416 }