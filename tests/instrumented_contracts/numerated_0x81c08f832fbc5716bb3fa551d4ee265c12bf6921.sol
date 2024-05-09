1 /**
2  *Submitted for verification at Etherscan.io on 06-28-2023
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // File: contracts/Strings.sol
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
72 // File: contracts/Address.sol
73 
74 
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
205         return _verifyCallResult(success, returndata, errorMessage);
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
232         return _verifyCallResult(success, returndata, errorMessage);
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
259         return _verifyCallResult(success, returndata, errorMessage);
260     }
261 
262     function _verifyCallResult(
263         bool success,
264         bytes memory returndata,
265         string memory errorMessage
266     ) private pure returns (bytes memory) {
267         if (success) {
268             return returndata;
269         } else {
270             // Look for revert reason and bubble it up if present
271             if (returndata.length > 0) {
272                 // The easiest way to bubble the revert reason is using memory via assembly
273 
274                 assembly {
275                     let returndata_size := mload(returndata)
276                     revert(add(32, returndata), returndata_size)
277                 }
278             } else {
279                 revert(errorMessage);
280             }
281         }
282     }
283 }
284 
285 // File: contracts/IERC721Receiver.sol
286 
287 
288 
289 pragma solidity ^0.8.0;
290 
291 /**
292  * @title ERC721 token receiver interface
293  * @dev Interface for any contract that wants to support safeTransfers
294  * from ERC721 asset contracts.
295  */
296 interface IERC721Receiver {
297     /**
298      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
299      * by `operator` from `from`, this function is called.
300      *
301      * It must return its Solidity selector to confirm the token transfer.
302      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
303      *
304      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
305      */
306     function onERC721Received(
307         address operator,
308         address from,
309         uint256 tokenId,
310         bytes calldata data
311     ) external returns (bytes4);
312 }
313 
314 // File: contracts/IERC165.sol
315 
316 
317 
318 pragma solidity ^0.8.0;
319 
320 /**
321  * @dev Interface of the ERC165 standard, as defined in the
322  * https://eips.ethereum.org/EIPS/eip-165[EIP].
323  *
324  * Implementers can declare support of contract interfaces, which can then be
325  * queried by others ({ERC165Checker}).
326  *
327  * For an implementation, see {ERC165}.
328  */
329 interface IERC165 {
330     /**
331      * @dev Returns true if this contract implements the interface defined by
332      * `interfaceId`. See the corresponding
333      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
334      * to learn more about how these ids are created.
335      *
336      * This function call must use less than 30 000 gas.
337      */
338     function supportsInterface(bytes4 interfaceId) external view returns (bool);
339 }
340 
341 // File: contracts/ERC165.sol
342 
343 
344 
345 pragma solidity ^0.8.0;
346 
347 
348 /**
349  * @dev Implementation of the {IERC165} interface.
350  *
351  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
352  * for the additional interface id that will be supported. For example:
353  *
354  * ```solidity
355  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
356  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
357  * }
358  * ```
359  *
360  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
361  */
362 abstract contract ERC165 is IERC165 {
363     /**
364      * @dev See {IERC165-supportsInterface}.
365      */
366     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
367         return interfaceId == type(IERC165).interfaceId;
368     }
369 }
370 
371 // File: contracts/IERC721.sol
372 
373 
374 
375 pragma solidity ^0.8.0;
376 
377 
378 /**
379  * @dev Required interface of an ERC721 compliant contract.
380  */
381 interface IERC721 is IERC165 {
382     /**
383      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
384      */
385     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
386 
387     /**
388      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
389      */
390     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
391 
392     /**
393      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
394      */
395     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
396 
397     /**
398      * @dev Returns the number of tokens in ``owner``'s account.
399      */
400     function balanceOf(address owner) external view returns (uint256 balance);
401 
402     /**
403      * @dev Returns the owner of the `tokenId` token.
404      *
405      * Requirements:
406      *
407      * - `tokenId` must exist.
408      */
409     function ownerOf(uint256 tokenId) external view returns (address owner);
410 
411     /**
412      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
413      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
414      *
415      * Requirements:
416      *
417      * - `from` cannot be the zero address.
418      * - `to` cannot be the zero address.
419      * - `tokenId` token must exist and be owned by `from`.
420      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
421      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
422      *
423      * Emits a {Transfer} event.
424      */
425     function safeTransferFrom(
426         address from,
427         address to,
428         uint256 tokenId
429     ) external;
430 
431     /**
432      * @dev Transfers `tokenId` token from `from` to `to`.
433      *
434      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
435      *
436      * Requirements:
437      *
438      * - `from` cannot be the zero address.
439      * - `to` cannot be the zero address.
440      * - `tokenId` token must be owned by `from`.
441      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
442      *
443      * Emits a {Transfer} event.
444      */
445     function transferFrom(
446         address from,
447         address to,
448         uint256 tokenId
449     ) external;
450 
451     /**
452      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
453      * The approval is cleared when the token is transferred.
454      *
455      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
456      *
457      * Requirements:
458      *
459      * - The caller must own the token or be an approved operator.
460      * - `tokenId` must exist.
461      *
462      * Emits an {Approval} event.
463      */
464     function approve(address to, uint256 tokenId) external;
465 
466     /**
467      * @dev Returns the account approved for `tokenId` token.
468      *
469      * Requirements:
470      *
471      * - `tokenId` must exist.
472      */
473     function getApproved(uint256 tokenId) external view returns (address operator);
474 
475     /**
476      * @dev Approve or remove `operator` as an operator for the caller.
477      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
478      *
479      * Requirements:
480      *
481      * - The `operator` cannot be the caller.
482      *
483      * Emits an {ApprovalForAll} event.
484      */
485     function setApprovalForAll(address operator, bool _approved) external;
486 
487     /**
488      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
489      *
490      * See {setApprovalForAll}
491      */
492     function isApprovedForAll(address owner, address operator) external view returns (bool);
493 
494     /**
495      * @dev Safely transfers `tokenId` token from `from` to `to`.
496      *
497      * Requirements:
498      *
499      * - `from` cannot be the zero address.
500      * - `to` cannot be the zero address.
501      * - `tokenId` token must exist and be owned by `from`.
502      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
503      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
504      *
505      * Emits a {Transfer} event.
506      */
507     function safeTransferFrom(
508         address from,
509         address to,
510         uint256 tokenId,
511         bytes calldata data
512     ) external;
513 }
514 
515 // File: contracts/IERC721Enumerable.sol
516 
517 
518 
519 pragma solidity ^0.8.0;
520 
521 
522 /**
523  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
524  * @dev See https://eips.ethereum.org/EIPS/eip-721
525  */
526 interface IERC721Enumerable is IERC721 {
527     /**
528      * @dev Returns the total amount of tokens stored by the contract.
529      */
530     function totalSupply() external view returns (uint256);
531 
532     /**
533      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
534      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
535      */
536     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
537 
538     /**
539      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
540      * Use along with {totalSupply} to enumerate all tokens.
541      */
542     function tokenByIndex(uint256 index) external view returns (uint256);
543 }
544 
545 // File: contracts/IERC721Metadata.sol
546 
547 
548 
549 pragma solidity ^0.8.0;
550 
551 
552 /**
553  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
554  * @dev See https://eips.ethereum.org/EIPS/eip-721
555  */
556 interface IERC721Metadata is IERC721 {
557     /**
558      * @dev Returns the token collection name.
559      */
560     function name() external view returns (string memory);
561 
562     /**
563      * @dev Returns the token collection symbol.
564      */
565     function symbol() external view returns (string memory);
566 
567     /**
568      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
569      */
570     function tokenURI(uint256 tokenId) external view returns (string memory);
571 }
572 
573 // File: contracts/ReentrancyGuard.sol
574 
575 
576 
577 pragma solidity ^0.8.0;
578 
579 /**
580  * @dev Contract module that helps prevent reentrant calls to a function.
581  *
582  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
583  * available, which can be applied to functions to make sure there are no nested
584  * (reentrant) calls to them.
585  *
586  * Note that because there is a single `nonReentrant` guard, functions marked as
587  * `nonReentrant` may not call one another. This can be worked around by making
588  * those functions `private`, and then adding `external` `nonReentrant` entry
589  * points to them.
590  *
591  * TIP: If you would like to learn more about reentrancy and alternative ways
592  * to protect against it, check out our blog post
593  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
594  */
595 abstract contract ReentrancyGuard {
596     // Booleans are more expensive than uint256 or any type that takes up a full
597     // word because each write operation emits an extra SLOAD to first read the
598     // slot's contents, replace the bits taken up by the boolean, and then write
599     // back. This is the compiler's defense against contract upgrades and
600     // pointer aliasing, and it cannot be disabled.
601 
602     // The values being non-zero value makes deployment a bit more expensive,
603     // but in exchange the refund on every call to nonReentrant will be lower in
604     // amount. Since refunds are capped to a percentage of the total
605     // transaction's gas, it is best to keep them low in cases like this one, to
606     // increase the likelihood of the full refund coming into effect.
607     uint256 private constant _NOT_ENTERED = 1;
608     uint256 private constant _ENTERED = 2;
609 
610     uint256 private _status;
611 
612     constructor() {
613         _status = _NOT_ENTERED;
614     }
615 
616     /**
617      * @dev Prevents a contract from calling itself, directly or indirectly.
618      * Calling a `nonReentrant` function from another `nonReentrant`
619      * function is not supported. It is possible to prevent this from happening
620      * by making the `nonReentrant` function external, and make it call a
621      * `private` function that does the actual work.
622      */
623     modifier nonReentrant() {
624         // On the first call to nonReentrant, _notEntered will be true
625         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
626 
627         // Any calls to nonReentrant after this point will fail
628         _status = _ENTERED;
629 
630         _;
631 
632         // By storing the original value once again, a refund is triggered (see
633         // https://eips.ethereum.org/EIPS/eip-2200)
634         _status = _NOT_ENTERED;
635     }
636 }
637 
638 // File: contracts/Context.sol
639 
640 
641 
642 pragma solidity ^0.8.0;
643 
644 /*
645  * @dev Provides information about the current execution context, including the
646  * sender of the transaction and its data. While these are generally available
647  * via msg.sender and msg.data, they should not be accessed in such a direct
648  * manner, since when dealing with meta-transactions the account sending and
649  * paying for execution may not be the actual sender (as far as an application
650  * is concerned).
651  *
652  * This contract is only required for intermediate, library-like contracts.
653  */
654 abstract contract Context {
655     function _msgSender() internal view virtual returns (address) {
656         return msg.sender;
657     }
658 
659     function _msgData() internal view virtual returns (bytes calldata) {
660         return msg.data;
661     }
662 }
663 
664 // File: contracts/ERC721A.sol
665 
666 
667 
668 pragma solidity ^0.8.0;
669 
670 
671 
672 
673 
674 
675 
676 
677 
678 /**
679  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
680  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
681  *
682  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
683  *
684  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
685  *
686  * Does not support burning tokens to address(0).
687  */
688 contract ERC721A is
689   Context,
690   ERC165,
691   IERC721,
692   IERC721Metadata,
693   IERC721Enumerable
694 {
695   using Address for address;
696   using Strings for uint256;
697 
698   struct TokenOwnership {
699     address addr;
700     uint64 startTimestamp;
701   }
702 
703   struct AddressData {
704     uint128 balance;
705     uint128 numberMinted;
706   }
707 
708   uint256 private currentIndex = 0;
709 
710   uint256 internal immutable collectionSize;
711   uint256 internal immutable maxBatchSize;
712 
713   // Token name
714   string private _name;
715 
716   // Token symbol
717   string private _symbol;
718 
719   // Mapping from token ID to ownership details
720   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
721   mapping(uint256 => TokenOwnership) private _ownerships;
722 
723   // Mapping owner address to address data
724   mapping(address => AddressData) private _addressData;
725 
726   // Mapping from token ID to approved address
727   mapping(uint256 => address) private _tokenApprovals;
728 
729   // Mapping from owner to operator approvals
730   mapping(address => mapping(address => bool)) private _operatorApprovals;
731 
732   /**
733    * @dev
734    * `maxBatchSize` refers to how much a minter can mint at a time.
735    * `collectionSize_` refers to how many tokens are in the collection.
736    */
737   constructor(
738     string memory name_,
739     string memory symbol_,
740     uint256 maxBatchSize_,
741     uint256 collectionSize_
742   ) {
743     require(
744       collectionSize_ > 0,
745       "ERC721A: collection must have a nonzero supply"
746     );
747     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
748     _name = name_;
749     _symbol = symbol_;
750     maxBatchSize = maxBatchSize_;
751     collectionSize = collectionSize_;
752   }
753 
754   /**
755    * @dev See {IERC721Enumerable-totalSupply}.
756    */
757   function totalSupply() public view override returns (uint256) {
758     return currentIndex;
759   }
760 
761   /**
762    * @dev See {IERC721Enumerable-tokenByIndex}.
763    */
764   function tokenByIndex(uint256 index) public view override returns (uint256) {
765     require(index < totalSupply(), "ERC721A: global index out of bounds");
766     return index;
767   }
768 
769   /**
770    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
771    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
772    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
773    */
774   function tokenOfOwnerByIndex(address owner, uint256 index)
775     public
776     view
777     override
778     returns (uint256)
779   {
780     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
781     uint256 numMintedSoFar = totalSupply();
782     uint256 tokenIdsIdx = 0;
783     address currOwnershipAddr = address(0);
784     for (uint256 i = 0; i < numMintedSoFar; i++) {
785       TokenOwnership memory ownership = _ownerships[i];
786       if (ownership.addr != address(0)) {
787         currOwnershipAddr = ownership.addr;
788       }
789       if (currOwnershipAddr == owner) {
790         if (tokenIdsIdx == index) {
791           return i;
792         }
793         tokenIdsIdx++;
794       }
795     }
796     revert("ERC721A: unable to get token of owner by index");
797   }
798 
799   /**
800    * @dev See {IERC165-supportsInterface}.
801    */
802   function supportsInterface(bytes4 interfaceId)
803     public
804     view
805     virtual
806     override(ERC165, IERC165)
807     returns (bool)
808   {
809     return
810       interfaceId == type(IERC721).interfaceId ||
811       interfaceId == type(IERC721Metadata).interfaceId ||
812       interfaceId == type(IERC721Enumerable).interfaceId ||
813       super.supportsInterface(interfaceId);
814   }
815 
816   /**
817    * @dev See {IERC721-balanceOf}.
818    */
819   function balanceOf(address owner) public view override returns (uint256) {
820     require(owner != address(0), "ERC721A: balance query for the zero address");
821     return uint256(_addressData[owner].balance);
822   }
823 
824   function _numberMinted(address owner) internal view returns (uint256) {
825     require(
826       owner != address(0),
827       "ERC721A: number minted query for the zero address"
828     );
829     return uint256(_addressData[owner].numberMinted);
830   }
831 
832   function ownershipOf(uint256 tokenId)
833     internal
834     view
835     returns (TokenOwnership memory)
836   {
837     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
838 
839     uint256 lowestTokenToCheck;
840     if (tokenId >= maxBatchSize) {
841       lowestTokenToCheck = tokenId - maxBatchSize + 1;
842     }
843 
844     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
845       TokenOwnership memory ownership = _ownerships[curr];
846       if (ownership.addr != address(0)) {
847         return ownership;
848       }
849     }
850 
851     revert("ERC721A: unable to determine the owner of token");
852   }
853 
854   /**
855    * @dev See {IERC721-ownerOf}.
856    */
857   function ownerOf(uint256 tokenId) public view override returns (address) {
858     return ownershipOf(tokenId).addr;
859   }
860 
861   /**
862    * @dev See {IERC721Metadata-name}.
863    */
864   function name() public view virtual override returns (string memory) {
865     return _name;
866   }
867 
868   /**
869    * @dev See {IERC721Metadata-symbol}.
870    */
871   function symbol() public view virtual override returns (string memory) {
872     return _symbol;
873   }
874 
875   /**
876    * @dev See {IERC721Metadata-tokenURI}.
877    */
878   function tokenURI(uint256 tokenId)
879     public
880     view
881     virtual
882     override
883     returns (string memory)
884   {
885     require(
886       _exists(tokenId),
887       "ERC721Metadata: URI query for nonexistent token"
888     );
889 
890     string memory baseURI = _baseURI();
891     return
892       bytes(baseURI).length > 0
893         ? string(abi.encodePacked(baseURI, tokenId.toString()))
894         : "";
895   }
896 
897   /**
898    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
899    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
900    * by default, can be overriden in child contracts.
901    */
902   function _baseURI() internal view virtual returns (string memory) {
903     return "";
904   }
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
1011    * - there must be `quantity` tokens remaining unminted in the total collection.
1012    * - `to` cannot be the zero address.
1013    * - `quantity` cannot be larger than the max batch size.
1014    *
1015    * Emits a {Transfer} event.
1016    */
1017   function _safeMint(
1018     address to,
1019     uint256 quantity,
1020     bytes memory _data
1021   ) internal {
1022     uint256 startTokenId = currentIndex;
1023     require(to != address(0), "ERC721A: mint to the zero address");
1024     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1025     require(!_exists(startTokenId), "ERC721A: token already minted");
1026     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1027 
1028     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1029 
1030     AddressData memory addressData = _addressData[to];
1031     _addressData[to] = AddressData(
1032       addressData.balance + uint128(quantity),
1033       addressData.numberMinted + uint128(quantity)
1034     );
1035     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1036 
1037     uint256 updatedIndex = startTokenId;
1038 
1039     for (uint256 i = 0; i < quantity; i++) {
1040       emit Transfer(address(0), to, updatedIndex);
1041       require(
1042         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1043         "ERC721A: transfer to non ERC721Receiver implementer"
1044       );
1045       updatedIndex++;
1046     }
1047 
1048     currentIndex = updatedIndex;
1049     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1050   }
1051 
1052   /**
1053    * @dev Transfers `tokenId` from `from` to `to`.
1054    *
1055    * Requirements:
1056    *
1057    * - `to` cannot be the zero address.
1058    * - `tokenId` token must be owned by `from`.
1059    *
1060    * Emits a {Transfer} event.
1061    */
1062   function _transfer(
1063     address from,
1064     address to,
1065     uint256 tokenId
1066   ) private {
1067     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1068 
1069     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1070       getApproved(tokenId) == _msgSender() ||
1071       isApprovedForAll(prevOwnership.addr, _msgSender()));
1072 
1073     require(
1074       isApprovedOrOwner,
1075       "ERC721A: transfer caller is not owner nor approved"
1076     );
1077 
1078     require(
1079       prevOwnership.addr == from,
1080       "ERC721A: transfer from incorrect owner"
1081     );
1082     require(to != address(0), "ERC721A: transfer to the zero address");
1083 
1084     _beforeTokenTransfers(from, to, tokenId, 1);
1085 
1086     // Clear approvals from the previous owner
1087     _approve(address(0), tokenId, prevOwnership.addr);
1088 
1089     _addressData[from].balance -= 1;
1090     _addressData[to].balance += 1;
1091     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1092 
1093     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1094     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1095     uint256 nextTokenId = tokenId + 1;
1096     if (_ownerships[nextTokenId].addr == address(0)) {
1097       if (_exists(nextTokenId)) {
1098         _ownerships[nextTokenId] = TokenOwnership(
1099           prevOwnership.addr,
1100           prevOwnership.startTimestamp
1101         );
1102       }
1103     }
1104 
1105     emit Transfer(from, to, tokenId);
1106     _afterTokenTransfers(from, to, tokenId, 1);
1107   }
1108 
1109   /**
1110    * @dev Approve `to` to operate on `tokenId`
1111    *
1112    * Emits a {Approval} event.
1113    */
1114   function _approve(
1115     address to,
1116     uint256 tokenId,
1117     address owner
1118   ) private {
1119     _tokenApprovals[tokenId] = to;
1120     emit Approval(owner, to, tokenId);
1121   }
1122 
1123   uint256 public nextOwnerToExplicitlySet = 0;
1124 
1125   /**
1126    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1127    */
1128   function _setOwnersExplicit(uint256 quantity) internal {
1129     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1130     require(quantity > 0, "quantity must be nonzero");
1131     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1132     if (endIndex > collectionSize - 1) {
1133       endIndex = collectionSize - 1;
1134     }
1135     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1136     require(_exists(endIndex), "not enough minted yet for this cleanup");
1137     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1138       if (_ownerships[i].addr == address(0)) {
1139         TokenOwnership memory ownership = ownershipOf(i);
1140         _ownerships[i] = TokenOwnership(
1141           ownership.addr,
1142           ownership.startTimestamp
1143         );
1144       }
1145     }
1146     nextOwnerToExplicitlySet = endIndex + 1;
1147   }
1148 
1149   /**
1150    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1151    * The call is not executed if the target address is not a contract.
1152    *
1153    * @param from address representing the previous owner of the given token ID
1154    * @param to target address that will receive the tokens
1155    * @param tokenId uint256 ID of the token to be transferred
1156    * @param _data bytes optional data to send along with the call
1157    * @return bool whether the call correctly returned the expected magic value
1158    */
1159   function _checkOnERC721Received(
1160     address from,
1161     address to,
1162     uint256 tokenId,
1163     bytes memory _data
1164   ) private returns (bool) {
1165     if (to.isContract()) {
1166       try
1167         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1168       returns (bytes4 retval) {
1169         return retval == IERC721Receiver(to).onERC721Received.selector;
1170       } catch (bytes memory reason) {
1171         if (reason.length == 0) {
1172           revert("ERC721A: transfer to non ERC721Receiver implementer");
1173         } else {
1174           assembly {
1175             revert(add(32, reason), mload(reason))
1176           }
1177         }
1178       }
1179     } else {
1180       return true;
1181     }
1182   }
1183 
1184   /**
1185    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1186    *
1187    * startTokenId - the first token id to be transferred
1188    * quantity - the amount to be transferred
1189    *
1190    * Calling conditions:
1191    *
1192    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1193    * transferred to `to`.
1194    * - When `from` is zero, `tokenId` will be minted for `to`.
1195    */
1196   function _beforeTokenTransfers(
1197     address from,
1198     address to,
1199     uint256 startTokenId,
1200     uint256 quantity
1201   ) internal virtual {}
1202 
1203   /**
1204    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1205    * minting.
1206    *
1207    * startTokenId - the first token id to be transferred
1208    * quantity - the amount to be transferred
1209    *
1210    * Calling conditions:
1211    *
1212    * - when `from` and `to` are both non-zero.
1213    * - `from` and `to` are never both zero.
1214    */
1215   function _afterTokenTransfers(
1216     address from,
1217     address to,
1218     uint256 startTokenId,
1219     uint256 quantity
1220   ) internal virtual {}
1221 }
1222 
1223 // File: contracts/Ownable.sol
1224 
1225 
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
1251         _setOwner(_msgSender());
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
1277         _setOwner(address(0));
1278     }
1279 
1280     /**
1281      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1282      * Can only be called by the current owner.
1283      */
1284     function transferOwnership(address newOwner) public virtual onlyOwner {
1285         require(newOwner != address(0), "Ownable: new owner is the zero address");
1286         _setOwner(newOwner);
1287     }
1288 
1289     function _setOwner(address newOwner) private {
1290         address oldOwner = _owner;
1291         _owner = newOwner;
1292         emit OwnershipTransferred(oldOwner, newOwner);
1293     }
1294 }
1295 
1296 // File: contracts/bnet.sol
1297 
1298 
1299 
1300 pragma solidity ^0.8.0;
1301 
1302 
1303 
1304 
1305 
1306 contract bnet is Ownable, ERC721A, ReentrancyGuard {
1307   uint256 public immutable maxPerAddressDuringMint;
1308 
1309 
1310   constructor(
1311     uint256 maxBatchSize_,
1312     uint256 collectionSize_
1313   ) ERC721A("bnet", "BNET", maxBatchSize_, collectionSize_) {
1314     maxPerAddressDuringMint = maxBatchSize_;
1315   }
1316 
1317   modifier callerIsUser() {
1318     require(tx.origin == msg.sender, "The caller is another contract");
1319     _;
1320   }
1321 
1322   function mint(uint256 quantity) external callerIsUser {
1323 
1324     require(totalSupply() + quantity <= collectionSize, "reached max supply");
1325     require(
1326       numberMinted(msg.sender) + quantity <= maxPerAddressDuringMint,
1327       "can not mint this many"
1328     );
1329     _safeMint(msg.sender, quantity);
1330   }
1331 
1332 
1333   // // metadata URI
1334   string private _baseTokenURI;
1335 
1336   function _baseURI() internal view virtual override returns (string memory) {
1337     return _baseTokenURI;
1338   }
1339 
1340   function setBaseURI(string calldata baseURI) external onlyOwner {
1341     _baseTokenURI = baseURI;
1342   }
1343 
1344   function withdrawMoney() external onlyOwner nonReentrant {
1345     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1346     require(success, "Transfer failed.");
1347   }
1348 
1349   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1350     _setOwnersExplicit(quantity);
1351   }
1352 
1353   function numberMinted(address owner) public view returns (uint256) {
1354     return _numberMinted(owner);
1355   }
1356 
1357   function getOwnershipData(uint256 tokenId)
1358     external
1359     view
1360     returns (TokenOwnership memory)
1361   {
1362     return ownershipOf(tokenId);
1363   }
1364 
1365 }