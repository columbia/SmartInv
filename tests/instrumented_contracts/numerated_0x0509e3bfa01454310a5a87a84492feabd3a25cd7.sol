1 // SPDX-License-Identifier: MIT
2 // ╭╮╱╱╭┳━━━┳━━━╮╭╮╱╱╱╱╭━━━┳╮╭╮
3 // ┃╰╮╭╯┃╭━╮┃╭━╮┣╯╰╮╱╱╱┃╭━┳╯╰┫┃
4 // ╰╮╰╯╭┫┃┃┃┃┃┃┃┣╮╭╋━━╮┃╰━┻╮╭┫╰━┳━━┳━┳━━┳╮╭┳╮╭╮
5 // ╱╰╮╭╯┃┃┃┃┃┃┃┃┃┃┃┃━━┫┃╭━━┫┃┃╭╮┃┃━┫╭┫┃━┫┃┃┃╰╯┃
6 // ╱╱┃┃╱┃╰━╯┃╰━╯┃┃╰╋━━┃┃╰━━┫╰┫┃┃┃┃━┫┃┃┃━┫╰╯┃┃┃┃
7 // ╱╱╰╯╱╰━━━┻━━━╯╰━┻━━╯╰━━━┻━┻╯╰┻━━┻╯╰━━┻━━┻┻┻╯
8 // File: contracts/Strings.sol
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev String operations.
13  */
14 
15 
16 library Strings {
17     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
18 
19     /**
20      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
21      */
22     function toString(uint256 value) internal pure returns (string memory) {
23         // Inspired by OraclizeAPI's implementation - MIT licence
24         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
25 
26         if (value == 0) {
27             return "0";
28         }
29         uint256 temp = value;
30         uint256 digits;
31         while (temp != 0) {
32             digits++;
33             temp /= 10;
34         }
35         bytes memory buffer = new bytes(digits);
36         while (value != 0) {
37             digits -= 1;
38             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
39             value /= 10;
40         }
41         return string(buffer);
42     }
43 
44     /**
45      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
46      */
47     function toHexString(uint256 value) internal pure returns (string memory) {
48         if (value == 0) {
49             return "0x00";
50         }
51         uint256 temp = value;
52         uint256 length = 0;
53         while (temp != 0) {
54             length++;
55             temp >>= 8;
56         }
57         return toHexString(value, length);
58     }
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
62      */
63     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
64         bytes memory buffer = new bytes(2 * length + 2);
65         buffer[0] = "0";
66         buffer[1] = "x";
67         for (uint256 i = 2 * length + 1; i > 1; --i) {
68             buffer[i] = _HEX_SYMBOLS[value & 0xf];
69             value >>= 4;
70         }
71         require(value == 0, "Strings: hex length insufficient");
72         return string(buffer);
73     }
74 }
75 
76 // File: contracts/Address.sol
77 
78 
79 
80 pragma solidity ^0.8.0;
81 
82 /**
83  * @dev Collection of functions related to the address type
84  */
85 library Address {
86     /**
87      * @dev Returns true if `account` is a contract.
88      *
89      * [IMPORTANT]
90      * ====
91      * It is unsafe to assume that an address for which this function returns
92      * false is an externally-owned account (EOA) and not a contract.
93      *
94      * Among others, `isContract` will return false for the following
95      * types of addresses:
96      *
97      *  - an externally-owned account
98      *  - a contract in construction
99      *  - an address where a contract will be created
100      *  - an address where a contract lived, but was destroyed
101      * ====
102      */
103     function isContract(address account) internal view returns (bool) {
104         // This method relies on extcodesize, which returns 0 for contracts in
105         // construction, since the code is only stored at the end of the
106         // constructor execution.
107 
108         uint256 size;
109         assembly {
110             size := extcodesize(account)
111         }
112         return size > 0;
113     }
114 
115     /**
116      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
117      * `recipient`, forwarding all available gas and reverting on errors.
118      *
119      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
120      * of certain opcodes, possibly making contracts go over the 2300 gas limit
121      * imposed by `transfer`, making them unable to receive funds via
122      * `transfer`. {sendValue} removes this limitation.
123      *
124      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
125      *
126      * IMPORTANT: because control is transferred to `recipient`, care must be
127      * taken to not create reentrancy vulnerabilities. Consider using
128      * {ReentrancyGuard} or the
129      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
130      */
131     function sendValue(address payable recipient, uint256 amount) internal {
132         require(address(this).balance >= amount, "Address: insufficient balance");
133 
134         (bool success, ) = recipient.call{value: amount}("");
135         require(success, "Address: unable to send value, recipient may have reverted");
136     }
137 
138     /**
139      * @dev Performs a Solidity function call using a low level `call`. A
140      * plain `call` is an unsafe replacement for a function call: use this
141      * function instead.
142      *
143      * If `target` reverts with a revert reason, it is bubbled up by this
144      * function (like regular Solidity function calls).
145      *
146      * Returns the raw returned data. To convert to the expected return value,
147      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
148      *
149      * Requirements:
150      *
151      * - `target` must be a contract.
152      * - calling `target` with `data` must not revert.
153      *
154      * _Available since v3.1._
155      */
156     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
157         return functionCall(target, data, "Address: low-level call failed");
158     }
159 
160     /**
161      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
162      * `errorMessage` as a fallback revert reason when `target` reverts.
163      *
164      * _Available since v3.1._
165      */
166     function functionCall(
167         address target,
168         bytes memory data,
169         string memory errorMessage
170     ) internal returns (bytes memory) {
171         return functionCallWithValue(target, data, 0, errorMessage);
172     }
173 
174     /**
175      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
176      * but also transferring `value` wei to `target`.
177      *
178      * Requirements:
179      *
180      * - the calling contract must have an ETH balance of at least `value`.
181      * - the called Solidity function must be `payable`.
182      *
183      * _Available since v3.1._
184      */
185     function functionCallWithValue(
186         address target,
187         bytes memory data,
188         uint256 value
189     ) internal returns (bytes memory) {
190         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
191     }
192 
193     /**
194      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
195      * with `errorMessage` as a fallback revert reason when `target` reverts.
196      *
197      * _Available since v3.1._
198      */
199     function functionCallWithValue(
200         address target,
201         bytes memory data,
202         uint256 value,
203         string memory errorMessage
204     ) internal returns (bytes memory) {
205         require(address(this).balance >= value, "Address: insufficient balance for call");
206         require(isContract(target), "Address: call to non-contract");
207 
208         (bool success, bytes memory returndata) = target.call{value: value}(data);
209         return _verifyCallResult(success, returndata, errorMessage);
210     }
211 
212     /**
213      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
214      * but performing a static call.
215      *
216      * _Available since v3.3._
217      */
218     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
219         return functionStaticCall(target, data, "Address: low-level static call failed");
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
224      * but performing a static call.
225      *
226      * _Available since v3.3._
227      */
228     function functionStaticCall(
229         address target,
230         bytes memory data,
231         string memory errorMessage
232     ) internal view returns (bytes memory) {
233         require(isContract(target), "Address: static call to non-contract");
234 
235         (bool success, bytes memory returndata) = target.staticcall(data);
236         return _verifyCallResult(success, returndata, errorMessage);
237     }
238 
239     /**
240      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
241      * but performing a delegate call.
242      *
243      * _Available since v3.4._
244      */
245     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
246         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
251      * but performing a delegate call.
252      *
253      * _Available since v3.4._
254      */
255     function functionDelegateCall(
256         address target,
257         bytes memory data,
258         string memory errorMessage
259     ) internal returns (bytes memory) {
260         require(isContract(target), "Address: delegate call to non-contract");
261 
262         (bool success, bytes memory returndata) = target.delegatecall(data);
263         return _verifyCallResult(success, returndata, errorMessage);
264     }
265 
266     function _verifyCallResult(
267         bool success,
268         bytes memory returndata,
269         string memory errorMessage
270     ) private pure returns (bytes memory) {
271         if (success) {
272             return returndata;
273         } else {
274             // Look for revert reason and bubble it up if present
275             if (returndata.length > 0) {
276                 // The easiest way to bubble the revert reason is using memory via assembly
277 
278                 assembly {
279                     let returndata_size := mload(returndata)
280                     revert(add(32, returndata), returndata_size)
281                 }
282             } else {
283                 revert(errorMessage);
284             }
285         }
286     }
287 }
288 
289 // File: contracts/IERC721Receiver.sol
290 
291 
292 
293 pragma solidity ^0.8.0;
294 
295 /**
296  * @title ERC721 token receiver interface
297  * @dev Interface for any contract that wants to support safeTransfers
298  * from ERC721 asset contracts.
299  */
300 interface IERC721Receiver {
301     /**
302      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
303      * by `operator` from `from`, this function is called.
304      *
305      * It must return its Solidity selector to confirm the token transfer.
306      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
307      *
308      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
309      */
310     function onERC721Received(
311         address operator,
312         address from,
313         uint256 tokenId,
314         bytes calldata data
315     ) external returns (bytes4);
316 }
317 
318 // File: contracts/IERC165.sol
319 
320 
321 
322 pragma solidity ^0.8.0;
323 
324 /**
325  * @dev Interface of the ERC165 standard, as defined in the
326  * https://eips.ethereum.org/EIPS/eip-165[EIP].
327  *
328  * Implementers can declare support of contract interfaces, which can then be
329  * queried by others ({ERC165Checker}).
330  *
331  * For an implementation, see {ERC165}.
332  */
333 interface IERC165 {
334     /**
335      * @dev Returns true if this contract implements the interface defined by
336      * `interfaceId`. See the corresponding
337      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
338      * to learn more about how these ids are created.
339      *
340      * This function call must use less than 30 000 gas.
341      */
342     function supportsInterface(bytes4 interfaceId) external view returns (bool);
343 }
344 
345 // File: contracts/ERC165.sol
346 
347 
348 
349 pragma solidity ^0.8.0;
350 
351 
352 /**
353  * @dev Implementation of the {IERC165} interface.
354  *
355  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
356  * for the additional interface id that will be supported. For example:
357  *
358  * ```solidity
359  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
360  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
361  * }
362  * ```
363  *
364  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
365  */
366 abstract contract ERC165 is IERC165 {
367     /**
368      * @dev See {IERC165-supportsInterface}.
369      */
370     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
371         return interfaceId == type(IERC165).interfaceId;
372     }
373 }
374 
375 // File: contracts/IERC721.sol
376 
377 
378 
379 pragma solidity ^0.8.0;
380 
381 
382 /**
383  * @dev Required interface of an ERC721 compliant contract.
384  */
385 interface IERC721 is IERC165 {
386     /**
387      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
388      */
389     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
390 
391     /**
392      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
393      */
394     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
395 
396     /**
397      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
398      */
399     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
400 
401     /**
402      * @dev Returns the number of tokens in ``owner``'s account.
403      */
404     function balanceOf(address owner) external view returns (uint256 balance);
405 
406     /**
407      * @dev Returns the owner of the `tokenId` token.
408      *
409      * Requirements:
410      *
411      * - `tokenId` must exist.
412      */
413     function ownerOf(uint256 tokenId) external view returns (address owner);
414 
415     /**
416      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
417      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
418      *
419      * Requirements:
420      *
421      * - `from` cannot be the zero address.
422      * - `to` cannot be the zero address.
423      * - `tokenId` token must exist and be owned by `from`.
424      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
425      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
426      *
427      * Emits a {Transfer} event.
428      */
429     function safeTransferFrom(
430         address from,
431         address to,
432         uint256 tokenId
433     ) external;
434 
435     /**
436      * @dev Transfers `tokenId` token from `from` to `to`.
437      *
438      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
439      *
440      * Requirements:
441      *
442      * - `from` cannot be the zero address.
443      * - `to` cannot be the zero address.
444      * - `tokenId` token must be owned by `from`.
445      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
446      *
447      * Emits a {Transfer} event.
448      */
449     function transferFrom(
450         address from,
451         address to,
452         uint256 tokenId
453     ) external;
454 
455     /**
456      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
457      * The approval is cleared when the token is transferred.
458      *
459      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
460      *
461      * Requirements:
462      *
463      * - The caller must own the token or be an approved operator.
464      * - `tokenId` must exist.
465      *
466      * Emits an {Approval} event.
467      */
468     function approve(address to, uint256 tokenId) external;
469 
470     /**
471      * @dev Returns the account approved for `tokenId` token.
472      *
473      * Requirements:
474      *
475      * - `tokenId` must exist.
476      */
477     function getApproved(uint256 tokenId) external view returns (address operator);
478 
479     /**
480      * @dev Approve or remove `operator` as an operator for the caller.
481      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
482      *
483      * Requirements:
484      *
485      * - The `operator` cannot be the caller.
486      *
487      * Emits an {ApprovalForAll} event.
488      */
489     function setApprovalForAll(address operator, bool _approved) external;
490 
491     /**
492      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
493      *
494      * See {setApprovalForAll}
495      */
496     function isApprovedForAll(address owner, address operator) external view returns (bool);
497 
498     /**
499      * @dev Safely transfers `tokenId` token from `from` to `to`.
500      *
501      * Requirements:
502      *
503      * - `from` cannot be the zero address.
504      * - `to` cannot be the zero address.
505      * - `tokenId` token must exist and be owned by `from`.
506      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
507      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
508      *
509      * Emits a {Transfer} event.
510      */
511     function safeTransferFrom(
512         address from,
513         address to,
514         uint256 tokenId,
515         bytes calldata data
516     ) external;
517 }
518 
519 // File: contracts/IERC721Enumerable.sol
520 
521 
522 
523 pragma solidity ^0.8.0;
524 
525 
526 /**
527  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
528  * @dev See https://eips.ethereum.org/EIPS/eip-721
529  */
530 interface IERC721Enumerable is IERC721 {
531     /**
532      * @dev Returns the total amount of tokens stored by the contract.
533      */
534     function totalSupply() external view returns (uint256);
535 
536     /**
537      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
538      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
539      */
540     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
541 
542     /**
543      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
544      * Use along with {totalSupply} to enumerate all tokens.
545      */
546     function tokenByIndex(uint256 index) external view returns (uint256);
547 }
548 
549 // File: contracts/IERC721Metadata.sol
550 
551 
552 
553 pragma solidity ^0.8.0;
554 
555 
556 /**
557  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
558  * @dev See https://eips.ethereum.org/EIPS/eip-721
559  */
560 interface IERC721Metadata is IERC721 {
561     /**
562      * @dev Returns the token collection name.
563      */
564     function name() external view returns (string memory);
565 
566     /**
567      * @dev Returns the token collection symbol.
568      */
569     function symbol() external view returns (string memory);
570 
571     /**
572      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
573      */
574     function tokenURI(uint256 tokenId) external view returns (string memory);
575 }
576 
577 // File: contracts/ReentrancyGuard.sol
578 
579 
580 
581 pragma solidity ^0.8.0;
582 
583 /**
584  * @dev Contract module that helps prevent reentrant calls to a function.
585  *
586  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
587  * available, which can be applied to functions to make sure there are no nested
588  * (reentrant) calls to them.
589  *
590  * Note that because there is a single `nonReentrant` guard, functions marked as
591  * `nonReentrant` may not call one another. This can be worked around by making
592  * those functions `private`, and then adding `external` `nonReentrant` entry
593  * points to them.
594  *
595  * TIP: If you would like to learn more about reentrancy and alternative ways
596  * to protect against it, check out our blog post
597  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
598  */
599 abstract contract ReentrancyGuard {
600     // Booleans are more expensive than uint256 or any type that takes up a full
601     // word because each write operation emits an extra SLOAD to first read the
602     // slot's contents, replace the bits taken up by the boolean, and then write
603     // back. This is the compiler's defense against contract upgrades and
604     // pointer aliasing, and it cannot be disabled.
605 
606     // The values being non-zero value makes deployment a bit more expensive,
607     // but in exchange the refund on every call to nonReentrant will be lower in
608     // amount. Since refunds are capped to a percentage of the total
609     // transaction's gas, it is best to keep them low in cases like this one, to
610     // increase the likelihood of the full refund coming into effect.
611     uint256 private constant _NOT_ENTERED = 1;
612     uint256 private constant _ENTERED = 2;
613 
614     uint256 private _status;
615 
616     constructor() {
617         _status = _NOT_ENTERED;
618     }
619 
620     /**
621      * @dev Prevents a contract from calling itself, directly or indirectly.
622      * Calling a `nonReentrant` function from another `nonReentrant`
623      * function is not supported. It is possible to prevent this from happening
624      * by making the `nonReentrant` function external, and make it call a
625      * `private` function that does the actual work.
626      */
627     modifier nonReentrant() {
628         // On the first call to nonReentrant, _notEntered will be true
629         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
630 
631         // Any calls to nonReentrant after this point will fail
632         _status = _ENTERED;
633 
634         _;
635 
636         // By storing the original value once again, a refund is triggered (see
637         // https://eips.ethereum.org/EIPS/eip-2200)
638         _status = _NOT_ENTERED;
639     }
640 }
641 
642 // File: contracts/Context.sol
643 
644 
645 
646 pragma solidity ^0.8.0;
647 
648 /*
649  * @dev Provides information about the current execution context, including the
650  * sender of the transaction and its data. While these are generally available
651  * via msg.sender and msg.data, they should not be accessed in such a direct
652  * manner, since when dealing with meta-transactions the account sending and
653  * paying for execution may not be the actual sender (as far as an application
654  * is concerned).
655  *
656  * This contract is only required for intermediate, library-like contracts.
657  */
658 abstract contract Context {
659     function _msgSender() internal view virtual returns (address) {
660         return msg.sender;
661     }
662 
663     function _msgData() internal view virtual returns (bytes calldata) {
664         return msg.data;
665     }
666 }
667 
668 // File: contracts/ERC721A.sol
669 
670 
671 
672 pragma solidity ^0.8.0;
673 
674 
675 
676 
677 
678 
679 
680 
681 
682 /**
683  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
684  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
685  *
686  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
687  *
688  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
689  *
690  * Does not support burning tokens to address(0).
691  */
692 contract ERC721A is
693   Context,
694   ERC165,
695   IERC721,
696   IERC721Metadata,
697   IERC721Enumerable
698 {
699   using Address for address;
700   using Strings for uint256;
701 
702   struct TokenOwnership {
703     address addr;
704     uint64 startTimestamp;
705   }
706 
707   struct AddressData {
708     uint128 balance;
709     uint128 numberMinted;
710   }
711 
712   uint256 private currentIndex = 0;
713 
714   uint256 internal immutable collectionSize;
715   uint256 internal immutable maxBatchSize;
716 
717   // Token name
718   string private _name;
719 
720   // Token symbol
721   string private _symbol;
722 
723   // Mapping from token ID to ownership details
724   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
725   mapping(uint256 => TokenOwnership) private _ownerships;
726 
727   // Mapping owner address to address data
728   mapping(address => AddressData) private _addressData;
729 
730   // Mapping from token ID to approved address
731   mapping(uint256 => address) private _tokenApprovals;
732 
733   // Mapping from owner to operator approvals
734   mapping(address => mapping(address => bool)) private _operatorApprovals;
735 
736   /**
737    * @dev
738    * `maxBatchSize` refers to how much a minter can mint at a time.
739    * `collectionSize_` refers to how many tokens are in the collection.
740    */
741   constructor(
742     string memory name_,
743     string memory symbol_,
744     uint256 maxBatchSize_,
745     uint256 collectionSize_
746   ) {
747     require(
748       collectionSize_ > 0,
749       "ERC721A: collection must have a nonzero supply"
750     );
751     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
752     _name = name_;
753     _symbol = symbol_;
754     maxBatchSize = maxBatchSize_;
755     collectionSize = collectionSize_;
756   }
757 
758   /**
759    * @dev See {IERC721Enumerable-totalSupply}.
760    */
761   function totalSupply() public view override returns (uint256) {
762     return currentIndex;
763   }
764 
765   /**
766    * @dev See {IERC721Enumerable-tokenByIndex}.
767    */
768   function tokenByIndex(uint256 index) public view override returns (uint256) {
769     require(index < totalSupply(), "ERC721A: global index out of bounds");
770     return index;
771   }
772 
773   /**
774    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
775    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
776    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
777    */
778   function tokenOfOwnerByIndex(address owner, uint256 index)
779     public
780     view
781     override
782     returns (uint256)
783   {
784     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
785     uint256 numMintedSoFar = totalSupply();
786     uint256 tokenIdsIdx = 0;
787     address currOwnershipAddr = address(0);
788     for (uint256 i = 0; i < numMintedSoFar; i++) {
789       TokenOwnership memory ownership = _ownerships[i];
790       if (ownership.addr != address(0)) {
791         currOwnershipAddr = ownership.addr;
792       }
793       if (currOwnershipAddr == owner) {
794         if (tokenIdsIdx == index) {
795           return i;
796         }
797         tokenIdsIdx++;
798       }
799     }
800     revert("ERC721A: unable to get token of owner by index");
801   }
802 
803   /**
804    * @dev See {IERC165-supportsInterface}.
805    */
806   function supportsInterface(bytes4 interfaceId)
807     public
808     view
809     virtual
810     override(ERC165, IERC165)
811     returns (bool)
812   {
813     return
814       interfaceId == type(IERC721).interfaceId ||
815       interfaceId == type(IERC721Metadata).interfaceId ||
816       interfaceId == type(IERC721Enumerable).interfaceId ||
817       super.supportsInterface(interfaceId);
818   }
819 
820   /**
821    * @dev See {IERC721-balanceOf}.
822    */
823   function balanceOf(address owner) public view override returns (uint256) {
824     require(owner != address(0), "ERC721A: balance query for the zero address");
825     return uint256(_addressData[owner].balance);
826   }
827 
828   function _numberMinted(address owner) internal view returns (uint256) {
829     require(
830       owner != address(0),
831       "ERC721A: number minted query for the zero address"
832     );
833     return uint256(_addressData[owner].numberMinted);
834   }
835 
836   function ownershipOf(uint256 tokenId)
837     internal
838     view
839     returns (TokenOwnership memory)
840   {
841     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
842 
843     uint256 lowestTokenToCheck;
844     if (tokenId >= maxBatchSize) {
845       lowestTokenToCheck = tokenId - maxBatchSize + 1;
846     }
847 
848     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
849       TokenOwnership memory ownership = _ownerships[curr];
850       if (ownership.addr != address(0)) {
851         return ownership;
852       }
853     }
854 
855     revert("ERC721A: unable to determine the owner of token");
856   }
857 
858   /**
859    * @dev See {IERC721-ownerOf}.
860    */
861   function ownerOf(uint256 tokenId) public view override returns (address) {
862     return ownershipOf(tokenId).addr;
863   }
864 
865   /**
866    * @dev See {IERC721Metadata-name}.
867    */
868   function name() public view virtual override returns (string memory) {
869     return _name;
870   }
871 
872   /**
873    * @dev See {IERC721Metadata-symbol}.
874    */
875   function symbol() public view virtual override returns (string memory) {
876     return _symbol;
877   }
878 
879   /**
880    * @dev See {IERC721Metadata-tokenURI}.
881    */
882   function tokenURI(uint256 tokenId)
883     public
884     view
885     virtual
886     override
887     returns (string memory)
888   {
889     require(
890       _exists(tokenId),
891       "ERC721Metadata: URI query for nonexistent token"
892     );
893 
894     string memory baseURI = _baseURI();
895     return
896       bytes(baseURI).length > 0
897         ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
898         : "";
899   }
900 
901   /**
902    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
903    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
904    * by default, can be overriden in child contracts.
905    */
906   function _baseURI() internal view virtual returns (string memory) {
907     return "";
908   }
909 
910   /**
911    * @dev See {IERC721-approve}.
912    */
913   function approve(address to, uint256 tokenId) public override {
914     address owner = ERC721A.ownerOf(tokenId);
915     require(to != owner, "ERC721A: approval to current owner");
916 
917     require(
918       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
919       "ERC721A: approve caller is not owner nor approved for all"
920     );
921 
922     _approve(to, tokenId, owner);
923   }
924 
925   /**
926    * @dev See {IERC721-getApproved}.
927    */
928   function getApproved(uint256 tokenId) public view override returns (address) {
929     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
930 
931     return _tokenApprovals[tokenId];
932   }
933 
934   /**
935    * @dev See {IERC721-setApprovalForAll}.
936    */
937   function setApprovalForAll(address operator, bool approved) public override {
938     require(operator != _msgSender(), "ERC721A: approve to caller");
939 
940     _operatorApprovals[_msgSender()][operator] = approved;
941     emit ApprovalForAll(_msgSender(), operator, approved);
942   }
943 
944   /**
945    * @dev See {IERC721-isApprovedForAll}.
946    */
947   function isApprovedForAll(address owner, address operator)
948     public
949     view
950     virtual
951     override
952     returns (bool)
953   {
954     return _operatorApprovals[owner][operator];
955   }
956 
957   /**
958    * @dev See {IERC721-transferFrom}.
959    */
960   function transferFrom(
961     address from,
962     address to,
963     uint256 tokenId
964   ) public override {
965     _transfer(from, to, tokenId);
966   }
967 
968   /**
969    * @dev See {IERC721-safeTransferFrom}.
970    */
971   function safeTransferFrom(
972     address from,
973     address to,
974     uint256 tokenId
975   ) public override {
976     safeTransferFrom(from, to, tokenId, "");
977   }
978 
979   /**
980    * @dev See {IERC721-safeTransferFrom}.
981    */
982   function safeTransferFrom(
983     address from,
984     address to,
985     uint256 tokenId,
986     bytes memory _data
987   ) public override {
988     _transfer(from, to, tokenId);
989     require(
990       _checkOnERC721Received(from, to, tokenId, _data),
991       "ERC721A: transfer to non ERC721Receiver implementer"
992     );
993   }
994 
995   /**
996    * @dev Returns whether `tokenId` exists.
997    *
998    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
999    *
1000    * Tokens start existing when they are minted (`_mint`),
1001    */
1002   function _exists(uint256 tokenId) internal view returns (bool) {
1003     return tokenId < currentIndex;
1004   }
1005 
1006   function _safeMint(address to, uint256 quantity) internal {
1007     _safeMint(to, quantity, "");
1008   }
1009 
1010   /**
1011    * @dev Mints `quantity` tokens and transfers them to `to`.
1012    *
1013    * Requirements:
1014    *
1015    * - there must be `quantity` tokens remaining unminted in the total collection.
1016    * - `to` cannot be the zero address.
1017    * - `quantity` cannot be larger than the max batch size.
1018    *
1019    * Emits a {Transfer} event.
1020    */
1021   function _safeMint(
1022     address to,
1023     uint256 quantity,
1024     bytes memory _data
1025   ) internal {
1026     uint256 startTokenId = currentIndex;
1027     require(to != address(0), "ERC721A: mint to the zero address");
1028     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1029     require(!_exists(startTokenId), "ERC721A: token already minted");
1030     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1031 
1032     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1033 
1034     AddressData memory addressData = _addressData[to];
1035     _addressData[to] = AddressData(
1036       addressData.balance + uint128(quantity),
1037       addressData.numberMinted + uint128(quantity)
1038     );
1039     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1040 
1041     uint256 updatedIndex = startTokenId;
1042 
1043     for (uint256 i = 0; i < quantity; i++) {
1044       emit Transfer(address(0), to, updatedIndex);
1045       require(
1046         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1047         "ERC721A: transfer to non ERC721Receiver implementer"
1048       );
1049       updatedIndex++;
1050     }
1051 
1052     currentIndex = updatedIndex;
1053     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1054   }
1055 
1056   /**
1057    * @dev Transfers `tokenId` from `from` to `to`.
1058    *
1059    * Requirements:
1060    *
1061    * - `to` cannot be the zero address.
1062    * - `tokenId` token must be owned by `from`.
1063    *
1064    * Emits a {Transfer} event.
1065    */
1066   function _transfer(
1067     address from,
1068     address to,
1069     uint256 tokenId
1070   ) private {
1071     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1072 
1073     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1074       getApproved(tokenId) == _msgSender() ||
1075       isApprovedForAll(prevOwnership.addr, _msgSender()));
1076 
1077     require(
1078       isApprovedOrOwner,
1079       "ERC721A: transfer caller is not owner nor approved"
1080     );
1081 
1082     require(
1083       prevOwnership.addr == from,
1084       "ERC721A: transfer from incorrect owner"
1085     );
1086     require(to != address(0), "ERC721A: transfer to the zero address");
1087 
1088     _beforeTokenTransfers(from, to, tokenId, 1);
1089 
1090     // Clear approvals from the previous owner
1091     _approve(address(0), tokenId, prevOwnership.addr);
1092 
1093     _addressData[from].balance -= 1;
1094     _addressData[to].balance += 1;
1095     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1096 
1097     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1098     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1099     uint256 nextTokenId = tokenId + 1;
1100     if (_ownerships[nextTokenId].addr == address(0)) {
1101       if (_exists(nextTokenId)) {
1102         _ownerships[nextTokenId] = TokenOwnership(
1103           prevOwnership.addr,
1104           prevOwnership.startTimestamp
1105         );
1106       }
1107     }
1108 
1109     emit Transfer(from, to, tokenId);
1110     _afterTokenTransfers(from, to, tokenId, 1);
1111   }
1112 
1113   /**
1114    * @dev Approve `to` to operate on `tokenId`
1115    *
1116    * Emits a {Approval} event.
1117    */
1118   function _approve(
1119     address to,
1120     uint256 tokenId,
1121     address owner
1122   ) private {
1123     _tokenApprovals[tokenId] = to;
1124     emit Approval(owner, to, tokenId);
1125   }
1126 
1127   uint256 public nextOwnerToExplicitlySet = 0;
1128 
1129   /**
1130    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1131    */
1132   function _setOwnersExplicit(uint256 quantity) internal {
1133     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1134     require(quantity > 0, "quantity must be nonzero");
1135     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1136     if (endIndex > collectionSize - 1) {
1137       endIndex = collectionSize - 1;
1138     }
1139     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1140     require(_exists(endIndex), "not enough minted yet for this cleanup");
1141     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1142       if (_ownerships[i].addr == address(0)) {
1143         TokenOwnership memory ownership = ownershipOf(i);
1144         _ownerships[i] = TokenOwnership(
1145           ownership.addr,
1146           ownership.startTimestamp
1147         );
1148       }
1149     }
1150     nextOwnerToExplicitlySet = endIndex + 1;
1151   }
1152 
1153   /**
1154    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1155    * The call is not executed if the target address is not a contract.
1156    *
1157    * @param from address representing the previous owner of the given token ID
1158    * @param to target address that will receive the tokens
1159    * @param tokenId uint256 ID of the token to be transferred
1160    * @param _data bytes optional data to send along with the call
1161    * @return bool whether the call correctly returned the expected magic value
1162    */
1163   function _checkOnERC721Received(
1164     address from,
1165     address to,
1166     uint256 tokenId,
1167     bytes memory _data
1168   ) private returns (bool) {
1169     if (to.isContract()) {
1170       try
1171         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1172       returns (bytes4 retval) {
1173         return retval == IERC721Receiver(to).onERC721Received.selector;
1174       } catch (bytes memory reason) {
1175         if (reason.length == 0) {
1176           revert("ERC721A: transfer to non ERC721Receiver implementer");
1177         } else {
1178           assembly {
1179             revert(add(32, reason), mload(reason))
1180           }
1181         }
1182       }
1183     } else {
1184       return true;
1185     }
1186   }
1187 
1188   /**
1189    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1190    *
1191    * startTokenId - the first token id to be transferred
1192    * quantity - the amount to be transferred
1193    *
1194    * Calling conditions:
1195    *
1196    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1197    * transferred to `to`.
1198    * - When `from` is zero, `tokenId` will be minted for `to`.
1199    */
1200   function _beforeTokenTransfers(
1201     address from,
1202     address to,
1203     uint256 startTokenId,
1204     uint256 quantity
1205   ) internal virtual {}
1206 
1207   /**
1208    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1209    * minting.
1210    *
1211    * startTokenId - the first token id to be transferred
1212    * quantity - the amount to be transferred
1213    *
1214    * Calling conditions:
1215    *
1216    * - when `from` and `to` are both non-zero.
1217    * - `from` and `to` are never both zero.
1218    */
1219   function _afterTokenTransfers(
1220     address from,
1221     address to,
1222     uint256 startTokenId,
1223     uint256 quantity
1224   ) internal virtual {}
1225 }
1226 
1227 // File: contracts/Ownable.sol
1228 
1229 
1230 
1231 pragma solidity ^0.8.0;
1232 
1233 
1234 /**
1235  * @dev Contract module which provides a basic access control mechanism, where
1236  * there is an account (an owner) that can be granted exclusive access to
1237  * specific functions.
1238  *
1239  * By default, the owner account will be the one that deploys the contract. This
1240  * can later be changed with {transferOwnership}.
1241  *
1242  * This module is used through inheritance. It will make available the modifier
1243  * `onlyOwner`, which can be applied to your functions to restrict their use to
1244  * the owner.
1245  */
1246 abstract contract Ownable is Context {
1247     address private _owner;
1248 
1249     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1250 
1251     /**
1252      * @dev Initializes the contract setting the deployer as the initial owner.
1253      */
1254     constructor() {
1255         _setOwner(_msgSender());
1256     }
1257 
1258     /**
1259      * @dev Returns the address of the current owner.
1260      */
1261     function owner() public view virtual returns (address) {
1262         return _owner;
1263     }
1264 
1265     /**
1266      * @dev Throws if called by any account other than the owner.
1267      */
1268     modifier onlyOwner() {
1269         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1270         _;
1271     }
1272 
1273     /**
1274      * @dev Leaves the contract without owner. It will not be possible to call
1275      * `onlyOwner` functions anymore. Can only be called by the current owner.
1276      *
1277      * NOTE: Renouncing ownership will leave the contract without an owner,
1278      * thereby removing any functionality that is only available to the owner.
1279      */
1280     function renounceOwnership() public virtual onlyOwner {
1281         _setOwner(address(0));
1282     }
1283 
1284     /**
1285      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1286      * Can only be called by the current owner.
1287      */
1288     function transferOwnership(address newOwner) public virtual onlyOwner {
1289         require(newOwner != address(0), "Ownable: new owner is the zero address");
1290         _setOwner(newOwner);
1291     }
1292 
1293     function _setOwner(address newOwner) private {
1294         address oldOwner = _owner;
1295         _owner = newOwner;
1296         emit OwnershipTransferred(oldOwner, newOwner);
1297     }
1298 }
1299 
1300 // File: contracts/Y00ts.sol
1301 
1302 
1303 
1304 pragma solidity ^0.8.0;
1305 
1306 
1307 
1308 
1309 
1310 contract Y00ts is Ownable, ERC721A, ReentrancyGuard {
1311   uint256 public immutable maxPerAddressDuringMint;
1312   uint256 public immutable amountForDevs;
1313   mapping(address => uint256) public allowlist;
1314 
1315   constructor(
1316     uint256 maxBatchSize_,
1317     uint256 collectionSize_,
1318     uint256 amountForDevs_
1319   ) ERC721A("Y00ts Ethereum", "YTS", maxBatchSize_, collectionSize_) {
1320     maxPerAddressDuringMint = maxBatchSize_;
1321     amountForDevs = amountForDevs_;
1322   }
1323 
1324   modifier callerIsUser() {
1325     require(tx.origin == msg.sender, "The caller is another contract");
1326     _;
1327   }
1328 
1329 
1330 
1331   function mint(uint256 quantity) external callerIsUser {
1332 
1333     require(totalSupply() + quantity <= collectionSize, "reached max supply");
1334     require(
1335       numberMinted(msg.sender) + quantity <= maxPerAddressDuringMint,
1336       "can not mint this many"
1337     );
1338     _safeMint(msg.sender, quantity);
1339   }
1340 
1341   // For marketing etc.
1342   function devMint(uint256 quantity) external onlyOwner {
1343     require(
1344       totalSupply() + quantity <= amountForDevs,
1345       "too many already minted before dev mint"
1346     );
1347     require(
1348       quantity % maxBatchSize == 0,
1349       "can only mint a multiple of the maxBatchSize"
1350     );
1351     uint256 numChunks = quantity / maxBatchSize;
1352     for (uint256 i = 0; i < numChunks; i++) {
1353       _safeMint(msg.sender, maxBatchSize);
1354     }
1355   }
1356 
1357   // // metadata URI
1358   string private _baseTokenURI;
1359 
1360   function _baseURI() internal view virtual override returns (string memory) {
1361     return _baseTokenURI;
1362   }
1363 
1364   function setBaseURI(string calldata baseURI) external onlyOwner {
1365     _baseTokenURI = baseURI;
1366   }
1367 
1368   function withdrawMoney() external onlyOwner nonReentrant {
1369     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1370     require(success, "Transfer failed.");
1371   }
1372 
1373   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1374     _setOwnersExplicit(quantity);
1375   }
1376 
1377   function numberMinted(address owner) public view returns (uint256) {
1378     return _numberMinted(owner);
1379   }
1380 
1381   function getOwnershipData(uint256 tokenId)
1382     external
1383     view
1384     returns (TokenOwnership memory)
1385   {
1386     return ownershipOf(tokenId);
1387   }
1388 
1389 }