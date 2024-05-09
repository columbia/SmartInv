1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
15 interface IERC165 {
16     /**
17      * @dev Returns true if this contract implements the interface defined by
18      * `interfaceId`. See the corresponding
19      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
20      * to learn more about how these ids are created.
21      *
22      * This function call must use less than 30 000 gas.
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool);
25 }
26 
27 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
28 
29 pragma solidity ^0.8.0;
30 
31 /**
32  * @dev Required interface of an ERC721 compliant contract.
33  */
34 interface IERC721 is IERC165 {
35     /**
36      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
37      */
38     event Transfer(
39         address indexed from,
40         address indexed to,
41         uint256 indexed tokenId
42     );
43 
44     /**
45      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
46      */
47     event Approval(
48         address indexed owner,
49         address indexed approved,
50         uint256 indexed tokenId
51     );
52 
53     /**
54      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
55      */
56     event ApprovalForAll(
57         address indexed owner,
58         address indexed operator,
59         bool approved
60     );
61 
62     /**
63      * @dev Returns the number of tokens in ``owner``'s account.
64      */
65     function balanceOf(address owner) external view returns (uint256 balance);
66 
67     /**
68      * @dev Returns the owner of the `tokenId` token.
69      *
70      * Requirements:
71      *
72      * - `tokenId` must exist.
73      */
74     function ownerOf(uint256 tokenId) external view returns (address owner);
75 
76     /**
77      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
78      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
79      *
80      * Requirements:
81      *
82      * - `from` cannot be the zero address.
83      * - `to` cannot be the zero address.
84      * - `tokenId` token must exist and be owned by `from`.
85      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
86      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
87      *
88      * Emits a {Transfer} event.
89      */
90     function safeTransferFrom(
91         address from,
92         address to,
93         uint256 tokenId
94     ) external;
95 
96     /**
97      * @dev Transfers `tokenId` token from `from` to `to`.
98      *
99      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
100      *
101      * Requirements:
102      *
103      * - `from` cannot be the zero address.
104      * - `to` cannot be the zero address.
105      * - `tokenId` token must be owned by `from`.
106      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
107      *
108      * Emits a {Transfer} event.
109      */
110     function transferFrom(
111         address from,
112         address to,
113         uint256 tokenId
114     ) external;
115 
116     /**
117      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
118      * The approval is cleared when the token is transferred.
119      *
120      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
121      *
122      * Requirements:
123      *
124      * - The caller must own the token or be an approved operator.
125      * - `tokenId` must exist.
126      *
127      * Emits an {Approval} event.
128      */
129     function approve(address to, uint256 tokenId) external;
130 
131     /**
132      * @dev Returns the account approved for `tokenId` token.
133      *
134      * Requirements:
135      *
136      * - `tokenId` must exist.
137      */
138     function getApproved(uint256 tokenId)
139         external
140         view
141         returns (address operator);
142 
143     /**
144      * @dev Approve or remove `operator` as an operator for the caller.
145      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
146      *
147      * Requirements:
148      *
149      * - The `operator` cannot be the caller.
150      *
151      * Emits an {ApprovalForAll} event.
152      */
153     function setApprovalForAll(address operator, bool _approved) external;
154 
155     /**
156      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
157      *
158      * See {setApprovalForAll}
159      */
160     function isApprovedForAll(address owner, address operator)
161         external
162         view
163         returns (bool);
164 
165     /**
166      * @dev Safely transfers `tokenId` token from `from` to `to`.
167      *
168      * Requirements:
169      *
170      * - `from` cannot be the zero address.
171      * - `to` cannot be the zero address.
172      * - `tokenId` token must exist and be owned by `from`.
173      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
174      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
175      *
176      * Emits a {Transfer} event.
177      */
178     function safeTransferFrom(
179         address from,
180         address to,
181         uint256 tokenId,
182         bytes calldata data
183     ) external;
184 }
185 
186 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
187 
188 pragma solidity ^0.8.0;
189 
190 /**
191  * @title ERC721 token receiver interface
192  * @dev Interface for any contract that wants to support safeTransfers
193  * from ERC721 asset contracts.
194  */
195 interface IERC721Receiver {
196     /**
197      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
198      * by `operator` from `from`, this function is called.
199      *
200      * It must return its Solidity selector to confirm the token transfer.
201      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
202      *
203      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
204      */
205     function onERC721Received(
206         address operator,
207         address from,
208         uint256 tokenId,
209         bytes calldata data
210     ) external returns (bytes4);
211 }
212 
213 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
214 
215 pragma solidity ^0.8.0;
216 
217 /**
218  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
219  * @dev See https://eips.ethereum.org/EIPS/eip-721
220  */
221 interface IERC721Metadata is IERC721 {
222     /**
223      * @dev Returns the token collection name.
224      */
225     function name() external view returns (string memory);
226 
227     /**
228      * @dev Returns the token collection symbol.
229      */
230     function symbol() external view returns (string memory);
231 
232     /**
233      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
234      */
235     function tokenURI(uint256 tokenId) external view returns (string memory);
236 }
237 
238 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
239 
240 pragma solidity ^0.8.0;
241 
242 /**
243  * @dev Implementation of the {IERC165} interface.
244  *
245  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
246  * for the additional interface id that will be supported. For example:
247  *
248  * ```solidity
249  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
250  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
251  * }
252  * ```
253  *
254  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
255  */
256 abstract contract ERC165 is IERC165 {
257     /**
258      * @dev See {IERC165-supportsInterface}.
259      */
260     function supportsInterface(bytes4 interfaceId)
261         public
262         view
263         virtual
264         override
265         returns (bool)
266     {
267         return interfaceId == type(IERC165).interfaceId;
268     }
269 }
270 
271 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
272 
273 pragma solidity ^0.8.0;
274 
275 /**
276  * @dev Collection of functions related to the address type
277  */
278 library Address {
279     /**
280      * @dev Returns true if `account` is a contract.
281      *
282      * [IMPORTANT]
283      * ====
284      * It is unsafe to assume that an address for which this function returns
285      * false is an externally-owned account (EOA) and not a contract.
286      *
287      * Among others, `isContract` will return false for the following
288      * types of addresses:
289      *
290      *  - an externally-owned account
291      *  - a contract in construction
292      *  - an address where a contract will be created
293      *  - an address where a contract lived, but was destroyed
294      * ====
295      */
296     function isContract(address account) internal view returns (bool) {
297         // This method relies on extcodesize, which returns 0 for contracts in
298         // construction, since the code is only stored at the end of the
299         // constructor execution.
300 
301         uint256 size;
302         assembly {
303             size := extcodesize(account)
304         }
305         return size > 0;
306     }
307 
308     /**
309      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
310      * `recipient`, forwarding all available gas and reverting on errors.
311      *
312      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
313      * of certain opcodes, possibly making contracts go over the 2300 gas limit
314      * imposed by `transfer`, making them unable to receive funds via
315      * `transfer`. {sendValue} removes this limitation.
316      *
317      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
318      *
319      * IMPORTANT: because control is transferred to `recipient`, care must be
320      * taken to not create reentrancy vulnerabilities. Consider using
321      * {ReentrancyGuard} or the
322      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
323      */
324     function sendValue(address payable recipient, uint256 amount) internal {
325         require(
326             address(this).balance >= amount,
327             "Address: insufficient balance"
328         );
329 
330         (bool success, ) = recipient.call{value: amount}("");
331         require(
332             success,
333             "Address: unable to send value, recipient may have reverted"
334         );
335     }
336 
337     /**
338      * @dev Performs a Solidity function call using a low level `call`. A
339      * plain `call` is an unsafe replacement for a function call: use this
340      * function instead.
341      *
342      * If `target` reverts with a revert reason, it is bubbled up by this
343      * function (like regular Solidity function calls).
344      *
345      * Returns the raw returned data. To convert to the expected return value,
346      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
347      *
348      * Requirements:
349      *
350      * - `target` must be a contract.
351      * - calling `target` with `data` must not revert.
352      *
353      * _Available since v3.1._
354      */
355     function functionCall(address target, bytes memory data)
356         internal
357         returns (bytes memory)
358     {
359         return functionCall(target, data, "Address: low-level call failed");
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
364      * `errorMessage` as a fallback revert reason when `target` reverts.
365      *
366      * _Available since v3.1._
367      */
368     function functionCall(
369         address target,
370         bytes memory data,
371         string memory errorMessage
372     ) internal returns (bytes memory) {
373         return functionCallWithValue(target, data, 0, errorMessage);
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
378      * but also transferring `value` wei to `target`.
379      *
380      * Requirements:
381      *
382      * - the calling contract must have an ETH balance of at least `value`.
383      * - the called Solidity function must be `payable`.
384      *
385      * _Available since v3.1._
386      */
387     function functionCallWithValue(
388         address target,
389         bytes memory data,
390         uint256 value
391     ) internal returns (bytes memory) {
392         return
393             functionCallWithValue(
394                 target,
395                 data,
396                 value,
397                 "Address: low-level call with value failed"
398             );
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
403      * with `errorMessage` as a fallback revert reason when `target` reverts.
404      *
405      * _Available since v3.1._
406      */
407     function functionCallWithValue(
408         address target,
409         bytes memory data,
410         uint256 value,
411         string memory errorMessage
412     ) internal returns (bytes memory) {
413         require(
414             address(this).balance >= value,
415             "Address: insufficient balance for call"
416         );
417         require(isContract(target), "Address: call to non-contract");
418 
419         (bool success, bytes memory returndata) = target.call{value: value}(
420             data
421         );
422         return verifyCallResult(success, returndata, errorMessage);
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
427      * but performing a static call.
428      *
429      * _Available since v3.3._
430      */
431     function functionStaticCall(address target, bytes memory data)
432         internal
433         view
434         returns (bytes memory)
435     {
436         return
437             functionStaticCall(
438                 target,
439                 data,
440                 "Address: low-level static call failed"
441             );
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
446      * but performing a static call.
447      *
448      * _Available since v3.3._
449      */
450     function functionStaticCall(
451         address target,
452         bytes memory data,
453         string memory errorMessage
454     ) internal view returns (bytes memory) {
455         require(isContract(target), "Address: static call to non-contract");
456 
457         (bool success, bytes memory returndata) = target.staticcall(data);
458         return verifyCallResult(success, returndata, errorMessage);
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
463      * but performing a delegate call.
464      *
465      * _Available since v3.4._
466      */
467     function functionDelegateCall(address target, bytes memory data)
468         internal
469         returns (bytes memory)
470     {
471         return
472             functionDelegateCall(
473                 target,
474                 data,
475                 "Address: low-level delegate call failed"
476             );
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
481      * but performing a delegate call.
482      *
483      * _Available since v3.4._
484      */
485     function functionDelegateCall(
486         address target,
487         bytes memory data,
488         string memory errorMessage
489     ) internal returns (bytes memory) {
490         require(isContract(target), "Address: delegate call to non-contract");
491 
492         (bool success, bytes memory returndata) = target.delegatecall(data);
493         return verifyCallResult(success, returndata, errorMessage);
494     }
495 
496     /**
497      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
498      * revert reason using the provided one.
499      *
500      * _Available since v4.3._
501      */
502     function verifyCallResult(
503         bool success,
504         bytes memory returndata,
505         string memory errorMessage
506     ) internal pure returns (bytes memory) {
507         if (success) {
508             return returndata;
509         } else {
510             // Look for revert reason and bubble it up if present
511             if (returndata.length > 0) {
512                 // The easiest way to bubble the revert reason is using memory via assembly
513 
514                 assembly {
515                     let returndata_size := mload(returndata)
516                     revert(add(32, returndata), returndata_size)
517                 }
518             } else {
519                 revert(errorMessage);
520             }
521         }
522     }
523 }
524 
525 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
526 
527 pragma solidity ^0.8.0;
528 
529 /**
530  * @dev Provides information about the current execution context, including the
531  * sender of the transaction and its data. While these are generally available
532  * via msg.sender and msg.data, they should not be accessed in such a direct
533  * manner, since when dealing with meta-transactions the account sending and
534  * paying for execution may not be the actual sender (as far as an application
535  * is concerned).
536  *
537  * This contract is only required for intermediate, library-like contracts.
538  */
539 abstract contract Context {
540     function _msgSender() internal view virtual returns (address) {
541         return msg.sender;
542     }
543 
544     function _msgData() internal view virtual returns (bytes calldata) {
545         return msg.data;
546     }
547 }
548 
549 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
550 
551 pragma solidity ^0.8.0;
552 
553 /**
554  * @dev String operations.
555  */
556 library Strings {
557     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
558 
559     /**
560      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
561      */
562     function toString(uint256 value) internal pure returns (string memory) {
563         // Inspired by OraclizeAPI's implementation - MIT licence
564         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
565 
566         if (value == 0) {
567             return "0";
568         }
569         uint256 temp = value;
570         uint256 digits;
571         while (temp != 0) {
572             digits++;
573             temp /= 10;
574         }
575         bytes memory buffer = new bytes(digits);
576         while (value != 0) {
577             digits -= 1;
578             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
579             value /= 10;
580         }
581         return string(buffer);
582     }
583 
584     /**
585      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
586      */
587     function toHexString(uint256 value) internal pure returns (string memory) {
588         if (value == 0) {
589             return "0x00";
590         }
591         uint256 temp = value;
592         uint256 length = 0;
593         while (temp != 0) {
594             length++;
595             temp >>= 8;
596         }
597         return toHexString(value, length);
598     }
599 
600     /**
601      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
602      */
603     function toHexString(uint256 value, uint256 length)
604         internal
605         pure
606         returns (string memory)
607     {
608         bytes memory buffer = new bytes(2 * length + 2);
609         buffer[0] = "0";
610         buffer[1] = "x";
611         for (uint256 i = 2 * length + 1; i > 1; --i) {
612             buffer[i] = _HEX_SYMBOLS[value & 0xf];
613             value >>= 4;
614         }
615         require(value == 0, "Strings: hex length insufficient");
616         return string(buffer);
617     }
618 }
619 
620 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
621 
622 pragma solidity ^0.8.0;
623 
624 /**
625  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
626  * @dev See https://eips.ethereum.org/EIPS/eip-721
627  */
628 interface IERC721Enumerable is IERC721 {
629     /**
630      * @dev Returns the total amount of tokens stored by the contract.
631      */
632     function totalSupply() external view returns (uint256);
633 
634     /**
635      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
636      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
637      */
638     function tokenOfOwnerByIndex(address owner, uint256 index)
639         external
640         view
641         returns (uint256 tokenId);
642 
643     /**
644      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
645      * Use along with {totalSupply} to enumerate all tokens.
646      */
647     function tokenByIndex(uint256 index) external view returns (uint256);
648 }
649 
650 pragma solidity ^0.8.0;
651 
652 /**
653  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
654  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
655  *
656  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
657  *
658  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
659  *
660  * Does not support burning tokens to address(0).
661  */
662 contract ERC721A is
663   Context,
664   ERC165,
665   IERC721,
666   IERC721Metadata,
667   IERC721Enumerable
668 {
669   using Address for address;
670   using Strings for uint256;
671 
672   struct TokenOwnership {
673     address addr;
674     uint64 startTimestamp;
675   }
676 
677   struct AddressData {
678     uint128 balance;
679     uint128 numberMinted;
680   }
681 
682   uint256 private currentIndex = 0;
683 
684   uint256 internal immutable collectionSize;
685   uint256 internal immutable maxBatchSize;
686 
687   // Token name
688   string private _name;
689 
690   // Token symbol
691   string private _symbol;
692 
693   // Mapping from token ID to ownership details
694   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
695   mapping(uint256 => TokenOwnership) private _ownerships;
696 
697   // Mapping owner address to address data
698   mapping(address => AddressData) private _addressData;
699 
700   // Mapping from token ID to approved address
701   mapping(uint256 => address) private _tokenApprovals;
702 
703   // Mapping from owner to operator approvals
704   mapping(address => mapping(address => bool)) private _operatorApprovals;
705 
706   /**
707    * @dev
708    * `maxBatchSize` refers to how much a minter can mint at a time.
709    * `collectionSize_` refers to how many tokens are in the collection.
710    */
711   constructor(
712     string memory name_,
713     string memory symbol_,
714     uint256 maxBatchSize_,
715     uint256 collectionSize_
716   ) {
717     require(
718       collectionSize_ > 0,
719       "ERC721A: collection must have a nonzero supply"
720     );
721     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
722     _name = name_;
723     _symbol = symbol_;
724     maxBatchSize = maxBatchSize_;
725     collectionSize = collectionSize_;
726   }
727 
728   /**
729    * @dev See {IERC721Enumerable-totalSupply}.
730    */
731   function totalSupply() public view override returns (uint256) {
732     return currentIndex;
733   }
734 
735   /**
736    * @dev See {IERC721Enumerable-tokenByIndex}.
737    */
738   function tokenByIndex(uint256 index) public view override returns (uint256) {
739     require(index < totalSupply(), "ERC721A: global index out of bounds");
740     return index;
741   }
742 
743   /**
744    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
745    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
746    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
747    */
748   function tokenOfOwnerByIndex(address owner, uint256 index)
749     public
750     view
751     override
752     returns (uint256)
753   {
754     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
755     uint256 numMintedSoFar = totalSupply();
756     uint256 tokenIdsIdx = 0;
757     address currOwnershipAddr = address(0);
758     for (uint256 i = 0; i < numMintedSoFar; i++) {
759       TokenOwnership memory ownership = _ownerships[i];
760       if (ownership.addr != address(0)) {
761         currOwnershipAddr = ownership.addr;
762       }
763       if (currOwnershipAddr == owner) {
764         if (tokenIdsIdx == index) {
765           return i;
766         }
767         tokenIdsIdx++;
768       }
769     }
770     revert("ERC721A: unable to get token of owner by index");
771   }
772 
773   /**
774    * @dev See {IERC165-supportsInterface}.
775    */
776   function supportsInterface(bytes4 interfaceId)
777     public
778     view
779     virtual
780     override(ERC165, IERC165)
781     returns (bool)
782   {
783     return
784       interfaceId == type(IERC721).interfaceId ||
785       interfaceId == type(IERC721Metadata).interfaceId ||
786       interfaceId == type(IERC721Enumerable).interfaceId ||
787       super.supportsInterface(interfaceId);
788   }
789 
790   /**
791    * @dev See {IERC721-balanceOf}.
792    */
793   function balanceOf(address owner) public view override returns (uint256) {
794     require(owner != address(0), "ERC721A: balance query for the zero address");
795     return uint256(_addressData[owner].balance);
796   }
797 
798   function _numberMinted(address owner) internal view returns (uint256) {
799     require(
800       owner != address(0),
801       "ERC721A: number minted query for the zero address"
802     );
803     return uint256(_addressData[owner].numberMinted);
804   }
805 
806   function ownershipOf(uint256 tokenId)
807     internal
808     view
809     returns (TokenOwnership memory)
810   {
811     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
812 
813     uint256 lowestTokenToCheck;
814     if (tokenId >= maxBatchSize) {
815       lowestTokenToCheck = tokenId - maxBatchSize + 1;
816     }
817 
818     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
819       TokenOwnership memory ownership = _ownerships[curr];
820       if (ownership.addr != address(0)) {
821         return ownership;
822       }
823     }
824 
825     revert("ERC721A: unable to determine the owner of token");
826   }
827 
828   /**
829    * @dev See {IERC721-ownerOf}.
830    */
831   function ownerOf(uint256 tokenId) public view override returns (address) {
832     return ownershipOf(tokenId).addr;
833   }
834 
835   /**
836    * @dev See {IERC721Metadata-name}.
837    */
838   function name() public view virtual override returns (string memory) {
839     return _name;
840   }
841 
842   /**
843    * @dev See {IERC721Metadata-symbol}.
844    */
845   function symbol() public view virtual override returns (string memory) {
846     return _symbol;
847   }
848 
849   /**
850    * @dev See {IERC721Metadata-tokenURI}.
851    */
852   function tokenURI(uint256 tokenId)
853     public
854     view
855     virtual
856     override
857     returns (string memory)
858   {
859     require(
860       _exists(tokenId),
861       "ERC721Metadata: URI query for nonexistent token"
862     );
863 
864     string memory baseURI = _baseURI();
865     return
866       bytes(baseURI).length > 0
867         ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
868         : "";
869   }
870 
871   /**
872    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
873    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
874    * by default, can be overriden in child contracts.
875    */
876   function _baseURI() internal view virtual returns (string memory) {
877     return "";
878   }
879 
880   /**
881    * @dev See {IERC721-approve}.
882    */
883   function approve(address to, uint256 tokenId) public override {
884     address owner = ERC721A.ownerOf(tokenId);
885     require(to != owner, "ERC721A: approval to current owner");
886 
887     require(
888       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
889       "ERC721A: approve caller is not owner nor approved for all"
890     );
891 
892     _approve(to, tokenId, owner);
893   }
894 
895   /**
896    * @dev See {IERC721-getApproved}.
897    */
898   function getApproved(uint256 tokenId) public view override returns (address) {
899     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
900 
901     return _tokenApprovals[tokenId];
902   }
903 
904   /**
905    * @dev See {IERC721-setApprovalForAll}.
906    */
907   function setApprovalForAll(address operator, bool approved) public override {
908     require(operator != _msgSender(), "ERC721A: approve to caller");
909 
910     _operatorApprovals[_msgSender()][operator] = approved;
911     emit ApprovalForAll(_msgSender(), operator, approved);
912   }
913 
914   /**
915    * @dev See {IERC721-isApprovedForAll}.
916    */
917   function isApprovedForAll(address owner, address operator)
918     public
919     view
920     virtual
921     override
922     returns (bool)
923   {
924     return _operatorApprovals[owner][operator];
925   }
926 
927   /**
928    * @dev See {IERC721-transferFrom}.
929    */
930   function transferFrom(
931     address from,
932     address to,
933     uint256 tokenId
934   ) public override {
935     _transfer(from, to, tokenId);
936   }
937 
938   /**
939    * @dev See {IERC721-safeTransferFrom}.
940    */
941   function safeTransferFrom(
942     address from,
943     address to,
944     uint256 tokenId
945   ) public override {
946     safeTransferFrom(from, to, tokenId, "");
947   }
948 
949   /**
950    * @dev See {IERC721-safeTransferFrom}.
951    */
952   function safeTransferFrom(
953     address from,
954     address to,
955     uint256 tokenId,
956     bytes memory _data
957   ) public override {
958     _transfer(from, to, tokenId);
959     require(
960       _checkOnERC721Received(from, to, tokenId, _data),
961       "ERC721A: transfer to non ERC721Receiver implementer"
962     );
963   }
964 
965   /**
966    * @dev Returns whether `tokenId` exists.
967    *
968    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
969    *
970    * Tokens start existing when they are minted (`_mint`),
971    */
972   function _exists(uint256 tokenId) internal view returns (bool) {
973     return tokenId < currentIndex;
974   }
975 
976   function _safeMint(address to, uint256 quantity) internal {
977     _safeMint(to, quantity, "");
978   }
979 
980   /**
981    * @dev Mints `quantity` tokens and transfers them to `to`.
982    *
983    * Requirements:
984    *
985    * - there must be `quantity` tokens remaining unminted in the total collection.
986    * - `to` cannot be the zero address.
987    * - `quantity` cannot be larger than the max batch size.
988    *
989    * Emits a {Transfer} event.
990    */
991   function _safeMint(
992     address to,
993     uint256 quantity,
994     bytes memory _data
995   ) internal {
996     uint256 startTokenId = currentIndex;
997     require(to != address(0), "ERC721A: mint to the zero address");
998     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
999     require(!_exists(startTokenId), "ERC721A: token already minted");
1000     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1001 
1002     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1003 
1004     AddressData memory addressData = _addressData[to];
1005     _addressData[to] = AddressData(
1006       addressData.balance + uint128(quantity),
1007       addressData.numberMinted + uint128(quantity)
1008     );
1009     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1010 
1011     uint256 updatedIndex = startTokenId;
1012 
1013     for (uint256 i = 0; i < quantity; i++) {
1014       emit Transfer(address(0), to, updatedIndex);
1015       require(
1016         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1017         "ERC721A: transfer to non ERC721Receiver implementer"
1018       );
1019       updatedIndex++;
1020     }
1021 
1022     currentIndex = updatedIndex;
1023     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1024   }
1025 
1026   /**
1027    * @dev Transfers `tokenId` from `from` to `to`.
1028    *
1029    * Requirements:
1030    *
1031    * - `to` cannot be the zero address.
1032    * - `tokenId` token must be owned by `from`.
1033    *
1034    * Emits a {Transfer} event.
1035    */
1036   function _transfer(
1037     address from,
1038     address to,
1039     uint256 tokenId
1040   ) private {
1041     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1042 
1043     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1044       getApproved(tokenId) == _msgSender() ||
1045       isApprovedForAll(prevOwnership.addr, _msgSender()));
1046 
1047     require(
1048       isApprovedOrOwner,
1049       "ERC721A: transfer caller is not owner nor approved"
1050     );
1051 
1052     require(
1053       prevOwnership.addr == from,
1054       "ERC721A: transfer from incorrect owner"
1055     );
1056     require(to != address(0), "ERC721A: transfer to the zero address");
1057 
1058     _beforeTokenTransfers(from, to, tokenId, 1);
1059 
1060     // Clear approvals from the previous owner
1061     _approve(address(0), tokenId, prevOwnership.addr);
1062 
1063     _addressData[from].balance -= 1;
1064     _addressData[to].balance += 1;
1065     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1066 
1067     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1068     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1069     uint256 nextTokenId = tokenId + 1;
1070     if (_ownerships[nextTokenId].addr == address(0)) {
1071       if (_exists(nextTokenId)) {
1072         _ownerships[nextTokenId] = TokenOwnership(
1073           prevOwnership.addr,
1074           prevOwnership.startTimestamp
1075         );
1076       }
1077     }
1078 
1079     emit Transfer(from, to, tokenId);
1080     _afterTokenTransfers(from, to, tokenId, 1);
1081   }
1082 
1083   /**
1084    * @dev Approve `to` to operate on `tokenId`
1085    *
1086    * Emits a {Approval} event.
1087    */
1088   function _approve(
1089     address to,
1090     uint256 tokenId,
1091     address owner
1092   ) private {
1093     _tokenApprovals[tokenId] = to;
1094     emit Approval(owner, to, tokenId);
1095   }
1096 
1097   uint256 public nextOwnerToExplicitlySet = 0;
1098 
1099   /**
1100    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1101    */
1102   function _setOwnersExplicit(uint256 quantity) internal {
1103     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1104     require(quantity > 0, "quantity must be nonzero");
1105     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1106     if (endIndex > collectionSize - 1) {
1107       endIndex = collectionSize - 1;
1108     }
1109     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1110     require(_exists(endIndex), "not enough minted yet for this cleanup");
1111     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1112       if (_ownerships[i].addr == address(0)) {
1113         TokenOwnership memory ownership = ownershipOf(i);
1114         _ownerships[i] = TokenOwnership(
1115           ownership.addr,
1116           ownership.startTimestamp
1117         );
1118       }
1119     }
1120     nextOwnerToExplicitlySet = endIndex + 1;
1121   }
1122 
1123   /**
1124    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1125    * The call is not executed if the target address is not a contract.
1126    *
1127    * @param from address representing the previous owner of the given token ID
1128    * @param to target address that will receive the tokens
1129    * @param tokenId uint256 ID of the token to be transferred
1130    * @param _data bytes optional data to send along with the call
1131    * @return bool whether the call correctly returned the expected magic value
1132    */
1133   function _checkOnERC721Received(
1134     address from,
1135     address to,
1136     uint256 tokenId,
1137     bytes memory _data
1138   ) private returns (bool) {
1139     if (to.isContract()) {
1140       try
1141         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1142       returns (bytes4 retval) {
1143         return retval == IERC721Receiver(to).onERC721Received.selector;
1144       } catch (bytes memory reason) {
1145         if (reason.length == 0) {
1146           revert("ERC721A: transfer to non ERC721Receiver implementer");
1147         } else {
1148           assembly {
1149             revert(add(32, reason), mload(reason))
1150           }
1151         }
1152       }
1153     } else {
1154       return true;
1155     }
1156   }
1157 
1158   /**
1159    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1160    *
1161    * startTokenId - the first token id to be transferred
1162    * quantity - the amount to be transferred
1163    *
1164    * Calling conditions:
1165    *
1166    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1167    * transferred to `to`.
1168    * - When `from` is zero, `tokenId` will be minted for `to`.
1169    */
1170   function _beforeTokenTransfers(
1171     address from,
1172     address to,
1173     uint256 startTokenId,
1174     uint256 quantity
1175   ) internal virtual {}
1176 
1177   /**
1178    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1179    * minting.
1180    *
1181    * startTokenId - the first token id to be transferred
1182    * quantity - the amount to be transferred
1183    *
1184    * Calling conditions:
1185    *
1186    * - when `from` and `to` are both non-zero.
1187    * - `from` and `to` are never both zero.
1188    */
1189   function _afterTokenTransfers(
1190     address from,
1191     address to,
1192     uint256 startTokenId,
1193     uint256 quantity
1194   ) internal virtual {}
1195 }
1196 
1197 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1198 
1199 pragma solidity ^0.8.0;
1200 
1201 /**
1202  * @dev Contract module which provides a basic access control mechanism, where
1203  * there is an account (an owner) that can be granted exclusive access to
1204  * specific functions.
1205  *
1206  * By default, the owner account will be the one that deploys the contract. This
1207  * can later be changed with {transferOwnership}.
1208  *
1209  * This module is used through inheritance. It will make available the modifier
1210  * `onlyOwner`, which can be applied to your functions to restrict their use to
1211  * the owner.
1212  */
1213 abstract contract Ownable is Context {
1214     address private _owner;
1215 
1216     event OwnershipTransferred(
1217         address indexed previousOwner,
1218         address indexed newOwner
1219     );
1220 
1221     /**
1222      * @dev Initializes the contract setting the deployer as the initial owner.
1223      */
1224     constructor() {
1225         _transferOwnership(_msgSender());
1226     }
1227 
1228     /**
1229      * @dev Returns the address of the current owner.
1230      */
1231     function owner() public view virtual returns (address) {
1232         return _owner;
1233     }
1234 
1235     /**
1236      * @dev Throws if called by any account other than the owner.
1237      */
1238     modifier onlyOwner() {
1239         require(owner() == _msgSender(), "You are not the owner");
1240         _;
1241     }
1242 
1243     /**
1244      * @dev Leaves the contract without owner. It will not be possible to call
1245      * `onlyOwner` functions anymore. Can only be called by the current owner.
1246      *
1247      * NOTE: Renouncing ownership will leave the contract without an owner,
1248      * thereby removing any functionality that is only available to the owner.
1249      */
1250     function renounceOwnership() public virtual onlyOwner {
1251         _transferOwnership(address(0));
1252     }
1253 
1254     /**
1255      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1256      * Can only be called by the current owner.
1257      */
1258     function transferOwnership(address newOwner) public virtual onlyOwner {
1259         require(
1260             newOwner != address(0),
1261             "Ownable: new owner is the zero address"
1262         );
1263         _transferOwnership(newOwner);
1264     }
1265 
1266     /**
1267      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1268      * Internal function without access restriction.
1269      */
1270     function _transferOwnership(address newOwner) internal virtual {
1271         address oldOwner = _owner;
1272         _owner = newOwner;
1273         emit OwnershipTransferred(oldOwner, newOwner);
1274     }
1275 }
1276 
1277 
1278 pragma solidity ^0.8.0;
1279 
1280 contract LadyApes is ERC721A, Ownable {
1281     uint256 public NFT_PRICE = 0 ether;
1282     uint256 public MAX_SUPPLY = 4444;
1283     uint256 public MAX_MINTS = 275;
1284     string public baseURI = "https://bafybeid6d53ar43q3ozzcnb35cgbr3yuadgdu3ftybamvh6actj5rc6zga.ipfs.dweb.link/";
1285     string public baseExtension = ".json";
1286      bool public paused = true;   
1287     
1288     constructor() ERC721A("LADY APES", "LAPES", MAX_MINTS, MAX_SUPPLY) {  
1289         _safeMint(_msgSender(), 1);
1290     }
1291     
1292 
1293     function FreeMint(uint256 numTokens) public payable {
1294         require(!paused, "Paused");
1295         require(numTokens <= 4 && numTokens >0);
1296         _safeMint(msg.sender, numTokens);
1297     }
1298 
1299     function TopMint(uint256 numTokens) public payable onlyOwner {
1300         _safeMint(msg.sender, numTokens);
1301     }
1302 
1303 
1304     function pause(bool _state) public onlyOwner {
1305         paused = _state;
1306     }
1307 
1308     function setBaseURI(string memory newBaseURI) public onlyOwner {
1309         baseURI = newBaseURI;
1310     }
1311     function tokenURI(uint256 _tokenId)
1312         public
1313         view
1314         override
1315         returns (string memory)
1316     {
1317         require(_exists(_tokenId), "That token doesn't exist");
1318         return
1319             bytes(baseURI).length > 0
1320                 ? string(
1321                     abi.encodePacked(
1322                         baseURI,
1323                         Strings.toString(_tokenId),
1324                         baseExtension
1325                     )
1326                 )
1327                 : "";
1328     }
1329 
1330     function _baseURI() internal view virtual override returns (string memory) {
1331         return baseURI;
1332     }
1333 }