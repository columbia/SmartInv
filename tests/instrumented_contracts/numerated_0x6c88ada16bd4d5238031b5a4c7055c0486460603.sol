1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 interface IERC165 {
6     function supportsInterface(bytes4 interfaceId) external view returns (bool);
7 }
8 
9 
10 pragma solidity ^0.8.0;
11 
12 abstract contract ERC165 is IERC165 {
13     /**
14      * @dev See {IERC165-supportsInterface}.
15      */
16     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
17         return interfaceId == type(IERC165).interfaceId;
18     }
19 }
20 
21 pragma solidity ^0.8.0;
22 
23 /**
24  * @dev Collection of functions related to the address type
25  */
26 library Address {
27     /**
28      * @dev Returns true if `account` is a contract.
29      *
30      * [IMPORTANT]
31      * ====
32      * It is unsafe to assume that an address for which this function returns
33      * false is an externally-owned account (EOA) and not a contract.
34      *
35      * Among others, `isContract` will return false for the following
36      * types of addresses:
37      *
38      *  - an externally-owned account
39      *  - a contract in construction
40      *  - an address where a contract will be created
41      *  - an address where a contract lived, but was destroyed
42      * ====
43      */
44     function isContract(address account) internal view returns (bool) {
45         // This method relies on extcodesize, which returns 0 for contracts in
46         // construction, since the code is only stored at the end of the
47         // constructor execution.
48 
49         uint256 size;
50         assembly {
51             size := extcodesize(account)
52         }
53         return size > 0;
54     }
55 
56     /**
57      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
58      * `recipient`, forwarding all available gas and reverting on errors.
59      *
60      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
61      * of certain opcodes, possibly making contracts go over the 2300 gas limit
62      * imposed by `transfer`, making them unable to receive funds via
63      * `transfer`. {sendValue} removes this limitation.
64      *
65      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
66      *
67      * IMPORTANT: because control is transferred to `recipient`, care must be
68      * taken to not create reentrancy vulnerabilities. Consider using
69      * {ReentrancyGuard} or the
70      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
71      */
72     function sendValue(address payable recipient, uint256 amount) internal {
73         require(address(this).balance >= amount, "Address: insufficient balance");
74 
75         (bool success, ) = recipient.call{value: amount}("");
76         require(success, "Address: unable to send value, recipient may have reverted");
77     }
78 
79     /**
80      * @dev Performs a Solidity function call using a low level `call`. A
81      * plain `call` is an unsafe replacement for a function call: use this
82      * function instead.
83      *
84      * If `target` reverts with a revert reason, it is bubbled up by this
85      * function (like regular Solidity function calls).
86      *
87      * Returns the raw returned data. To convert to the expected return value,
88      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
89      *
90      * Requirements:
91      *
92      * - `target` must be a contract.
93      * - calling `target` with `data` must not revert.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
98         return functionCall(target, data, "Address: low-level call failed");
99     }
100 
101     /**
102      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
103      * `errorMessage` as a fallback revert reason when `target` reverts.
104      *
105      * _Available since v3.1._
106      */
107     function functionCall(
108         address target,
109         bytes memory data,
110         string memory errorMessage
111     ) internal returns (bytes memory) {
112         return functionCallWithValue(target, data, 0, errorMessage);
113     }
114 
115     /**
116      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
117      * but also transferring `value` wei to `target`.
118      *
119      * Requirements:
120      *
121      * - the calling contract must have an ETH balance of at least `value`.
122      * - the called Solidity function must be `payable`.
123      *
124      * _Available since v3.1._
125      */
126     function functionCallWithValue(
127         address target,
128         bytes memory data,
129         uint256 value
130     ) internal returns (bytes memory) {
131         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
132     }
133 
134     /**
135      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
136      * with `errorMessage` as a fallback revert reason when `target` reverts.
137      *
138      * _Available since v3.1._
139      */
140     function functionCallWithValue(
141         address target,
142         bytes memory data,
143         uint256 value,
144         string memory errorMessage
145     ) internal returns (bytes memory) {
146         require(address(this).balance >= value, "Address: insufficient balance for call");
147         require(isContract(target), "Address: call to non-contract");
148 
149         (bool success, bytes memory returndata) = target.call{value: value}(data);
150         return _verifyCallResult(success, returndata, errorMessage);
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
155      * but performing a static call.
156      *
157      * _Available since v3.3._
158      */
159     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
160         return functionStaticCall(target, data, "Address: low-level static call failed");
161     }
162 
163     /**
164      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
165      * but performing a static call.
166      *
167      * _Available since v3.3._
168      */
169     function functionStaticCall(
170         address target,
171         bytes memory data,
172         string memory errorMessage
173     ) internal view returns (bytes memory) {
174         require(isContract(target), "Address: static call to non-contract");
175 
176         (bool success, bytes memory returndata) = target.staticcall(data);
177         return _verifyCallResult(success, returndata, errorMessage);
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
182      * but performing a delegate call.
183      *
184      * _Available since v3.4._
185      */
186     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
187         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
188     }
189 
190     /**
191      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
192      * but performing a delegate call.
193      *
194      * _Available since v3.4._
195      */
196     function functionDelegateCall(
197         address target,
198         bytes memory data,
199         string memory errorMessage
200     ) internal returns (bytes memory) {
201         require(isContract(target), "Address: delegate call to non-contract");
202 
203         (bool success, bytes memory returndata) = target.delegatecall(data);
204         return _verifyCallResult(success, returndata, errorMessage);
205     }
206 
207     function _verifyCallResult(
208         bool success,
209         bytes memory returndata,
210         string memory errorMessage
211     ) private pure returns (bytes memory) {
212         if (success) {
213             return returndata;
214         } else {
215             // Look for revert reason and bubble it up if present
216             if (returndata.length > 0) {
217                 // The easiest way to bubble the revert reason is using memory via assembly
218 
219                 assembly {
220                     let returndata_size := mload(returndata)
221                     revert(add(32, returndata), returndata_size)
222                 }
223             } else {
224                 revert(errorMessage);
225             }
226         }
227     }
228 }
229 
230 pragma solidity ^0.8.0;
231 
232 /**
233  * @dev Required interface of an ERC721 compliant contract.
234  */
235 interface IERC721 is IERC165 {
236     /**
237      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
238      */
239     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
240 
241     /**
242      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
243      */
244     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
245 
246     /**
247      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
248      */
249     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
250 
251     /**
252      * @dev Returns the number of tokens in ``owner``'s account.
253      */
254     function balanceOf(address owner) external view returns (uint256 balance);
255 
256     /**
257      * @dev Returns the owner of the `tokenId` token.
258      *
259      * Requirements:
260      *
261      * - `tokenId` must exist.
262      */
263     function ownerOf(uint256 tokenId) external view returns (address owner);
264 
265     /**
266      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
267      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
268      *
269      * Requirements:
270      *
271      * - `from` cannot be the zero address.
272      * - `to` cannot be the zero address.
273      * - `tokenId` token must exist and be owned by `from`.
274      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
275      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
276      *
277      * Emits a {Transfer} event.
278      */
279     function safeTransferFrom(
280         address from,
281         address to,
282         uint256 tokenId
283     ) external;
284 
285     /**
286      * @dev Transfers `tokenId` token from `from` to `to`.
287      *
288      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
289      *
290      * Requirements:
291      *
292      * - `from` cannot be the zero address.
293      * - `to` cannot be the zero address.
294      * - `tokenId` token must be owned by `from`.
295      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
296      *
297      * Emits a {Transfer} event.
298      */
299     function transferFrom(
300         address from,
301         address to,
302         uint256 tokenId
303     ) external;
304 
305     /**
306      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
307      * The approval is cleared when the token is transferred.
308      *
309      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
310      *
311      * Requirements:
312      *
313      * - The caller must own the token or be an approved operator.
314      * - `tokenId` must exist.
315      *
316      * Emits an {Approval} event.
317      */
318     function approve(address to, uint256 tokenId) external;
319 
320     /**
321      * @dev Returns the account approved for `tokenId` token.
322      *
323      * Requirements:
324      *
325      * - `tokenId` must exist.
326      */
327     function getApproved(uint256 tokenId) external view returns (address operator);
328 
329     /**
330      * @dev Approve or remove `operator` as an operator for the caller.
331      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
332      *
333      * Requirements:
334      *
335      * - The `operator` cannot be the caller.
336      *
337      * Emits an {ApprovalForAll} event.
338      */
339     function setApprovalForAll(address operator, bool _approved) external;
340 
341     /**
342      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
343      *
344      * See {setApprovalForAll}
345      */
346     function isApprovedForAll(address owner, address operator) external view returns (bool);
347 
348     /**
349      * @dev Safely transfers `tokenId` token from `from` to `to`.
350      *
351      * Requirements:
352      *
353      * - `from` cannot be the zero address.
354      * - `to` cannot be the zero address.
355      * - `tokenId` token must exist and be owned by `from`.
356      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
357      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
358      *
359      * Emits a {Transfer} event.
360      */
361     function safeTransferFrom(
362         address from,
363         address to,
364         uint256 tokenId,
365         bytes calldata data
366     ) external;
367 }
368 
369 pragma solidity ^0.8.0;
370 
371 /**
372  * @title ERC721 token receiver interface
373  * @dev Interface for any contract that wants to support safeTransfers
374  * from ERC721 asset contracts.
375  */
376 interface IERC721Receiver {
377     /**
378      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
379      * by `operator` from `from`, this function is called.
380      *
381      * It must return its Solidity selector to confirm the token transfer.
382      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
383      *
384      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
385      */
386     function onERC721Received(
387         address operator,
388         address from,
389         uint256 tokenId,
390         bytes calldata data
391     ) external returns (bytes4);
392 }
393 
394 pragma solidity ^0.8.0;
395 
396 /*
397  * @dev Provides information about the current execution context, including the
398  * sender of the transaction and its data. While these are generally available
399  * via msg.sender and msg.data, they should not be accessed in such a direct
400  * manner, since when dealing with meta-transactions the account sending and
401  * paying for execution may not be the actual sender (as far as an application
402  * is concerned).
403  *
404  * This contract is only required for intermediate, library-like contracts.
405  */
406 abstract contract Context {
407     function _msgSender() internal view virtual returns (address) {
408         return msg.sender;
409     }
410 
411     function _msgData() internal view virtual returns (bytes calldata) {
412         return msg.data;
413     }
414 }
415 
416 pragma solidity ^0.8.0;
417 
418 /**
419  * @dev String operations.
420  */
421 library Strings {
422     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
423 
424     /**
425      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
426      */
427     function toString(uint256 value) internal pure returns (string memory) {
428         // Inspired by OraclizeAPI's implementation - MIT licence
429         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
430 
431         if (value == 0) {
432             return "0";
433         }
434         uint256 temp = value;
435         uint256 digits;
436         while (temp != 0) {
437             digits++;
438             temp /= 10;
439         }
440         bytes memory buffer = new bytes(digits);
441         while (value != 0) {
442             digits -= 1;
443             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
444             value /= 10;
445         }
446         return string(buffer);
447     }
448 
449     /**
450      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
451      */
452     function toHexString(uint256 value) internal pure returns (string memory) {
453         if (value == 0) {
454             return "0x00";
455         }
456         uint256 temp = value;
457         uint256 length = 0;
458         while (temp != 0) {
459             length++;
460             temp >>= 8;
461         }
462         return toHexString(value, length);
463     }
464 
465     /**
466      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
467      */
468     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
469         bytes memory buffer = new bytes(2 * length + 2);
470         buffer[0] = "0";
471         buffer[1] = "x";
472         for (uint256 i = 2 * length + 1; i > 1; --i) {
473             buffer[i] = _HEX_SYMBOLS[value & 0xf];
474             value >>= 4;
475         }
476         require(value == 0, "Strings: hex length insufficient");
477         return string(buffer);
478     }
479 }
480 
481 pragma solidity ^0.8.0;
482 
483 /**
484  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
485  * @dev See https://eips.ethereum.org/EIPS/eip-721
486  */
487 interface IERC721Enumerable is IERC721 {
488     /**
489      * @dev Returns the total amount of tokens stored by the contract.
490      */
491     function totalSupply() external view returns (uint256);
492 
493     /**
494      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
495      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
496      */
497     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
498 
499     /**
500      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
501      * Use along with {totalSupply} to enumerate all tokens.
502      */
503     function tokenByIndex(uint256 index) external view returns (uint256);
504 }
505 
506 pragma solidity ^0.8.0;
507 
508 /**
509  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
510  * @dev See https://eips.ethereum.org/EIPS/eip-721
511  */
512 interface IERC721Metadata is IERC721 {
513     /**
514      * @dev Returns the token collection name.
515      */
516     function name() external view returns (string memory);
517 
518     /**
519      * @dev Returns the token collection symbol.
520      */
521     function symbol() external view returns (string memory);
522 
523     /**
524      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
525      */
526     function tokenURI(uint256 tokenId) external view returns (string memory);
527 }
528 
529 pragma solidity ^0.8.0;
530 
531 /**
532  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
533  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
534  *
535  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
536  *
537  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
538  *
539  * Does not support burning tokens to address(0).
540  */
541 contract ERC721A is
542   Context,
543   ERC165,
544   IERC721,
545   IERC721Metadata,
546   IERC721Enumerable
547 {
548   using Address for address;
549   using Strings for uint256;
550 
551   struct TokenOwnership {
552     address addr;
553     uint64 startTimestamp;
554   }
555 
556   struct AddressData {
557     uint128 balance;
558     uint128 numberMinted;
559   }
560 
561   uint256 private currentIndex = 0;
562 
563   uint256 internal immutable TotalToken;
564   uint256 internal immutable maxBatchSize;
565 
566   // Token name
567   string private _name;
568 
569   // Token symbol
570   string private _symbol;
571 
572   // Mapping from token ID to ownership details
573   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
574   mapping(uint256 => TokenOwnership) private _ownerships;
575 
576   // Mapping owner address to address data
577   mapping(address => AddressData) private _addressData;
578 
579   // Mapping from token ID to approved address
580   mapping(uint256 => address) private _tokenApprovals;
581 
582   // Mapping from owner to operator approvals
583   mapping(address => mapping(address => bool)) private _operatorApprovals;
584 
585   /**
586    * @dev
587    * `maxBatchSize` refers to how much a minter can mint at a time.
588    * `TotalToken_` refers to how many tokens are in the collection.
589    */
590   constructor(
591     string memory name_,
592     string memory symbol_,
593     uint256 maxBatchSize_,
594     uint256 TotalToken_
595   ) {
596     require(
597       TotalToken_ > 0,
598       "ERC721A: collection must have a nonzero supply"
599     );
600     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
601     _name = name_;
602     _symbol = symbol_;
603     maxBatchSize = maxBatchSize_;
604     TotalToken = TotalToken_;
605   }
606 
607   /**
608    * @dev See {IERC721Enumerable-totalSupply}.
609    */
610   function totalSupply() public view override returns (uint256) {
611     return currentIndex;
612   }
613 
614   /**
615    * @dev See {IERC721Enumerable-tokenByIndex}.
616    */
617   function tokenByIndex(uint256 index) public view override returns (uint256) {
618     require(index < totalSupply(), "ERC721A: global index out of bounds");
619     return index;
620   }
621 
622   /**
623    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
624    * This read function is O(TotalToken). If calling from a separate contract, be sure to test gas first.
625    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
626    */
627   function tokenOfOwnerByIndex(address owner, uint256 index)
628     public
629     view
630     override
631     returns (uint256)
632   {
633     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
634     uint256 numMintedSoFar = totalSupply();
635     uint256 tokenIdsIdx = 0;
636     address currOwnershipAddr = address(0);
637     for (uint256 i = 0; i < numMintedSoFar; i++) {
638       TokenOwnership memory ownership = _ownerships[i];
639       if (ownership.addr != address(0)) {
640         currOwnershipAddr = ownership.addr;
641       }
642       if (currOwnershipAddr == owner) {
643         if (tokenIdsIdx == index) {
644           return i;
645         }
646         tokenIdsIdx++;
647       }
648     }
649     revert("ERC721A: unable to get token of owner by index");
650   }
651 
652   /**
653    * @dev See {IERC165-supportsInterface}.
654    */
655   function supportsInterface(bytes4 interfaceId)
656     public
657     view
658     virtual
659     override(ERC165, IERC165)
660     returns (bool)
661   {
662     return
663       interfaceId == type(IERC721).interfaceId ||
664       interfaceId == type(IERC721Metadata).interfaceId ||
665       interfaceId == type(IERC721Enumerable).interfaceId ||
666       super.supportsInterface(interfaceId);
667   }
668 
669   /**
670    * @dev See {IERC721-balanceOf}.
671    */
672   function balanceOf(address owner) public view override returns (uint256) {
673     require(owner != address(0), "ERC721A: balance query for the zero address");
674     return uint256(_addressData[owner].balance);
675   }
676 
677   function _numberMinted(address owner) internal view returns (uint256) {
678     require(
679       owner != address(0),
680       "ERC721A: number minted query for the zero address"
681     );
682     return uint256(_addressData[owner].numberMinted);
683   }
684 
685   function ownershipOf(uint256 tokenId)
686     internal
687     view
688     returns (TokenOwnership memory)
689   {
690     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
691 
692     uint256 lowestTokenToCheck;
693     if (tokenId >= maxBatchSize) {
694       lowestTokenToCheck = tokenId - maxBatchSize + 1;
695     }
696 
697     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
698       TokenOwnership memory ownership = _ownerships[curr];
699       if (ownership.addr != address(0)) {
700         return ownership;
701       }
702     }
703 
704     revert("ERC721A: unable to determine the owner of token");
705   }
706 
707   /**
708    * @dev See {IERC721-ownerOf}.
709    */
710   function ownerOf(uint256 tokenId) public view override returns (address) {
711     return ownershipOf(tokenId).addr;
712   }
713 
714   /**
715    * @dev See {IERC721Metadata-name}.
716    */
717   function name() public view virtual override returns (string memory) {
718     return _name;
719   }
720 
721   /**
722    * @dev See {IERC721Metadata-symbol}.
723    */
724   function symbol() public view virtual override returns (string memory) {
725     return _symbol;
726   }
727 
728   /**
729    * @dev See {IERC721Metadata-tokenURI}.
730    */
731   function tokenURI(uint256 tokenId)
732     public
733     view
734     virtual
735     override
736     returns (string memory)
737   {
738     require(
739       _exists(tokenId),
740       "ERC721Metadata: URI query for nonexistent token"
741     );
742 
743     string memory baseURI = _baseURI();
744     return
745       bytes(baseURI).length > 0
746         ? string(abi.encodePacked(baseURI, tokenId.toString()))
747         : "";
748   }
749 
750 
751   function _baseURI() internal view virtual returns (string memory) {
752     return "";
753   }
754 
755   /**
756    * @dev See {IERC721-approve}.
757    */
758   function approve(address to, uint256 tokenId) public override {
759     address owner = ERC721A.ownerOf(tokenId);
760     require(to != owner, "ERC721A: approval to current owner");
761 
762     require(
763       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
764       "ERC721A: approve caller is not owner nor approved for all"
765     );
766 
767     _approve(to, tokenId, owner);
768   }
769 
770   /**
771    * @dev See {IERC721-getApproved}.
772    */
773   function getApproved(uint256 tokenId) public view override returns (address) {
774     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
775 
776     return _tokenApprovals[tokenId];
777   }
778 
779   /**
780    * @dev See {IERC721-setApprovalForAll}.
781    */
782   function setApprovalForAll(address operator, bool approved) public override {
783     require(operator != _msgSender(), "ERC721A: approve to caller");
784 
785     _operatorApprovals[_msgSender()][operator] = approved;
786     emit ApprovalForAll(_msgSender(), operator, approved);
787   }
788 
789   /**
790    * @dev See {IERC721-isApprovedForAll}.
791    */
792   function isApprovedForAll(address owner, address operator)
793     public
794     view
795     virtual
796     override
797     returns (bool)
798   {
799     return _operatorApprovals[owner][operator];
800   }
801 
802   /**
803    * @dev See {IERC721-transferFrom}.
804    */
805   function transferFrom(
806     address from,
807     address to,
808     uint256 tokenId
809   ) public virtual override {
810     _transfer(from, to, tokenId);
811   }
812 
813   /**
814    * @dev See {IERC721-safeTransferFrom}.
815    */
816   function safeTransferFrom(
817     address from,
818     address to,
819     uint256 tokenId
820   ) public override {
821     safeTransferFrom(from, to, tokenId, "");
822   }
823 
824   /**
825    * @dev See {IERC721-safeTransferFrom}.
826    */
827   function safeTransferFrom(
828     address from,
829     address to,
830     uint256 tokenId,
831     bytes memory _data
832   ) public virtual override {
833     _transfer(from, to, tokenId);
834     require(
835       _checkOnERC721Received(from, to, tokenId, _data),
836       "ERC721A: transfer to non ERC721Receiver implementer"
837     );
838   }
839 
840   /**
841    * @dev Returns whether `tokenId` exists.
842    *
843    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
844    *
845    * Tokens start existing when they are minted (`_mint`),
846    */
847   function _exists(uint256 tokenId) internal view returns (bool) {
848     return tokenId < currentIndex;
849   }
850 
851   function _safeMint(address to, uint256 quantity) internal {
852     _safeMint(to, quantity, "");
853   }
854 
855   /**
856    * @dev Mints `quantity` tokens and transfers them to `to`.
857    *
858    * Requirements:
859    *
860    * - there must be `quantity` tokens remaining unminted in the total collection.
861    * - `to` cannot be the zero address.
862    * - `quantity` cannot be larger than the max batch size.
863    *
864    * Emits a {Transfer} event.
865    */
866   function _safeMint(
867     address to,
868     uint256 quantity,
869     bytes memory _data
870   ) internal {
871     uint256 startTokenId = currentIndex;
872     require(to != address(0), "ERC721A: mint to the zero address");
873     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
874     require(!_exists(startTokenId), "ERC721A: token already minted");
875     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
876 
877     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
878 
879     AddressData memory addressData = _addressData[to];
880     _addressData[to] = AddressData(
881       addressData.balance + uint128(quantity),
882       addressData.numberMinted + uint128(quantity)
883     );
884     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
885 
886     uint256 updatedIndex = startTokenId;
887 
888     for (uint256 i = 0; i < quantity; i++) {
889       emit Transfer(address(0), to, updatedIndex);
890       require(
891         _checkOnERC721Received(address(0), to, updatedIndex, _data),
892         "ERC721A: transfer to non ERC721Receiver implementer"
893       );
894       updatedIndex++;
895     }
896 
897     currentIndex = updatedIndex;
898     _afterTokenTransfers(address(0), to, startTokenId, quantity);
899   }
900 
901   /**
902    * @dev Transfers `tokenId` from `from` to `to`.
903    *
904    * Requirements:
905    *
906    * - `to` cannot be the zero address.
907    * - `tokenId` token must be owned by `from`.
908    *
909    * Emits a {Transfer} event.
910    */
911   function _transfer(
912     address from,
913     address to,
914     uint256 tokenId
915   ) private {
916     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
917 
918     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
919       getApproved(tokenId) == _msgSender() ||
920       isApprovedForAll(prevOwnership.addr, _msgSender()));
921 
922     require(
923       isApprovedOrOwner,
924       "ERC721A: transfer caller is not owner nor approved"
925     );
926 
927     require(
928       prevOwnership.addr == from,
929       "ERC721A: transfer from incorrect owner"
930     );
931     require(to != address(0), "ERC721A: transfer to the zero address");
932 
933     _beforeTokenTransfers(from, to, tokenId, 1);
934 
935     // Clear approvals from the previous owner
936     _approve(address(0), tokenId, prevOwnership.addr);
937 
938     _addressData[from].balance -= 1;
939     _addressData[to].balance += 1;
940     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
941 
942     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
943     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
944     uint256 nextTokenId = tokenId + 1;
945     if (_ownerships[nextTokenId].addr == address(0)) {
946       if (_exists(nextTokenId)) {
947         _ownerships[nextTokenId] = TokenOwnership(
948           prevOwnership.addr,
949           prevOwnership.startTimestamp
950         );
951       }
952     }
953 
954     emit Transfer(from, to, tokenId);
955     _afterTokenTransfers(from, to, tokenId, 1);
956   }
957 
958   /**
959    * @dev Approve `to` to operate on `tokenId`
960    *
961    * Emits a {Approval} event.
962    */
963   function _approve(
964     address to,
965     uint256 tokenId,
966     address owner
967   ) private {
968     _tokenApprovals[tokenId] = to;
969     emit Approval(owner, to, tokenId);
970   }
971 
972   uint256 public nextOwnerToExplicitlySet = 0;
973 
974   /**
975    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
976    */
977   function _setOwnersExplicit(uint256 quantity) internal {
978     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
979     require(quantity > 0, "quantity must be nonzero");
980     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
981     if (endIndex > TotalToken - 1) {
982       endIndex = TotalToken - 1;
983     }
984     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
985     require(_exists(endIndex), "not enough minted yet for this cleanup");
986     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
987       if (_ownerships[i].addr == address(0)) {
988         TokenOwnership memory ownership = ownershipOf(i);
989         _ownerships[i] = TokenOwnership(
990           ownership.addr,
991           ownership.startTimestamp
992         );
993       }
994     }
995     nextOwnerToExplicitlySet = endIndex + 1;
996   }
997 
998   /**
999    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1000    * The call is not executed if the target address is not a contract.
1001    *
1002    * @param from address representing the previous owner of the given token ID
1003    * @param to target address that will receive the tokens
1004    * @param tokenId uint256 ID of the token to be transferred
1005    * @param _data bytes optional data to send along with the call
1006    * @return bool whether the call correctly returned the expected magic value
1007    */
1008   function _checkOnERC721Received(
1009     address from,
1010     address to,
1011     uint256 tokenId,
1012     bytes memory _data
1013   ) private returns (bool) {
1014     if (to.isContract()) {
1015       try
1016         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1017       returns (bytes4 retval) {
1018         return retval == IERC721Receiver(to).onERC721Received.selector;
1019       } catch (bytes memory reason) {
1020         if (reason.length == 0) {
1021           revert("ERC721A: transfer to non ERC721Receiver implementer");
1022         } else {
1023           assembly {
1024             revert(add(32, reason), mload(reason))
1025           }
1026         }
1027       }
1028     } else {
1029       return true;
1030     }
1031   }
1032 
1033   /**
1034    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1035    *
1036    * startTokenId - the first token id to be transferred
1037    * quantity - the amount to be transferred
1038    *
1039    * Calling conditions:
1040    *
1041    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1042    * transferred to `to`.
1043    * - When `from` is zero, `tokenId` will be minted for `to`.
1044    */
1045   function _beforeTokenTransfers(
1046     address from,
1047     address to,
1048     uint256 startTokenId,
1049     uint256 quantity
1050   ) internal virtual {}
1051 
1052   /**
1053    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1054    * minting.
1055    *
1056    * startTokenId - the first token id to be transferred
1057    * quantity - the amount to be transferred
1058    *
1059    * Calling conditions:
1060    *
1061    * - when `from` and `to` are both non-zero.
1062    * - `from` and `to` are never both zero.
1063    */
1064   function _afterTokenTransfers(
1065     address from,
1066     address to,
1067     uint256 startTokenId,
1068     uint256 quantity
1069   ) internal virtual {}
1070 }
1071 
1072 
1073 
1074 pragma solidity ^0.8.0;
1075 
1076 /**
1077  * @dev Contract module that helps prevent reentrant calls to a function.
1078  *
1079  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1080  * available, which can be applied to functions to make sure there are no nested
1081  * (reentrant) calls to them.
1082  *
1083  * Note that because there is a single `nonReentrant` guard, functions marked as
1084  * `nonReentrant` may not call one another. This can be worked around by making
1085  * those functions `private`, and then adding `external` `nonReentrant` entry
1086  * points to them.
1087  *
1088  * TIP: If you would like to learn more about reentrancy and alternative ways
1089  * to protect against it, check out our blog post
1090  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1091  */
1092 abstract contract ReentrancyGuard {
1093     // Booleans are more expensive than uint256 or any type that takes up a full
1094     // word because each write operation emits an extra SLOAD to first read the
1095     // slot's contents, replace the bits taken up by the boolean, and then write
1096     // back. This is the compiler's defense against contract upgrades and
1097     // pointer aliasing, and it cannot be disabled.
1098 
1099     // The values being non-zero value makes deployment a bit more expensive,
1100     // but in exchange the refund on every call to nonReentrant will be lower in
1101     // amount. Since refunds are capped to a percentage of the total
1102     // transaction's gas, it is best to keep them low in cases like this one, to
1103     // increase the likelihood of the full refund coming into effect.
1104     uint256 private constant _NOT_ENTERED = 1;
1105     uint256 private constant _ENTERED = 2;
1106 
1107     uint256 private _status;
1108 
1109     constructor() {
1110         _status = _NOT_ENTERED;
1111     }
1112 
1113     /**
1114      * @dev Prevents a contract from calling itself, directly or indirectly.
1115      * Calling a `nonReentrant` function from another `nonReentrant`
1116      * function is not supported. It is possible to prevent this from happening
1117      * by making the `nonReentrant` function external, and make it call a
1118      * `private` function that does the actual work.
1119      */
1120     modifier nonReentrant() {
1121         // On the first call to nonReentrant, _notEntered will be true
1122         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1123 
1124         // Any calls to nonReentrant after this point will fail
1125         _status = _ENTERED;
1126 
1127         _;
1128 
1129         // By storing the original value once again, a refund is triggered (see
1130         // https://eips.ethereum.org/EIPS/eip-2200)
1131         _status = _NOT_ENTERED;
1132     }
1133 }
1134 
1135 
1136 
1137 pragma solidity ^0.8.0;
1138 
1139 
1140 /**
1141  * @dev Contract module which provides a basic access control mechanism, where
1142  * there is an account (an owner) that can be granted exclusive access to
1143  * specific functions.
1144  *
1145  * By default, the owner account will be the one that deploys the contract. This
1146  * can later be changed with {transferOwnership}.
1147  *
1148  * This module is used through inheritance. It will make available the modifier
1149  * `onlyOwner`, which can be applied to your functions to restrict their use to
1150  * the owner.
1151  */
1152 abstract contract Ownable is Context {
1153     address private _owner;
1154 
1155     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1156 
1157     /**
1158      * @dev Initializes the contract setting the deployer as the initial owner.
1159      */
1160     constructor() {
1161         _setOwner(_msgSender());
1162     }
1163 
1164     /**
1165      * @dev Returns the address of the current owner.
1166      */
1167     function owner() public view virtual returns (address) {
1168         return _owner;
1169     }
1170 
1171     /**
1172      * @dev Throws if called by any account other than the owner.
1173      */
1174     modifier onlyOwner() {
1175         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1176         _;
1177     }
1178 
1179     /**
1180      * @dev Leaves the contract without owner. It will not be possible to call
1181      * `onlyOwner` functions anymore. Can only be called by the current owner.
1182      *
1183      * NOTE: Renouncing ownership will leave the contract without an owner,
1184      * thereby removing any functionality that is only available to the owner.
1185      */
1186     function renounceOwnership() public virtual onlyOwner {
1187         _setOwner(address(0));
1188     }
1189 
1190     /**
1191      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1192      * Can only be called by the current owner.
1193      */
1194     function transferOwnership(address newOwner) public virtual onlyOwner {
1195         require(newOwner != address(0), "Ownable: new owner is the zero address");
1196         _setOwner(newOwner);
1197     }
1198 
1199     function _setOwner(address newOwner) private {
1200         address oldOwner = _owner;
1201         _owner = newOwner;
1202         emit OwnershipTransferred(oldOwner, newOwner);
1203     }
1204 }
1205 
1206 
1207 pragma solidity ^0.8.0;
1208 
1209 /**
1210  * @dev These functions deal with verification of Merkle Trees proofs.
1211  *
1212  * The proofs can be generated using the JavaScript library
1213  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1214  *
1215  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1216  */
1217 library MerkleProof {
1218     /**
1219      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1220      * defined by `root`. For this, a `proof` must be provided, containing
1221      * sibling hashes on the branch from the leaf to the root of the tree. Each
1222      * pair of leaves and each pair of pre-images are assumed to be sorted.
1223      */
1224     function verify(
1225         bytes32[] memory proof,
1226         bytes32 root,
1227         bytes32 leaf
1228     ) internal pure returns (bool) {
1229         return processProof(proof, leaf) == root;
1230     }
1231 
1232     /**
1233      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1234      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1235      * hash matches the root of the tree. When processing the proof, the pairs
1236      * of leafs & pre-images are assumed to be sorted.
1237      *
1238      * _Available since v4.4._
1239      */
1240     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1241         bytes32 computedHash = leaf;
1242         for (uint256 i = 0; i < proof.length; i++) {
1243             bytes32 proofElement = proof[i];
1244             if (computedHash <= proofElement) {
1245                 // Hash(current computed hash + current element of the proof)
1246                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1247             } else {
1248                 // Hash(current element of the proof + current computed hash)
1249                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1250             }
1251         }
1252         return computedHash;
1253     }
1254 }
1255 
1256 
1257 pragma solidity ^0.8.0;
1258 
1259 
1260 contract BabyTrippinApeClubContract is Ownable, ERC721A, ReentrancyGuard {
1261   bool public     IsSalesStart;
1262   uint256 public  TotalCollectionSize;
1263   uint256 public  Mintprice;  
1264   uint256 public  MaxClaimTokenTotalForFree; 
1265   uint256 public  MaxClaimTokenTotalForFreePerwallet;   
1266   uint public     MaxMintPerTx; 
1267   mapping(address => uint256) public ClaimPerWallet;
1268 
1269  constructor(
1270     uint256 maxBatchSize_,
1271     uint256 TotalToken_
1272   ) ERC721A("Baby Trippin Ape Club", "BabyTrippinApeClub", maxBatchSize_, TotalToken_) {
1273     MaxMintPerTx = maxBatchSize_;
1274     TotalCollectionSize = TotalToken_; 
1275     IsSalesStart = true;  
1276     Mintprice =   6900000000000000;
1277     MaxClaimTokenTotalForFree = 1000;
1278     MaxClaimTokenTotalForFreePerwallet = 2;
1279   }
1280 
1281   
1282   function MintTo(address _to,uint256 mintamount) external onlyOwner {        
1283     require(totalSupply() + mintamount <= TotalCollectionSize, "Can not mint more than 5555");
1284 
1285     _safeMint(_to, mintamount);
1286     }
1287 
1288   function Mint(uint256 mintamount) external payable {
1289     uint256 cost = Mintprice;
1290     bool isFree = (totalSupply() + mintamount < MaxClaimTokenTotalForFree + 1) &&
1291        (ClaimPerWallet[msg.sender] + mintamount <= MaxClaimTokenTotalForFreePerwallet);
1292        
1293     if (isFree) {
1294         cost = 0;
1295     }
1296               
1297     require(IsSalesStart, "Sale is not started");
1298     require(totalSupply() + mintamount <= TotalCollectionSize, "Can not mint more than 5555");    
1299     require(mintamount > 0 && mintamount <= MaxMintPerTx, "Can not mint more than 20 per tx");
1300     require(msg.value >= cost*mintamount, "Not paid enough ETH.");
1301 
1302    if (isFree) {
1303        ClaimPerWallet[msg.sender] += mintamount;
1304     }
1305 
1306     _safeMint(msg.sender, mintamount);
1307   } 
1308 
1309   function setMaxMintPerTx(uint _MaxMintPerTx) external onlyOwner {
1310     MaxMintPerTx = _MaxMintPerTx;
1311   }   
1312 
1313   function setTotalCollectionSize(uint _TotalToken) external onlyOwner {
1314     TotalCollectionSize = _TotalToken;
1315   }
1316 
1317   function setMintprice(uint _Mintprice) external onlyOwner {
1318     Mintprice = _Mintprice;
1319   }        
1320 
1321   function setMaxClaimTokenTotalForFreePerwallet(uint _MaxClaimTokenTotalForFreePerwallet) external onlyOwner {
1322     MaxClaimTokenTotalForFreePerwallet = _MaxClaimTokenTotalForFreePerwallet;
1323   }         
1324 
1325   function setMaxClaimTokenTotalForFree(uint _MaxClaimTokenTotalForFree) external onlyOwner {
1326     MaxClaimTokenTotalForFree = _MaxClaimTokenTotalForFree;
1327   } 
1328 
1329   function SetSalesStart() public onlyOwner {
1330     IsSalesStart = !IsSalesStart;
1331   }
1332 
1333   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1334     _setOwnersExplicit(quantity);
1335   }
1336 
1337   function numberMinted(address owner) public view returns (uint256) {
1338     return _numberMinted(owner);
1339   }
1340   
1341   string private _baseAPIURI;
1342 
1343   function setBaseURI(string calldata baseURI) external onlyOwner {
1344     _baseAPIURI = baseURI;
1345   }
1346 
1347   function _baseURI() internal view virtual override returns (string memory) {
1348     return _baseAPIURI;
1349   }
1350 
1351   function getOwnershipData(uint256 tokenId)
1352     external
1353     view
1354     returns (TokenOwnership memory)
1355   {
1356     return ownershipOf(tokenId);
1357   }
1358 
1359   function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1360     uint256 tokenCount = balanceOf(_owner);
1361     if (tokenCount == 0) {
1362         return new uint256[](0);
1363     } else {
1364         uint256[] memory result = new uint256[](tokenCount);
1365         uint256 index;
1366         for (index = 0; index < tokenCount; index++) {
1367             result[index] = tokenOfOwnerByIndex(_owner, index);
1368         }
1369         return result;
1370     }
1371   } 
1372 
1373   function withdraw() external onlyOwner nonReentrant {
1374     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1375     require(success, "Transfer failed.");
1376   }
1377 
1378  }