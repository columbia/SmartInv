1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 
27 pragma solidity ^0.8.0;
28 
29 
30 /**
31  * @dev Implementation of the {IERC165} interface.
32  *
33  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
34  * for the additional interface id that will be supported. For example:
35  *
36  * ```solidity
37  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
38  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
39  * }
40  * ```
41  *
42  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
43  */
44 abstract contract ERC165 is IERC165 {
45     /**
46      * @dev See {IERC165-supportsInterface}.
47      */
48     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
49         return interfaceId == type(IERC165).interfaceId;
50     }
51 }
52 
53 
54 pragma solidity ^0.8.0;
55 
56 /**
57  * @dev Collection of functions related to the address type
58  */
59 library Address {
60     /**
61      * @dev Returns true if `account` is a contract.
62      *
63      * [IMPORTANT]
64      * ====
65      * It is unsafe to assume that an address for which this function returns
66      * false is an externally-owned account (EOA) and not a contract.
67      *
68      * Among others, `isContract` will return false for the following
69      * types of addresses:
70      *
71      *  - an externally-owned account
72      *  - a contract in construction
73      *  - an address where a contract will be created
74      *  - an address where a contract lived, but was destroyed
75      * ====
76      */
77     function isContract(address account) internal view returns (bool) {
78         // This method relies on extcodesize, which returns 0 for contracts in
79         // construction, since the code is only stored at the end of the
80         // constructor execution.
81 
82         uint256 size;
83         assembly {
84             size := extcodesize(account)
85         }
86         return size > 0;
87     }
88 
89     /**
90      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
91      * `recipient`, forwarding all available gas and reverting on errors.
92      *
93      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
94      * of certain opcodes, possibly making contracts go over the 2300 gas limit
95      * imposed by `transfer`, making them unable to receive funds via
96      * `transfer`. {sendValue} removes this limitation.
97      *
98      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
99      *
100      * IMPORTANT: because control is transferred to `recipient`, care must be
101      * taken to not create reentrancy vulnerabilities. Consider using
102      * {ReentrancyGuard} or the
103      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
104      */
105     function sendValue(address payable recipient, uint256 amount) internal {
106         require(address(this).balance >= amount, "Address: insufficient balance");
107 
108         (bool success, ) = recipient.call{value: amount}("");
109         require(success, "Address: unable to send value, recipient may have reverted");
110     }
111 
112     /**
113      * @dev Performs a Solidity function call using a low level `call`. A
114      * plain `call` is an unsafe replacement for a function call: use this
115      * function instead.
116      *
117      * If `target` reverts with a revert reason, it is bubbled up by this
118      * function (like regular Solidity function calls).
119      *
120      * Returns the raw returned data. To convert to the expected return value,
121      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
122      *
123      * Requirements:
124      *
125      * - `target` must be a contract.
126      * - calling `target` with `data` must not revert.
127      *
128      * _Available since v3.1._
129      */
130     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
131         return functionCall(target, data, "Address: low-level call failed");
132     }
133 
134     /**
135      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
136      * `errorMessage` as a fallback revert reason when `target` reverts.
137      *
138      * _Available since v3.1._
139      */
140     function functionCall(
141         address target,
142         bytes memory data,
143         string memory errorMessage
144     ) internal returns (bytes memory) {
145         return functionCallWithValue(target, data, 0, errorMessage);
146     }
147 
148     /**
149      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
150      * but also transferring `value` wei to `target`.
151      *
152      * Requirements:
153      *
154      * - the calling contract must have an ETH balance of at least `value`.
155      * - the called Solidity function must be `payable`.
156      *
157      * _Available since v3.1._
158      */
159     function functionCallWithValue(
160         address target,
161         bytes memory data,
162         uint256 value
163     ) internal returns (bytes memory) {
164         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
165     }
166 
167     /**
168      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
169      * with `errorMessage` as a fallback revert reason when `target` reverts.
170      *
171      * _Available since v3.1._
172      */
173     function functionCallWithValue(
174         address target,
175         bytes memory data,
176         uint256 value,
177         string memory errorMessage
178     ) internal returns (bytes memory) {
179         require(address(this).balance >= value, "Address: insufficient balance for call");
180         require(isContract(target), "Address: call to non-contract");
181 
182         (bool success, bytes memory returndata) = target.call{value: value}(data);
183         return _verifyCallResult(success, returndata, errorMessage);
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
188      * but performing a static call.
189      *
190      * _Available since v3.3._
191      */
192     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
193         return functionStaticCall(target, data, "Address: low-level static call failed");
194     }
195 
196     /**
197      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
198      * but performing a static call.
199      *
200      * _Available since v3.3._
201      */
202     function functionStaticCall(
203         address target,
204         bytes memory data,
205         string memory errorMessage
206     ) internal view returns (bytes memory) {
207         require(isContract(target), "Address: static call to non-contract");
208 
209         (bool success, bytes memory returndata) = target.staticcall(data);
210         return _verifyCallResult(success, returndata, errorMessage);
211     }
212 
213     /**
214      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
215      * but performing a delegate call.
216      *
217      * _Available since v3.4._
218      */
219     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
220         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
221     }
222 
223     /**
224      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
225      * but performing a delegate call.
226      *
227      * _Available since v3.4._
228      */
229     function functionDelegateCall(
230         address target,
231         bytes memory data,
232         string memory errorMessage
233     ) internal returns (bytes memory) {
234         require(isContract(target), "Address: delegate call to non-contract");
235 
236         (bool success, bytes memory returndata) = target.delegatecall(data);
237         return _verifyCallResult(success, returndata, errorMessage);
238     }
239 
240     function _verifyCallResult(
241         bool success,
242         bytes memory returndata,
243         string memory errorMessage
244     ) private pure returns (bytes memory) {
245         if (success) {
246             return returndata;
247         } else {
248             // Look for revert reason and bubble it up if present
249             if (returndata.length > 0) {
250                 // The easiest way to bubble the revert reason is using memory via assembly
251 
252                 assembly {
253                     let returndata_size := mload(returndata)
254                     revert(add(32, returndata), returndata_size)
255                 }
256             } else {
257                 revert(errorMessage);
258             }
259         }
260     }
261 }
262 
263 
264 
265 
266 
267 
268 
269 
270 pragma solidity ^0.8.0;
271 
272 /**
273  * @title ERC721 token receiver interface
274  * @dev Interface for any contract that wants to support safeTransfers
275  * from ERC721 asset contracts.
276  */
277 interface IERC721Receiver {
278     /**
279      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
280      * by `operator` from `from`, this function is called.
281      *
282      * It must return its Solidity selector to confirm the token transfer.
283      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
284      *
285      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
286      */
287     function onERC721Received(
288         address operator,
289         address from,
290         uint256 tokenId,
291         bytes calldata data
292     ) external returns (bytes4);
293 }
294 
295 
296 
297 
298 pragma solidity ^0.8.0;
299 
300 
301 /**
302  * @dev Required interface of an ERC721 compliant contract.
303  */
304 interface IERC721 is IERC165 {
305     /**
306      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
307      */
308     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
309 
310     /**
311      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
312      */
313     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
314 
315     /**
316      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
317      */
318     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
319 
320     /**
321      * @dev Returns the number of tokens in ``owner``'s account.
322      */
323     function balanceOf(address owner) external view returns (uint256 balance);
324 
325     /**
326      * @dev Returns the owner of the `tokenId` token.
327      *
328      * Requirements:
329      *
330      * - `tokenId` must exist.
331      */
332     function ownerOf(uint256 tokenId) external view returns (address owner);
333 
334     /**
335      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
336      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
337      *
338      * Requirements:
339      *
340      * - `from` cannot be the zero address.
341      * - `to` cannot be the zero address.
342      * - `tokenId` token must exist and be owned by `from`.
343      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
344      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
345      *
346      * Emits a {Transfer} event.
347      */
348     function safeTransferFrom(
349         address from,
350         address to,
351         uint256 tokenId
352     ) external;
353 
354     /**
355      * @dev Transfers `tokenId` token from `from` to `to`.
356      *
357      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
358      *
359      * Requirements:
360      *
361      * - `from` cannot be the zero address.
362      * - `to` cannot be the zero address.
363      * - `tokenId` token must be owned by `from`.
364      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
365      *
366      * Emits a {Transfer} event.
367      */
368     function transferFrom(
369         address from,
370         address to,
371         uint256 tokenId
372     ) external;
373 
374     /**
375      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
376      * The approval is cleared when the token is transferred.
377      *
378      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
379      *
380      * Requirements:
381      *
382      * - The caller must own the token or be an approved operator.
383      * - `tokenId` must exist.
384      *
385      * Emits an {Approval} event.
386      */
387     function approve(address to, uint256 tokenId) external;
388 
389     /**
390      * @dev Returns the account approved for `tokenId` token.
391      *
392      * Requirements:
393      *
394      * - `tokenId` must exist.
395      */
396     function getApproved(uint256 tokenId) external view returns (address operator);
397 
398     /**
399      * @dev Approve or remove `operator` as an operator for the caller.
400      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
401      *
402      * Requirements:
403      *
404      * - The `operator` cannot be the caller.
405      *
406      * Emits an {ApprovalForAll} event.
407      */
408     function setApprovalForAll(address operator, bool _approved) external;
409 
410     /**
411      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
412      *
413      * See {setApprovalForAll}
414      */
415     function isApprovedForAll(address owner, address operator) external view returns (bool);
416 
417     /**
418      * @dev Safely transfers `tokenId` token from `from` to `to`.
419      *
420      * Requirements:
421      *
422      * - `from` cannot be the zero address.
423      * - `to` cannot be the zero address.
424      * - `tokenId` token must exist and be owned by `from`.
425      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
426      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
427      *
428      * Emits a {Transfer} event.
429      */
430     function safeTransferFrom(
431         address from,
432         address to,
433         uint256 tokenId,
434         bytes calldata data
435     ) external;
436 }
437 
438 
439 pragma solidity ^0.8.0;
440 
441 
442 /**
443  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
444  * @dev See https://eips.ethereum.org/EIPS/eip-721
445  */
446 interface IERC721Metadata is IERC721 {
447     /**
448      * @dev Returns the token collection name.
449      */
450     function name() external view returns (string memory);
451 
452     /**
453      * @dev Returns the token collection symbol.
454      */
455     function symbol() external view returns (string memory);
456 
457     /**
458      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
459      */
460     function tokenURI(uint256 tokenId) external view returns (string memory);
461 }
462 
463 
464 pragma solidity ^0.8.0;
465 
466 
467 /**
468  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
469  * @dev See https://eips.ethereum.org/EIPS/eip-721
470  */
471 interface IERC721Enumerable is IERC721 {
472     /**
473      * @dev Returns the total amount of tokens stored by the contract.
474      */
475     function totalSupply() external view returns (uint256);
476 
477     /**
478      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
479      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
480      */
481     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
482 
483     /**
484      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
485      * Use along with {totalSupply} to enumerate all tokens.
486      */
487     function tokenByIndex(uint256 index) external view returns (uint256);
488 }
489 
490 pragma solidity ^0.8.0;
491 
492 /*
493  * @dev Provides information about the current execution context, including the
494  * sender of the transaction and its data. While these are generally available
495  * via msg.sender and msg.data, they should not be accessed in such a direct
496  * manner, since when dealing with meta-transactions the account sending and
497  * paying for execution may not be the actual sender (as far as an application
498  * is concerned).
499  *
500  * This contract is only required for intermediate, library-like contracts.
501  */
502 abstract contract Context {
503     function _msgSender() internal view virtual returns (address) {
504         return msg.sender;
505     }
506 
507     function _msgData() internal view virtual returns (bytes calldata) {
508         return msg.data;
509     }
510 }
511 
512 
513 pragma solidity ^0.8.0;
514 
515 /**
516  * @dev String operations.
517  */
518 library Strings {
519     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
520 
521     /**
522      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
523      */
524     function toString(uint256 value) internal pure returns (string memory) {
525         // Inspired by OraclizeAPI's implementation - MIT licence
526         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
527 
528         if (value == 0) {
529             return "0";
530         }
531         uint256 temp = value;
532         uint256 digits;
533         while (temp != 0) {
534             digits++;
535             temp /= 10;
536         }
537         bytes memory buffer = new bytes(digits);
538         while (value != 0) {
539             digits -= 1;
540             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
541             value /= 10;
542         }
543         return string(buffer);
544     }
545 
546     /**
547      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
548      */
549     function toHexString(uint256 value) internal pure returns (string memory) {
550         if (value == 0) {
551             return "0x00";
552         }
553         uint256 temp = value;
554         uint256 length = 0;
555         while (temp != 0) {
556             length++;
557             temp >>= 8;
558         }
559         return toHexString(value, length);
560     }
561 
562     /**
563      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
564      */
565     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
566         bytes memory buffer = new bytes(2 * length + 2);
567         buffer[0] = "0";
568         buffer[1] = "x";
569         for (uint256 i = 2 * length + 1; i > 1; --i) {
570             buffer[i] = _HEX_SYMBOLS[value & 0xf];
571             value >>= 4;
572         }
573         require(value == 0, "Strings: hex length insufficient");
574         return string(buffer);
575     }
576 }
577 
578 
579 pragma solidity ^0.8.0;
580 
581 
582 /**
583  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
584  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
585  *
586  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
587  *
588  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
589  *
590  * Does not support burning tokens to address(0).
591  */
592 contract ERC721A is
593   Context,
594   ERC165,
595   IERC721,
596   IERC721Metadata,
597   IERC721Enumerable
598 {
599   using Address for address;
600   using Strings for uint256;
601 
602   struct TokenOwnership {
603     address addr;
604     uint64 startTimestamp;
605   }
606 
607   struct AddressData {
608     uint128 balance;
609     uint128 numberMinted;
610   }
611 
612   uint256 private currentIndex = 0;
613 
614   uint256 internal  collectionSize;
615   uint256 internal  collectionSizeFree;
616   uint256 internal  maxBatchSize;
617 
618   // Token name
619   string private _name;
620 
621   // Token symbol
622   string private _symbol;
623 
624   // Mapping from token ID to ownership details
625   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
626   mapping(uint256 => TokenOwnership) private _ownerships;
627 
628   // Mapping owner address to address data
629   mapping(address => AddressData) private _addressData;
630 
631   // Mapping from token ID to approved address
632   mapping(uint256 => address) private _tokenApprovals;
633 
634   // Mapping from owner to operator approvals
635   mapping(address => mapping(address => bool)) private _operatorApprovals;
636 
637   /**
638    * @dev
639    * `maxBatchSize` refers to how much a minter can mint at a time.
640    * `collectionSize_` refers to how many tokens are in the collection.
641    */
642   constructor(
643     string memory name_,
644     string memory symbol_,
645     uint256 maxBatchSize_,
646     uint256 collectionSize_,
647     uint256 collectionSizeFree_
648   ) {
649     require(
650       collectionSize_ > 0,
651       "ERC721A: collection must have a nonzero supply"
652     );
653     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
654     _name = name_;
655     _symbol = symbol_;
656     maxBatchSize = maxBatchSize_;
657     collectionSize = collectionSize_;
658     collectionSizeFree = collectionSizeFree_;
659   }
660 
661   /**
662    * @dev See {IERC721Enumerable-totalSupply}.
663    */
664   function totalSupply() public view override returns (uint256) {
665     return currentIndex;
666   }
667 
668   /**
669    * @dev See {IERC721Enumerable-tokenByIndex}.
670    */
671   function tokenByIndex(uint256 index) public view override returns (uint256) {
672     require(index < totalSupply(), "ERC721A: global index out of bounds");
673     return index;
674   }
675 
676   /**
677    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
678    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
679    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
680    */
681   function tokenOfOwnerByIndex(address owner, uint256 index)
682     public
683     view
684     override
685     returns (uint256)
686   {
687     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
688     uint256 numMintedSoFar = totalSupply();
689     uint256 tokenIdsIdx = 0;
690     address currOwnershipAddr = address(0);
691     for (uint256 i = 0; i < numMintedSoFar; i++) {
692       TokenOwnership memory ownership = _ownerships[i];
693       if (ownership.addr != address(0)) {
694         currOwnershipAddr = ownership.addr;
695       }
696       if (currOwnershipAddr == owner) {
697         if (tokenIdsIdx == index) {
698           return i;
699         }
700         tokenIdsIdx++;
701       }
702     }
703     revert("ERC721A: unable to get token of owner by index");
704   }
705 
706   /**
707    * @dev See {IERC165-supportsInterface}.
708    */
709   function supportsInterface(bytes4 interfaceId)
710     public
711     view
712     virtual
713     override(ERC165, IERC165)
714     returns (bool)
715   {
716     return
717       interfaceId == type(IERC721).interfaceId ||
718       interfaceId == type(IERC721Metadata).interfaceId ||
719       interfaceId == type(IERC721Enumerable).interfaceId ||
720       super.supportsInterface(interfaceId);
721   }
722 
723   /**
724    * @dev See {IERC721-balanceOf}.
725    */
726   function balanceOf(address owner) public view override returns (uint256) {
727     require(owner != address(0), "ERC721A: balance query for the zero address");
728     return uint256(_addressData[owner].balance);
729   }
730 
731   function _numberMinted(address owner) internal view returns (uint256) {
732     require(
733       owner != address(0),
734       "ERC721A: number minted query for the zero address"
735     );
736     return uint256(_addressData[owner].numberMinted);
737   }
738 
739   function ownershipOf(uint256 tokenId)
740     internal
741     view
742     returns (TokenOwnership memory)
743   {
744     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
745 
746     uint256 lowestTokenToCheck;
747     if (tokenId >= maxBatchSize) {
748       lowestTokenToCheck = tokenId - maxBatchSize + 1;
749     }
750 
751     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
752       TokenOwnership memory ownership = _ownerships[curr];
753       if (ownership.addr != address(0)) {
754         return ownership;
755       }
756     }
757 
758     revert("ERC721A: unable to determine the owner of token");
759   }
760 
761   /**
762    * @dev See {IERC721-ownerOf}.
763    */
764   function ownerOf(uint256 tokenId) public view override returns (address) {
765     return ownershipOf(tokenId).addr;
766   }
767 
768   /**
769    * @dev See {IERC721Metadata-name}.
770    */
771   function name() public view virtual override returns (string memory) {
772     return _name;
773   }
774 
775   /**
776    * @dev See {IERC721Metadata-symbol}.
777    */
778   function symbol() public view virtual override returns (string memory) {
779     return _symbol;
780   }
781 
782   /**
783    * @dev See {IERC721Metadata-tokenURI}.
784    */
785   function tokenURI(uint256 tokenId)
786     public
787     view
788     virtual
789     override
790     returns (string memory)
791   {
792     require(
793       _exists(tokenId),
794       "ERC721Metadata: URI query for nonexistent token"
795     );
796 
797     string memory baseURI = _baseURI();
798     return
799       bytes(baseURI).length > 0
800         ? string(abi.encodePacked(baseURI, tokenId.toString()))
801         : "";
802   }
803 
804   /**
805    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
806    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
807    * by default, can be overriden in child contracts.
808    */
809   function _baseURI() internal view virtual returns (string memory) {
810     return "";
811   }
812 
813   /**
814    * @dev See {IERC721-approve}.
815    */
816   function approve(address to, uint256 tokenId) public override {
817     address owner = ERC721A.ownerOf(tokenId);
818     require(to != owner, "ERC721A: approval to current owner");
819 
820     require(
821       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
822       "ERC721A: approve caller is not owner nor approved for all"
823     );
824 
825     _approve(to, tokenId, owner);
826   }
827 
828   /**
829    * @dev See {IERC721-getApproved}.
830    */
831   function getApproved(uint256 tokenId) public view override returns (address) {
832     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
833 
834     return _tokenApprovals[tokenId];
835   }
836 
837   /**
838    * @dev See {IERC721-setApprovalForAll}.
839    */
840   function setApprovalForAll(address operator, bool approved) public override {
841     require(operator != _msgSender(), "ERC721A: approve to caller");
842 
843     _operatorApprovals[_msgSender()][operator] = approved;
844     emit ApprovalForAll(_msgSender(), operator, approved);
845   }
846 
847   /**
848    * @dev See {IERC721-isApprovedForAll}.
849    */
850   function isApprovedForAll(address owner, address operator)
851     public
852     view
853     virtual
854     override
855     returns (bool)
856   {
857     return _operatorApprovals[owner][operator];
858   }
859 
860   /**
861    * @dev See {IERC721-transferFrom}.
862    */
863   function transferFrom(
864     address from,
865     address to,
866     uint256 tokenId
867   ) public override {
868     _transfer(from, to, tokenId);
869   }
870 
871   /**
872    * @dev See {IERC721-safeTransferFrom}.
873    */
874   function safeTransferFrom(
875     address from,
876     address to,
877     uint256 tokenId
878   ) public override {
879     safeTransferFrom(from, to, tokenId, "");
880   }
881 
882   /**
883    * @dev See {IERC721-safeTransferFrom}.
884    */
885   function safeTransferFrom(
886     address from,
887     address to,
888     uint256 tokenId,
889     bytes memory _data
890   ) public override {
891     _transfer(from, to, tokenId);
892     require(
893       _checkOnERC721Received(from, to, tokenId, _data),
894       "ERC721A: transfer to non ERC721Receiver implementer"
895     );
896   }
897 
898   /**
899    * @dev Returns whether `tokenId` exists.
900    *
901    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
902    *
903    * Tokens start existing when they are minted (`_mint`),
904    */
905   function _exists(uint256 tokenId) internal view returns (bool) {
906     return tokenId < currentIndex;
907   }
908 
909   function _safeMint(address to, uint256 quantity) internal {
910     _safeMint(to, quantity, "");
911   }
912 
913   /**
914    * @dev Mints `quantity` tokens and transfers them to `to`.
915    *
916    * Requirements:
917    *
918    * - there must be `quantity` tokens remaining unminted in the total collection.
919    * - `to` cannot be the zero address.
920    * - `quantity` cannot be larger than the max batch size.
921    *
922    * Emits a {Transfer} event.
923    */
924   function _safeMint(
925     address to,
926     uint256 quantity,
927     bytes memory _data
928   ) internal {
929     uint256 startTokenId = currentIndex;
930     require(to != address(0), "ERC721A: mint to the zero address");
931     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
932     require(!_exists(startTokenId), "ERC721A: token already minted");
933     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
934 
935     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
936 
937     AddressData memory addressData = _addressData[to];
938     _addressData[to] = AddressData(
939       addressData.balance + uint128(quantity),
940       addressData.numberMinted + uint128(quantity)
941     );
942     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
943 
944     uint256 updatedIndex = startTokenId;
945 
946     for (uint256 i = 0; i < quantity; i++) {
947       emit Transfer(address(0), to, updatedIndex);
948       require(
949         _checkOnERC721Received(address(0), to, updatedIndex, _data),
950         "ERC721A: transfer to non ERC721Receiver implementer"
951       );
952       updatedIndex++;
953     }
954 
955     currentIndex = updatedIndex;
956     _afterTokenTransfers(address(0), to, startTokenId, quantity);
957   }
958 
959   /**
960    * @dev Transfers `tokenId` from `from` to `to`.
961    *
962    * Requirements:
963    *
964    * - `to` cannot be the zero address.
965    * - `tokenId` token must be owned by `from`.
966    *
967    * Emits a {Transfer} event.
968    */
969   function _transfer(
970     address from,
971     address to,
972     uint256 tokenId
973   ) private {
974     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
975 
976     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
977       getApproved(tokenId) == _msgSender() ||
978       isApprovedForAll(prevOwnership.addr, _msgSender()));
979 
980     require(
981       isApprovedOrOwner,
982       "ERC721A: transfer caller is not owner nor approved"
983     );
984 
985     require(
986       prevOwnership.addr == from,
987       "ERC721A: transfer from incorrect owner"
988     );
989     require(to != address(0), "ERC721A: transfer to the zero address");
990 
991     _beforeTokenTransfers(from, to, tokenId, 1);
992 
993     // Clear approvals from the previous owner
994     _approve(address(0), tokenId, prevOwnership.addr);
995 
996     _addressData[from].balance -= 1;
997     _addressData[to].balance += 1;
998     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
999 
1000     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1001     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1002     uint256 nextTokenId = tokenId + 1;
1003     if (_ownerships[nextTokenId].addr == address(0)) {
1004       if (_exists(nextTokenId)) {
1005         _ownerships[nextTokenId] = TokenOwnership(
1006           prevOwnership.addr,
1007           prevOwnership.startTimestamp
1008         );
1009       }
1010     }
1011 
1012     emit Transfer(from, to, tokenId);
1013     _afterTokenTransfers(from, to, tokenId, 1);
1014   }
1015 
1016   /**
1017    * @dev Approve `to` to operate on `tokenId`
1018    *
1019    * Emits a {Approval} event.
1020    */
1021   function _approve(
1022     address to,
1023     uint256 tokenId,
1024     address owner
1025   ) private {
1026     _tokenApprovals[tokenId] = to;
1027     emit Approval(owner, to, tokenId);
1028   }
1029 
1030   uint256 public nextOwnerToExplicitlySet = 0;
1031 
1032   /**
1033    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1034    */
1035   function _setOwnersExplicit(uint256 quantity) internal {
1036     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1037     require(quantity > 0, "quantity must be nonzero");
1038     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1039     if (endIndex > collectionSize - 1) {
1040       endIndex = collectionSize - 1;
1041     }
1042     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1043     require(_exists(endIndex), "not enough minted yet for this cleanup");
1044     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1045       if (_ownerships[i].addr == address(0)) {
1046         TokenOwnership memory ownership = ownershipOf(i);
1047         _ownerships[i] = TokenOwnership(
1048           ownership.addr,
1049           ownership.startTimestamp
1050         );
1051       }
1052     }
1053     nextOwnerToExplicitlySet = endIndex + 1;
1054   }
1055 
1056   /**
1057    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1058    * The call is not executed if the target address is not a contract.
1059    *
1060    * @param from address representing the previous owner of the given token ID
1061    * @param to target address that will receive the tokens
1062    * @param tokenId uint256 ID of the token to be transferred
1063    * @param _data bytes optional data to send along with the call
1064    * @return bool whether the call correctly returned the expected magic value
1065    */
1066   function _checkOnERC721Received(
1067     address from,
1068     address to,
1069     uint256 tokenId,
1070     bytes memory _data
1071   ) private returns (bool) {
1072     if (to.isContract()) {
1073       try
1074         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1075       returns (bytes4 retval) {
1076         return retval == IERC721Receiver(to).onERC721Received.selector;
1077       } catch (bytes memory reason) {
1078         if (reason.length == 0) {
1079           revert("ERC721A: transfer to non ERC721Receiver implementer");
1080         } else {
1081           assembly {
1082             revert(add(32, reason), mload(reason))
1083           }
1084         }
1085       }
1086     } else {
1087       return true;
1088     }
1089   }
1090 
1091   /**
1092    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1093    *
1094    * startTokenId - the first token id to be transferred
1095    * quantity - the amount to be transferred
1096    *
1097    * Calling conditions:
1098    *
1099    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1100    * transferred to `to`.
1101    * - When `from` is zero, `tokenId` will be minted for `to`.
1102    */
1103   function _beforeTokenTransfers(
1104     address from,
1105     address to,
1106     uint256 startTokenId,
1107     uint256 quantity
1108   ) internal virtual {}
1109 
1110   /**
1111    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1112    * minting.
1113    *
1114    * startTokenId - the first token id to be transferred
1115    * quantity - the amount to be transferred
1116    *
1117    * Calling conditions:
1118    *
1119    * - when `from` and `to` are both non-zero.
1120    * - `from` and `to` are never both zero.
1121    */
1122   function _afterTokenTransfers(
1123     address from,
1124     address to,
1125     uint256 startTokenId,
1126     uint256 quantity
1127   ) internal virtual {}
1128 }
1129 
1130 
1131 pragma solidity ^0.8.0;
1132 
1133 /**
1134  * @dev Contract module that helps prevent reentrant calls to a function.
1135  *
1136  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1137  * available, which can be applied to functions to make sure there are no nested
1138  * (reentrant) calls to them.
1139  *
1140  * Note that because there is a single `nonReentrant` guard, functions marked as
1141  * `nonReentrant` may not call one another. This can be worked around by making
1142  * those functions `private`, and then adding `external` `nonReentrant` entry
1143  * points to them.
1144  *
1145  * TIP: If you would like to learn more about reentrancy and alternative ways
1146  * to protect against it, check out our blog post
1147  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1148  */
1149 abstract contract ReentrancyGuard {
1150     // Booleans are more expensive than uint256 or any type that takes up a full
1151     // word because each write operation emits an extra SLOAD to first read the
1152     // slot's contents, replace the bits taken up by the boolean, and then write
1153     // back. This is the compiler's defense against contract upgrades and
1154     // pointer aliasing, and it cannot be disabled.
1155 
1156     // The values being non-zero value makes deployment a bit more expensive,
1157     // but in exchange the refund on every call to nonReentrant will be lower in
1158     // amount. Since refunds are capped to a percentage of the total
1159     // transaction's gas, it is best to keep them low in cases like this one, to
1160     // increase the likelihood of the full refund coming into effect.
1161     uint256 private constant _NOT_ENTERED = 1;
1162     uint256 private constant _ENTERED = 2;
1163 
1164     uint256 private _status;
1165 
1166     constructor() {
1167         _status = _NOT_ENTERED;
1168     }
1169 
1170     /**
1171      * @dev Prevents a contract from calling itself, directly or indirectly.
1172      * Calling a `nonReentrant` function from another `nonReentrant`
1173      * function is not supported. It is possible to prevent this from happening
1174      * by making the `nonReentrant` function external, and make it call a
1175      * `private` function that does the actual work.
1176      */
1177     modifier nonReentrant() {
1178         // On the first call to nonReentrant, _notEntered will be true
1179         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1180 
1181         // Any calls to nonReentrant after this point will fail
1182         _status = _ENTERED;
1183 
1184         _;
1185 
1186         // By storing the original value once again, a refund is triggered (see
1187         // https://eips.ethereum.org/EIPS/eip-2200)
1188         _status = _NOT_ENTERED;
1189     }
1190 }
1191 
1192 
1193 pragma solidity ^0.8.0;
1194 
1195 
1196 /**
1197  * @dev Contract module which provides a basic access control mechanism, where
1198  * there is an account (an owner) that can be granted exclusive access to
1199  * specific functions.
1200  *
1201  * By default, the owner account will be the one that deploys the contract. This
1202  * can later be changed with {transferOwnership}.
1203  *
1204  * This module is used through inheritance. It will make available the modifier
1205  * `onlyOwner`, which can be applied to your functions to restrict their use to
1206  * the owner.
1207  */
1208 abstract contract Ownable is Context {
1209     address private _owner;
1210 
1211     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1212 
1213     /**
1214      * @dev Initializes the contract setting the deployer as the initial owner.
1215      */
1216     constructor() {
1217         _setOwner(_msgSender());
1218     }
1219 
1220     /**
1221      * @dev Returns the address of the current owner.
1222      */
1223     function owner() public view virtual returns (address) {
1224         return _owner;
1225     }
1226 
1227     /**
1228      * @dev Throws if called by any account other than the owner.
1229      */
1230     modifier onlyOwner() {
1231         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1232         _;
1233     }
1234 
1235     /**
1236      * @dev Leaves the contract without owner. It will not be possible to call
1237      * `onlyOwner` functions anymore. Can only be called by the current owner.
1238      *
1239      * NOTE: Renouncing ownership will leave the contract without an owner,
1240      * thereby removing any functionality that is only available to the owner.
1241      */
1242     function renounceOwnership() public virtual onlyOwner {
1243         _setOwner(address(0));
1244     }
1245 
1246     /**
1247      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1248      * Can only be called by the current owner.
1249      */
1250     function transferOwnership(address newOwner) public virtual onlyOwner {
1251         require(newOwner != address(0), "Ownable: new owner is the zero address");
1252         _setOwner(newOwner);
1253     }
1254 
1255     function _setOwner(address newOwner) private {
1256         address oldOwner = _owner;
1257         _owner = newOwner;
1258         emit OwnershipTransferred(oldOwner, newOwner);
1259     }
1260 }
1261 
1262 
1263 pragma solidity ^0.8.0;
1264 
1265 
1266 contract xCoolCats is Ownable, ERC721A, ReentrancyGuard {
1267   uint256 public maxPerAddressDuringMint;
1268   uint256 public amountForDevs;
1269   uint256 public price = 0.01 ether;
1270   uint256 public freemintAmount = 20;
1271   uint256 public mintAmount = 20;
1272   bool public revealed = false;
1273   struct SaleConfig {
1274     uint64 publicPrice;
1275   }
1276 
1277   SaleConfig public saleConfig;
1278   mapping(address => uint256) public allowlist;
1279 
1280   // // metadata URI
1281   string private _baseTokenURI;
1282   string private _hiddenMetadataUri ='ipfs://no/hidden.json';
1283   
1284   constructor() ERC721A("0xCoolCats", "0xCC", 20, 10000, 1000) {
1285     maxPerAddressDuringMint = 20;
1286     amountForDevs = 10;
1287   }
1288 
1289 
1290   function Mint(uint256 quantity)
1291     external
1292     payable
1293     nonReentrant
1294   {
1295     if (totalSupply() + quantity <= collectionSizeFree){
1296       require(quantity <= freemintAmount, "Too many minted at once");
1297       //require(totalSupply() + quantity <= collectionSizeFree, "reached max supply");
1298     }else{
1299       require(quantity <= mintAmount, "Too many minted at once");
1300       require(msg.value >= price, "Need to send more ETH.");
1301       require(totalSupply() + quantity <= collectionSize, "reached max supply");
1302     }
1303     _safeMint(msg.sender, quantity);
1304   }
1305 
1306 
1307   function refundIfOver(uint256 _price) private {
1308     require(msg.value >= _price, "Need to send more ETH.");
1309     if (msg.value > _price) {
1310       payable(msg.sender).transfer(msg.value - _price);
1311     }
1312   }
1313 
1314 
1315   function seedAllowlist(address[] memory addresses, uint256[] memory numSlots)
1316     external
1317     onlyOwner
1318   {
1319     require(
1320       addresses.length == numSlots.length,
1321       "addresses does not match numSlots length"
1322     );
1323     for (uint256 i = 0; i < addresses.length; i++) {
1324       allowlist[addresses[i]] = numSlots[i];
1325     }
1326   }
1327 
1328   // For marketing etc.
1329   function Mints(uint256 quantity) external onlyOwner {
1330     
1331      require(totalSupply() + quantity <= amountForDevs, "reached max supply");
1332     _safeMint(msg.sender, quantity);
1333   }
1334     
1335   function _baseURI() internal view virtual override returns (string memory) {
1336       return _baseTokenURI;
1337   }
1338 
1339 
1340     function tokenURI(uint256 tokenId)
1341     public
1342     view
1343     virtual
1344     override
1345     returns (string memory)
1346   {
1347     if (revealed){
1348       return super.tokenURI(tokenId);
1349     }
1350     else{
1351       return _hiddenMetadataUri;
1352     }
1353   }
1354 
1355 
1356   function setBaseURI(string calldata baseURI) external onlyOwner {
1357     _baseTokenURI = baseURI;
1358   }
1359 
1360   function setHiddenURI(string calldata baseURI) external onlyOwner {
1361     _hiddenMetadataUri = baseURI;
1362   }
1363 
1364 
1365   function withdrawMoney() external onlyOwner nonReentrant {
1366     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1367     require(success, "Transfer failed.");
1368   }
1369 
1370   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1371     _setOwnersExplicit(quantity);
1372   }
1373 
1374   function numberMinted(address owner) public view returns (uint256) {
1375     return _numberMinted(owner);
1376   }
1377 
1378   function getOwnershipData(uint256 tokenId)
1379     external
1380     view
1381     returns (TokenOwnership memory)
1382   {
1383     return ownershipOf(tokenId);
1384   }
1385   
1386   function setRevealed(bool _state) external onlyOwner{
1387     revealed = _state;
1388   }
1389   function setprice(uint256 _newprice) public onlyOwner {
1390 	    price = _newprice;
1391 	}
1392 
1393   function setfreemints(uint256 _newfreemints) public onlyOwner {
1394 	    collectionSizeFree = _newfreemints;
1395 	}
1396 
1397     function setcollectionSize(uint256 _newcollectionSize) public onlyOwner {
1398 	    collectionSize = _newcollectionSize;
1399 	}
1400 
1401     function setamountForDevs(uint256 _newamountForDevs) public onlyOwner {
1402 	    amountForDevs = _newamountForDevs;
1403 	}
1404 
1405     function setfreemintAmount(uint256 _newfreemintAmount) public onlyOwner {
1406 	    freemintAmount = _newfreemintAmount;
1407 	}
1408 
1409   function setmintAmount(uint256 _newmintAmount) public onlyOwner {
1410 	    mintAmount = _newmintAmount;
1411 	}
1412   function getCollectionSize() external view returns(uint256){
1413     return collectionSize;
1414   }
1415   function getFreeCollectionSize() external view returns(uint256){
1416     return collectionSizeFree;
1417   }
1418 }