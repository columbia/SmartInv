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
27 
28 pragma solidity ^0.8.0;
29 
30 
31 /**
32  * @dev Implementation of the {IERC165} interface.
33  *
34  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
35  * for the additional interface id that will be supported. For example:
36  *
37  * ```solidity
38  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
39  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
40  * }
41  * ```
42  *
43  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
44  */
45 abstract contract ERC165 is IERC165 {
46     /**
47      * @dev See {IERC165-supportsInterface}.
48      */
49     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
50         return interfaceId == type(IERC165).interfaceId;
51     }
52 }
53 
54 
55 
56 pragma solidity ^0.8.0;
57 
58 /**
59  * @dev Collection of functions related to the address type
60  */
61 library Address {
62     /**
63      * @dev Returns true if `account` is a contract.
64      *
65      * [IMPORTANT]
66      * ====
67      * It is unsafe to assume that an address for which this function returns
68      * false is an externally-owned account (EOA) and not a contract.
69      *
70      * Among others, `isContract` will return false for the following
71      * types of addresses:
72      *
73      *  - an externally-owned account
74      *  - a contract in construction
75      *  - an address where a contract will be created
76      *  - an address where a contract lived, but was destroyed
77      * ====
78      */
79     function isContract(address account) internal view returns (bool) {
80         // This method relies on extcodesize, which returns 0 for contracts in
81         // construction, since the code is only stored at the end of the
82         // constructor execution.
83 
84         uint256 size;
85         assembly {
86             size := extcodesize(account)
87         }
88         return size > 0;
89     }
90 
91     /**
92      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
93      * `recipient`, forwarding all available gas and reverting on errors.
94      *
95      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
96      * of certain opcodes, possibly making contracts go over the 2300 gas limit
97      * imposed by `transfer`, making them unable to receive funds via
98      * `transfer`. {sendValue} removes this limitation.
99      *
100      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
101      *
102      * IMPORTANT: because control is transferred to `recipient`, care must be
103      * taken to not create reentrancy vulnerabilities. Consider using
104      * {ReentrancyGuard} or the
105      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
106      */
107     function sendValue(address payable recipient, uint256 amount) internal {
108         require(address(this).balance >= amount, "Address: insufficient balance");
109 
110         (bool success, ) = recipient.call{value: amount}("");
111         require(success, "Address: unable to send value, recipient may have reverted");
112     }
113 
114     /**
115      * @dev Performs a Solidity function call using a low level `call`. A
116      * plain `call` is an unsafe replacement for a function call: use this
117      * function instead.
118      *
119      * If `target` reverts with a revert reason, it is bubbled up by this
120      * function (like regular Solidity function calls).
121      *
122      * Returns the raw returned data. To convert to the expected return value,
123      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
124      *
125      * Requirements:
126      *
127      * - `target` must be a contract.
128      * - calling `target` with `data` must not revert.
129      *
130      * _Available since v3.1._
131      */
132     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
133         return functionCall(target, data, "Address: low-level call failed");
134     }
135 
136     /**
137      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
138      * `errorMessage` as a fallback revert reason when `target` reverts.
139      *
140      * _Available since v3.1._
141      */
142     function functionCall(
143         address target,
144         bytes memory data,
145         string memory errorMessage
146     ) internal returns (bytes memory) {
147         return functionCallWithValue(target, data, 0, errorMessage);
148     }
149 
150     /**
151      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
152      * but also transferring `value` wei to `target`.
153      *
154      * Requirements:
155      *
156      * - the calling contract must have an ETH balance of at least `value`.
157      * - the called Solidity function must be `payable`.
158      *
159      * _Available since v3.1._
160      */
161     function functionCallWithValue(
162         address target,
163         bytes memory data,
164         uint256 value
165     ) internal returns (bytes memory) {
166         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
167     }
168 
169     /**
170      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
171      * with `errorMessage` as a fallback revert reason when `target` reverts.
172      *
173      * _Available since v3.1._
174      */
175     function functionCallWithValue(
176         address target,
177         bytes memory data,
178         uint256 value,
179         string memory errorMessage
180     ) internal returns (bytes memory) {
181         require(address(this).balance >= value, "Address: insufficient balance for call");
182         require(isContract(target), "Address: call to non-contract");
183 
184         (bool success, bytes memory returndata) = target.call{value: value}(data);
185         return _verifyCallResult(success, returndata, errorMessage);
186     }
187 
188     /**
189      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
190      * but performing a static call.
191      *
192      * _Available since v3.3._
193      */
194     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
195         return functionStaticCall(target, data, "Address: low-level static call failed");
196     }
197 
198     /**
199      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
200      * but performing a static call.
201      *
202      * _Available since v3.3._
203      */
204     function functionStaticCall(
205         address target,
206         bytes memory data,
207         string memory errorMessage
208     ) internal view returns (bytes memory) {
209         require(isContract(target), "Address: static call to non-contract");
210 
211         (bool success, bytes memory returndata) = target.staticcall(data);
212         return _verifyCallResult(success, returndata, errorMessage);
213     }
214 
215     /**
216      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
217      * but performing a delegate call.
218      *
219      * _Available since v3.4._
220      */
221     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
222         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
223     }
224 
225     /**
226      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
227      * but performing a delegate call.
228      *
229      * _Available since v3.4._
230      */
231     function functionDelegateCall(
232         address target,
233         bytes memory data,
234         string memory errorMessage
235     ) internal returns (bytes memory) {
236         require(isContract(target), "Address: delegate call to non-contract");
237 
238         (bool success, bytes memory returndata) = target.delegatecall(data);
239         return _verifyCallResult(success, returndata, errorMessage);
240     }
241 
242     function _verifyCallResult(
243         bool success,
244         bytes memory returndata,
245         string memory errorMessage
246     ) private pure returns (bytes memory) {
247         if (success) {
248             return returndata;
249         } else {
250             // Look for revert reason and bubble it up if present
251             if (returndata.length > 0) {
252                 // The easiest way to bubble the revert reason is using memory via assembly
253 
254                 assembly {
255                     let returndata_size := mload(returndata)
256                     revert(add(32, returndata), returndata_size)
257                 }
258             } else {
259                 revert(errorMessage);
260             }
261         }
262     }
263 }
264 
265 
266 
267 pragma solidity ^0.8.0;
268 
269 
270 /**
271  * @dev Required interface of an ERC721 compliant contract.
272  */
273 interface IERC721 is IERC165 {
274     /**
275      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
276      */
277     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
278 
279     /**
280      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
281      */
282     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
283 
284     /**
285      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
286      */
287     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
288 
289     /**
290      * @dev Returns the number of tokens in ``owner``'s account.
291      */
292     function balanceOf(address owner) external view returns (uint256 balance);
293 
294     /**
295      * @dev Returns the owner of the `tokenId` token.
296      *
297      * Requirements:
298      *
299      * - `tokenId` must exist.
300      */
301     function ownerOf(uint256 tokenId) external view returns (address owner);
302 
303     /**
304      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
305      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
306      *
307      * Requirements:
308      *
309      * - `from` cannot be the zero address.
310      * - `to` cannot be the zero address.
311      * - `tokenId` token must exist and be owned by `from`.
312      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
313      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
314      *
315      * Emits a {Transfer} event.
316      */
317     function safeTransferFrom(
318         address from,
319         address to,
320         uint256 tokenId
321     ) external;
322 
323     /**
324      * @dev Transfers `tokenId` token from `from` to `to`.
325      *
326      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
327      *
328      * Requirements:
329      *
330      * - `from` cannot be the zero address.
331      * - `to` cannot be the zero address.
332      * - `tokenId` token must be owned by `from`.
333      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
334      *
335      * Emits a {Transfer} event.
336      */
337     function transferFrom(
338         address from,
339         address to,
340         uint256 tokenId
341     ) external;
342 
343     /**
344      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
345      * The approval is cleared when the token is transferred.
346      *
347      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
348      *
349      * Requirements:
350      *
351      * - The caller must own the token or be an approved operator.
352      * - `tokenId` must exist.
353      *
354      * Emits an {Approval} event.
355      */
356     function approve(address to, uint256 tokenId) external;
357 
358     /**
359      * @dev Returns the account approved for `tokenId` token.
360      *
361      * Requirements:
362      *
363      * - `tokenId` must exist.
364      */
365     function getApproved(uint256 tokenId) external view returns (address operator);
366 
367     /**
368      * @dev Approve or remove `operator` as an operator for the caller.
369      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
370      *
371      * Requirements:
372      *
373      * - The `operator` cannot be the caller.
374      *
375      * Emits an {ApprovalForAll} event.
376      */
377     function setApprovalForAll(address operator, bool _approved) external;
378 
379     /**
380      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
381      *
382      * See {setApprovalForAll}
383      */
384     function isApprovedForAll(address owner, address operator) external view returns (bool);
385 
386     /**
387      * @dev Safely transfers `tokenId` token from `from` to `to`.
388      *
389      * Requirements:
390      *
391      * - `from` cannot be the zero address.
392      * - `to` cannot be the zero address.
393      * - `tokenId` token must exist and be owned by `from`.
394      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
395      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
396      *
397      * Emits a {Transfer} event.
398      */
399     function safeTransferFrom(
400         address from,
401         address to,
402         uint256 tokenId,
403         bytes calldata data
404     ) external;
405 }
406 
407 
408 
409 pragma solidity ^0.8.0;
410 
411 /**
412  * @title ERC721 token receiver interface
413  * @dev Interface for any contract that wants to support safeTransfers
414  * from ERC721 asset contracts.
415  */
416 interface IERC721Receiver {
417     /**
418      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
419      * by `operator` from `from`, this function is called.
420      *
421      * It must return its Solidity selector to confirm the token transfer.
422      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
423      *
424      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
425      */
426     function onERC721Received(
427         address operator,
428         address from,
429         uint256 tokenId,
430         bytes calldata data
431     ) external returns (bytes4);
432 }
433 
434 
435 
436 pragma solidity ^0.8.0;
437 
438 /*
439  * @dev Provides information about the current execution context, including the
440  * sender of the transaction and its data. While these are generally available
441  * via msg.sender and msg.data, they should not be accessed in such a direct
442  * manner, since when dealing with meta-transactions the account sending and
443  * paying for execution may not be the actual sender (as far as an application
444  * is concerned).
445  *
446  * This contract is only required for intermediate, library-like contracts.
447  */
448 abstract contract Context {
449     function _msgSender() internal view virtual returns (address) {
450         return msg.sender;
451     }
452 
453     function _msgData() internal view virtual returns (bytes calldata) {
454         return msg.data;
455     }
456 }
457 
458 
459 pragma solidity ^0.8.0;
460 
461 /**
462  * @dev String operations.
463  */
464 library Strings {
465     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
466 
467     /**
468      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
469      */
470     function toString(uint256 value) internal pure returns (string memory) {
471         // Inspired by OraclizeAPI's implementation - MIT licence
472         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
473 
474         if (value == 0) {
475             return "0";
476         }
477         uint256 temp = value;
478         uint256 digits;
479         while (temp != 0) {
480             digits++;
481             temp /= 10;
482         }
483         bytes memory buffer = new bytes(digits);
484         while (value != 0) {
485             digits -= 1;
486             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
487             value /= 10;
488         }
489         return string(buffer);
490     }
491 
492     /**
493      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
494      */
495     function toHexString(uint256 value) internal pure returns (string memory) {
496         if (value == 0) {
497             return "0x00";
498         }
499         uint256 temp = value;
500         uint256 length = 0;
501         while (temp != 0) {
502             length++;
503             temp >>= 8;
504         }
505         return toHexString(value, length);
506     }
507 
508     /**
509      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
510      */
511     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
512         bytes memory buffer = new bytes(2 * length + 2);
513         buffer[0] = "0";
514         buffer[1] = "x";
515         for (uint256 i = 2 * length + 1; i > 1; --i) {
516             buffer[i] = _HEX_SYMBOLS[value & 0xf];
517             value >>= 4;
518         }
519         require(value == 0, "Strings: hex length insufficient");
520         return string(buffer);
521     }
522 }
523 
524 
525 
526 pragma solidity ^0.8.0;
527 
528 
529 /**
530  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
531  * @dev See https://eips.ethereum.org/EIPS/eip-721
532  */
533 interface IERC721Enumerable is IERC721 {
534     /**
535      * @dev Returns the total amount of tokens stored by the contract.
536      */
537     function totalSupply() external view returns (uint256);
538 
539     /**
540      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
541      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
542      */
543     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
544 
545     /**
546      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
547      * Use along with {totalSupply} to enumerate all tokens.
548      */
549     function tokenByIndex(uint256 index) external view returns (uint256);
550 }
551 
552 
553 
554 pragma solidity ^0.8.0;
555 
556 
557 
558 /**
559  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
560  * @dev See https://eips.ethereum.org/EIPS/eip-721
561  */
562 interface IERC721Metadata is IERC721 {
563     /**
564      * @dev Returns the token collection name.
565      */
566     function name() external view returns (string memory);
567 
568     /**
569      * @dev Returns the token collection symbol.
570      */
571     function symbol() external view returns (string memory);
572 
573     /**
574      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
575      */
576     function tokenURI(uint256 tokenId) external view returns (string memory);
577 }
578 
579 
580 
581 pragma solidity ^0.8.0;
582 
583 /**
584  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
585  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
586  *
587  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
588  *
589  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
590  *
591  * Does not support burning tokens to address(0).
592  */
593 contract ERC721A is
594   Context,
595   ERC165,
596   IERC721,
597   IERC721Metadata,
598   IERC721Enumerable
599 {
600   using Address for address;
601   using Strings for uint256;
602 
603   struct TokenOwnership {
604     address addr;
605     uint64 startTimestamp;
606   }
607 
608   struct AddressData {
609     uint128 balance;
610     uint128 numberMinted;
611   }
612 
613   uint256 private currentIndex = 0;
614 
615   uint256 internal immutable collectionSize;
616   uint256 internal immutable maxBatchSize;
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
646     uint256 collectionSize_
647   ) {
648     require(
649       collectionSize_ > 0,
650       "ERC721A: collection must have a nonzero supply"
651     );
652     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
653     _name = name_;
654     _symbol = symbol_;
655     maxBatchSize = maxBatchSize_;
656     collectionSize = collectionSize_;
657   }
658 
659   /**
660    * @dev See {IERC721Enumerable-totalSupply}.
661    */
662   function totalSupply() public view override returns (uint256) {
663     return currentIndex;
664   }
665 
666   /**
667    * @dev See {IERC721Enumerable-tokenByIndex}.
668    */
669   function tokenByIndex(uint256 index) public view override returns (uint256) {
670     require(index < totalSupply(), "ERC721A: global index out of bounds");
671     return index;
672   }
673 
674   /**
675    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
676    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
677    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
678    */
679   function tokenOfOwnerByIndex(address owner, uint256 index)
680     public
681     view
682     override
683     returns (uint256)
684   {
685     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
686     uint256 numMintedSoFar = totalSupply();
687     uint256 tokenIdsIdx = 0;
688     address currOwnershipAddr = address(0);
689     for (uint256 i = 0; i < numMintedSoFar; i++) {
690       TokenOwnership memory ownership = _ownerships[i];
691       if (ownership.addr != address(0)) {
692         currOwnershipAddr = ownership.addr;
693       }
694       if (currOwnershipAddr == owner) {
695         if (tokenIdsIdx == index) {
696           return i;
697         }
698         tokenIdsIdx++;
699       }
700     }
701     revert("ERC721A: unable to get token of owner by index");
702   }
703 
704   /**
705    * @dev See {IERC165-supportsInterface}.
706    */
707   function supportsInterface(bytes4 interfaceId)
708     public
709     view
710     virtual
711     override(ERC165, IERC165)
712     returns (bool)
713   {
714     return
715       interfaceId == type(IERC721).interfaceId ||
716       interfaceId == type(IERC721Metadata).interfaceId ||
717       interfaceId == type(IERC721Enumerable).interfaceId ||
718       super.supportsInterface(interfaceId);
719   }
720 
721   /**
722    * @dev See {IERC721-balanceOf}.
723    */
724   function balanceOf(address owner) public view override returns (uint256) {
725     require(owner != address(0), "ERC721A: balance query for the zero address");
726     return uint256(_addressData[owner].balance);
727   }
728 
729   function _numberMinted(address owner) internal view returns (uint256) {
730     require(
731       owner != address(0),
732       "ERC721A: number minted query for the zero address"
733     );
734     return uint256(_addressData[owner].numberMinted);
735   }
736 
737   function ownershipOf(uint256 tokenId)
738     internal
739     view
740     returns (TokenOwnership memory)
741   {
742     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
743 
744     uint256 lowestTokenToCheck;
745     if (tokenId >= maxBatchSize) {
746       lowestTokenToCheck = tokenId - maxBatchSize + 1;
747     }
748 
749     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
750       TokenOwnership memory ownership = _ownerships[curr];
751       if (ownership.addr != address(0)) {
752         return ownership;
753       }
754     }
755 
756     revert("ERC721A: unable to determine the owner of token");
757   }
758 
759   /**
760    * @dev See {IERC721-ownerOf}.
761    */
762   function ownerOf(uint256 tokenId) public view override returns (address) {
763     return ownershipOf(tokenId).addr;
764   }
765 
766   /**
767    * @dev See {IERC721Metadata-name}.
768    */
769   function name() public view virtual override returns (string memory) {
770     return _name;
771   }
772 
773   /**
774    * @dev See {IERC721Metadata-symbol}.
775    */
776   function symbol() public view virtual override returns (string memory) {
777     return _symbol;
778   }
779 
780   /**
781    * @dev See {IERC721Metadata-tokenURI}.
782    */
783   function tokenURI(uint256 tokenId)
784     public
785     view
786     virtual
787     override
788     returns (string memory)
789   {
790     require(
791       _exists(tokenId),
792       "ERC721Metadata: URI query for nonexistent token"
793     );
794 
795     string memory baseURI = _baseURI();
796     return
797       bytes(baseURI).length > 0
798         ? string(abi.encodePacked(baseURI, tokenId.toString()))
799         : "";
800   }
801 
802   /**
803    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
804    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
805    * by default, can be overriden in child contracts.
806    */
807   function _baseURI() internal view virtual returns (string memory) {
808     return "";
809   }
810 
811   /**
812    * @dev See {IERC721-approve}.
813    */
814   function approve(address to, uint256 tokenId) public override {
815     address owner = ERC721A.ownerOf(tokenId);
816     require(to != owner, "ERC721A: approval to current owner");
817 
818     require(
819       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
820       "ERC721A: approve caller is not owner nor approved for all"
821     );
822 
823     _approve(to, tokenId, owner);
824   }
825 
826   /**
827    * @dev See {IERC721-getApproved}.
828    */
829   function getApproved(uint256 tokenId) public view override returns (address) {
830     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
831 
832     return _tokenApprovals[tokenId];
833   }
834 
835   /**
836    * @dev See {IERC721-setApprovalForAll}.
837    */
838   function setApprovalForAll(address operator, bool approved) public override {
839     require(operator != _msgSender(), "ERC721A: approve to caller");
840 
841     _operatorApprovals[_msgSender()][operator] = approved;
842     emit ApprovalForAll(_msgSender(), operator, approved);
843   }
844 
845   /**
846    * @dev See {IERC721-isApprovedForAll}.
847    */
848   function isApprovedForAll(address owner, address operator)
849     public
850     view
851     virtual
852     override
853     returns (bool)
854   {
855     return _operatorApprovals[owner][operator];
856   }
857 
858   /**
859    * @dev See {IERC721-transferFrom}.
860    */
861   function transferFrom(
862     address from,
863     address to,
864     uint256 tokenId
865   ) public override {
866     _transfer(from, to, tokenId);
867   }
868 
869   /**
870    * @dev See {IERC721-safeTransferFrom}.
871    */
872   function safeTransferFrom(
873     address from,
874     address to,
875     uint256 tokenId
876   ) public override {
877     safeTransferFrom(from, to, tokenId, "");
878   }
879 
880   /**
881    * @dev See {IERC721-safeTransferFrom}.
882    */
883   function safeTransferFrom(
884     address from,
885     address to,
886     uint256 tokenId,
887     bytes memory _data
888   ) public override {
889     _transfer(from, to, tokenId);
890     require(
891       _checkOnERC721Received(from, to, tokenId, _data),
892       "ERC721A: transfer to non ERC721Receiver implementer"
893     );
894   }
895 
896   /**
897    * @dev Returns whether `tokenId` exists.
898    *
899    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
900    *
901    * Tokens start existing when they are minted (`_mint`),
902    */
903   function _exists(uint256 tokenId) internal view returns (bool) {
904     return tokenId < currentIndex;
905   }
906 
907   function _safeMint(address to, uint256 quantity) internal {
908     _safeMint(to, quantity, "");
909   }
910 
911   /**
912    * @dev Mints `quantity` tokens and transfers them to `to`.
913    *
914    * Requirements:
915    *
916    * - there must be `quantity` tokens remaining unminted in the total collection.
917    * - `to` cannot be the zero address.
918    * - `quantity` cannot be larger than the max batch size.
919    *
920    * Emits a {Transfer} event.
921    */
922   function _safeMint(
923     address to,
924     uint256 quantity,
925     bytes memory _data
926   ) internal {
927     uint256 startTokenId = currentIndex;
928     require(to != address(0), "ERC721A: mint to the zero address");
929     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
930     require(!_exists(startTokenId), "ERC721A: token already minted");
931     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
932 
933     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
934 
935     AddressData memory addressData = _addressData[to];
936     _addressData[to] = AddressData(
937       addressData.balance + uint128(quantity),
938       addressData.numberMinted + uint128(quantity)
939     );
940     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
941 
942     uint256 updatedIndex = startTokenId;
943 
944     for (uint256 i = 0; i < quantity; i++) {
945       emit Transfer(address(0), to, updatedIndex);
946       require(
947         _checkOnERC721Received(address(0), to, updatedIndex, _data),
948         "ERC721A: transfer to non ERC721Receiver implementer"
949       );
950       updatedIndex++;
951     }
952 
953     currentIndex = updatedIndex;
954     _afterTokenTransfers(address(0), to, startTokenId, quantity);
955   }
956 
957   /**
958    * @dev Transfers `tokenId` from `from` to `to`.
959    *
960    * Requirements:
961    *
962    * - `to` cannot be the zero address.
963    * - `tokenId` token must be owned by `from`.
964    *
965    * Emits a {Transfer} event.
966    */
967   function _transfer(
968     address from,
969     address to,
970     uint256 tokenId
971   ) private {
972     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
973 
974     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
975       getApproved(tokenId) == _msgSender() ||
976       isApprovedForAll(prevOwnership.addr, _msgSender()));
977 
978     require(
979       isApprovedOrOwner,
980       "ERC721A: transfer caller is not owner nor approved"
981     );
982 
983     require(
984       prevOwnership.addr == from,
985       "ERC721A: transfer from incorrect owner"
986     );
987     require(to != address(0), "ERC721A: transfer to the zero address");
988 
989     _beforeTokenTransfers(from, to, tokenId, 1);
990 
991     // Clear approvals from the previous owner
992     _approve(address(0), tokenId, prevOwnership.addr);
993 
994     _addressData[from].balance -= 1;
995     _addressData[to].balance += 1;
996     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
997 
998     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
999     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1000     uint256 nextTokenId = tokenId + 1;
1001     if (_ownerships[nextTokenId].addr == address(0)) {
1002       if (_exists(nextTokenId)) {
1003         _ownerships[nextTokenId] = TokenOwnership(
1004           prevOwnership.addr,
1005           prevOwnership.startTimestamp
1006         );
1007       }
1008     }
1009 
1010     emit Transfer(from, to, tokenId);
1011     _afterTokenTransfers(from, to, tokenId, 1);
1012   }
1013 
1014   /**
1015    * @dev Approve `to` to operate on `tokenId`
1016    *
1017    * Emits a {Approval} event.
1018    */
1019   function _approve(
1020     address to,
1021     uint256 tokenId,
1022     address owner
1023   ) private {
1024     _tokenApprovals[tokenId] = to;
1025     emit Approval(owner, to, tokenId);
1026   }
1027 
1028   uint256 public nextOwnerToExplicitlySet = 0;
1029 
1030   /**
1031    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1032    */
1033   function _setOwnersExplicit(uint256 quantity) internal {
1034     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1035     require(quantity > 0, "quantity must be nonzero");
1036     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1037     if (endIndex > collectionSize - 1) {
1038       endIndex = collectionSize - 1;
1039     }
1040     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1041     require(_exists(endIndex), "not enough minted yet for this cleanup");
1042     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1043       if (_ownerships[i].addr == address(0)) {
1044         TokenOwnership memory ownership = ownershipOf(i);
1045         _ownerships[i] = TokenOwnership(
1046           ownership.addr,
1047           ownership.startTimestamp
1048         );
1049       }
1050     }
1051     nextOwnerToExplicitlySet = endIndex + 1;
1052   }
1053 
1054   /**
1055    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1056    * The call is not executed if the target address is not a contract.
1057    *
1058    * @param from address representing the previous owner of the given token ID
1059    * @param to target address that will receive the tokens
1060    * @param tokenId uint256 ID of the token to be transferred
1061    * @param _data bytes optional data to send along with the call
1062    * @return bool whether the call correctly returned the expected magic value
1063    */
1064   function _checkOnERC721Received(
1065     address from,
1066     address to,
1067     uint256 tokenId,
1068     bytes memory _data
1069   ) private returns (bool) {
1070     if (to.isContract()) {
1071       try
1072         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1073       returns (bytes4 retval) {
1074         return retval == IERC721Receiver(to).onERC721Received.selector;
1075       } catch (bytes memory reason) {
1076         if (reason.length == 0) {
1077           revert("ERC721A: transfer to non ERC721Receiver implementer");
1078         } else {
1079           assembly {
1080             revert(add(32, reason), mload(reason))
1081           }
1082         }
1083       }
1084     } else {
1085       return true;
1086     }
1087   }
1088 
1089   /**
1090    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1091    *
1092    * startTokenId - the first token id to be transferred
1093    * quantity - the amount to be transferred
1094    *
1095    * Calling conditions:
1096    *
1097    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1098    * transferred to `to`.
1099    * - When `from` is zero, `tokenId` will be minted for `to`.
1100    */
1101   function _beforeTokenTransfers(
1102     address from,
1103     address to,
1104     uint256 startTokenId,
1105     uint256 quantity
1106   ) internal virtual {}
1107 
1108   /**
1109    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1110    * minting.
1111    *
1112    * startTokenId - the first token id to be transferred
1113    * quantity - the amount to be transferred
1114    *
1115    * Calling conditions:
1116    *
1117    * - when `from` and `to` are both non-zero.
1118    * - `from` and `to` are never both zero.
1119    */
1120   function _afterTokenTransfers(
1121     address from,
1122     address to,
1123     uint256 startTokenId,
1124     uint256 quantity
1125   ) internal virtual {}
1126 }
1127 
1128 
1129 
1130 pragma solidity ^0.8.0;
1131 
1132 /**
1133  * @dev Contract module that helps prevent reentrant calls to a function.
1134  *
1135  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1136  * available, which can be applied to functions to make sure there are no nested
1137  * (reentrant) calls to them.
1138  *
1139  * Note that because there is a single `nonReentrant` guard, functions marked as
1140  * `nonReentrant` may not call one another. This can be worked around by making
1141  * those functions `private`, and then adding `external` `nonReentrant` entry
1142  * points to them.
1143  *
1144  * TIP: If you would like to learn more about reentrancy and alternative ways
1145  * to protect against it, check out our blog post
1146  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1147  */
1148 abstract contract ReentrancyGuard {
1149     // Booleans are more expensive than uint256 or any type that takes up a full
1150     // word because each write operation emits an extra SLOAD to first read the
1151     // slot's contents, replace the bits taken up by the boolean, and then write
1152     // back. This is the compiler's defense against contract upgrades and
1153     // pointer aliasing, and it cannot be disabled.
1154 
1155     // The values being non-zero value makes deployment a bit more expensive,
1156     // but in exchange the refund on every call to nonReentrant will be lower in
1157     // amount. Since refunds are capped to a percentage of the total
1158     // transaction's gas, it is best to keep them low in cases like this one, to
1159     // increase the likelihood of the full refund coming into effect.
1160     uint256 private constant _NOT_ENTERED = 1;
1161     uint256 private constant _ENTERED = 2;
1162 
1163     uint256 private _status;
1164 
1165     constructor() {
1166         _status = _NOT_ENTERED;
1167     }
1168 
1169     /**
1170      * @dev Prevents a contract from calling itself, directly or indirectly.
1171      * Calling a `nonReentrant` function from another `nonReentrant`
1172      * function is not supported. It is possible to prevent this from happening
1173      * by making the `nonReentrant` function external, and make it call a
1174      * `private` function that does the actual work.
1175      */
1176     modifier nonReentrant() {
1177         // On the first call to nonReentrant, _notEntered will be true
1178         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1179 
1180         // Any calls to nonReentrant after this point will fail
1181         _status = _ENTERED;
1182 
1183         _;
1184 
1185         // By storing the original value once again, a refund is triggered (see
1186         // https://eips.ethereum.org/EIPS/eip-2200)
1187         _status = _NOT_ENTERED;
1188     }
1189 }
1190 
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
1266 contract PixelAzuki is Ownable, ERC721A, ReentrancyGuard {
1267   uint256 public immutable maxPerAddressDuringMint;
1268   uint256 public immutable amountForDevs;
1269 
1270   uint256 public  publicsalePrice =   10000000000000000;    
1271   uint256 public  MAX_FREETOKEN = 1000; 
1272   bool public IsActive = true;
1273 
1274   constructor(
1275     uint256 maxBatchSize_,
1276     uint256 collectionSize_,
1277     uint256 amountForDevs_
1278   ) ERC721A("Pixel Azuki", "PixelAzuki", maxBatchSize_, collectionSize_) {
1279     maxPerAddressDuringMint = maxBatchSize_;
1280     amountForDevs = amountForDevs_;
1281   }
1282 
1283   modifier callerIsUser() {
1284     require(tx.origin == msg.sender, "The caller is another contract");
1285     _;
1286   }
1287 
1288   function setpublicsalePrice(uint _price) external onlyOwner {
1289     publicsalePrice = _price;
1290   }        
1291 
1292   function setMaxFreeMint(uint _MAX_FREETOKEN) external onlyOwner {
1293     MAX_FREETOKEN = _MAX_FREETOKEN;
1294   }         
1295 	
1296   function Paused() public onlyOwner {
1297     IsActive = !IsActive;
1298   }
1299 
1300   function freeMint(uint256 quantity) external payable callerIsUser {
1301     require(IsActive, "Sale must be active to mint");
1302     require(quantity > 0 && quantity <= maxPerAddressDuringMint, "Can only mint max token at a time");  
1303     require(totalSupply() + quantity <= MAX_FREETOKEN, "reached max Free Mint");
1304     _safeMint(msg.sender, quantity);
1305   }
1306 
1307   function publicMint(uint256 quantity)
1308     external
1309     payable
1310     callerIsUser
1311   {
1312     require(IsActive, "Sale must be active to mint");
1313     require(quantity > 0 && quantity <= maxPerAddressDuringMint, "Can only mint max token at a time");
1314     require(msg.value >= publicsalePrice*quantity, "Need to send more ETH.");
1315     require(totalSupply() + quantity <= collectionSize, "reached max supply");
1316 
1317     _safeMint(msg.sender, quantity);
1318   }
1319 
1320    // For marketing etc.
1321   function devMint(uint256 quantity) external onlyOwner {
1322     require(
1323       totalSupply() + quantity <= amountForDevs,
1324       "too many already minted before dev mint"
1325     );
1326     require(
1327       quantity % maxBatchSize == 0,
1328       "can only mint a multiple of the maxBatchSize"
1329     );
1330     uint256 numChunks = quantity / maxBatchSize;
1331     for (uint256 i = 0; i < numChunks; i++) {
1332       _safeMint(msg.sender, maxBatchSize);
1333     }
1334   }
1335 
1336   // // metadata URI
1337   string private _baseTokenURI;
1338 
1339   function _baseURI() internal view virtual override returns (string memory) {
1340     return _baseTokenURI;
1341   }
1342 
1343   function setBaseURI(string calldata baseURI) external onlyOwner {
1344     _baseTokenURI = baseURI;
1345   }
1346 
1347   function withdrawMoney() external onlyOwner nonReentrant {
1348     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1349     require(success, "Transfer failed.");
1350   }
1351 
1352   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1353     _setOwnersExplicit(quantity);
1354   }
1355 
1356   function numberMinted(address owner) public view returns (uint256) {
1357     return _numberMinted(owner);
1358   }
1359 
1360   function getOwnershipData(uint256 tokenId)
1361     external
1362     view
1363     returns (TokenOwnership memory)
1364   {
1365     return ownershipOf(tokenId);
1366   }
1367 }