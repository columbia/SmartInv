1 /**
2  *Submitted for verification at Etherscan.io on 2022-05-18
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-05-17
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Interface of the ERC165 standard, as defined in the
15  * https://eips.ethereum.org/EIPS/eip-165[EIP].
16  *
17  * Implementers can declare support of contract interfaces, which can then be
18  * queried by others ({ERC165Checker}).
19  *
20  * For an implementation, see {ERC165}.
21  */
22 interface IERC165 {
23     /**
24      * @dev Returns true if this contract implements the interface defined by
25      * `interfaceId`. See the corresponding
26      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
27      * to learn more about how these ids are created.
28      *
29      * This function call must use less than 30 000 gas.
30      */
31     function supportsInterface(bytes4 interfaceId) external view returns (bool);
32 }
33 
34 
35 pragma solidity ^0.8.0;
36 
37 
38 /**
39  * @dev Implementation of the {IERC165} interface.
40  *
41  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
42  * for the additional interface id that will be supported. For example:
43  *
44  * ```solidity
45  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
46  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
47  * }
48  * ```
49  *
50  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
51  */
52 abstract contract ERC165 is IERC165 {
53     /**
54      * @dev See {IERC165-supportsInterface}.
55      */
56     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
57         return interfaceId == type(IERC165).interfaceId;
58     }
59 }
60 
61 
62 pragma solidity ^0.8.0;
63 
64 /**
65  * @dev Collection of functions related to the address type
66  */
67 library Address {
68     /**
69      * @dev Returns true if `account` is a contract.
70      *
71      * [IMPORTANT]
72      * ====
73      * It is unsafe to assume that an address for which this function returns
74      * false is an externally-owned account (EOA) and not a contract.
75      *
76      * Among others, `isContract` will return false for the following
77      * types of addresses:
78      *
79      *  - an externally-owned account
80      *  - a contract in construction
81      *  - an address where a contract will be created
82      *  - an address where a contract lived, but was destroyed
83      * ====
84      */
85     function isContract(address account) internal view returns (bool) {
86         // This method relies on extcodesize, which returns 0 for contracts in
87         // construction, since the code is only stored at the end of the
88         // constructor execution.
89 
90         uint256 size;
91         assembly {
92             size := extcodesize(account)
93         }
94         return size > 0;
95     }
96 
97     /**
98      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
99      * `recipient`, forwarding all available gas and reverting on errors.
100      *
101      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
102      * of certain opcodes, possibly making contracts go over the 2300 gas limit
103      * imposed by `transfer`, making them unable to receive funds via
104      * `transfer`. {sendValue} removes this limitation.
105      *
106      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
107      *
108      * IMPORTANT: because control is transferred to `recipient`, care must be
109      * taken to not create reentrancy vulnerabilities. Consider using
110      * {ReentrancyGuard} or the
111      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
112      */
113     function sendValue(address payable recipient, uint256 amount) internal {
114         require(address(this).balance >= amount, "Address: insufficient balance");
115 
116         (bool success, ) = recipient.call{value: amount}("");
117         require(success, "Address: unable to send value, recipient may have reverted");
118     }
119 
120     /**
121      * @dev Performs a Solidity function call using a low level `call`. A
122      * plain `call` is an unsafe replacement for a function call: use this
123      * function instead.
124      *
125      * If `target` reverts with a revert reason, it is bubbled up by this
126      * function (like regular Solidity function calls).
127      *
128      * Returns the raw returned data. To convert to the expected return value,
129      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
130      *
131      * Requirements:
132      *
133      * - `target` must be a contract.
134      * - calling `target` with `data` must not revert.
135      *
136      * _Available since v3.1._
137      */
138     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
139         return functionCall(target, data, "Address: low-level call failed");
140     }
141 
142     /**
143      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
144      * `errorMessage` as a fallback revert reason when `target` reverts.
145      *
146      * _Available since v3.1._
147      */
148     function functionCall(
149         address target,
150         bytes memory data,
151         string memory errorMessage
152     ) internal returns (bytes memory) {
153         return functionCallWithValue(target, data, 0, errorMessage);
154     }
155 
156     /**
157      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
158      * but also transferring `value` wei to `target`.
159      *
160      * Requirements:
161      *
162      * - the calling contract must have an ETH balance of at least `value`.
163      * - the called Solidity function must be `payable`.
164      *
165      * _Available since v3.1._
166      */
167     function functionCallWithValue(
168         address target,
169         bytes memory data,
170         uint256 value
171     ) internal returns (bytes memory) {
172         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
173     }
174 
175     /**
176      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
177      * with `errorMessage` as a fallback revert reason when `target` reverts.
178      *
179      * _Available since v3.1._
180      */
181     function functionCallWithValue(
182         address target,
183         bytes memory data,
184         uint256 value,
185         string memory errorMessage
186     ) internal returns (bytes memory) {
187         require(address(this).balance >= value, "Address: insufficient balance for call");
188         require(isContract(target), "Address: call to non-contract");
189 
190         (bool success, bytes memory returndata) = target.call{value: value}(data);
191         return _verifyCallResult(success, returndata, errorMessage);
192     }
193 
194     /**
195      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
196      * but performing a static call.
197      *
198      * _Available since v3.3._
199      */
200     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
201         return functionStaticCall(target, data, "Address: low-level static call failed");
202     }
203 
204     /**
205      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
206      * but performing a static call.
207      *
208      * _Available since v3.3._
209      */
210     function functionStaticCall(
211         address target,
212         bytes memory data,
213         string memory errorMessage
214     ) internal view returns (bytes memory) {
215         require(isContract(target), "Address: static call to non-contract");
216 
217         (bool success, bytes memory returndata) = target.staticcall(data);
218         return _verifyCallResult(success, returndata, errorMessage);
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
223      * but performing a delegate call.
224      *
225      * _Available since v3.4._
226      */
227     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
228         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
233      * but performing a delegate call.
234      *
235      * _Available since v3.4._
236      */
237     function functionDelegateCall(
238         address target,
239         bytes memory data,
240         string memory errorMessage
241     ) internal returns (bytes memory) {
242         require(isContract(target), "Address: delegate call to non-contract");
243 
244         (bool success, bytes memory returndata) = target.delegatecall(data);
245         return _verifyCallResult(success, returndata, errorMessage);
246     }
247 
248     function _verifyCallResult(
249         bool success,
250         bytes memory returndata,
251         string memory errorMessage
252     ) private pure returns (bytes memory) {
253         if (success) {
254             return returndata;
255         } else {
256             // Look for revert reason and bubble it up if present
257             if (returndata.length > 0) {
258                 // The easiest way to bubble the revert reason is using memory via assembly
259 
260                 assembly {
261                     let returndata_size := mload(returndata)
262                     revert(add(32, returndata), returndata_size)
263                 }
264             } else {
265                 revert(errorMessage);
266             }
267         }
268     }
269 }
270 
271 
272 
273 
274 
275 
276 
277 
278 pragma solidity ^0.8.0;
279 
280 /**
281  * @title ERC721 token receiver interface
282  * @dev Interface for any contract that wants to support safeTransfers
283  * from ERC721 asset contracts.
284  */
285 interface IERC721Receiver {
286     /**
287      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
288      * by `operator` from `from`, this function is called.
289      *
290      * It must return its Solidity selector to confirm the token transfer.
291      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
292      *
293      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
294      */
295     function onERC721Received(
296         address operator,
297         address from,
298         uint256 tokenId,
299         bytes calldata data
300     ) external returns (bytes4);
301 }
302 
303 
304 
305 
306 pragma solidity ^0.8.0;
307 
308 
309 /**
310  * @dev Required interface of an ERC721 compliant contract.
311  */
312 interface IERC721 is IERC165 {
313     /**
314      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
315      */
316     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
317 
318     /**
319      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
320      */
321     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
322 
323     /**
324      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
325      */
326     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
327 
328     /**
329      * @dev Returns the number of tokens in ``owner``'s account.
330      */
331     function balanceOf(address owner) external view returns (uint256 balance);
332 
333     /**
334      * @dev Returns the owner of the `tokenId` token.
335      *
336      * Requirements:
337      *
338      * - `tokenId` must exist.
339      */
340     function ownerOf(uint256 tokenId) external view returns (address owner);
341 
342     /**
343      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
344      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
345      *
346      * Requirements:
347      *
348      * - `from` cannot be the zero address.
349      * - `to` cannot be the zero address.
350      * - `tokenId` token must exist and be owned by `from`.
351      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
352      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
353      *
354      * Emits a {Transfer} event.
355      */
356     function safeTransferFrom(
357         address from,
358         address to,
359         uint256 tokenId
360     ) external;
361 
362     /**
363      * @dev Transfers `tokenId` token from `from` to `to`.
364      *
365      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
366      *
367      * Requirements:
368      *
369      * - `from` cannot be the zero address.
370      * - `to` cannot be the zero address.
371      * - `tokenId` token must be owned by `from`.
372      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
373      *
374      * Emits a {Transfer} event.
375      */
376     function transferFrom(
377         address from,
378         address to,
379         uint256 tokenId
380     ) external;
381 
382     /**
383      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
384      * The approval is cleared when the token is transferred.
385      *
386      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
387      *
388      * Requirements:
389      *
390      * - The caller must own the token or be an approved operator.
391      * - `tokenId` must exist.
392      *
393      * Emits an {Approval} event.
394      */
395     function approve(address to, uint256 tokenId) external;
396 
397     /**
398      * @dev Returns the account approved for `tokenId` token.
399      *
400      * Requirements:
401      *
402      * - `tokenId` must exist.
403      */
404     function getApproved(uint256 tokenId) external view returns (address operator);
405 
406     /**
407      * @dev Approve or remove `operator` as an operator for the caller.
408      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
409      *
410      * Requirements:
411      *
412      * - The `operator` cannot be the caller.
413      *
414      * Emits an {ApprovalForAll} event.
415      */
416     function setApprovalForAll(address operator, bool _approved) external;
417 
418     /**
419      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
420      *
421      * See {setApprovalForAll}
422      */
423     function isApprovedForAll(address owner, address operator) external view returns (bool);
424 
425     /**
426      * @dev Safely transfers `tokenId` token from `from` to `to`.
427      *
428      * Requirements:
429      *
430      * - `from` cannot be the zero address.
431      * - `to` cannot be the zero address.
432      * - `tokenId` token must exist and be owned by `from`.
433      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
434      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
435      *
436      * Emits a {Transfer} event.
437      */
438     function safeTransferFrom(
439         address from,
440         address to,
441         uint256 tokenId,
442         bytes calldata data
443     ) external;
444 }
445 
446 
447 pragma solidity ^0.8.0;
448 
449 
450 /**
451  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
452  * @dev See https://eips.ethereum.org/EIPS/eip-721
453  */
454 interface IERC721Metadata is IERC721 {
455     /**
456      * @dev Returns the token collection name.
457      */
458     function name() external view returns (string memory);
459 
460     /**
461      * @dev Returns the token collection symbol.
462      */
463     function symbol() external view returns (string memory);
464 
465     /**
466      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
467      */
468     function tokenURI(uint256 tokenId) external view returns (string memory);
469 }
470 
471 
472 pragma solidity ^0.8.0;
473 
474 
475 /**
476  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
477  * @dev See https://eips.ethereum.org/EIPS/eip-721
478  */
479 interface IERC721Enumerable is IERC721 {
480     /**
481      * @dev Returns the total amount of tokens stored by the contract.
482      */
483     function totalSupply() external view returns (uint256);
484 
485     /**
486      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
487      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
488      */
489     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
490 
491     /**
492      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
493      * Use along with {totalSupply} to enumerate all tokens.
494      */
495     function tokenByIndex(uint256 index) external view returns (uint256);
496 }
497 
498 pragma solidity ^0.8.0;
499 
500 /*
501  * @dev Provides information about the current execution context, including the
502  * sender of the transaction and its data. While these are generally available
503  * via msg.sender and msg.data, they should not be accessed in such a direct
504  * manner, since when dealing with meta-transactions the account sending and
505  * paying for execution may not be the actual sender (as far as an application
506  * is concerned).
507  *
508  * This contract is only required for intermediate, library-like contracts.
509  */
510 abstract contract Context {
511     function _msgSender() internal view virtual returns (address) {
512         return msg.sender;
513     }
514 
515     function _msgData() internal view virtual returns (bytes calldata) {
516         return msg.data;
517     }
518 }
519 
520 
521 pragma solidity ^0.8.0;
522 
523 /**
524  * @dev String operations.
525  */
526 library Strings {
527     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
528 
529     /**
530      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
531      */
532     function toString(uint256 value) internal pure returns (string memory) {
533         // Inspired by OraclizeAPI's implementation - MIT licence
534         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
535 
536         if (value == 0) {
537             return "0";
538         }
539         uint256 temp = value;
540         uint256 digits;
541         while (temp != 0) {
542             digits++;
543             temp /= 10;
544         }
545         bytes memory buffer = new bytes(digits);
546         while (value != 0) {
547             digits -= 1;
548             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
549             value /= 10;
550         }
551         return string(buffer);
552     }
553 
554     /**
555      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
556      */
557     function toHexString(uint256 value) internal pure returns (string memory) {
558         if (value == 0) {
559             return "0x00";
560         }
561         uint256 temp = value;
562         uint256 length = 0;
563         while (temp != 0) {
564             length++;
565             temp >>= 8;
566         }
567         return toHexString(value, length);
568     }
569 
570     /**
571      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
572      */
573     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
574         bytes memory buffer = new bytes(2 * length + 2);
575         buffer[0] = "0";
576         buffer[1] = "x";
577         for (uint256 i = 2 * length + 1; i > 1; --i) {
578             buffer[i] = _HEX_SYMBOLS[value & 0xf];
579             value >>= 4;
580         }
581         require(value == 0, "Strings: hex length insufficient");
582         return string(buffer);
583     }
584 }
585 
586 
587 pragma solidity ^0.8.0;
588 
589 
590 /**
591  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
592  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
593  *
594  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
595  *
596  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
597  *
598  * Does not support burning tokens to address(0).
599  */
600 contract ERC721A is
601   Context,
602   ERC165,
603   IERC721,
604   IERC721Metadata,
605   IERC721Enumerable
606 {
607   using Address for address;
608   using Strings for uint256;
609 
610   struct TokenOwnership {
611     address addr;
612     uint64 startTimestamp;
613   }
614 
615   struct AddressData {
616     uint128 balance;
617     uint128 numberMinted;
618   }
619 
620   uint256 private currentIndex = 0;
621 
622   uint256 internal  collectionSize;
623   uint256 internal  collectionSizeFree;
624   uint256 internal  maxBatchSize;
625 
626   // Token name
627   string private _name;
628 
629   // Token symbol
630   string private _symbol;
631 
632   // Mapping from token ID to ownership details
633   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
634   mapping(uint256 => TokenOwnership) private _ownerships;
635 
636   // Mapping owner address to address data
637   mapping(address => AddressData) private _addressData;
638 
639   // Mapping from token ID to approved address
640   mapping(uint256 => address) private _tokenApprovals;
641 
642   // Mapping from owner to operator approvals
643   mapping(address => mapping(address => bool)) private _operatorApprovals;
644 
645   /**
646    * @dev
647    * `maxBatchSize` refers to how much a minter can mint at a time.
648    * `collectionSize_` refers to how many tokens are in the collection.
649    */
650   constructor(
651     string memory name_,
652     string memory symbol_,
653     uint256 maxBatchSize_,
654     uint256 collectionSize_,
655     uint256 collectionSizeFree_
656   ) {
657     require(
658       collectionSize_ > 0,
659       "ERC721A: collection must have a nonzero supply"
660     );
661     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
662     _name = name_;
663     _symbol = symbol_;
664     maxBatchSize = maxBatchSize_;
665     collectionSize = collectionSize_;
666     collectionSizeFree = collectionSizeFree_;
667   }
668 
669   /**
670    * @dev See {IERC721Enumerable-totalSupply}.
671    */
672   function totalSupply() public view override returns (uint256) {
673     return currentIndex;
674   }
675 
676   /**
677    * @dev See {IERC721Enumerable-tokenByIndex}.
678    */
679   function tokenByIndex(uint256 index) public view override returns (uint256) {
680     require(index < totalSupply(), "ERC721A: global index out of bounds");
681     return index;
682   }
683 
684   /**
685    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
686    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
687    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
688    */
689   function tokenOfOwnerByIndex(address owner, uint256 index)
690     public
691     view
692     override
693     returns (uint256)
694   {
695     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
696     uint256 numMintedSoFar = totalSupply();
697     uint256 tokenIdsIdx = 0;
698     address currOwnershipAddr = address(0);
699     for (uint256 i = 0; i < numMintedSoFar; i++) {
700       TokenOwnership memory ownership = _ownerships[i];
701       if (ownership.addr != address(0)) {
702         currOwnershipAddr = ownership.addr;
703       }
704       if (currOwnershipAddr == owner) {
705         if (tokenIdsIdx == index) {
706           return i;
707         }
708         tokenIdsIdx++;
709       }
710     }
711     revert("ERC721A: unable to get token of owner by index");
712   }
713 
714   /**
715    * @dev See {IERC165-supportsInterface}.
716    */
717   function supportsInterface(bytes4 interfaceId)
718     public
719     view
720     virtual
721     override(ERC165, IERC165)
722     returns (bool)
723   {
724     return
725       interfaceId == type(IERC721).interfaceId ||
726       interfaceId == type(IERC721Metadata).interfaceId ||
727       interfaceId == type(IERC721Enumerable).interfaceId ||
728       super.supportsInterface(interfaceId);
729   }
730 
731   /**
732    * @dev See {IERC721-balanceOf}.
733    */
734   function balanceOf(address owner) public view override returns (uint256) {
735     require(owner != address(0), "ERC721A: balance query for the zero address");
736     return uint256(_addressData[owner].balance);
737   }
738 
739   function _numberMinted(address owner) internal view returns (uint256) {
740     require(
741       owner != address(0),
742       "ERC721A: number minted query for the zero address"
743     );
744     return uint256(_addressData[owner].numberMinted);
745   }
746 
747   function ownershipOf(uint256 tokenId)
748     internal
749     view
750     returns (TokenOwnership memory)
751   {
752     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
753 
754     uint256 lowestTokenToCheck;
755     if (tokenId >= maxBatchSize) {
756       lowestTokenToCheck = tokenId - maxBatchSize + 1;
757     }
758 
759     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
760       TokenOwnership memory ownership = _ownerships[curr];
761       if (ownership.addr != address(0)) {
762         return ownership;
763       }
764     }
765 
766     revert("ERC721A: unable to determine the owner of token");
767   }
768 
769   /**
770    * @dev See {IERC721-ownerOf}.
771    */
772   function ownerOf(uint256 tokenId) public view override returns (address) {
773     return ownershipOf(tokenId).addr;
774   }
775 
776   /**
777    * @dev See {IERC721Metadata-name}.
778    */
779   function name() public view virtual override returns (string memory) {
780     return _name;
781   }
782 
783   /**
784    * @dev See {IERC721Metadata-symbol}.
785    */
786   function symbol() public view virtual override returns (string memory) {
787     return _symbol;
788   }
789 
790   /**
791    * @dev See {IERC721Metadata-tokenURI}.
792    */
793   function tokenURI(uint256 tokenId)
794     public
795     view
796     virtual
797     override
798     returns (string memory)
799   {
800     require(
801       _exists(tokenId),
802       "ERC721Metadata: URI query for nonexistent token"
803     );
804 
805     string memory baseURI = _baseURI();
806     return
807       bytes(baseURI).length > 0
808         ? string(abi.encodePacked(baseURI, tokenId.toString()))
809         : "";
810   }
811 
812   /**
813    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
814    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
815    * by default, can be overriden in child contracts.
816    */
817   function _baseURI() internal view virtual returns (string memory) {
818     return "";
819   }
820 
821   /**
822    * @dev See {IERC721-approve}.
823    */
824   function approve(address to, uint256 tokenId) public override {
825     address owner = ERC721A.ownerOf(tokenId);
826     require(to != owner, "ERC721A: approval to current owner");
827 
828     require(
829       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
830       "ERC721A: approve caller is not owner nor approved for all"
831     );
832 
833     _approve(to, tokenId, owner);
834   }
835 
836   /**
837    * @dev See {IERC721-getApproved}.
838    */
839   function getApproved(uint256 tokenId) public view override returns (address) {
840     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
841 
842     return _tokenApprovals[tokenId];
843   }
844 
845   /**
846    * @dev See {IERC721-setApprovalForAll}.
847    */
848   function setApprovalForAll(address operator, bool approved) public override {
849     require(operator != _msgSender(), "ERC721A: approve to caller");
850 
851     _operatorApprovals[_msgSender()][operator] = approved;
852     emit ApprovalForAll(_msgSender(), operator, approved);
853   }
854 
855   /**
856    * @dev See {IERC721-isApprovedForAll}.
857    */
858   function isApprovedForAll(address owner, address operator)
859     public
860     view
861     virtual
862     override
863     returns (bool)
864   {
865     return _operatorApprovals[owner][operator];
866   }
867 
868   /**
869    * @dev See {IERC721-transferFrom}.
870    */
871   function transferFrom(
872     address from,
873     address to,
874     uint256 tokenId
875   ) public override {
876     _transfer(from, to, tokenId);
877   }
878 
879   /**
880    * @dev See {IERC721-safeTransferFrom}.
881    */
882   function safeTransferFrom(
883     address from,
884     address to,
885     uint256 tokenId
886   ) public override {
887     safeTransferFrom(from, to, tokenId, "");
888   }
889 
890   /**
891    * @dev See {IERC721-safeTransferFrom}.
892    */
893   function safeTransferFrom(
894     address from,
895     address to,
896     uint256 tokenId,
897     bytes memory _data
898   ) public override {
899     _transfer(from, to, tokenId);
900     require(
901       _checkOnERC721Received(from, to, tokenId, _data),
902       "ERC721A: transfer to non ERC721Receiver implementer"
903     );
904   }
905 
906   /**
907    * @dev Returns whether `tokenId` exists.
908    *
909    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
910    *
911    * Tokens start existing when they are minted (`_mint`),
912    */
913   function _exists(uint256 tokenId) internal view returns (bool) {
914     return tokenId < currentIndex;
915   }
916 
917   function _safeMint(address to, uint256 quantity) internal {
918     _safeMint(to, quantity, "");
919   }
920 
921   /**
922    * @dev Mints `quantity` tokens and transfers them to `to`.
923    *
924    * Requirements:
925    *
926    * - there must be `quantity` tokens remaining unminted in the total collection.
927    * - `to` cannot be the zero address.
928    * - `quantity` cannot be larger than the max batch size.
929    *
930    * Emits a {Transfer} event.
931    */
932   function _safeMint(
933     address to,
934     uint256 quantity,
935     bytes memory _data
936   ) internal {
937     uint256 startTokenId = currentIndex;
938     require(to != address(0), "ERC721A: mint to the zero address");
939     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
940     require(!_exists(startTokenId), "ERC721A: token already minted");
941     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
942 
943     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
944 
945     AddressData memory addressData = _addressData[to];
946     _addressData[to] = AddressData(
947       addressData.balance + uint128(quantity),
948       addressData.numberMinted + uint128(quantity)
949     );
950     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
951 
952     uint256 updatedIndex = startTokenId;
953 
954     for (uint256 i = 0; i < quantity; i++) {
955       emit Transfer(address(0), to, updatedIndex);
956       require(
957         _checkOnERC721Received(address(0), to, updatedIndex, _data),
958         "ERC721A: transfer to non ERC721Receiver implementer"
959       );
960       updatedIndex++;
961     }
962 
963     currentIndex = updatedIndex;
964     _afterTokenTransfers(address(0), to, startTokenId, quantity);
965   }
966 
967   /**
968    * @dev Transfers `tokenId` from `from` to `to`.
969    *
970    * Requirements:
971    *
972    * - `to` cannot be the zero address.
973    * - `tokenId` token must be owned by `from`.
974    *
975    * Emits a {Transfer} event.
976    */
977   function _transfer(
978     address from,
979     address to,
980     uint256 tokenId
981   ) private {
982     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
983 
984     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
985       getApproved(tokenId) == _msgSender() ||
986       isApprovedForAll(prevOwnership.addr, _msgSender()));
987 
988     require(
989       isApprovedOrOwner,
990       "ERC721A: transfer caller is not owner nor approved"
991     );
992 
993     require(
994       prevOwnership.addr == from,
995       "ERC721A: transfer from incorrect owner"
996     );
997     require(to != address(0), "ERC721A: transfer to the zero address");
998 
999     _beforeTokenTransfers(from, to, tokenId, 1);
1000 
1001     // Clear approvals from the previous owner
1002     _approve(address(0), tokenId, prevOwnership.addr);
1003 
1004     _addressData[from].balance -= 1;
1005     _addressData[to].balance += 1;
1006     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1007 
1008     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1009     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1010     uint256 nextTokenId = tokenId + 1;
1011     if (_ownerships[nextTokenId].addr == address(0)) {
1012       if (_exists(nextTokenId)) {
1013         _ownerships[nextTokenId] = TokenOwnership(
1014           prevOwnership.addr,
1015           prevOwnership.startTimestamp
1016         );
1017       }
1018     }
1019 
1020     emit Transfer(from, to, tokenId);
1021     _afterTokenTransfers(from, to, tokenId, 1);
1022   }
1023 
1024   /**
1025    * @dev Approve `to` to operate on `tokenId`
1026    *
1027    * Emits a {Approval} event.
1028    */
1029   function _approve(
1030     address to,
1031     uint256 tokenId,
1032     address owner
1033   ) private {
1034     _tokenApprovals[tokenId] = to;
1035     emit Approval(owner, to, tokenId);
1036   }
1037 
1038   uint256 public nextOwnerToExplicitlySet = 0;
1039 
1040   /**
1041    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1042    */
1043   function _setOwnersExplicit(uint256 quantity) internal {
1044     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1045     require(quantity > 0, "quantity must be nonzero");
1046     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1047     if (endIndex > collectionSize - 1) {
1048       endIndex = collectionSize - 1;
1049     }
1050     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1051     require(_exists(endIndex), "not enough minted yet for this cleanup");
1052     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1053       if (_ownerships[i].addr == address(0)) {
1054         TokenOwnership memory ownership = ownershipOf(i);
1055         _ownerships[i] = TokenOwnership(
1056           ownership.addr,
1057           ownership.startTimestamp
1058         );
1059       }
1060     }
1061     nextOwnerToExplicitlySet = endIndex + 1;
1062   }
1063 
1064   /**
1065    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1066    * The call is not executed if the target address is not a contract.
1067    *
1068    * @param from address representing the previous owner of the given token ID
1069    * @param to target address that will receive the tokens
1070    * @param tokenId uint256 ID of the token to be transferred
1071    * @param _data bytes optional data to send along with the call
1072    * @return bool whether the call correctly returned the expected magic value
1073    */
1074   function _checkOnERC721Received(
1075     address from,
1076     address to,
1077     uint256 tokenId,
1078     bytes memory _data
1079   ) private returns (bool) {
1080     if (to.isContract()) {
1081       try
1082         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1083       returns (bytes4 retval) {
1084         return retval == IERC721Receiver(to).onERC721Received.selector;
1085       } catch (bytes memory reason) {
1086         if (reason.length == 0) {
1087           revert("ERC721A: transfer to non ERC721Receiver implementer");
1088         } else {
1089           assembly {
1090             revert(add(32, reason), mload(reason))
1091           }
1092         }
1093       }
1094     } else {
1095       return true;
1096     }
1097   }
1098 
1099   /**
1100    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1101    *
1102    * startTokenId - the first token id to be transferred
1103    * quantity - the amount to be transferred
1104    *
1105    * Calling conditions:
1106    *
1107    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1108    * transferred to `to`.
1109    * - When `from` is zero, `tokenId` will be minted for `to`.
1110    */
1111   function _beforeTokenTransfers(
1112     address from,
1113     address to,
1114     uint256 startTokenId,
1115     uint256 quantity
1116   ) internal virtual {}
1117 
1118   /**
1119    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1120    * minting.
1121    *
1122    * startTokenId - the first token id to be transferred
1123    * quantity - the amount to be transferred
1124    *
1125    * Calling conditions:
1126    *
1127    * - when `from` and `to` are both non-zero.
1128    * - `from` and `to` are never both zero.
1129    */
1130   function _afterTokenTransfers(
1131     address from,
1132     address to,
1133     uint256 startTokenId,
1134     uint256 quantity
1135   ) internal virtual {}
1136 }
1137 
1138 
1139 pragma solidity ^0.8.0;
1140 
1141 /**
1142  * @dev Contract module that helps prevent reentrant calls to a function.
1143  *
1144  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1145  * available, which can be applied to functions to make sure there are no nested
1146  * (reentrant) calls to them.
1147  *
1148  * Note that because there is a single `nonReentrant` guard, functions marked as
1149  * `nonReentrant` may not call one another. This can be worked around by making
1150  * those functions `private`, and then adding `external` `nonReentrant` entry
1151  * points to them.
1152  *
1153  * TIP: If you would like to learn more about reentrancy and alternative ways
1154  * to protect against it, check out our blog post
1155  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1156  */
1157 abstract contract ReentrancyGuard {
1158     // Booleans are more expensive than uint256 or any type that takes up a full
1159     // word because each write operation emits an extra SLOAD to first read the
1160     // slot's contents, replace the bits taken up by the boolean, and then write
1161     // back. This is the compiler's defense against contract upgrades and
1162     // pointer aliasing, and it cannot be disabled.
1163 
1164     // The values being non-zero value makes deployment a bit more expensive,
1165     // but in exchange the refund on every call to nonReentrant will be lower in
1166     // amount. Since refunds are capped to a percentage of the total
1167     // transaction's gas, it is best to keep them low in cases like this one, to
1168     // increase the likelihood of the full refund coming into effect.
1169     uint256 private constant _NOT_ENTERED = 1;
1170     uint256 private constant _ENTERED = 2;
1171 
1172     uint256 private _status;
1173 
1174     constructor() {
1175         _status = _NOT_ENTERED;
1176     }
1177 
1178     /**
1179      * @dev Prevents a contract from calling itself, directly or indirectly.
1180      * Calling a `nonReentrant` function from another `nonReentrant`
1181      * function is not supported. It is possible to prevent this from happening
1182      * by making the `nonReentrant` function external, and make it call a
1183      * `private` function that does the actual work.
1184      */
1185     modifier nonReentrant() {
1186         // On the first call to nonReentrant, _notEntered will be true
1187         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1188 
1189         // Any calls to nonReentrant after this point will fail
1190         _status = _ENTERED;
1191 
1192         _;
1193 
1194         // By storing the original value once again, a refund is triggered (see
1195         // https://eips.ethereum.org/EIPS/eip-2200)
1196         _status = _NOT_ENTERED;
1197     }
1198 }
1199 
1200 
1201 pragma solidity ^0.8.0;
1202 
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
1219     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1220 
1221     /**
1222      * @dev Initializes the contract setting the deployer as the initial owner.
1223      */
1224     constructor() {
1225         _setOwner(_msgSender());
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
1239         require(owner() == _msgSender(), "Ownable: caller is not the owner");
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
1251         _setOwner(address(0));
1252     }
1253 
1254     /**
1255      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1256      * Can only be called by the current owner.
1257      */
1258     function transferOwnership(address newOwner) public virtual onlyOwner {
1259         require(newOwner != address(0), "Ownable: new owner is the zero address");
1260         _setOwner(newOwner);
1261     }
1262 
1263     function _setOwner(address newOwner) private {
1264         address oldOwner = _owner;
1265         _owner = newOwner;
1266         emit OwnershipTransferred(oldOwner, newOwner);
1267     }
1268 }
1269 
1270 
1271 pragma solidity ^0.8.0;
1272 
1273 
1274 contract MoonChimpers is Ownable, ERC721A, ReentrancyGuard {
1275   uint256 public maxPerAddressDuringMint;
1276   uint256 public amountForDevs;
1277   uint256 public price = 0.005 ether;
1278   uint256 public freemintAmount = 3;
1279   uint256 public mintAmount = 10;
1280 
1281   struct SaleConfig {
1282     uint64 publicPrice;
1283   }
1284 
1285   SaleConfig public saleConfig;
1286 
1287   mapping(address => uint256) public allowlist;
1288 
1289   constructor(
1290     uint256 maxBatchSize_,
1291     uint256 collectionSize_,
1292     uint256 collectionSizeFree_,
1293     uint256 amountForDevs_
1294   ) ERC721A("MoonChimpers", "MC", maxBatchSize_, collectionSize_, collectionSizeFree_) {
1295     maxPerAddressDuringMint = 50;
1296     amountForDevs = amountForDevs_;
1297     
1298   }
1299 
1300   modifier callerIsUser() {
1301     require(tx.origin == msg.sender, "The caller is another contract");
1302     _;
1303   }
1304 
1305   function webmint(uint256 quantity)
1306     external
1307     payable
1308     callerIsUser
1309   {
1310       require(quantity <= mintAmount, "Too many minted at once");
1311       require(msg.value >= price * quantity, "Need to send more ETH.");
1312     require(totalSupply() + quantity <= collectionSize, "reached max supply");
1313     _safeMint(msg.sender, quantity);
1314     
1315   }
1316 
1317 
1318   function mint(uint256 quantity) external payable {address _caller = _msgSender();
1319      
1320         require(quantity > 0, "No 0 mints");
1321         require(tx.origin == _caller, "No contracts"); 
1322 
1323         if(collectionSizeFree >= totalSupply())
1324 
1325         {require(freemintAmount >= quantity , "Excess max per free tx");} 
1326 
1327 
1328      else
1329      
1330      {require(mintAmount >= quantity , "Excess max per paid tx");
1331      
1332      require(msg.value >= price * quantity, "Need to send more ETH.");
1333      
1334      }
1335     
1336     _safeMint(msg.sender, quantity);
1337 
1338      }
1339 
1340   function seedAllowlist(address[] memory addresses, uint256[] memory numSlots)
1341     external
1342     onlyOwner
1343   {
1344     require(
1345       addresses.length == numSlots.length,
1346       "addresses does not match numSlots length"
1347     );
1348     for (uint256 i = 0; i < addresses.length; i++) {
1349       allowlist[addresses[i]] = numSlots[i];
1350     }
1351   }
1352 
1353   // For marketing etc.
1354   function Mint(uint256 quantity) external onlyOwner {
1355     
1356      require(totalSupply() + quantity <= amountForDevs, "reached max supply");
1357     _safeMint(msg.sender, quantity);
1358   }
1359     
1360 
1361   // // metadata URI
1362   string private _baseTokenURI;
1363 
1364   function _baseURI() internal view virtual override returns (string memory) {
1365     return _baseTokenURI;
1366   }
1367 
1368   function setBaseURI(string calldata baseURI) external onlyOwner {
1369     _baseTokenURI = baseURI;
1370   }
1371 
1372   function withdrawMoney() external onlyOwner nonReentrant {
1373     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1374     require(success, "Transfer failed.");
1375   }
1376 
1377   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1378     _setOwnersExplicit(quantity);
1379   }
1380 
1381   function numberMinted(address owner) public view returns (uint256) {
1382     return _numberMinted(owner);
1383   }
1384 
1385   function getOwnershipData(uint256 tokenId)
1386     external
1387     view
1388     returns (TokenOwnership memory)
1389   {
1390     return ownershipOf(tokenId);
1391   }
1392 
1393 function setprice(uint256 _newprice) public onlyOwner {
1394 	    price = _newprice;
1395 	}
1396 
1397   function setfreemints(uint256 _newfreemints) public onlyOwner {
1398 	    collectionSizeFree = _newfreemints;
1399 	}
1400 
1401     function setcollectionSize(uint256 _newcollectionSize) public onlyOwner {
1402 	    collectionSize = _newcollectionSize;
1403 	}
1404 
1405     function setamountForDevs(uint256 _newamountForDevs) public onlyOwner {
1406 	    amountForDevs = _newamountForDevs;
1407 	}
1408 
1409     function setfreemintAmount(uint256 _newfreemintAmount) public onlyOwner {
1410 	    freemintAmount = _newfreemintAmount;
1411 	}
1412 
1413     function setmintAmount(uint256 _newmintAmount) public onlyOwner {
1414 	    mintAmount = _newmintAmount;
1415 	}
1416 
1417 
1418 }