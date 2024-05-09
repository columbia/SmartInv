1 // SPDX-License-Identifier: MIT
2 // File: contracts/Strings.sol
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
68 // File: contracts/Address.sol
69 
70 
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev Collection of functions related to the address type
76  */
77 library Address {
78     /**
79      * @dev Returns true if `account` is a contract.
80      *
81      * [IMPORTANT]
82      * ====
83      * It is unsafe to assume that an address for which this function returns
84      * false is an externally-owned account (EOA) and not a contract.
85      *
86      * Among others, `isContract` will return false for the following
87      * types of addresses:
88      *
89      *  - an externally-owned account
90      *  - a contract in construction
91      *  - an address where a contract will be created
92      *  - an address where a contract lived, but was destroyed
93      * ====
94      */
95     function isContract(address account) internal view returns (bool) {
96         // This method relies on extcodesize, which returns 0 for contracts in
97         // construction, since the code is only stored at the end of the
98         // constructor execution.
99 
100         uint256 size;
101         assembly {
102             size := extcodesize(account)
103         }
104         return size > 0;
105     }
106 
107     /**
108      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
109      * `recipient`, forwarding all available gas and reverting on errors.
110      *
111      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
112      * of certain opcodes, possibly making contracts go over the 2300 gas limit
113      * imposed by `transfer`, making them unable to receive funds via
114      * `transfer`. {sendValue} removes this limitation.
115      *
116      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
117      *
118      * IMPORTANT: because control is transferred to `recipient`, care must be
119      * taken to not create reentrancy vulnerabilities. Consider using
120      * {ReentrancyGuard} or the
121      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
122      */
123     function sendValue(address payable recipient, uint256 amount) internal {
124         require(address(this).balance >= amount, "Address: insufficient balance");
125 
126         (bool success, ) = recipient.call{value: amount}("");
127         require(success, "Address: unable to send value, recipient may have reverted");
128     }
129 
130     /**
131      * @dev Performs a Solidity function call using a low level `call`. A
132      * plain `call` is an unsafe replacement for a function call: use this
133      * function instead.
134      *
135      * If `target` reverts with a revert reason, it is bubbled up by this
136      * function (like regular Solidity function calls).
137      *
138      * Returns the raw returned data. To convert to the expected return value,
139      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
140      *
141      * Requirements:
142      *
143      * - `target` must be a contract.
144      * - calling `target` with `data` must not revert.
145      *
146      * _Available since v3.1._
147      */
148     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
149         return functionCall(target, data, "Address: low-level call failed");
150     }
151 
152     /**
153      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
154      * `errorMessage` as a fallback revert reason when `target` reverts.
155      *
156      * _Available since v3.1._
157      */
158     function functionCall(
159         address target,
160         bytes memory data,
161         string memory errorMessage
162     ) internal returns (bytes memory) {
163         return functionCallWithValue(target, data, 0, errorMessage);
164     }
165 
166     /**
167      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
168      * but also transferring `value` wei to `target`.
169      *
170      * Requirements:
171      *
172      * - the calling contract must have an ETH balance of at least `value`.
173      * - the called Solidity function must be `payable`.
174      *
175      * _Available since v3.1._
176      */
177     function functionCallWithValue(
178         address target,
179         bytes memory data,
180         uint256 value
181     ) internal returns (bytes memory) {
182         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
183     }
184 
185     /**
186      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
187      * with `errorMessage` as a fallback revert reason when `target` reverts.
188      *
189      * _Available since v3.1._
190      */
191     function functionCallWithValue(
192         address target,
193         bytes memory data,
194         uint256 value,
195         string memory errorMessage
196     ) internal returns (bytes memory) {
197         require(address(this).balance >= value, "Address: insufficient balance for call");
198         require(isContract(target), "Address: call to non-contract");
199 
200         (bool success, bytes memory returndata) = target.call{value: value}(data);
201         return _verifyCallResult(success, returndata, errorMessage);
202     }
203 
204     /**
205      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
206      * but performing a static call.
207      *
208      * _Available since v3.3._
209      */
210     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
211         return functionStaticCall(target, data, "Address: low-level static call failed");
212     }
213 
214     /**
215      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
216      * but performing a static call.
217      *
218      * _Available since v3.3._
219      */
220     function functionStaticCall(
221         address target,
222         bytes memory data,
223         string memory errorMessage
224     ) internal view returns (bytes memory) {
225         require(isContract(target), "Address: static call to non-contract");
226 
227         (bool success, bytes memory returndata) = target.staticcall(data);
228         return _verifyCallResult(success, returndata, errorMessage);
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
233      * but performing a delegate call.
234      *
235      * _Available since v3.4._
236      */
237     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
238         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
239     }
240 
241     /**
242      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
243      * but performing a delegate call.
244      *
245      * _Available since v3.4._
246      */
247     function functionDelegateCall(
248         address target,
249         bytes memory data,
250         string memory errorMessage
251     ) internal returns (bytes memory) {
252         require(isContract(target), "Address: delegate call to non-contract");
253 
254         (bool success, bytes memory returndata) = target.delegatecall(data);
255         return _verifyCallResult(success, returndata, errorMessage);
256     }
257 
258     function _verifyCallResult(
259         bool success,
260         bytes memory returndata,
261         string memory errorMessage
262     ) private pure returns (bytes memory) {
263         if (success) {
264             return returndata;
265         } else {
266             // Look for revert reason and bubble it up if present
267             if (returndata.length > 0) {
268                 // The easiest way to bubble the revert reason is using memory via assembly
269 
270                 assembly {
271                     let returndata_size := mload(returndata)
272                     revert(add(32, returndata), returndata_size)
273                 }
274             } else {
275                 revert(errorMessage);
276             }
277         }
278     }
279 }
280 
281 // File: contracts/IERC721Receiver.sol
282 
283 
284 
285 pragma solidity ^0.8.0;
286 
287 /**
288  * @title ERC721 token receiver interface
289  * @dev Interface for any contract that wants to support safeTransfers
290  * from ERC721 asset contracts.
291  */
292 interface IERC721Receiver {
293     /**
294      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
295      * by `operator` from `from`, this function is called.
296      *
297      * It must return its Solidity selector to confirm the token transfer.
298      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
299      *
300      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
301      */
302     function onERC721Received(
303         address operator,
304         address from,
305         uint256 tokenId,
306         bytes calldata data
307     ) external returns (bytes4);
308 }
309 
310 // File: contracts/IERC165.sol
311 
312 
313 
314 pragma solidity ^0.8.0;
315 
316 /**
317  * @dev Interface of the ERC165 standard, as defined in the
318  * https://eips.ethereum.org/EIPS/eip-165[EIP].
319  *
320  * Implementers can declare support of contract interfaces, which can then be
321  * queried by others ({ERC165Checker}).
322  *
323  * For an implementation, see {ERC165}.
324  */
325 interface IERC165 {
326     /**
327      * @dev Returns true if this contract implements the interface defined by
328      * `interfaceId`. See the corresponding
329      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
330      * to learn more about how these ids are created.
331      *
332      * This function call must use less than 30 000 gas.
333      */
334     function supportsInterface(bytes4 interfaceId) external view returns (bool);
335 }
336 
337 // File: contracts/ERC165.sol
338 
339 
340 
341 pragma solidity ^0.8.0;
342 
343 
344 /**
345  * @dev Implementation of the {IERC165} interface.
346  *
347  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
348  * for the additional interface id that will be supported. For example:
349  *
350  * ```solidity
351  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
352  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
353  * }
354  * ```
355  *
356  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
357  */
358 abstract contract ERC165 is IERC165 {
359     /**
360      * @dev See {IERC165-supportsInterface}.
361      */
362     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
363         return interfaceId == type(IERC165).interfaceId;
364     }
365 }
366 
367 // File: contracts/IERC721.sol
368 
369 
370 
371 pragma solidity ^0.8.0;
372 
373 
374 /**
375  * @dev Required interface of an ERC721 compliant contract.
376  */
377 interface IERC721 is IERC165 {
378     /**
379      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
380      */
381     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
382 
383     /**
384      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
385      */
386     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
387 
388     /**
389      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
390      */
391     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
392 
393     /**
394      * @dev Returns the number of tokens in ``owner``'s account.
395      */
396     function balanceOf(address owner) external view returns (uint256 balance);
397 
398     /**
399      * @dev Returns the owner of the `tokenId` token.
400      *
401      * Requirements:
402      *
403      * - `tokenId` must exist.
404      */
405     function ownerOf(uint256 tokenId) external view returns (address owner);
406 
407     /**
408      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
409      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
410      *
411      * Requirements:
412      *
413      * - `from` cannot be the zero address.
414      * - `to` cannot be the zero address.
415      * - `tokenId` token must exist and be owned by `from`.
416      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
417      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
418      *
419      * Emits a {Transfer} event.
420      */
421     function safeTransferFrom(
422         address from,
423         address to,
424         uint256 tokenId
425     ) external;
426 
427     /**
428      * @dev Transfers `tokenId` token from `from` to `to`.
429      *
430      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
431      *
432      * Requirements:
433      *
434      * - `from` cannot be the zero address.
435      * - `to` cannot be the zero address.
436      * - `tokenId` token must be owned by `from`.
437      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
438      *
439      * Emits a {Transfer} event.
440      */
441     function transferFrom(
442         address from,
443         address to,
444         uint256 tokenId
445     ) external;
446 
447     /**
448      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
449      * The approval is cleared when the token is transferred.
450      *
451      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
452      *
453      * Requirements:
454      *
455      * - The caller must own the token or be an approved operator.
456      * - `tokenId` must exist.
457      *
458      * Emits an {Approval} event.
459      */
460     function approve(address to, uint256 tokenId) external;
461 
462     /**
463      * @dev Returns the account approved for `tokenId` token.
464      *
465      * Requirements:
466      *
467      * - `tokenId` must exist.
468      */
469     function getApproved(uint256 tokenId) external view returns (address operator);
470 
471     /**
472      * @dev Approve or remove `operator` as an operator for the caller.
473      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
474      *
475      * Requirements:
476      *
477      * - The `operator` cannot be the caller.
478      *
479      * Emits an {ApprovalForAll} event.
480      */
481     function setApprovalForAll(address operator, bool _approved) external;
482 
483     /**
484      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
485      *
486      * See {setApprovalForAll}
487      */
488     function isApprovedForAll(address owner, address operator) external view returns (bool);
489 
490     /**
491      * @dev Safely transfers `tokenId` token from `from` to `to`.
492      *
493      * Requirements:
494      *
495      * - `from` cannot be the zero address.
496      * - `to` cannot be the zero address.
497      * - `tokenId` token must exist and be owned by `from`.
498      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
499      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
500      *
501      * Emits a {Transfer} event.
502      */
503     function safeTransferFrom(
504         address from,
505         address to,
506         uint256 tokenId,
507         bytes calldata data
508     ) external;
509 }
510 
511 // File: contracts/IERC721Enumerable.sol
512 
513 
514 
515 pragma solidity ^0.8.0;
516 
517 
518 /**
519  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
520  * @dev See https://eips.ethereum.org/EIPS/eip-721
521  */
522 interface IERC721Enumerable is IERC721 {
523     /**
524      * @dev Returns the total amount of tokens stored by the contract.
525      */
526     function totalSupply() external view returns (uint256);
527 
528     /**
529      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
530      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
531      */
532     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
533 
534     /**
535      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
536      * Use along with {totalSupply} to enumerate all tokens.
537      */
538     function tokenByIndex(uint256 index) external view returns (uint256);
539 }
540 
541 // File: contracts/IERC721Metadata.sol
542 
543 
544 
545 pragma solidity ^0.8.0;
546 
547 
548 /**
549  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
550  * @dev See https://eips.ethereum.org/EIPS/eip-721
551  */
552 interface IERC721Metadata is IERC721 {
553     /**
554      * @dev Returns the token collection name.
555      */
556     function name() external view returns (string memory);
557 
558     /**
559      * @dev Returns the token collection symbol.
560      */
561     function symbol() external view returns (string memory);
562 
563     /**
564      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
565      */
566     function tokenURI(uint256 tokenId) external view returns (string memory);
567 }
568 
569 // File: contracts/ReentrancyGuard.sol
570 
571 
572 
573 pragma solidity ^0.8.0;
574 
575 /**
576  * @dev Contract module that helps prevent reentrant calls to a function.
577  *
578  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
579  * available, which can be applied to functions to make sure there are no nested
580  * (reentrant) calls to them.
581  *
582  * Note that because there is a single `nonReentrant` guard, functions marked as
583  * `nonReentrant` may not call one another. This can be worked around by making
584  * those functions `private`, and then adding `external` `nonReentrant` entry
585  * points to them.
586  *
587  * TIP: If you would like to learn more about reentrancy and alternative ways
588  * to protect against it, check out our blog post
589  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
590  */
591 abstract contract ReentrancyGuard {
592     // Booleans are more expensive than uint256 or any type that takes up a full
593     // word because each write operation emits an extra SLOAD to first read the
594     // slot's contents, replace the bits taken up by the boolean, and then write
595     // back. This is the compiler's defense against contract upgrades and
596     // pointer aliasing, and it cannot be disabled.
597 
598     // The values being non-zero value makes deployment a bit more expensive,
599     // but in exchange the refund on every call to nonReentrant will be lower in
600     // amount. Since refunds are capped to a percentage of the total
601     // transaction's gas, it is best to keep them low in cases like this one, to
602     // increase the likelihood of the full refund coming into effect.
603     uint256 private constant _NOT_ENTERED = 1;
604     uint256 private constant _ENTERED = 2;
605 
606     uint256 private _status;
607 
608     constructor() {
609         _status = _NOT_ENTERED;
610     }
611 
612     /**
613      * @dev Prevents a contract from calling itself, directly or indirectly.
614      * Calling a `nonReentrant` function from another `nonReentrant`
615      * function is not supported. It is possible to prevent this from happening
616      * by making the `nonReentrant` function external, and make it call a
617      * `private` function that does the actual work.
618      */
619     modifier nonReentrant() {
620         // On the first call to nonReentrant, _notEntered will be true
621         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
622 
623         // Any calls to nonReentrant after this point will fail
624         _status = _ENTERED;
625 
626         _;
627 
628         // By storing the original value once again, a refund is triggered (see
629         // https://eips.ethereum.org/EIPS/eip-2200)
630         _status = _NOT_ENTERED;
631     }
632 }
633 
634 // File: contracts/Context.sol
635 
636 
637 
638 pragma solidity ^0.8.0;
639 
640 /*
641  * @dev Provides information about the current execution context, including the
642  * sender of the transaction and its data. While these are generally available
643  * via msg.sender and msg.data, they should not be accessed in such a direct
644  * manner, since when dealing with meta-transactions the account sending and
645  * paying for execution may not be the actual sender (as far as an application
646  * is concerned).
647  *
648  * This contract is only required for intermediate, library-like contracts.
649  */
650 abstract contract Context {
651     function _msgSender() internal view virtual returns (address) {
652         return msg.sender;
653     }
654 
655     function _msgData() internal view virtual returns (bytes calldata) {
656         return msg.data;
657     }
658 }
659 
660 // File: contracts/ERC721A.sol
661 
662 
663 
664 pragma solidity ^0.8.0;
665 
666 
667 
668 
669 
670 
671 
672 
673 
674 /**
675  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
676  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
677  *
678  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
679  *
680  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
681  *
682  * Does not support burning tokens to address(0).
683  */
684 contract ERC721A is
685   Context,
686   ERC165,
687   IERC721,
688   IERC721Metadata,
689   IERC721Enumerable
690 {
691   using Address for address;
692   using Strings for uint256;
693 
694   struct TokenOwnership {
695     address addr;
696     uint64 startTimestamp;
697   }
698 
699   struct AddressData {
700     uint128 balance;
701     uint128 numberMinted;
702   }
703 
704   uint256 private currentIndex = 0;
705 
706   uint256 internal immutable collectionSize;
707   uint256 internal immutable maxBatchSize;
708 
709   // Token name
710   string private _name;
711 
712   // Token symbol
713   string private _symbol;
714 
715   // Mapping from token ID to ownership details
716   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
717   mapping(uint256 => TokenOwnership) private _ownerships;
718 
719   // Mapping owner address to address data
720   mapping(address => AddressData) private _addressData;
721 
722   // Mapping from token ID to approved address
723   mapping(uint256 => address) private _tokenApprovals;
724 
725   // Mapping from owner to operator approvals
726   mapping(address => mapping(address => bool)) private _operatorApprovals;
727 
728   /**
729    * @dev
730    * `maxBatchSize` refers to how much a minter can mint at a time.
731    * `collectionSize_` refers to how many tokens are in the collection.
732    */
733   constructor(
734     string memory name_,
735     string memory symbol_,
736     uint256 maxBatchSize_,
737     uint256 collectionSize_
738   ) {
739     require(
740       collectionSize_ > 0,
741       "ERC721A: collection must have a nonzero supply"
742     );
743     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
744     _name = name_;
745     _symbol = symbol_;
746     maxBatchSize = maxBatchSize_;
747     collectionSize = collectionSize_;
748   }
749 
750   /**
751    * @dev See {IERC721Enumerable-totalSupply}.
752    */
753   function totalSupply() public view override returns (uint256) {
754     return currentIndex;
755   }
756 
757   /**
758    * @dev See {IERC721Enumerable-tokenByIndex}.
759    */
760   function tokenByIndex(uint256 index) public view override returns (uint256) {
761     require(index < totalSupply(), "ERC721A: global index out of bounds");
762     return index;
763   }
764 
765   /**
766    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
767    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
768    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
769    */
770   function tokenOfOwnerByIndex(address owner, uint256 index)
771     public
772     view
773     override
774     returns (uint256)
775   {
776     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
777     uint256 numMintedSoFar = totalSupply();
778     uint256 tokenIdsIdx = 0;
779     address currOwnershipAddr = address(0);
780     for (uint256 i = 0; i < numMintedSoFar; i++) {
781       TokenOwnership memory ownership = _ownerships[i];
782       if (ownership.addr != address(0)) {
783         currOwnershipAddr = ownership.addr;
784       }
785       if (currOwnershipAddr == owner) {
786         if (tokenIdsIdx == index) {
787           return i;
788         }
789         tokenIdsIdx++;
790       }
791     }
792     revert("ERC721A: unable to get token of owner by index");
793   }
794 
795   /**
796    * @dev See {IERC165-supportsInterface}.
797    */
798   function supportsInterface(bytes4 interfaceId)
799     public
800     view
801     virtual
802     override(ERC165, IERC165)
803     returns (bool)
804   {
805     return
806       interfaceId == type(IERC721).interfaceId ||
807       interfaceId == type(IERC721Metadata).interfaceId ||
808       interfaceId == type(IERC721Enumerable).interfaceId ||
809       super.supportsInterface(interfaceId);
810   }
811 
812   /**
813    * @dev See {IERC721-balanceOf}.
814    */
815   function balanceOf(address owner) public view override returns (uint256) {
816     require(owner != address(0), "ERC721A: balance query for the zero address");
817     return uint256(_addressData[owner].balance);
818   }
819 
820   function _numberMinted(address owner) internal view returns (uint256) {
821     require(
822       owner != address(0),
823       "ERC721A: number minted query for the zero address"
824     );
825     return uint256(_addressData[owner].numberMinted);
826   }
827 
828   function ownershipOf(uint256 tokenId)
829     internal
830     view
831     returns (TokenOwnership memory)
832   {
833     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
834 
835     uint256 lowestTokenToCheck;
836     if (tokenId >= maxBatchSize) {
837       lowestTokenToCheck = tokenId - maxBatchSize + 1;
838     }
839 
840     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
841       TokenOwnership memory ownership = _ownerships[curr];
842       if (ownership.addr != address(0)) {
843         return ownership;
844       }
845     }
846 
847     revert("ERC721A: unable to determine the owner of token");
848   }
849 
850   /**
851    * @dev See {IERC721-ownerOf}.
852    */
853   function ownerOf(uint256 tokenId) public view override returns (address) {
854     return ownershipOf(tokenId).addr;
855   }
856 
857   /**
858    * @dev See {IERC721Metadata-name}.
859    */
860   function name() public view virtual override returns (string memory) {
861     return _name;
862   }
863 
864   /**
865    * @dev See {IERC721Metadata-symbol}.
866    */
867   function symbol() public view virtual override returns (string memory) {
868     return _symbol;
869   }
870 
871   /**
872    * @dev See {IERC721Metadata-tokenURI}.
873    */
874   function tokenURI(uint256 tokenId)
875     public
876     view
877     virtual
878     override
879     returns (string memory)
880   {
881     require(
882       _exists(tokenId),
883       "ERC721Metadata: URI query for nonexistent token"
884     );
885 
886     string memory baseURI = _baseURI();
887     return
888       bytes(baseURI).length > 0
889         ? string(abi.encodePacked(baseURI, tokenId.toString()))
890         : "";
891   }
892 
893   /**
894    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
895    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
896    * by default, can be overriden in child contracts.
897    */
898   function _baseURI() internal view virtual returns (string memory) {
899     return "";
900   }
901 
902   /**
903    * @dev See {IERC721-approve}.
904    */
905   function approve(address to, uint256 tokenId) public override {
906     address owner = ERC721A.ownerOf(tokenId);
907     require(to != owner, "ERC721A: approval to current owner");
908 
909     require(
910       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
911       "ERC721A: approve caller is not owner nor approved for all"
912     );
913 
914     _approve(to, tokenId, owner);
915   }
916 
917   /**
918    * @dev See {IERC721-getApproved}.
919    */
920   function getApproved(uint256 tokenId) public view override returns (address) {
921     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
922 
923     return _tokenApprovals[tokenId];
924   }
925 
926   /**
927    * @dev See {IERC721-setApprovalForAll}.
928    */
929   function setApprovalForAll(address operator, bool approved) public override {
930     require(operator != _msgSender(), "ERC721A: approve to caller");
931 
932     _operatorApprovals[_msgSender()][operator] = approved;
933     emit ApprovalForAll(_msgSender(), operator, approved);
934   }
935 
936   /**
937    * @dev See {IERC721-isApprovedForAll}.
938    */
939   function isApprovedForAll(address owner, address operator)
940     public
941     view
942     virtual
943     override
944     returns (bool)
945   {
946     return _operatorApprovals[owner][operator];
947   }
948 
949   /**
950    * @dev See {IERC721-transferFrom}.
951    */
952   function transferFrom(
953     address from,
954     address to,
955     uint256 tokenId
956   ) public override {
957     _transfer(from, to, tokenId);
958   }
959 
960   /**
961    * @dev See {IERC721-safeTransferFrom}.
962    */
963   function safeTransferFrom(
964     address from,
965     address to,
966     uint256 tokenId
967   ) public override {
968     safeTransferFrom(from, to, tokenId, "");
969   }
970 
971   /**
972    * @dev See {IERC721-safeTransferFrom}.
973    */
974   function safeTransferFrom(
975     address from,
976     address to,
977     uint256 tokenId,
978     bytes memory _data
979   ) public override {
980     _transfer(from, to, tokenId);
981     require(
982       _checkOnERC721Received(from, to, tokenId, _data),
983       "ERC721A: transfer to non ERC721Receiver implementer"
984     );
985   }
986 
987   /**
988    * @dev Returns whether `tokenId` exists.
989    *
990    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
991    *
992    * Tokens start existing when they are minted (`_mint`),
993    */
994   function _exists(uint256 tokenId) internal view returns (bool) {
995     return tokenId < currentIndex;
996   }
997 
998   function _safeMint(address to, uint256 quantity) internal {
999     _safeMint(to, quantity, "");
1000   }
1001 
1002   /**
1003    * @dev Mints `quantity` tokens and transfers them to `to`.
1004    *
1005    * Requirements:
1006    *
1007    * - there must be `quantity` tokens remaining unminted in the total collection.
1008    * - `to` cannot be the zero address.
1009    * - `quantity` cannot be larger than the max batch size.
1010    *
1011    * Emits a {Transfer} event.
1012    */
1013   function _safeMint(
1014     address to,
1015     uint256 quantity,
1016     bytes memory _data
1017   ) internal {
1018     uint256 startTokenId = currentIndex;
1019     require(to != address(0), "ERC721A: mint to the zero address");
1020     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1021     require(!_exists(startTokenId), "ERC721A: token already minted");
1022     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1023 
1024     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1025 
1026     AddressData memory addressData = _addressData[to];
1027     _addressData[to] = AddressData(
1028       addressData.balance + uint128(quantity),
1029       addressData.numberMinted + uint128(quantity)
1030     );
1031     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1032 
1033     uint256 updatedIndex = startTokenId;
1034 
1035     for (uint256 i = 0; i < quantity; i++) {
1036       emit Transfer(address(0), to, updatedIndex);
1037       require(
1038         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1039         "ERC721A: transfer to non ERC721Receiver implementer"
1040       );
1041       updatedIndex++;
1042     }
1043 
1044     currentIndex = updatedIndex;
1045     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1046   }
1047 
1048   /**
1049    * @dev Transfers `tokenId` from `from` to `to`.
1050    *
1051    * Requirements:
1052    *
1053    * - `to` cannot be the zero address.
1054    * - `tokenId` token must be owned by `from`.
1055    *
1056    * Emits a {Transfer} event.
1057    */
1058   function _transfer(
1059     address from,
1060     address to,
1061     uint256 tokenId
1062   ) private {
1063     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1064 
1065     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1066       getApproved(tokenId) == _msgSender() ||
1067       isApprovedForAll(prevOwnership.addr, _msgSender()));
1068 
1069     require(
1070       isApprovedOrOwner,
1071       "ERC721A: transfer caller is not owner nor approved"
1072     );
1073 
1074     require(
1075       prevOwnership.addr == from,
1076       "ERC721A: transfer from incorrect owner"
1077     );
1078     require(to != address(0), "ERC721A: transfer to the zero address");
1079 
1080     _beforeTokenTransfers(from, to, tokenId, 1);
1081 
1082     // Clear approvals from the previous owner
1083     _approve(address(0), tokenId, prevOwnership.addr);
1084 
1085     _addressData[from].balance -= 1;
1086     _addressData[to].balance += 1;
1087     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1088 
1089     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1090     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1091     uint256 nextTokenId = tokenId + 1;
1092     if (_ownerships[nextTokenId].addr == address(0)) {
1093       if (_exists(nextTokenId)) {
1094         _ownerships[nextTokenId] = TokenOwnership(
1095           prevOwnership.addr,
1096           prevOwnership.startTimestamp
1097         );
1098       }
1099     }
1100 
1101     emit Transfer(from, to, tokenId);
1102     _afterTokenTransfers(from, to, tokenId, 1);
1103   }
1104 
1105   /**
1106    * @dev Approve `to` to operate on `tokenId`
1107    *
1108    * Emits a {Approval} event.
1109    */
1110   function _approve(
1111     address to,
1112     uint256 tokenId,
1113     address owner
1114   ) private {
1115     _tokenApprovals[tokenId] = to;
1116     emit Approval(owner, to, tokenId);
1117   }
1118 
1119   uint256 public nextOwnerToExplicitlySet = 0;
1120 
1121   /**
1122    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1123    */
1124   function _setOwnersExplicit(uint256 quantity) internal {
1125     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1126     require(quantity > 0, "quantity must be nonzero");
1127     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1128     if (endIndex > collectionSize - 1) {
1129       endIndex = collectionSize - 1;
1130     }
1131     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1132     require(_exists(endIndex), "not enough minted yet for this cleanup");
1133     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1134       if (_ownerships[i].addr == address(0)) {
1135         TokenOwnership memory ownership = ownershipOf(i);
1136         _ownerships[i] = TokenOwnership(
1137           ownership.addr,
1138           ownership.startTimestamp
1139         );
1140       }
1141     }
1142     nextOwnerToExplicitlySet = endIndex + 1;
1143   }
1144 
1145   /**
1146    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1147    * The call is not executed if the target address is not a contract.
1148    *
1149    * @param from address representing the previous owner of the given token ID
1150    * @param to target address that will receive the tokens
1151    * @param tokenId uint256 ID of the token to be transferred
1152    * @param _data bytes optional data to send along with the call
1153    * @return bool whether the call correctly returned the expected magic value
1154    */
1155   function _checkOnERC721Received(
1156     address from,
1157     address to,
1158     uint256 tokenId,
1159     bytes memory _data
1160   ) private returns (bool) {
1161     if (to.isContract()) {
1162       try
1163         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1164       returns (bytes4 retval) {
1165         return retval == IERC721Receiver(to).onERC721Received.selector;
1166       } catch (bytes memory reason) {
1167         if (reason.length == 0) {
1168           revert("ERC721A: transfer to non ERC721Receiver implementer");
1169         } else {
1170           assembly {
1171             revert(add(32, reason), mload(reason))
1172           }
1173         }
1174       }
1175     } else {
1176       return true;
1177     }
1178   }
1179 
1180   /**
1181    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1182    *
1183    * startTokenId - the first token id to be transferred
1184    * quantity - the amount to be transferred
1185    *
1186    * Calling conditions:
1187    *
1188    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1189    * transferred to `to`.
1190    * - When `from` is zero, `tokenId` will be minted for `to`.
1191    */
1192   function _beforeTokenTransfers(
1193     address from,
1194     address to,
1195     uint256 startTokenId,
1196     uint256 quantity
1197   ) internal virtual {}
1198 
1199   /**
1200    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1201    * minting.
1202    *
1203    * startTokenId - the first token id to be transferred
1204    * quantity - the amount to be transferred
1205    *
1206    * Calling conditions:
1207    *
1208    * - when `from` and `to` are both non-zero.
1209    * - `from` and `to` are never both zero.
1210    */
1211   function _afterTokenTransfers(
1212     address from,
1213     address to,
1214     uint256 startTokenId,
1215     uint256 quantity
1216   ) internal virtual {}
1217 }
1218 
1219 // File: contracts/Ownable.sol
1220 
1221 
1222 
1223 pragma solidity ^0.8.0;
1224 
1225 
1226 /**
1227  * @dev Contract module which provides a basic access control mechanism, where
1228  * there is an account (an owner) that can be granted exclusive access to
1229  * specific functions.
1230  *
1231  * By default, the owner account will be the one that deploys the contract. This
1232  * can later be changed with {transferOwnership}.
1233  *
1234  * This module is used through inheritance. It will make available the modifier
1235  * `onlyOwner`, which can be applied to your functions to restrict their use to
1236  * the owner.
1237  */
1238 abstract contract Ownable is Context {
1239     address private _owner;
1240 
1241     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1242 
1243     /**
1244      * @dev Initializes the contract setting the deployer as the initial owner.
1245      */
1246     constructor() {
1247         _setOwner(_msgSender());
1248     }
1249 
1250     /**
1251      * @dev Returns the address of the current owner.
1252      */
1253     function owner() public view virtual returns (address) {
1254         return _owner;
1255     }
1256 
1257     /**
1258      * @dev Throws if called by any account other than the owner.
1259      */
1260     modifier onlyOwner() {
1261         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1262         _;
1263     }
1264 
1265     /**
1266      * @dev Leaves the contract without owner. It will not be possible to call
1267      * `onlyOwner` functions anymore. Can only be called by the current owner.
1268      *
1269      * NOTE: Renouncing ownership will leave the contract without an owner,
1270      * thereby removing any functionality that is only available to the owner.
1271      */
1272     function renounceOwnership() public virtual onlyOwner {
1273         _setOwner(address(0));
1274     }
1275 
1276     /**
1277      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1278      * Can only be called by the current owner.
1279      */
1280     function transferOwnership(address newOwner) public virtual onlyOwner {
1281         require(newOwner != address(0), "Ownable: new owner is the zero address");
1282         _setOwner(newOwner);
1283     }
1284 
1285     function _setOwner(address newOwner) private {
1286         address oldOwner = _owner;
1287         _owner = newOwner;
1288         emit OwnershipTransferred(oldOwner, newOwner);
1289     }
1290 }
1291 
1292 // File: contracts/YAYC.sol
1293 
1294 
1295 
1296 pragma solidity ^0.8.0;
1297 
1298 
1299 
1300 
1301 
1302 contract YAYC is Ownable, ERC721A, ReentrancyGuard {
1303   uint256 public immutable maxPerAddressDuringMint;
1304   uint256 public immutable amountForDevs;
1305   uint256 public immutable amountForFree;
1306   uint256 public mintPrice = 0; //0.05 ETH
1307   uint256 public listPrice = 0; //0.05 ETH
1308 
1309   mapping(address => uint256) public allowlist;
1310 
1311   constructor(
1312     uint256 maxBatchSize_,
1313     uint256 collectionSize_,
1314     uint256 amountForDevs_,
1315     uint256 amountForFree_
1316   ) ERC721A("y00ts Apepe Yacht Club", "YAYC", maxBatchSize_, collectionSize_) {
1317     maxPerAddressDuringMint = maxBatchSize_;
1318     amountForDevs = amountForDevs_;
1319     amountForFree = amountForFree_;
1320   }
1321 
1322   modifier callerIsUser() {
1323     require(tx.origin == msg.sender, "The caller is another contract");
1324     _;
1325   }
1326 
1327   function freeMint(uint256 quantity) external callerIsUser {
1328 
1329     require(totalSupply() + quantity <= amountForFree, "reached max supply");
1330     require(
1331       numberMinted(msg.sender) + quantity <= maxPerAddressDuringMint,
1332       "can not mint this many"
1333     );
1334     _safeMint(msg.sender, quantity);
1335   }
1336 
1337   function allowlistMint() external payable callerIsUser {
1338     uint256 price = listPrice;
1339     require(price != 0, "allowlist sale has not begun yet");
1340     require(allowlist[msg.sender] > 0, "not eligible for allowlist mint");
1341     require(totalSupply() + 1 <= collectionSize, "reached max supply");
1342     allowlist[msg.sender]--;
1343     _safeMint(msg.sender, 1);
1344     refundIfOver(price);
1345   }
1346 
1347   function publicSaleMint(uint256 quantity)
1348     external
1349     payable
1350     callerIsUser
1351   {
1352     uint256 publicPrice = mintPrice;
1353 
1354     require(
1355       isPublicSaleOn(publicPrice),
1356       "public sale has not begun yet"
1357     );
1358     require(totalSupply() + quantity <= collectionSize, "reached max supply");
1359     require(
1360       numberMinted(msg.sender) + quantity <= maxPerAddressDuringMint,
1361       "can not mint this many"
1362     );
1363     _safeMint(msg.sender, quantity);
1364     refundIfOver(publicPrice * quantity);
1365   }
1366 
1367   function refundIfOver(uint256 price) private {
1368     require(msg.value >= price, "Need to send more ETH.");
1369     if (msg.value > price) {
1370       payable(msg.sender).transfer(msg.value - price);
1371     }
1372   }
1373 
1374   function isPublicSaleOn(
1375     uint256 publicPriceWei
1376   ) public view returns (bool) {
1377     return
1378       publicPriceWei != 0 ;
1379   }
1380 
1381 
1382   function seedAllowlist(address[] memory addresses, uint256[] memory numSlots)
1383     external
1384     onlyOwner
1385   {
1386     require(
1387       addresses.length == numSlots.length,
1388       "addresses does not match numSlots length"
1389     );
1390     for (uint256 i = 0; i < addresses.length; i++) {
1391       allowlist[addresses[i]] = numSlots[i];
1392     }
1393   }
1394 
1395   // For marketing etc.
1396   function devMint(uint256 quantity) external onlyOwner {
1397     require(
1398       totalSupply() + quantity <= amountForDevs,
1399       "too many already minted before dev mint"
1400     );
1401     require(
1402       quantity % maxBatchSize == 0,
1403       "can only mint a multiple of the maxBatchSize"
1404     );
1405     uint256 numChunks = quantity / maxBatchSize;
1406     for (uint256 i = 0; i < numChunks; i++) {
1407       _safeMint(msg.sender, maxBatchSize);
1408     }
1409   }
1410 
1411   // // metadata URI
1412   string private _baseTokenURI;
1413 
1414   function _baseURI() internal view virtual override returns (string memory) {
1415     return _baseTokenURI;
1416   }
1417 
1418   function setBaseURI(string calldata baseURI) external onlyOwner {
1419     _baseTokenURI = baseURI;
1420   }
1421 
1422   function withdrawMoney() external onlyOwner nonReentrant {
1423     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1424     require(success, "Transfer failed.");
1425   }
1426 
1427   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1428     _setOwnersExplicit(quantity);
1429   }
1430 
1431   function numberMinted(address owner) public view returns (uint256) {
1432     return _numberMinted(owner);
1433   }
1434 
1435   function getOwnershipData(uint256 tokenId)
1436     external
1437     view
1438     returns (TokenOwnership memory)
1439   {
1440     return ownershipOf(tokenId);
1441   }
1442 
1443   function setListPrice(uint256 newPrice) public onlyOwner {
1444       listPrice = newPrice;
1445   }
1446 
1447   function setMintPrice(uint256 newPrice) public onlyOwner {
1448       mintPrice = newPrice;
1449   }
1450 }