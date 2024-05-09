1 /**
2  *Submitted for verification at Etherscan.io on 07-20-2023
3  https://frogdogcoin.com
4  By Forgdog coin community
5 */
6 
7 // SPDX-License-Identifier: MIT
8 // File: contracts/Strings.sol
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev String operations.
13  */
14 library Strings {
15     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
16 
17     /**
18      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
19      */
20     function toString(uint256 value) internal pure returns (string memory) {
21         // Inspired by OraclizeAPI's implementation - MIT licence
22         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
23 
24         if (value == 0) {
25             return "0";
26         }
27         uint256 temp = value;
28         uint256 digits;
29         while (temp != 0) {
30             digits++;
31             temp /= 10;
32         }
33         bytes memory buffer = new bytes(digits);
34         while (value != 0) {
35             digits -= 1;
36             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
37             value /= 10;
38         }
39         return string(buffer);
40     }
41 
42     /**
43      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
44      */
45     function toHexString(uint256 value) internal pure returns (string memory) {
46         if (value == 0) {
47             return "0x00";
48         }
49         uint256 temp = value;
50         uint256 length = 0;
51         while (temp != 0) {
52             length++;
53             temp >>= 8;
54         }
55         return toHexString(value, length);
56     }
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
60      */
61     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
62         bytes memory buffer = new bytes(2 * length + 2);
63         buffer[0] = "0";
64         buffer[1] = "x";
65         for (uint256 i = 2 * length + 1; i > 1; --i) {
66             buffer[i] = _HEX_SYMBOLS[value & 0xf];
67             value >>= 4;
68         }
69         require(value == 0, "Strings: hex length insufficient");
70         return string(buffer);
71     }
72 }
73 
74 // File: contracts/Address.sol
75 
76 
77 
78 pragma solidity ^0.8.0;
79 
80 /**
81  * @dev Collection of functions related to the address type
82  */
83 library Address {
84     /**
85      * @dev Returns true if `account` is a contract.
86      *
87      * [IMPORTANT]
88      * ====
89      * It is unsafe to assume that an address for which this function returns
90      * false is an externally-owned account (EOA) and not a contract.
91      *
92      * Among others, `isContract` will return false for the following
93      * types of addresses:
94      *
95      *  - an externally-owned account
96      *  - a contract in construction
97      *  - an address where a contract will be created
98      *  - an address where a contract lived, but was destroyed
99      * ====
100      */
101     function isContract(address account) internal view returns (bool) {
102         // This method relies on extcodesize, which returns 0 for contracts in
103         // construction, since the code is only stored at the end of the
104         // constructor execution.
105 
106         uint256 size;
107         assembly {
108             size := extcodesize(account)
109         }
110         return size > 0;
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
207         return _verifyCallResult(success, returndata, errorMessage);
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
234         return _verifyCallResult(success, returndata, errorMessage);
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
261         return _verifyCallResult(success, returndata, errorMessage);
262     }
263 
264     function _verifyCallResult(
265         bool success,
266         bytes memory returndata,
267         string memory errorMessage
268     ) private pure returns (bytes memory) {
269         if (success) {
270             return returndata;
271         } else {
272             // Look for revert reason and bubble it up if present
273             if (returndata.length > 0) {
274                 // The easiest way to bubble the revert reason is using memory via assembly
275 
276                 assembly {
277                     let returndata_size := mload(returndata)
278                     revert(add(32, returndata), returndata_size)
279                 }
280             } else {
281                 revert(errorMessage);
282             }
283         }
284     }
285 }
286 
287 // File: contracts/IERC721Receiver.sol
288 
289 
290 
291 pragma solidity ^0.8.0;
292 
293 /**
294  * @title ERC721 token receiver interface
295  * @dev Interface for any contract that wants to support safeTransfers
296  * from ERC721 asset contracts.
297  */
298 interface IERC721Receiver {
299     /**
300      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
301      * by `operator` from `from`, this function is called.
302      *
303      * It must return its Solidity selector to confirm the token transfer.
304      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
305      *
306      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
307      */
308     function onERC721Received(
309         address operator,
310         address from,
311         uint256 tokenId,
312         bytes calldata data
313     ) external returns (bytes4);
314 }
315 
316 // File: contracts/IERC165.sol
317 
318 
319 
320 pragma solidity ^0.8.0;
321 
322 /**
323  * @dev Interface of the ERC165 standard, as defined in the
324  * https://eips.ethereum.org/EIPS/eip-165[EIP].
325  *
326  * Implementers can declare support of contract interfaces, which can then be
327  * queried by others ({ERC165Checker}).
328  *
329  * For an implementation, see {ERC165}.
330  */
331 interface IERC165 {
332     /**
333      * @dev Returns true if this contract implements the interface defined by
334      * `interfaceId`. See the corresponding
335      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
336      * to learn more about how these ids are created.
337      *
338      * This function call must use less than 30 000 gas.
339      */
340     function supportsInterface(bytes4 interfaceId) external view returns (bool);
341 }
342 
343 // File: contracts/ERC165.sol
344 
345 
346 
347 pragma solidity ^0.8.0;
348 
349 
350 /**
351  * @dev Implementation of the {IERC165} interface.
352  *
353  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
354  * for the additional interface id that will be supported. For example:
355  *
356  * ```solidity
357  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
358  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
359  * }
360  * ```
361  *
362  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
363  */
364 abstract contract ERC165 is IERC165 {
365     /**
366      * @dev See {IERC165-supportsInterface}.
367      */
368     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
369         return interfaceId == type(IERC165).interfaceId;
370     }
371 }
372 
373 // File: contracts/IERC721.sol
374 
375 
376 
377 pragma solidity ^0.8.0;
378 
379 
380 /**
381  * @dev Required interface of an ERC721 compliant contract.
382  */
383 interface IERC721 is IERC165 {
384     /**
385      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
386      */
387     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
388 
389     /**
390      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
391      */
392     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
393 
394     /**
395      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
396      */
397     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
398 
399     /**
400      * @dev Returns the number of tokens in ``owner``'s account.
401      */
402     function balanceOf(address owner) external view returns (uint256 balance);
403 
404     /**
405      * @dev Returns the owner of the `tokenId` token.
406      *
407      * Requirements:
408      *
409      * - `tokenId` must exist.
410      */
411     function ownerOf(uint256 tokenId) external view returns (address owner);
412 
413     /**
414      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
415      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
416      *
417      * Requirements:
418      *
419      * - `from` cannot be the zero address.
420      * - `to` cannot be the zero address.
421      * - `tokenId` token must exist and be owned by `from`.
422      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
423      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
424      *
425      * Emits a {Transfer} event.
426      */
427     function safeTransferFrom(
428         address from,
429         address to,
430         uint256 tokenId
431     ) external;
432 
433     /**
434      * @dev Transfers `tokenId` token from `from` to `to`.
435      *
436      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
437      *
438      * Requirements:
439      *
440      * - `from` cannot be the zero address.
441      * - `to` cannot be the zero address.
442      * - `tokenId` token must be owned by `from`.
443      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
444      *
445      * Emits a {Transfer} event.
446      */
447     function transferFrom(
448         address from,
449         address to,
450         uint256 tokenId
451     ) external;
452 
453     /**
454      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
455      * The approval is cleared when the token is transferred.
456      *
457      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
458      *
459      * Requirements:
460      *
461      * - The caller must own the token or be an approved operator.
462      * - `tokenId` must exist.
463      *
464      * Emits an {Approval} event.
465      */
466     function approve(address to, uint256 tokenId) external;
467 
468     /**
469      * @dev Returns the account approved for `tokenId` token.
470      *
471      * Requirements:
472      *
473      * - `tokenId` must exist.
474      */
475     function getApproved(uint256 tokenId) external view returns (address operator);
476 
477     /**
478      * @dev Approve or remove `operator` as an operator for the caller.
479      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
480      *
481      * Requirements:
482      *
483      * - The `operator` cannot be the caller.
484      *
485      * Emits an {ApprovalForAll} event.
486      */
487     function setApprovalForAll(address operator, bool _approved) external;
488 
489     /**
490      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
491      *
492      * See {setApprovalForAll}
493      */
494     function isApprovedForAll(address owner, address operator) external view returns (bool);
495 
496     /**
497      * @dev Safely transfers `tokenId` token from `from` to `to`.
498      *
499      * Requirements:
500      *
501      * - `from` cannot be the zero address.
502      * - `to` cannot be the zero address.
503      * - `tokenId` token must exist and be owned by `from`.
504      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
505      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
506      *
507      * Emits a {Transfer} event.
508      */
509     function safeTransferFrom(
510         address from,
511         address to,
512         uint256 tokenId,
513         bytes calldata data
514     ) external;
515 }
516 
517 // File: contracts/IERC721Enumerable.sol
518 
519 
520 
521 pragma solidity ^0.8.0;
522 
523 
524 /**
525  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
526  * @dev See https://eips.ethereum.org/EIPS/eip-721
527  */
528 interface IERC721Enumerable is IERC721 {
529     /**
530      * @dev Returns the total amount of tokens stored by the contract.
531      */
532     function totalSupply() external view returns (uint256);
533 
534     /**
535      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
536      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
537      */
538     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
539 
540     /**
541      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
542      * Use along with {totalSupply} to enumerate all tokens.
543      */
544     function tokenByIndex(uint256 index) external view returns (uint256);
545 }
546 
547 // File: contracts/IERC721Metadata.sol
548 
549 
550 
551 pragma solidity ^0.8.0;
552 
553 
554 /**
555  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
556  * @dev See https://eips.ethereum.org/EIPS/eip-721
557  */
558 interface IERC721Metadata is IERC721 {
559     /**
560      * @dev Returns the token collection name.
561      */
562     function name() external view returns (string memory);
563 
564     /**
565      * @dev Returns the token collection symbol.
566      */
567     function symbol() external view returns (string memory);
568 
569     /**
570      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
571      */
572     function tokenURI(uint256 tokenId) external view returns (string memory);
573 }
574 
575 // File: contracts/ReentrancyGuard.sol
576 
577 
578 
579 pragma solidity ^0.8.0;
580 
581 /**
582  * @dev Contract module that helps prevent reentrant calls to a function.
583  *
584  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
585  * available, which can be applied to functions to make sure there are no nested
586  * (reentrant) calls to them.
587  *
588  * Note that because there is a single `nonReentrant` guard, functions marked as
589  * `nonReentrant` may not call one another. This can be worked around by making
590  * those functions `private`, and then adding `external` `nonReentrant` entry
591  * points to them.
592  *
593  * TIP: If you would like to learn more about reentrancy and alternative ways
594  * to protect against it, check out our blog post
595  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
596  */
597 abstract contract ReentrancyGuard {
598     // Booleans are more expensive than uint256 or any type that takes up a full
599     // word because each write operation emits an extra SLOAD to first read the
600     // slot's contents, replace the bits taken up by the boolean, and then write
601     // back. This is the compiler's defense against contract upgrades and
602     // pointer aliasing, and it cannot be disabled.
603 
604     // The values being non-zero value makes deployment a bit more expensive,
605     // but in exchange the refund on every call to nonReentrant will be lower in
606     // amount. Since refunds are capped to a percentage of the total
607     // transaction's gas, it is best to keep them low in cases like this one, to
608     // increase the likelihood of the full refund coming into effect.
609     uint256 private constant _NOT_ENTERED = 1;
610     uint256 private constant _ENTERED = 2;
611 
612     uint256 private _status;
613 
614     constructor() {
615         _status = _NOT_ENTERED;
616     }
617 
618     /**
619      * @dev Prevents a contract from calling itself, directly or indirectly.
620      * Calling a `nonReentrant` function from another `nonReentrant`
621      * function is not supported. It is possible to prevent this from happening
622      * by making the `nonReentrant` function external, and make it call a
623      * `private` function that does the actual work.
624      */
625     modifier nonReentrant() {
626         // On the first call to nonReentrant, _notEntered will be true
627         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
628 
629         // Any calls to nonReentrant after this point will fail
630         _status = _ENTERED;
631 
632         _;
633 
634         // By storing the original value once again, a refund is triggered (see
635         // https://eips.ethereum.org/EIPS/eip-2200)
636         _status = _NOT_ENTERED;
637     }
638 }
639 
640 // File: contracts/Context.sol
641 
642 
643 
644 pragma solidity ^0.8.0;
645 
646 /*
647  * @dev Provides information about the current execution context, including the
648  * sender of the transaction and its data. While these are generally available
649  * via msg.sender and msg.data, they should not be accessed in such a direct
650  * manner, since when dealing with meta-transactions the account sending and
651  * paying for execution may not be the actual sender (as far as an application
652  * is concerned).
653  *
654  * This contract is only required for intermediate, library-like contracts.
655  */
656 abstract contract Context {
657     function _msgSender() internal view virtual returns (address) {
658         return msg.sender;
659     }
660 
661     function _msgData() internal view virtual returns (bytes calldata) {
662         return msg.data;
663     }
664 }
665 
666 // File: contracts/ERC721A.sol
667 
668 
669 
670 pragma solidity ^0.8.0;
671 
672 
673 
674 
675 
676 
677 
678 
679 
680 /**
681  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
682  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
683  *
684  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
685  *
686  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
687  *
688  * Does not support burning tokens to address(0).
689  */
690 contract ERC721A is
691   Context,
692   ERC165,
693   IERC721,
694   IERC721Metadata,
695   IERC721Enumerable
696 {
697   using Address for address;
698   using Strings for uint256;
699 
700   struct TokenOwnership {
701     address addr;
702     uint64 startTimestamp;
703   }
704 
705   struct AddressData {
706     uint128 balance;
707     uint128 numberMinted;
708   }
709 
710   uint256 private currentIndex = 0;
711 
712   uint256 internal immutable collectionSize;
713   uint256 internal immutable maxBatchSize;
714 
715   // Token name
716   string private _name;
717 
718   // Token symbol
719   string private _symbol;
720 
721   // Mapping from token ID to ownership details
722   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
723   mapping(uint256 => TokenOwnership) private _ownerships;
724 
725   // Mapping owner address to address data
726   mapping(address => AddressData) private _addressData;
727 
728   // Mapping from token ID to approved address
729   mapping(uint256 => address) private _tokenApprovals;
730 
731   // Mapping from owner to operator approvals
732   mapping(address => mapping(address => bool)) private _operatorApprovals;
733 
734   /**
735    * @dev
736    * `maxBatchSize` refers to how much a minter can mint at a time.
737    * `collectionSize_` refers to how many tokens are in the collection.
738    */
739   constructor(
740     string memory name_,
741     string memory symbol_,
742     uint256 maxBatchSize_,
743     uint256 collectionSize_
744   ) {
745     require(
746       collectionSize_ > 0,
747       "ERC721A: collection must have a nonzero supply"
748     );
749     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
750     _name = name_;
751     _symbol = symbol_;
752     maxBatchSize = maxBatchSize_;
753     collectionSize = collectionSize_;
754   }
755 
756   /**
757    * @dev See {IERC721Enumerable-totalSupply}.
758    */
759   function totalSupply() public view override returns (uint256) {
760     return currentIndex;
761   }
762 
763   /**
764    * @dev See {IERC721Enumerable-tokenByIndex}.
765    */
766   function tokenByIndex(uint256 index) public view override returns (uint256) {
767     require(index < totalSupply(), "ERC721A: global index out of bounds");
768     return index;
769   }
770 
771   /**
772    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
773    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
774    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
775    */
776   function tokenOfOwnerByIndex(address owner, uint256 index)
777     public
778     view
779     override
780     returns (uint256)
781   {
782     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
783     uint256 numMintedSoFar = totalSupply();
784     uint256 tokenIdsIdx = 0;
785     address currOwnershipAddr = address(0);
786     for (uint256 i = 0; i < numMintedSoFar; i++) {
787       TokenOwnership memory ownership = _ownerships[i];
788       if (ownership.addr != address(0)) {
789         currOwnershipAddr = ownership.addr;
790       }
791       if (currOwnershipAddr == owner) {
792         if (tokenIdsIdx == index) {
793           return i;
794         }
795         tokenIdsIdx++;
796       }
797     }
798     revert("ERC721A: unable to get token of owner by index");
799   }
800 
801   /**
802    * @dev See {IERC165-supportsInterface}.
803    */
804   function supportsInterface(bytes4 interfaceId)
805     public
806     view
807     virtual
808     override(ERC165, IERC165)
809     returns (bool)
810   {
811     return
812       interfaceId == type(IERC721).interfaceId ||
813       interfaceId == type(IERC721Metadata).interfaceId ||
814       interfaceId == type(IERC721Enumerable).interfaceId ||
815       super.supportsInterface(interfaceId);
816   }
817 
818   /**
819    * @dev See {IERC721-balanceOf}.
820    */
821   function balanceOf(address owner) public view override returns (uint256) {
822     require(owner != address(0), "ERC721A: balance query for the zero address");
823     return uint256(_addressData[owner].balance);
824   }
825 
826   function _numberMinted(address owner) internal view returns (uint256) {
827     require(
828       owner != address(0),
829       "ERC721A: number minted query for the zero address"
830     );
831     return uint256(_addressData[owner].numberMinted);
832   }
833 
834   function ownershipOf(uint256 tokenId)
835     internal
836     view
837     returns (TokenOwnership memory)
838   {
839     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
840 
841     uint256 lowestTokenToCheck;
842     if (tokenId >= maxBatchSize) {
843       lowestTokenToCheck = tokenId - maxBatchSize + 1;
844     }
845 
846     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
847       TokenOwnership memory ownership = _ownerships[curr];
848       if (ownership.addr != address(0)) {
849         return ownership;
850       }
851     }
852 
853     revert("ERC721A: unable to determine the owner of token");
854   }
855 
856   /**
857    * @dev See {IERC721-ownerOf}.
858    */
859   function ownerOf(uint256 tokenId) public view override returns (address) {
860     return ownershipOf(tokenId).addr;
861   }
862 
863   /**
864    * @dev See {IERC721Metadata-name}.
865    */
866   function name() public view virtual override returns (string memory) {
867     return _name;
868   }
869 
870   /**
871    * @dev See {IERC721Metadata-symbol}.
872    */
873   function symbol() public view virtual override returns (string memory) {
874     return _symbol;
875   }
876 
877   /**
878    * @dev See {IERC721Metadata-tokenURI}.
879    */
880   function tokenURI(uint256 tokenId)
881     public
882     view
883     virtual
884     override
885     returns (string memory)
886   {
887     require(
888       _exists(tokenId),
889       "ERC721Metadata: URI query for nonexistent token"
890     );
891 
892     string memory baseURI = _baseURI();
893     return
894       bytes(baseURI).length > 0
895         ? string(abi.encodePacked(baseURI, tokenId.toString()))
896         : "";
897   }
898 
899   /**
900    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
901    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
902    * by default, can be overriden in child contracts.
903    */
904   function _baseURI() internal view virtual returns (string memory) {
905     return "";
906   }
907 
908   /**
909    * @dev See {IERC721-approve}.
910    */
911   function approve(address to, uint256 tokenId) public override {
912     address owner = ERC721A.ownerOf(tokenId);
913     require(to != owner, "ERC721A: approval to current owner");
914 
915     require(
916       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
917       "ERC721A: approve caller is not owner nor approved for all"
918     );
919 
920     _approve(to, tokenId, owner);
921   }
922 
923   /**
924    * @dev See {IERC721-getApproved}.
925    */
926   function getApproved(uint256 tokenId) public view override returns (address) {
927     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
928 
929     return _tokenApprovals[tokenId];
930   }
931 
932   /**
933    * @dev See {IERC721-setApprovalForAll}.
934    */
935   function setApprovalForAll(address operator, bool approved) public override {
936     require(operator != _msgSender(), "ERC721A: approve to caller");
937 
938     _operatorApprovals[_msgSender()][operator] = approved;
939     emit ApprovalForAll(_msgSender(), operator, approved);
940   }
941 
942   /**
943    * @dev See {IERC721-isApprovedForAll}.
944    */
945   function isApprovedForAll(address owner, address operator)
946     public
947     view
948     virtual
949     override
950     returns (bool)
951   {
952     return _operatorApprovals[owner][operator];
953   }
954 
955   /**
956    * @dev See {IERC721-transferFrom}.
957    */
958   function transferFrom(
959     address from,
960     address to,
961     uint256 tokenId
962   ) public override {
963     _transfer(from, to, tokenId);
964   }
965 
966   /**
967    * @dev See {IERC721-safeTransferFrom}.
968    */
969   function safeTransferFrom(
970     address from,
971     address to,
972     uint256 tokenId
973   ) public override {
974     safeTransferFrom(from, to, tokenId, "");
975   }
976 
977   /**
978    * @dev See {IERC721-safeTransferFrom}.
979    */
980   function safeTransferFrom(
981     address from,
982     address to,
983     uint256 tokenId,
984     bytes memory _data
985   ) public override {
986     _transfer(from, to, tokenId);
987     require(
988       _checkOnERC721Received(from, to, tokenId, _data),
989       "ERC721A: transfer to non ERC721Receiver implementer"
990     );
991   }
992 
993   /**
994    * @dev Returns whether `tokenId` exists.
995    *
996    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
997    *
998    * Tokens start existing when they are minted (`_mint`),
999    */
1000   function _exists(uint256 tokenId) internal view returns (bool) {
1001     return tokenId < currentIndex;
1002   }
1003 
1004   function _safeMint(address to, uint256 quantity) internal {
1005     _safeMint(to, quantity, "");
1006   }
1007 
1008   /**
1009    * @dev Mints `quantity` tokens and transfers them to `to`.
1010    *
1011    * Requirements:
1012    *
1013    * - there must be `quantity` tokens remaining unminted in the total collection.
1014    * - `to` cannot be the zero address.
1015    * - `quantity` cannot be larger than the max batch size.
1016    *
1017    * Emits a {Transfer} event.
1018    */
1019   function _safeMint(
1020     address to,
1021     uint256 quantity,
1022     bytes memory _data
1023   ) internal {
1024     uint256 startTokenId = currentIndex;
1025     require(to != address(0), "ERC721A: mint to the zero address");
1026     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1027     require(!_exists(startTokenId), "ERC721A: token already minted");
1028     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1029 
1030     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1031 
1032     AddressData memory addressData = _addressData[to];
1033     _addressData[to] = AddressData(
1034       addressData.balance + uint128(quantity),
1035       addressData.numberMinted + uint128(quantity)
1036     );
1037     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1038 
1039     uint256 updatedIndex = startTokenId;
1040 
1041     for (uint256 i = 0; i < quantity; i++) {
1042       emit Transfer(address(0), to, updatedIndex);
1043       require(
1044         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1045         "ERC721A: transfer to non ERC721Receiver implementer"
1046       );
1047       updatedIndex++;
1048     }
1049 
1050     currentIndex = updatedIndex;
1051     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1052   }
1053 
1054   /**
1055    * @dev Transfers `tokenId` from `from` to `to`.
1056    *
1057    * Requirements:
1058    *
1059    * - `to` cannot be the zero address.
1060    * - `tokenId` token must be owned by `from`.
1061    *
1062    * Emits a {Transfer} event.
1063    */
1064   function _transfer(
1065     address from,
1066     address to,
1067     uint256 tokenId
1068   ) private {
1069     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1070 
1071     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1072       getApproved(tokenId) == _msgSender() ||
1073       isApprovedForAll(prevOwnership.addr, _msgSender()));
1074 
1075     require(
1076       isApprovedOrOwner,
1077       "ERC721A: transfer caller is not owner nor approved"
1078     );
1079 
1080     require(
1081       prevOwnership.addr == from,
1082       "ERC721A: transfer from incorrect owner"
1083     );
1084     require(to != address(0), "ERC721A: transfer to the zero address");
1085 
1086     _beforeTokenTransfers(from, to, tokenId, 1);
1087 
1088     // Clear approvals from the previous owner
1089     _approve(address(0), tokenId, prevOwnership.addr);
1090 
1091     _addressData[from].balance -= 1;
1092     _addressData[to].balance += 1;
1093     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1094 
1095     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1096     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1097     uint256 nextTokenId = tokenId + 1;
1098     if (_ownerships[nextTokenId].addr == address(0)) {
1099       if (_exists(nextTokenId)) {
1100         _ownerships[nextTokenId] = TokenOwnership(
1101           prevOwnership.addr,
1102           prevOwnership.startTimestamp
1103         );
1104       }
1105     }
1106 
1107     emit Transfer(from, to, tokenId);
1108     _afterTokenTransfers(from, to, tokenId, 1);
1109   }
1110 
1111   /**
1112    * @dev Approve `to` to operate on `tokenId`
1113    *
1114    * Emits a {Approval} event.
1115    */
1116   function _approve(
1117     address to,
1118     uint256 tokenId,
1119     address owner
1120   ) private {
1121     _tokenApprovals[tokenId] = to;
1122     emit Approval(owner, to, tokenId);
1123   }
1124 
1125   uint256 public nextOwnerToExplicitlySet = 0;
1126 
1127   /**
1128    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1129    */
1130   function _setOwnersExplicit(uint256 quantity) internal {
1131     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1132     require(quantity > 0, "quantity must be nonzero");
1133     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1134     if (endIndex > collectionSize - 1) {
1135       endIndex = collectionSize - 1;
1136     }
1137     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1138     require(_exists(endIndex), "not enough minted yet for this cleanup");
1139     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1140       if (_ownerships[i].addr == address(0)) {
1141         TokenOwnership memory ownership = ownershipOf(i);
1142         _ownerships[i] = TokenOwnership(
1143           ownership.addr,
1144           ownership.startTimestamp
1145         );
1146       }
1147     }
1148     nextOwnerToExplicitlySet = endIndex + 1;
1149   }
1150 
1151   /**
1152    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1153    * The call is not executed if the target address is not a contract.
1154    *
1155    * @param from address representing the previous owner of the given token ID
1156    * @param to target address that will receive the tokens
1157    * @param tokenId uint256 ID of the token to be transferred
1158    * @param _data bytes optional data to send along with the call
1159    * @return bool whether the call correctly returned the expected magic value
1160    */
1161   function _checkOnERC721Received(
1162     address from,
1163     address to,
1164     uint256 tokenId,
1165     bytes memory _data
1166   ) private returns (bool) {
1167     if (to.isContract()) {
1168       try
1169         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1170       returns (bytes4 retval) {
1171         return retval == IERC721Receiver(to).onERC721Received.selector;
1172       } catch (bytes memory reason) {
1173         if (reason.length == 0) {
1174           revert("ERC721A: transfer to non ERC721Receiver implementer");
1175         } else {
1176           assembly {
1177             revert(add(32, reason), mload(reason))
1178           }
1179         }
1180       }
1181     } else {
1182       return true;
1183     }
1184   }
1185 
1186   /**
1187    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1188    *
1189    * startTokenId - the first token id to be transferred
1190    * quantity - the amount to be transferred
1191    *
1192    * Calling conditions:
1193    *
1194    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1195    * transferred to `to`.
1196    * - When `from` is zero, `tokenId` will be minted for `to`.
1197    */
1198   function _beforeTokenTransfers(
1199     address from,
1200     address to,
1201     uint256 startTokenId,
1202     uint256 quantity
1203   ) internal virtual {}
1204 
1205   /**
1206    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1207    * minting.
1208    *
1209    * startTokenId - the first token id to be transferred
1210    * quantity - the amount to be transferred
1211    *
1212    * Calling conditions:
1213    *
1214    * - when `from` and `to` are both non-zero.
1215    * - `from` and `to` are never both zero.
1216    */
1217   function _afterTokenTransfers(
1218     address from,
1219     address to,
1220     uint256 startTokenId,
1221     uint256 quantity
1222   ) internal virtual {}
1223 }
1224 
1225 // File: contracts/Ownable.sol
1226 
1227 
1228 
1229 pragma solidity ^0.8.0;
1230 
1231 
1232 /**
1233  * @dev Contract module which provides a basic access control mechanism, where
1234  * there is an account (an owner) that can be granted exclusive access to
1235  * specific functions.
1236  *
1237  * By default, the owner account will be the one that deploys the contract. This
1238  * can later be changed with {transferOwnership}.
1239  *
1240  * This module is used through inheritance. It will make available the modifier
1241  * `onlyOwner`, which can be applied to your functions to restrict their use to
1242  * the owner.
1243  */
1244 abstract contract Ownable is Context {
1245     address private _owner;
1246 
1247     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1248 
1249     /**
1250      * @dev Initializes the contract setting the deployer as the initial owner.
1251      */
1252     constructor() {
1253         _setOwner(_msgSender());
1254     }
1255 
1256     /**
1257      * @dev Returns the address of the current owner.
1258      */
1259     function owner() public view virtual returns (address) {
1260         return _owner;
1261     }
1262 
1263     /**
1264      * @dev Throws if called by any account other than the owner.
1265      */
1266     modifier onlyOwner() {
1267         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1268         _;
1269     }
1270 
1271     /**
1272      * @dev Leaves the contract without owner. It will not be possible to call
1273      * `onlyOwner` functions anymore. Can only be called by the current owner.
1274      *
1275      * NOTE: Renouncing ownership will leave the contract without an owner,
1276      * thereby removing any functionality that is only available to the owner.
1277      */
1278     function renounceOwnership() public virtual onlyOwner {
1279         _setOwner(address(0));
1280     }
1281 
1282     /**
1283      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1284      * Can only be called by the current owner.
1285      */
1286     function transferOwnership(address newOwner) public virtual onlyOwner {
1287         require(newOwner != address(0), "Ownable: new owner is the zero address");
1288         _setOwner(newOwner);
1289     }
1290 
1291     function _setOwner(address newOwner) private {
1292         address oldOwner = _owner;
1293         _owner = newOwner;
1294         emit OwnershipTransferred(oldOwner, newOwner);
1295     }
1296 }
1297 
1298 // File: contracts/FROGDOGCOIN.sol
1299 
1300 
1301 
1302 pragma solidity ^0.8.0;
1303 
1304 
1305 
1306 
1307 
1308 contract OPEPENAI is Ownable, ERC721A, ReentrancyGuard {
1309   uint256 public immutable maxPerAddressDuringMint;
1310 
1311 
1312   constructor(
1313     uint256 maxBatchSize_,
1314     uint256 collectionSize_
1315   ) ERC721A("OPEPENAI", "OPEPENAI", maxBatchSize_, collectionSize_) {
1316     maxPerAddressDuringMint = maxBatchSize_;
1317   }
1318 
1319   modifier callerIsUser() {
1320     require(tx.origin == msg.sender, "The caller is another contract");
1321     _;
1322   }
1323 
1324   function mint(uint256 quantity) external callerIsUser {
1325 
1326     require(totalSupply() + quantity <= collectionSize, "reached max supply");
1327     require(
1328       numberMinted(msg.sender) + quantity <= maxPerAddressDuringMint,
1329       "can not mint this many"
1330     );
1331     _safeMint(msg.sender, quantity);
1332   }
1333 
1334 
1335   // // metadata URI
1336   string private _baseTokenURI;
1337 
1338   function _baseURI() internal view virtual override returns (string memory) {
1339     return _baseTokenURI;
1340   }
1341 
1342   function setBaseURI(string calldata baseURI) external onlyOwner {
1343     _baseTokenURI = baseURI;
1344   }
1345 
1346   function withdrawMoney() external onlyOwner nonReentrant {
1347     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1348     require(success, "Transfer failed.");
1349   }
1350 
1351   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1352     _setOwnersExplicit(quantity);
1353   }
1354 
1355   function numberMinted(address owner) public view returns (uint256) {
1356     return _numberMinted(owner);
1357   }
1358 
1359   function getOwnershipData(uint256 tokenId)
1360     external
1361     view
1362     returns (TokenOwnership memory)
1363   {
1364     return ownershipOf(tokenId);
1365   }
1366 
1367 }