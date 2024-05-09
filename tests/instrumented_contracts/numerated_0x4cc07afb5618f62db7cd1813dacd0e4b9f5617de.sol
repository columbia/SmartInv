1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 }
71 
72 // File: @openzeppelin/contracts/utils/Address.sol
73 
74 
75 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
76 
77 pragma solidity ^0.8.0;
78 
79 /**
80  * @dev Collection of functions related to the address type
81  */
82 library Address {
83     /**
84      * @dev Returns true if `account` is a contract.
85      *
86      * [IMPORTANT]
87      * ====
88      * It is unsafe to assume that an address for which this function returns
89      * false is an externally-owned account (EOA) and not a contract.
90      *
91      * Among others, `isContract` will return false for the following
92      * types of addresses:
93      *
94      *  - an externally-owned account
95      *  - a contract in construction
96      *  - an address where a contract will be created
97      *  - an address where a contract lived, but was destroyed
98      * ====
99      */
100     function isContract(address account) internal view returns (bool) {
101         // This method relies on extcodesize, which returns 0 for contracts in
102         // construction, since the code is only stored at the end of the
103         // constructor execution.
104 
105         uint256 size;
106         assembly {
107             size := extcodesize(account)
108         }
109         return size > 0;
110     }
111 
112     /**
113      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
114      * `recipient`, forwarding all available gas and reverting on errors.
115      *
116      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
117      * of certain opcodes, possibly making contracts go over the 2300 gas limit
118      * imposed by `transfer`, making them unable to receive funds via
119      * `transfer`. {sendValue} removes this limitation.
120      *
121      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
122      *
123      * IMPORTANT: because control is transferred to `recipient`, care must be
124      * taken to not create reentrancy vulnerabilities. Consider using
125      * {ReentrancyGuard} or the
126      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
127      */
128     function sendValue(address payable recipient, uint256 amount) internal {
129         require(address(this).balance >= amount, "Address: insufficient balance");
130 
131         (bool success, ) = recipient.call{value: amount}("");
132         require(success, "Address: unable to send value, recipient may have reverted");
133     }
134 
135     /**
136      * @dev Performs a Solidity function call using a low level `call`. A
137      * plain `call` is an unsafe replacement for a function call: use this
138      * function instead.
139      *
140      * If `target` reverts with a revert reason, it is bubbled up by this
141      * function (like regular Solidity function calls).
142      *
143      * Returns the raw returned data. To convert to the expected return value,
144      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
145      *
146      * Requirements:
147      *
148      * - `target` must be a contract.
149      * - calling `target` with `data` must not revert.
150      *
151      * _Available since v3.1._
152      */
153     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
154         return functionCall(target, data, "Address: low-level call failed");
155     }
156 
157     /**
158      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
159      * `errorMessage` as a fallback revert reason when `target` reverts.
160      *
161      * _Available since v3.1._
162      */
163     function functionCall(
164         address target,
165         bytes memory data,
166         string memory errorMessage
167     ) internal returns (bytes memory) {
168         return functionCallWithValue(target, data, 0, errorMessage);
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
173      * but also transferring `value` wei to `target`.
174      *
175      * Requirements:
176      *
177      * - the calling contract must have an ETH balance of at least `value`.
178      * - the called Solidity function must be `payable`.
179      *
180      * _Available since v3.1._
181      */
182     function functionCallWithValue(
183         address target,
184         bytes memory data,
185         uint256 value
186     ) internal returns (bytes memory) {
187         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
188     }
189 
190     /**
191      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
192      * with `errorMessage` as a fallback revert reason when `target` reverts.
193      *
194      * _Available since v3.1._
195      */
196     function functionCallWithValue(
197         address target,
198         bytes memory data,
199         uint256 value,
200         string memory errorMessage
201     ) internal returns (bytes memory) {
202         require(address(this).balance >= value, "Address: insufficient balance for call");
203         require(isContract(target), "Address: call to non-contract");
204 
205         (bool success, bytes memory returndata) = target.call{value: value}(data);
206         return verifyCallResult(success, returndata, errorMessage);
207     }
208 
209     /**
210      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
211      * but performing a static call.
212      *
213      * _Available since v3.3._
214      */
215     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
216         return functionStaticCall(target, data, "Address: low-level static call failed");
217     }
218 
219     /**
220      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
221      * but performing a static call.
222      *
223      * _Available since v3.3._
224      */
225     function functionStaticCall(
226         address target,
227         bytes memory data,
228         string memory errorMessage
229     ) internal view returns (bytes memory) {
230         require(isContract(target), "Address: static call to non-contract");
231 
232         (bool success, bytes memory returndata) = target.staticcall(data);
233         return verifyCallResult(success, returndata, errorMessage);
234     }
235 
236     /**
237      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
238      * but performing a delegate call.
239      *
240      * _Available since v3.4._
241      */
242     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
243         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
244     }
245 
246     /**
247      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
248      * but performing a delegate call.
249      *
250      * _Available since v3.4._
251      */
252     function functionDelegateCall(
253         address target,
254         bytes memory data,
255         string memory errorMessage
256     ) internal returns (bytes memory) {
257         require(isContract(target), "Address: delegate call to non-contract");
258 
259         (bool success, bytes memory returndata) = target.delegatecall(data);
260         return verifyCallResult(success, returndata, errorMessage);
261     }
262 
263     /**
264      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
265      * revert reason using the provided one.
266      *
267      * _Available since v4.3._
268      */
269     function verifyCallResult(
270         bool success,
271         bytes memory returndata,
272         string memory errorMessage
273     ) internal pure returns (bytes memory) {
274         if (success) {
275             return returndata;
276         } else {
277             // Look for revert reason and bubble it up if present
278             if (returndata.length > 0) {
279                 // The easiest way to bubble the revert reason is using memory via assembly
280 
281                 assembly {
282                     let returndata_size := mload(returndata)
283                     revert(add(32, returndata), returndata_size)
284                 }
285             } else {
286                 revert(errorMessage);
287             }
288         }
289     }
290 }
291 
292 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
293 
294 
295 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
296 
297 pragma solidity ^0.8.0;
298 
299 /**
300  * @title ERC721 token receiver interface
301  * @dev Interface for any contract that wants to support safeTransfers
302  * from ERC721 asset contracts.
303  */
304 interface IERC721Receiver {
305     /**
306      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
307      * by `operator` from `from`, this function is called.
308      *
309      * It must return its Solidity selector to confirm the token transfer.
310      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
311      *
312      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
313      */
314     function onERC721Received(
315         address operator,
316         address from,
317         uint256 tokenId,
318         bytes calldata data
319     ) external returns (bytes4);
320 }
321 
322 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
323 
324 
325 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
326 
327 pragma solidity ^0.8.0;
328 
329 /**
330  * @dev Interface of the ERC165 standard, as defined in the
331  * https://eips.ethereum.org/EIPS/eip-165[EIP].
332  *
333  * Implementers can declare support of contract interfaces, which can then be
334  * queried by others ({ERC165Checker}).
335  *
336  * For an implementation, see {ERC165}.
337  */
338 interface IERC165 {
339     /**
340      * @dev Returns true if this contract implements the interface defined by
341      * `interfaceId`. See the corresponding
342      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
343      * to learn more about how these ids are created.
344      *
345      * This function call must use less than 30 000 gas.
346      */
347     function supportsInterface(bytes4 interfaceId) external view returns (bool);
348 }
349 
350 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
351 
352 
353 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
354 
355 pragma solidity ^0.8.0;
356 
357 
358 /**
359  * @dev Implementation of the {IERC165} interface.
360  *
361  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
362  * for the additional interface id that will be supported. For example:
363  *
364  * ```solidity
365  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
366  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
367  * }
368  * ```
369  *
370  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
371  */
372 abstract contract ERC165 is IERC165 {
373     /**
374      * @dev See {IERC165-supportsInterface}.
375      */
376     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
377         return interfaceId == type(IERC165).interfaceId;
378     }
379 }
380 
381 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
382 
383 
384 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
385 
386 pragma solidity ^0.8.0;
387 
388 
389 /**
390  * @dev Required interface of an ERC721 compliant contract.
391  */
392 interface IERC721 is IERC165 {
393     /**
394      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
395      */
396     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
397 
398     /**
399      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
400      */
401     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
402 
403     /**
404      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
405      */
406     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
407 
408     /**
409      * @dev Returns the number of tokens in ``owner``'s account.
410      */
411     function balanceOf(address owner) external view returns (uint256 balance);
412 
413     /**
414      * @dev Returns the owner of the `tokenId` token.
415      *
416      * Requirements:
417      *
418      * - `tokenId` must exist.
419      */
420     function ownerOf(uint256 tokenId) external view returns (address owner);
421 
422     /**
423      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
424      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
425      *
426      * Requirements:
427      *
428      * - `from` cannot be the zero address.
429      * - `to` cannot be the zero address.
430      * - `tokenId` token must exist and be owned by `from`.
431      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
432      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
433      *
434      * Emits a {Transfer} event.
435      */
436     function safeTransferFrom(
437         address from,
438         address to,
439         uint256 tokenId
440     ) external;
441 
442     /**
443      * @dev Transfers `tokenId` token from `from` to `to`.
444      *
445      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
446      *
447      * Requirements:
448      *
449      * - `from` cannot be the zero address.
450      * - `to` cannot be the zero address.
451      * - `tokenId` token must be owned by `from`.
452      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
453      *
454      * Emits a {Transfer} event.
455      */
456     function transferFrom(
457         address from,
458         address to,
459         uint256 tokenId
460     ) external;
461 
462     /**
463      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
464      * The approval is cleared when the token is transferred.
465      *
466      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
467      *
468      * Requirements:
469      *
470      * - The caller must own the token or be an approved operator.
471      * - `tokenId` must exist.
472      *
473      * Emits an {Approval} event.
474      */
475     function approve(address to, uint256 tokenId) external;
476 
477     /**
478      * @dev Returns the account approved for `tokenId` token.
479      *
480      * Requirements:
481      *
482      * - `tokenId` must exist.
483      */
484     function getApproved(uint256 tokenId) external view returns (address operator);
485 
486     /**
487      * @dev Approve or remove `operator` as an operator for the caller.
488      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
489      *
490      * Requirements:
491      *
492      * - The `operator` cannot be the caller.
493      *
494      * Emits an {ApprovalForAll} event.
495      */
496     function setApprovalForAll(address operator, bool _approved) external;
497 
498     /**
499      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
500      *
501      * See {setApprovalForAll}
502      */
503     function isApprovedForAll(address owner, address operator) external view returns (bool);
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
524 }
525 
526 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
527 
528 
529 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
530 
531 pragma solidity ^0.8.0;
532 
533 
534 /**
535  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
536  * @dev See https://eips.ethereum.org/EIPS/eip-721
537  */
538 interface IERC721Enumerable is IERC721 {
539     /**
540      * @dev Returns the total amount of tokens stored by the contract.
541      */
542     function totalSupply() external view returns (uint256);
543 
544     /**
545      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
546      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
547      */
548     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
549 
550     /**
551      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
552      * Use along with {totalSupply} to enumerate all tokens.
553      */
554     function tokenByIndex(uint256 index) external view returns (uint256);
555 }
556 
557 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
558 
559 
560 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
561 
562 pragma solidity ^0.8.0;
563 
564 
565 /**
566  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
567  * @dev See https://eips.ethereum.org/EIPS/eip-721
568  */
569 interface IERC721Metadata is IERC721 {
570     /**
571      * @dev Returns the token collection name.
572      */
573     function name() external view returns (string memory);
574 
575     /**
576      * @dev Returns the token collection symbol.
577      */
578     function symbol() external view returns (string memory);
579 
580     /**
581      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
582      */
583     function tokenURI(uint256 tokenId) external view returns (string memory);
584 }
585 
586 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
587 
588 
589 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
590 
591 pragma solidity ^0.8.0;
592 
593 /**
594  * @dev Contract module that helps prevent reentrant calls to a function.
595  *
596  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
597  * available, which can be applied to functions to make sure there are no nested
598  * (reentrant) calls to them.
599  *
600  * Note that because there is a single `nonReentrant` guard, functions marked as
601  * `nonReentrant` may not call one another. This can be worked around by making
602  * those functions `private`, and then adding `external` `nonReentrant` entry
603  * points to them.
604  *
605  * TIP: If you would like to learn more about reentrancy and alternative ways
606  * to protect against it, check out our blog post
607  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
608  */
609 abstract contract ReentrancyGuard {
610     // Booleans are more expensive than uint256 or any type that takes up a full
611     // word because each write operation emits an extra SLOAD to first read the
612     // slot's contents, replace the bits taken up by the boolean, and then write
613     // back. This is the compiler's defense against contract upgrades and
614     // pointer aliasing, and it cannot be disabled.
615 
616     // The values being non-zero value makes deployment a bit more expensive,
617     // but in exchange the refund on every call to nonReentrant will be lower in
618     // amount. Since refunds are capped to a percentage of the total
619     // transaction's gas, it is best to keep them low in cases like this one, to
620     // increase the likelihood of the full refund coming into effect.
621     uint256 private constant _NOT_ENTERED = 1;
622     uint256 private constant _ENTERED = 2;
623 
624     uint256 private _status;
625 
626     constructor() {
627         _status = _NOT_ENTERED;
628     }
629 
630     /**
631      * @dev Prevents a contract from calling itself, directly or indirectly.
632      * Calling a `nonReentrant` function from another `nonReentrant`
633      * function is not supported. It is possible to prevent this from happening
634      * by making the `nonReentrant` function external, and making it call a
635      * `private` function that does the actual work.
636      */
637     modifier nonReentrant() {
638         // On the first call to nonReentrant, _notEntered will be true
639         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
640 
641         // Any calls to nonReentrant after this point will fail
642         _status = _ENTERED;
643 
644         _;
645 
646         // By storing the original value once again, a refund is triggered (see
647         // https://eips.ethereum.org/EIPS/eip-2200)
648         _status = _NOT_ENTERED;
649     }
650 }
651 
652 // File: @openzeppelin/contracts/utils/Context.sol
653 
654 
655 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
656 
657 pragma solidity ^0.8.0;
658 
659 /**
660  * @dev Provides information about the current execution context, including the
661  * sender of the transaction and its data. While these are generally available
662  * via msg.sender and msg.data, they should not be accessed in such a direct
663  * manner, since when dealing with meta-transactions the account sending and
664  * paying for execution may not be the actual sender (as far as an application
665  * is concerned).
666  *
667  * This contract is only required for intermediate, library-like contracts.
668  */
669 abstract contract Context {
670     function _msgSender() internal view virtual returns (address) {
671         return msg.sender;
672     }
673 
674     function _msgData() internal view virtual returns (bytes calldata) {
675         return msg.data;
676     }
677 }
678 
679 // File: contracts/ERC721A.sol
680 
681 
682 // Creators: locationtba.eth, 2pmflow.eth
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
724   uint256 internal immutable collectionSize;
725   uint256 internal immutable maxBatchSize;
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
749    */
750   constructor(
751     string memory name_,
752     string memory symbol_,
753     uint256 maxBatchSize_,
754     uint256 collectionSize_
755   ) {
756     require(
757       collectionSize_ > 0,
758       "ERC721A: collection must have a nonzero supply"
759     );
760     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
761     _name = name_;
762     _symbol = symbol_;
763     maxBatchSize = maxBatchSize_;
764     collectionSize = collectionSize_;
765   }
766 
767   /**
768    * @dev See {IERC721Enumerable-totalSupply}.
769    */
770   function totalSupply() public view override returns (uint256) {
771     return currentIndex;
772   }
773 
774   /**
775    * @dev See {IERC721Enumerable-tokenByIndex}.
776    */
777   function tokenByIndex(uint256 index) public view override returns (uint256) {
778     require(index < totalSupply(), "ERC721A: global index out of bounds");
779     return index;
780   }
781 
782   /**
783    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
784    * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
785    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
786    */
787   function tokenOfOwnerByIndex(address owner, uint256 index)
788     public
789     view
790     override
791     returns (uint256)
792   {
793     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
794     uint256 numMintedSoFar = totalSupply();
795     uint256 tokenIdsIdx = 0;
796     address currOwnershipAddr = address(0);
797     for (uint256 i = 0; i < numMintedSoFar; i++) {
798       TokenOwnership memory ownership = _ownerships[i];
799       if (ownership.addr != address(0)) {
800         currOwnershipAddr = ownership.addr;
801       }
802       if (currOwnershipAddr == owner) {
803         if (tokenIdsIdx == index) {
804           return i;
805         }
806         tokenIdsIdx++;
807       }
808     }
809     revert("ERC721A: unable to get token of owner by index");
810   }
811 
812   /**
813    * @dev See {IERC165-supportsInterface}.
814    */
815   function supportsInterface(bytes4 interfaceId)
816     public
817     view
818     virtual
819     override(ERC165, IERC165)
820     returns (bool)
821   {
822     return
823       interfaceId == type(IERC721).interfaceId ||
824       interfaceId == type(IERC721Metadata).interfaceId ||
825       interfaceId == type(IERC721Enumerable).interfaceId ||
826       super.supportsInterface(interfaceId);
827   }
828 
829   /**
830    * @dev See {IERC721-balanceOf}.
831    */
832   function balanceOf(address owner) public view override returns (uint256) {
833     require(owner != address(0), "ERC721A: balance query for the zero address");
834     return uint256(_addressData[owner].balance);
835   }
836 
837   function _numberMinted(address owner) internal view returns (uint256) {
838     require(
839       owner != address(0),
840       "ERC721A: number minted query for the zero address"
841     );
842     return uint256(_addressData[owner].numberMinted);
843   }
844 
845   function ownershipOf(uint256 tokenId)
846     internal
847     view
848     returns (TokenOwnership memory)
849   {
850     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
851 
852     uint256 lowestTokenToCheck;
853     if (tokenId >= maxBatchSize) {
854       lowestTokenToCheck = tokenId - maxBatchSize + 1;
855     }
856 
857     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
858       TokenOwnership memory ownership = _ownerships[curr];
859       if (ownership.addr != address(0)) {
860         return ownership;
861       }
862     }
863 
864     revert("ERC721A: unable to determine the owner of token");
865   }
866 
867   /**
868    * @dev See {IERC721-ownerOf}.
869    */
870   function ownerOf(uint256 tokenId) public view override returns (address) {
871     return ownershipOf(tokenId).addr;
872   }
873 
874   /**
875    * @dev See {IERC721Metadata-name}.
876    */
877   function name() public view virtual override returns (string memory) {
878     return _name;
879   }
880 
881   /**
882    * @dev See {IERC721Metadata-symbol}.
883    */
884   function symbol() public view virtual override returns (string memory) {
885     return _symbol;
886   }
887 /**
888      * @dev See {IERC721Metadata-tokenURI}.
889      */
890     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
891         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
892 
893         string memory baseURI = _baseURI();
894         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
895     }
896 
897     /**
898      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
899      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
900      * by default, can be overriden in child contracts.
901      */
902     function _baseURI() internal view virtual returns (string memory) {
903         return "";
904     }
905 
906   /**
907    * @dev See {IERC721-approve}.
908    */
909   function approve(address to, uint256 tokenId) public override {
910     address owner = ERC721A.ownerOf(tokenId);
911     require(to != owner, "ERC721A: approval to current owner");
912 
913     require(
914       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
915       "ERC721A: approve caller is not owner nor approved for all"
916     );
917 
918     _approve(to, tokenId, owner);
919   }
920 
921   /**
922    * @dev See {IERC721-getApproved}.
923    */
924   function getApproved(uint256 tokenId) public view override returns (address) {
925     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
926 
927     return _tokenApprovals[tokenId];
928   }
929 
930   /**
931    * @dev See {IERC721-setApprovalForAll}.
932    */
933   function setApprovalForAll(address operator, bool approved) public override {
934     require(operator != _msgSender(), "ERC721A: approve to caller");
935 
936     _operatorApprovals[_msgSender()][operator] = approved;
937     emit ApprovalForAll(_msgSender(), operator, approved);
938   }
939 
940   /**
941    * @dev See {IERC721-isApprovedForAll}.
942    */
943   function isApprovedForAll(address owner, address operator)
944     public
945     view
946     virtual
947     override
948     returns (bool)
949   {
950     return _operatorApprovals[owner][operator];
951   }
952 
953   /**
954    * @dev See {IERC721-transferFrom}.
955    */
956   function transferFrom(
957     address from,
958     address to,
959     uint256 tokenId
960   ) public override {
961     _transfer(from, to, tokenId);
962   }
963 
964   /**
965    * @dev See {IERC721-safeTransferFrom}.
966    */
967   function safeTransferFrom(
968     address from,
969     address to,
970     uint256 tokenId
971   ) public override {
972     safeTransferFrom(from, to, tokenId, "");
973   }
974 
975   /**
976    * @dev See {IERC721-safeTransferFrom}.
977    */
978   function safeTransferFrom(
979     address from,
980     address to,
981     uint256 tokenId,
982     bytes memory _data
983   ) public override {
984     _transfer(from, to, tokenId);
985     require(
986       _checkOnERC721Received(from, to, tokenId, _data),
987       "ERC721A: transfer to non ERC721Receiver implementer"
988     );
989   }
990 
991   /**
992    * @dev Returns whether `tokenId` exists.
993    *
994    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
995    *
996    * Tokens start existing when they are minted (`_mint`),
997    */
998   function _exists(uint256 tokenId) internal view returns (bool) {
999     return tokenId < currentIndex;
1000   }
1001 
1002   function _safeMint(address to, uint256 quantity) internal {
1003     _safeMint(to, quantity, "");
1004   }
1005 
1006   /**
1007    * @dev Mints `quantity` tokens and transfers them to `to`.
1008    *
1009    * Requirements:
1010    *
1011    * - `to` cannot be the zero address.
1012    * - `quantity` cannot be larger than the max batch size.
1013    *
1014    * Emits a {Transfer} event.
1015    */
1016   function _safeMint(
1017     address to,
1018     uint256 quantity,
1019     bytes memory _data
1020   ) internal {
1021     uint256 startTokenId = currentIndex;
1022     require(to != address(0), "ERC721A: mint to the zero address");
1023     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1024     require(!_exists(startTokenId), "ERC721A: token already minted");
1025     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1026 
1027     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1028 
1029     AddressData memory addressData = _addressData[to];
1030     _addressData[to] = AddressData(
1031       addressData.balance + uint128(quantity),
1032       addressData.numberMinted + uint128(quantity)
1033     );
1034     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1035 
1036     uint256 updatedIndex = startTokenId;
1037 
1038     for (uint256 i = 0; i < quantity; i++) {
1039       emit Transfer(address(0), to, updatedIndex);
1040       require(
1041         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1042         "ERC721A: transfer to non ERC721Receiver implementer"
1043       );
1044       updatedIndex++;
1045     }
1046 
1047     currentIndex = updatedIndex;
1048     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1049   }
1050 
1051   /**
1052    * @dev Transfers `tokenId` from `from` to `to`.
1053    *
1054    * Requirements:
1055    *
1056    * - `to` cannot be the zero address.
1057    * - `tokenId` token must be owned by `from`.
1058    *
1059    * Emits a {Transfer} event.
1060    */
1061   function _transfer(
1062     address from,
1063     address to,
1064     uint256 tokenId
1065   ) private {
1066     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1067 
1068     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1069       getApproved(tokenId) == _msgSender() ||
1070       isApprovedForAll(prevOwnership.addr, _msgSender()));
1071 
1072     require(
1073       isApprovedOrOwner,
1074       "ERC721A: transfer caller is not owner nor approved"
1075     );
1076 
1077     require(
1078       prevOwnership.addr == from,
1079       "ERC721A: transfer from incorrect owner"
1080     );
1081     require(to != address(0), "ERC721A: transfer to the zero address");
1082 
1083     _beforeTokenTransfers(from, to, tokenId, 1);
1084 
1085     // Clear approvals from the previous owner
1086     _approve(address(0), tokenId, prevOwnership.addr);
1087 
1088     _addressData[from].balance -= 1;
1089     _addressData[to].balance += 1;
1090     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1091 
1092     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1093     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1094     uint256 nextTokenId = tokenId + 1;
1095     if (_ownerships[nextTokenId].addr == address(0)) {
1096       if (_exists(nextTokenId)) {
1097         _ownerships[nextTokenId] = TokenOwnership(
1098           prevOwnership.addr,
1099           prevOwnership.startTimestamp
1100         );
1101       }
1102     }
1103 
1104     emit Transfer(from, to, tokenId);
1105     _afterTokenTransfers(from, to, tokenId, 1);
1106   }
1107 
1108   /**
1109    * @dev Approve `to` to operate on `tokenId`
1110    *
1111    * Emits a {Approval} event.
1112    */
1113   function _approve(
1114     address to,
1115     uint256 tokenId,
1116     address owner
1117   ) private {
1118     _tokenApprovals[tokenId] = to;
1119     emit Approval(owner, to, tokenId);
1120   }
1121 
1122   uint256 public nextOwnerToExplicitlySet = 0;
1123 
1124   /**
1125    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1126    */
1127   function _setOwnersExplicit(uint256 quantity) internal {
1128     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1129     require(quantity > 0, "quantity must be nonzero");
1130     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1131     if (endIndex > currentIndex - 1) {
1132       endIndex = currentIndex - 1;
1133     }
1134     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1135     require(_exists(endIndex), "not enough minted yet for this cleanup");
1136     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1137       if (_ownerships[i].addr == address(0)) {
1138         TokenOwnership memory ownership = ownershipOf(i);
1139         _ownerships[i] = TokenOwnership(
1140           ownership.addr,
1141           ownership.startTimestamp
1142         );
1143       }
1144     }
1145     nextOwnerToExplicitlySet = endIndex + 1;
1146   }
1147 
1148   /**
1149    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1150    * The call is not executed if the target address is not a contract.
1151    *
1152    * @param from address representing the previous owner of the given token ID
1153    * @param to target address that will receive the tokens
1154    * @param tokenId uint256 ID of the token to be transferred
1155    * @param _data bytes optional data to send along with the call
1156    * @return bool whether the call correctly returned the expected magic value
1157    */
1158   function _checkOnERC721Received(
1159     address from,
1160     address to,
1161     uint256 tokenId,
1162     bytes memory _data
1163   ) private returns (bool) {
1164     if (to.isContract()) {
1165       try
1166         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1167       returns (bytes4 retval) {
1168         return retval == IERC721Receiver(to).onERC721Received.selector;
1169       } catch (bytes memory reason) {
1170         if (reason.length == 0) {
1171           revert("ERC721A: transfer to non ERC721Receiver implementer");
1172         } else {
1173           assembly {
1174             revert(add(32, reason), mload(reason))
1175           }
1176         }
1177       }
1178     } else {
1179       return true;
1180     }
1181   }
1182 
1183   /**
1184    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1185    *
1186    * startTokenId - the first token id to be transferred
1187    * quantity - the amount to be transferred
1188    *
1189    * Calling conditions:
1190    *
1191    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1192    * transferred to `to`.
1193    * - When `from` is zero, `tokenId` will be minted for `to`.
1194    */
1195   function _beforeTokenTransfers(
1196     address from,
1197     address to,
1198     uint256 startTokenId,
1199     uint256 quantity
1200   ) internal virtual {}
1201 
1202   /**
1203    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1204    * minting.
1205    *
1206    * startTokenId - the first token id to be transferred
1207    * quantity - the amount to be transferred
1208    *
1209    * Calling conditions:
1210    *
1211    * - when `from` and `to` are both non-zero.
1212    * - `from` and `to` are never both zero.
1213    */
1214   function _afterTokenTransfers(
1215     address from,
1216     address to,
1217     uint256 startTokenId,
1218     uint256 quantity
1219   ) internal virtual {}
1220 }
1221 
1222 // File: @openzeppelin/contracts/access/Ownable.sol
1223 
1224 
1225 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1226 
1227 pragma solidity ^0.8.0;
1228 
1229 
1230 /**
1231  * @dev Contract module which provides a basic access control mechanism, where
1232  * there is an account (an owner) that can be granted exclusive access to
1233  * specific functions.
1234  *
1235  * By default, the owner account will be the one that deploys the contract. This
1236  * can later be changed with {transferOwnership}.
1237  *
1238  * This module is used through inheritance. It will make available the modifier
1239  * `onlyOwner`, which can be applied to your functions to restrict their use to
1240  * the owner.
1241  */
1242 abstract contract Ownable is Context {
1243     address private _owner;
1244 
1245     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1246 
1247     /**
1248      * @dev Initializes the contract setting the deployer as the initial owner.
1249      */
1250     constructor() {
1251         _transferOwnership(_msgSender());
1252     }
1253 
1254     /**
1255      * @dev Returns the address of the current owner.
1256      */
1257     function owner() public view virtual returns (address) {
1258         return _owner;
1259     }
1260 
1261     /**
1262      * @dev Throws if called by any account other than the owner.
1263      */
1264     modifier onlyOwner() {
1265         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1266         _;
1267     }
1268 
1269     /**
1270      * @dev Leaves the contract without owner. It will not be possible to call
1271      * `onlyOwner` functions anymore. Can only be called by the current owner.
1272      *
1273      * NOTE: Renouncing ownership will leave the contract without an owner,
1274      * thereby removing any functionality that is only available to the owner.
1275      */
1276     function renounceOwnership() public virtual onlyOwner {
1277         _transferOwnership(address(0));
1278     }
1279 
1280     /**
1281      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1282      * Can only be called by the current owner.
1283      */
1284     function transferOwnership(address newOwner) public virtual onlyOwner {
1285         require(newOwner != address(0), "Ownable: new owner is the zero address");
1286         _transferOwnership(newOwner);
1287     }
1288 
1289     /**
1290      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1291      * Internal function without access restriction.
1292      */
1293     function _transferOwnership(address newOwner) internal virtual {
1294         address oldOwner = _owner;
1295         _owner = newOwner;
1296         emit OwnershipTransferred(oldOwner, newOwner);
1297     }
1298 }
1299 
1300 // File: contracts/but_dao.sol
1301 
1302 
1303 
1304 pragma solidity ^0.8.0;
1305 
1306 
1307 
1308 
1309 
1310 contract WorldofEvilGirls is ERC721A, Ownable {
1311     uint256 public PRICE = 0.01 ether;
1312     uint256 public MAXSUPPLY = 10000;
1313     uint256 public MAX_MINTS = 20;
1314     uint256 public MAX_MINTS_RESERVED = 100;
1315     string public projName = "World of Evil Girls";
1316     string public projSym = "WoEG";
1317 
1318     bool public DROP_ACTIVE = false;
1319 
1320   string public uriPrefix = "";
1321   string public uriSuffix = ".json";
1322   string public hiddenMetadataUri;
1323 
1324 
1325   bool public paused = true;
1326   bool public revealed = false;
1327 
1328     mapping(address => uint) addressToReservedMints;
1329     
1330     constructor() ERC721A(projName, projSym, MAX_MINTS, MAXSUPPLY) {
1331       setHiddenMetadataUri("ipfs://QmYrB2VNYyMNbcpnJbMLcAS9rxERwwY7sQt5B4fLPV8Gnb/_metadata.json");}
1332 
1333     function mint(uint256 numTokens) public payable {
1334         require(DROP_ACTIVE, "Sale not started");
1335         require(
1336             numTokens > 0 && numTokens <= MAX_MINTS,
1337             "Must mint between 1 and 20 tokens"
1338         );
1339         require(totalSupply() + numTokens <= MAXSUPPLY, "Sold Out");
1340         require(
1341             msg.value >= PRICE * numTokens,
1342             "Amount of ether sent is not enough"
1343         );
1344 
1345         _safeMint(msg.sender, numTokens);
1346     }
1347 
1348  
1349 
1350     function flipDropState() public onlyOwner {
1351         DROP_ACTIVE = !DROP_ACTIVE;
1352     }
1353 
1354 function tokenURI(uint256 _tokenId)
1355     public
1356     view
1357     virtual
1358     override
1359     returns (string memory)
1360   {
1361     require(
1362       _exists(_tokenId),
1363       "ERC721Metadata: URI query for nonexistent token"
1364     );
1365 
1366     if (revealed == false) {
1367       return hiddenMetadataUri;
1368     }
1369     string memory currentBaseURI = _baseURI();
1370     return bytes(currentBaseURI).length > 0 ? 
1371 string(abi.encodePacked(currentBaseURI, Strings.toString(_tokenId), uriSuffix)) : "";
1372   }
1373 
1374    function setRevealed(bool _state) public onlyOwner {
1375     revealed = _state;
1376   }
1377 
1378 function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1379     hiddenMetadataUri = _hiddenMetadataUri;
1380   }
1381 
1382   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1383     uriPrefix = _uriPrefix;
1384   }
1385 
1386   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1387     uriSuffix = _uriSuffix;
1388   }
1389 
1390     function setPrice(uint256 newPrice) public onlyOwner {
1391         PRICE = newPrice;
1392     }
1393 
1394     function setMaxMints(uint256 newMax) public onlyOwner {
1395         MAX_MINTS = newMax;
1396     }
1397 
1398     function setSupply(uint256 newSupply) public onlyOwner {
1399         MAXSUPPLY = newSupply;
1400     }
1401     
1402   
1403     function reservedMintedBy() external view returns (uint256) {
1404         return addressToReservedMints[msg.sender];
1405     }
1406 
1407     function withdraw() public onlyOwner {
1408         require(payable(msg.sender).send(address(this).balance));
1409     }
1410     function _baseURI() internal view virtual override returns (string memory) {
1411     return uriPrefix;
1412   }
1413 }