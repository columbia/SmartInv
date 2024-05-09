1 // SPDX-License-Identifier: MIT
2 // File: contracts/MadSails.sol
3 
4 
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
30 
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @dev Required interface of an ERC721 compliant contract.
35  */
36 interface IERC721 is IERC165 {
37     /**
38      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
39      */
40     event Transfer(
41         address indexed from,
42         address indexed to,
43         uint256 indexed tokenId
44     );
45 
46     /**
47      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
48      */
49     event Approval(
50         address indexed owner,
51         address indexed approved,
52         uint256 indexed tokenId
53     );
54 
55     /**
56      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
57      */
58     event ApprovalForAll(
59         address indexed owner,
60         address indexed operator,
61         bool approved
62     );
63 
64     /**
65      * @dev Returns the number of tokens in ``owner``'s account.
66      */
67     function balanceOf(address owner) external view returns (uint256 balance);
68 
69     /**
70      * @dev Returns the owner of the `tokenId` token.
71      *
72      * Requirements:
73      *
74      * - `tokenId` must exist.
75      */
76     function ownerOf(uint256 tokenId) external view returns (address owner);
77 
78     /**
79      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
80      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
81      *
82      * Requirements:
83      *
84      * - `from` cannot be the zero address.
85      * - `to` cannot be the zero address.
86      * - `tokenId` token must exist and be owned by `from`.
87      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
88      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
89      *
90      * Emits a {Transfer} event.
91      */
92     function safeTransferFrom(
93         address from,
94         address to,
95         uint256 tokenId
96     ) external;
97 
98     /**
99      * @dev Transfers `tokenId` token from `from` to `to`.
100      *
101      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
102      *
103      * Requirements:
104      *
105      * - `from` cannot be the zero address.
106      * - `to` cannot be the zero address.
107      * - `tokenId` token must be owned by `from`.
108      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
109      *
110      * Emits a {Transfer} event.
111      */
112     function transferFrom(
113         address from,
114         address to,
115         uint256 tokenId
116     ) external;
117 
118     /**
119      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
120      * The approval is cleared when the token is transferred.
121      *
122      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
123      *
124      * Requirements:
125      *
126      * - The caller must own the token or be an approved operator.
127      * - `tokenId` must exist.
128      *
129      * Emits an {Approval} event.
130      */
131     function approve(address to, uint256 tokenId) external;
132 
133     /**
134      * @dev Returns the account approved for `tokenId` token.
135      *
136      * Requirements:
137      *
138      * - `tokenId` must exist.
139      */
140     function getApproved(uint256 tokenId)
141         external
142         view
143         returns (address operator);
144 
145     /**
146      * @dev Approve or remove `operator` as an operator for the caller.
147      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
148      *
149      * Requirements:
150      *
151      * - The `operator` cannot be the caller.
152      *
153      * Emits an {ApprovalForAll} event.
154      */
155     function setApprovalForAll(address operator, bool _approved) external;
156 
157     /**
158      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
159      *
160      * See {setApprovalForAll}
161      */
162     function isApprovedForAll(address owner, address operator)
163         external
164         view
165         returns (bool);
166 
167     /**
168      * @dev Safely transfers `tokenId` token from `from` to `to`.
169      *
170      * Requirements:
171      *
172      * - `from` cannot be the zero address.
173      * - `to` cannot be the zero address.
174      * - `tokenId` token must exist and be owned by `from`.
175      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
176      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
177      *
178      * Emits a {Transfer} event.
179      */
180     function safeTransferFrom(
181         address from,
182         address to,
183         uint256 tokenId,
184         bytes calldata data
185     ) external;
186 }
187 
188 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
189 
190 pragma solidity ^0.8.0;
191 
192 /**
193  * @title ERC721 token receiver interface
194  * @dev Interface for any contract that wants to support safeTransfers
195  * from ERC721 asset contracts.
196  */
197 interface IERC721Receiver {
198     /**
199      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
200      * by `operator` from `from`, this function is called.
201      *
202      * It must return its Solidity selector to confirm the token transfer.
203      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
204      *
205      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
206      */
207     function onERC721Received(
208         address operator,
209         address from,
210         uint256 tokenId,
211         bytes calldata data
212     ) external returns (bytes4);
213 }
214 
215 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
216 
217 pragma solidity ^0.8.0;
218 
219 /**
220  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
221  * @dev See https://eips.ethereum.org/EIPS/eip-721
222  */
223 interface IERC721Metadata is IERC721 {
224     /**
225      * @dev Returns the token collection name.
226      */
227     function name() external view returns (string memory);
228 
229     /**
230      * @dev Returns the token collection symbol.
231      */
232     function symbol() external view returns (string memory);
233 
234     /**
235      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
236      */
237     function tokenURI(uint256 tokenId) external view returns (string memory);
238 }
239 
240 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
241 
242 pragma solidity ^0.8.0;
243 
244 /**
245  * @dev Implementation of the {IERC165} interface.
246  *
247  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
248  * for the additional interface id that will be supported. For example:
249  *
250  * ```solidity
251  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
252  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
253  * }
254  * ```
255  *
256  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
257  */
258 abstract contract ERC165 is IERC165 {
259     /**
260      * @dev See {IERC165-supportsInterface}.
261      */
262     function supportsInterface(bytes4 interfaceId)
263         public
264         view
265         virtual
266         override
267         returns (bool)
268     {
269         return interfaceId == type(IERC165).interfaceId;
270     }
271 }
272 
273 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
274 
275 pragma solidity ^0.8.0;
276 
277 /**
278  * @dev Collection of functions related to the address type
279  */
280 library Address {
281     /**
282      * @dev Returns true if `account` is a contract.
283      *
284      * [IMPORTANT]
285      * ====
286      * It is unsafe to assume that an address for which this function returns
287      * false is an externally-owned account (EOA) and not a contract.
288      *
289      * Among others, `isContract` will return false for the following
290      * types of addresses:
291      *
292      *  - an externally-owned account
293      *  - a contract in construction
294      *  - an address where a contract will be created
295      *  - an address where a contract lived, but was destroyed
296      * ====
297      */
298     function isContract(address account) internal view returns (bool) {
299         // This method relies on extcodesize, which returns 0 for contracts in
300         // construction, since the code is only stored at the end of the
301         // constructor execution.
302 
303         uint256 size;
304         assembly {
305             size := extcodesize(account)
306         }
307         return size > 0;
308     }
309 
310     /**
311      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
312      * `recipient`, forwarding all available gas and reverting on errors.
313      *
314      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
315      * of certain opcodes, possibly making contracts go over the 2300 gas limit
316      * imposed by `transfer`, making them unable to receive funds via
317      * `transfer`. {sendValue} removes this limitation.
318      *
319      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
320      *
321      * IMPORTANT: because control is transferred to `recipient`, care must be
322      * taken to not create reentrancy vulnerabilities. Consider using
323      * {ReentrancyGuard} or the
324      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
325      */
326     function sendValue(address payable recipient, uint256 amount) internal {
327         require(
328             address(this).balance >= amount,
329             "Address: insufficient balance"
330         );
331 
332         (bool success, ) = recipient.call{value: amount}("");
333         require(
334             success,
335             "Address: unable to send value, recipient may have reverted"
336         );
337     }
338 
339     /**
340      * @dev Performs a Solidity function call using a low level `call`. A
341      * plain `call` is an unsafe replacement for a function call: use this
342      * function instead.
343      *
344      * If `target` reverts with a revert reason, it is bubbled up by this
345      * function (like regular Solidity function calls).
346      *
347      * Returns the raw returned data. To convert to the expected return value,
348      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
349      *
350      * Requirements:
351      *
352      * - `target` must be a contract.
353      * - calling `target` with `data` must not revert.
354      *
355      * _Available since v3.1._
356      */
357     function functionCall(address target, bytes memory data)
358         internal
359         returns (bytes memory)
360     {
361         return functionCall(target, data, "Address: low-level call failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
366      * `errorMessage` as a fallback revert reason when `target` reverts.
367      *
368      * _Available since v3.1._
369      */
370     function functionCall(
371         address target,
372         bytes memory data,
373         string memory errorMessage
374     ) internal returns (bytes memory) {
375         return functionCallWithValue(target, data, 0, errorMessage);
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
380      * but also transferring `value` wei to `target`.
381      *
382      * Requirements:
383      *
384      * - the calling contract must have an ETH balance of at least `value`.
385      * - the called Solidity function must be `payable`.
386      *
387      * _Available since v3.1._
388      */
389     function functionCallWithValue(
390         address target,
391         bytes memory data,
392         uint256 value
393     ) internal returns (bytes memory) {
394         return
395             functionCallWithValue(
396                 target,
397                 data,
398                 value,
399                 "Address: low-level call with value failed"
400             );
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
405      * with `errorMessage` as a fallback revert reason when `target` reverts.
406      *
407      * _Available since v3.1._
408      */
409     function functionCallWithValue(
410         address target,
411         bytes memory data,
412         uint256 value,
413         string memory errorMessage
414     ) internal returns (bytes memory) {
415         require(
416             address(this).balance >= value,
417             "Address: insufficient balance for call"
418         );
419         require(isContract(target), "Address: call to non-contract");
420 
421         (bool success, bytes memory returndata) = target.call{value: value}(
422             data
423         );
424         return verifyCallResult(success, returndata, errorMessage);
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
429      * but performing a static call.
430      *
431      * _Available since v3.3._
432      */
433     function functionStaticCall(address target, bytes memory data)
434         internal
435         view
436         returns (bytes memory)
437     {
438         return
439             functionStaticCall(
440                 target,
441                 data,
442                 "Address: low-level static call failed"
443             );
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
448      * but performing a static call.
449      *
450      * _Available since v3.3._
451      */
452     function functionStaticCall(
453         address target,
454         bytes memory data,
455         string memory errorMessage
456     ) internal view returns (bytes memory) {
457         require(isContract(target), "Address: static call to non-contract");
458 
459         (bool success, bytes memory returndata) = target.staticcall(data);
460         return verifyCallResult(success, returndata, errorMessage);
461     }
462 
463     /**
464      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
465      * but performing a delegate call.
466      *
467      * _Available since v3.4._
468      */
469     function functionDelegateCall(address target, bytes memory data)
470         internal
471         returns (bytes memory)
472     {
473         return
474             functionDelegateCall(
475                 target,
476                 data,
477                 "Address: low-level delegate call failed"
478             );
479     }
480 
481     /**
482      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
483      * but performing a delegate call.
484      *
485      * _Available since v3.4._
486      */
487     function functionDelegateCall(
488         address target,
489         bytes memory data,
490         string memory errorMessage
491     ) internal returns (bytes memory) {
492         require(isContract(target), "Address: delegate call to non-contract");
493 
494         (bool success, bytes memory returndata) = target.delegatecall(data);
495         return verifyCallResult(success, returndata, errorMessage);
496     }
497 
498     /**
499      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
500      * revert reason using the provided one.
501      *
502      * _Available since v4.3._
503      */
504     function verifyCallResult(
505         bool success,
506         bytes memory returndata,
507         string memory errorMessage
508     ) internal pure returns (bytes memory) {
509         if (success) {
510             return returndata;
511         } else {
512             // Look for revert reason and bubble it up if present
513             if (returndata.length > 0) {
514                 // The easiest way to bubble the revert reason is using memory via assembly
515 
516                 assembly {
517                     let returndata_size := mload(returndata)
518                     revert(add(32, returndata), returndata_size)
519                 }
520             } else {
521                 revert(errorMessage);
522             }
523         }
524     }
525 }
526 
527 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
528 
529 pragma solidity ^0.8.0;
530 
531 /**
532  * @dev Provides information about the current execution context, including the
533  * sender of the transaction and its data. While these are generally available
534  * via msg.sender and msg.data, they should not be accessed in such a direct
535  * manner, since when dealing with meta-transactions the account sending and
536  * paying for execution may not be the actual sender (as far as an application
537  * is concerned).
538  *
539  * This contract is only required for intermediate, library-like contracts.
540  */
541 abstract contract Context {
542     function _msgSender() internal view virtual returns (address) {
543         return msg.sender;
544     }
545 
546     function _msgData() internal view virtual returns (bytes calldata) {
547         return msg.data;
548     }
549 }
550 
551 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
552 
553 pragma solidity ^0.8.0;
554 
555 /**
556  * @dev String operations.
557  */
558 library Strings {
559     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
560 
561     /**
562      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
563      */
564     function toString(uint256 value) internal pure returns (string memory) {
565         // Inspired by OraclizeAPI's implementation - MIT licence
566         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
567 
568         if (value == 0) {
569             return "0";
570         }
571         uint256 temp = value;
572         uint256 digits;
573         while (temp != 0) {
574             digits++;
575             temp /= 10;
576         }
577         bytes memory buffer = new bytes(digits);
578         while (value != 0) {
579             digits -= 1;
580             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
581             value /= 10;
582         }
583         return string(buffer);
584     }
585 
586     /**
587      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
588      */
589     function toHexString(uint256 value) internal pure returns (string memory) {
590         if (value == 0) {
591             return "0x00";
592         }
593         uint256 temp = value;
594         uint256 length = 0;
595         while (temp != 0) {
596             length++;
597             temp >>= 8;
598         }
599         return toHexString(value, length);
600     }
601 
602     /**
603      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
604      */
605     function toHexString(uint256 value, uint256 length)
606         internal
607         pure
608         returns (string memory)
609     {
610         bytes memory buffer = new bytes(2 * length + 2);
611         buffer[0] = "0";
612         buffer[1] = "x";
613         for (uint256 i = 2 * length + 1; i > 1; --i) {
614             buffer[i] = _HEX_SYMBOLS[value & 0xf];
615             value >>= 4;
616         }
617         require(value == 0, "Strings: hex length insufficient");
618         return string(buffer);
619     }
620 }
621 
622 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
623 
624 pragma solidity ^0.8.0;
625 
626 /**
627  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
628  * @dev See https://eips.ethereum.org/EIPS/eip-721
629  */
630 interface IERC721Enumerable is IERC721 {
631     /**
632      * @dev Returns the total amount of tokens stored by the contract.
633      */
634     function totalSupply() external view returns (uint256);
635 
636     /**
637      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
638      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
639      */
640     function tokenOfOwnerByIndex(address owner, uint256 index)
641         external
642         view
643         returns (uint256 tokenId);
644 
645     /**
646      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
647      * Use along with {totalSupply} to enumerate all tokens.
648      */
649     function tokenByIndex(uint256 index) external view returns (uint256);
650 }
651 
652 pragma solidity ^0.8.0;
653 
654 /**
655  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
656  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
657  *
658  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
659  *
660  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
661  *
662  * Does not support burning tokens to address(0).
663  */
664 contract ERC721A is
665   Context,
666   ERC165,
667   IERC721,
668   IERC721Metadata,
669   IERC721Enumerable
670 {
671   using Address for address;
672   using Strings for uint256;
673 
674   struct TokenOwnership {
675     address addr;
676     uint64 startTimestamp;
677   }
678 
679   struct AddressData {
680     uint128 balance;
681     uint128 numberMinted;
682   }
683 
684   uint256 private currentIndex = 0;
685 
686   uint256 internal immutable collectionSize;
687   uint256 internal immutable maxBatchSize;
688 
689   // Token name
690   string private _name;
691 
692   // Token symbol
693   string private _symbol;
694 
695   // Mapping from token ID to ownership details
696   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
697   mapping(uint256 => TokenOwnership) private _ownerships;
698 
699   // Mapping owner address to address data
700   mapping(address => AddressData) private _addressData;
701 
702   // Mapping from token ID to approved address
703   mapping(uint256 => address) private _tokenApprovals;
704 
705   // Mapping from owner to operator approvals
706   mapping(address => mapping(address => bool)) private _operatorApprovals;
707 
708   /**
709    * @dev
710    * `maxBatchSize` refers to how much a minter can mint at a time.
711    * `collectionSize_` refers to how many tokens are in the collection.
712    */
713   constructor(
714     string memory name_,
715     string memory symbol_,
716     uint256 maxBatchSize_,
717     uint256 collectionSize_
718   ) {
719     require(
720       collectionSize_ > 0,
721       "ERC721A: collection must have a nonzero supply"
722     );
723     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
724     _name = name_;
725     _symbol = symbol_;
726     maxBatchSize = maxBatchSize_;
727     collectionSize = collectionSize_;
728   }
729 
730   /**
731    * @dev See {IERC721Enumerable-totalSupply}.
732    */
733   function totalSupply() public view override returns (uint256) {
734     return currentIndex;
735   }
736 
737   /**
738    * @dev See {IERC721Enumerable-tokenByIndex}.
739    */
740   function tokenByIndex(uint256 index) public view override returns (uint256) {
741     require(index < totalSupply(), "ERC721A: global index out of bounds");
742     return index;
743   }
744 
745   /**
746    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
747    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
748    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
749    */
750   function tokenOfOwnerByIndex(address owner, uint256 index)
751     public
752     view
753     override
754     returns (uint256)
755   {
756     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
757     uint256 numMintedSoFar = totalSupply();
758     uint256 tokenIdsIdx = 0;
759     address currOwnershipAddr = address(0);
760     for (uint256 i = 0; i < numMintedSoFar; i++) {
761       TokenOwnership memory ownership = _ownerships[i];
762       if (ownership.addr != address(0)) {
763         currOwnershipAddr = ownership.addr;
764       }
765       if (currOwnershipAddr == owner) {
766         if (tokenIdsIdx == index) {
767           return i;
768         }
769         tokenIdsIdx++;
770       }
771     }
772     revert("ERC721A: unable to get token of owner by index");
773   }
774 
775   /**
776    * @dev See {IERC165-supportsInterface}.
777    */
778   function supportsInterface(bytes4 interfaceId)
779     public
780     view
781     virtual
782     override(ERC165, IERC165)
783     returns (bool)
784   {
785     return
786       interfaceId == type(IERC721).interfaceId ||
787       interfaceId == type(IERC721Metadata).interfaceId ||
788       interfaceId == type(IERC721Enumerable).interfaceId ||
789       super.supportsInterface(interfaceId);
790   }
791 
792   /**
793    * @dev See {IERC721-balanceOf}.
794    */
795   function balanceOf(address owner) public view override returns (uint256) {
796     require(owner != address(0), "ERC721A: balance query for the zero address");
797     return uint256(_addressData[owner].balance);
798   }
799 
800   function _numberMinted(address owner) internal view returns (uint256) {
801     require(
802       owner != address(0),
803       "ERC721A: number minted query for the zero address"
804     );
805     return uint256(_addressData[owner].numberMinted);
806   }
807 
808   function ownershipOf(uint256 tokenId)
809     internal
810     view
811     returns (TokenOwnership memory)
812   {
813     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
814 
815     uint256 lowestTokenToCheck;
816     if (tokenId >= maxBatchSize) {
817       lowestTokenToCheck = tokenId - maxBatchSize + 1;
818     }
819 
820     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
821       TokenOwnership memory ownership = _ownerships[curr];
822       if (ownership.addr != address(0)) {
823         return ownership;
824       }
825     }
826 
827     revert("ERC721A: unable to determine the owner of token");
828   }
829 
830   /**
831    * @dev See {IERC721-ownerOf}.
832    */
833   function ownerOf(uint256 tokenId) public view override returns (address) {
834     return ownershipOf(tokenId).addr;
835   }
836 
837   /**
838    * @dev See {IERC721Metadata-name}.
839    */
840   function name() public view virtual override returns (string memory) {
841     return _name;
842   }
843 
844   /**
845    * @dev See {IERC721Metadata-symbol}.
846    */
847   function symbol() public view virtual override returns (string memory) {
848     return _symbol;
849   }
850 
851   /**
852    * @dev See {IERC721Metadata-tokenURI}.
853    */
854   function tokenURI(uint256 tokenId)
855     public
856     view
857     virtual
858     override
859     returns (string memory)
860   {
861     require(
862       _exists(tokenId),
863       "ERC721Metadata: URI query for nonexistent token"
864     );
865 
866     string memory baseURI = _baseURI();
867     return
868       bytes(baseURI).length > 0
869         ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
870         : "";
871   }
872 
873   /**
874    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
875    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
876    * by default, can be overriden in child contracts.
877    */
878   function _baseURI() internal view virtual returns (string memory) {
879     return "";
880   }
881 
882   /**
883    * @dev See {IERC721-approve}.
884    */
885   function approve(address to, uint256 tokenId) public override {
886     address owner = ERC721A.ownerOf(tokenId);
887     require(to != owner, "ERC721A: approval to current owner");
888 
889     require(
890       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
891       "ERC721A: approve caller is not owner nor approved for all"
892     );
893 
894     _approve(to, tokenId, owner);
895   }
896 
897   /**
898    * @dev See {IERC721-getApproved}.
899    */
900   function getApproved(uint256 tokenId) public view override returns (address) {
901     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
902 
903     return _tokenApprovals[tokenId];
904   }
905 
906   /**
907    * @dev See {IERC721-setApprovalForAll}.
908    */
909   function setApprovalForAll(address operator, bool approved) public override {
910     require(operator != _msgSender(), "ERC721A: approve to caller");
911 
912     _operatorApprovals[_msgSender()][operator] = approved;
913     emit ApprovalForAll(_msgSender(), operator, approved);
914   }
915 
916   /**
917    * @dev See {IERC721-isApprovedForAll}.
918    */
919   function isApprovedForAll(address owner, address operator)
920     public
921     view
922     virtual
923     override
924     returns (bool)
925   {
926     return _operatorApprovals[owner][operator];
927   }
928 
929   /**
930    * @dev See {IERC721-transferFrom}.
931    */
932   function transferFrom(
933     address from,
934     address to,
935     uint256 tokenId
936   ) public override {
937     _transfer(from, to, tokenId);
938   }
939 
940   /**
941    * @dev See {IERC721-safeTransferFrom}.
942    */
943   function safeTransferFrom(
944     address from,
945     address to,
946     uint256 tokenId
947   ) public override {
948     safeTransferFrom(from, to, tokenId, "");
949   }
950 
951   /**
952    * @dev See {IERC721-safeTransferFrom}.
953    */
954   function safeTransferFrom(
955     address from,
956     address to,
957     uint256 tokenId,
958     bytes memory _data
959   ) public override {
960     _transfer(from, to, tokenId);
961     require(
962       _checkOnERC721Received(from, to, tokenId, _data),
963       "ERC721A: transfer to non ERC721Receiver implementer"
964     );
965   }
966 
967   /**
968    * @dev Returns whether `tokenId` exists.
969    *
970    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
971    *
972    * Tokens start existing when they are minted (`_mint`),
973    */
974   function _exists(uint256 tokenId) internal view returns (bool) {
975     return tokenId < currentIndex;
976   }
977 
978   function _safeMint(address to, uint256 quantity) internal {
979     _safeMint(to, quantity, "");
980   }
981 
982   /**
983    * @dev Mints `quantity` tokens and transfers them to `to`.
984    *
985    * Requirements:
986    *
987    * - there must be `quantity` tokens remaining unminted in the total collection.
988    * - `to` cannot be the zero address.
989    * - `quantity` cannot be larger than the max batch size.
990    *
991    * Emits a {Transfer} event.
992    */
993   function _safeMint(
994     address to,
995     uint256 quantity,
996     bytes memory _data
997   ) internal {
998     uint256 startTokenId = currentIndex;
999     require(to != address(0), "ERC721A: mint to the zero address");
1000     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1001     require(!_exists(startTokenId), "ERC721A: token already minted");
1002     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1003 
1004     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1005 
1006     AddressData memory addressData = _addressData[to];
1007     _addressData[to] = AddressData(
1008       addressData.balance + uint128(quantity),
1009       addressData.numberMinted + uint128(quantity)
1010     );
1011     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1012 
1013     uint256 updatedIndex = startTokenId;
1014 
1015     for (uint256 i = 0; i < quantity; i++) {
1016       emit Transfer(address(0), to, updatedIndex);
1017       require(
1018         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1019         "ERC721A: transfer to non ERC721Receiver implementer"
1020       );
1021       updatedIndex++;
1022     }
1023 
1024     currentIndex = updatedIndex;
1025     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1026   }
1027 
1028   /**
1029    * @dev Transfers `tokenId` from `from` to `to`.
1030    *
1031    * Requirements:
1032    *
1033    * - `to` cannot be the zero address.
1034    * - `tokenId` token must be owned by `from`.
1035    *
1036    * Emits a {Transfer} event.
1037    */
1038   function _transfer(
1039     address from,
1040     address to,
1041     uint256 tokenId
1042   ) private {
1043     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1044 
1045     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1046       getApproved(tokenId) == _msgSender() ||
1047       isApprovedForAll(prevOwnership.addr, _msgSender()));
1048 
1049     require(
1050       isApprovedOrOwner,
1051       "ERC721A: transfer caller is not owner nor approved"
1052     );
1053 
1054     require(
1055       prevOwnership.addr == from,
1056       "ERC721A: transfer from incorrect owner"
1057     );
1058     require(to != address(0), "ERC721A: transfer to the zero address");
1059 
1060     _beforeTokenTransfers(from, to, tokenId, 1);
1061 
1062     // Clear approvals from the previous owner
1063     _approve(address(0), tokenId, prevOwnership.addr);
1064 
1065     _addressData[from].balance -= 1;
1066     _addressData[to].balance += 1;
1067     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1068 
1069     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1070     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1071     uint256 nextTokenId = tokenId + 1;
1072     if (_ownerships[nextTokenId].addr == address(0)) {
1073       if (_exists(nextTokenId)) {
1074         _ownerships[nextTokenId] = TokenOwnership(
1075           prevOwnership.addr,
1076           prevOwnership.startTimestamp
1077         );
1078       }
1079     }
1080 
1081     emit Transfer(from, to, tokenId);
1082     _afterTokenTransfers(from, to, tokenId, 1);
1083   }
1084 
1085   /**
1086    * @dev Approve `to` to operate on `tokenId`
1087    *
1088    * Emits a {Approval} event.
1089    */
1090   function _approve(
1091     address to,
1092     uint256 tokenId,
1093     address owner
1094   ) private {
1095     _tokenApprovals[tokenId] = to;
1096     emit Approval(owner, to, tokenId);
1097   }
1098 
1099   uint256 public nextOwnerToExplicitlySet = 0;
1100 
1101   /**
1102    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1103    */
1104   function _setOwnersExplicit(uint256 quantity) internal {
1105     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1106     require(quantity > 0, "quantity must be nonzero");
1107     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1108     if (endIndex > collectionSize - 1) {
1109       endIndex = collectionSize - 1;
1110     }
1111     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1112     require(_exists(endIndex), "not enough minted yet for this cleanup");
1113     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1114       if (_ownerships[i].addr == address(0)) {
1115         TokenOwnership memory ownership = ownershipOf(i);
1116         _ownerships[i] = TokenOwnership(
1117           ownership.addr,
1118           ownership.startTimestamp
1119         );
1120       }
1121     }
1122     nextOwnerToExplicitlySet = endIndex + 1;
1123   }
1124 
1125   /**
1126    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1127    * The call is not executed if the target address is not a contract.
1128    *
1129    * @param from address representing the previous owner of the given token ID
1130    * @param to target address that will receive the tokens
1131    * @param tokenId uint256 ID of the token to be transferred
1132    * @param _data bytes optional data to send along with the call
1133    * @return bool whether the call correctly returned the expected magic value
1134    */
1135   function _checkOnERC721Received(
1136     address from,
1137     address to,
1138     uint256 tokenId,
1139     bytes memory _data
1140   ) private returns (bool) {
1141     if (to.isContract()) {
1142       try
1143         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1144       returns (bytes4 retval) {
1145         return retval == IERC721Receiver(to).onERC721Received.selector;
1146       } catch (bytes memory reason) {
1147         if (reason.length == 0) {
1148           revert("ERC721A: transfer to non ERC721Receiver implementer");
1149         } else {
1150           assembly {
1151             revert(add(32, reason), mload(reason))
1152           }
1153         }
1154       }
1155     } else {
1156       return true;
1157     }
1158   }
1159 
1160   /**
1161    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1162    *
1163    * startTokenId - the first token id to be transferred
1164    * quantity - the amount to be transferred
1165    *
1166    * Calling conditions:
1167    *
1168    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1169    * transferred to `to`.
1170    * - When `from` is zero, `tokenId` will be minted for `to`.
1171    */
1172   function _beforeTokenTransfers(
1173     address from,
1174     address to,
1175     uint256 startTokenId,
1176     uint256 quantity
1177   ) internal virtual {}
1178 
1179   /**
1180    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1181    * minting.
1182    *
1183    * startTokenId - the first token id to be transferred
1184    * quantity - the amount to be transferred
1185    *
1186    * Calling conditions:
1187    *
1188    * - when `from` and `to` are both non-zero.
1189    * - `from` and `to` are never both zero.
1190    */
1191   function _afterTokenTransfers(
1192     address from,
1193     address to,
1194     uint256 startTokenId,
1195     uint256 quantity
1196   ) internal virtual {}
1197 }
1198 
1199 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1200 
1201 pragma solidity ^0.8.0;
1202 
1203 /**
1204  * @dev Contract module which provides a basic access control mechanism, where
1205  * there is an account (an owner) that can be granted exclusive access to
1206  * specific functions.
1207  *
1208  * By default, the owner account will be the one that deploys the contract. This
1209  * can later be changed with {transferOwnership}.
1210  *
1211  * This module is used through inheritance. It will make available the modifier
1212  * `onlyOwner`, which can be applied to your functions to restrict their use to
1213  * the owner.
1214  */
1215 abstract contract Ownable is Context {
1216     address private _owner;
1217 
1218     event OwnershipTransferred(
1219         address indexed previousOwner,
1220         address indexed newOwner
1221     );
1222 
1223     /**
1224      * @dev Initializes the contract setting the deployer as the initial owner.
1225      */
1226     constructor() {
1227         _transferOwnership(_msgSender());
1228     }
1229 
1230     /**
1231      * @dev Returns the address of the current owner.
1232      */
1233     function owner() public view virtual returns (address) {
1234         return _owner;
1235     }
1236 
1237     /**
1238      * @dev Throws if called by any account other than the owner.
1239      */
1240     modifier onlyOwner() {
1241         require(owner() == _msgSender(), "You are not the owner");
1242         _;
1243     }
1244 
1245     /**
1246      * @dev Leaves the contract without owner. It will not be possible to call
1247      * `onlyOwner` functions anymore. Can only be called by the current owner.
1248      *
1249      * NOTE: Renouncing ownership will leave the contract without an owner,
1250      * thereby removing any functionality that is only available to the owner.
1251      */
1252     function renounceOwnership() public virtual onlyOwner {
1253         _transferOwnership(address(0));
1254     }
1255 
1256     /**
1257      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1258      * Can only be called by the current owner.
1259      */
1260     function transferOwnership(address newOwner) public virtual onlyOwner {
1261         require(
1262             newOwner != address(0),
1263             "Ownable: new owner is the zero address"
1264         );
1265         _transferOwnership(newOwner);
1266     }
1267 
1268     /**
1269      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1270      * Internal function without access restriction.
1271      */
1272     function _transferOwnership(address newOwner) internal virtual {
1273         address oldOwner = _owner;
1274         _owner = newOwner;
1275         emit OwnershipTransferred(oldOwner, newOwner);
1276     }
1277 }
1278 
1279 
1280 pragma solidity ^0.8.0;
1281 
1282 contract MadSails is ERC721A, Ownable {
1283     uint256 public NFT_PRICE = 0 ether;
1284     uint256 public MAX_SUPPLY = 6000;
1285     uint256 public MAX_MINTS = 500;
1286     string public baseURI = "ipfs://QmdFh349iKeBLRj21PqkGvw4S9Y4gPhJtPb3UFCpaSpJU4/";
1287     string public baseExtension = ".json";
1288      bool public paused = true;
1289     
1290     constructor() ERC721A("Mad Sails", "MADSAILS", MAX_MINTS, MAX_SUPPLY) {  
1291     }
1292     
1293 
1294     function Mint(uint256 numTokens) public payable {
1295         require(!paused, "Paused");
1296         require(numTokens > 0 && numTokens <= MAX_MINTS);
1297         require(totalSupply() + numTokens <= MAX_SUPPLY);
1298         require(MAX_MINTS >= numTokens, "Excess max per paid tx");
1299         require(msg.value >= numTokens * NFT_PRICE, "Invalid funds provided");
1300         _safeMint(msg.sender, numTokens);
1301     }
1302 
1303     function DevsMint(uint256 numTokens) public payable onlyOwner {
1304         _safeMint(msg.sender, numTokens);
1305     }
1306 
1307 
1308     function pause(bool _state) public onlyOwner {
1309         paused = _state;
1310     }
1311 
1312     function setBaseURI(string memory newBaseURI) public onlyOwner {
1313         baseURI = newBaseURI;
1314     }
1315     function tokenURI(uint256 _tokenId)
1316         public
1317         view
1318         override
1319         returns (string memory)
1320     {
1321         require(_exists(_tokenId), "That token doesn't exist");
1322         return
1323             bytes(baseURI).length > 0
1324                 ? string(
1325                     abi.encodePacked(
1326                         baseURI,
1327                         Strings.toString(_tokenId),
1328                         baseExtension
1329                     )
1330                 )
1331                 : "";
1332     }
1333 
1334     function setPrice(uint256 newPrice) public onlyOwner {
1335         NFT_PRICE = newPrice;
1336     }
1337 
1338     function setMaxMints(uint256 newMax) public onlyOwner {
1339         MAX_MINTS = newMax;
1340     }
1341 
1342     function _baseURI() internal view virtual override returns (string memory) {
1343         return baseURI;
1344     }
1345 
1346     function withdrawMoney() external onlyOwner {
1347       (bool success, ) = msg.sender.call{value: address(this).balance}("");
1348       require(success, "WITHDRAW FAILED!");
1349     }
1350 }