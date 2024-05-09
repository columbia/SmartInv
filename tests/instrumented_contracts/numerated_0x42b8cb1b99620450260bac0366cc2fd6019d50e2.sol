1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 interface IERC165 {
4     /**
5      * @dev Returns true if this contract implements the interface defined by
6      * `interfaceId`. See the corresponding
7      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
8      * to learn more about how these ids are created.
9      *
10      * This function call must use less than 30 000 gas.
11      */
12     function supportsInterface(bytes4 interfaceId) external view returns (bool);
13 }
14 
15 pragma solidity ^0.8.0;
16 
17 
18 /**
19  * @dev Implementation of the {IERC165} interface.
20  *
21  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
22  * for the additional interface id that will be supported. For example:
23  *
24  * ```solidity
25  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
26  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
27  * }
28  * ```
29  *
30  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
31  */
32 abstract contract ERC165 is IERC165 {
33     /**
34      * @dev See {IERC165-supportsInterface}.
35      */
36     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
37         return interfaceId == type(IERC165).interfaceId;
38     }
39 }
40 
41 pragma solidity ^0.8.0;
42 
43 /**
44  * @dev Collection of functions related to the address type
45  */
46 library Address {
47     /**
48      * @dev Returns true if `account` is a contract.
49      *
50      * [IMPORTANT]
51      * ====
52      * It is unsafe to assume that an address for which this function returns
53      * false is an externally-owned account (EOA) and not a contract.
54      *
55      * Among others, `isContract` will return false for the following
56      * types of addresses:
57      *
58      *  - an externally-owned account
59      *  - a contract in construction
60      *  - an address where a contract will be created
61      *  - an address where a contract lived, but was destroyed
62      * ====
63      */
64     function isContract(address account) internal view returns (bool) {
65         // This method relies on extcodesize, which returns 0 for contracts in
66         // construction, since the code is only stored at the end of the
67         // constructor execution.
68 
69         uint256 size;
70         assembly {
71             size := extcodesize(account)
72         }
73         return size > 0;
74     }
75 
76     /**
77      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
78      * `recipient`, forwarding all available gas and reverting on errors.
79      *
80      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
81      * of certain opcodes, possibly making contracts go over the 2300 gas limit
82      * imposed by `transfer`, making them unable to receive funds via
83      * `transfer`. {sendValue} removes this limitation.
84      *
85      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
86      *
87      * IMPORTANT: because control is transferred to `recipient`, care must be
88      * taken to not create reentrancy vulnerabilities. Consider using
89      * {ReentrancyGuard} or the
90      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
91      */
92     function sendValue(address payable recipient, uint256 amount) internal {
93         require(address(this).balance >= amount, "Address: insufficient balance");
94 
95         (bool success, ) = recipient.call{value: amount}("");
96         require(success, "Address: unable to send value, recipient may have reverted");
97     }
98 
99     /**
100      * @dev Performs a Solidity function call using a low level `call`. A
101      * plain `call` is an unsafe replacement for a function call: use this
102      * function instead.
103      *
104      * If `target` reverts with a revert reason, it is bubbled up by this
105      * function (like regular Solidity function calls).
106      *
107      * Returns the raw returned data. To convert to the expected return value,
108      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
109      *
110      * Requirements:
111      *
112      * - `target` must be a contract.
113      * - calling `target` with `data` must not revert.
114      *
115      * _Available since v3.1._
116      */
117     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
118         return functionCall(target, data, "Address: low-level call failed");
119     }
120 
121     /**
122      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
123      * `errorMessage` as a fallback revert reason when `target` reverts.
124      *
125      * _Available since v3.1._
126      */
127     function functionCall(
128         address target,
129         bytes memory data,
130         string memory errorMessage
131     ) internal returns (bytes memory) {
132         return functionCallWithValue(target, data, 0, errorMessage);
133     }
134 
135     /**
136      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
137      * but also transferring `value` wei to `target`.
138      *
139      * Requirements:
140      *
141      * - the calling contract must have an ETH balance of at least `value`.
142      * - the called Solidity function must be `payable`.
143      *
144      * _Available since v3.1._
145      */
146     function functionCallWithValue(
147         address target,
148         bytes memory data,
149         uint256 value
150     ) internal returns (bytes memory) {
151         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
152     }
153 
154     /**
155      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
156      * with `errorMessage` as a fallback revert reason when `target` reverts.
157      *
158      * _Available since v3.1._
159      */
160     function functionCallWithValue(
161         address target,
162         bytes memory data,
163         uint256 value,
164         string memory errorMessage
165     ) internal returns (bytes memory) {
166         require(address(this).balance >= value, "Address: insufficient balance for call");
167         require(isContract(target), "Address: call to non-contract");
168 
169         (bool success, bytes memory returndata) = target.call{value: value}(data);
170         return _verifyCallResult(success, returndata, errorMessage);
171     }
172 
173     /**
174      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
175      * but performing a static call.
176      *
177      * _Available since v3.3._
178      */
179     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
180         return functionStaticCall(target, data, "Address: low-level static call failed");
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
185      * but performing a static call.
186      *
187      * _Available since v3.3._
188      */
189     function functionStaticCall(
190         address target,
191         bytes memory data,
192         string memory errorMessage
193     ) internal view returns (bytes memory) {
194         require(isContract(target), "Address: static call to non-contract");
195 
196         (bool success, bytes memory returndata) = target.staticcall(data);
197         return _verifyCallResult(success, returndata, errorMessage);
198     }
199 
200     /**
201      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
202      * but performing a delegate call.
203      *
204      * _Available since v3.4._
205      */
206     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
207         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
208     }
209 
210     /**
211      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
212      * but performing a delegate call.
213      *
214      * _Available since v3.4._
215      */
216     function functionDelegateCall(
217         address target,
218         bytes memory data,
219         string memory errorMessage
220     ) internal returns (bytes memory) {
221         require(isContract(target), "Address: delegate call to non-contract");
222 
223         (bool success, bytes memory returndata) = target.delegatecall(data);
224         return _verifyCallResult(success, returndata, errorMessage);
225     }
226 
227     function _verifyCallResult(
228         bool success,
229         bytes memory returndata,
230         string memory errorMessage
231     ) private pure returns (bytes memory) {
232         if (success) {
233             return returndata;
234         } else {
235             // Look for revert reason and bubble it up if present
236             if (returndata.length > 0) {
237                 // The easiest way to bubble the revert reason is using memory via assembly
238 
239                 assembly {
240                     let returndata_size := mload(returndata)
241                     revert(add(32, returndata), returndata_size)
242                 }
243             } else {
244                 revert(errorMessage);
245             }
246         }
247     }
248 }
249 
250 
251 
252 pragma solidity ^0.8.0;
253 
254 
255 /**
256  * @dev Required interface of an ERC721 compliant contract.
257  */
258 interface IERC721 is IERC165 {
259     /**
260      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
261      */
262     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
263 
264     /**
265      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
266      */
267     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
268 
269     /**
270      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
271      */
272     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
273 
274     /**
275      * @dev Returns the number of tokens in ``owner``'s account.
276      */
277     function balanceOf(address owner) external view returns (uint256 balance);
278 
279     /**
280      * @dev Returns the owner of the `tokenId` token.
281      *
282      * Requirements:
283      *
284      * - `tokenId` must exist.
285      */
286     function ownerOf(uint256 tokenId) external view returns (address owner);
287 
288     /**
289      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
290      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
291      *
292      * Requirements:
293      *
294      * - `from` cannot be the zero address.
295      * - `to` cannot be the zero address.
296      * - `tokenId` token must exist and be owned by `from`.
297      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
298      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
299      *
300      * Emits a {Transfer} event.
301      */
302     function safeTransferFrom(
303         address from,
304         address to,
305         uint256 tokenId
306     ) external;
307 
308     /**
309      * @dev Transfers `tokenId` token from `from` to `to`.
310      *
311      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
312      *
313      * Requirements:
314      *
315      * - `from` cannot be the zero address.
316      * - `to` cannot be the zero address.
317      * - `tokenId` token must be owned by `from`.
318      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
319      *
320      * Emits a {Transfer} event.
321      */
322     function transferFrom(
323         address from,
324         address to,
325         uint256 tokenId
326     ) external;
327 
328     /**
329      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
330      * The approval is cleared when the token is transferred.
331      *
332      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
333      *
334      * Requirements:
335      *
336      * - The caller must own the token or be an approved operator.
337      * - `tokenId` must exist.
338      *
339      * Emits an {Approval} event.
340      */
341     function approve(address to, uint256 tokenId) external;
342 
343     /**
344      * @dev Returns the account approved for `tokenId` token.
345      *
346      * Requirements:
347      *
348      * - `tokenId` must exist.
349      */
350     function getApproved(uint256 tokenId) external view returns (address operator);
351 
352     /**
353      * @dev Approve or remove `operator` as an operator for the caller.
354      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
355      *
356      * Requirements:
357      *
358      * - The `operator` cannot be the caller.
359      *
360      * Emits an {ApprovalForAll} event.
361      */
362     function setApprovalForAll(address operator, bool _approved) external;
363 
364     /**
365      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
366      *
367      * See {setApprovalForAll}
368      */
369     function isApprovedForAll(address owner, address operator) external view returns (bool);
370 
371     /**
372      * @dev Safely transfers `tokenId` token from `from` to `to`.
373      *
374      * Requirements:
375      *
376      * - `from` cannot be the zero address.
377      * - `to` cannot be the zero address.
378      * - `tokenId` token must exist and be owned by `from`.
379      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
380      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
381      *
382      * Emits a {Transfer} event.
383      */
384     function safeTransferFrom(
385         address from,
386         address to,
387         uint256 tokenId,
388         bytes calldata data
389     ) external;
390 }
391 
392 
393 
394 pragma solidity ^0.8.0;
395 
396 /**
397  * @title ERC721 token receiver interface
398  * @dev Interface for any contract that wants to support safeTransfers
399  * from ERC721 asset contracts.
400  */
401 interface IERC721Receiver {
402     /**
403      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
404      * by `operator` from `from`, this function is called.
405      *
406      * It must return its Solidity selector to confirm the token transfer.
407      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
408      *
409      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
410      */
411     function onERC721Received(
412         address operator,
413         address from,
414         uint256 tokenId,
415         bytes calldata data
416     ) external returns (bytes4);
417 }
418 
419 
420 
421 pragma solidity ^0.8.0;
422 
423 /*
424  * @dev Provides information about the current execution context, including the
425  * sender of the transaction and its data. While these are generally available
426  * via msg.sender and msg.data, they should not be accessed in such a direct
427  * manner, since when dealing with meta-transactions the account sending and
428  * paying for execution may not be the actual sender (as far as an application
429  * is concerned).
430  *
431  * This contract is only required for intermediate, library-like contracts.
432  */
433 abstract contract Context {
434     function _msgSender() internal view virtual returns (address) {
435         return msg.sender;
436     }
437 
438     function _msgData() internal view virtual returns (bytes calldata) {
439         return msg.data;
440     }
441 }
442 
443 
444 pragma solidity ^0.8.0;
445 
446 /**
447  * @dev String operations.
448  */
449 library Strings {
450     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
451 
452     /**
453      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
454      */
455     function toString(uint256 value) internal pure returns (string memory) {
456         // Inspired by OraclizeAPI's implementation - MIT licence
457         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
458 
459         if (value == 0) {
460             return "0";
461         }
462         uint256 temp = value;
463         uint256 digits;
464         while (temp != 0) {
465             digits++;
466             temp /= 10;
467         }
468         bytes memory buffer = new bytes(digits);
469         while (value != 0) {
470             digits -= 1;
471             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
472             value /= 10;
473         }
474         return string(buffer);
475     }
476 
477     /**
478      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
479      */
480     function toHexString(uint256 value) internal pure returns (string memory) {
481         if (value == 0) {
482             return "0x00";
483         }
484         uint256 temp = value;
485         uint256 length = 0;
486         while (temp != 0) {
487             length++;
488             temp >>= 8;
489         }
490         return toHexString(value, length);
491     }
492 
493     /**
494      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
495      */
496     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
497         bytes memory buffer = new bytes(2 * length + 2);
498         buffer[0] = "0";
499         buffer[1] = "x";
500         for (uint256 i = 2 * length + 1; i > 1; --i) {
501             buffer[i] = _HEX_SYMBOLS[value & 0xf];
502             value >>= 4;
503         }
504         require(value == 0, "Strings: hex length insufficient");
505         return string(buffer);
506     }
507 }
508 
509 
510 
511 pragma solidity ^0.8.0;
512 
513 
514 /**
515  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
516  * @dev See https://eips.ethereum.org/EIPS/eip-721
517  */
518 interface IERC721Enumerable is IERC721 {
519     /**
520      * @dev Returns the total amount of tokens stored by the contract.
521      */
522     function totalSupply() external view returns (uint256);
523 
524     /**
525      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
526      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
527      */
528     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
529 
530     /**
531      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
532      * Use along with {totalSupply} to enumerate all tokens.
533      */
534     function tokenByIndex(uint256 index) external view returns (uint256);
535 }
536 
537 
538 
539 pragma solidity ^0.8.0;
540 
541 
542 
543 /**
544  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
545  * @dev See https://eips.ethereum.org/EIPS/eip-721
546  */
547 interface IERC721Metadata is IERC721 {
548     /**
549      * @dev Returns the token collection name.
550      */
551     function name() external view returns (string memory);
552 
553     /**
554      * @dev Returns the token collection symbol.
555      */
556     function symbol() external view returns (string memory);
557 
558     /**
559      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
560      */
561     function tokenURI(uint256 tokenId) external view returns (string memory);
562 }
563 
564 
565 
566 pragma solidity ^0.8.0;
567 
568 /**
569  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
570  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
571  *
572  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
573  *
574  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
575  *
576  * Does not support burning tokens to address(0).
577  */
578 contract ERC721A is
579   Context,
580   ERC165,
581   IERC721,
582   IERC721Metadata,
583   IERC721Enumerable
584 {
585   using Address for address;
586   using Strings for uint256;
587 
588   struct TokenOwnership {
589     address addr;
590     uint64 startTimestamp;
591   }
592 
593   struct AddressData {
594     uint128 balance;
595     uint128 numberMinted;
596   }
597 
598   uint256 private currentIndex = 0;
599 
600   uint256 internal immutable collectionSize;
601   uint256 internal immutable maxBatchSize;
602 
603   // Token name
604   string private _name;
605 
606   // Token symbol
607   string private _symbol;
608 
609   // Mapping from token ID to ownership details
610   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
611   mapping(uint256 => TokenOwnership) private _ownerships;
612 
613   // Mapping owner address to address data
614   mapping(address => AddressData) private _addressData;
615 
616   // Mapping from token ID to approved address
617   mapping(uint256 => address) private _tokenApprovals;
618 
619   // Mapping from owner to operator approvals
620   mapping(address => mapping(address => bool)) private _operatorApprovals;
621 
622   /**
623    * @dev
624    * `maxBatchSize` refers to how much a minter can mint at a time.
625    * `collectionSize_` refers to how many tokens are in the collection.
626    */
627   constructor(
628     string memory name_,
629     string memory symbol_,
630     uint256 maxBatchSize_,
631     uint256 collectionSize_
632   ) {
633     require(
634       collectionSize_ > 0,
635       "ERC721A: collection must have a nonzero supply"
636     );
637     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
638     _name = name_;
639     _symbol = symbol_;
640     maxBatchSize = maxBatchSize_;
641     collectionSize = collectionSize_;
642   }
643 
644   /**
645    * @dev See {IERC721Enumerable-totalSupply}.
646    */
647   function totalSupply() public view override returns (uint256) {
648     return currentIndex;
649   }
650 
651   /**
652    * @dev See {IERC721Enumerable-tokenByIndex}.
653    */
654   function tokenByIndex(uint256 index) public view override returns (uint256) {
655     require(index < totalSupply(), "ERC721A: global index out of bounds");
656     return index;
657   }
658 
659   /**
660    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
661    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
662    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
663    */
664   function tokenOfOwnerByIndex(address owner, uint256 index)
665     public
666     view
667     override
668     returns (uint256)
669   {
670     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
671     uint256 numMintedSoFar = totalSupply();
672     uint256 tokenIdsIdx = 0;
673     address currOwnershipAddr = address(0);
674     for (uint256 i = 0; i < numMintedSoFar; i++) {
675       TokenOwnership memory ownership = _ownerships[i];
676       if (ownership.addr != address(0)) {
677         currOwnershipAddr = ownership.addr;
678       }
679       if (currOwnershipAddr == owner) {
680         if (tokenIdsIdx == index) {
681           return i;
682         }
683         tokenIdsIdx++;
684       }
685     }
686     revert("ERC721A: unable to get token of owner by index");
687   }
688 
689   /**
690    * @dev See {IERC165-supportsInterface}.
691    */
692   function supportsInterface(bytes4 interfaceId)
693     public
694     view
695     virtual
696     override(ERC165, IERC165)
697     returns (bool)
698   {
699     return
700       interfaceId == type(IERC721).interfaceId ||
701       interfaceId == type(IERC721Metadata).interfaceId ||
702       interfaceId == type(IERC721Enumerable).interfaceId ||
703       super.supportsInterface(interfaceId);
704   }
705 
706   /**
707    * @dev See {IERC721-balanceOf}.
708    */
709   function balanceOf(address owner) public view override returns (uint256) {
710     require(owner != address(0), "ERC721A: balance query for the zero address");
711     return uint256(_addressData[owner].balance);
712   }
713 
714   function _numberMinted(address owner) internal view returns (uint256) {
715     require(
716       owner != address(0),
717       "ERC721A: number minted query for the zero address"
718     );
719     return uint256(_addressData[owner].numberMinted);
720   }
721 
722   function ownershipOf(uint256 tokenId)
723     internal
724     view
725     returns (TokenOwnership memory)
726   {
727     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
728 
729     uint256 lowestTokenToCheck;
730     if (tokenId >= maxBatchSize) {
731       lowestTokenToCheck = tokenId - maxBatchSize + 1;
732     }
733 
734     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
735       TokenOwnership memory ownership = _ownerships[curr];
736       if (ownership.addr != address(0)) {
737         return ownership;
738       }
739     }
740 
741     revert("ERC721A: unable to determine the owner of token");
742   }
743 
744   /**
745    * @dev See {IERC721-ownerOf}.
746    */
747   function ownerOf(uint256 tokenId) public view override returns (address) {
748     return ownershipOf(tokenId).addr;
749   }
750 
751   /**
752    * @dev See {IERC721Metadata-name}.
753    */
754   function name() public view virtual override returns (string memory) {
755     return _name;
756   }
757 
758   /**
759    * @dev See {IERC721Metadata-symbol}.
760    */
761   function symbol() public view virtual override returns (string memory) {
762     return _symbol;
763   }
764 
765   /**
766    * @dev See {IERC721Metadata-tokenURI}.
767    */
768   function tokenURI(uint256 tokenId)
769     public
770     view
771     virtual
772     override
773     returns (string memory)
774   {
775     require(
776       _exists(tokenId),
777       "ERC721Metadata: URI query for nonexistent token"
778     );
779 
780     string memory baseURI = _baseURI();
781     return
782       bytes(baseURI).length > 0
783         ? string(abi.encodePacked(baseURI, tokenId.toString()))
784         : "";
785   }
786 
787   /**
788    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
789    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
790    * by default, can be overriden in child contracts.
791    */
792   function _baseURI() internal view virtual returns (string memory) {
793     return "";
794   }
795 
796   /**
797    * @dev See {IERC721-approve}.
798    */
799   function approve(address to, uint256 tokenId) public override {
800     address owner = ERC721A.ownerOf(tokenId);
801     require(to != owner, "ERC721A: approval to current owner");
802 
803     require(
804       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
805       "ERC721A: approve caller is not owner nor approved for all"
806     );
807 
808     _approve(to, tokenId, owner);
809   }
810 
811   /**
812    * @dev See {IERC721-getApproved}.
813    */
814   function getApproved(uint256 tokenId) public view override returns (address) {
815     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
816 
817     return _tokenApprovals[tokenId];
818   }
819 
820   /**
821    * @dev See {IERC721-setApprovalForAll}.
822    */
823   function setApprovalForAll(address operator, bool approved) public override {
824     require(operator != _msgSender(), "ERC721A: approve to caller");
825 
826     _operatorApprovals[_msgSender()][operator] = approved;
827     emit ApprovalForAll(_msgSender(), operator, approved);
828   }
829 
830   /**
831    * @dev See {IERC721-isApprovedForAll}.
832    */
833   function isApprovedForAll(address owner, address operator)
834     public
835     view
836     virtual
837     override
838     returns (bool)
839   {
840     return _operatorApprovals[owner][operator];
841   }
842 
843   /**
844    * @dev See {IERC721-transferFrom}.
845    */
846   function transferFrom(
847     address from,
848     address to,
849     uint256 tokenId
850   ) public virtual override {
851     _transfer(from, to, tokenId);
852   }
853 
854   /**
855    * @dev See {IERC721-safeTransferFrom}.
856    */
857   function safeTransferFrom(
858     address from,
859     address to,
860     uint256 tokenId
861   ) public override {
862     safeTransferFrom(from, to, tokenId, "");
863   }
864 
865   /**
866    * @dev See {IERC721-safeTransferFrom}.
867    */
868   function safeTransferFrom(
869     address from,
870     address to,
871     uint256 tokenId,
872     bytes memory _data
873   ) public virtual override {
874     _transfer(from, to, tokenId);
875     require(
876       _checkOnERC721Received(from, to, tokenId, _data),
877       "ERC721A: transfer to non ERC721Receiver implementer"
878     );
879   }
880 
881   /**
882    * @dev Returns whether `tokenId` exists.
883    *
884    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
885    *
886    * Tokens start existing when they are minted (`_mint`),
887    */
888   function _exists(uint256 tokenId) internal view returns (bool) {
889     return tokenId < currentIndex;
890   }
891 
892   function _safeMint(address to, uint256 quantity) internal {
893     _safeMint(to, quantity, "");
894   }
895 
896   function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
897          require(_exists(tokenId), "ERC721: operator query for nonexistent token");
898          address owner = ERC721A.ownerOf(tokenId);
899          return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
900    }
901   /**
902    * @dev Mints `quantity` tokens and transfers them to `to`.
903    *
904    * Requirements:
905    *
906    * - there must be `quantity` tokens remaining unminted in the total collection.
907    * - `to` cannot be the zero address.
908    * - `quantity` cannot be larger than the max batch size.
909    *
910    * Emits a {Transfer} event.
911    */
912   function _safeMint(
913     address to,
914     uint256 quantity,
915     bytes memory _data
916   ) internal {
917     uint256 startTokenId = currentIndex;
918     require(to != address(0), "ERC721A: mint to the zero address");
919     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
920     require(!_exists(startTokenId), "ERC721A: token already minted");
921     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
922 
923     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
924 
925     AddressData memory addressData = _addressData[to];
926     _addressData[to] = AddressData(
927       addressData.balance + uint128(quantity),
928       addressData.numberMinted + uint128(quantity)
929     );
930     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
931 
932     uint256 updatedIndex = startTokenId;
933 
934     for (uint256 i = 0; i < quantity; i++) {
935       emit Transfer(address(0), to, updatedIndex);
936       require(
937         _checkOnERC721Received(address(0), to, updatedIndex, _data),
938         "ERC721A: transfer to non ERC721Receiver implementer"
939       );
940       updatedIndex++;
941     }
942 
943     currentIndex = updatedIndex;
944     _afterTokenTransfers(address(0), to, startTokenId, quantity);
945   }
946 
947   /**
948    * @dev Transfers `tokenId` from `from` to `to`.
949    *
950    * Requirements:
951    *
952    * - `to` cannot be the zero address.
953    * - `tokenId` token must be owned by `from`.
954    *
955    * Emits a {Transfer} event.
956    */
957   function _transfer(
958     address from,
959     address to,
960     uint256 tokenId
961   ) internal virtual {
962     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
963 
964     require(
965       prevOwnership.addr == from,
966       "ERC721A: transfer from incorrect owner"
967     );
968     require(to != address(0), "ERC721A: transfer to the zero address");
969 
970     _beforeTokenTransfers(from, to, tokenId, 1);
971 
972     // Clear approvals from the previous owner
973     _approve(address(0), tokenId, prevOwnership.addr);
974 
975     _addressData[from].balance -= 1;
976     _addressData[to].balance += 1;
977     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
978 
979     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
980     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
981     uint256 nextTokenId = tokenId + 1;
982     if (_ownerships[nextTokenId].addr == address(0)) {
983       if (_exists(nextTokenId)) {
984         _ownerships[nextTokenId] = TokenOwnership(
985           prevOwnership.addr,
986           prevOwnership.startTimestamp
987         );
988       }
989     }
990 
991     emit Transfer(from, to, tokenId);
992     _afterTokenTransfers(from, to, tokenId, 1);
993   }
994 
995   /**
996    * @dev Approve `to` to operate on `tokenId`
997    *
998    * Emits a {Approval} event.
999    */
1000   function _approve(
1001     address to,
1002     uint256 tokenId,
1003     address owner
1004   ) private {
1005     _tokenApprovals[tokenId] = to;
1006     emit Approval(owner, to, tokenId);
1007   }
1008 
1009   uint256 public nextOwnerToExplicitlySet = 0;
1010 
1011   /**
1012    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1013    */
1014   function _setOwnersExplicit(uint256 quantity) internal {
1015     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1016     require(quantity > 0, "quantity must be nonzero");
1017     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1018     if (endIndex > collectionSize - 1) {
1019       endIndex = collectionSize - 1;
1020     }
1021     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1022     require(_exists(endIndex), "not enough minted yet for this cleanup");
1023     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1024       if (_ownerships[i].addr == address(0)) {
1025         TokenOwnership memory ownership = ownershipOf(i);
1026         _ownerships[i] = TokenOwnership(
1027           ownership.addr,
1028           ownership.startTimestamp
1029         );
1030       }
1031     }
1032     nextOwnerToExplicitlySet = endIndex + 1;
1033   }
1034 
1035   /**
1036    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1037    * The call is not executed if the target address is not a contract.
1038    *
1039    * @param from address representing the previous owner of the given token ID
1040    * @param to target address that will receive the tokens
1041    * @param tokenId uint256 ID of the token to be transferred
1042    * @param _data bytes optional data to send along with the call
1043    * @return bool whether the call correctly returned the expected magic value
1044    */
1045   function _checkOnERC721Received(
1046     address from,
1047     address to,
1048     uint256 tokenId,
1049     bytes memory _data
1050   ) private returns (bool) {
1051     if (to.isContract()) {
1052       try
1053         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1054       returns (bytes4 retval) {
1055         return retval == IERC721Receiver(to).onERC721Received.selector;
1056       } catch (bytes memory reason) {
1057         if (reason.length == 0) {
1058           revert("ERC721A: transfer to non ERC721Receiver implementer");
1059         } else {
1060           assembly {
1061             revert(add(32, reason), mload(reason))
1062           }
1063         }
1064       }
1065     } else {
1066       return true;
1067     }
1068   }
1069 
1070   /**
1071    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1072    *
1073    * startTokenId - the first token id to be transferred
1074    * quantity - the amount to be transferred
1075    *
1076    * Calling conditions:
1077    *
1078    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1079    * transferred to `to`.
1080    * - When `from` is zero, `tokenId` will be minted for `to`.
1081    */
1082   function _beforeTokenTransfers(
1083     address from,
1084     address to,
1085     uint256 startTokenId,
1086     uint256 quantity
1087   ) internal virtual {}
1088 
1089   /**
1090    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1091    * minting.
1092    *
1093    * startTokenId - the first token id to be transferred
1094    * quantity - the amount to be transferred
1095    *
1096    * Calling conditions:
1097    *
1098    * - when `from` and `to` are both non-zero.
1099    * - `from` and `to` are never both zero.
1100    */
1101   function _afterTokenTransfers(
1102     address from,
1103     address to,
1104     uint256 startTokenId,
1105     uint256 quantity
1106   ) internal virtual {}
1107 }
1108 
1109 
1110 
1111 pragma solidity ^0.8.0;
1112 
1113 /**
1114  * @dev Contract module that helps prevent reentrant calls to a function.
1115  *
1116  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1117  * available, which can be applied to functions to make sure there are no nested
1118  * (reentrant) calls to them.
1119  *
1120  * Note that because there is a single `nonReentrant` guard, functions marked as
1121  * `nonReentrant` may not call one another. This can be worked around by making
1122  * those functions `private`, and then adding `external` `nonReentrant` entry
1123  * points to them.
1124  *
1125  * TIP: If you would like to learn more about reentrancy and alternative ways
1126  * to protect against it, check out our blog post
1127  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1128  */
1129 abstract contract ReentrancyGuard {
1130     // Booleans are more expensive than uint256 or any type that takes up a full
1131     // word because each write operation emits an extra SLOAD to first read the
1132     // slot's contents, replace the bits taken up by the boolean, and then write
1133     // back. This is the compiler's defense against contract upgrades and
1134     // pointer aliasing, and it cannot be disabled.
1135 
1136     // The values being non-zero value makes deployment a bit more expensive,
1137     // but in exchange the refund on every call to nonReentrant will be lower in
1138     // amount. Since refunds are capped to a percentage of the total
1139     // transaction's gas, it is best to keep them low in cases like this one, to
1140     // increase the likelihood of the full refund coming into effect.
1141     uint256 private constant _NOT_ENTERED = 1;
1142     uint256 private constant _ENTERED = 2;
1143 
1144     uint256 private _status;
1145 
1146     constructor() {
1147         _status = _NOT_ENTERED;
1148     }
1149 
1150     /**
1151      * @dev Prevents a contract from calling itself, directly or indirectly.
1152      * Calling a `nonReentrant` function from another `nonReentrant`
1153      * function is not supported. It is possible to prevent this from happening
1154      * by making the `nonReentrant` function external, and make it call a
1155      * `private` function that does the actual work.
1156      */
1157     modifier nonReentrant() {
1158         // On the first call to nonReentrant, _notEntered will be true
1159         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1160 
1161         // Any calls to nonReentrant after this point will fail
1162         _status = _ENTERED;
1163 
1164         _;
1165 
1166         // By storing the original value once again, a refund is triggered (see
1167         // https://eips.ethereum.org/EIPS/eip-2200)
1168         _status = _NOT_ENTERED;
1169     }
1170 }
1171 
1172 
1173 
1174 pragma solidity ^0.8.0;
1175 
1176 
1177 /**
1178  * @dev Contract module which provides a basic access control mechanism, where
1179  * there is an account (an owner) that can be granted exclusive access to
1180  * specific functions.
1181  *
1182  * By default, the owner account will be the one that deploys the contract. This
1183  * can later be changed with {transferOwnership}.
1184  *
1185  * This module is used through inheritance. It will make available the modifier
1186  * `onlyOwner`, which can be applied to your functions to restrict their use to
1187  * the owner.
1188  */
1189 abstract contract Ownable is Context {
1190     address private _owner;
1191 
1192     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1193 
1194     /**
1195      * @dev Initializes the contract setting the deployer as the initial owner.
1196      */
1197     constructor() {
1198         _setOwner(_msgSender());
1199     }
1200 
1201     /**
1202      * @dev Returns the address of the current owner.
1203      */
1204     function owner() public view virtual returns (address) {
1205         return _owner;
1206     }
1207 
1208     /**
1209      * @dev Throws if called by any account other than the owner.
1210      */
1211     modifier onlyOwner() {
1212         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1213         _;
1214     }
1215 
1216     /**
1217      * @dev Leaves the contract without owner. It will not be possible to call
1218      * `onlyOwner` functions anymore. Can only be called by the current owner.
1219      *
1220      * NOTE: Renouncing ownership will leave the contract without an owner,
1221      * thereby removing any functionality that is only available to the owner.
1222      */
1223     function renounceOwnership() public virtual onlyOwner {
1224         _setOwner(address(0));
1225     }
1226 
1227     /**
1228      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1229      * Can only be called by the current owner.
1230      */
1231     function transferOwnership(address newOwner) public virtual onlyOwner {
1232         require(newOwner != address(0), "Ownable: new owner is the zero address");
1233         _setOwner(newOwner);
1234     }
1235 
1236     function _setOwner(address newOwner) private {
1237         address oldOwner = _owner;
1238         _owner = newOwner;
1239         emit OwnershipTransferred(oldOwner, newOwner);
1240     }
1241 }
1242 
1243 
1244 pragma solidity ^0.8.0;
1245 
1246 interface IPWOWStaking {
1247     function deposit(address account, uint256[] calldata tokenIds) external;
1248 }
1249 
1250 contract pixelwomencontract is Ownable, ERC721A, ReentrancyGuard {
1251   uint256 public maxTx;
1252   uint256 public maxPerFreeMint = 1;  
1253   uint256 public immutable amountForDevs;
1254 
1255   uint256 public publicsalePrice =   25000000000000000;    
1256   uint256 public MAX_FREETOKEN = 500;   
1257   bool public IsActive = true;
1258   IPWOWStaking public PWOWStaking;
1259 
1260   constructor(
1261     uint256 maxBatchSize_,
1262     uint256 collectionSize_,
1263     uint256 amountForDevs_
1264   ) ERC721A("Pixel Women", "PixelWomen", maxBatchSize_, collectionSize_) {
1265     maxTx = maxBatchSize_;
1266     amountForDevs = amountForDevs_;
1267   }
1268 
1269   function setPWOWStaking(address _StakingAddress) external onlyOwner {
1270     PWOWStaking = IPWOWStaking(_StakingAddress);
1271   }
1272 
1273   modifier callerIsUser() {
1274     require(tx.origin == msg.sender, "The caller is another contract");
1275     _;
1276   }
1277 
1278   function setpublicsalePrice(uint _price) external onlyOwner {
1279     publicsalePrice = _price;
1280   }        
1281 
1282   function setmaxTx(uint _maxTx) external onlyOwner {
1283     maxTx = _maxTx;
1284   } 
1285 
1286   function setmaxPerFreeMint(uint _maxPerFreeMint) external onlyOwner {
1287     maxPerFreeMint = _maxPerFreeMint;
1288   }   
1289 
1290   function setMaxFreeMint(uint _MAX_FREETOKEN) external onlyOwner {
1291     MAX_FREETOKEN = _MAX_FREETOKEN;
1292   }         
1293 	
1294   function Paused() public onlyOwner {
1295     IsActive = !IsActive;
1296   }
1297 
1298   function freeMint(uint256 quantity) external payable callerIsUser {
1299     require(IsActive, "Sale must be active to mint");
1300     require(quantity > 0 && quantity <= maxPerFreeMint, "Can only mint max token at a time");  
1301     require(totalSupply() + quantity <= MAX_FREETOKEN, "reached max Free Mint");
1302 
1303     uint256[] memory tokenIds = new uint256[](quantity);
1304 
1305     for (uint i = 0; i < quantity; i++) {
1306         tokenIds[i] = totalSupply()+i;
1307     }
1308 
1309     _safeMint(address(PWOWStaking), quantity);
1310     PWOWStaking.deposit(msg.sender, tokenIds);
1311   }
1312 
1313   function publicMint(uint256 quantity, bool _stake)
1314     external
1315     payable
1316     callerIsUser
1317   {
1318     require(IsActive, "Sale must be active to mint");
1319     require(quantity > 0 && quantity <= maxTx, "Can only mint max token at a time");
1320     require(msg.value >= publicsalePrice*quantity, "Need to send more ETH.");
1321     require(totalSupply() + quantity <= collectionSize, "reached max supply");
1322 
1323     if (_stake) {
1324         uint256[] memory tokenIds = new uint256[](quantity);
1325 
1326         for (uint i = 0; i < quantity; i++) {
1327             tokenIds[i] = totalSupply()+i;
1328         }
1329 
1330         _safeMint(address(PWOWStaking), quantity);
1331         PWOWStaking.deposit(msg.sender, tokenIds);
1332     }
1333     else{
1334         _safeMint(msg.sender, quantity);       
1335     }
1336   }
1337 
1338   function MintbyOwner(address _to, uint256 _reserveAmount) public onlyOwner {        
1339     uint supply = totalSupply();
1340     require(_reserveAmount > 0 && (supply+_reserveAmount) <= collectionSize, "Not enough token left");
1341     _safeMint(_to, _reserveAmount);
1342   }
1343 
1344   // // metadata URI
1345   string private _baseTokenURI;
1346 
1347   function _baseURI() internal view virtual override returns (string memory) {
1348     return _baseTokenURI;
1349   }
1350 
1351   function setBaseURI(string calldata baseURI) external onlyOwner {
1352     _baseTokenURI = baseURI;
1353   }
1354 
1355   function withdrawMoney() external onlyOwner nonReentrant {
1356     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1357     require(success, "Transfer failed.");
1358   }
1359 
1360   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1361     _setOwnersExplicit(quantity);
1362   }
1363 
1364   function numberMinted(address owner) public view returns (uint256) {
1365     return _numberMinted(owner);
1366   }
1367 
1368   function getOwnershipData(uint256 tokenId)
1369     external
1370     view
1371     returns (TokenOwnership memory)
1372   {
1373     return ownershipOf(tokenId);
1374   }
1375 
1376  function transferFrom(address from, address to, uint tokenId) public virtual override {
1377     // Hardcode the Manager's approval so that users don't have to waste gas approving
1378     if (_msgSender() != address(PWOWStaking))
1379         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1380     _transfer(from, to, tokenId);
1381  }
1382 
1383  function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1384     uint256 tokenCount = balanceOf(_owner);
1385     if (tokenCount == 0) {
1386         // Return an empty array
1387         return new uint256[](0);
1388     } else {
1389         uint256[] memory result = new uint256[](tokenCount);
1390         uint256 index;
1391         for (index = 0; index < tokenCount; index++) {
1392             result[index] = tokenOfOwnerByIndex(_owner, index);
1393         }
1394         return result;
1395     }
1396  }
1397 }