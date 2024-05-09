1 // SPDX-License-Identifier: MIT
2 
3 // File: contracts/Strings.sol
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev String operations.
8  */
9 
10 
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
71 // File: contracts/Address.sol
72 
73 
74 
75 pragma solidity ^0.8.0;
76 
77 /**
78  * @dev Collection of functions related to the address type
79  */
80 library Address {
81     /**
82      * @dev Returns true if `account` is a contract.
83      *
84      * [IMPORTANT]
85      * ====
86      * It is unsafe to assume that an address for which this function returns
87      * false is an externally-owned account (EOA) and not a contract.
88      *
89      * Among others, `isContract` will return false for the following
90      * types of addresses:
91      *
92      *  - an externally-owned account
93      *  - a contract in construction
94      *  - an address where a contract will be created
95      *  - an address where a contract lived, but was destroyed
96      * ====
97      */
98     function isContract(address account) internal view returns (bool) {
99         // This method relies on extcodesize, which returns 0 for contracts in
100         // construction, since the code is only stored at the end of the
101         // constructor execution.
102 
103         uint256 size;
104         assembly {
105             size := extcodesize(account)
106         }
107         return size > 0;
108     }
109 
110     /**
111      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
112      * `recipient`, forwarding all available gas and reverting on errors.
113      *
114      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
115      * of certain opcodes, possibly making contracts go over the 2300 gas limit
116      * imposed by `transfer`, making them unable to receive funds via
117      * `transfer`. {sendValue} removes this limitation.
118      *
119      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
120      *
121      * IMPORTANT: because control is transferred to `recipient`, care must be
122      * taken to not create reentrancy vulnerabilities. Consider using
123      * {ReentrancyGuard} or the
124      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
125      */
126     function sendValue(address payable recipient, uint256 amount) internal {
127         require(address(this).balance >= amount, "Address: insufficient balance");
128 
129         (bool success, ) = recipient.call{value: amount}("");
130         require(success, "Address: unable to send value, recipient may have reverted");
131     }
132 
133     /**
134      * @dev Performs a Solidity function call using a low level `call`. A
135      * plain `call` is an unsafe replacement for a function call: use this
136      * function instead.
137      *
138      * If `target` reverts with a revert reason, it is bubbled up by this
139      * function (like regular Solidity function calls).
140      *
141      * Returns the raw returned data. To convert to the expected return value,
142      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
143      *
144      * Requirements:
145      *
146      * - `target` must be a contract.
147      * - calling `target` with `data` must not revert.
148      *
149      * _Available since v3.1._
150      */
151     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
152         return functionCall(target, data, "Address: low-level call failed");
153     }
154 
155     /**
156      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
157      * `errorMessage` as a fallback revert reason when `target` reverts.
158      *
159      * _Available since v3.1._
160      */
161     function functionCall(
162         address target,
163         bytes memory data,
164         string memory errorMessage
165     ) internal returns (bytes memory) {
166         return functionCallWithValue(target, data, 0, errorMessage);
167     }
168 
169     /**
170      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
171      * but also transferring `value` wei to `target`.
172      *
173      * Requirements:
174      *
175      * - the calling contract must have an ETH balance of at least `value`.
176      * - the called Solidity function must be `payable`.
177      *
178      * _Available since v3.1._
179      */
180     function functionCallWithValue(
181         address target,
182         bytes memory data,
183         uint256 value
184     ) internal returns (bytes memory) {
185         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
186     }
187 
188     /**
189      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
190      * with `errorMessage` as a fallback revert reason when `target` reverts.
191      *
192      * _Available since v3.1._
193      */
194     function functionCallWithValue(
195         address target,
196         bytes memory data,
197         uint256 value,
198         string memory errorMessage
199     ) internal returns (bytes memory) {
200         require(address(this).balance >= value, "Address: insufficient balance for call");
201         require(isContract(target), "Address: call to non-contract");
202 
203         (bool success, bytes memory returndata) = target.call{value: value}(data);
204         return _verifyCallResult(success, returndata, errorMessage);
205     }
206 
207     /**
208      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
209      * but performing a static call.
210      *
211      * _Available since v3.3._
212      */
213     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
214         return functionStaticCall(target, data, "Address: low-level static call failed");
215     }
216 
217     /**
218      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
219      * but performing a static call.
220      *
221      * _Available since v3.3._
222      */
223     function functionStaticCall(
224         address target,
225         bytes memory data,
226         string memory errorMessage
227     ) internal view returns (bytes memory) {
228         require(isContract(target), "Address: static call to non-contract");
229 
230         (bool success, bytes memory returndata) = target.staticcall(data);
231         return _verifyCallResult(success, returndata, errorMessage);
232     }
233 
234     /**
235      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
236      * but performing a delegate call.
237      *
238      * _Available since v3.4._
239      */
240     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
241         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
242     }
243 
244     /**
245      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
246      * but performing a delegate call.
247      *
248      * _Available since v3.4._
249      */
250     function functionDelegateCall(
251         address target,
252         bytes memory data,
253         string memory errorMessage
254     ) internal returns (bytes memory) {
255         require(isContract(target), "Address: delegate call to non-contract");
256 
257         (bool success, bytes memory returndata) = target.delegatecall(data);
258         return _verifyCallResult(success, returndata, errorMessage);
259     }
260 
261     function _verifyCallResult(
262         bool success,
263         bytes memory returndata,
264         string memory errorMessage
265     ) private pure returns (bytes memory) {
266         if (success) {
267             return returndata;
268         } else {
269             // Look for revert reason and bubble it up if present
270             if (returndata.length > 0) {
271                 // The easiest way to bubble the revert reason is using memory via assembly
272 
273                 assembly {
274                     let returndata_size := mload(returndata)
275                     revert(add(32, returndata), returndata_size)
276                 }
277             } else {
278                 revert(errorMessage);
279             }
280         }
281     }
282 }
283 
284 // File: contracts/IERC721Receiver.sol
285 
286 
287 
288 pragma solidity ^0.8.0;
289 
290 /**
291  * @title ERC721 token receiver interface
292  * @dev Interface for any contract that wants to support safeTransfers
293  * from ERC721 asset contracts.
294  */
295 interface IERC721Receiver {
296     /**
297      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
298      * by `operator` from `from`, this function is called.
299      *
300      * It must return its Solidity selector to confirm the token transfer.
301      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
302      *
303      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
304      */
305     function onERC721Received(
306         address operator,
307         address from,
308         uint256 tokenId,
309         bytes calldata data
310     ) external returns (bytes4);
311 }
312 
313 // File: contracts/IERC165.sol
314 
315 
316 
317 pragma solidity ^0.8.0;
318 
319 /**
320  * @dev Interface of the ERC165 standard, as defined in the
321  * https://eips.ethereum.org/EIPS/eip-165[EIP].
322  *
323  * Implementers can declare support of contract interfaces, which can then be
324  * queried by others ({ERC165Checker}).
325  *
326  * For an implementation, see {ERC165}.
327  */
328 interface IERC165 {
329     /**
330      * @dev Returns true if this contract implements the interface defined by
331      * `interfaceId`. See the corresponding
332      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
333      * to learn more about how these ids are created.
334      *
335      * This function call must use less than 30 000 gas.
336      */
337     function supportsInterface(bytes4 interfaceId) external view returns (bool);
338 }
339 
340 // File: contracts/ERC165.sol
341 
342 
343 
344 pragma solidity ^0.8.0;
345 
346 
347 /**
348  * @dev Implementation of the {IERC165} interface.
349  *
350  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
351  * for the additional interface id that will be supported. For example:
352  *
353  * ```solidity
354  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
355  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
356  * }
357  * ```
358  *
359  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
360  */
361 abstract contract ERC165 is IERC165 {
362     /**
363      * @dev See {IERC165-supportsInterface}.
364      */
365     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
366         return interfaceId == type(IERC165).interfaceId;
367     }
368 }
369 
370 // File: contracts/IERC721.sol
371 
372 
373 
374 pragma solidity ^0.8.0;
375 
376 
377 /**
378  * @dev Required interface of an ERC721 compliant contract.
379  */
380 interface IERC721 is IERC165 {
381     /**
382      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
383      */
384     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
385 
386     /**
387      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
388      */
389     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
390 
391     /**
392      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
393      */
394     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
395 
396     /**
397      * @dev Returns the number of tokens in ``owner``'s account.
398      */
399     function balanceOf(address owner) external view returns (uint256 balance);
400 
401     /**
402      * @dev Returns the owner of the `tokenId` token.
403      *
404      * Requirements:
405      *
406      * - `tokenId` must exist.
407      */
408     function ownerOf(uint256 tokenId) external view returns (address owner);
409 
410     /**
411      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
412      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
413      *
414      * Requirements:
415      *
416      * - `from` cannot be the zero address.
417      * - `to` cannot be the zero address.
418      * - `tokenId` token must exist and be owned by `from`.
419      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
420      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
421      *
422      * Emits a {Transfer} event.
423      */
424     function safeTransferFrom(
425         address from,
426         address to,
427         uint256 tokenId
428     ) external;
429 
430     /**
431      * @dev Transfers `tokenId` token from `from` to `to`.
432      *
433      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
434      *
435      * Requirements:
436      *
437      * - `from` cannot be the zero address.
438      * - `to` cannot be the zero address.
439      * - `tokenId` token must be owned by `from`.
440      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
441      *
442      * Emits a {Transfer} event.
443      */
444     function transferFrom(
445         address from,
446         address to,
447         uint256 tokenId
448     ) external;
449 
450     /**
451      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
452      * The approval is cleared when the token is transferred.
453      *
454      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
455      *
456      * Requirements:
457      *
458      * - The caller must own the token or be an approved operator.
459      * - `tokenId` must exist.
460      *
461      * Emits an {Approval} event.
462      */
463     function approve(address to, uint256 tokenId) external;
464 
465     /**
466      * @dev Returns the account approved for `tokenId` token.
467      *
468      * Requirements:
469      *
470      * - `tokenId` must exist.
471      */
472     function getApproved(uint256 tokenId) external view returns (address operator);
473 
474     /**
475      * @dev Approve or remove `operator` as an operator for the caller.
476      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
477      *
478      * Requirements:
479      *
480      * - The `operator` cannot be the caller.
481      *
482      * Emits an {ApprovalForAll} event.
483      */
484     function setApprovalForAll(address operator, bool _approved) external;
485 
486     /**
487      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
488      *
489      * See {setApprovalForAll}
490      */
491     function isApprovedForAll(address owner, address operator) external view returns (bool);
492 
493     /**
494      * @dev Safely transfers `tokenId` token from `from` to `to`.
495      *
496      * Requirements:
497      *
498      * - `from` cannot be the zero address.
499      * - `to` cannot be the zero address.
500      * - `tokenId` token must exist and be owned by `from`.
501      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
502      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
503      *
504      * Emits a {Transfer} event.
505      */
506     function safeTransferFrom(
507         address from,
508         address to,
509         uint256 tokenId,
510         bytes calldata data
511     ) external;
512 }
513 
514 // File: contracts/IERC721Enumerable.sol
515 
516 
517 
518 pragma solidity ^0.8.0;
519 
520 
521 /**
522  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
523  * @dev See https://eips.ethereum.org/EIPS/eip-721
524  */
525 interface IERC721Enumerable is IERC721 {
526     /**
527      * @dev Returns the total amount of tokens stored by the contract.
528      */
529     function totalSupply() external view returns (uint256);
530 
531     /**
532      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
533      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
534      */
535     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
536 
537     /**
538      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
539      * Use along with {totalSupply} to enumerate all tokens.
540      */
541     function tokenByIndex(uint256 index) external view returns (uint256);
542 }
543 
544 // File: contracts/IERC721Metadata.sol
545 
546 
547 
548 pragma solidity ^0.8.0;
549 
550 
551 /**
552  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
553  * @dev See https://eips.ethereum.org/EIPS/eip-721
554  */
555 interface IERC721Metadata is IERC721 {
556     /**
557      * @dev Returns the token collection name.
558      */
559     function name() external view returns (string memory);
560 
561     /**
562      * @dev Returns the token collection symbol.
563      */
564     function symbol() external view returns (string memory);
565 
566     /**
567      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
568      */
569     function tokenURI(uint256 tokenId) external view returns (string memory);
570 }
571 
572 // File: contracts/ReentrancyGuard.sol
573 
574 
575 
576 pragma solidity ^0.8.0;
577 
578 /**
579  * @dev Contract module that helps prevent reentrant calls to a function.
580  *
581  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
582  * available, which can be applied to functions to make sure there are no nested
583  * (reentrant) calls to them.
584  *
585  * Note that because there is a single `nonReentrant` guard, functions marked as
586  * `nonReentrant` may not call one another. This can be worked around by making
587  * those functions `private`, and then adding `external` `nonReentrant` entry
588  * points to them.
589  *
590  * TIP: If you would like to learn more about reentrancy and alternative ways
591  * to protect against it, check out our blog post
592  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
593  */
594 abstract contract ReentrancyGuard {
595     // Booleans are more expensive than uint256 or any type that takes up a full
596     // word because each write operation emits an extra SLOAD to first read the
597     // slot's contents, replace the bits taken up by the boolean, and then write
598     // back. This is the compiler's defense against contract upgrades and
599     // pointer aliasing, and it cannot be disabled.
600 
601     // The values being non-zero value makes deployment a bit more expensive,
602     // but in exchange the refund on every call to nonReentrant will be lower in
603     // amount. Since refunds are capped to a percentage of the total
604     // transaction's gas, it is best to keep them low in cases like this one, to
605     // increase the likelihood of the full refund coming into effect.
606     uint256 private constant _NOT_ENTERED = 1;
607     uint256 private constant _ENTERED = 2;
608 
609     uint256 private _status;
610 
611     constructor() {
612         _status = _NOT_ENTERED;
613     }
614 
615     /**
616      * @dev Prevents a contract from calling itself, directly or indirectly.
617      * Calling a `nonReentrant` function from another `nonReentrant`
618      * function is not supported. It is possible to prevent this from happening
619      * by making the `nonReentrant` function external, and make it call a
620      * `private` function that does the actual work.
621      */
622     modifier nonReentrant() {
623         // On the first call to nonReentrant, _notEntered will be true
624         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
625 
626         // Any calls to nonReentrant after this point will fail
627         _status = _ENTERED;
628 
629         _;
630 
631         // By storing the original value once again, a refund is triggered (see
632         // https://eips.ethereum.org/EIPS/eip-2200)
633         _status = _NOT_ENTERED;
634     }
635 }
636 
637 // File: contracts/Context.sol
638 
639 
640 
641 pragma solidity ^0.8.0;
642 
643 /*
644  * @dev Provides information about the current execution context, including the
645  * sender of the transaction and its data. While these are generally available
646  * via msg.sender and msg.data, they should not be accessed in such a direct
647  * manner, since when dealing with meta-transactions the account sending and
648  * paying for execution may not be the actual sender (as far as an application
649  * is concerned).
650  *
651  * This contract is only required for intermediate, library-like contracts.
652  */
653 abstract contract Context {
654     function _msgSender() internal view virtual returns (address) {
655         return msg.sender;
656     }
657 
658     function _msgData() internal view virtual returns (bytes calldata) {
659         return msg.data;
660     }
661 }
662 
663 // File: contracts/ERC721A.sol
664 
665 
666 
667 pragma solidity ^0.8.0;
668 
669 
670 
671 
672 
673 
674 
675 
676 
677 /**
678  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
679  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
680  *
681  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
682  *
683  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
684  *
685  * Does not support burning tokens to address(0).
686  */
687 contract ERC721A is
688   Context,
689   ERC165,
690   IERC721,
691   IERC721Metadata,
692   IERC721Enumerable
693 {
694   using Address for address;
695   using Strings for uint256;
696 
697   struct TokenOwnership {
698     address addr;
699     uint64 startTimestamp;
700   }
701 
702   struct AddressData {
703     uint128 balance;
704     uint128 numberMinted;
705   }
706 
707   uint256 private currentIndex = 0;
708 
709   uint256 internal immutable collectionSize;
710   uint256 internal immutable maxBatchSize;
711 
712   // Token name
713   string private _name;
714 
715   // Token symbol
716   string private _symbol;
717 
718   // Mapping from token ID to ownership details
719   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
720   mapping(uint256 => TokenOwnership) private _ownerships;
721 
722   // Mapping owner address to address data
723   mapping(address => AddressData) private _addressData;
724 
725   // Mapping from token ID to approved address
726   mapping(uint256 => address) private _tokenApprovals;
727 
728   // Mapping from owner to operator approvals
729   mapping(address => mapping(address => bool)) private _operatorApprovals;
730 
731   /**
732    * @dev
733    * `maxBatchSize` refers to how much a minter can mint at a time.
734    * `collectionSize_` refers to how many tokens are in the collection.
735    */
736   constructor(
737     string memory name_,
738     string memory symbol_,
739     uint256 maxBatchSize_,
740     uint256 collectionSize_
741   ) {
742     require(
743       collectionSize_ > 0,
744       "ERC721A: collection must have a nonzero supply"
745     );
746     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
747     _name = name_;
748     _symbol = symbol_;
749     maxBatchSize = maxBatchSize_;
750     collectionSize = collectionSize_;
751   }
752 
753   /**
754    * @dev See {IERC721Enumerable-totalSupply}.
755    */
756   function totalSupply() public view override returns (uint256) {
757     return currentIndex;
758   }
759 
760   /**
761    * @dev See {IERC721Enumerable-tokenByIndex}.
762    */
763   function tokenByIndex(uint256 index) public view override returns (uint256) {
764     require(index < totalSupply(), "ERC721A: global index out of bounds");
765     return index;
766   }
767 
768   /**
769    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
770    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
771    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
772    */
773   function tokenOfOwnerByIndex(address owner, uint256 index)
774     public
775     view
776     override
777     returns (uint256)
778   {
779     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
780     uint256 numMintedSoFar = totalSupply();
781     uint256 tokenIdsIdx = 0;
782     address currOwnershipAddr = address(0);
783     for (uint256 i = 0; i < numMintedSoFar; i++) {
784       TokenOwnership memory ownership = _ownerships[i];
785       if (ownership.addr != address(0)) {
786         currOwnershipAddr = ownership.addr;
787       }
788       if (currOwnershipAddr == owner) {
789         if (tokenIdsIdx == index) {
790           return i;
791         }
792         tokenIdsIdx++;
793       }
794     }
795     revert("ERC721A: unable to get token of owner by index");
796   }
797 
798   /**
799    * @dev See {IERC165-supportsInterface}.
800    */
801   function supportsInterface(bytes4 interfaceId)
802     public
803     view
804     virtual
805     override(ERC165, IERC165)
806     returns (bool)
807   {
808     return
809       interfaceId == type(IERC721).interfaceId ||
810       interfaceId == type(IERC721Metadata).interfaceId ||
811       interfaceId == type(IERC721Enumerable).interfaceId ||
812       super.supportsInterface(interfaceId);
813   }
814 
815   /**
816    * @dev See {IERC721-balanceOf}.
817    */
818   function balanceOf(address owner) public view override returns (uint256) {
819     require(owner != address(0), "ERC721A: balance query for the zero address");
820     return uint256(_addressData[owner].balance);
821   }
822 
823   function _numberMinted(address owner) internal view returns (uint256) {
824     require(
825       owner != address(0),
826       "ERC721A: number minted query for the zero address"
827     );
828     return uint256(_addressData[owner].numberMinted);
829   }
830 
831   function ownershipOf(uint256 tokenId)
832     internal
833     view
834     returns (TokenOwnership memory)
835   {
836     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
837 
838     uint256 lowestTokenToCheck;
839     if (tokenId >= maxBatchSize) {
840       lowestTokenToCheck = tokenId - maxBatchSize + 1;
841     }
842 
843     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
844       TokenOwnership memory ownership = _ownerships[curr];
845       if (ownership.addr != address(0)) {
846         return ownership;
847       }
848     }
849 
850     revert("ERC721A: unable to determine the owner of token");
851   }
852 
853   /**
854    * @dev See {IERC721-ownerOf}.
855    */
856   function ownerOf(uint256 tokenId) public view override returns (address) {
857     return ownershipOf(tokenId).addr;
858   }
859 
860   /**
861    * @dev See {IERC721Metadata-name}.
862    */
863   function name() public view virtual override returns (string memory) {
864     return _name;
865   }
866 
867   /**
868    * @dev See {IERC721Metadata-symbol}.
869    */
870   function symbol() public view virtual override returns (string memory) {
871     return _symbol;
872   }
873 
874   /**
875    * @dev See {IERC721Metadata-tokenURI}.
876    */
877   function tokenURI(uint256 tokenId)
878     public
879     view
880     virtual
881     override
882     returns (string memory)
883   {
884     require(
885       _exists(tokenId),
886       "ERC721Metadata: URI query for nonexistent token"
887     );
888 
889     string memory baseURI = _baseURI();
890     return
891       bytes(baseURI).length > 0
892         ? string(abi.encodePacked(baseURI, tokenId.toString()))
893         : "";
894   }
895 
896   /**
897    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
898    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
899    * by default, can be overriden in child contracts.
900    */
901   function _baseURI() internal view virtual returns (string memory) {
902     return "";
903   }
904 
905   /**
906    * @dev See {IERC721-approve}.
907    */
908   function approve(address to, uint256 tokenId) public override {
909     address owner = ERC721A.ownerOf(tokenId);
910     require(to != owner, "ERC721A: approval to current owner");
911 
912     require(
913       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
914       "ERC721A: approve caller is not owner nor approved for all"
915     );
916 
917     _approve(to, tokenId, owner);
918   }
919 
920   /**
921    * @dev See {IERC721-getApproved}.
922    */
923   function getApproved(uint256 tokenId) public view override returns (address) {
924     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
925 
926     return _tokenApprovals[tokenId];
927   }
928 
929   /**
930    * @dev See {IERC721-setApprovalForAll}.
931    */
932   function setApprovalForAll(address operator, bool approved) public override {
933     require(operator != _msgSender(), "ERC721A: approve to caller");
934 
935     _operatorApprovals[_msgSender()][operator] = approved;
936     emit ApprovalForAll(_msgSender(), operator, approved);
937   }
938 
939   /**
940    * @dev See {IERC721-isApprovedForAll}.
941    */
942   function isApprovedForAll(address owner, address operator)
943     public
944     view
945     virtual
946     override
947     returns (bool)
948   {
949     return _operatorApprovals[owner][operator];
950   }
951 
952   /**
953    * @dev See {IERC721-transferFrom}.
954    */
955   function transferFrom(
956     address from,
957     address to,
958     uint256 tokenId
959   ) public override {
960     _transfer(from, to, tokenId);
961   }
962 
963   /**
964    * @dev See {IERC721-safeTransferFrom}.
965    */
966   function safeTransferFrom(
967     address from,
968     address to,
969     uint256 tokenId
970   ) public override {
971     safeTransferFrom(from, to, tokenId, "");
972   }
973 
974   /**
975    * @dev See {IERC721-safeTransferFrom}.
976    */
977   function safeTransferFrom(
978     address from,
979     address to,
980     uint256 tokenId,
981     bytes memory _data
982   ) public override {
983     _transfer(from, to, tokenId);
984     require(
985       _checkOnERC721Received(from, to, tokenId, _data),
986       "ERC721A: transfer to non ERC721Receiver implementer"
987     );
988   }
989 
990   /**
991    * @dev Returns whether `tokenId` exists.
992    *
993    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
994    *
995    * Tokens start existing when they are minted (`_mint`),
996    */
997   function _exists(uint256 tokenId) internal view returns (bool) {
998     return tokenId < currentIndex;
999   }
1000 
1001   function _safeMint(address to, uint256 quantity) internal {
1002     _safeMint(to, quantity, "");
1003   }
1004 
1005   /**
1006    * @dev Mints `quantity` tokens and transfers them to `to`.
1007    *
1008    * Requirements:
1009    *
1010    * - there must be `quantity` tokens remaining unminted in the total collection.
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
1131     if (endIndex > collectionSize - 1) {
1132       endIndex = collectionSize - 1;
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
1222 // File: contracts/Ownable.sol
1223 
1224 
1225 
1226 pragma solidity ^0.8.0;
1227 
1228 
1229 /**
1230  * @dev Contract module which provides a basic access control mechanism, where
1231  * there is an account (an owner) that can be granted exclusive access to
1232  * specific functions.
1233  *
1234  * By default, the owner account will be the one that deploys the contract. This
1235  * can later be changed with {transferOwnership}.
1236  *
1237  * This module is used through inheritance. It will make available the modifier
1238  * `onlyOwner`, which can be applied to your functions to restrict their use to
1239  * the owner.
1240  */
1241 abstract contract Ownable is Context {
1242     address private _owner;
1243 
1244     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1245 
1246     /**
1247      * @dev Initializes the contract setting the deployer as the initial owner.
1248      */
1249     constructor() {
1250         _setOwner(_msgSender());
1251     }
1252 
1253     /**
1254      * @dev Returns the address of the current owner.
1255      */
1256     function owner() public view virtual returns (address) {
1257         return _owner;
1258     }
1259 
1260     /**
1261      * @dev Throws if called by any account other than the owner.
1262      */
1263     modifier onlyOwner() {
1264         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1265         _;
1266     }
1267 
1268     /**
1269      * @dev Leaves the contract without owner. It will not be possible to call
1270      * `onlyOwner` functions anymore. Can only be called by the current owner.
1271      *
1272      * NOTE: Renouncing ownership will leave the contract without an owner,
1273      * thereby removing any functionality that is only available to the owner.
1274      */
1275     function renounceOwnership() public virtual onlyOwner {
1276         _setOwner(address(0));
1277     }
1278 
1279     /**
1280      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1281      * Can only be called by the current owner.
1282      */
1283     function transferOwnership(address newOwner) public virtual onlyOwner {
1284         require(newOwner != address(0), "Ownable: new owner is the zero address");
1285         _setOwner(newOwner);
1286     }
1287 
1288     function _setOwner(address newOwner) private {
1289         address oldOwner = _owner;
1290         _owner = newOwner;
1291         emit OwnershipTransferred(oldOwner, newOwner);
1292     }
1293 }
1294 
1295 // File: contracts/FarSide.sol
1296 
1297 
1298 
1299 pragma solidity ^0.8.0;
1300 
1301 
1302 
1303 
1304 
1305 contract FarSide is Ownable, ERC721A, ReentrancyGuard {
1306   uint256 public immutable maxPerAddressDuringMint;
1307   uint256 public immutable amountForDevs;
1308   mapping(address => uint256) public allowlist;
1309 
1310   constructor(
1311     uint256 maxBatchSize_,
1312     uint256 collectionSize_,
1313     uint256 amountForDevs_
1314   ) ERC721A("FarSide", "FARSIDE", maxBatchSize_, collectionSize_) {
1315     maxPerAddressDuringMint = maxBatchSize_;
1316     amountForDevs = amountForDevs_;
1317   }
1318 
1319   modifier callerIsUser() {
1320     require(tx.origin == msg.sender, "The caller is another contract");
1321     _;
1322   }
1323 
1324 
1325 
1326   function mint(uint256 quantity) external callerIsUser {
1327 
1328     require(totalSupply() + quantity <= collectionSize, "reached max supply");
1329     require(
1330       numberMinted(msg.sender) + quantity <= maxPerAddressDuringMint,
1331       "can not mint this many"
1332     );
1333     _safeMint(msg.sender, quantity);
1334   }
1335 
1336   // For marketing etc.
1337   function devMint(uint256 quantity) external onlyOwner {
1338     require(
1339       totalSupply() + quantity <= amountForDevs,
1340       "too many already minted before dev mint"
1341     );
1342     require(
1343       quantity % maxBatchSize == 0,
1344       "can only mint a multiple of the maxBatchSize"
1345     );
1346     uint256 numChunks = quantity / maxBatchSize;
1347     for (uint256 i = 0; i < numChunks; i++) {
1348       _safeMint(msg.sender, maxBatchSize);
1349     }
1350   }
1351 
1352   // // metadata URI
1353   string private _baseTokenURI;
1354 
1355   function _baseURI() internal view virtual override returns (string memory) {
1356     return _baseTokenURI;
1357   }
1358 
1359   function setBaseURI(string calldata baseURI) external onlyOwner {
1360     _baseTokenURI = baseURI;
1361   }
1362 
1363   function withdrawMoney() external onlyOwner nonReentrant {
1364     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1365     require(success, "Transfer failed.");
1366   }
1367 
1368   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1369     _setOwnersExplicit(quantity);
1370   }
1371 
1372   function numberMinted(address owner) public view returns (uint256) {
1373     return _numberMinted(owner);
1374   }
1375 
1376   function getOwnershipData(uint256 tokenId)
1377     external
1378     view
1379     returns (TokenOwnership memory)
1380   {
1381     return ownershipOf(tokenId);
1382   }
1383 
1384 }