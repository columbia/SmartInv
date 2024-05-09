1 // SPDX-License-Identifier: MIT
2 // File: contracts/TankDoodles.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Required interface of an ERC721 compliant contract.
36  */
37 interface IERC721 is IERC165 {
38     /**
39      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
40      */
41     event Transfer(
42         address indexed from,
43         address indexed to,
44         uint256 indexed tokenId
45     );
46 
47     /**
48      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
49      */
50     event Approval(
51         address indexed owner,
52         address indexed approved,
53         uint256 indexed tokenId
54     );
55 
56     /**
57      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
58      */
59     event ApprovalForAll(
60         address indexed owner,
61         address indexed operator,
62         bool approved
63     );
64 
65     /**
66      * @dev Returns the number of tokens in ``owner``'s account.
67      */
68     function balanceOf(address owner) external view returns (uint256 balance);
69 
70     /**
71      * @dev Returns the owner of the `tokenId` token.
72      *
73      * Requirements:
74      *
75      * - `tokenId` must exist.
76      */
77     function ownerOf(uint256 tokenId) external view returns (address owner);
78 
79     /**
80      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
81      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
82      *
83      * Requirements:
84      *
85      * - `from` cannot be the zero address.
86      * - `to` cannot be the zero address.
87      * - `tokenId` token must exist and be owned by `from`.
88      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
89      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
90      *
91      * Emits a {Transfer} event.
92      */
93     function safeTransferFrom(
94         address from,
95         address to,
96         uint256 tokenId
97     ) external;
98 
99     /**
100      * @dev Transfers `tokenId` token from `from` to `to`.
101      *
102      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
103      *
104      * Requirements:
105      *
106      * - `from` cannot be the zero address.
107      * - `to` cannot be the zero address.
108      * - `tokenId` token must be owned by `from`.
109      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
110      *
111      * Emits a {Transfer} event.
112      */
113     function transferFrom(
114         address from,
115         address to,
116         uint256 tokenId
117     ) external;
118 
119     /**
120      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
121      * The approval is cleared when the token is transferred.
122      *
123      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
124      *
125      * Requirements:
126      *
127      * - The caller must own the token or be an approved operator.
128      * - `tokenId` must exist.
129      *
130      * Emits an {Approval} event.
131      */
132     function approve(address to, uint256 tokenId) external;
133 
134     /**
135      * @dev Returns the account approved for `tokenId` token.
136      *
137      * Requirements:
138      *
139      * - `tokenId` must exist.
140      */
141     function getApproved(uint256 tokenId)
142         external
143         view
144         returns (address operator);
145 
146     /**
147      * @dev Approve or remove `operator` as an operator for the caller.
148      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
149      *
150      * Requirements:
151      *
152      * - The `operator` cannot be the caller.
153      *
154      * Emits an {ApprovalForAll} event.
155      */
156     function setApprovalForAll(address operator, bool _approved) external;
157 
158     /**
159      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
160      *
161      * See {setApprovalForAll}
162      */
163     function isApprovedForAll(address owner, address operator)
164         external
165         view
166         returns (bool);
167 
168     /**
169      * @dev Safely transfers `tokenId` token from `from` to `to`.
170      *
171      * Requirements:
172      *
173      * - `from` cannot be the zero address.
174      * - `to` cannot be the zero address.
175      * - `tokenId` token must exist and be owned by `from`.
176      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
177      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
178      *
179      * Emits a {Transfer} event.
180      */
181     function safeTransferFrom(
182         address from,
183         address to,
184         uint256 tokenId,
185         bytes calldata data
186     ) external;
187 }
188 
189 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
190 
191 pragma solidity ^0.8.0;
192 
193 /**
194  * @title ERC721 token receiver interface
195  * @dev Interface for any contract that wants to support safeTransfers
196  * from ERC721 asset contracts.
197  */
198 interface IERC721Receiver {
199     /**
200      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
201      * by `operator` from `from`, this function is called.
202      *
203      * It must return its Solidity selector to confirm the token transfer.
204      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
205      *
206      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
207      */
208     function onERC721Received(
209         address operator,
210         address from,
211         uint256 tokenId,
212         bytes calldata data
213     ) external returns (bytes4);
214 }
215 
216 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
217 
218 pragma solidity ^0.8.0;
219 
220 /**
221  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
222  * @dev See https://eips.ethereum.org/EIPS/eip-721
223  */
224 interface IERC721Metadata is IERC721 {
225     /**
226      * @dev Returns the token collection name.
227      */
228     function name() external view returns (string memory);
229 
230     /**
231      * @dev Returns the token collection symbol.
232      */
233     function symbol() external view returns (string memory);
234 
235     /**
236      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
237      */
238     function tokenURI(uint256 tokenId) external view returns (string memory);
239 }
240 
241 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
242 
243 pragma solidity ^0.8.0;
244 
245 /**
246  * @dev Implementation of the {IERC165} interface.
247  *
248  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
249  * for the additional interface id that will be supported. For example:
250  *
251  * ```solidity
252  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
253  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
254  * }
255  * ```
256  *
257  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
258  */
259 abstract contract ERC165 is IERC165 {
260     /**
261      * @dev See {IERC165-supportsInterface}.
262      */
263     function supportsInterface(bytes4 interfaceId)
264         public
265         view
266         virtual
267         override
268         returns (bool)
269     {
270         return interfaceId == type(IERC165).interfaceId;
271     }
272 }
273 
274 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
275 
276 pragma solidity ^0.8.0;
277 
278 /**
279  * @dev Collection of functions related to the address type
280  */
281 library Address {
282     /**
283      * @dev Returns true if `account` is a contract.
284      *
285      * [IMPORTANT]
286      * ====
287      * It is unsafe to assume that an address for which this function returns
288      * false is an externally-owned account (EOA) and not a contract.
289      *
290      * Among others, `isContract` will return false for the following
291      * types of addresses:
292      *
293      *  - an externally-owned account
294      *  - a contract in construction
295      *  - an address where a contract will be created
296      *  - an address where a contract lived, but was destroyed
297      * ====
298      */
299     function isContract(address account) internal view returns (bool) {
300         // This method relies on extcodesize, which returns 0 for contracts in
301         // construction, since the code is only stored at the end of the
302         // constructor execution.
303 
304         uint256 size;
305         assembly {
306             size := extcodesize(account)
307         }
308         return size > 0;
309     }
310 
311     /**
312      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
313      * `recipient`, forwarding all available gas and reverting on errors.
314      *
315      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
316      * of certain opcodes, possibly making contracts go over the 2300 gas limit
317      * imposed by `transfer`, making them unable to receive funds via
318      * `transfer`. {sendValue} removes this limitation.
319      *
320      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
321      *
322      * IMPORTANT: because control is transferred to `recipient`, care must be
323      * taken to not create reentrancy vulnerabilities. Consider using
324      * {ReentrancyGuard} or the
325      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
326      */
327     function sendValue(address payable recipient, uint256 amount) internal {
328         require(
329             address(this).balance >= amount,
330             "Address: insufficient balance"
331         );
332 
333         (bool success, ) = recipient.call{value: amount}("");
334         require(
335             success,
336             "Address: unable to send value, recipient may have reverted"
337         );
338     }
339 
340     /**
341      * @dev Performs a Solidity function call using a low level `call`. A
342      * plain `call` is an unsafe replacement for a function call: use this
343      * function instead.
344      *
345      * If `target` reverts with a revert reason, it is bubbled up by this
346      * function (like regular Solidity function calls).
347      *
348      * Returns the raw returned data. To convert to the expected return value,
349      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
350      *
351      * Requirements:
352      *
353      * - `target` must be a contract.
354      * - calling `target` with `data` must not revert.
355      *
356      * _Available since v3.1._
357      */
358     function functionCall(address target, bytes memory data)
359         internal
360         returns (bytes memory)
361     {
362         return functionCall(target, data, "Address: low-level call failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
367      * `errorMessage` as a fallback revert reason when `target` reverts.
368      *
369      * _Available since v3.1._
370      */
371     function functionCall(
372         address target,
373         bytes memory data,
374         string memory errorMessage
375     ) internal returns (bytes memory) {
376         return functionCallWithValue(target, data, 0, errorMessage);
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
381      * but also transferring `value` wei to `target`.
382      *
383      * Requirements:
384      *
385      * - the calling contract must have an ETH balance of at least `value`.
386      * - the called Solidity function must be `payable`.
387      *
388      * _Available since v3.1._
389      */
390     function functionCallWithValue(
391         address target,
392         bytes memory data,
393         uint256 value
394     ) internal returns (bytes memory) {
395         return
396             functionCallWithValue(
397                 target,
398                 data,
399                 value,
400                 "Address: low-level call with value failed"
401             );
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
406      * with `errorMessage` as a fallback revert reason when `target` reverts.
407      *
408      * _Available since v3.1._
409      */
410     function functionCallWithValue(
411         address target,
412         bytes memory data,
413         uint256 value,
414         string memory errorMessage
415     ) internal returns (bytes memory) {
416         require(
417             address(this).balance >= value,
418             "Address: insufficient balance for call"
419         );
420         require(isContract(target), "Address: call to non-contract");
421 
422         (bool success, bytes memory returndata) = target.call{value: value}(
423             data
424         );
425         return verifyCallResult(success, returndata, errorMessage);
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
430      * but performing a static call.
431      *
432      * _Available since v3.3._
433      */
434     function functionStaticCall(address target, bytes memory data)
435         internal
436         view
437         returns (bytes memory)
438     {
439         return
440             functionStaticCall(
441                 target,
442                 data,
443                 "Address: low-level static call failed"
444             );
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
449      * but performing a static call.
450      *
451      * _Available since v3.3._
452      */
453     function functionStaticCall(
454         address target,
455         bytes memory data,
456         string memory errorMessage
457     ) internal view returns (bytes memory) {
458         require(isContract(target), "Address: static call to non-contract");
459 
460         (bool success, bytes memory returndata) = target.staticcall(data);
461         return verifyCallResult(success, returndata, errorMessage);
462     }
463 
464     /**
465      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
466      * but performing a delegate call.
467      *
468      * _Available since v3.4._
469      */
470     function functionDelegateCall(address target, bytes memory data)
471         internal
472         returns (bytes memory)
473     {
474         return
475             functionDelegateCall(
476                 target,
477                 data,
478                 "Address: low-level delegate call failed"
479             );
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
484      * but performing a delegate call.
485      *
486      * _Available since v3.4._
487      */
488     function functionDelegateCall(
489         address target,
490         bytes memory data,
491         string memory errorMessage
492     ) internal returns (bytes memory) {
493         require(isContract(target), "Address: delegate call to non-contract");
494 
495         (bool success, bytes memory returndata) = target.delegatecall(data);
496         return verifyCallResult(success, returndata, errorMessage);
497     }
498 
499     /**
500      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
501      * revert reason using the provided one.
502      *
503      * _Available since v4.3._
504      */
505     function verifyCallResult(
506         bool success,
507         bytes memory returndata,
508         string memory errorMessage
509     ) internal pure returns (bytes memory) {
510         if (success) {
511             return returndata;
512         } else {
513             // Look for revert reason and bubble it up if present
514             if (returndata.length > 0) {
515                 // The easiest way to bubble the revert reason is using memory via assembly
516 
517                 assembly {
518                     let returndata_size := mload(returndata)
519                     revert(add(32, returndata), returndata_size)
520                 }
521             } else {
522                 revert(errorMessage);
523             }
524         }
525     }
526 }
527 
528 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
529 
530 pragma solidity ^0.8.0;
531 
532 /**
533  * @dev Provides information about the current execution context, including the
534  * sender of the transaction and its data. While these are generally available
535  * via msg.sender and msg.data, they should not be accessed in such a direct
536  * manner, since when dealing with meta-transactions the account sending and
537  * paying for execution may not be the actual sender (as far as an application
538  * is concerned).
539  *
540  * This contract is only required for intermediate, library-like contracts.
541  */
542 abstract contract Context {
543     function _msgSender() internal view virtual returns (address) {
544         return msg.sender;
545     }
546 
547     function _msgData() internal view virtual returns (bytes calldata) {
548         return msg.data;
549     }
550 }
551 
552 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
553 
554 pragma solidity ^0.8.0;
555 
556 /**
557  * @dev String operations.
558  */
559 library Strings {
560     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
561 
562     /**
563      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
564      */
565     function toString(uint256 value) internal pure returns (string memory) {
566         // Inspired by OraclizeAPI's implementation - MIT licence
567         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
568 
569         if (value == 0) {
570             return "0";
571         }
572         uint256 temp = value;
573         uint256 digits;
574         while (temp != 0) {
575             digits++;
576             temp /= 10;
577         }
578         bytes memory buffer = new bytes(digits);
579         while (value != 0) {
580             digits -= 1;
581             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
582             value /= 10;
583         }
584         return string(buffer);
585     }
586 
587     /**
588      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
589      */
590     function toHexString(uint256 value) internal pure returns (string memory) {
591         if (value == 0) {
592             return "0x00";
593         }
594         uint256 temp = value;
595         uint256 length = 0;
596         while (temp != 0) {
597             length++;
598             temp >>= 8;
599         }
600         return toHexString(value, length);
601     }
602 
603     /**
604      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
605      */
606     function toHexString(uint256 value, uint256 length)
607         internal
608         pure
609         returns (string memory)
610     {
611         bytes memory buffer = new bytes(2 * length + 2);
612         buffer[0] = "0";
613         buffer[1] = "x";
614         for (uint256 i = 2 * length + 1; i > 1; --i) {
615             buffer[i] = _HEX_SYMBOLS[value & 0xf];
616             value >>= 4;
617         }
618         require(value == 0, "Strings: hex length insufficient");
619         return string(buffer);
620     }
621 }
622 
623 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
624 
625 pragma solidity ^0.8.0;
626 
627 /**
628  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
629  * @dev See https://eips.ethereum.org/EIPS/eip-721
630  */
631 interface IERC721Enumerable is IERC721 {
632     /**
633      * @dev Returns the total amount of tokens stored by the contract.
634      */
635     function totalSupply() external view returns (uint256);
636 
637     /**
638      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
639      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
640      */
641     function tokenOfOwnerByIndex(address owner, uint256 index)
642         external
643         view
644         returns (uint256 tokenId);
645 
646     /**
647      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
648      * Use along with {totalSupply} to enumerate all tokens.
649      */
650     function tokenByIndex(uint256 index) external view returns (uint256);
651 }
652 
653 pragma solidity ^0.8.0;
654 
655 /**
656  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
657  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
658  *
659  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
660  *
661  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
662  *
663  * Does not support burning tokens to address(0).
664  */
665 contract ERC721A is
666   Context,
667   ERC165,
668   IERC721,
669   IERC721Metadata,
670   IERC721Enumerable
671 {
672   using Address for address;
673   using Strings for uint256;
674 
675   struct TokenOwnership {
676     address addr;
677     uint64 startTimestamp;
678   }
679 
680   struct AddressData {
681     uint128 balance;
682     uint128 numberMinted;
683   }
684 
685   uint256 private currentIndex = 0;
686 
687   uint256 internal immutable collectionSize;
688   uint256 internal immutable maxBatchSize;
689 
690   // Token name
691   string private _name;
692 
693   // Token symbol
694   string private _symbol;
695 
696   // Mapping from token ID to ownership details
697   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
698   mapping(uint256 => TokenOwnership) private _ownerships;
699 
700   // Mapping owner address to address data
701   mapping(address => AddressData) private _addressData;
702 
703   // Mapping from token ID to approved address
704   mapping(uint256 => address) private _tokenApprovals;
705 
706   // Mapping from owner to operator approvals
707   mapping(address => mapping(address => bool)) private _operatorApprovals;
708 
709   /**
710    * @dev
711    * `maxBatchSize` refers to how much a minter can mint at a time.
712    * `collectionSize_` refers to how many tokens are in the collection.
713    */
714   constructor(
715     string memory name_,
716     string memory symbol_,
717     uint256 maxBatchSize_,
718     uint256 collectionSize_
719   ) {
720     require(
721       collectionSize_ > 0,
722       "ERC721A: collection must have a nonzero supply"
723     );
724     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
725     _name = name_;
726     _symbol = symbol_;
727     maxBatchSize = maxBatchSize_;
728     collectionSize = collectionSize_;
729   }
730 
731   /**
732    * @dev See {IERC721Enumerable-totalSupply}.
733    */
734   function totalSupply() public view override returns (uint256) {
735     return currentIndex;
736   }
737 
738   /**
739    * @dev See {IERC721Enumerable-tokenByIndex}.
740    */
741   function tokenByIndex(uint256 index) public view override returns (uint256) {
742     require(index < totalSupply(), "ERC721A: global index out of bounds");
743     return index;
744   }
745 
746   /**
747    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
748    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
749    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
750    */
751   function tokenOfOwnerByIndex(address owner, uint256 index)
752     public
753     view
754     override
755     returns (uint256)
756   {
757     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
758     uint256 numMintedSoFar = totalSupply();
759     uint256 tokenIdsIdx = 0;
760     address currOwnershipAddr = address(0);
761     for (uint256 i = 0; i < numMintedSoFar; i++) {
762       TokenOwnership memory ownership = _ownerships[i];
763       if (ownership.addr != address(0)) {
764         currOwnershipAddr = ownership.addr;
765       }
766       if (currOwnershipAddr == owner) {
767         if (tokenIdsIdx == index) {
768           return i;
769         }
770         tokenIdsIdx++;
771       }
772     }
773     revert("ERC721A: unable to get token of owner by index");
774   }
775 
776   /**
777    * @dev See {IERC165-supportsInterface}.
778    */
779   function supportsInterface(bytes4 interfaceId)
780     public
781     view
782     virtual
783     override(ERC165, IERC165)
784     returns (bool)
785   {
786     return
787       interfaceId == type(IERC721).interfaceId ||
788       interfaceId == type(IERC721Metadata).interfaceId ||
789       interfaceId == type(IERC721Enumerable).interfaceId ||
790       super.supportsInterface(interfaceId);
791   }
792 
793   /**
794    * @dev See {IERC721-balanceOf}.
795    */
796   function balanceOf(address owner) public view override returns (uint256) {
797     require(owner != address(0), "ERC721A: balance query for the zero address");
798     return uint256(_addressData[owner].balance);
799   }
800 
801   function _numberMinted(address owner) internal view returns (uint256) {
802     require(
803       owner != address(0),
804       "ERC721A: number minted query for the zero address"
805     );
806     return uint256(_addressData[owner].numberMinted);
807   }
808 
809   function ownershipOf(uint256 tokenId)
810     internal
811     view
812     returns (TokenOwnership memory)
813   {
814     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
815 
816     uint256 lowestTokenToCheck;
817     if (tokenId >= maxBatchSize) {
818       lowestTokenToCheck = tokenId - maxBatchSize + 1;
819     }
820 
821     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
822       TokenOwnership memory ownership = _ownerships[curr];
823       if (ownership.addr != address(0)) {
824         return ownership;
825       }
826     }
827 
828     revert("ERC721A: unable to determine the owner of token");
829   }
830 
831   /**
832    * @dev See {IERC721-ownerOf}.
833    */
834   function ownerOf(uint256 tokenId) public view override returns (address) {
835     return ownershipOf(tokenId).addr;
836   }
837 
838   /**
839    * @dev See {IERC721Metadata-name}.
840    */
841   function name() public view virtual override returns (string memory) {
842     return _name;
843   }
844 
845   /**
846    * @dev See {IERC721Metadata-symbol}.
847    */
848   function symbol() public view virtual override returns (string memory) {
849     return _symbol;
850   }
851 
852   /**
853    * @dev See {IERC721Metadata-tokenURI}.
854    */
855   function tokenURI(uint256 tokenId)
856     public
857     view
858     virtual
859     override
860     returns (string memory)
861   {
862     require(
863       _exists(tokenId),
864       "ERC721Metadata: URI query for nonexistent token"
865     );
866 
867     string memory baseURI = _baseURI();
868     return
869       bytes(baseURI).length > 0
870         ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
871         : "";
872   }
873 
874   /**
875    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
876    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
877    * by default, can be overriden in child contracts.
878    */
879   function _baseURI() internal view virtual returns (string memory) {
880     return "";
881   }
882 
883   /**
884    * @dev See {IERC721-approve}.
885    */
886   function approve(address to, uint256 tokenId) public override {
887     address owner = ERC721A.ownerOf(tokenId);
888     require(to != owner, "ERC721A: approval to current owner");
889 
890     require(
891       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
892       "ERC721A: approve caller is not owner nor approved for all"
893     );
894 
895     _approve(to, tokenId, owner);
896   }
897 
898   /**
899    * @dev See {IERC721-getApproved}.
900    */
901   function getApproved(uint256 tokenId) public view override returns (address) {
902     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
903 
904     return _tokenApprovals[tokenId];
905   }
906 
907   /**
908    * @dev See {IERC721-setApprovalForAll}.
909    */
910   function setApprovalForAll(address operator, bool approved) public override {
911     require(operator != _msgSender(), "ERC721A: approve to caller");
912 
913     _operatorApprovals[_msgSender()][operator] = approved;
914     emit ApprovalForAll(_msgSender(), operator, approved);
915   }
916 
917   /**
918    * @dev See {IERC721-isApprovedForAll}.
919    */
920   function isApprovedForAll(address owner, address operator)
921     public
922     view
923     virtual
924     override
925     returns (bool)
926   {
927     return _operatorApprovals[owner][operator];
928   }
929 
930   /**
931    * @dev See {IERC721-transferFrom}.
932    */
933   function transferFrom(
934     address from,
935     address to,
936     uint256 tokenId
937   ) public override {
938     _transfer(from, to, tokenId);
939   }
940 
941   /**
942    * @dev See {IERC721-safeTransferFrom}.
943    */
944   function safeTransferFrom(
945     address from,
946     address to,
947     uint256 tokenId
948   ) public override {
949     safeTransferFrom(from, to, tokenId, "");
950   }
951 
952   /**
953    * @dev See {IERC721-safeTransferFrom}.
954    */
955   function safeTransferFrom(
956     address from,
957     address to,
958     uint256 tokenId,
959     bytes memory _data
960   ) public override {
961     _transfer(from, to, tokenId);
962     require(
963       _checkOnERC721Received(from, to, tokenId, _data),
964       "ERC721A: transfer to non ERC721Receiver implementer"
965     );
966   }
967 
968   /**
969    * @dev Returns whether `tokenId` exists.
970    *
971    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
972    *
973    * Tokens start existing when they are minted (`_mint`),
974    */
975   function _exists(uint256 tokenId) internal view returns (bool) {
976     return tokenId < currentIndex;
977   }
978 
979   function _safeMint(address to, uint256 quantity) internal {
980     _safeMint(to, quantity, "");
981   }
982 
983   /**
984    * @dev Mints `quantity` tokens and transfers them to `to`.
985    *
986    * Requirements:
987    *
988    * - there must be `quantity` tokens remaining unminted in the total collection.
989    * - `to` cannot be the zero address.
990    * - `quantity` cannot be larger than the max batch size.
991    *
992    * Emits a {Transfer} event.
993    */
994   function _safeMint(
995     address to,
996     uint256 quantity,
997     bytes memory _data
998   ) internal {
999     uint256 startTokenId = currentIndex;
1000     require(to != address(0), "ERC721A: mint to the zero address");
1001     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1002     require(!_exists(startTokenId), "ERC721A: token already minted");
1003     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1004 
1005     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1006 
1007     AddressData memory addressData = _addressData[to];
1008     _addressData[to] = AddressData(
1009       addressData.balance + uint128(quantity),
1010       addressData.numberMinted + uint128(quantity)
1011     );
1012     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1013 
1014     uint256 updatedIndex = startTokenId;
1015 
1016     for (uint256 i = 0; i < quantity; i++) {
1017       emit Transfer(address(0), to, updatedIndex);
1018       require(
1019         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1020         "ERC721A: transfer to non ERC721Receiver implementer"
1021       );
1022       updatedIndex++;
1023     }
1024 
1025     currentIndex = updatedIndex;
1026     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1027   }
1028 
1029   /**
1030    * @dev Transfers `tokenId` from `from` to `to`.
1031    *
1032    * Requirements:
1033    *
1034    * - `to` cannot be the zero address.
1035    * - `tokenId` token must be owned by `from`.
1036    *
1037    * Emits a {Transfer} event.
1038    */
1039   function _transfer(
1040     address from,
1041     address to,
1042     uint256 tokenId
1043   ) private {
1044     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1045 
1046     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1047       getApproved(tokenId) == _msgSender() ||
1048       isApprovedForAll(prevOwnership.addr, _msgSender()));
1049 
1050     require(
1051       isApprovedOrOwner,
1052       "ERC721A: transfer caller is not owner nor approved"
1053     );
1054 
1055     require(
1056       prevOwnership.addr == from,
1057       "ERC721A: transfer from incorrect owner"
1058     );
1059     require(to != address(0), "ERC721A: transfer to the zero address");
1060 
1061     _beforeTokenTransfers(from, to, tokenId, 1);
1062 
1063     // Clear approvals from the previous owner
1064     _approve(address(0), tokenId, prevOwnership.addr);
1065 
1066     _addressData[from].balance -= 1;
1067     _addressData[to].balance += 1;
1068     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1069 
1070     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1071     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1072     uint256 nextTokenId = tokenId + 1;
1073     if (_ownerships[nextTokenId].addr == address(0)) {
1074       if (_exists(nextTokenId)) {
1075         _ownerships[nextTokenId] = TokenOwnership(
1076           prevOwnership.addr,
1077           prevOwnership.startTimestamp
1078         );
1079       }
1080     }
1081 
1082     emit Transfer(from, to, tokenId);
1083     _afterTokenTransfers(from, to, tokenId, 1);
1084   }
1085 
1086   /**
1087    * @dev Approve `to` to operate on `tokenId`
1088    *
1089    * Emits a {Approval} event.
1090    */
1091   function _approve(
1092     address to,
1093     uint256 tokenId,
1094     address owner
1095   ) private {
1096     _tokenApprovals[tokenId] = to;
1097     emit Approval(owner, to, tokenId);
1098   }
1099 
1100   uint256 public nextOwnerToExplicitlySet = 0;
1101 
1102   /**
1103    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1104    */
1105   function _setOwnersExplicit(uint256 quantity) internal {
1106     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1107     require(quantity > 0, "quantity must be nonzero");
1108     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1109     if (endIndex > collectionSize - 1) {
1110       endIndex = collectionSize - 1;
1111     }
1112     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1113     require(_exists(endIndex), "not enough minted yet for this cleanup");
1114     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1115       if (_ownerships[i].addr == address(0)) {
1116         TokenOwnership memory ownership = ownershipOf(i);
1117         _ownerships[i] = TokenOwnership(
1118           ownership.addr,
1119           ownership.startTimestamp
1120         );
1121       }
1122     }
1123     nextOwnerToExplicitlySet = endIndex + 1;
1124   }
1125 
1126   /**
1127    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1128    * The call is not executed if the target address is not a contract.
1129    *
1130    * @param from address representing the previous owner of the given token ID
1131    * @param to target address that will receive the tokens
1132    * @param tokenId uint256 ID of the token to be transferred
1133    * @param _data bytes optional data to send along with the call
1134    * @return bool whether the call correctly returned the expected magic value
1135    */
1136   function _checkOnERC721Received(
1137     address from,
1138     address to,
1139     uint256 tokenId,
1140     bytes memory _data
1141   ) private returns (bool) {
1142     if (to.isContract()) {
1143       try
1144         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1145       returns (bytes4 retval) {
1146         return retval == IERC721Receiver(to).onERC721Received.selector;
1147       } catch (bytes memory reason) {
1148         if (reason.length == 0) {
1149           revert("ERC721A: transfer to non ERC721Receiver implementer");
1150         } else {
1151           assembly {
1152             revert(add(32, reason), mload(reason))
1153           }
1154         }
1155       }
1156     } else {
1157       return true;
1158     }
1159   }
1160 
1161   /**
1162    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1163    *
1164    * startTokenId - the first token id to be transferred
1165    * quantity - the amount to be transferred
1166    *
1167    * Calling conditions:
1168    *
1169    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1170    * transferred to `to`.
1171    * - When `from` is zero, `tokenId` will be minted for `to`.
1172    */
1173   function _beforeTokenTransfers(
1174     address from,
1175     address to,
1176     uint256 startTokenId,
1177     uint256 quantity
1178   ) internal virtual {}
1179 
1180   /**
1181    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1182    * minting.
1183    *
1184    * startTokenId - the first token id to be transferred
1185    * quantity - the amount to be transferred
1186    *
1187    * Calling conditions:
1188    *
1189    * - when `from` and `to` are both non-zero.
1190    * - `from` and `to` are never both zero.
1191    */
1192   function _afterTokenTransfers(
1193     address from,
1194     address to,
1195     uint256 startTokenId,
1196     uint256 quantity
1197   ) internal virtual {}
1198 }
1199 
1200 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1201 
1202 pragma solidity ^0.8.0;
1203 
1204 /**
1205  * @dev Contract module which provides a basic access control mechanism, where
1206  * there is an account (an owner) that can be granted exclusive access to
1207  * specific functions.
1208  *
1209  * By default, the owner account will be the one that deploys the contract. This
1210  * can later be changed with {transferOwnership}.
1211  *
1212  * This module is used through inheritance. It will make available the modifier
1213  * `onlyOwner`, which can be applied to your functions to restrict their use to
1214  * the owner.
1215  */
1216 abstract contract Ownable is Context {
1217     address private _owner;
1218 
1219     event OwnershipTransferred(
1220         address indexed previousOwner,
1221         address indexed newOwner
1222     );
1223 
1224     /**
1225      * @dev Initializes the contract setting the deployer as the initial owner.
1226      */
1227     constructor() {
1228         _transferOwnership(_msgSender());
1229     }
1230 
1231     /**
1232      * @dev Returns the address of the current owner.
1233      */
1234     function owner() public view virtual returns (address) {
1235         return _owner;
1236     }
1237 
1238     /**
1239      * @dev Throws if called by any account other than the owner.
1240      */
1241     modifier onlyOwner() {
1242         require(owner() == _msgSender(), "You are not the owner");
1243         _;
1244     }
1245 
1246     /**
1247      * @dev Leaves the contract without owner. It will not be possible to call
1248      * `onlyOwner` functions anymore. Can only be called by the current owner.
1249      *
1250      * NOTE: Renouncing ownership will leave the contract without an owner,
1251      * thereby removing any functionality that is only available to the owner.
1252      */
1253     function renounceOwnership() public virtual onlyOwner {
1254         _transferOwnership(address(0));
1255     }
1256 
1257     /**
1258      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1259      * Can only be called by the current owner.
1260      */
1261     function transferOwnership(address newOwner) public virtual onlyOwner {
1262         require(
1263             newOwner != address(0),
1264             "Ownable: new owner is the zero address"
1265         );
1266         _transferOwnership(newOwner);
1267     }
1268 
1269     /**
1270      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1271      * Internal function without access restriction.
1272      */
1273     function _transferOwnership(address newOwner) internal virtual {
1274         address oldOwner = _owner;
1275         _owner = newOwner;
1276         emit OwnershipTransferred(oldOwner, newOwner);
1277     }
1278 }
1279 
1280 
1281 pragma solidity ^0.8.0;
1282 
1283 contract TankDoodles is ERC721A, Ownable {
1284     uint256 public NFT_PRICE = 0 ether;
1285     uint256 public MAX_SUPPLY = 500;
1286     uint256 public MAX_MINTS = 10;
1287     string public baseURI = "ipfs://QmSGvAxt6sjNPDKtWy31NVF72rrs4kfA69NAtUYKnSEvbk/";
1288     string public baseExtension = ".json";
1289      bool public paused = false;
1290     
1291     constructor() ERC721A("Tank Doodles", "TNKD", MAX_MINTS, MAX_SUPPLY) {  
1292     }
1293     
1294 
1295     function Mint(uint256 numTokens) public payable {
1296         require(!paused, "Paused");
1297         require(numTokens > 0 && numTokens <= MAX_MINTS);
1298         require(totalSupply() + numTokens <= MAX_SUPPLY);
1299         require(MAX_MINTS >= numTokens, "Excess max per paid tx");
1300         require(msg.value >= numTokens * NFT_PRICE, "Invalid funds provided");
1301         _safeMint(msg.sender, numTokens);
1302     }
1303 
1304     function DevsMint(uint256 numTokens) public payable onlyOwner {
1305         _safeMint(msg.sender, numTokens);
1306     }
1307 
1308 
1309     function pause(bool _state) public onlyOwner {
1310         paused = _state;
1311     }
1312 
1313     function setBaseURI(string memory newBaseURI) public onlyOwner {
1314         baseURI = newBaseURI;
1315     }
1316     function tokenURI(uint256 _tokenId)
1317         public
1318         view
1319         override
1320         returns (string memory)
1321     {
1322         require(_exists(_tokenId), "That token doesn't exist");
1323         return
1324             bytes(baseURI).length > 0
1325                 ? string(
1326                     abi.encodePacked(
1327                         baseURI,
1328                         Strings.toString(_tokenId),
1329                         baseExtension
1330                     )
1331                 )
1332                 : "";
1333     }
1334 
1335     function setPrice(uint256 newPrice) public onlyOwner {
1336         NFT_PRICE = newPrice;
1337     }
1338 
1339     function setMaxMints(uint256 newMax) public onlyOwner {
1340         MAX_MINTS = newMax;
1341     }
1342 
1343     function _baseURI() internal view virtual override returns (string memory) {
1344         return baseURI;
1345     }
1346 
1347     function withdrawMoney() external onlyOwner {
1348       (bool success, ) = msg.sender.call{value: address(this).balance}("");
1349       require(success, "WITHDRAW FAILED!");
1350     }
1351 }