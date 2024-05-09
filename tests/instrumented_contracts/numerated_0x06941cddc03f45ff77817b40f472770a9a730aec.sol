1 /**
2  *Submitted for verification at Etherscan.io on 2022-09-13
3 */
4 // memegenesis.com
5 // SPDX-License-Identifier: MIT
6 
7 // File: contracts/Strings.sol
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev String operations.
12  */
13 library Strings {
14     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
15 
16     /**
17      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
18      */
19     function toString(uint256 value) internal pure returns (string memory) {
20         // Inspired by OraclizeAPI's implementation - MIT licence
21         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
22 
23         if (value == 0) {
24             return "0";
25         }
26         uint256 temp = value;
27         uint256 digits;
28         while (temp != 0) {
29             digits++;
30             temp /= 10;
31         }
32         bytes memory buffer = new bytes(digits);
33         while (value != 0) {
34             digits -= 1;
35             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
36             value /= 10;
37         }
38         return string(buffer);
39     }
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
43      */
44     function toHexString(uint256 value) internal pure returns (string memory) {
45         if (value == 0) {
46             return "0x00";
47         }
48         uint256 temp = value;
49         uint256 length = 0;
50         while (temp != 0) {
51             length++;
52             temp >>= 8;
53         }
54         return toHexString(value, length);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
59      */
60     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
61         bytes memory buffer = new bytes(2 * length + 2);
62         buffer[0] = "0";
63         buffer[1] = "x";
64         for (uint256 i = 2 * length + 1; i > 1; --i) {
65             buffer[i] = _HEX_SYMBOLS[value & 0xf];
66             value >>= 4;
67         }
68         require(value == 0, "Strings: hex length insufficient");
69         return string(buffer);
70     }
71 }
72 
73 // File: contracts/Address.sol
74 
75 
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
206         return _verifyCallResult(success, returndata, errorMessage);
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
233         return _verifyCallResult(success, returndata, errorMessage);
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
260         return _verifyCallResult(success, returndata, errorMessage);
261     }
262 
263     function _verifyCallResult(
264         bool success,
265         bytes memory returndata,
266         string memory errorMessage
267     ) private pure returns (bytes memory) {
268         if (success) {
269             return returndata;
270         } else {
271             // Look for revert reason and bubble it up if present
272             if (returndata.length > 0) {
273                 // The easiest way to bubble the revert reason is using memory via assembly
274 
275                 assembly {
276                     let returndata_size := mload(returndata)
277                     revert(add(32, returndata), returndata_size)
278                 }
279             } else {
280                 revert(errorMessage);
281             }
282         }
283     }
284 }
285 
286 // File: contracts/IERC721Receiver.sol
287 
288 
289 
290 pragma solidity ^0.8.0;
291 
292 /**
293  * @title ERC721 token receiver interface
294  * @dev Interface for any contract that wants to support safeTransfers
295  * from ERC721 asset contracts.
296  */
297 interface IERC721Receiver {
298     /**
299      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
300      * by `operator` from `from`, this function is called.
301      *
302      * It must return its Solidity selector to confirm the token transfer.
303      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
304      *
305      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
306      */
307     function onERC721Received(
308         address operator,
309         address from,
310         uint256 tokenId,
311         bytes calldata data
312     ) external returns (bytes4);
313 }
314 
315 // File: contracts/IERC165.sol
316 
317 
318 
319 pragma solidity ^0.8.0;
320 
321 /**
322  * @dev Interface of the ERC165 standard, as defined in the
323  * https://eips.ethereum.org/EIPS/eip-165[EIP].
324  *
325  * Implementers can declare support of contract interfaces, which can then be
326  * queried by others ({ERC165Checker}).
327  *
328  * For an implementation, see {ERC165}.
329  */
330 interface IERC165 {
331     /**
332      * @dev Returns true if this contract implements the interface defined by
333      * `interfaceId`. See the corresponding
334      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
335      * to learn more about how these ids are created.
336      *
337      * This function call must use less than 30 000 gas.
338      */
339     function supportsInterface(bytes4 interfaceId) external view returns (bool);
340 }
341 
342 // File: contracts/ERC165.sol
343 
344 
345 
346 pragma solidity ^0.8.0;
347 
348 
349 /**
350  * @dev Implementation of the {IERC165} interface.
351  *
352  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
353  * for the additional interface id that will be supported. For example:
354  *
355  * ```solidity
356  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
357  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
358  * }
359  * ```
360  *
361  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
362  */
363 abstract contract ERC165 is IERC165 {
364     /**
365      * @dev See {IERC165-supportsInterface}.
366      */
367     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
368         return interfaceId == type(IERC165).interfaceId;
369     }
370 }
371 
372 // File: contracts/IERC721.sol
373 
374 
375 
376 pragma solidity ^0.8.0;
377 
378 
379 /**
380  * @dev Required interface of an ERC721 compliant contract.
381  */
382 interface IERC721 is IERC165 {
383     /**
384      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
385      */
386     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
387 
388     /**
389      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
390      */
391     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
392 
393     /**
394      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
395      */
396     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
397 
398     /**
399      * @dev Returns the number of tokens in ``owner``'s account.
400      */
401     function balanceOf(address owner) external view returns (uint256 balance);
402 
403     /**
404      * @dev Returns the owner of the `tokenId` token.
405      *
406      * Requirements:
407      *
408      * - `tokenId` must exist.
409      */
410     function ownerOf(uint256 tokenId) external view returns (address owner);
411 
412     /**
413      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
414      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
415      *
416      * Requirements:
417      *
418      * - `from` cannot be the zero address.
419      * - `to` cannot be the zero address.
420      * - `tokenId` token must exist and be owned by `from`.
421      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
422      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
423      *
424      * Emits a {Transfer} event.
425      */
426     function safeTransferFrom(
427         address from,
428         address to,
429         uint256 tokenId
430     ) external;
431 
432     /**
433      * @dev Transfers `tokenId` token from `from` to `to`.
434      *
435      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
436      *
437      * Requirements:
438      *
439      * - `from` cannot be the zero address.
440      * - `to` cannot be the zero address.
441      * - `tokenId` token must be owned by `from`.
442      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
443      *
444      * Emits a {Transfer} event.
445      */
446     function transferFrom(
447         address from,
448         address to,
449         uint256 tokenId
450     ) external;
451 
452     /**
453      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
454      * The approval is cleared when the token is transferred.
455      *
456      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
457      *
458      * Requirements:
459      *
460      * - The caller must own the token or be an approved operator.
461      * - `tokenId` must exist.
462      *
463      * Emits an {Approval} event.
464      */
465     function approve(address to, uint256 tokenId) external;
466 
467     /**
468      * @dev Returns the account approved for `tokenId` token.
469      *
470      * Requirements:
471      *
472      * - `tokenId` must exist.
473      */
474     function getApproved(uint256 tokenId) external view returns (address operator);
475 
476     /**
477      * @dev Approve or remove `operator` as an operator for the caller.
478      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
479      *
480      * Requirements:
481      *
482      * - The `operator` cannot be the caller.
483      *
484      * Emits an {ApprovalForAll} event.
485      */
486     function setApprovalForAll(address operator, bool _approved) external;
487 
488     /**
489      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
490      *
491      * See {setApprovalForAll}
492      */
493     function isApprovedForAll(address owner, address operator) external view returns (bool);
494 
495     /**
496      * @dev Safely transfers `tokenId` token from `from` to `to`.
497      *
498      * Requirements:
499      *
500      * - `from` cannot be the zero address.
501      * - `to` cannot be the zero address.
502      * - `tokenId` token must exist and be owned by `from`.
503      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
504      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
505      *
506      * Emits a {Transfer} event.
507      */
508     function safeTransferFrom(
509         address from,
510         address to,
511         uint256 tokenId,
512         bytes calldata data
513     ) external;
514 }
515 
516 // File: contracts/IERC721Enumerable.sol
517 
518 
519 
520 pragma solidity ^0.8.0;
521 
522 
523 /**
524  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
525  * @dev See https://eips.ethereum.org/EIPS/eip-721
526  */
527 interface IERC721Enumerable is IERC721 {
528     /**
529      * @dev Returns the total amount of tokens stored by the contract.
530      */
531     function totalSupply() external view returns (uint256);
532 
533     /**
534      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
535      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
536      */
537     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
538 
539     /**
540      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
541      * Use along with {totalSupply} to enumerate all tokens.
542      */
543     function tokenByIndex(uint256 index) external view returns (uint256);
544 }
545 
546 // File: contracts/IERC721Metadata.sol
547 
548 
549 
550 pragma solidity ^0.8.0;
551 
552 
553 /**
554  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
555  * @dev See https://eips.ethereum.org/EIPS/eip-721
556  */
557 interface IERC721Metadata is IERC721 {
558     /**
559      * @dev Returns the token collection name.
560      */
561     function name() external view returns (string memory);
562 
563     /**
564      * @dev Returns the token collection symbol.
565      */
566     function symbol() external view returns (string memory);
567 
568     /**
569      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
570      */
571     function tokenURI(uint256 tokenId) external view returns (string memory);
572 }
573 
574 // File: contracts/ReentrancyGuard.sol
575 
576 
577 
578 pragma solidity ^0.8.0;
579 
580 /**
581  * @dev Contract module that helps prevent reentrant calls to a function.
582  *
583  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
584  * available, which can be applied to functions to make sure there are no nested
585  * (reentrant) calls to them.
586  *
587  * Note that because there is a single `nonReentrant` guard, functions marked as
588  * `nonReentrant` may not call one another. This can be worked around by making
589  * those functions `private`, and then adding `external` `nonReentrant` entry
590  * points to them.
591  *
592  * TIP: If you would like to learn more about reentrancy and alternative ways
593  * to protect against it, check out our blog post
594  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
595  */
596 abstract contract ReentrancyGuard {
597     // Booleans are more expensive than uint256 or any type that takes up a full
598     // word because each write operation emits an extra SLOAD to first read the
599     // slot's contents, replace the bits taken up by the boolean, and then write
600     // back. This is the compiler's defense against contract upgrades and
601     // pointer aliasing, and it cannot be disabled.
602 
603     // The values being non-zero value makes deployment a bit more expensive,
604     // but in exchange the refund on every call to nonReentrant will be lower in
605     // amount. Since refunds are capped to a percentage of the total
606     // transaction's gas, it is best to keep them low in cases like this one, to
607     // increase the likelihood of the full refund coming into effect.
608     uint256 private constant _NOT_ENTERED = 1;
609     uint256 private constant _ENTERED = 2;
610 
611     uint256 private _status;
612 
613     constructor() {
614         _status = _NOT_ENTERED;
615     }
616 
617     /**
618      * @dev Prevents a contract from calling itself, directly or indirectly.
619      * Calling a `nonReentrant` function from another `nonReentrant`
620      * function is not supported. It is possible to prevent this from happening
621      * by making the `nonReentrant` function external, and make it call a
622      * `private` function that does the actual work.
623      */
624     modifier nonReentrant() {
625         // On the first call to nonReentrant, _notEntered will be true
626         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
627 
628         // Any calls to nonReentrant after this point will fail
629         _status = _ENTERED;
630 
631         _;
632 
633         // By storing the original value once again, a refund is triggered (see
634         // https://eips.ethereum.org/EIPS/eip-2200)
635         _status = _NOT_ENTERED;
636     }
637 }
638 
639 // File: contracts/Context.sol
640 
641 
642 
643 pragma solidity ^0.8.0;
644 
645 /*
646  * @dev Provides information about the current execution context, including the
647  * sender of the transaction and its data. While these are generally available
648  * via msg.sender and msg.data, they should not be accessed in such a direct
649  * manner, since when dealing with meta-transactions the account sending and
650  * paying for execution may not be the actual sender (as far as an application
651  * is concerned).
652  *
653  * This contract is only required for intermediate, library-like contracts.
654  */
655 abstract contract Context {
656     function _msgSender() internal view virtual returns (address) {
657         return msg.sender;
658     }
659 
660     function _msgData() internal view virtual returns (bytes calldata) {
661         return msg.data;
662     }
663 }
664 
665 // File: contracts/ERC721A.sol
666 
667 
668 
669 pragma solidity ^0.8.0;
670 
671 
672 
673 
674 
675 
676 
677 
678 
679 /**
680  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
681  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
682  *
683  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
684  *
685  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
686  *
687  * Does not support burning tokens to address(0).
688  */
689 contract ERC721A is
690   Context,
691   ERC165,
692   IERC721,
693   IERC721Metadata,
694   IERC721Enumerable
695 {
696   using Address for address;
697   using Strings for uint256;
698 
699   struct TokenOwnership {
700     address addr;
701     uint64 startTimestamp;
702   }
703 
704   struct AddressData {
705     uint128 balance;
706     uint128 numberMinted;
707   }
708 
709   uint256 private currentIndex = 0;
710 
711   uint256 internal immutable collectionSize;
712   uint256 internal immutable maxBatchSize;
713 
714   // Token name
715   string private _name;
716 
717   // Token symbol
718   string private _symbol;
719 
720   // Mapping from token ID to ownership details
721   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
722   mapping(uint256 => TokenOwnership) private _ownerships;
723 
724   // Mapping owner address to address data
725   mapping(address => AddressData) private _addressData;
726 
727   // Mapping from token ID to approved address
728   mapping(uint256 => address) private _tokenApprovals;
729 
730   // Mapping from owner to operator approvals
731   mapping(address => mapping(address => bool)) private _operatorApprovals;
732 
733   /**
734    * @dev
735    * `maxBatchSize` refers to how much a minter can mint at a time.
736    * `collectionSize_` refers to how many tokens are in the collection.
737    */
738   constructor(
739     string memory name_,
740     string memory symbol_,
741     uint256 maxBatchSize_,
742     uint256 collectionSize_
743   ) {
744     require(
745       collectionSize_ > 0,
746       "ERC721A: collection must have a nonzero supply"
747     );
748     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
749     _name = name_;
750     _symbol = symbol_;
751     maxBatchSize = maxBatchSize_;
752     collectionSize = collectionSize_;
753   }
754 
755   /**
756    * @dev See {IERC721Enumerable-totalSupply}.
757    */
758   function totalSupply() public view override returns (uint256) {
759     return currentIndex;
760   }
761 
762   /**
763    * @dev See {IERC721Enumerable-tokenByIndex}.
764    */
765   function tokenByIndex(uint256 index) public view override returns (uint256) {
766     require(index < totalSupply(), "ERC721A: global index out of bounds");
767     return index;
768   }
769 
770   /**
771    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
772    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
773    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
774    */
775   function tokenOfOwnerByIndex(address owner, uint256 index)
776     public
777     view
778     override
779     returns (uint256)
780   {
781     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
782     uint256 numMintedSoFar = totalSupply();
783     uint256 tokenIdsIdx = 0;
784     address currOwnershipAddr = address(0);
785     for (uint256 i = 0; i < numMintedSoFar; i++) {
786       TokenOwnership memory ownership = _ownerships[i];
787       if (ownership.addr != address(0)) {
788         currOwnershipAddr = ownership.addr;
789       }
790       if (currOwnershipAddr == owner) {
791         if (tokenIdsIdx == index) {
792           return i;
793         }
794         tokenIdsIdx++;
795       }
796     }
797     revert("ERC721A: unable to get token of owner by index");
798   }
799 
800   /**
801    * @dev See {IERC165-supportsInterface}.
802    */
803   function supportsInterface(bytes4 interfaceId)
804     public
805     view
806     virtual
807     override(ERC165, IERC165)
808     returns (bool)
809   {
810     return
811       interfaceId == type(IERC721).interfaceId ||
812       interfaceId == type(IERC721Metadata).interfaceId ||
813       interfaceId == type(IERC721Enumerable).interfaceId ||
814       super.supportsInterface(interfaceId);
815   }
816 
817   /**
818    * @dev See {IERC721-balanceOf}.
819    */
820   function balanceOf(address owner) public view override returns (uint256) {
821     require(owner != address(0), "ERC721A: balance query for the zero address");
822     return uint256(_addressData[owner].balance);
823   }
824 
825   function _numberMinted(address owner) internal view returns (uint256) {
826     require(
827       owner != address(0),
828       "ERC721A: number minted query for the zero address"
829     );
830     return uint256(_addressData[owner].numberMinted);
831   }
832 
833   function ownershipOf(uint256 tokenId)
834     internal
835     view
836     returns (TokenOwnership memory)
837   {
838     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
839 
840     uint256 lowestTokenToCheck;
841     if (tokenId >= maxBatchSize) {
842       lowestTokenToCheck = tokenId - maxBatchSize + 1;
843     }
844 
845     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
846       TokenOwnership memory ownership = _ownerships[curr];
847       if (ownership.addr != address(0)) {
848         return ownership;
849       }
850     }
851 
852     revert("ERC721A: unable to determine the owner of token");
853   }
854 
855   /**
856    * @dev See {IERC721-ownerOf}.
857    */
858   function ownerOf(uint256 tokenId) public view override returns (address) {
859     return ownershipOf(tokenId).addr;
860   }
861 
862   /**
863    * @dev See {IERC721Metadata-name}.
864    */
865   function name() public view virtual override returns (string memory) {
866     return _name;
867   }
868 
869   /**
870    * @dev See {IERC721Metadata-symbol}.
871    */
872   function symbol() public view virtual override returns (string memory) {
873     return _symbol;
874   }
875 
876   /**
877    * @dev See {IERC721Metadata-tokenURI}.
878    */
879   function tokenURI(uint256 tokenId)
880     public
881     view
882     virtual
883     override
884     returns (string memory)
885   {
886     require(
887       _exists(tokenId),
888       "ERC721Metadata: URI query for nonexistent token"
889     );
890 
891     string memory baseURI = _baseURI();
892     return
893       bytes(baseURI).length > 0
894         ? string(abi.encodePacked(baseURI, tokenId.toString()))
895         : "";
896   }
897 
898   /**
899    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
900    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
901    * by default, can be overriden in child contracts.
902    */
903   function _baseURI() internal view virtual returns (string memory) {
904     return "";
905   }
906 
907   /**
908    * @dev See {IERC721-approve}.
909    */
910   function approve(address to, uint256 tokenId) public override {
911     address owner = ERC721A.ownerOf(tokenId);
912     require(to != owner, "ERC721A: approval to current owner");
913 
914     require(
915       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
916       "ERC721A: approve caller is not owner nor approved for all"
917     );
918 
919     _approve(to, tokenId, owner);
920   }
921 
922   /**
923    * @dev See {IERC721-getApproved}.
924    */
925   function getApproved(uint256 tokenId) public view override returns (address) {
926     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
927 
928     return _tokenApprovals[tokenId];
929   }
930 
931   /**
932    * @dev See {IERC721-setApprovalForAll}.
933    */
934   function setApprovalForAll(address operator, bool approved) public override {
935     require(operator != _msgSender(), "ERC721A: approve to caller");
936 
937     _operatorApprovals[_msgSender()][operator] = approved;
938     emit ApprovalForAll(_msgSender(), operator, approved);
939   }
940 
941   /**
942    * @dev See {IERC721-isApprovedForAll}.
943    */
944   function isApprovedForAll(address owner, address operator)
945     public
946     view
947     virtual
948     override
949     returns (bool)
950   {
951     return _operatorApprovals[owner][operator];
952   }
953 
954   /**
955    * @dev See {IERC721-transferFrom}.
956    */
957   function transferFrom(
958     address from,
959     address to,
960     uint256 tokenId
961   ) public override {
962     _transfer(from, to, tokenId);
963   }
964 
965   /**
966    * @dev See {IERC721-safeTransferFrom}.
967    */
968   function safeTransferFrom(
969     address from,
970     address to,
971     uint256 tokenId
972   ) public override {
973     safeTransferFrom(from, to, tokenId, "");
974   }
975 
976   /**
977    * @dev See {IERC721-safeTransferFrom}.
978    */
979   function safeTransferFrom(
980     address from,
981     address to,
982     uint256 tokenId,
983     bytes memory _data
984   ) public override {
985     _transfer(from, to, tokenId);
986     require(
987       _checkOnERC721Received(from, to, tokenId, _data),
988       "ERC721A: transfer to non ERC721Receiver implementer"
989     );
990   }
991 
992   /**
993    * @dev Returns whether `tokenId` exists.
994    *
995    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
996    *
997    * Tokens start existing when they are minted (`_mint`),
998    */
999   function _exists(uint256 tokenId) internal view returns (bool) {
1000     return tokenId < currentIndex;
1001   }
1002 
1003   function _safeMint(address to, uint256 quantity) internal {
1004     _safeMint(to, quantity, "");
1005   }
1006 
1007   /**
1008    * @dev Mints `quantity` tokens and transfers them to `to`.
1009    *
1010    * Requirements:
1011    *
1012    * - there must be `quantity` tokens remaining unminted in the total collection.
1013    * - `to` cannot be the zero address.
1014    * - `quantity` cannot be larger than the max batch size.
1015    *
1016    * Emits a {Transfer} event.
1017    */
1018   function _safeMint(
1019     address to,
1020     uint256 quantity,
1021     bytes memory _data
1022   ) internal {
1023     uint256 startTokenId = currentIndex;
1024     require(to != address(0), "ERC721A: mint to the zero address");
1025     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1026     require(!_exists(startTokenId), "ERC721A: token already minted");
1027     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1028 
1029     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1030 
1031     AddressData memory addressData = _addressData[to];
1032     _addressData[to] = AddressData(
1033       addressData.balance + uint128(quantity),
1034       addressData.numberMinted + uint128(quantity)
1035     );
1036     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1037 
1038     uint256 updatedIndex = startTokenId;
1039 
1040     for (uint256 i = 0; i < quantity; i++) {
1041       emit Transfer(address(0), to, updatedIndex);
1042       require(
1043         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1044         "ERC721A: transfer to non ERC721Receiver implementer"
1045       );
1046       updatedIndex++;
1047     }
1048 
1049     currentIndex = updatedIndex;
1050     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1051   }
1052 
1053   /**
1054    * @dev Transfers `tokenId` from `from` to `to`.
1055    *
1056    * Requirements:
1057    *
1058    * - `to` cannot be the zero address.
1059    * - `tokenId` token must be owned by `from`.
1060    *
1061    * Emits a {Transfer} event.
1062    */
1063   function _transfer(
1064     address from,
1065     address to,
1066     uint256 tokenId
1067   ) private {
1068     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1069 
1070     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1071       getApproved(tokenId) == _msgSender() ||
1072       isApprovedForAll(prevOwnership.addr, _msgSender()));
1073 
1074     require(
1075       isApprovedOrOwner,
1076       "ERC721A: transfer caller is not owner nor approved"
1077     );
1078 
1079     require(
1080       prevOwnership.addr == from,
1081       "ERC721A: transfer from incorrect owner"
1082     );
1083     require(to != address(0), "ERC721A: transfer to the zero address");
1084 
1085     _beforeTokenTransfers(from, to, tokenId, 1);
1086 
1087     // Clear approvals from the previous owner
1088     _approve(address(0), tokenId, prevOwnership.addr);
1089 
1090     _addressData[from].balance -= 1;
1091     _addressData[to].balance += 1;
1092     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1093 
1094     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1095     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1096     uint256 nextTokenId = tokenId + 1;
1097     if (_ownerships[nextTokenId].addr == address(0)) {
1098       if (_exists(nextTokenId)) {
1099         _ownerships[nextTokenId] = TokenOwnership(
1100           prevOwnership.addr,
1101           prevOwnership.startTimestamp
1102         );
1103       }
1104     }
1105 
1106     emit Transfer(from, to, tokenId);
1107     _afterTokenTransfers(from, to, tokenId, 1);
1108   }
1109 
1110   /**
1111    * @dev Approve `to` to operate on `tokenId`
1112    *
1113    * Emits a {Approval} event.
1114    */
1115   function _approve(
1116     address to,
1117     uint256 tokenId,
1118     address owner
1119   ) private {
1120     _tokenApprovals[tokenId] = to;
1121     emit Approval(owner, to, tokenId);
1122   }
1123 
1124   uint256 public nextOwnerToExplicitlySet = 0;
1125 
1126   /**
1127    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1128    */
1129   function _setOwnersExplicit(uint256 quantity) internal {
1130     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1131     require(quantity > 0, "quantity must be nonzero");
1132     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1133     if (endIndex > collectionSize - 1) {
1134       endIndex = collectionSize - 1;
1135     }
1136     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1137     require(_exists(endIndex), "not enough minted yet for this cleanup");
1138     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1139       if (_ownerships[i].addr == address(0)) {
1140         TokenOwnership memory ownership = ownershipOf(i);
1141         _ownerships[i] = TokenOwnership(
1142           ownership.addr,
1143           ownership.startTimestamp
1144         );
1145       }
1146     }
1147     nextOwnerToExplicitlySet = endIndex + 1;
1148   }
1149 
1150   /**
1151    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1152    * The call is not executed if the target address is not a contract.
1153    *
1154    * @param from address representing the previous owner of the given token ID
1155    * @param to target address that will receive the tokens
1156    * @param tokenId uint256 ID of the token to be transferred
1157    * @param _data bytes optional data to send along with the call
1158    * @return bool whether the call correctly returned the expected magic value
1159    */
1160   function _checkOnERC721Received(
1161     address from,
1162     address to,
1163     uint256 tokenId,
1164     bytes memory _data
1165   ) private returns (bool) {
1166     if (to.isContract()) {
1167       try
1168         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1169       returns (bytes4 retval) {
1170         return retval == IERC721Receiver(to).onERC721Received.selector;
1171       } catch (bytes memory reason) {
1172         if (reason.length == 0) {
1173           revert("ERC721A: transfer to non ERC721Receiver implementer");
1174         } else {
1175           assembly {
1176             revert(add(32, reason), mload(reason))
1177           }
1178         }
1179       }
1180     } else {
1181       return true;
1182     }
1183   }
1184 
1185   /**
1186    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1187    *
1188    * startTokenId - the first token id to be transferred
1189    * quantity - the amount to be transferred
1190    *
1191    * Calling conditions:
1192    *
1193    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1194    * transferred to `to`.
1195    * - When `from` is zero, `tokenId` will be minted for `to`.
1196    */
1197   function _beforeTokenTransfers(
1198     address from,
1199     address to,
1200     uint256 startTokenId,
1201     uint256 quantity
1202   ) internal virtual {}
1203 
1204   /**
1205    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1206    * minting.
1207    *
1208    * startTokenId - the first token id to be transferred
1209    * quantity - the amount to be transferred
1210    *
1211    * Calling conditions:
1212    *
1213    * - when `from` and `to` are both non-zero.
1214    * - `from` and `to` are never both zero.
1215    */
1216   function _afterTokenTransfers(
1217     address from,
1218     address to,
1219     uint256 startTokenId,
1220     uint256 quantity
1221   ) internal virtual {}
1222 }
1223 
1224 // File: contracts/Ownable.sol
1225 
1226 
1227 
1228 pragma solidity ^0.8.0;
1229 
1230 
1231 /**
1232  * @dev Contract module which provides a basic access control mechanism, where
1233  * there is an account (an owner) that can be granted exclusive access to
1234  * specific functions.
1235  *
1236  * By default, the owner account will be the one that deploys the contract. This
1237  * can later be changed with {transferOwnership}.
1238  *
1239  * This module is used through inheritance. It will make available the modifier
1240  * `onlyOwner`, which can be applied to your functions to restrict their use to
1241  * the owner.
1242  */
1243 abstract contract Ownable is Context {
1244     address private _owner;
1245 
1246     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1247 
1248     /**
1249      * @dev Initializes the contract setting the deployer as the initial owner.
1250      */
1251     constructor() {
1252         _setOwner(_msgSender());
1253     }
1254 
1255     /**
1256      * @dev Returns the address of the current owner.
1257      */
1258     function owner() public view virtual returns (address) {
1259         return _owner;
1260     }
1261 
1262     /**
1263      * @dev Throws if called by any account other than the owner.
1264      */
1265     modifier onlyOwner() {
1266         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1267         _;
1268     }
1269 
1270     /**
1271      * @dev Leaves the contract without owner. It will not be possible to call
1272      * `onlyOwner` functions anymore. Can only be called by the current owner.
1273      *
1274      * NOTE: Renouncing ownership will leave the contract without an owner,
1275      * thereby removing any functionality that is only available to the owner.
1276      */
1277     function renounceOwnership() public virtual onlyOwner {
1278         _setOwner(address(0));
1279     }
1280 
1281     /**
1282      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1283      * Can only be called by the current owner.
1284      */
1285     function transferOwnership(address newOwner) public virtual onlyOwner {
1286         require(newOwner != address(0), "Ownable: new owner is the zero address");
1287         _setOwner(newOwner);
1288     }
1289 
1290     function _setOwner(address newOwner) private {
1291         address oldOwner = _owner;
1292         _owner = newOwner;
1293         emit OwnershipTransferred(oldOwner, newOwner);
1294     }
1295 }
1296 
1297 // File: contracts/MemeGenesis.sol
1298 
1299 
1300 
1301 pragma solidity ^0.8.0;
1302 
1303 
1304 
1305 
1306 
1307 contract MemeGenesis is Ownable, ERC721A, ReentrancyGuard {
1308   uint256 public immutable maxPerAddressDuringMint;
1309   uint256 public immutable amountForDevs;
1310   uint256 public immutable amountForFree;
1311   uint256 public mintPrice = 0; //0.05 ETH
1312   uint256 public listPrice = 0; //0.05 ETH
1313 
1314   mapping(address => uint256) public allowlist;
1315 
1316   constructor(
1317     uint256 maxBatchSize_,
1318     uint256 collectionSize_,
1319     uint256 amountForDevs_,
1320     uint256 amountForFree_
1321   ) ERC721A("Meme Genesis", "MEME", maxBatchSize_, collectionSize_) {
1322     maxPerAddressDuringMint = maxBatchSize_;
1323     amountForDevs = amountForDevs_;
1324     amountForFree = amountForFree_;
1325   }
1326 
1327   modifier callerIsUser() {
1328     require(tx.origin == msg.sender, "The caller is another contract");
1329     _;
1330   }
1331 
1332   function mint(uint256 quantity) external callerIsUser {
1333 
1334     require(totalSupply() + quantity <= amountForFree, "reached max supply");
1335     require(
1336       numberMinted(msg.sender) + quantity <= maxPerAddressDuringMint,
1337       "can not mint this many"
1338     );
1339     _safeMint(msg.sender, quantity);
1340   }
1341 
1342   function wlMint() external payable callerIsUser {
1343     uint256 price = listPrice;
1344     require(price != 0, "allowlist sale has not begun yet");
1345     require(allowlist[msg.sender] > 0, "not eligible for allowlist mint");
1346     require(totalSupply() + 1 <= collectionSize, "reached max supply");
1347     allowlist[msg.sender]--;
1348     _safeMint(msg.sender, 1);
1349     refundIfOver(price);
1350   }
1351 
1352   function paidMint(uint256 quantity)
1353     external
1354     payable
1355     callerIsUser
1356   {
1357     uint256 publicPrice = mintPrice;
1358 
1359     require(
1360       isPublicSaleOn(publicPrice),
1361       "public sale has not begun yet"
1362     );
1363     require(totalSupply() + quantity <= collectionSize, "reached max supply");
1364     require(
1365       numberMinted(msg.sender) + quantity <= maxPerAddressDuringMint,
1366       "can not mint this many"
1367     );
1368     _safeMint(msg.sender, quantity);
1369     refundIfOver(publicPrice * quantity);
1370   }
1371 
1372   function refundIfOver(uint256 price) private {
1373     require(msg.value >= price, "Need to send more ETH.");
1374     if (msg.value > price) {
1375       payable(msg.sender).transfer(msg.value - price);
1376     }
1377   }
1378 
1379   function isPublicSaleOn(
1380     uint256 publicPriceWei
1381   ) public view returns (bool) {
1382     return
1383       publicPriceWei != 0 ;
1384   }
1385 
1386 
1387   function seedAllowlist(address[] memory addresses, uint256[] memory numSlots)
1388     external
1389     onlyOwner
1390   {
1391     require(
1392       addresses.length == numSlots.length,
1393       "addresses does not match numSlots length"
1394     );
1395     for (uint256 i = 0; i < addresses.length; i++) {
1396       allowlist[addresses[i]] = numSlots[i];
1397     }
1398   }
1399 
1400   // For marketing etc.
1401   function devMint(uint256 quantity) external onlyOwner {
1402     require(
1403       totalSupply() + quantity <= amountForDevs,
1404       "too many already minted before dev mint"
1405     );
1406     require(
1407       quantity % maxBatchSize == 0,
1408       "can only mint a multiple of the maxBatchSize"
1409     );
1410     uint256 numChunks = quantity / maxBatchSize;
1411     for (uint256 i = 0; i < numChunks; i++) {
1412       _safeMint(msg.sender, maxBatchSize);
1413     }
1414   }
1415 
1416   // // metadata URI
1417   string private _baseTokenURI;
1418 
1419   function _baseURI() internal view virtual override returns (string memory) {
1420     return _baseTokenURI;
1421   }
1422 
1423   function setBaseURI(string calldata baseURI) external onlyOwner {
1424     _baseTokenURI = baseURI;
1425   }
1426 
1427   function withdrawMoney() external onlyOwner nonReentrant {
1428     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1429     require(success, "Transfer failed.");
1430   }
1431 
1432   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1433     _setOwnersExplicit(quantity);
1434   }
1435 
1436   function numberMinted(address owner) public view returns (uint256) {
1437     return _numberMinted(owner);
1438   }
1439 
1440   function getOwnershipData(uint256 tokenId)
1441     external
1442     view
1443     returns (TokenOwnership memory)
1444   {
1445     return ownershipOf(tokenId);
1446   }
1447 
1448   function setListPrice(uint256 newPrice) public onlyOwner {
1449       listPrice = newPrice;
1450   }
1451 
1452   function setMintPrice(uint256 newPrice) public onlyOwner {
1453       mintPrice = newPrice;
1454   }
1455 }