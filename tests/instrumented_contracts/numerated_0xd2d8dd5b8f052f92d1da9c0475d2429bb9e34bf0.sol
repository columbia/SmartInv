1 // SPDX-License-Identifier: MIT
2 // File: contracts/ETHPOD.sol
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 interface IERC165 {
17     /**
18      * @dev Returns true if this contract implements the interface defined by
19      * `interfaceId`. See the corresponding
20      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
21      * to learn more about how these ids are created.
22      *
23      * This function call must use less than 30 000 gas.
24      */
25     function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @dev Required interface of an ERC721 compliant contract.
34  */
35 interface IERC721 is IERC165 {
36     /**
37      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
38      */
39     event Transfer(
40         address indexed from,
41         address indexed to,
42         uint256 indexed tokenId
43     );
44 
45     /**
46      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
47      */
48     event Approval(
49         address indexed owner,
50         address indexed approved,
51         uint256 indexed tokenId
52     );
53 
54     /**
55      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
56      */
57     event ApprovalForAll(
58         address indexed owner,
59         address indexed operator,
60         bool approved
61     );
62 
63     /**
64      * @dev Returns the number of tokens in ``owner``'s account.
65      */
66     function balanceOf(address owner) external view returns (uint256 balance);
67 
68     /**
69      * @dev Returns the owner of the `tokenId` token.
70      *
71      * Requirements:
72      *
73      * - `tokenId` must exist.
74      */
75     function ownerOf(uint256 tokenId) external view returns (address owner);
76 
77     /**
78      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
79      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
80      *
81      * Requirements:
82      *
83      * - `from` cannot be the zero address.
84      * - `to` cannot be the zero address.
85      * - `tokenId` token must exist and be owned by `from`.
86      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
87      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
88      *
89      * Emits a {Transfer} event.
90      */
91     function safeTransferFrom(
92         address from,
93         address to,
94         uint256 tokenId
95     ) external;
96 
97     /**
98      * @dev Transfers `tokenId` token from `from` to `to`.
99      *
100      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
101      *
102      * Requirements:
103      *
104      * - `from` cannot be the zero address.
105      * - `to` cannot be the zero address.
106      * - `tokenId` token must be owned by `from`.
107      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
108      *
109      * Emits a {Transfer} event.
110      */
111     function transferFrom(
112         address from,
113         address to,
114         uint256 tokenId
115     ) external;
116 
117     /**
118      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
119      * The approval is cleared when the token is transferred.
120      *
121      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
122      *
123      * Requirements:
124      *
125      * - The caller must own the token or be an approved operator.
126      * - `tokenId` must exist.
127      *
128      * Emits an {Approval} event.
129      */
130     function approve(address to, uint256 tokenId) external;
131 
132     /**
133      * @dev Returns the account approved for `tokenId` token.
134      *
135      * Requirements:
136      *
137      * - `tokenId` must exist.
138      */
139     function getApproved(uint256 tokenId)
140         external
141         view
142         returns (address operator);
143 
144     /**
145      * @dev Approve or remove `operator` as an operator for the caller.
146      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
147      *
148      * Requirements:
149      *
150      * - The `operator` cannot be the caller.
151      *
152      * Emits an {ApprovalForAll} event.
153      */
154     function setApprovalForAll(address operator, bool _approved) external;
155 
156     /**
157      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
158      *
159      * See {setApprovalForAll}
160      */
161     function isApprovedForAll(address owner, address operator)
162         external
163         view
164         returns (bool);
165 
166     /**
167      * @dev Safely transfers `tokenId` token from `from` to `to`.
168      *
169      * Requirements:
170      *
171      * - `from` cannot be the zero address.
172      * - `to` cannot be the zero address.
173      * - `tokenId` token must exist and be owned by `from`.
174      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
175      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
176      *
177      * Emits a {Transfer} event.
178      */
179     function safeTransferFrom(
180         address from,
181         address to,
182         uint256 tokenId,
183         bytes calldata data
184     ) external;
185 }
186 
187 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
188 
189 pragma solidity ^0.8.0;
190 
191 /**
192  * @title ERC721 token receiver interface
193  * @dev Interface for any contract that wants to support safeTransfers
194  * from ERC721 asset contracts.
195  */
196 interface IERC721Receiver {
197     /**
198      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
199      * by `operator` from `from`, this function is called.
200      *
201      * It must return its Solidity selector to confirm the token transfer.
202      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
203      *
204      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
205      */
206     function onERC721Received(
207         address operator,
208         address from,
209         uint256 tokenId,
210         bytes calldata data
211     ) external returns (bytes4);
212 }
213 
214 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
215 
216 pragma solidity ^0.8.0;
217 
218 /**
219  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
220  * @dev See https://eips.ethereum.org/EIPS/eip-721
221  */
222 interface IERC721Metadata is IERC721 {
223     /**
224      * @dev Returns the token collection name.
225      */
226     function name() external view returns (string memory);
227 
228     /**
229      * @dev Returns the token collection symbol.
230      */
231     function symbol() external view returns (string memory);
232 
233     /**
234      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
235      */
236     function tokenURI(uint256 tokenId) external view returns (string memory);
237 }
238 
239 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
240 
241 pragma solidity ^0.8.0;
242 
243 /**
244  * @dev Implementation of the {IERC165} interface.
245  *
246  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
247  * for the additional interface id that will be supported. For example:
248  *
249  * ```solidity
250  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
251  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
252  * }
253  * ```
254  *
255  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
256  */
257 abstract contract ERC165 is IERC165 {
258     /**
259      * @dev See {IERC165-supportsInterface}.
260      */
261     function supportsInterface(bytes4 interfaceId)
262         public
263         view
264         virtual
265         override
266         returns (bool)
267     {
268         return interfaceId == type(IERC165).interfaceId;
269     }
270 }
271 
272 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
273 
274 pragma solidity ^0.8.0;
275 
276 /**
277  * @dev Collection of functions related to the address type
278  */
279 library Address {
280     /**
281      * @dev Returns true if `account` is a contract.
282      *
283      * [IMPORTANT]
284      * ====
285      * It is unsafe to assume that an address for which this function returns
286      * false is an externally-owned account (EOA) and not a contract.
287      *
288      * Among others, `isContract` will return false for the following
289      * types of addresses:
290      *
291      *  - an externally-owned account
292      *  - a contract in construction
293      *  - an address where a contract will be created
294      *  - an address where a contract lived, but was destroyed
295      * ====
296      */
297     function isContract(address account) internal view returns (bool) {
298         // This method relies on extcodesize, which returns 0 for contracts in
299         // construction, since the code is only stored at the end of the
300         // constructor execution.
301 
302         uint256 size;
303         assembly {
304             size := extcodesize(account)
305         }
306         return size > 0;
307     }
308 
309     /**
310      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
311      * `recipient`, forwarding all available gas and reverting on errors.
312      *
313      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
314      * of certain opcodes, possibly making contracts go over the 2300 gas limit
315      * imposed by `transfer`, making them unable to receive funds via
316      * `transfer`. {sendValue} removes this limitation.
317      *
318      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
319      *
320      * IMPORTANT: because control is transferred to `recipient`, care must be
321      * taken to not create reentrancy vulnerabilities. Consider using
322      * {ReentrancyGuard} or the
323      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
324      */
325     function sendValue(address payable recipient, uint256 amount) internal {
326         require(
327             address(this).balance >= amount,
328             "Address: insufficient balance"
329         );
330 
331         (bool success, ) = recipient.call{value: amount}("");
332         require(
333             success,
334             "Address: unable to send value, recipient may have reverted"
335         );
336     }
337 
338     /**
339      * @dev Performs a Solidity function call using a low level `call`. A
340      * plain `call` is an unsafe replacement for a function call: use this
341      * function instead.
342      *
343      * If `target` reverts with a revert reason, it is bubbled up by this
344      * function (like regular Solidity function calls).
345      *
346      * Returns the raw returned data. To convert to the expected return value,
347      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
348      *
349      * Requirements:
350      *
351      * - `target` must be a contract.
352      * - calling `target` with `data` must not revert.
353      *
354      * _Available since v3.1._
355      */
356     function functionCall(address target, bytes memory data)
357         internal
358         returns (bytes memory)
359     {
360         return functionCall(target, data, "Address: low-level call failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
365      * `errorMessage` as a fallback revert reason when `target` reverts.
366      *
367      * _Available since v3.1._
368      */
369     function functionCall(
370         address target,
371         bytes memory data,
372         string memory errorMessage
373     ) internal returns (bytes memory) {
374         return functionCallWithValue(target, data, 0, errorMessage);
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
379      * but also transferring `value` wei to `target`.
380      *
381      * Requirements:
382      *
383      * - the calling contract must have an ETH balance of at least `value`.
384      * - the called Solidity function must be `payable`.
385      *
386      * _Available since v3.1._
387      */
388     function functionCallWithValue(
389         address target,
390         bytes memory data,
391         uint256 value
392     ) internal returns (bytes memory) {
393         return
394             functionCallWithValue(
395                 target,
396                 data,
397                 value,
398                 "Address: low-level call with value failed"
399             );
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
404      * with `errorMessage` as a fallback revert reason when `target` reverts.
405      *
406      * _Available since v3.1._
407      */
408     function functionCallWithValue(
409         address target,
410         bytes memory data,
411         uint256 value,
412         string memory errorMessage
413     ) internal returns (bytes memory) {
414         require(
415             address(this).balance >= value,
416             "Address: insufficient balance for call"
417         );
418         require(isContract(target), "Address: call to non-contract");
419 
420         (bool success, bytes memory returndata) = target.call{value: value}(
421             data
422         );
423         return verifyCallResult(success, returndata, errorMessage);
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
428      * but performing a static call.
429      *
430      * _Available since v3.3._
431      */
432     function functionStaticCall(address target, bytes memory data)
433         internal
434         view
435         returns (bytes memory)
436     {
437         return
438             functionStaticCall(
439                 target,
440                 data,
441                 "Address: low-level static call failed"
442             );
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
447      * but performing a static call.
448      *
449      * _Available since v3.3._
450      */
451     function functionStaticCall(
452         address target,
453         bytes memory data,
454         string memory errorMessage
455     ) internal view returns (bytes memory) {
456         require(isContract(target), "Address: static call to non-contract");
457 
458         (bool success, bytes memory returndata) = target.staticcall(data);
459         return verifyCallResult(success, returndata, errorMessage);
460     }
461 
462     /**
463      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
464      * but performing a delegate call.
465      *
466      * _Available since v3.4._
467      */
468     function functionDelegateCall(address target, bytes memory data)
469         internal
470         returns (bytes memory)
471     {
472         return
473             functionDelegateCall(
474                 target,
475                 data,
476                 "Address: low-level delegate call failed"
477             );
478     }
479 
480     /**
481      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
482      * but performing a delegate call.
483      *
484      * _Available since v3.4._
485      */
486     function functionDelegateCall(
487         address target,
488         bytes memory data,
489         string memory errorMessage
490     ) internal returns (bytes memory) {
491         require(isContract(target), "Address: delegate call to non-contract");
492 
493         (bool success, bytes memory returndata) = target.delegatecall(data);
494         return verifyCallResult(success, returndata, errorMessage);
495     }
496 
497     /**
498      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
499      * revert reason using the provided one.
500      *
501      * _Available since v4.3._
502      */
503     function verifyCallResult(
504         bool success,
505         bytes memory returndata,
506         string memory errorMessage
507     ) internal pure returns (bytes memory) {
508         if (success) {
509             return returndata;
510         } else {
511             // Look for revert reason and bubble it up if present
512             if (returndata.length > 0) {
513                 // The easiest way to bubble the revert reason is using memory via assembly
514 
515                 assembly {
516                     let returndata_size := mload(returndata)
517                     revert(add(32, returndata), returndata_size)
518                 }
519             } else {
520                 revert(errorMessage);
521             }
522         }
523     }
524 }
525 
526 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
527 
528 pragma solidity ^0.8.0;
529 
530 /**
531  * @dev Provides information about the current execution context, including the
532  * sender of the transaction and its data. While these are generally available
533  * via msg.sender and msg.data, they should not be accessed in such a direct
534  * manner, since when dealing with meta-transactions the account sending and
535  * paying for execution may not be the actual sender (as far as an application
536  * is concerned).
537  *
538  * This contract is only required for intermediate, library-like contracts.
539  */
540 abstract contract Context {
541     function _msgSender() internal view virtual returns (address) {
542         return msg.sender;
543     }
544 
545     function _msgData() internal view virtual returns (bytes calldata) {
546         return msg.data;
547     }
548 }
549 
550 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
551 
552 pragma solidity ^0.8.0;
553 
554 /**
555  * @dev String operations.
556  */
557 library Strings {
558     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
559 
560     /**
561      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
562      */
563     function toString(uint256 value) internal pure returns (string memory) {
564         // Inspired by OraclizeAPI's implementation - MIT licence
565         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
566 
567         if (value == 0) {
568             return "0";
569         }
570         uint256 temp = value;
571         uint256 digits;
572         while (temp != 0) {
573             digits++;
574             temp /= 10;
575         }
576         bytes memory buffer = new bytes(digits);
577         while (value != 0) {
578             digits -= 1;
579             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
580             value /= 10;
581         }
582         return string(buffer);
583     }
584 
585     /**
586      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
587      */
588     function toHexString(uint256 value) internal pure returns (string memory) {
589         if (value == 0) {
590             return "0x00";
591         }
592         uint256 temp = value;
593         uint256 length = 0;
594         while (temp != 0) {
595             length++;
596             temp >>= 8;
597         }
598         return toHexString(value, length);
599     }
600 
601     /**
602      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
603      */
604     function toHexString(uint256 value, uint256 length)
605         internal
606         pure
607         returns (string memory)
608     {
609         bytes memory buffer = new bytes(2 * length + 2);
610         buffer[0] = "0";
611         buffer[1] = "x";
612         for (uint256 i = 2 * length + 1; i > 1; --i) {
613             buffer[i] = _HEX_SYMBOLS[value & 0xf];
614             value >>= 4;
615         }
616         require(value == 0, "Strings: hex length insufficient");
617         return string(buffer);
618     }
619 }
620 
621 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
622 
623 pragma solidity ^0.8.0;
624 
625 /**
626  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
627  * @dev See https://eips.ethereum.org/EIPS/eip-721
628  */
629 interface IERC721Enumerable is IERC721 {
630     /**
631      * @dev Returns the total amount of tokens stored by the contract.
632      */
633     function totalSupply() external view returns (uint256);
634 
635     /**
636      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
637      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
638      */
639     function tokenOfOwnerByIndex(address owner, uint256 index)
640         external
641         view
642         returns (uint256 tokenId);
643 
644     /**
645      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
646      * Use along with {totalSupply} to enumerate all tokens.
647      */
648     function tokenByIndex(uint256 index) external view returns (uint256);
649 }
650 
651 pragma solidity ^0.8.0;
652 
653 /**
654  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
655  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
656  *
657  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
658  *
659  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
660  *
661  * Does not support burning tokens to address(0).
662  */
663 contract ERC721A is
664   Context,
665   ERC165,
666   IERC721,
667   IERC721Metadata,
668   IERC721Enumerable
669 {
670   using Address for address;
671   using Strings for uint256;
672 
673   struct TokenOwnership {
674     address addr;
675     uint64 startTimestamp;
676   }
677 
678   struct AddressData {
679     uint128 balance;
680     uint128 numberMinted;
681   }
682 
683   uint256 private currentIndex = 0;
684 
685   uint256 internal immutable collectionSize;
686   uint256 internal immutable maxBatchSize;
687 
688   // Token name
689   string private _name;
690 
691   // Token symbol
692   string private _symbol;
693 
694   // Mapping from token ID to ownership details
695   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
696   mapping(uint256 => TokenOwnership) private _ownerships;
697 
698   // Mapping owner address to address data
699   mapping(address => AddressData) private _addressData;
700 
701   // Mapping from token ID to approved address
702   mapping(uint256 => address) private _tokenApprovals;
703 
704   // Mapping from owner to operator approvals
705   mapping(address => mapping(address => bool)) private _operatorApprovals;
706 
707   /**
708    * @dev
709    * `maxBatchSize` refers to how much a minter can mint at a time.
710    * `collectionSize_` refers to how many tokens are in the collection.
711    */
712   constructor(
713     string memory name_,
714     string memory symbol_,
715     uint256 maxBatchSize_,
716     uint256 collectionSize_
717   ) {
718     require(
719       collectionSize_ > 0,
720       "ERC721A: collection must have a nonzero supply"
721     );
722     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
723     _name = name_;
724     _symbol = symbol_;
725     maxBatchSize = maxBatchSize_;
726     collectionSize = collectionSize_;
727   }
728 
729   /**
730    * @dev See {IERC721Enumerable-totalSupply}.
731    */
732   function totalSupply() public view override returns (uint256) {
733     return currentIndex;
734   }
735 
736   /**
737    * @dev See {IERC721Enumerable-tokenByIndex}.
738    */
739   function tokenByIndex(uint256 index) public view override returns (uint256) {
740     require(index < totalSupply(), "ERC721A: global index out of bounds");
741     return index;
742   }
743 
744   /**
745    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
746    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
747    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
748    */
749   function tokenOfOwnerByIndex(address owner, uint256 index)
750     public
751     view
752     override
753     returns (uint256)
754   {
755     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
756     uint256 numMintedSoFar = totalSupply();
757     uint256 tokenIdsIdx = 0;
758     address currOwnershipAddr = address(0);
759     for (uint256 i = 0; i < numMintedSoFar; i++) {
760       TokenOwnership memory ownership = _ownerships[i];
761       if (ownership.addr != address(0)) {
762         currOwnershipAddr = ownership.addr;
763       }
764       if (currOwnershipAddr == owner) {
765         if (tokenIdsIdx == index) {
766           return i;
767         }
768         tokenIdsIdx++;
769       }
770     }
771     revert("ERC721A: unable to get token of owner by index");
772   }
773 
774   /**
775    * @dev See {IERC165-supportsInterface}.
776    */
777   function supportsInterface(bytes4 interfaceId)
778     public
779     view
780     virtual
781     override(ERC165, IERC165)
782     returns (bool)
783   {
784     return
785       interfaceId == type(IERC721).interfaceId ||
786       interfaceId == type(IERC721Metadata).interfaceId ||
787       interfaceId == type(IERC721Enumerable).interfaceId ||
788       super.supportsInterface(interfaceId);
789   }
790 
791   /**
792    * @dev See {IERC721-balanceOf}.
793    */
794   function balanceOf(address owner) public view override returns (uint256) {
795     require(owner != address(0), "ERC721A: balance query for the zero address");
796     return uint256(_addressData[owner].balance);
797   }
798 
799   function _numberMinted(address owner) internal view returns (uint256) {
800     require(
801       owner != address(0),
802       "ERC721A: number minted query for the zero address"
803     );
804     return uint256(_addressData[owner].numberMinted);
805   }
806 
807   function ownershipOf(uint256 tokenId)
808     internal
809     view
810     returns (TokenOwnership memory)
811   {
812     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
813 
814     uint256 lowestTokenToCheck;
815     if (tokenId >= maxBatchSize) {
816       lowestTokenToCheck = tokenId - maxBatchSize + 1;
817     }
818 
819     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
820       TokenOwnership memory ownership = _ownerships[curr];
821       if (ownership.addr != address(0)) {
822         return ownership;
823       }
824     }
825 
826     revert("ERC721A: unable to determine the owner of token");
827   }
828 
829   /**
830    * @dev See {IERC721-ownerOf}.
831    */
832   function ownerOf(uint256 tokenId) public view override returns (address) {
833     return ownershipOf(tokenId).addr;
834   }
835 
836   /**
837    * @dev See {IERC721Metadata-name}.
838    */
839   function name() public view virtual override returns (string memory) {
840     return _name;
841   }
842 
843   /**
844    * @dev See {IERC721Metadata-symbol}.
845    */
846   function symbol() public view virtual override returns (string memory) {
847     return _symbol;
848   }
849 
850   /**
851    * @dev See {IERC721Metadata-tokenURI}.
852    */
853   function tokenURI(uint256 tokenId)
854     public
855     view
856     virtual
857     override
858     returns (string memory)
859   {
860     require(
861       _exists(tokenId),
862       "ERC721Metadata: URI query for nonexistent token"
863     );
864 
865     string memory baseURI = _baseURI();
866     return
867       bytes(baseURI).length > 0
868         ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
869         : "";
870   }
871 
872   /**
873    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
874    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
875    * by default, can be overriden in child contracts.
876    */
877   function _baseURI() internal view virtual returns (string memory) {
878     return "";
879   }
880 
881   /**
882    * @dev See {IERC721-approve}.
883    */
884   function approve(address to, uint256 tokenId) public override {
885     address owner = ERC721A.ownerOf(tokenId);
886     require(to != owner, "ERC721A: approval to current owner");
887 
888     require(
889       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
890       "ERC721A: approve caller is not owner nor approved for all"
891     );
892 
893     _approve(to, tokenId, owner);
894   }
895 
896   /**
897    * @dev See {IERC721-getApproved}.
898    */
899   function getApproved(uint256 tokenId) public view override returns (address) {
900     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
901 
902     return _tokenApprovals[tokenId];
903   }
904 
905   /**
906    * @dev See {IERC721-setApprovalForAll}.
907    */
908   function setApprovalForAll(address operator, bool approved) public override {
909     require(operator != _msgSender(), "ERC721A: approve to caller");
910 
911     _operatorApprovals[_msgSender()][operator] = approved;
912     emit ApprovalForAll(_msgSender(), operator, approved);
913   }
914 
915   /**
916    * @dev See {IERC721-isApprovedForAll}.
917    */
918   function isApprovedForAll(address owner, address operator)
919     public
920     view
921     virtual
922     override
923     returns (bool)
924   {
925     return _operatorApprovals[owner][operator];
926   }
927 
928   /**
929    * @dev See {IERC721-transferFrom}.
930    */
931   function transferFrom(
932     address from,
933     address to,
934     uint256 tokenId
935   ) public override {
936     _transfer(from, to, tokenId);
937   }
938 
939   /**
940    * @dev See {IERC721-safeTransferFrom}.
941    */
942   function safeTransferFrom(
943     address from,
944     address to,
945     uint256 tokenId
946   ) public override {
947     safeTransferFrom(from, to, tokenId, "");
948   }
949 
950   /**
951    * @dev See {IERC721-safeTransferFrom}.
952    */
953   function safeTransferFrom(
954     address from,
955     address to,
956     uint256 tokenId,
957     bytes memory _data
958   ) public override {
959     _transfer(from, to, tokenId);
960     require(
961       _checkOnERC721Received(from, to, tokenId, _data),
962       "ERC721A: transfer to non ERC721Receiver implementer"
963     );
964   }
965 
966   /**
967    * @dev Returns whether `tokenId` exists.
968    *
969    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
970    *
971    * Tokens start existing when they are minted (`_mint`),
972    */
973   function _exists(uint256 tokenId) internal view returns (bool) {
974     return tokenId < currentIndex;
975   }
976 
977   function _safeMint(address to, uint256 quantity) internal {
978     _safeMint(to, quantity, "");
979   }
980 
981   /**
982    * @dev Mints `quantity` tokens and transfers them to `to`.
983    *
984    * Requirements:
985    *
986    * - there must be `quantity` tokens remaining unminted in the total collection.
987    * - `to` cannot be the zero address.
988    * - `quantity` cannot be larger than the max batch size.
989    *
990    * Emits a {Transfer} event.
991    */
992   function _safeMint(
993     address to,
994     uint256 quantity,
995     bytes memory _data
996   ) internal {
997     uint256 startTokenId = currentIndex;
998     require(to != address(0), "ERC721A: mint to the zero address");
999     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1000     require(!_exists(startTokenId), "ERC721A: token already minted");
1001     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1002 
1003     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1004 
1005     AddressData memory addressData = _addressData[to];
1006     _addressData[to] = AddressData(
1007       addressData.balance + uint128(quantity),
1008       addressData.numberMinted + uint128(quantity)
1009     );
1010     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1011 
1012     uint256 updatedIndex = startTokenId;
1013 
1014     for (uint256 i = 0; i < quantity; i++) {
1015       emit Transfer(address(0), to, updatedIndex);
1016       require(
1017         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1018         "ERC721A: transfer to non ERC721Receiver implementer"
1019       );
1020       updatedIndex++;
1021     }
1022 
1023     currentIndex = updatedIndex;
1024     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1025   }
1026 
1027   /**
1028    * @dev Transfers `tokenId` from `from` to `to`.
1029    *
1030    * Requirements:
1031    *
1032    * - `to` cannot be the zero address.
1033    * - `tokenId` token must be owned by `from`.
1034    *
1035    * Emits a {Transfer} event.
1036    */
1037   function _transfer(
1038     address from,
1039     address to,
1040     uint256 tokenId
1041   ) private {
1042     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1043 
1044     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1045       getApproved(tokenId) == _msgSender() ||
1046       isApprovedForAll(prevOwnership.addr, _msgSender()));
1047 
1048     require(
1049       isApprovedOrOwner,
1050       "ERC721A: transfer caller is not owner nor approved"
1051     );
1052 
1053     require(
1054       prevOwnership.addr == from,
1055       "ERC721A: transfer from incorrect owner"
1056     );
1057     require(to != address(0), "ERC721A: transfer to the zero address");
1058 
1059     _beforeTokenTransfers(from, to, tokenId, 1);
1060 
1061     // Clear approvals from the previous owner
1062     _approve(address(0), tokenId, prevOwnership.addr);
1063 
1064     _addressData[from].balance -= 1;
1065     _addressData[to].balance += 1;
1066     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1067 
1068     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1069     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1070     uint256 nextTokenId = tokenId + 1;
1071     if (_ownerships[nextTokenId].addr == address(0)) {
1072       if (_exists(nextTokenId)) {
1073         _ownerships[nextTokenId] = TokenOwnership(
1074           prevOwnership.addr,
1075           prevOwnership.startTimestamp
1076         );
1077       }
1078     }
1079 
1080     emit Transfer(from, to, tokenId);
1081     _afterTokenTransfers(from, to, tokenId, 1);
1082   }
1083 
1084   /**
1085    * @dev Approve `to` to operate on `tokenId`
1086    *
1087    * Emits a {Approval} event.
1088    */
1089   function _approve(
1090     address to,
1091     uint256 tokenId,
1092     address owner
1093   ) private {
1094     _tokenApprovals[tokenId] = to;
1095     emit Approval(owner, to, tokenId);
1096   }
1097 
1098   uint256 public nextOwnerToExplicitlySet = 0;
1099 
1100   /**
1101    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1102    */
1103   function _setOwnersExplicit(uint256 quantity) internal {
1104     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1105     require(quantity > 0, "quantity must be nonzero");
1106     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1107     if (endIndex > collectionSize - 1) {
1108       endIndex = collectionSize - 1;
1109     }
1110     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1111     require(_exists(endIndex), "not enough minted yet for this cleanup");
1112     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1113       if (_ownerships[i].addr == address(0)) {
1114         TokenOwnership memory ownership = ownershipOf(i);
1115         _ownerships[i] = TokenOwnership(
1116           ownership.addr,
1117           ownership.startTimestamp
1118         );
1119       }
1120     }
1121     nextOwnerToExplicitlySet = endIndex + 1;
1122   }
1123 
1124   /**
1125    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1126    * The call is not executed if the target address is not a contract.
1127    *
1128    * @param from address representing the previous owner of the given token ID
1129    * @param to target address that will receive the tokens
1130    * @param tokenId uint256 ID of the token to be transferred
1131    * @param _data bytes optional data to send along with the call
1132    * @return bool whether the call correctly returned the expected magic value
1133    */
1134   function _checkOnERC721Received(
1135     address from,
1136     address to,
1137     uint256 tokenId,
1138     bytes memory _data
1139   ) private returns (bool) {
1140     if (to.isContract()) {
1141       try
1142         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1143       returns (bytes4 retval) {
1144         return retval == IERC721Receiver(to).onERC721Received.selector;
1145       } catch (bytes memory reason) {
1146         if (reason.length == 0) {
1147           revert("ERC721A: transfer to non ERC721Receiver implementer");
1148         } else {
1149           assembly {
1150             revert(add(32, reason), mload(reason))
1151           }
1152         }
1153       }
1154     } else {
1155       return true;
1156     }
1157   }
1158 
1159   /**
1160    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1161    *
1162    * startTokenId - the first token id to be transferred
1163    * quantity - the amount to be transferred
1164    *
1165    * Calling conditions:
1166    *
1167    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1168    * transferred to `to`.
1169    * - When `from` is zero, `tokenId` will be minted for `to`.
1170    */
1171   function _beforeTokenTransfers(
1172     address from,
1173     address to,
1174     uint256 startTokenId,
1175     uint256 quantity
1176   ) internal virtual {}
1177 
1178   /**
1179    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1180    * minting.
1181    *
1182    * startTokenId - the first token id to be transferred
1183    * quantity - the amount to be transferred
1184    *
1185    * Calling conditions:
1186    *
1187    * - when `from` and `to` are both non-zero.
1188    * - `from` and `to` are never both zero.
1189    */
1190   function _afterTokenTransfers(
1191     address from,
1192     address to,
1193     uint256 startTokenId,
1194     uint256 quantity
1195   ) internal virtual {}
1196 }
1197 
1198 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1199 
1200 pragma solidity ^0.8.0;
1201 
1202 /**
1203  * @dev Contract module which provides a basic access control mechanism, where
1204  * there is an account (an owner) that can be granted exclusive access to
1205  * specific functions.
1206  *
1207  * By default, the owner account will be the one that deploys the contract. This
1208  * can later be changed with {transferOwnership}.
1209  *
1210  * This module is used through inheritance. It will make available the modifier
1211  * `onlyOwner`, which can be applied to your functions to restrict their use to
1212  * the owner.
1213  */
1214 abstract contract Ownable is Context {
1215     address private _owner;
1216 
1217     event OwnershipTransferred(
1218         address indexed previousOwner,
1219         address indexed newOwner
1220     );
1221 
1222     /**
1223      * @dev Initializes the contract setting the deployer as the initial owner.
1224      */
1225     constructor() {
1226         _transferOwnership(_msgSender());
1227     }
1228 
1229     /**
1230      * @dev Returns the address of the current owner.
1231      */
1232     function owner() public view virtual returns (address) {
1233         return _owner;
1234     }
1235 
1236     /**
1237      * @dev Throws if called by any account other than the owner.
1238      */
1239     modifier onlyOwner() {
1240         require(owner() == _msgSender(), "You are not the owner");
1241         _;
1242     }
1243 
1244     /**
1245      * @dev Leaves the contract without owner. It will not be possible to call
1246      * `onlyOwner` functions anymore. Can only be called by the current owner.
1247      *
1248      * NOTE: Renouncing ownership will leave the contract without an owner,
1249      * thereby removing any functionality that is only available to the owner.
1250      */
1251     function renounceOwnership() public virtual onlyOwner {
1252         _transferOwnership(address(0));
1253     }
1254 
1255     /**
1256      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1257      * Can only be called by the current owner.
1258      */
1259     function transferOwnership(address newOwner) public virtual onlyOwner {
1260         require(
1261             newOwner != address(0),
1262             "Ownable: new owner is the zero address"
1263         );
1264         _transferOwnership(newOwner);
1265     }
1266 
1267     /**
1268      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1269      * Internal function without access restriction.
1270      */
1271     function _transferOwnership(address newOwner) internal virtual {
1272         address oldOwner = _owner;
1273         _owner = newOwner;
1274         emit OwnershipTransferred(oldOwner, newOwner);
1275     }
1276 }
1277 
1278 
1279 pragma solidity ^0.8.0;
1280 
1281 contract ETHPOD is ERC721A, Ownable {
1282     uint256 public NFT_PRICE = 0 ether;
1283     uint256 public MAX_SUPPLY = 3000;
1284     uint256 public MAX_MINTS = 2;
1285     string public baseURI = "ipfs:///";
1286     string public baseExtension = ".json";
1287      bool public paused = false;
1288     
1289     constructor() ERC721A("ETH POD", "ETHPOD", MAX_MINTS, MAX_SUPPLY) {  
1290     }
1291     
1292 
1293     function Mint(uint256 numTokens) public payable {
1294         require(!paused, "Paused");
1295         require(numTokens > 0 && numTokens <= MAX_MINTS);
1296         require(totalSupply() + numTokens <= MAX_SUPPLY);
1297         require(MAX_MINTS >= numTokens, "Excess max per paid tx");
1298         require(msg.value >= numTokens * NFT_PRICE, "Invalid funds provided");
1299         _safeMint(msg.sender, numTokens);
1300     }
1301 
1302     function DevsMint(uint256 numTokens) public payable onlyOwner {
1303         _safeMint(msg.sender, numTokens);
1304     }
1305 
1306 
1307     function pause(bool _state) public onlyOwner {
1308         paused = _state;
1309     }
1310 
1311     function setBaseURI(string memory newBaseURI) public onlyOwner {
1312         baseURI = newBaseURI;
1313     }
1314     function tokenURI(uint256 _tokenId)
1315         public
1316         view
1317         override
1318         returns (string memory)
1319     {
1320         require(_exists(_tokenId), "That token doesn't exist");
1321         return
1322             bytes(baseURI).length > 0
1323                 ? string(
1324                     abi.encodePacked(
1325                         baseURI,
1326                         Strings.toString(_tokenId),
1327                         baseExtension
1328                     )
1329                 )
1330                 : "";
1331     }
1332 
1333     function setPrice(uint256 newPrice) public onlyOwner {
1334         NFT_PRICE = newPrice;
1335     }
1336 
1337     function setMaxMints(uint256 newMax) public onlyOwner {
1338         MAX_MINTS = newMax;
1339     }
1340 
1341     function _baseURI() internal view virtual override returns (string memory) {
1342         return baseURI;
1343     }
1344 
1345     function withdrawMoney() external onlyOwner {
1346       (bool success, ) = msg.sender.call{value: address(this).balance}("");
1347       require(success, "WITHDRAW FAILED!");
1348     }
1349 }